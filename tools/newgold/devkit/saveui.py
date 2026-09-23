#!/usr/bin/env python3
"""The save editor as a page on this machine.

    saveui.py [--library DIR] [--port N] [--no-browser] [--build DIR]

Serves saveui.html on http://127.0.0.1:PORT (8765 by default) and opens it
in the browser. The library is a folder of .sav files; the emulator slots are
the .sav melonDS reads beside each ROM. Both are chosen in the page ("Cartelle
e ROM") and kept in ~/.config/newgold-saveui/settings.json (SAVEUI_CONFIG
elsewhere); until something is chosen the library is ~/hgss-saves and the ROMs
are the ones built under --build (this tree's build/). --library on the command
line wins over the settings for that run. --build also says where the save's
layout is measured (build/heartgold.us). Everything is read and written
through savedit.py.

Nothing is ever deleted. Before any write the file is copied to
LIBRARY/.backups/<its path>/<timestamp>.sav (an emulator slot to
.backups/emulatore/<slot>/), the new bytes go to a temporary file that
savedit.Save must open, and only then does a rename replace the file. The
bin is LIBRARY/.trash/. melonDS writes its .sav back when it closes, so no
emulator slot is written while it runs.

A slot is used only beside a real ROM (a Nintendo DS header whose checksums
hold, and as long as the header says) in a folder the melonDS flatpak can
see -- never /tmp, which its sandbox keeps private. --dry-run-launch, or
SAVEUI_DRY_RUN=1 in the environment, makes "Gioca" say what it would run
instead of running it; the tests use it.
"""

import argparse
import datetime
import functools
import hashlib
import http.server
import json
import os
import re
import shutil
import struct
import subprocess
import sys
import threading
import time
import urllib.parse
import webbrowser
import zlib
from pathlib import Path, PurePosixPath

HERE = Path(__file__).resolve().parent
ROOT = HERE.parents[2]
sys.path.insert(0, str(HERE))
import savedit as sv  # noqa: E402

PAGE = HERE / "saveui.html"
ICONS = ROOT / "files/poketool/icongra/poke_icon"
# The page's names for the games config.mk builds, by their GAME_VERSION.
GAME_LABELS = {"HEARTGOLD": "HeartGold", "SOULSILVER": "SoulSilver"}
NAME = re.compile(r"[\w\- .]+")
APP = "net.kuribo64.melonDS"    # diag/play.py's
LAUNCHED = []                   # what a dry run would have started
# What this editor's code is: a server running older code answers with
# another, and a new start replaces it instead of opening its page.
CODE = hashlib.sha1(b"".join(f.read_bytes() for f in (Path(__file__).resolve(), HERE / "saveui.html", HERE / "savedit.py"))).hexdigest()[:12]
CONFIG = Path(os.environ.get("SAVEUI_CONFIG") or
              Path(os.environ.get("XDG_CONFIG_HOME") or Path.home() / ".config") / "newgold-saveui/settings.json")
LAUNCH_LOG = Path(os.environ.get("XDG_CACHE_HOME") or Path.home() / ".cache") / "newgold-saveui/melonds.log"
# The folders the page may list when choosing a folder or a ROM.
BROWSE_ROOTS = [Path.home(), Path("/run/media"), Path("/media"), Path("/mnt")]


class Refused(Exception):
    """A request the editor turns down; the message is shown as it is, and
    `code` tells the page when it has something to do about it."""

    def __init__(self, message, code=None):
        super().__init__(message)
        self.code = code


INVALID = "non è un salvataggio valido"
FLAG_ROWS = 300      # the flags and variables one search shows
MELON_OPEN = "melonDS è aperto: riscriverebbe lo slot alla chiusura. Chiudilo prima."
STALE = ("il file è cambiato su disco da quando la pagina l'ha letto (melonDS, un'altra scheda o "
         "savedit): l'ho ricaricato, rifai la modifica")


def digest(data):
    return hashlib.sha1(data).hexdigest()


def version(path):
    """What the page read, to tell whether the file has moved on since."""
    return digest(Path(path).read_bytes())


def melonds_running():
    return subprocess.run(["pgrep", "-x", "melonDS"], capture_output=True).returncode == 0


def dry_run():
    return os.environ.get("SAVEUI_DRY_RUN") == "1"


def launch(rom, wait=8.0):
    """play.py's launch -- the flatpak on this ROM, detached -- and then a
    look that melonDS really came up: its window appears within a few
    seconds, or what flatpak said is the error."""
    command = ["flatpak", "run", APP, str(rom)]
    if dry_run():
        LAUNCHED.append(rom)
        print("avvio simulato:", " ".join(command))
        return
    LAUNCH_LOG.parent.mkdir(parents=True, exist_ok=True)
    with open(LAUNCH_LOG, "wb") as log:
        process = subprocess.Popen(command, stdin=subprocess.DEVNULL, stdout=subprocess.DEVNULL,
                                   stderr=log, start_new_session=True)
    deadline = time.monotonic() + wait
    while time.monotonic() < deadline:
        if melonds_running():
            return
        if process.poll() is not None:
            break
        time.sleep(0.2)
    said = LAUNCH_LOG.read_text(errors="replace").strip()[-500:]
    why = f"flatpak è uscito con codice {process.returncode}" if process.poll() is not None else \
        f"nessuna finestra dopo {wait:.0f} secondi"
    raise Refused(f"melonDS non si è aperto ({why}). {said or 'flatpak non ha scritto nulla'} "
                  f"-- il comando era: {' '.join(command)}")


def game_code(rom):
    with open(rom, "rb") as f:
        f.seek(0x0C)
        return f.read(4)


def nds_crc(data):
    """The cartridge header's CRC-16: polynomial 0xA001, reflected, from 0xFFFF."""
    crc = 0xFFFF
    for byte in data:
        crc ^= byte
        for _ in range(8):
            crc = (crc >> 1) ^ 0xA001 if crc & 1 else crc >> 1
    return crc


@functools.cache
def flatpak_folders():
    """The folders the melonDS flatpak may write in, from its own
    permissions (it writes the .sav beside the ROM); None without it."""
    try:
        run = subprocess.run(["flatpak", "info", "--show-permissions", APP], capture_output=True, text=True)
    except OSError:
        return None
    if run.returncode:
        return None
    found = re.search(r"^filesystems=(.*)$", run.stdout, re.M)
    folders = []
    for entry in (found.group(1).split(";") if found else []):
        where, _, mode = entry.partition(":")
        if mode == "ro":
            continue
        if where in ("host", "host-os"):
            folders.append(Path("/"))
        elif where == "home":
            folders.append(Path.home())
        elif where.startswith("~/"):
            folders.append(Path.home() / where[2:])
        elif where.startswith("/"):
            folders.append(Path(where))
    return [f.resolve() for f in folders]


def rom_problem(rom, save):
    """Why melonDS could not play this ROM with this .sav, in Italian; None
    when it can. The header is the cartridge's: the logo's CRC is 0xCF56,
    the header's own CRC is at 0x15E, the used size at 0x80."""
    try:
        real = Path(rom).resolve(strict=True)
    except OSError:
        return f"la ROM {rom} non esiste"
    size = real.stat().st_size
    with open(real, "rb") as f:
        header = f.read(0x200)
    if (len(header) < 0x200 or struct.unpack_from("<H", header, 0x15C)[0] != 0xCF56
            or nds_crc(header[0xC0:0x15C]) != 0xCF56 or nds_crc(header[:0x15E]) != struct.unpack_from("<H", header, 0x15E)[0]):
        return f"{real} non è una ROM del Nintendo DS ({size} byte, senza un'intestazione di cartuccia valida)"
    if size < struct.unpack_from("<I", header, 0x80)[0]:
        return f"{real} è troncata: {size} byte, la sua intestazione ne dichiara {struct.unpack_from('<I', header, 0x80)[0]}"
    if real.parent != Path(save).parent.resolve():
        return f"{rom} porta a {real}: melonDS scriverebbe il salvataggio là, non in {Path(save).parent}"
    if dry_run():
        return None
    folders = flatpak_folders()
    if folders is None:
        return f"non trovo melonDS installato come flatpak ({APP})"
    if real.is_relative_to("/tmp") or real.is_relative_to("/var/tmp") or not any(real.is_relative_to(f) for f in folders):
        return (f"melonDS gira come flatpak e può scrivere solo in {', '.join(map(str, folders))} (mai in /tmp): "
                f"non vedrebbe {real}")
    return None


def sync_folder(folder):
    """A rename in the folder made to last a power cut."""
    fd = os.open(folder, os.O_RDONLY)
    try:
        os.fsync(fd)
    finally:
        os.close(fd)


