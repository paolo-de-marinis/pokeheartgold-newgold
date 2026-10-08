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
layout is measured (build/heartgold.us; with no build there, a clone, it is
save_layout.json's). Everything is read and written through savedit.py.

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
# What this editor's code is -- its own files and the tools' modules savedit
# borrows: a server running older code answers with another, and a new start
# replaces it instead of opening its page.
CODE = hashlib.sha1(b"".join(f.read_bytes() for f in (
    Path(__file__).resolve(), HERE / "saveui.html", HERE / "savedit.py", HERE / "harness/save_budget.py",
    *(ROOT / "tools/newgold/import" / f"{name}.py" for name in ("wotbl", "import_moves", "gmm"))))).hexdigest()[:12]
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
# Beside a file's backups: for each story step run here, what it found
# (savedit.record), so that taking it back puts that back; and for a step
# taken back without one, the variables it left.
STORY_RECORDS = "storia.json"


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


def icon_pair(species, form=0, egg=False):
    """GetMonIconNaixEx's icon and GetMonIconPaletteEx's palette entry for
    the Pokemon: (icon, palette entry)."""
    rules = icon_rules()
    first, last = rules["added"]
    if egg:
        return rules["egg"].get(species, rules["egg"][None])
    if species > rules["retail"]:
        return tuple(species - first + start for start in rules["first_added"]) if first <= species <= last else (rules["own"], 0)
    if species in rules["forms"] and 0 < form < rules["forms"][species][2]:
        return tuple(start + form - 1 for start in rules["forms"][species][:2])
    return species + rules["own"], species


def _icon_file(index, pal):
    """The icon's PNG (watched: a new icon moves the tree on) and its
    palette's 16 colours."""
    palette_of, colours = _icon_colours()
    number = palette_of[pal] if pal < len(palette_of) else 0
    return sv.source(ICONS / f"poke_icon_{index:08d}.png").read_bytes(), colours[16 * number:16 * number + 16]


def icon(species, form=0, egg=False):
    """GetMonIconNaixEx's icon for the Pokemon, with GetMonIconPaletteEx's palette."""
    return recolour(*_icon_file(*icon_pair(species, form, egg)))


@sv.tree_cache
def species_icon_cells():
    """Each distinct icon of a species (its first form, not an egg) once,
    and every species' cell of the sheet: ([(icon, palette entry)], {species: cell})."""
    pairs = {row["id"]: icon_pair(row["id"]) for row in sv.species_table()}
    distinct = sorted(set(pairs.values()))
    cell = {pair: i for i, pair in enumerate(distinct)}
    return distinct, {species: cell[pair] for species, pair in pairs.items()}


@sv.tree_cache
def species_icon_sheet():
    """The pickers' species icons, the first frame of each, 32x32,
    SHEET_COLUMNS to a row: one request where each row asked for its own.
    One whose file is not in the tree is left clear."""
    def drawn(pair):
        try:
            png, colours = _icon_file(*pair)
            return sv._png_rows(png)[0][:32], bytes(c for rgb in colours for c in rgb)
        except (OSError, ValueError):
            return [], b""
    return sheet([drawn(pair) for pair in species_icon_cells()[0]], SHEET_COLUMNS, 32, 32)


def chunk(kind, body):
    """A PNG chunk."""
    return struct.pack(">I", len(body)) + kind + body + struct.pack(">I", zlib.crc32(kind + body))


def recolour(png, colours):
    """The PNG with this palette, colour 0 transparent as the game draws it."""
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
# The items' icons and the marks of the moves' classes: the game's pictures,
# each set one sheet the page asks for once (an icon a cell of it).

ITEM_ICONS = ROOT / "files/itemtool/itemdata/item_icon"
SHEET_COLUMNS = 32      # the item and species sheets' cells a row


@sv.tree_cache
def item_icon_members():
    """GetItemIndexMapping's icon for each item: the members of
    item_icon.narc it draws with, (tiles, palette) -- sItemNarcIds' row for
    HeartGold's own numbers, sImportedItemIcons' member (its palette the
    next) after them, and where that says none, or for a number neither
    has, the blank pair ITEM_NONE's row gives."""
    text = sv.source("src/item.c").read_text()
    blank = tuple(int(n) for n in re.search(
        r"return icon \? icon : NARC_item_icon_item_icon_(\d+)_NCGR;\s*case ITEMNARC_NCLR:\s*"
        r"return icon \? icon \+ 1 : NARC_item_icon_item_icon_(\d+)_NCLR;", sv.c_function("src/item.c", "int GetItemIndexMapping(")).groups())
    items = sv.constants("include/constants/items.h", "ITEM_")
    out = {items[c]: (int(t), int(p)) for c, t, p in re.findall(
        r"\[(ITEM_\w+)\] = \{\s*NARC_item_data_\d+_bin,\s*NARC_item_icon_item_icon_(\d+)_NCGR,\s*NARC_item_icon_item_icon_(\d+)_NCLR,", text)
        if c in items}
    first = sv.constants("include/constants/items.h", "FIRST_IMPORTED_")["FIRST_IMPORTED_ITEM"]
    table = text[text.index("sImportedItemIcons["):]
    table = re.sub(r"//.*", "", table[table.index("{") + 1:table.index("};")])
    out.update({first + i: (icon, icon + 1) if icon else blank for i, icon in enumerate(int(n) for n in re.findall(r"\d+", table))})
    return {item: out.get(item, blank) for item in sv.item_table()}


@sv.tree_cache
def _item_icon_pngs():
    """The members item_data.mk builds from a PNG of the icon folder
    (ITEMICON_FROM_PNG), tiles and palette both: {member: the PNG's name}."""
    out = {}
    for tiles, colours, name in re.findall(r"call ITEMICON_FROM_PNG,(\d+),(\d+),(\w+)\)",
                                           sv.source("files/itemtool/itemdata/item_data.mk").read_text()):
        out[int(tiles)] = out[int(colours)] = name
    return out


def _ncgr(data, wide):
    """An NCGR's 4-bit tiles as rows of colour indices, `wide` tiles a row
    as a sprite mapped in one dimension lays them out."""
    at = data.index(b"RAHC")
    size, offset = struct.unpack_from("<II", data, at + 24)
    tiles = data[at + 8 + offset:at + 8 + offset + size]
    rows = [bytearray(8 * wide) for _ in range(8 * (size // 32 // wide))]
    for i, byte in enumerate(tiles):
        tile, y, x = i // 32, i % 32 // 4, i % 4 * 2
        rows[tile // wide * 8 + y][tile % wide * 8 + x:tile % wide * 8 + x + 2] = bytes((byte & 15, byte >> 4))
    return rows


def _palette(nclr, number):
    """Palette `number` (16 colours) of an NCLR, as a PNG's PLTE. (The
    battle archive's says it holds more than it does: its count is not
    read.)"""
    at = nclr.index(b"TTLP")
    colours = struct.unpack_from("<16H", nclr, at + 8 + struct.unpack_from("<I", nclr, at + 20)[0] + 32 * number)
    return b"".join(bytes((c >> shift & 31) * 255 // 31 for shift in (0, 5, 10)) for c in colours)


def _lz10(data):
    """The game's LZ77 compression (type 0x10) undone."""
    size, out, at = int.from_bytes(data[1:4], "little"), bytearray(), 4
    while len(out) < size:
        flags, at = data[at], at + 1
        for bit in range(8):
            if len(out) >= size:
                break
            if flags & 0x80 >> bit:
                pair, at = data[at] << 8 | data[at + 1], at + 2
                for _ in range((pair >> 12) + 3):
                    out.append(out[-(pair & 0xFFF) - 1])
            else:
                out.append(data[at])
                at += 1
    return bytes(out)


def item_icon(tiles, colours):
    """An item's icon as the bag draws it: 32 rows of 32 colour indices,
    and its palette as a PLTE -- the members' files, or the PNG item_data.mk
    builds a member from."""
    pngs = _item_icon_pngs()
    png = lambda name: sv._png_rows(sv.source(ITEM_ICONS / f"{name}.png").read_bytes())  # noqa: E731
    rows = png(pngs[tiles])[0] if tiles in pngs else _ncgr(sv.source(ITEM_ICONS / f"item_icon_{tiles:03d}.NCGR").read_bytes(), 4)
    return rows, png(pngs[colours])[1] if colours in pngs else _palette(sv.source(ITEM_ICONS / f"item_icon_{colours:03d}.NCLR").read_bytes(), 0)


def sheet(images, columns, width, height):
    """Images (rows of colour indices and a PLTE each) as one RGBA PNG,
    `columns` cells a row, colour 0 clear as the game draws it."""
    rows = [bytearray(4 * columns * width) for _ in range(height * -(-len(images) // columns))]
    for i, (pixels, palette) in enumerate(images):
        rgba = [b"\0\0\0\0"] + [palette[3 * c:3 * c + 3].ljust(3, b"\0") + b"\xff" for c in range(1, 16)]
        x, y = i % columns * width * 4, i // columns * height
        for line, row in zip(pixels[:height], rows[y:y + height]):
            row[x:x + 4 * width] = b"".join(rgba[p & 15] for p in line[:width])
    return (b"\x89PNG\r\n\x1a\n" + chunk(b"IHDR", struct.pack(">IIBBBBB", columns * width, len(rows), 8, 6, 0, 0, 0))
            + chunk(b"IDAT", zlib.compress(b"".join(b"\0" + bytes(r) for r in rows), 9)) + chunk(b"IEND", b""))


@sv.tree_cache
def item_icon_cells():
    """Each distinct item icon once, in the members' order, and every
    item's cell of the sheet: ([(tiles, palette)], {item: cell})."""
    members = item_icon_members()
    pairs = sorted(set(members.values()))
    cell = {pair: i for i, pair in enumerate(pairs)}
    return pairs, {item: cell[pair] for item, pair in members.items()}


@sv.tree_cache
def item_icon_sheet():
    """Every item icon, 32x32, SHEET_COLUMNS to a row; one whose files are
    not in the tree is left clear."""
    def drawn(pair):
        try:
            return item_icon(*pair)
        except (OSError, ValueError):
            return [], b""
    return sheet([drawn(pair) for pair in item_icon_cells()[0]], SHEET_COLUMNS, 32, 32)


@sv.tree_cache
def move_class_sheet():
    """The marks the summary and the battle draw for a move's class, one
    under the other in CATEGORY_'s order: sub_02077800's member of the
    archive sub_02077830 names, in sub_02077818's palette of the member
    sub_02077690 gives, as large as sub_02077694's cell draws it (its one
    OAM's shape and size)."""
    text = sv.source("src/unk_02077678.c").read_text()
    table = lambda name: [int(n, 0) for n in re.search(rf"{name}\[\] = \{{([^}}]*)\}}", text).group(1).split(",") if n.strip()]  # noqa: E731
    returns = lambda fn: re.search(rf"\b{fn}\(void\) \{{\s*return (\w+);", text).group(1)  # noqa: E731
    sys.path.insert(0, str(ROOT / "tools/newgold/import"))
    import wotbl
    members, _, _ = wotbl.read_narc(sv.source("files/" + returns("sub_02077830")[len("NARC_"):].replace("_", "/")).read_bytes())
    unpack = lambda m: _lz10(members[m]) if members[m][0] == 0x10 else members[m]  # noqa: E731
    cell = unpack(int(returns("sub_02077694"), 0))
    at = cell.index(b"KBEC")
    count, bounded, cells = struct.unpack_from("<HHI", cell, at + 8)
    attr0, attr1 = struct.unpack_from("<HH", cell, at + 8 + cells + (16 if bounded else 8) * count)
    width, height = {0: ((8, 8), (16, 16), (32, 32), (64, 64)), 1: ((16, 8), (32, 8), (32, 16), (64, 32)),
                     2: ((8, 16), (8, 32), (16, 32), (32, 64))}[attr0 >> 14][attr1 >> 14]     # the DS's OAM sizes
    nclr = unpack(int(returns("sub_02077690"), 0))
    return sheet([(_ncgr(unpack(m), width // 8), _palette(nclr, p))
                  for m, p in zip(table("sMoveSplitIconFiles"), table("sMoveSplitIconPalettes"))], 1, width, height)


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
        """Why the save's layout cannot be read -- from the build, or with
        none (a clone) from save_layout.json -- None when it can: without it
        no file can be read, which is not the files' fault (a rebuild under
        way)."""
        try:
            sv.blocks(self.layout)
        except (Exception, SystemExit) as e:
            return (f"il formato del salvataggio non si legge da {sv.linked(self.layout) or sv.save_budget.LAYOUT} "
                    f"({type(e).__name__}: {e}): se make sta ricostruendo la build, riprova quando ha finito.")
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
                "layout_file": [] if problem else sv.layout_file_differs(self.layout),
                "playable": [s["slot"] for s in slots if not s["problem"] and self.playable(s["slot"])],
                "configured": CONFIG.exists(),
                "melonds": melonds_running()}

    def detail(self, f):
        path, key, is_slot = self.locate(f)
        if not path.exists():
            raise Refused("il file non c'è")
        save, errors = self.open(path), {}
        return {"f": f, "path": str(path), "slot": is_slot, "mtime": path.stat().st_mtime, "version": version(path),
                "profile": sv.profile(save), "party": [sv.describe_mon(raw) for raw in sv.party_raw(save)],
                "boxes": sv.boxes(save), "bag": sv.bag(save), "dex": sv.dex(save),
                "position": position_of(save), "info": sv.info(save), "backups": self.history(key),
                "given": part(errors, "given", lambda: given(save), {"shoes": False, "pokegear": {"cards": 0, "map_level": 0},
                                                                     "level_cap": 0, "milestones": [], "menu": {}}),
                "story": part(errors, "story", lambda: {**sv.story_state(save), "left": self.story_left(key, save)},
                              {"done": [], "met": {}, "left": {}}),
                "places": part(errors, "places", lambda: [sv.place_state(save, p) for p in sv.story_places()], []),
                "errors": errors}

    def story_records(self, key):
        try:
            records = json.loads((self.backups / key / STORY_RECORDS).read_text())
            return records if isinstance(records, dict) else {}
        except (OSError, ValueError):
            return {}

    def keep_story_records(self, key, records):
        folder = self.backups / key
        folder.mkdir(parents=True, exist_ok=True)
        partial = folder / f".{STORY_RECORDS}.tmp"
        partial.write_text(json.dumps(records, indent=1, ensure_ascii=False))
        os.replace(partial, folder / STORY_RECORDS)

    def story_left(self, key, save):
        """The variables steps taken back left, while they still hold it."""
        names = sv.constants("include/constants/vars.h", "VAR_")
        out = {}
        for sid, record in self.story_records(key).items():
            still = [[name, value] for name, value in record.get("left", [])
                     if name in names and sv.var_value(save, names[name]) == value]
            if still:
                out[sid] = still
        return out

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
            path, key, _ = self.locate(f)
            if seen is not None and seen != self.current(f):
                raise Refused(STALE, "stale")
            save = self.open(path)
            self.editing = key
            try:
                report = handler(save, args)
            except sv.Illegal as e:
                raise Refused(illegal(e))
            except (KeyError, TypeError) as e:
                raise Refused(f"richiesta incompleta: {e}")
            except (ValueError, SystemExit) as e:
                raise Refused(italian(str(e)))
            data = save.image()
            changed = data != path.read_bytes()
            if changed:
                self.write(f, data)
            return {**self.detail(f), "changed": changed, **({"report": report} if report is not None else {})}

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
        limits = {"money": (sv.MAX_MONEY, "soldi"), "johto": (255, "medaglie di Johto"),
                  "kanto": (255, "medaglie di Kanto"), "coins": (sv.MAX_COINS, "gettoni")}
        values = {k: number(a[k], 0, high, what) for k, (high, what) in limits.items() if k in a}
        if "gender" in a:
            values["gender"] = number(a["gender"], 0, 0xFF, "genere")
            if values["gender"] not in (sv.PLAYER_GENDER_MALE, sv.PLAYER_GENDER_FEMALE):
                raise Refused(f"genere: {sv.PLAYER_GENDER_MALE} o {sv.PLAYER_GENDER_FEMALE}")
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
        changes = holdable(storable(changed(checked_mon(a), sv.describe_mon(raw))), party=True)
        sv.set_party_mon(save, slot, sv.edit_mon(raw, **changes))     # with none, PP down to the maximum

    def op_party_add(self, save, a):
        if len(sv.party_raw(save)) >= sv.PARTY_SIZE:
            raise Refused(f"la squadra è piena: sei già a {sv.PARTY_SIZE} Pokémon")
        sv.add_party_mon(save, created(save, a, party=True))

    def op_party_remove(self, save, a):
        slot = number(a["slot"], 0, sv.PARTY_SIZE - 1, "posto")
        last_one(save)
        if not any(sv.can_battle(raw) for i, raw in enumerate(sv.party_raw(save)) if i != slot):
            raise Refused(italian("the party would have no Pokemon able to battle"))
        sv.remove_party_mon(save, slot)

    def op_party_swap(self, save, a):
        sv.swap_party_mons(save, number(a["a"], 0, sv.PARTY_SIZE - 1, "posto"), number(a["b"], 0, sv.PARTY_SIZE - 1, "posto"))

    def op_box_edit(self, save, a):
        box, slot = number(a["box"], 0, sv.NUM_BOXES - 1, "box"), number(a["slot"], 0, sv.MONS_PER_BOX - 1, "posto")
        raw = sv.box_raw(save, box, slot)
        changes = holdable(storable(changed(checked_mon(a), sv.describe_mon(raw))), party=False)
        sv.set_box_mon(save, box, slot, sv.edit_mon(raw, **changes))     # with none, PP down to the maximum

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
            if "left empty" in str(e):
                raise Refused(italian("the party would have no Pokemon able to battle"))
            raise

    def op_item(self, save, a):
        """One item's count in the bag; `pocket`, the pocket the page shows,
        refuses an item the game files in another one."""
        item = number(a["item"], 1, 0xFFFF, "strumento")
        entry = in_pocket(item, a.get("pocket"))
        limit = sv.item_limit(item)
        quantity = number(a["quantity"], 0, limit, f"{entry['name']}, quantità" +
                          (" (una MT è una sola: New Gold non le consuma)" if limit == 1 else ""))
        held = sv.bag(save)[entry["pocket"]]
        if quantity and item not in {i["item"] for i in held} and len(held) >= sv.pocket_at(entry["pocket"], save.layout)[1]:
            raise Refused(f"la tasca è piena ({len(held)} posti): togline uno prima")
        sv.set_item(save, item, quantity)

    def op_pocket(self, save, a):
        """A pocket's list saved at once -- the key items' checklist, a small
        pocket's counts: each item from 0 to its limit, written as the game
        keeps the pocket (set_item), refused for another pocket's item and
        past the pocket's slots. Removals first, so that a swap never finds
        the pocket full."""
        pocket = a.get("pocket")
        if pocket not in {p["name"] for p in sv.pockets()}:
            raise Refused("tasca sconosciuta")
        wanted = {}
        for change in a["changes"]:
            item = number(change["item"], 1, 0xFFFF, "strumento")
            entry, limit = in_pocket(item, pocket), sv.item_limit(item)
            wanted[item] = number(change["quantity"], 0, limit, f"{entry['name']}, quantità" +
                                  (" (una MT è una sola: New Gold non le consuma)" if limit == 1 else ""))
        held = {slot["item"]: slot["quantity"] for slot in sv.bag(save)[pocket]}
        slots, used = sv.pocket_at(pocket, save.layout)[1], sum(1 for q in {**held, **wanted}.values() if q)
        if used > slots:
            raise Refused(f"la tasca ha {slots} posti: ne servirebbero {used}. Togline {used - slots} prima")
        for item, quantity in sorted(wanted.items(), key=lambda kv: kv[1] != 0):
            if held.get(item, 0) != quantity:
                try:
                    sv.set_item(save, item, quantity)
                except ValueError as e:
                    if "before TM93 to TM148" not in str(e):
                        raise
                    raise Refused(f"{sv.item_table()[item]['name']}: il salvataggio è di prima delle MT93–MT148 e "
                                  "tiene le macchine di hg-engine; nessuna di loro diventa questa. Caricalo nel gioco "
                                  "e salvalo, poi aggiungila")

    def op_dex(self, save, a):
        for change in a["changes"]:
            species = number(change["id"], 1, 0xFFFF, "specie")
            if species in sv.dex_forms():
                if not save.has_form_record:
                    raise Refused("il salvataggio è in un formato più vecchio, senza il registro delle forme: "
                                  "il gioco lo aggiunge quando lo carica")
                sv.set_form_record(save, species, bool(change["seen"]), bool(change["caught"]))
                continue
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
        """The player put on a map. With a place of the story (Posizione's
        "Davanti a…"), in the same change: the story steps to run or take
        back first ("run", "undo", as op "story"), the flag that hides the
        person there cleared ("show": a place's own hide flag), and the
        map's sight trainers given as beaten ("beat": a place's
        "trainers" on that map), so that the walk to the person is no
        battle on the way."""
        report = self.op_story(save, a) if a.get("run") or a.get("undo") else None
        names = sv._script_names()[0]
        for flag in a.get("show", []):
            if not any(p["hide"] == [flag] for p in sv.story_places()):
                raise Refused(f"{flag} non è il flag che nasconde una persona davanti a cui mettersi")
            sv.write_flag(save, names[flag], False)
        sight = {t for p in sv.story_places() if p["map"] == a.get("map") for t, _ in p["trainers"]}
        for trainer in a.get("beat", []):
            if trainer not in sight:
                raise Refused(f"{trainer} non è un allenatore di questa mappa")
            sv._apply(save, ("trainer", trainer, 1))
        self.put(save, a)
        if a.get("cap") or a.get("lower"):     # the cap the story steps above leave
            self.op_party_cap(save, {"raise": bool(a.get("cap")), "lower": bool(a.get("lower"))})
        return report

    def op_party_cap(self, save, a):
        """The party (not an Egg) at the level cap the save's badges and
        story make (savedit.level_cap), its moves kept: the Pokemon below it
        raised ("raise", by default), and with "lower" the ones above it
        brought down -- which the page asks first, naming them."""
        cap, up, down = sv.level_cap(save), a.get("raise", True), a.get("lower", False)
        for slot, raw in enumerate(sv.party_raw(save)):
            mon = sv.describe_mon(raw)
            if mon and mon["ok"] and not mon["egg"] and (up and mon["level"] < cap or down and mon["level"] > cap):
                sv.set_party_mon(save, slot, sv.edit_mon(raw, level=cap))

    def put(self, save, a):
        where = number(a["map"], 0, 0xFFFF, "mappa")
        if where not in sv.map_table() or not standable(where):
            raise Refused(f"la mappa {where} non è un luogo dove stare")
        x, y = number(a["x"], 0, 0xFFFF, "x"), number(a["y"], 0, 0xFFFF, "y")
        name = sv.map_table()[where]["name"] or sv.map_table()[where]["const"]
        if not sv.on_map(where, x, y):
            (x0, x1), (y0, y1) = span(where)
            raise Refused(f"({x}, {y}) è fuori da {name}: lì il gioco lascerebbe "
                          f"il giocatore nel nero. La mappa sta tra x {x0}–{x1} e y {y0}–{y1}.")
        problem = sv.tile_problem(where, x, y)
        if problem:
            safe = sv.preset(where)
            raise Refused(f"({x}, {y}) in {name} ({sv.map_table()[where]['const']}) {TILE_PROBLEMS[problem]}. " + (
                f"Il gioco mette il giocatore in ({safe['x']}, {safe['y']}), {ARRIVALS[safe['how']]}: scegli di nuovo la "
                f"mappa (elenco o minimappa) e la trovi già scritta." if safe else "Scegli un'altra casella."))
        sv.set_position(save, where, x, y, number(a.get("direction", 0), 0, sv.DIR_MAX - 1, "direzione"))

    def op_story(self, save, a):
        """Story steps run as the game runs them ("run", in order) or taken
        back ("undo", in order): what each wrote, and the variables an undo
        left as they were. What a run found is kept beside the backups, and
        a step taken back puts it back (savedit.undo_step)."""
        steps = {s["id"]: s for s in sv.story()}
        for sid in list(a.get("run", [])) + list(a.get("undo", [])):
            if sid not in steps:
                raise Refused(f"non c'è il passo della storia {sid}")
        report, records = {"ran": {}, "left": {}}, self.story_records(self.editing)
        for sid in a.get("undo", []):
            done = records.pop(sid, {})
            left = sv.undo_step(save, sid, done if "found" in done else None)
            if left:
                report["left"][sid] = left
                records[sid] = {"left": left}
        for sid in a.get("run", []):
            found = {}
            report["ran"][sid] = sv.run_step(save, sid, found)
            records[sid] = sv.record(save, found)
        # Kept before the file is written: a record whose run never reached
        # the file does not match it, and undo_step passes it over.
        self.keep_story_records(self.editing, records)
        return report

    def op_menu(self, save, a):
        icon = a.get("icon")
        if icon not in {e["icon"] for e in sv.menu_unlocks()}:
            raise Refused(f"{icon} non è una voce del menu che si ottiene")
        sv.set_menu_unlock(save, icon, bool(a["on"]))

    def op_pokegear(self, save, a):
        cards = sum(c["value"] for c in sv.pokegear_cards()["cards"])
        sv.set_pokegear(save, cards=number(a["cards"], 0, cards, "schede") & cards if "cards" in a else None,
                        map_level=number(a["map_level"], 0, sv.pokegear_cards()["map_levels"] - 1, "livello della mappa")
                        if "map_level" in a else None)

    def op_machines(self, save, a):
        """The machines' checklist: op_pocket on the TMs and HMs pocket, each
        machine at most once, sorted as SortTMHMPocket sorts them (set_item);
        an item that is no machine is refused as such."""
        table = {row["item"] for row in sv.machine_table()}
        for change in a["changes"]:
            if number(change["item"], 1, 0xFFFF, "macchina") not in table:
                raise Refused(f"lo strumento {change['item']} non è una MT o una MN")
        self.op_pocket(save, {"pocket": sv.item_table()[next(iter(table))]["pocket"], "changes": a["changes"]})

    def op_flag(self, save, a):
        sv.write_flag(save, number(a["number"], 1, sv.num_flags() - 1, "flag"), bool(a["value"]))

    def op_var(self, save, a):
        sv.write_var(save, number(a["number"], sv.VAR_BASE, sv.VAR_BASE + sv.NUM_VARS - 1, "variabile"),
                     number(a["value"], 0, 0xFFFF, "valore"))


# Why a tile is refused (savedit.tile_problem), and where a preset is from (savedit.ground's arrivals).
TILE_PROBLEMS = {"wall": "è una casella bloccata (un muro, un albero, un mobile, una sporgenza)",
                 "water": "è acqua: il giocatore ci starebbe in piedi",
                 "object": "è occupata da una persona o da un oggetto della mappa",
                 "apart": "è fuori dalle stanze in cui il gioco porta il giocatore (lo spazio vuoto attorno, o una "
                          "parte chiusa)"}
ARRIVALS = {"fly": "dove si arriva col Volo o con Teleport", "heal": "dove si ricompare dopo una sconfitta",
            "warp": "dove si arriva da una porta o da una scala", "door": "appena fuori da una porta",
            "edge": "dove si entra da una mappa vicina"}


def span(map_id):
    """The tiles a map's chunks cover, ((x from, to), (y from, to))."""
    chunks = sv.map_chunks(map_id)
    return tuple((min(c[i] for c in chunks) * size, (max(c[i] for c in chunks) + 1) * size - 1)
                 for i, size in ((0, sv.CHUNK_TILES), (1, sv.CHUNK_ROWS)))


def position_of(save):
    """The save's position, and the town map's tile the Pokégear marks it at
    (None when the town map does not read: /api/data says why)."""
    position = sv.position(save)
    now = position["current"]
    return {**position, "tile": part({}, "world", lambda: sv.town_tile(now["map"], now["x"], now["y"], (
        position["special"]["x"], position["special"]["y"])), None)}


def map_place(q):
    """What the page puts in for a map picked: where the game itself puts
    the player there (None when it puts the player nowhere the editor knows
    of), and the tiles the map covers."""
    map_id = number(q.get("map"), 0, 0xFFFF, "mappa")
    if map_id not in sv.map_table() or not standable(map_id):
        raise Refused(f"la mappa {map_id} non è un luogo dove stare")
    (x0, x1), (y0, y1) = span(map_id)
    preset = sv.preset(map_id)
    return {"map": map_id, "preset": preset and {**preset, "said": ARRIVALS[preset["how"]]}, "x": [x0, x1], "y": [y0, y1]}


def world():
    """The town map's size, and each map's tiles on it and whether the main
    matrix is its own (a tile of it is then the chunk it owns); and the map
    types that are a building's (MapHeader_IsInBuilding), which a click
    on a tile picks last; and the maps a blackout sends the player to (the
    heal spawns: the Pokémon Centers, and the few other places that are
    one)."""
    town, tiles, main = sv.town_map(), sv.town_tiles(), sv.main_matrix()[1]
    return {"cols": town["cols"], "rows": town["rows"], "buildings": sorted(sv.buildings()),
            "heals": sorted(m for m in sv.spawns()["heal"] if standable(m)),
            "tiles": {m: tiles.get(m, []) for m in sv.map_table() if standable(m)},
            "main": [m for m in sv.map_table() if standable(m) and sv._matrix_of().get(m) == main]}


def given(save):
    """What the player was given that the bag does not hold, and the level
    cap it all makes, with each of its milestones met or not (the page
    works out the cap a place's plan will leave)."""
    return {"shoes": sv.running_shoes(save), "pokegear": sv.pokegear(save), "level_cap": sv.level_cap(save),
            "milestones": sv.level_cap_reached(save),
            "menu": {e["icon"]: sv.running_shoes(save) if e.get("shoes") else sv.flag_is_set(save, e["flag"])
                     for e in sv.menu_unlocks()}}


def part(errors, name, read, empty):
    """One section of what the page gets, read on its own: a reader that
    fails -- a file renamed upstream, the art exported another way, a
    function renamed -- empties it and says why in `errors`, and the rest
    of the editor still loads."""
    try:
        return read()
    except Exception as e:
        errors[name] = f"{type(e).__name__}: {e}"
        return empty


def story_table():
    """The story's steps as the page shows them."""
    keep = ("id", "script", "line", "kind", "key", "battle", "trainer", "section", "writes", "needs", "badge", "order",
            "opens", "said")
    return [{k: step.get(k) for k in keep} for step in sv.story()]


def standable(map_id):
    """A map the player can be put on: not MAP_EVERYWHERE, which is the
    header of no place, one with chunks of its own, none the tree names as
    unused (MAP_GOLDENROD_UNUSED_1: leftovers with a header), and none where
    the game never leaves a save (savedit.nosave_maps: the Union Room, the
    Safari Zone, Pal Park, the Bug-Catching Contest's park)."""
    const = sv.map_table()[map_id]["const"] if map_id in sv.map_table() else ""
    return (map_id != sv.constants("include/constants/maps.h", "MAP_")["MAP_EVERYWHERE"] and bool(sv.map_chunks(map_id))
            and "_UNUSED" not in const and map_id not in sv.nosave_maps())


def in_pocket(item, pocket=None):
    """The item's row, refused when it goes in no pocket or -- `pocket`
    given, the one the page shows -- in another one."""
    entry = sv.item_table().get(item)
    if not entry or not entry["pocket"]:
        raise Refused("questo strumento non va in nessuna tasca")
    if pocket is not None and entry["pocket"] != pocket:
        raise Refused(f"{entry['name']} non va in questa tasca: il gioco lo tiene in un'altra")
    return entry


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
        if len(moves) > sv.MAX_MON_MOVES:
            raise Refused(f"al massimo {sv.MAX_MON_MOVES} mosse")
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
    if "hyper" in a:
        # Allenamento Pro: the stats that count as 31, the IVs kept (savedit.hyper_trained).
        if not isinstance(a["hyper"], list) or not all(isinstance(v, bool) for v in a["hyper"]):
            raise Refused("allenamento pro: un sì o un no per statistica")
        out["hyper"] = a["hyper"]
    if "ability" in a:
        out["ability"] = number(a["ability"], 0, sv.HIDDEN_SLOT, "abilità")
    for key in ("ivs", "evs", "hyper"):
        if key in out and len(out[key]) != sv.NUM_STATS:
            raise Refused(f"{key}: {sv.NUM_STATS} valori")
    return out


def changed(fields, now):
    """Only what differs, so that a field left alone is not rewritten -- a
    level sent back unchanged would put the experience at the level's floor.
    With a new species the moves and the ability sent are the new species'
    to check, even when they are the ones the Pokemon has; an ability slot
    is new, whatever it is, to a Pokemon whose ability is not its slot's."""
    if now is None or not now["ok"]:
        raise Refused("qui non c'è un Pokémon leggibile")
    current = {"species": now["species"], "level": now["level"], "nature": now["nature"], "item": now["item"],
               "moves": [m["id"] for m in now["moves"]], "ivs": now["ivs"], "evs": now["evs"], "hyper": now["hyper"],
               "friendship": now["friendship"], "ability": now["ability_slot"] if now["ability_ok"] else None}
    out = {k: v for k, v in fields.items() if v != current[k]}
    if "species" in out:
        out.update({k: fields[k] for k in ("moves", "ability") if k in fields})
    return out


def illegal(e):
    """savedit's Illegal in Italian, naming what the species cannot have."""
    who = sv.species_name(e.species)
    if e.twice:
        return (f"{sv.move_table()[e.twice]['name']} compare due volte: il gioco non insegna una mossa che il Pokémon "
                f"conosce già, scegline un'altra")
    if e.moves:
        return (f"{who} non può imparare {', '.join(sv.move_table()[m]['name'] for m in e.moves)}: non è tra le "
                f"mosse della specie (livello, MT/MN, insegnanti, mosse uovo, forma, pre-evoluzioni). Una mossa "
                f"che solo un evento o un regalo dà resta su un Pokémon che la conosce già, non si aggiunge")
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


def holdable(fields, party):
    """An item a Pokemon is given here only as the bag gives one (savedit's
    "give": GIVE is offered for no key item, no machine, no Apricorn) --
    and never a key item, whatever its prevent_toss says (hg-engine's
    record left it off 45, the Teal Mask among them), nor an item with no name (hg-engine's
    ITEM_NONE_ placeholders) -- and no Mail in a box: the PC takes no
    Pokemon holding one. One it holds already is not sent again (changed)."""
    item = fields.get("item")
    if item:
        entry = sv.item_table()[item]
        if not entry["name"].strip():
            raise Refused(f"lo strumento {item} non ha nome: è un posto vuoto della tabella, non uno strumento")
        if not entry["give"] or entry["pocket"] == key_pocket():
            raise Refused(f"{entry['name']}: nel gioco non si dà da tenere a un Pokémon (la Borsa non offre DAI "
                          "per gli strumenti chiave, le MT e MN e le Ghicocche)")
        if not party and sv.FIRST_MAIL <= item <= sv.LAST_MAIL:
            raise Refused(f"{entry['name']}: un Pokémon nel box non tiene Lettere (il PC non lo accetta)")
    return fields


# savedit's refusals, in the page's Italian; one not here is shown as it is.
ITALIAN = [
    (r"the party has no slot (\d+)", r"la squadra non ha il posto \1"),
    (r"no such party slot", "la squadra non ha quel posto"),
    (r"a party holds (\d+)", r"la squadra è piena: ha già \1 Pokémon"),
    (r"the party cannot be left empty", "la squadra non può restare vuota"),
    (r"the party would have no Pokemon able to battle",
     "in squadra deve restare almeno un Pokémon che possa lottare (non un uovo e non esausto)"),
    (r"a Pokemon holding Mail does not go in a box",
     "un Pokémon che tiene una Lettera non va nel box (il PC non lo accetta): togli prima la Lettera"),
    (r"box (\d+) slot (\d+) is taken", r"box \1, posto \2: è occupato"),
    (r"box (\d+) slot (\d+) is empty", r"box \1, posto \2: è vuoto"),
    (r"that slot holds nothing that can be taken", "in quel posto non c'è un Pokémon da prendere"),
    (r"the boxes are 1 to (\d+), their slots 1 to (\d+)", r"i box vanno da 1 a \1, i posti da 1 a \2"),
    (r"there is no Pokemon here to change, or its checksum is wrong",
     "qui non c'è un Pokémon da modificare, o non si legge (checksum errato)"),
    (r"a level is 1 to (\d+)", r"il livello va da 1 a \1"),
    (r"there is no species (\d+)", r"non c'è la specie \1"),
    (r"item (\d+) goes in no pocket", "questo strumento non va in nessuna tasca"),
    (r"the \w+ pocket is full", "la tasca è piena: togline uno prima"),
    (r"(.+): 0 to (\d+)$", r"\1: da 0 a \2"),
    (r"there is no story step (.+)", r"non c'è il passo della storia \1"),
]


def italian(message):
    for pattern, said in ITALIAN:
        if re.fullmatch(pattern, message):
            return re.sub(pattern, said, message)
    return message


def created(save, a, party):
    """A new Pokemon; with no moves given, the ones the species knows at
    that level."""
    fields = holdable(storable(checked_mon({k: v for k, v in a.items() if k != "moves" or v})), party)
    if "species" not in fields or "level" not in fields:
        raise Refused("servono specie e livello")
    if sv.EOS not in sv.owner(save)["codes"]:
        # A save sealed from RAM before the name was chosen: the Pokemon's
        # original trainer would be a name with no end, which the game
        # asserts on (CopyU16ArrayToString).
        raise Refused("il giocatore non ha ancora un nome: daglielo nella scheda Allenatore, poi aggiungi il Pokémon")
    raw = sv.new_mon(fields["species"], fields["level"], sv.owner(save), nature=fields.get("nature"),
                     moves=fields.get("moves"), item=fields.get("item", 0), ability=fields.get("ability"),
                     ivs=fields.get("ivs", 31), evs=fields.get("evs", 0), party=party)
    if "friendship" in fields:
        raw = sv.edit_mon(raw, friendship=fields["friendship"])
    if any(fields.get("hyper", ())):
        raw = sv.edit_mon(raw, hyper=fields["hyper"])
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
        d, width = mon["blocks"][3], sv.PLAYER_NAME_LENGTH + 1
        codes = list(struct.unpack_from(f"<{width}H", d, 0))
        codes = codes[:codes.index(sv.EOS) + 1] if sv.EOS in codes else codes
        a = mon["blocks"][0]
        if (codes, struct.unpack_from("<I", a, 4)[0], d[0x1C] >> 7) != (before["codes"], before["id"], before["gender"]):
            return None
        d[0:2 * width] = struct.pack(f"<{width}H", *(after["codes"] + [0] * (width - len(after["codes"]))))
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


def key_pocket():
    return next(p["name"] for p in sv.pockets() if p["const"] == "POCKET_KEY_ITEMS")


def offers(pocket):
    """What a pocket's lists offer: its own items only, by id -- those this
    game has ("items"), then the other games' ("others"), which the page
    shows only when asked; never one with no name (the 84 ITEM_NONE_
    placeholders of hg-engine's table)."""
    rows = [row for row in sv.item_table().values() if row["pocket"] == pocket and row["id"] and row["name"].strip()]
    return {"items": [row["id"] for row in rows if row["game"]], "others": [row["id"] for row in rows if not row["game"]]}


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
    errors = {}
    story, chains = part(errors, "story", lambda: (story_table(), sv.badge_chains()), ([], {}))
    field_moves = lambda: {badge: [sv.move_numbers()[m[len("MOVE_"):]] for m in moves if m[len("MOVE_"):] in sv.move_numbers()]
                           for badge, moves in sv.field_move_badges().items()}
    players = {"PLAYER_GENDER_MALE": sv.PLAYER_GENDER_MALE, "PLAYER_GENDER_FEMALE": sv.PLAYER_GENDER_FEMALE}
    types = lambda row: list(dict.fromkeys(t[len("TYPE_"):] for t in sv.personal_records()[row["id"]]["types"]))  # noqa: E731
    icons = part(errors, "item_icons", lambda: item_icon_cells()[1], {})
    species_icons = part(errors, "species_icons", lambda: species_icon_cells()[1], {})
    classes = sorted(sv.constants("include/constants/moves.h", "CATEGORY_").items(), key=lambda kv: kv[1])
    return {"species": [{**row, "types": types(row), "icon": species_icons.get(row["id"])} for row in sv.species_table()],
            "moves": sv.move_table(),
            "move_classes": [const[len("CATEGORY_"):] for const, _ in classes],
            "items": [{**row, "icon": icons.get(row["id"]), **({"limit": sv.item_limit(row["id"])} if row["pocket"] else {})}
                      for row in sv.item_table().values()],
            "item_icons": {"columns": SHEET_COLUMNS}, "species_icons": {"columns": SHEET_COLUMNS},
            "natures": sv.bank(sv.NATURE_NAMES), "nature_mods": sv.nature_mods(),
            "maps": [m for m in sv.map_table().values() if standable(m["id"])],
            "world": part(errors, "world", world, {"cols": 0, "rows": 0, "tiles": {}, "main": [], "buildings": [], "heals": []}),
            "dex": sv.dex_species(), "dex_forms": list(sv.dex_forms()),
            "pockets": [{**{k: p[k] for k in ("name", "const", "slots")}, **offers(p["name"])} for p in sv.pockets()],
            "stats": by_value("include/constants/pokemon.h", "STAT_", sv.NUM_STATS),
            "directions": by_value("include/constants/global_fieldmap.h", "DIR_", sv.DIR_MAX),
            "genders": [{"const": const, "value": value} for const, value in genders.items()],
            "player_genders": [{"const": const, "value": value} for const, value in players.items()],
            "badges": sv.badges(),
            "story": story, "chains": chains, "menu": part(errors, "menu", sv.menu_unlocks, []),
            "pokegear": part(errors, "pokegear", sv.pokegear_cards, {"cards": [], "map_levels": 1}),
            "level_cap": part(errors, "level_cap", sv.level_cap_milestones, {"milestones": [], "none": 0}),
            "field_moves": part(errors, "field_moves", field_moves, {}),
            "machines": part(errors, "machines", sv.machine_table, []),
            "places": part(errors, "places", sv.story_places, []),
            "givers": part(errors, "givers", sv.item_givers, {}),
            "roamers": part(errors, "roamers", lambda: {i: kind[0] for i, kind in sv.roamer_rules()["kinds"].items()}, {}),
            "limits": {"party": sv.PARTY_SIZE, "boxes": sv.NUM_BOXES, "box_slots": sv.MONS_PER_BOX,
                       "name": sv.PLAYER_NAME_LENGTH, "money": sv.MAX_MONEY, "coins": sv.MAX_COINS,
                       "hours": sv.MAX_PLAY_HOURS, "level": sv.MAX_LEVEL, "moves": sv.MAX_MON_MOVES,
                       "iv": sv.MAX_IV, "ev": sv.MAX_EV_PER_STAT, "ev_sum": sv.MAX_EV_SUM,
                       "hidden_slot": sv.HIDDEN_SLOT},
            "tree": sv.GENERATION, "errors": errors}


# ---------------------------------------------------------------------------
# HTTP.


class Handler(http.server.BaseHTTPRequestHandler):
    library = None
    port = None
    persist = False     # whether the page's choices are written to CONFIG
    server = None

    def log_message(self, fmt, *args):
        pass

    def reply(self, status, body, kind="application/json; charset=utf-8", etag=None):
        """`etag`: the browser may keep the body, but asks each time whether
        it is still this one (an icon: its PNG changes with the tree, and a
        restarted server would hand out the same address)."""
        data = json.dumps(body, ensure_ascii=False).encode() if kind.startswith("application/json") else body
        self.send_response(status)
        self.send_header("Content-Type", kind)
        self.send_header("Content-Length", str(len(data)))
        self.send_header("Cache-Control", "no-cache" if etag else "no-store")
        if etag:
            self.send_header("ETag", etag)
        self.send_header("X-Content-Type-Options", "nosniff")
        self.end_headers()
        self.wfile.write(data)

    def image(self, png):
        """A PNG the browser keeps and asks again for each time (its ETag)."""
        tag = f'"{digest(png)[:16]}"'
        if self.headers.get("If-None-Match") == tag:
            return self.reply(304, b"", "image/png", etag=tag)
        return self.reply(200, png, "image/png", etag=tag)

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
            if url.path == "/api/place":
                return self.reply(200, map_place(q))
            if url.path == "/api/townmap.png":
                return self.image(sv.town_map()["png"])
            if url.path == "/api/itemicons.png":
                return self.image(item_icon_sheet())
            if url.path == "/api/speciesicons.png":
                return self.image(species_icon_sheet())
            if url.path == "/api/moveclasses.png":
                return self.image(move_class_sheet())
            if url.path == "/api/icon":
                return self.image(icon(number(q.get("species"), 0, 0xFFFF, "specie"), number(q.get("form", 0), 0, 255, "forma"),
                                       q.get("egg") in ("1", "true")))
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
