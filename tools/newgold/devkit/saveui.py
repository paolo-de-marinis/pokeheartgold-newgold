#!/usr/bin/env python3
"""The save editor as a page on this machine.

    saveui.py [--library DIR] [--port N] [--no-browser] [--build DIR]

Serves saveui.html on http://127.0.0.1:PORT (8765 by default) and opens it
in the browser. The library is a folder of .sav files, ~/hgss-saves by
default; the emulator slots are the .sav melonDS reads beside each ROM under
the build folder (--build, this tree's build/ by default). Everything is read
and written through savedit.py.

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
import http.server
import json
import os
import re
import shutil
import struct
import subprocess
import sys
import threading
import urllib.parse
import webbrowser
import zlib
from pathlib import Path, PurePosixPath

HERE = Path(__file__).resolve().parent
ROOT = HERE.parents[2]
sys.path.insert(0, str(HERE))
import savedit as sv  # noqa: E402

PAGE = HERE / "saveui.html"
PLAY = HERE / "diag/play.py"
ICONS = ROOT / "files/poketool/icongra/poke_icon"
# key: (build folder, ROM stem, label). melonDS's SaveFilePath is empty, so
# it reads and writes the .sav beside the ROM.
SLOTS = {
    "hg-diag": ("heartgold.us.diag", "pokeheartgold.us", "HeartGold diagnostica"),
    "hg": ("heartgold.us", "pokeheartgold.us", "HeartGold"),
    "ss-diag": ("soulsilver.us.diag", "pokesoulsilver.us", "SoulSilver diagnostica"),
    "ss": ("soulsilver.us", "pokesoulsilver.us", "SoulSilver"),
}
PLAYABLE = ("hg-diag", "hg")
NAME = re.compile(r"[\w\- .]+")
APP = "net.kuribo64.melonDS"    # diag/play.py's
LAUNCHED = []                   # what a dry run would have started


class Refused(Exception):
    """A request the editor turns down; the message is shown as it is."""


def melonds_running():
    return subprocess.run(["pgrep", "-x", "melonDS"], capture_output=True).returncode == 0


def dry_run():
    return os.environ.get("SAVEUI_DRY_RUN") == "1"


def launch(rom):
    """play.py's own launch: the flatpak on this ROM, detached."""
    command = [sys.executable, str(PLAY), "launch", str(rom)]
    if dry_run():
        LAUNCHED.append(rom)
        print("avvio simulato:", " ".join(command))
        return
    subprocess.Popen(command, stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL, start_new_session=True)


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


def stamp():
    return datetime.datetime.now().strftime("%Y%m%d-%H%M%S-%f")


# ---------------------------------------------------------------------------
# Party icons: GetMonIconNaixEx and GetMonIconPaletteEx, the PNG given the
# palette the game gives it.

# species: (first icon, first palette entry, forms) for the forms with icons.
ICON_FORMS = {"DEOXYS": (503, 496, 4), "UNOWN": (507, 499, 28), "BURMY": (534, 527, 3),
              "WORMADAM": (536, 529, 3), "SHELLOS": (538, 531, 2), "GASTRODON": (539, 532, 2),
              "GIRATINA": (540, 533, 2), "SHAYMIN": (541, 534, 2), "ROTOM": (542, 535, 6)}


def _icon_tables():
    if not hasattr(_icon_tables, "cache"):
        source = (ROOT / "src/pokemon_icon_idx.c").read_text()
        start = source.index("sPokemonPalNoBySpeciesAndForm[] = {")
        palette_of = [int(n) for n in re.findall(r"^\s*(\d+),", source[start:source.index("\n};", start)], re.M)]
        lines = (ICONS / "poke_icon_00000000.pal").read_text().split("\n")[3:]
        colours = [tuple(int(v) for v in line.split()) for line in lines if line.strip()]
        first = sv.constants("include/pokemon_icon_idx.h", "FIRST_ADDED_")
        _icon_tables.cache = palette_of, colours, first["FIRST_ADDED_ICON"], first["FIRST_ADDED_PALETTE"]
    return _icon_tables.cache