def stamp():
    return datetime.datetime.now().strftime("%Y%m%d-%H%M%S-%f")


@sv.tree_cache
def built_roms():
    """The ROMs this tree's make builds, as config.mk and the Makefile name
    them: for each GAME_VERSION config.mk knows, its buildname (with the
    language's suffix) as the folder under the build, NEWGOLD_DIAG's folder
    beside it, the ROM poke<buildname>.nds, and the cartridge's game code.
    melonDS's SaveFilePath is empty, so it reads and writes the .sav beside
    the ROM. {slot: (folder, ROM stem, label, GAME_VERSION, game code)}, the
    slot named by the TITLE_NAME's last word."""
    mk, make = sv.source("config.mk").read_text(), sv.source("Makefile").read_text()

    def block(condition):
        found = re.search(rf"ifeq \({re.escape(condition)}\)(.*?)\n(?:else|endif)", mk, re.S)
        return lambda var: re.search(rf"^{var}\s*:=\s*(.+?)\s*$", found.group(1), re.M).group(1)
    default = re.search(r"^GAME_LANGUAGE\s*\?=\s*(\w+)", mk, re.M).group(1)
    language = block(f"$(GAME_LANGUAGE),{default}")
    suffix = language("buildname").replace("$(buildname)", "")
    diag = block("$(NEWGOLD_DIAG),1")("BUILD_DIR").replace("$(BUILD_DIR)", "")
    prefix = re.search(r"^ROM\s*:=\s*\$\(BUILD_DIR\)/(\S*)\$\(buildname\)\.nds\s*$", make, re.M).group(1)
    out = {}
    for version in re.findall(r"ifeq \(\$\(GAME_VERSION\),(\w+)\)", mk):
        game = block(f"$(GAME_VERSION),{version}")
        name, key = game("buildname") + suffix, game("TITLE_NAME").split()[-1].lower()
        label = GAME_LABELS.get(version, version.title())
        out[f"{key}-diag"] = (name + diag, prefix + name, f"{label} diagnostica", version, game("GAME_CODE"))
        out[key] = (name, prefix + name, label, version, game("GAME_CODE"))
    return out


# ---------------------------------------------------------------------------
# Party icons: GetMonIconNaixEx and GetMonIconPaletteEx, the PNG given the
# palette the game gives it.

@sv.tree_cache
def icon_rules():
    """GetMonIconNaixEx and GetMonIconPaletteEx (src/pokemon_icon_idx.c),
    their numbers read out of them: the egg's icon and palette entry and
    the other egg's (Manaphy's), for each species with form icons its first
    form's icon and palette entry and -- sub_02070438's bound -- how many
    forms it has, how far a species' own icon is from its number, and the
    range of the species New Gold adds, after the retail ones' icons."""
    naix = sv.c_function("src/pokemon_icon_idx.c", "u32 GetMonIconNaixEx(")
    pal = sv.c_function("src/pokemon_icon_idx.c", "const u8 GetMonIconPaletteEx(")
    n = sv.species_numbers()
    egg = re.search(r"if \(species == SPECIES_(\w+)\) \{\s*return (\d+);\s*\} else \{\s*return (\d+);", naix)
    egg_pal = re.search(r"if \(species == SPECIES_(\w+)\) \{\s*species = (\d+);\s*\} else \{\s*species = (\d+);", pal)
    icons = dict(re.findall(r"species == SPECIES_(\w+)\) \{\s*return form \+ (\d+) - 1;", naix))
    palettes = dict(re.findall(r"species == SPECIES_(\w+)\) \{\s*species = (\d+) \+ form - 1;", pal))
    bounds = re.findall(r"case SPECIES_(\w+):\s*if \(form >=? (\w+)", sv.c_function("src/pokemon.c", "u8 sub_02070438("))
    added = re.search(r"species >= (\w+) && species <= (\w+)\) \{\s*return species - \w+ \+ (\w+);", naix).groups()
    named = ("MAX_SPECIES", *added, "FIRST_ADDED_PALETTE", *(bound for _, bound in bounds))
    values, _ = sv.compile_c(named, headers=sv.LAYOUT_HEADERS + ("pokemon_icon_idx.h",))
    value = dict(zip(named, values))
    count = {n[s]: value[bound] for s, bound in bounds}
    return {"egg": {n[egg.group(1)]: (int(egg.group(2)), int(egg_pal.group(2))), None: (int(egg.group(3)), int(egg_pal.group(3)))},
            "forms": {n[s]: (int(icons[s]), int(palettes[s]), count[n[s]]) for s in icons},
            "own": int(re.search(r"return species \+ (\d+);", naix).group(1)),
            "retail": value["MAX_SPECIES"], "added": (value[added[0]], value[added[1]]),
            "first_added": (value[added[2]], value["FIRST_ADDED_PALETTE"])}


@sv.tree_cache
def _icon_colours():
    text = sv.source("src/pokemon_icon_idx.c").read_text()
    start = text.index("sPokemonPalNoBySpeciesAndForm[] = {")
    palette_of = [int(n) for n in re.findall(r"^\s*(\d+),", text[start:text.index("\n};", start)], re.M)]
    lines = sv.source(ICONS / "poke_icon_00000000.pal").read_text().split("\n")[3:]
    colours = [tuple(int(v) for v in line.split()) for line in lines if line.strip()]
    return palette_of, colours


def icon(species, form=0, egg=False):
    """GetMonIconNaixEx's icon for the Pokemon, with GetMonIconPaletteEx's palette."""
    palette_of, colours = _icon_colours()
    rules = icon_rules()
    first, last = rules["added"]
    if egg:
        index, pal = rules["egg"].get(species, rules["egg"][None])
    elif species > rules["retail"]:
        if first <= species <= last:
            index, pal = (species - first + start for start in rules["first_added"])
        else:
            index, pal = rules["own"], 0
    elif species in rules["forms"] and 0 < form < rules["forms"][species][2]:
        index, pal = (start + form - 1 for start in rules["forms"][species][:2])
    else:
        index, pal = species + rules["own"], species
    png = sv.source(ICONS / f"poke_icon_{index:08d}.png").read_bytes()     # watched: a new icon moves the tree on
    number = palette_of[pal] if pal < len(palette_of) else 0
    return recolour(png, colours[16 * number:16 * number + 16])


def recolour(png, colours):
    """The PNG with this palette, colour 0 transparent as the game draws it."""
    def chunk(kind, body):
        return struct.pack(">I", len(body)) + kind + body + struct.pack(">I", zlib.crc32(kind + body))
    out, at = bytearray(png[:8]), 8
    while at < len(png):
        size, kind = struct.unpack(">I4s", png[at:at + 8])
        body = png[at + 8:at + 8 + size]
        at += 12 + size
        if kind == b"tRNS":
            continue
        if kind == b"PLTE":
            out += chunk(kind, bytes(c for rgb in colours for c in rgb)) + chunk(b"tRNS", b"\x00")
        else:
            out += chunk(kind, body)
    return bytes(out)


# ---------------------------------------------------------------------------
# The library: files, the emulator slots, backups and the bin.


def default_roms(build):
    """The ROMs this tree builds, the ones that are there, as the settings
    list them."""
    build = Path(build).expanduser().resolve()
    return [{"id": key, "label": label, "rom": str(build / folder / f"{stem}.nds")}
            for key, (folder, stem, label, _, _) in built_roms().items() if (build / folder / f"{stem}.nds").exists()]


def rom_id(rom):
    return "r" + hashlib.sha1(str(rom).encode()).hexdigest()[:10]


def load_settings():
    try:
        settings = json.loads(CONFIG.read_text())
        return settings if isinstance(settings, dict) else {}
    except (OSError, ValueError):
        return {}


def store_settings(settings):
    """Atomically, as the saves are."""
    CONFIG.parent.mkdir(parents=True, exist_ok=True)
    temporary = CONFIG.with_name(f".{CONFIG.name}.{os.getpid()}.tmp")
    temporary.write_text(json.dumps(settings, indent=2, ensure_ascii=False) + "\n")
    os.replace(temporary, CONFIG)


# One lock for the server's whole life: choosing another folder makes a new
# Library, and a request still holding the old one must not write beside a
# request holding the new one.
LOCK = threading.RLock()


class Library:
    def __init__(self, library, build, roms=None):
        self.root = Path(library).expanduser().resolve()
        self.build = Path(build).expanduser().resolve()
        self.layout = self.build / "heartgold.us"
        self.roms = [dict(r) for r in (default_roms(build) if roms is None else roms)]
        self.backups = self.root / ".backups"
        self.trash = self.root / ".trash"
        self.lock = LOCK

    # -- where things are ---------------------------------------------------

    def rom_entry(self, key):
        found = next((r for r in self.roms if r["id"] == key), None)
        if found is None:
            raise Refused(f"non c'è lo slot {key}")
        return found

    def slot_paths(self, key):
        """The ROM and the .sav melonDS keeps beside it, under the same name."""
        rom = Path(self.rom_entry(key)["rom"])
        return rom, rom.with_suffix(".sav")

    def label(self, key):
        return self.rom_entry(key)["label"]

    def slots(self):
        return [r["id"] for r in self.roms]

    def playable(self, key):
        """A HeartGold ROM melonDS can open: the saves here are HeartGold's
        (the game code config.mk gives HEARTGOLD, whatever the language)."""
        rom, sav = self.slot_paths(key)
        code = next(code for _, _, _, version, code in built_roms().values() if version == "HEARTGOLD")
        return rom_problem(rom, sav) is None and game_code(rom).startswith(code.encode())

    def inside(self, rel, base=None, sav=True):
        """A path under the library (or `base`), refused if it climbs out,
        hides, or passes through a link."""
        base = base or self.root
        self.need_root()
        if not isinstance(rel, str) or not rel or "\\" in rel or "\0" in rel:
            raise Refused("percorso non valido")
        parts = PurePosixPath(rel).parts
        if PurePosixPath(rel).is_absolute() or not parts or any(p in (".", "..") or p.startswith(".") for p in parts):
            raise Refused(f"percorso non ammesso: {rel}")
        if sav and not parts[-1].endswith(".sav"):
            raise Refused("un salvataggio finisce in .sav")
        path = base
        for part in parts:
            path = path / part
            if path.is_symlink():
                raise Refused(f"{rel} passa per un collegamento simbolico")
        if not path.resolve().is_relative_to(base.resolve()):
            raise Refused(f"{rel} è fuori dalla libreria")
        return path

    def need_root(self):
        if not self.root.is_dir():
            raise Refused(f"la cartella dei salvataggi {self.root} non c'è: sceglila in Cartelle e ROM", "nolibrary")

    def locate(self, f):
        """(path, backup key, is it an emulator slot) for 'emu:<slot>' or a
        path in the library. A library path that is a slot's .sav -- a
        library folder holding a ROM's folder -- is a slot too, so that it
        is not written while melonDS runs."""
        if isinstance(f, str) and f.startswith("emu:"):
            key = f[4:]
            if key not in self.slots():
                raise Refused(f"non c'è lo slot {key}")
            path = self.slot_paths(key)[1]
            if path.is_symlink():
                raise Refused(f"{path} è un collegamento simbolico")
            return path, f"emulatore/{key}", True
        path = self.inside(f)
        return path, f, path.resolve() in {self.slot_paths(key)[1].resolve() for key in self.slots()}

    def new_name(self, name):
        """A library path for a file that does not exist yet. Backups kept
        under that name belonged to a file that is gone (renamed away before
        its history could follow): they are set aside, never handed to the
        new file, whose Annulla would otherwise swap the old one in."""
        name = (name or "").strip()
        if not name.endswith(".sav"):
            name += ".sav"
        if not all(NAME.fullmatch(part) for part in name.split("/")):
            raise Refused("nel nome solo lettere, cifre, spazi, - _ . e / per le cartelle")
        path = self.inside(name)
        if path.exists():
            raise Refused(f"{name} esiste già", "exists")
        self.move_history(name, f".vecchie/{stamp()}/{name}")
        return path

    def move_history(self, key, to):
        """A file's backups follow it: renamed, into the bin (.cestino) and
        back. The keys starting with a dot are names no library file can
        have."""
        if (self.backups / key).is_dir():
            (self.backups / to).parent.mkdir(parents=True, exist_ok=True)
            os.rename(self.backups / key, self.backups / to)

    def layout_problem(self):
        """Why the save's layout cannot be measured from the build, None when
        it can: without it no file can be read, which is not the files'
        fault (a make clean, a rebuild under way, a wrong --build)."""
        missing = [name for name in ("main.sbin", "main.elf") if not (self.layout / name).is_file()]
        if missing:
            return (f"non trovo la build in {self.layout} (manca {' e '.join(missing)}): senza, i salvataggi non si "
                    f"possono leggere. Se make la sta ricostruendo aspetta che finisca; altrimenti avvia l'editor "
                    f"con --build sulla cartella build giusta.")
        try:
            sv.blocks(self.layout)
        except (Exception, SystemExit) as e:
            return (f"la build in {self.layout} non si legge ({type(e).__name__}: {e}): forse make la sta "
                    f"ricostruendo. Riprova quando ha finito.")
        return None

    def open(self, path):
        problem = self.layout_problem()
        if problem:
            raise Refused(problem, "build")
        size = path.stat().st_size
        if size < sv.FLASH:
            raise Refused(f"{INVALID}: il file ha {size} byte, un salvataggio ne ha {sv.FLASH} (è troncato, o è "
                          f"un'altra cosa)", "invalid")
        try:
            return sv.Save(path, self.layout)
        except SystemExit as e:
            why = str(e).replace(str(path) + ": ", "")
            raise Refused(f"{INVALID}: " + ("nessuna delle due metà della flash contiene un salvataggio integro"
                                            if "neither half" in why else why), "invalid")
        except Exception as e:
            raise Refused(f"{INVALID}: {type(e).__name__}: {e}", "invalid")

    # -- reading ------------------------------------------------------------

    def summary(self, path):
        st = path.stat()
        entry = {"mtime": st.st_mtime, "size": st.st_size}
        try:
            save = self.open(path)
        except Refused as e:
            return {**entry, "valid": None if e.code == "build" else False,
                    "error": str(e).removeprefix(INVALID + ": ")}   # the card says it already
        profile = sv.profile(save)
        where = sv.position(save)["current"]
        place = sv.map_table().get(where["map"], {})
        return {**entry, "valid": True, "name": profile["name"], "johto": profile["johto"],
                "kanto": profile["kanto"], "badges": bin(profile["johto"]).count("1") + bin(profile["kanto"]).count("1"),
                "party": [brief(sv.describe_mon(raw)) for raw in sv.party_raw(save)],
                "location": place.get("name") or place.get("const") or f"mappa {where['map']}",
                "counter": save.counter(), "play_time": profile["play_time"]}

    def library_files(self):
        """Every .sav in the library; hidden folders (the backups, the bin)
        and links left out."""
        for folder, dirs, names in os.walk(self.root):
            dirs[:] = sorted(d for d in dirs if not d.startswith("."))
            for name in sorted(names):
                path = Path(folder) / name
                if name.endswith(".sav") and not name.startswith(".") and path.is_file() and not path.is_symlink():
                    yield path

    def listing(self):
        files = [{"f": path.relative_to(self.root).as_posix(), **self.summary(path)} for path in self.library_files()]
        slots = []
        for key in self.slots():
            rom, path = self.slot_paths(key)
            slots.append({"f": f"emu:{key}", "slot": key, "label": self.label(key), "path": str(path),
                          "rom": str(rom), "problem": rom_problem(rom, path),
                          "exists": path.exists(), **(self.summary(path) if path.exists() else {})})
        trash = []
        if self.trash.is_dir():
            for path in sorted(self.trash.rglob("*.sav"), reverse=True):
                rel = path.relative_to(self.trash).as_posix()
                trash.append({"t": rel, "f": rel.split("/", 1)[-1], "when": rel.split("/", 1)[0]})
        problem = self.layout_problem()
        return {"library": str(self.root), "files": files, "slots": slots, "trash": trash,
                "build": problem, "missing": not self.root.is_dir(),
                "behind": [] if problem else sv.build_behind(self.layout),
                "playable": [s["slot"] for s in slots if not s["problem"] and self.playable(s["slot"])],
                "configured": CONFIG.exists(),
                "melonds": melonds_running()}

    def detail(self, f):
        path, key, is_slot = self.locate(f)
        if not path.exists():
            raise Refused("il file non c'è")
        save = self.open(path)
        return {"f": f, "path": str(path), "slot": is_slot, "mtime": path.stat().st_mtime, "version": version(path),
                "profile": sv.profile(save), "party": [sv.describe_mon(raw) for raw in sv.party_raw(save)],
                "boxes": sv.boxes(save), "bag": sv.bag(save), "dex": sv.dex(save),
                "position": sv.position(save), "info": sv.info(save), "backups": self.history(key)}

    def history(self, key):
        folder = self.backups / key
        if not folder.is_dir():
            return []
        return [{"name": p.name, "mtime": p.stat().st_mtime, "undo": p.stem.count("-") == 2}
                for p in sorted(folder.glob("*.sav"), reverse=True)]

    # -- writing ------------------------------------------------------------

    def write(self, f, data, tag=None, validate=True):
        """Write beside the file, reopen what was written, back up what is
        there, then replace it. An untagged backup -- one "Annulla" may go
        back to -- is named <stamp>.<what replaced it>.sav, so that undo can
        tell whether the file is still what this write left."""
        path, key, is_slot = self.locate(f)
        self.need_root()    # the backups live in the library, a slot's too
        if is_slot and melonds_running():
            raise Refused(MELON_OPEN)
        path.parent.mkdir(parents=True, exist_ok=True)
        temporary = path.with_name(f".{path.name}.{os.getpid()}.{threading.get_ident()}.tmp")
        try:
            with open(temporary, "wb") as out:
                out.write(data)
                out.flush()
                os.fsync(out.fileno())
            if validate:
                self.open(temporary)
            if path.exists():
                # The backup is whole or not there: copied under a hidden
                # name, flushed, then renamed into the history.
                folder = self.backups / key
                folder.mkdir(parents=True, exist_ok=True)
                backup = folder / f"{stamp()}{'-' + tag if tag else '.' + digest(data)[:12]}.sav"
                partial = backup.with_name(f".{backup.name}.tmp")
                shutil.copyfile(path, partial)
                with open(partial, "rb") as copy:
                    os.fsync(copy.fileno())
                os.replace(partial, backup)
                sync_folder(folder)
            os.replace(temporary, path)
            sync_folder(path.parent)
        finally:
            temporary.unlink(missing_ok=True)

    def current(self, f):
        """The version of a file, None when there is no such file."""
        try:
            path, _, _ = self.locate(f)
            return version(path) if path.is_file() else None
        except Refused:
            return None

    def edit(self, f, op, args, seen=None):
        """One change, applied to the file as it is on disk. `seen` is the
        version the page showed: the page sends every field of a form and
        addresses a Pokemon by its slot, so a file that has moved on since --
        a session in melonDS, another tab -- would get the old values back,
        or the edit would land on another Pokemon."""
        handler = getattr(self, f"op_{op}", None) if re.fullmatch(r"[a-z_]+", op or "") else None
        if handler is None:
            raise Refused(f"operazione sconosciuta: {op}")
        with self.lock:
            path, _, _ = self.locate(f)
            if seen is not None and seen != self.current(f):
                raise Refused(STALE, "stale")
            save = self.open(path)
            try:
                handler(save, args)
            except sv.Illegal as e:
                raise Refused(illegal(e))
            except (KeyError, TypeError) as e:
                raise Refused(f"richiesta incompleta: {e}")
            except (ValueError, SystemExit) as e:
                raise Refused(str(e))
            data = save.image()
            changed = data != path.read_bytes()
            if changed:
                self.write(f, data)
            return {**self.detail(f), "changed": changed}

    def readable(self, path):
        try:
            self.open(path)
            return True
        except Refused:
            return False

    def undo(self, f, seen=None):
        """The file as it was before the last write made here -- refused if
        the file is no longer what that write left (a session in melonDS
        since), which going back would throw away; Cronologia still can."""
        with self.lock:
            path, key, _ = self.locate(f)
            if seen is not None and seen != self.current(f):
                raise Refused(STALE, "stale")
            # A backup that does not open (one cut short by a kill before
            # backups were written whole) is passed over, not stopped at.
            stack = [self.backups / key / b["name"] for b in self.history(key) if b["undo"]]
            latest = next((b for b in stack if self.readable(b)), None)
            if latest is None:
                raise Refused("non c'è nulla da annullare")
            left = latest.stem.partition(".")[2]
            if left and not version(path).startswith(left):
                raise Refused("il file è cambiato dopo l'ultima modifica fatta qui (per esempio una partita in "
                              "melonDS): annullarla butterebbe via anche quello. Se è proprio ciò che vuoi, "
                              "scegli il backup in Cronologia.")
            self.write(f, latest.read_bytes(), tag="prima-di-annullare")
            latest.rename(latest.with_name(latest.stem + "-ripristinato.sav"))
        return self.detail(f)

    def restore(self, f, name):
        with self.lock:
            _, key, _ = self.locate(f)
            backup = self.inside(name, base=self.backups / key)
            if not backup.is_file():
                raise Refused(f"non c'è il backup {name}")
            self.write(f, backup.read_bytes())
        return self.detail(f)

    def duplicate(self, f, name):
        with self.lock:
            source, _, _ = self.locate(f)
            target = self.new_name(name)
            self.write(target.relative_to(self.root).as_posix(), source.read_bytes(), validate=False)
            return target.relative_to(self.root).as_posix()

    def rename(self, f, name):
        with self.lock:
            source, key, is_slot = self.locate(f)
            if is_slot:
                raise Refused("uno slot dell'emulatore non si rinomina")
            if not source.is_file():
                raise Refused(f"{f} non c'è più")
            target = self.new_name(name)
            new = target.relative_to(self.root).as_posix()
            target.parent.mkdir(parents=True, exist_ok=True)
            os.rename(source, target)
            self.move_history(key, new)
            return new

    def throw(self, f):
        with self.lock:
            source, _, is_slot = self.locate(f)
            if is_slot:
                raise Refused("uno slot dell'emulatore non va nel cestino")
            if not source.is_file():
                raise Refused(f"{f} non c'è più")
            when = stamp()
            target = self.trash / when / f
            target.parent.mkdir(parents=True, exist_ok=True)
            os.rename(source, target)
            self.move_history(f, f".cestino/{when}/{f}")

    def untrash(self, t, name=None):
        with self.lock:
            source = self.inside(t, base=self.trash)
            if not source.is_file():
                raise Refused(f"non c'è {t} nel cestino")
            target = self.new_name(name or t.split("/", 1)[-1])
            new = target.relative_to(self.root).as_posix()
            target.parent.mkdir(parents=True, exist_ok=True)
            os.rename(source, target)
            self.move_history(f".cestino/{t}", new)
            return new

    def load(self, f, slot, force=False):
        """'Carica nell'emulatore': a valid save copied into a slot, beside
        a ROM melonDS can play. A slot holding a save the library has no
        copy of -- what was played there since it was loaded -- is not
        overwritten unless `force`: it would go only to the slot's backups."""
        with self.lock:
            source, _, _ = self.locate(f)
            target, _, _ = self.locate(f"emu:{slot}")
            problem = rom_problem(self.slot_paths(slot)[0], target)
            if problem:
                raise Refused(f"{self.label(slot)}: {problem}")
            self.open(source)
            data = source.read_bytes()
            if melonds_running():
                raise Refused(MELON_OPEN)
            if not force and target.is_file() and target.read_bytes() != data:
                self.unsaved(slot, target)
            self.write(f"emu:{slot}", data)

    def unsaved(self, slot, path):
        """Refuses when the slot holds a valid save that no library file is."""
        try:
            save = self.open(path)
        except Refused:
            return
        held = digest(path.read_bytes())
        if any(version(path) == held for path in self.library_files()):
            return
        p = sv.profile(save)
        raise Refused(f"lo slot {self.label(slot)} contiene progressi che non sono nella libreria ({p['name']}, "
                      f"salvataggio n. {save.counter()}, tempo {p['play_time'][0]}:{p['play_time'][1]:02d}). "
                      f"Prendili prima, o sovrascrivili: resterebbero solo nei backup dello slot.", "unsaved")

    def take(self, slot, name):
        """'Prendi dall'emulatore': a slot copied into the library."""
        with self.lock:
            source, _, _ = self.locate(f"emu:{slot}")
            if not source.exists():
                raise Refused("lo slot è vuoto")
            if melonds_running():
                raise Refused("melonDS è aperto: il salvataggio fatto nel gioco arriva nello slot quando melonDS si "
                              "chiude, quindi ora prenderesti quello di prima. Chiudi melonDS, poi prendi lo slot.")
            target = self.new_name(name)
            self.write(target.relative_to(self.root).as_posix(), source.read_bytes(), validate=False)
            return target.relative_to(self.root).as_posix()

    def play(self, f, slot, force=False):
        """'Gioca': the file loaded into the slot, then melonDS on its ROM;
        the slot itself (f is emu:<slot>) is played as it is."""
        if not isinstance(slot, str) or slot not in self.slots():
            raise Refused(f"non c'è lo slot {slot}")
        rom, sav = self.slot_paths(slot)
        problem = rom_problem(rom, sav)
        if problem is None and not self.playable(slot):
            raise Refused(f"{self.label(slot)}: si gioca su una ROM di HeartGold, i salvataggi qui sono di HeartGold")
        if melonds_running():
            raise Refused("melonDS è già aperto: chiudilo prima, poi premi di nuovo Gioca")
        if f == f"emu:{slot}":
            if problem:
                raise Refused(f"{self.label(slot)}: {problem}")
            self.open(sav)
        else:
            self.load(f, slot, force)
        launch(rom.resolve())

    # -- the settings: which folder, which ROMs -------------------------------

    def settings(self):
        return {"library": str(self.root), "layout": str(self.layout), "config": str(CONFIG),
                "roms": [{**r, "sav": str(Path(r["rom"]).with_suffix(".sav")),
                          "problem": rom_problem(r["rom"], Path(r["rom"]).with_suffix(".sav"))} for r in self.roms],
                "defaults": default_roms(self.build)}

    # -- the edits the page sends -------------------------------------------

    def op_trainer(self, save, a):
        now, before = sv.profile(save), sv.owner(save)
        if "name" in a and a["name"] != now["name"]:
            # savedit's charcode writes letters and digits and nothing else.
            if not re.fullmatch(rf"[A-Za-z0-9]{{1,{sv.PLAYER_NAME_LENGTH}}}", a["name"]):
                raise Refused(f"il nome: da 1 a {sv.PLAYER_NAME_LENGTH} lettere o cifre (A-Z, a-z, 0-9)")
            sv.set_name(save, a["name"])
        ident = number(a.get("id", now["id"]), 0, 0xFFFF, "ID"), number(a.get("sid", now["sid"]), 0, 0xFFFF, "ID segreto")
        if ident != (now["id"], now["sid"]):
            sv.set_trainer_id(save, ident[0] | ident[1] << 16)
        limits = {"money": (sv.MAX_MONEY, "soldi"), "gender": (1, "genere"), "johto": (255, "medaglie di Johto"),
                  "kanto": (255, "medaglie di Kanto"), "coins": (sv.MAX_COINS, "gettoni")}
        values = {k: number(a[k], 0, high, what) for k, (high, what) in limits.items() if k in a}
        if "play_time" in a:
            if not isinstance(a["play_time"], list) or len(a["play_time"]) != 3:
                raise Refused("il tempo di gioco: ore, minuti e secondi")
            hours, minutes, seconds = a["play_time"]
            values["play_time"] = [number(hours, 0, sv.MAX_PLAY_HOURS, "ore"), number(minutes, 0, 59, "minuti"),
                                   number(seconds, 0, 59, "secondi")]
        sv.set_profile(save, **values)
        if a.get("retag", True) and sv.owner(save) != before:
            retag(save, before, sv.owner(save))

    def op_party_edit(self, save, a):
        slot = number(a["slot"], 0, sv.PARTY_SIZE - 1, "posto")
        raw = sv.party_raw(save)[slot]
        changes = storable(changed(checked_mon(a), sv.describe_mon(raw)))
        if changes:
            sv.set_party_mon(save, slot, sv.edit_mon(raw, **changes))

    def op_party_add(self, save, a):
        if len(sv.party_raw(save)) >= sv.PARTY_SIZE:
            raise Refused(f"la squadra è piena: sei già a {sv.PARTY_SIZE} Pokémon")
        sv.add_party_mon(save, created(save, a, party=True))

    def op_party_remove(self, save, a):
        slot = number(a["slot"], 0, sv.PARTY_SIZE - 1, "posto")
        last_one(save)
        sv.remove_party_mon(save, slot)

    def op_party_swap(self, save, a):
        sv.swap_party_mons(save, number(a["a"], 0, sv.PARTY_SIZE - 1, "posto"), number(a["b"], 0, sv.PARTY_SIZE - 1, "posto"))

    def op_box_edit(self, save, a):
        box, slot = number(a["box"], 0, sv.NUM_BOXES - 1, "box"), number(a["slot"], 0, sv.MONS_PER_BOX - 1, "posto")
        raw = sv.box_raw(save, box, slot)
        changes = storable(changed(checked_mon(a), sv.describe_mon(raw)))
        if changes:
            sv.set_box_mon(save, box, slot, sv.edit_mon(raw, **changes))

    def op_box_add(self, save, a):
        box, slot = number(a["box"], 0, sv.NUM_BOXES - 1, "box"), number(a["slot"], 0, sv.MONS_PER_BOX - 1, "posto")
        if sv.open_mon(sv.box_raw(save, box, slot)) is not None:
            raise Refused(f"box {box + 1}, posto {slot + 1}: è occupato")
        sv.set_box_mon(save, box, slot, created(save, a, party=False))

    def op_box_remove(self, save, a):
        sv.set_box_mon(save, number(a["box"], 0, sv.NUM_BOXES - 1, "box"), number(a["slot"], 0, sv.MONS_PER_BOX - 1, "posto"), sv.EMPTY_BOX_MON)

    def op_deposit(self, save, a):
        box = number(a["box"], 0, sv.NUM_BOXES - 1, "box")
        free = [s for s in range(sv.MONS_PER_BOX) if sv.open_mon(sv.box_raw(save, box, s)) is None]
        if not free:
            raise Refused(f"il box {box + 1} è pieno")
        slot = number(a["slot"], 0, sv.PARTY_SIZE - 1, "posto")
        last_one(save)
        sv.deposit(save, slot, box, free[0])

    def op_withdraw(self, save, a):
        if len(sv.party_raw(save)) >= sv.PARTY_SIZE:
            raise Refused(f"la squadra è piena: sei già a {sv.PARTY_SIZE} Pokémon")
        sv.withdraw(save, number(a["box"], 0, sv.NUM_BOXES - 1, "box"), number(a["slot"], 0, sv.MONS_PER_BOX - 1, "posto"))

    def op_move(self, save, a):
        """A Pokemon dragged in the page, from one place to another."""
        def place(p):
            if not isinstance(p, dict) or p.get("kind") not in ("party", "box"):
                raise Refused("posizione non valida")
            if p["kind"] == "party":
                return ("party", number(p.get("slot"), 0, sv.PARTY_SIZE - 1, "posto in squadra"))
            return ("box", number(p.get("box"), 0, sv.NUM_BOXES - 1, "box"), number(p.get("slot"), 0, sv.MONS_PER_BOX - 1, "posto nel box"))
        src, dst = place(a.get("from")), place(a.get("to"))
        count = len(sv.party_raw(save))
        if src[0] == "party" and src[1] >= count:
            raise Refused(f"la squadra non ha il posto {src[1] + 1}")
        if src[0] == "box" and sv.open_mon(sv.box_raw(save, src[1], src[2])) is None:
            raise Refused(f"box {src[1] + 1}, posto {src[2] + 1}: è vuoto")
        if src[0] == "box" and dst[0] == "party" and dst[1] >= count and count >= sv.PARTY_SIZE:
            raise Refused(f"la squadra è piena, sei già a {sv.PARTY_SIZE} Pokémon: trascinalo su uno di loro per scambiarli")
        if src[0] == "box" and not (sv.open_mon(sv.box_raw(save, src[1], src[2])) or {}).get("ok"):
            if dst[0] == "party":
                raise Refused("un Pokémon che non si legge (Uovo Difettoso) non va in squadra")
        try:
            sv.move_mon(save, src, dst)
        except ValueError as e:
            if "able to battle" in str(e) or "left empty" in str(e):
                raise Refused("in squadra deve restare almeno un Pokémon che possa lottare (non un uovo e non esausto)")
            raise Refused(str(e))

    def op_item(self, save, a):
        item = number(a["item"], 1, 0xFFFF, "strumento")
        entry = sv.item_table().get(item)
        if not entry or not entry["pocket"]:
            raise Refused("questo strumento non va in nessuna tasca")
        limit = sv.item_limit(item)
        quantity = number(a["quantity"], 0, limit, f"{entry['name']}, quantità" +
                          (" (una MT è una sola: New Gold non le consuma)" if limit == 1 else ""))
        held = sv.bag(save)[entry["pocket"]]
        if quantity and item not in {i["item"] for i in held} and len(held) >= sv.pocket_at(entry["pocket"])[1]:
            raise Refused(f"la tasca è piena ({len(held)} posti)")
        sv.set_item(save, item, quantity)

    def op_dex(self, save, a):
        for change in a["changes"]:
            species = number(change["id"], 1, 0xFFFF, "specie")
            if species not in sv.dex_species():
                raise Refused(f"la specie {species} non ha una pagina nel Pokédex")
            sv.set_dex(save, [species], bool(change["seen"]), bool(change["caught"]))

    def op_dex_all(self, save, a):
        mode = a["mode"]
        if mode not in ("seen", "caught", "clear"):
            raise Refused("tutti visti, tutti catturati o azzera")
        sv.set_dex(save, sv.dex_species(), mode != "clear", mode == "caught")

    def op_dex_switches(self, save, a):
        sv.set_dex_switches(save, enabled=a.get("enabled"), national=a.get("national"))

    def op_position(self, save, a):
        where = number(a["map"], 0, 0xFFFF, "mappa")
        if where not in sv.map_table() or not standable(where):
            raise Refused(f"la mappa {where} non è un luogo dove stare")
        x, y = number(a["x"], 0, 0xFFFF, "x"), number(a["y"], 0, 0xFFFF, "y")
        if not sv.on_map(where, x, y):
            chunks = sv.map_chunks(where)
            span = lambda i: f"{min(c[i] for c in chunks) * 32}–{max(c[i] for c in chunks) * 32 + 31}"
            raise Refused(f"({x}, {y}) è fuori da {sv.map_table()[where]['name'] or where}: lì il gioco lascerebbe "
                          f"il giocatore nel nero. La mappa sta tra x {span(0)} e y {span(1)}.")
        sv.set_position(save, where, x, y, number(a.get("direction", 0), 0, sv.DIR_MAX - 1, "direzione"))

    def op_flag(self, save, a):
        sv.write_flag(save, number(a["number"], 1, sv.num_flags() - 1, "flag"), bool(a["value"]))

    def op_var(self, save, a):
        sv.write_var(save, number(a["number"], sv.VAR_BASE, sv.VAR_BASE + sv.NUM_VARS - 1, "variabile"),
                     number(a["value"], 0, 0xFFFF, "valore"))