def icon(species, form=0, egg=False):
    palette_of, colours, first_icon, first_palette = _icon_tables()
    n = sv.species_numbers()
    by_id = {n[name]: value for name, value in ICON_FORMS.items()}
    if egg:
        index, pal = (502, 495) if species == n["MANAPHY"] else (501, 494)
    elif species > n["ARCEUS"]:
        if n["LILLIPUP"] <= species < len(sv.personal_records()):
            index, pal = species - n["LILLIPUP"] + first_icon, species - n["LILLIPUP"] + first_palette
        else:
            index, pal = 7, 0
    elif species in by_id and 0 < form < by_id[species][2]:
        index, pal = by_id[species][0] + form - 1, by_id[species][1] + form - 1
    else:
        index, pal = species + 7, species
    png = (ICONS / f"poke_icon_{index:08d}.png").read_bytes()
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


class Library:
    def __init__(self, library, build):
        self.root = Path(library).expanduser().resolve()
        self.build = Path(build).expanduser().resolve()
        self.layout = self.build / "heartgold.us"
        self.backups = self.root / ".backups"
        self.trash = self.root / ".trash"
        self.lock = threading.RLock()

    # -- where things are ---------------------------------------------------

    def slot_paths(self, key):
        folder, stem, _ = SLOTS[key]
        return self.build / folder / f"{stem}.nds", self.build / folder / f"{stem}.sav"

    def slots(self):
        return [key for key in SLOTS if self.slot_paths(key)[0].exists()]

    def inside(self, rel, base=None, sav=True):
        """A path under the library (or `base`), refused if it climbs out,
        hides, or passes through a link."""
        base = base or self.root
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

    def locate(self, f):
        """(path, backup key, is it an emulator slot) for 'emu:<slot>' or a
        path in the library."""
        if isinstance(f, str) and f.startswith("emu:"):
            key = f[4:]
            if key not in SLOTS or key not in self.slots():
                raise Refused(f"non c'è lo slot {key}")
            path = self.slot_paths(key)[1]
            if path.is_symlink():
                raise Refused(f"{path} è un collegamento simbolico")
            return path, f"emulatore/{key}", True
        return self.inside(f), f, False

    def new_name(self, name):
        """A library path for a file that does not exist yet."""
        name = (name or "").strip()
        if not name.endswith(".sav"):
            name += ".sav"
        if not all(NAME.fullmatch(part) for part in name.split("/")):
            raise Refused("nel nome solo lettere, cifre, spazi, - _ . e / per le cartelle")
        path = self.inside(name)
        if path.exists():
            raise Refused(f"{name} esiste già")
        return path

    def open(self, path):
        try:
            return sv.Save(path, self.layout)
        except SystemExit as e:
            raise Refused(f"non è un salvataggio valido: {str(e).replace(str(path) + ': ', '')}")
        except Exception as e:
            raise Refused(f"non è un salvataggio valido: {type(e).__name__}: {e}")

    # -- reading ------------------------------------------------------------

    def summary(self, path):
        st = path.stat()
        entry = {"mtime": st.st_mtime, "size": st.st_size}
        try:
            save = self.open(path)
        except Refused as e:
            return {**entry, "valid": False, "error": str(e)}
        profile = sv.profile(save)
        where = sv.position(save)["current"]
        place = sv.map_table().get(where["map"], {})
        return {**entry, "valid": True, "name": profile["name"], "johto": profile["johto"],
                "kanto": profile["kanto"], "badges": bin(profile["johto"]).count("1") + bin(profile["kanto"]).count("1"),
                "party": [brief(sv.describe_mon(raw)) for raw in sv.party_raw(save)],
                "location": place.get("name") or place.get("const") or f"mappa {where['map']}",
                "counter": save.counter(), "play_time": profile["play_time"]}

    def listing(self):
        files = []
        for folder, dirs, names in os.walk(self.root):
            dirs[:] = sorted(d for d in dirs if not d.startswith("."))
            for name in sorted(names):
                path = Path(folder) / name
                if name.endswith(".sav") and not name.startswith(".") and path.is_file() and not path.is_symlink():
                    files.append({"f": path.relative_to(self.root).as_posix(), **self.summary(path)})
        slots = []
        for key in self.slots():
            rom, path = self.slot_paths(key)
            slots.append({"f": f"emu:{key}", "slot": key, "label": SLOTS[key][2], "path": str(path),
                          "rom": str(rom), "problem": rom_problem(rom, path),
                          "exists": path.exists(), **(self.summary(path) if path.exists() else {})})
        trash = []
        if self.trash.is_dir():
            for path in sorted(self.trash.rglob("*.sav"), reverse=True):
                rel = path.relative_to(self.trash).as_posix()
                trash.append({"t": rel, "f": rel.split("/", 1)[-1], "when": rel.split("/", 1)[0]})
        return {"library": str(self.root), "files": files, "slots": slots, "trash": trash,
                "playable": [s["slot"] for s in slots if s["slot"] in PLAYABLE and not s["problem"]],
                "melonds": melonds_running()}

    def detail(self, f):
        path, key, is_slot = self.locate(f)
        if not path.exists():
            raise Refused("il file non c'è")
        save = self.open(path)
        return {"f": f, "path": str(path), "slot": is_slot, "mtime": path.stat().st_mtime,
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
        there, then replace it."""
        path, key, is_slot = self.locate(f)
        if is_slot and melonds_running():
            raise Refused("melonDS è aperto: riscriverebbe lo slot alla chiusura. Chiudilo prima.")
        path.parent.mkdir(parents=True, exist_ok=True)
        temporary = path.with_name(f".{path.name}.{os.getpid()}.tmp")
        try:
            with open(temporary, "wb") as out:
                out.write(data)
                out.flush()
                os.fsync(out.fileno())
            if validate:
                self.open(temporary)
            if path.exists():
                folder = self.backups / key
                folder.mkdir(parents=True, exist_ok=True)
                shutil.copyfile(path, folder / f"{stamp()}{'-' + tag if tag else ''}.sav")
            os.replace(temporary, path)
        finally:
            temporary.unlink(missing_ok=True)

    def edit(self, f, op, args):
        handler = getattr(self, f"op_{op}", None) if re.fullmatch(r"[a-z_]+", op or "") else None
        if handler is None:
            raise Refused(f"operazione sconosciuta: {op}")
        with self.lock:
            path, _, _ = self.locate(f)
            save = self.open(path)
            try:
                handler(save, args)
            except (KeyError, TypeError) as e:
                raise Refused(f"richiesta incompleta: {e}")
            except (ValueError, SystemExit) as e:
                raise Refused(str(e))
            data = save.image()
            if data != path.read_bytes():
                self.write(f, data)
        return self.detail(f)

    def undo(self, f):
        with self.lock:
            path, key, _ = self.locate(f)
            stack = [b for b in self.history(key) if b["undo"]]
            if not stack:
                raise Refused("non c'è nulla da annullare")
            latest = self.backups / key / stack[0]["name"]
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
            target = self.new_name(name)
            new = target.relative_to(self.root).as_posix()
            target.parent.mkdir(parents=True, exist_ok=True)
            os.rename(source, target)
            if (self.backups / key).is_dir() and not (self.backups / new).exists():
                (self.backups / new).parent.mkdir(parents=True, exist_ok=True)
                os.rename(self.backups / key, self.backups / new)
            return new

    def throw(self, f):
        with self.lock:
            source, _, is_slot = self.locate(f)
            if is_slot:
                raise Refused("uno slot dell'emulatore non va nel cestino")
            target = self.trash / stamp() / f
            target.parent.mkdir(parents=True, exist_ok=True)
            os.rename(source, target)

    def untrash(self, t, name=None):
        with self.lock:
            source = self.inside(t, base=self.trash)
            if not source.is_file():
                raise Refused(f"non c'è {t} nel cestino")
            target = self.new_name(name or t.split("/", 1)[-1])
            target.parent.mkdir(parents=True, exist_ok=True)
            os.rename(source, target)
            return target.relative_to(self.root).as_posix()

    def load(self, f, slot):
        """'Carica nell'emulatore': a valid save copied into a slot, beside
        a ROM melonDS can play."""
        with self.lock:
            source, _, _ = self.locate(f)
            target, _, _ = self.locate(f"emu:{slot}")
            problem = rom_problem(self.slot_paths(slot)[0], target)
            if problem:
                raise Refused(f"{SLOTS[slot][2]}: {problem}")
            self.open(source)
            self.write(f"emu:{slot}", source.read_bytes())

    def take(self, slot, name):
        """'Prendi dall'emulatore': a slot copied into the library."""
        with self.lock:
            source, _, _ = self.locate(f"emu:{slot}")
            if not source.exists():
                raise Refused("lo slot è vuoto")
            target = self.new_name(name)
            self.write(target.relative_to(self.root).as_posix(), source.read_bytes(), validate=False)
            return target.relative_to(self.root).as_posix()

    def play(self, f, slot):
        if slot not in PLAYABLE:
            raise Refused("si gioca su HeartGold, normale o diagnostica")
        self.load(f, slot)
        launch(self.slot_paths(slot)[0].resolve())

    # -- the edits the page sends -------------------------------------------

    def op_trainer(self, save, a):
        now, before = sv.profile(save), sv.owner(save)
        if "name" in a and a["name"] != now["name"]:
            # savedit's charcode writes letters and digits and nothing else.
            if not re.fullmatch(r"[A-Za-z0-9]{1,7}", a["name"]):
                raise Refused("il nome: da 1 a 7 lettere o cifre (A-Z, a-z, 0-9)")
            sv.set_name(save, a["name"])
        ident = number(a.get("id", now["id"]), 0, 0xFFFF, "ID"), number(a.get("sid", now["sid"]), 0, 0xFFFF, "ID segreto")
        if ident != (now["id"], now["sid"]):
            sv.set_trainer_id(save, ident[0] | ident[1] << 16)
        limits = {"money": (sv.MAX_MONEY, "soldi"), "gender": (1, "genere"), "johto": (255, "medaglie di Johto"),
                  "kanto": (255, "medaglie di Kanto"), "coins": (sv.MAX_COINS, "gettoni")}
        values = {k: number(a[k], 0, high, what) for k, (high, what) in limits.items() if k in a}
        if "play_time" in a:
            hours, minutes, seconds = a["play_time"]
            values["play_time"] = [number(hours, 0, 999, "ore"), number(minutes, 0, 59, "minuti"),
                                   number(seconds, 0, 59, "secondi")]
        sv.set_profile(save, **values)
        if a.get("retag", True) and sv.owner(save) != before:
            retag(save, before, sv.owner(save))

    def op_party_edit(self, save, a):
        slot = number(a["slot"], 0, 5, "posto")
        raw = sv.party_raw(save)[slot]
        changes = changed(checked_mon(a), sv.describe_mon(raw))
        if changes:
            sv.set_party_mon(save, slot, sv.edit_mon(raw, **changes))

    def op_party_add(self, save, a):
        if len(sv.party_raw(save)) >= sv.PARTY_SIZE:
            raise Refused("la squadra ha già sei Pokémon")
        sv.add_party_mon(save, created(save, a, party=True))

    def op_party_remove(self, save, a):
        slot = number(a["slot"], 0, 5, "posto")
        last_one(save)
        sv.remove_party_mon(save, slot)

    def op_party_swap(self, save, a):
        sv.swap_party_mons(save, number(a["a"], 0, 5, "posto"), number(a["b"], 0, 5, "posto"))

    def op_box_edit(self, save, a):
        box, slot = number(a["box"], 0, 29, "box"), number(a["slot"], 0, 29, "posto")
        raw = sv.box_raw(save, box, slot)
        changes = changed(checked_mon(a), sv.describe_mon(raw))
        if changes:
            sv.set_box_mon(save, box, slot, sv.edit_mon(raw, **changes))

    def op_box_add(self, save, a):
        box, slot = number(a["box"], 0, 29, "box"), number(a["slot"], 0, 29, "posto")
        if sv.open_mon(sv.box_raw(save, box, slot)) is not None:
            raise Refused(f"box {box + 1}, posto {slot + 1}: è occupato")
        sv.set_box_mon(save, box, slot, created(save, a, party=False))

    def op_box_remove(self, save, a):
        sv.set_box_mon(save, number(a["box"], 0, 29, "box"), number(a["slot"], 0, 29, "posto"), sv.EMPTY_BOX_MON)

    def op_deposit(self, save, a):
        box = number(a["box"], 0, 29, "box")
        free = [s for s in range(30) if sv.open_mon(sv.box_raw(save, box, s)) is None]
        if not free:
            raise Refused(f"il box {box + 1} è pieno")
        slot = number(a["slot"], 0, 5, "posto")
        last_one(save)
        sv.deposit(save, slot, box, free[0])

    def op_withdraw(self, save, a):
        if len(sv.party_raw(save)) >= sv.PARTY_SIZE:
            raise Refused("la squadra ha già sei Pokémon")
        sv.withdraw(save, number(a["box"], 0, 29, "box"), number(a["slot"], 0, 29, "posto"))

    def op_item(self, save, a):
        item, quantity = number(a["item"], 1, 0xFFFF, "strumento"), number(a["quantity"], 0, 999, "quantità")
        entry = sv.item_table().get(item)
        if not entry or not entry["pocket"]:
            raise Refused("questo strumento non va in nessuna tasca")
        if entry["pocket"] == "TMsHMs" and quantity > (1 if entry["const"].startswith("ITEM_TM") else 99):
            raise Refused(f"{entry['name']}: una MT è una sola (New Gold non le consuma), una MN al massimo 99")
        held = sv.bag(save)[entry["pocket"]]
        if quantity and item not in {i["item"] for i in held} and len(held) >= dict(sv.POCKETS)[entry["pocket"]]:
            raise Refused(f"la tasca è piena ({len(held)} posti)")
        sv.set_item(save, item, quantity)

    def op_dex(self, save, a):
        for change in a["changes"]:
            sv.set_dex(save, [number(change["id"], 1, 0xFFFF, "specie")], bool(change["seen"]), bool(change["caught"]))

    def op_dex_all(self, save, a):
        mode = a["mode"]
        if mode not in ("seen", "caught", "clear"):
            raise Refused("tutti visti, tutti catturati o azzera")
        sv.set_dex(save, sv.dex_species(), mode != "clear", mode == "caught")

    def op_dex_switches(self, save, a):
        sv.set_dex_switches(save, enabled=a.get("enabled"), national=a.get("national"))

    def op_position(self, save, a):
        where = number(a["map"], 0, 0xFFFF, "mappa")
        if where not in sv.map_table():
            raise Refused(f"non c'è la mappa {where}")
        sv.set_position(save, where, number(a["x"], 0, 0xFFFF, "x"), number(a["y"], 0, 0xFFFF, "y"),
                        number(a.get("direction", 0), 0, 3, "direzione"))

    def op_flag(self, save, a):
        sv.write_flag(save, number(a["number"], 1, 0xFFFF, "flag"), bool(a["value"]))

    def op_var(self, save, a):
        sv.write_var(save, number(a["number"], 0, 0xFFFF, "variabile"), number(a["value"], 0, 0xFFFF, "valore"))


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
        if out["species"] not in {row["id"] for row in sv.species_table() if not row["egg"]}:
            raise Refused(f"non c'è la specie {out['species']}")
    if "level" in a:
        out["level"] = number(a["level"], 1, 100, "livello")
    if "nature" in a:
        out["nature"] = number(a["nature"], 0, 24, "natura")
    if "item" in a:
        out["item"] = number(a["item"], 0, 0xFFFF, "strumento")
        if out["item"] and out["item"] not in sv.item_table():
            raise Refused(f"non c'è lo strumento {out['item']}")
    if "moves" in a:
        moves = [number(m, 0, len(sv.move_table()) - 1, "mossa") for m in a["moves"]]
        moves = [m for m in moves if m]
        if len(moves) > 4 or len(set(moves)) != len(moves):
            raise Refused("al massimo quattro mosse, tutte diverse")
        out["moves"] = moves
    if "ivs" in a:
        out["ivs"] = [number(v, 0, 31, "IV") for v in a["ivs"]]
    if "evs" in a:
        out["evs"] = [number(v, 0, 255, "EV") for v in a["evs"]]
        if sum(out["evs"]) > 510:
            raise Refused("gli EV sono al massimo 510 in tutto")
    if "friendship" in a:
        out["friendship"] = number(a["friendship"], 0, 255, "amicizia")
    for key in ("ivs", "evs"):
        if key in out and len(out[key]) != 6:
            raise Refused(f"{key}: sei valori")
    return out


def changed(fields, now):
    """Only what differs, so that a field left alone is not rewritten -- a
    level sent back unchanged would put the experience at the level's floor."""
    if now is None or not now["ok"]:
        raise Refused("qui non c'è un Pokémon leggibile")
    current = {"species": now["species"], "level": now["level"], "nature": now["nature"], "item": now["item"],
               "moves": [m["id"] for m in now["moves"]], "ivs": now["ivs"], "evs": now["evs"],
               "friendship": now["friendship"]}
    return {k: v for k, v in fields.items() if v != current[k]}


def created(save, a, party):
    fields = checked_mon(a)
    if "species" not in fields or "level" not in fields:
        raise Refused("servono specie e livello")
    raw = sv.new_mon(fields["species"], fields["level"], sv.owner(save), nature=fields.get("nature"),
                     moves=fields.get("moves") or None, item=fields.get("item", 0),
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


def tables():
    """The names the page searches: species, moves, items, natures, maps."""
    return {"species": sv.species_table(), "moves": sv.move_table(),
            "items": list(sv.item_table().values()), "natures": sv.bank(sv.NATURE_NAMES),
            "maps": list(sv.map_table().values()), "dex": sv.dex_species(),
            "pockets": [[name, count] for name, count in sv.POCKETS]}


# ---------------------------------------------------------------------------
# HTTP.


class Handler(http.server.BaseHTTPRequestHandler):
    library = None
    port = None

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
        url = urllib.parse.urlsplit(self.path)
        q = {k: v[-1] for k, v in urllib.parse.parse_qs(url.query).items()}
        try:
            if url.path in ("/", "/index.html"):
                return self.reply(200, PAGE.read_bytes(), "text/html; charset=utf-8")
            if url.path == "/api/state":
                return self.reply(200, {"melonds": melonds_running()})
            if url.path == "/api/library":
                return self.reply(200, self.library.listing())
            if url.path == "/api/data":
                return self.reply(200, tables())
            if url.path == "/api/save":
                return self.reply(200, self.library.detail(q.get("f")))
            if url.path == "/api/flags":
                path, _, _ = self.library.locate(q.get("f"))
                return self.reply(200, sv.find_flags(self.library.open(path), q.get("q", "")))
            if url.path == "/api/learnset":
                species = number(q.get("species"), 1, len(sv.personal_records()) - 1, "specie")
                return self.reply(200, sv.learnset(species, number(q.get("level"), 1, 100, "livello")))
            if url.path == "/api/icon":
                png = icon(number(q.get("species"), 0, 0xFFFF, "specie"), number(q.get("form", 0), 0, 255, "forma"),
                           q.get("egg") in ("1", "true"))
                return self.reply(200, png, "image/png", cache=True)
            return self.reply(404, {"error": "non trovato"})
        except Refused as e:
            return self.reply(400, {"error": str(e)})
        except Exception as e:
            return self.reply(500, {"error": f"{type(e).__name__}: {e}"})

    def do_POST(self):
        if not self.trusted() or not self.headers.get("Content-Type", "").startswith("application/json"):
            return self.reply(403, {"error": "richiesta non ammessa"})
        try:
            body = json.loads(self.rfile.read(int(self.headers.get("Content-Length", 0))) or b"{}")
            lib, path = self.library, urllib.parse.urlsplit(self.path).path
            if path == "/api/edit":
                return self.reply(200, lib.edit(body.get("f"), body.get("op"), body.get("args") or {}))
            if path == "/api/undo":
                return self.reply(200, lib.undo(body.get("f")))
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
                lib.load(body.get("f"), body.get("slot"))
                return self.reply(200, {})
            if path == "/api/take":
                return self.reply(200, {"f": lib.take(body.get("slot"), body.get("name"))})
            if path == "/api/play":
                lib.play(body.get("f"), body.get("slot"))
                return self.reply(200, {})
            return self.reply(404, {"error": "non trovato"})
        except Refused as e:
            return self.reply(400, {"error": str(e)})
        except Exception as e:
            return self.reply(500, {"error": f"{type(e).__name__}: {e}"})


def serve(library, build, port):
    """The server on 127.0.0.1, on `port` or the next free one of ten."""
    for candidate in range(port, port + 10) if port else [0]:
        try:
            server = http.server.ThreadingHTTPServer(("127.0.0.1", candidate), Handler)
            break
        except OSError:
            continue
    else:
        raise SystemExit(f"no free port from {port} to {port + 9}")
    Handler.library = Library(library, build)
    Handler.port = server.server_address[1]
    return server


def main():
    parser = argparse.ArgumentParser(description=__doc__.split("\n\n")[0])
    parser.add_argument("--library", type=Path, default=Path.home() / "hgss-saves",
                        help="the folder of .sav files, ~/hgss-saves by default")
    parser.add_argument("--port", type=int, default=8765,
                        help="8765 by default; if it is taken, the next free one of ten")
    parser.add_argument("--no-browser", action="store_true", help="print the address instead of opening it")
    parser.add_argument("--build", type=Path, default=ROOT / "build",
                        help="the folder holding heartgold.us, heartgold.us.diag and the rest")
    parser.add_argument("--dry-run-launch", action="store_true",
                        help="Gioca prints the melonDS command instead of running it (or SAVEUI_DRY_RUN=1)")
    args = parser.parse_args()
    if args.dry_run_launch:
        os.environ["SAVEUI_DRY_RUN"] = "1"
    if not args.library.is_dir():
        raise SystemExit(f"{args.library} is not a folder")
    server = serve(args.library, args.build, args.port)
    url = f"http://127.0.0.1:{Handler.port}/"
    print(f"save editor on {url} -- library {Handler.library.root}, build {Handler.library.build}"
          f"{' (launches simulated)' if dry_run() else ''}; Ctrl+C to stop")
    if not args.no_browser:
        webbrowser.open(url)
    try:
        server.serve_forever()
    except KeyboardInterrupt:
        pass


if __name__ == "__main__":
    main()