def standable(map_id):
    """A map the player can be put on: not MAP_EVERYWHERE, which is the
    header of no place, and one with chunks of its own (the unused ones
    have none)."""
    return map_id != sv.constants("include/constants/maps.h", "MAP_")["MAP_EVERYWHERE"] and bool(sv.map_chunks(map_id))


def last_one(save):
    if len(sv.party_raw(save)) <= 1:
        raise Refused("la squadra non può restare vuota")


def number(value, low, high, what):
    try:
        value = int(value)
    except (TypeError, ValueError):
        raise Refused(f"{what}: non è un numero")
    if not low <= value <= high:
        raise Refused(f"{what}: da {low} a {high}")
    return value


def brief(mon):
    if mon is None or not mon["ok"]:
        return {"ok": False}
    return {"ok": True, "species": mon["species"], "form": mon["form"], "egg": mon["egg"],
            "name": mon["nickname"] or mon["species_name"], "level": mon["level"]}


def checked_mon(a):
    """The Pokemon fields of a request, each checked."""
    out = {}
    if "species" in a:
        out["species"] = number(a["species"], 1, 0xFFFF, "specie")
        if out["species"] not in {row["id"] for row in sv.species_table()}:
            raise Refused(f"non c'è la specie {out['species']}")
    if "level" in a:
        out["level"] = number(a["level"], 1, sv.MAX_LEVEL, "livello")
    if "nature" in a:
        out["nature"] = number(a["nature"], 0, sv.NATURE_NUM - 1, "natura")
    if "item" in a:
        out["item"] = number(a["item"], 0, 0xFFFF, "strumento")
        if out["item"] and out["item"] not in sv.item_table():
            raise Refused(f"non c'è lo strumento {out['item']}")
    if "moves" in a:
        moves = [number(m, 0, len(sv.move_table()) - 1, "mossa") for m in a["moves"]]
        moves = [m for m in moves if m]
        if len(moves) > sv.MAX_MON_MOVES or len(set(moves)) != len(moves):
            raise Refused(f"al massimo {sv.MAX_MON_MOVES} mosse, tutte diverse")
        if not moves:
            raise Refused("un Pokémon senza mosse non può lottare: serve almeno una mossa")
        out["moves"] = moves
    if "ivs" in a:
        out["ivs"] = [number(v, 0, sv.MAX_IV, "IV") for v in a["ivs"]]
    if "evs" in a:
        evs = [number(v, 0, 0xFF, "EV") for v in a["evs"]]
        if sum(evs) > sv.MAX_EV_SUM:
            raise Refused(f"gli EV sono al massimo {sv.MAX_EV_SUM} in tutto")
        out["evs"] = [number(v, 0, sv.MAX_EV_PER_STAT, "EV") for v in evs]
    if "friendship" in a:
        out["friendship"] = number(a["friendship"], 0, 255, "amicizia")
    if "ability" in a:
        out["ability"] = number(a["ability"], 0, sv.HIDDEN_SLOT, "abilità")
    for key in ("ivs", "evs"):
        if key in out and len(out[key]) != sv.NUM_STATS:
            raise Refused(f"{key}: {sv.NUM_STATS} valori")
    return out


def changed(fields, now):
    """Only what differs, so that a field left alone is not rewritten -- a
    level sent back unchanged would put the experience at the level's floor.
    With a new species the moves and the ability sent are the new species'
    to check, even when they are the ones the Pokemon has."""
    if now is None or not now["ok"]:
        raise Refused("qui non c'è un Pokémon leggibile")
    current = {"species": now["species"], "level": now["level"], "nature": now["nature"], "item": now["item"],
               "moves": [m["id"] for m in now["moves"]], "ivs": now["ivs"], "evs": now["evs"],
               "friendship": now["friendship"], "ability": now["ability_slot"]}
    out = {k: v for k, v in fields.items() if v != current[k]}
    if "species" in out:
        out.update({k: fields[k] for k in ("moves", "ability") if k in fields})
    return out


def illegal(e):
    """savedit's Illegal in Italian, naming what the species cannot have."""
    who = sv.species_name(e.species)
    if e.moves:
        return (f"{who} non può imparare {', '.join(sv.move_table()[m]['name'] for m in e.moves)}: non è tra le "
                f"mosse della specie (livello, MT/MN/DT, insegnanti, mosse uovo, pre-evoluzioni)")
    what = "un'abilità nascosta" if e.ability == sv.HIDDEN_SLOT else "una seconda abilità"
    return f"{who} non ha {what}: scegli una delle sue abilità"


def storable(fields):
    """A species a Pokemon may be made as or turned into (species_table's
    "pick"); one it already is stays, whatever it is."""
    if "species" in fields and not next(r for r in sv.species_table() if r["id"] == fields["species"])["pick"]:
        raise Refused(f"{sv.species_name(fields['species'])} (specie {fields['species']}) non si può scegliere: "
                      "è l'uovo, una forma che il gioco tiene come specie base più forma, o una forma che "
                      "esiste solo in lotta")
    return fields


def created(save, a, party):
    """A new Pokemon; with no moves given, the ones the species knows at
    that level."""
    fields = storable(checked_mon({k: v for k, v in a.items() if k != "moves" or v}))
    if "species" not in fields or "level" not in fields:
        raise Refused("servono specie e livello")
    if 0xFFFF not in sv.owner(save)["codes"]:
        # A save sealed from RAM before the name was chosen: the Pokemon's
        # original trainer would be a name with no end, which the game
        # asserts on (CopyU16ArrayToString).
        raise Refused("il giocatore non ha ancora un nome: daglielo nella scheda Allenatore, poi aggiungi il Pokémon")
    raw = sv.new_mon(fields["species"], fields["level"], sv.owner(save), nature=fields.get("nature"),
                     moves=fields.get("moves"), item=fields.get("item", 0), ability=fields.get("ability"),
                     ivs=fields.get("ivs", 31), evs=fields.get("evs", 0), party=party)
    if "friendship" in fields:
        raw = sv.edit_mon(raw, friendship=fields["friendship"])
    return raw


def retag(save, before, after):
    """A new name, id or gender for the player, given to the Pokemon that
    were the player's own under the old one: the game counts a Pokemon whose
    original trainer is not the player as traded, and a traded Pokemon above
    the badges' level does not obey."""
    def mine(raw):
        mon = sv.open_mon(raw)
        if mon is None or not mon["ok"]:
            return None
        d = mon["blocks"][3]
        codes = list(struct.unpack_from("<8H", d, 0))
        codes = codes[:codes.index(0xFFFF) + 1] if 0xFFFF in codes else codes
        a = mon["blocks"][0]
        if (codes, struct.unpack_from("<I", a, 4)[0], d[0x1C] >> 7) != (before["codes"], before["id"], before["gender"]):
            return None
        d[0:16] = struct.pack("<8H", *(after["codes"] + [0] * (8 - len(after["codes"]))))
        struct.pack_into("<I", a, 4, after["id"])
        d[0x1C] = (d[0x1C] & 0x7F) | (after["gender"] & 1) << 7
        return sv.seal_mon(mon)
    for slot, raw in enumerate(sv.party_raw(save)):
        new = mine(raw)
        if new:
            sv.set_party_mon(save, slot, new)
    for box in range(sv.NUM_BOXES):
        for slot in range(sv.MONS_PER_BOX):
            new = mine(sv.box_raw(save, box, slot))
            if new:
                sv.set_box_mon(save, box, slot, new)


def checked_settings(body, build):
    """The folder and the ROMs the page sent, checked; refused with the
    reason otherwise."""
    if not isinstance(body, dict):
        raise Refused("impostazioni non valide")
    library = body.get("library")
    if not isinstance(library, str) or not library.strip():
        raise Refused("scegli la cartella dei salvataggi")
    folder = Path(library.strip()).expanduser()
    if not folder.is_absolute():
        raise Refused("la cartella dei salvataggi va indicata per intero, da /")
    if not folder.exists():
        if not body.get("create"):
            raise Refused(f"la cartella {folder} non esiste")
        folder.mkdir(parents=True)
    if not folder.is_dir():
        raise Refused(f"{folder} non è una cartella")
    roms, seen = [], set()
    defaults = {r["rom"]: r for r in default_roms(build)}
    for entry in body.get("roms") or []:
        if not isinstance(entry, dict) or not isinstance(entry.get("rom"), str):
            raise Refused("una ROM senza percorso")
        rom = Path(entry["rom"].strip()).expanduser()
        if not rom.is_absolute() or rom.suffix.lower() != ".nds":
            raise Refused(f"{rom}: una ROM è un file .nds indicato per intero")
        if not rom.is_file():
            raise Refused(f"la ROM {rom} non esiste")
        if str(rom) in seen:
            continue
        seen.add(str(rom))
        label = str(entry.get("label") or "").strip()[:60] or defaults.get(str(rom), {}).get("label") or rom.stem
        key = defaults[str(rom)]["id"] if str(rom) in defaults else rom_id(rom)
        roms.append({"id": key, "label": label, "rom": str(rom)})
    return {"library": str(folder.resolve()), "roms": roms}


def browse(path, want):
    """One folder's subfolders, and its .nds files when a ROM is wanted; only
    under the home and the usual mount points."""
    here = Path(path).expanduser() if path else Path.home()
    try:
        here = here.resolve(strict=True)
    except OSError:
        raise Refused(f"{here} non esiste")
    if not here.is_dir():
        here = here.parent
    if not any(here == r or here.is_relative_to(r) for r in BROWSE_ROOTS if r.exists()):
        raise Refused(f"si sfoglia solo sotto {Path.home()} e i dischi montati")
    dirs, files = [], []
    try:
        for child in sorted(here.iterdir(), key=lambda c: c.name.lower()):
            if child.name.startswith("."):
                continue
            try:
                if child.is_dir():
                    dirs.append(child.name)
                elif want == "nds" and child.suffix.lower() == ".nds" and child.is_file():
                    files.append({"name": child.name, "size": child.stat().st_size})
            except OSError:
                continue
    except PermissionError:
        raise Refused(f"non posso leggere {here}")
    parent = here.parent if here != here.parent and any(
        here.parent == r or here.parent.is_relative_to(r) for r in BROWSE_ROOTS if r.exists()) else None
    return {"path": str(here), "parent": str(parent) if parent else None, "dirs": dirs, "files": files,
            "saves": sum(1 for _ in here.glob("*.sav")) if want == "dir" else None}


def species_rules(q):
    """What the Pokemon dialog offers for a species (in a form): every move
    it can learn with all its sources, by name; its abilities by slot; the
    moves the game gives it at the level (the preset); and the ability slot
    the game gives a Pokemon with these bits (hidden, bit) as this species."""
    species = number(q.get("species"), 1, len(sv.personal_records()) - 1, "specie")
    form = number(q.get("form", 0), 0, sv.MAX_FORM, "forma")
    moves, names = sv.learnable_moves(species, form), sv.move_table()
    return {"moves": [{"id": m, "sources": moves[m]} for m in sorted(moves, key=lambda m: names[m]["name"])],
            "abilities": sv.species_abilities(species, form),
            "ability": sv.ability_slot(species, form, q.get("hidden") == "1", q.get("bit") == "1"),
            "preset": sv.preset_moves(species, number(q.get("level", 1), 1, sv.MAX_LEVEL, "livello"), form),
            "friendship": sv.personal_records()[sv.personal_row(species, form)]["friendship"]}


def tables():
    """What the page names and offers, as the tree has it: the species,
    moves, items, natures (and the stat each raises and lowers), maps and
    Dex pages; the pockets in the order the game shows them; the stats, the
    badges, the directions and the genders by their constants, which the
    page's Italian labels are keyed by; and the limits a field is held to."""
    by_value = lambda header, prefix, below: [
        {"const": const, "value": value} for const, value in sorted(sv.constants(header, prefix).items(),
                                                                    key=lambda kv: kv[1]) if 0 <= value < below]
    genders = {"MON_MALE": sv.MON_MALE, "MON_FEMALE": sv.MON_FEMALE, "MON_GENDERLESS": sv.MON_GENDERLESS}
    return {"species": sv.species_table(), "moves": sv.move_table(),
            "items": [{**row, "limit": sv.item_limit(row["id"])} if row["pocket"] else row
                      for row in sv.item_table().values()],
            "natures": sv.bank(sv.NATURE_NAMES), "nature_mods": sv.nature_mods(),
            "maps": [m for m in sv.map_table().values() if standable(m["id"])], "dex": sv.dex_species(),
            "pockets": [{k: p[k] for k in ("name", "const", "slots")} for p in sv.pockets()],
            "stats": by_value("include/constants/pokemon.h", "STAT_", sv.NUM_STATS),
            "directions": by_value("include/constants/global_fieldmap.h", "DIR_", sv.DIR_MAX),
            "genders": [{"const": const, "value": value} for const, value in genders.items()],
            "badges": sv.badges(),
            "limits": {"party": sv.PARTY_SIZE, "boxes": sv.NUM_BOXES, "box_slots": sv.MONS_PER_BOX,
                       "name": sv.PLAYER_NAME_LENGTH, "money": sv.MAX_MONEY, "coins": sv.MAX_COINS,
                       "hours": sv.MAX_PLAY_HOURS, "level": sv.MAX_LEVEL, "moves": sv.MAX_MON_MOVES,
                       "iv": sv.MAX_IV, "ev": sv.MAX_EV_PER_STAT, "ev_sum": sv.MAX_EV_SUM,
                       "hidden_slot": sv.HIDDEN_SLOT},
            "tree": sv.GENERATION}


# ---------------------------------------------------------------------------
# HTTP.


class Handler(http.server.BaseHTTPRequestHandler):
    library = None
    port = None
    persist = False     # whether the page's choices are written to CONFIG
    server = None

    def log_message(self, fmt, *args):
        pass

    def reply(self, status, body, kind="application/json; charset=utf-8", cache=False):
        data = json.dumps(body, ensure_ascii=False).encode() if kind.startswith("application/json") else body
        self.send_response(status)
        self.send_header("Content-Type", kind)
        self.send_header("Content-Length", str(len(data)))
        self.send_header("Cache-Control", "max-age=86400" if cache else "no-store")
        self.send_header("X-Content-Type-Options", "nosniff")
        self.end_headers()
        self.wfile.write(data)

    def trusted(self):
        """Only this page: the Host is ours (no DNS rebinding) and an Origin,
        when there is one, is ours too (no other site posting here)."""
        hosts = {f"127.0.0.1:{self.port}", f"localhost:{self.port}"}
        origin = self.headers.get("Origin")
        return self.headers.get("Host") in hosts and (origin is None or origin in {f"http://{h}" for h in hosts})

    def do_GET(self):
        if not self.trusted():
            return self.reply(403, {"error": "richiesta non ammessa"})
        sv.fresh()      # what the page gets is the tree as it is now
        url = urllib.parse.urlsplit(self.path)
        q = {k: v[-1] for k, v in urllib.parse.parse_qs(url.query).items()}
        try:
            if url.path in ("/", "/index.html"):
                return self.reply(200, PAGE.read_bytes(), "text/html; charset=utf-8")
            if url.path == "/api/state":
                return self.reply(200, {"melonds": melonds_running(), "code": CODE, "tree": sv.GENERATION,
                                        "version": self.library.current(q["f"]) if q.get("f") else None})
            if url.path == "/api/settings":
                return self.reply(200, self.library.settings())
            if url.path == "/api/browse":
                return self.reply(200, browse(q.get("path"), q.get("want", "dir")))
            if url.path == "/api/library":
                return self.reply(200, self.library.listing())
            if url.path == "/api/data":
                return self.reply(200, tables())
            if url.path == "/api/save":
                return self.reply(200, self.library.detail(q.get("f")))
            if url.path == "/api/flags":
                path, _, _ = self.library.locate(q.get("f"))
                found = sv.find_flags(self.library.open(path), q.get("q", ""))
                return self.reply(200, {"rows": found[:FLAG_ROWS], "total": len(found)})
            if url.path == "/api/species":
                return self.reply(200, species_rules(q))
            if url.path == "/api/icon":
                png = icon(number(q.get("species"), 0, 0xFFFF, "specie"), number(q.get("form", 0), 0, 255, "forma"),
                           q.get("egg") in ("1", "true"))
                return self.reply(200, png, "image/png", cache=True)
            return self.reply(404, {"error": "non trovato"})
        except Refused as e:
            return self.reply(400, {"error": str(e), "code": e.code})
        except Exception as e:
            return self.reply(500, {"error": f"errore interno dell'editor ({type(e).__name__}: {e})"})

    def do_POST(self):
        if not self.trusted() or not self.headers.get("Content-Type", "").startswith("application/json"):
            return self.reply(403, {"error": "richiesta non ammessa"})
        sv.fresh()
        try:
            body = json.loads(self.rfile.read(int(self.headers.get("Content-Length", 0))) or b"{}")
            lib, path = self.library, urllib.parse.urlsplit(self.path).path
            if path == "/api/edit":
                return self.reply(200, lib.edit(body.get("f"), body.get("op"), body.get("args") or {},
                                                body.get("version")))
            if path == "/api/undo":
                return self.reply(200, lib.undo(body.get("f"), body.get("version")))
            if path == "/api/restore":
                return self.reply(200, lib.restore(body.get("f"), body.get("backup")))
            if path == "/api/duplicate":
                return self.reply(200, {"f": lib.duplicate(body.get("f"), body.get("name"))})
            if path == "/api/rename":
                return self.reply(200, {"f": lib.rename(body.get("f"), body.get("name"))})
            if path == "/api/trash":
                lib.throw(body.get("f"))
                return self.reply(200, {})
            if path == "/api/untrash":
                return self.reply(200, {"f": lib.untrash(body.get("t"), body.get("name"))})
            if path == "/api/load":
                lib.load(body.get("f"), body.get("slot"), body.get("force") is True)
                return self.reply(200, {})
            if path == "/api/take":
                return self.reply(200, {"f": lib.take(body.get("slot"), body.get("name"))})
            if path == "/api/play":
                lib.play(body.get("f"), body.get("slot"), body.get("force") is True)
                return self.reply(200, {})
            if path == "/api/quit":
                # The page's "Chiudi l'editor": started with a double click,
                # the server has no terminal to press Ctrl+C in.
                threading.Thread(target=Handler.server.shutdown, daemon=True).start()
                return self.reply(200, {})
            if path == "/api/settings":
                chosen = checked_settings(body, lib.build)
                with lib.lock:
                    Handler.library = Library(chosen["library"], lib.build, chosen["roms"])
                    if Handler.persist:
                        store_settings(chosen)
                return self.reply(200, Handler.library.settings())
            return self.reply(404, {"error": "non trovato"})
        except Refused as e:
            return self.reply(400, {"error": str(e), "code": e.code})
        except Exception as e:
            return self.reply(500, {"error": f"errore interno dell'editor ({type(e).__name__}: {e})"})


def serve(library, build, port, roms=None, persist=False):
    """The server on 127.0.0.1, on `port` or the next free one of ten."""
    for candidate in range(port, port + 10) if port else [0]:
        try:
            server = http.server.ThreadingHTTPServer(("127.0.0.1", candidate), Handler)
            break
        except OSError:
            continue
    else:
        raise SystemExit(f"nessuna porta libera da {port} a {port + 9}")
    Handler.library = Library(library, build, roms)
    Handler.port = server.server_address[1]
    Handler.persist = persist
    Handler.server = server
    return server


def main():
    parser = argparse.ArgumentParser(description="L'editor dei salvataggi, come pagina su questo computer.")
    parser.add_argument("--library", type=Path, default=None,
                        help="la cartella dei .sav per questa volta; altrimenti quella scelta nella pagina, "
                             "o ~/hgss-saves")
    parser.add_argument("--port", type=int, default=8765,
                        help="8765 se non si dice; se è occupata, la prima libera delle dieci dopo")
    parser.add_argument("--no-browser", action="store_true", help="scrive l'indirizzo invece di aprire il browser")
    parser.add_argument("--build", type=Path, default=ROOT / "build",
                        help="la cartella con heartgold.us, heartgold.us.diag e le altre")
    parser.add_argument("--dry-run-launch", action="store_true",
                        help="Gioca scrive il comando di melonDS invece di eseguirlo (o SAVEUI_DRY_RUN=1)")
    parser.add_argument("--install-launcher", action="store_true",
                        help="aggiunge 'Editor salvataggi New Gold' al menu delle applicazioni ed esce")
    args = parser.parse_args()
    if args.install_launcher:
        return install_launcher()
    if args.dry_run_launch:
        os.environ["SAVEUI_DRY_RUN"] = "1"
    running = already_serving(args.port) if args.port else None
    if running == CODE and not args.no_browser:
        # A second start -- a double click on the launcher while the editor
        # runs -- opens the page on the one that is there.
        url = f"http://127.0.0.1:{args.port}/"
        print(f"l'editor dei salvataggi è già aperto su {url}")
        webbrowser.open(url)
        return
    if running is not None and running != CODE:
        # The one running is older code -- the tree was updated since it
        # started -- so it is replaced rather than reopened.
        print("un editor con codice più vecchio era aperto: " + ("chiuso, riparto con quello nuovo" if stop_outdated(args.port)
                                                                   else "non si chiude, parto su un'altra porta"))
    settings = load_settings()
    library = args.library or Path(settings.get("library") or Path.home() / "hgss-saves")
    if not library.is_dir():
        if args.library:
            raise SystemExit(f"{args.library} non è una cartella")
        # Not the home folder instead: the page opens on the settings, and
        # nothing is read or written until a folder is chosen there.
        print(f"la cartella dei salvataggi {library} non c'è: sceglila nella pagina, in Cartelle e ROM")
    roms = settings.get("roms") if isinstance(settings.get("roms"), list) else None
    server = serve(library, args.build, args.port, roms, persist=True)
    problem = Handler.library.layout_problem()
    if problem:
        print("attenzione:", problem)
    url = f"http://127.0.0.1:{Handler.port}/"
    print(f"editor dei salvataggi su {url} -- libreria {Handler.library.root}, build {Handler.library.build}"
          f"{' (avvii di melonDS simulati)' if dry_run() else ''}; Ctrl+C per fermarlo")
    if not args.no_browser:
        webbrowser.open(url)
    try:
        server.serve_forever()
    except KeyboardInterrupt:
        pass


def already_serving(port):
    """The code of the editor answering on the port, "" for one too old to
    say, or None when nothing answers."""
    import urllib.request
    try:
        with urllib.request.urlopen(f"http://127.0.0.1:{port}/api/state", timeout=1) as reply:
            state = json.load(reply)
    except (OSError, ValueError):
        return None
    return state.get("code", "") if "melonds" in state else None


def stop_outdated(port, wait=5.0):
    """Ask the editor on the port, running older code, to stop, and wait for
    the port to be free. False when it would not (one from before "Chiudi
    l'editor"): the new one then takes the next free port."""
    import urllib.request
    request = urllib.request.Request(f"http://127.0.0.1:{port}/api/quit", data=b"{}", method="POST", headers={
        "Content-Type": "application/json", "Origin": f"http://127.0.0.1:{port}"})
    try:
        urllib.request.urlopen(request, timeout=2).read()
    except OSError:
        return False
    deadline = time.monotonic() + wait
    while time.monotonic() < deadline:
        if already_serving(port) is None:
            return True
        time.sleep(0.2)
    return False


def install_launcher():
    """A .desktop entry, so the editor starts from the application menu."""
    entry = Path(os.environ.get("XDG_DATA_HOME") or Path.home() / ".local/share") / "applications/newgold-saveui.desktop"
    entry.parent.mkdir(parents=True, exist_ok=True)
    entry.write_text("[Desktop Entry]\nType=Application\nName=Editor salvataggi New Gold\n"
                     "Comment=I salvataggi di HeartGold New Gold: modificali, caricali in melonDS e gioca\n"
                     f"Exec={sys.executable} {Path(__file__).resolve()}\nIcon=applications-games\n"
                     "Terminal=false\nCategories=Game;Utility;\n")
    print(f"scritto {entry}")


if __name__ == "__main__":
    main()
