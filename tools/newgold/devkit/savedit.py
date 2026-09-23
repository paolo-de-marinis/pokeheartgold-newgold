#!/usr/bin/env python3
"""Read and write a save file through this repository's own structures.

Playing the adventure to reach each thing that needs checking is the long
road: a Pokedex entry is an hour of walking away, the thirtieth box needs a
Pokemon Centre, the machine labels need a gym. The save holds all of it, and
the save is decompiled here, so it can be prepared instead.

Nothing here is a guessed offset. The block table is the one
SaveData_InitSubstructs builds, measured out of the built ROM by save_budget;
the flash mapping is GetChunkOffsetFromCurrentSaveSlot; the two checksums are
SaveSubstruct_UpdateCRC and SaveSlot_BuildFooter; and every field offset is
computed by the host compiler from this repository's headers, then checked
against the size the ROM itself reports. Where a field is packed rather than
declared -- the badges are the case -- the code that packs it is named.

Usage:
  savedit.py SAVE --show
  savedit.py SAVE --badges 8 --party SPECIES:LEVEL,... --item ITEM:COUNT,...

It is also a library: every option is a function of a Save, and the readers
below main()'s writers decode what the save holds -- the profile, every
Pokemon in the party and the boxes, the bag, the Dex, the position, any flag
or variable -- for saveui.py, which puts a page in front of all of it.
"""

import argparse
import binascii
import csv
import functools
import html
import json
import random
import re
import struct
import subprocess
import sys
import tempfile
from pathlib import Path

ROOT = Path(__file__).resolve().parents[3]
sys.path.insert(0, str(Path(__file__).resolve().parent / "harness"))
import save_budget  # noqa: E402

LANGUAGE_ENGLISH = 2            # include/config.h
VERSION_HEARTGOLD = 7           # include/config.h
GENDER_RATIO = lambda frac: int(frac * 254.75) if frac <= 1 else 255
PLAYER_NAME_LENGTH = 7          # include/constants/global.h
POKEMON_NAME_LENGTH = 10        # include/constants/global.h
PARTY_SIZE = 6                  # include/constants/pokemon.h
BOX_MON = 0x88                  # sizeof(BoxPokemon)
PARTY_MON = 0xEC                # sizeof(Pokemon)
BLOCK = 0x20                    # sizeof(PokemonDataBlockA), and of B, C and D
HALF = 0x40000                  # GetChunkOffsetFromCurrentSaveSlot
LOCATION = 20                   # sizeof(Location): mapId, warpId, x, y, direction
NUM_VARS = 0x170                # include/constants/vars.h; the flags follow the vars
FLAG_CONTINUE_BY_WARP = 0x966   # FLAG_UNK_966, read by CallFieldTask_ContinueGame_Normal
CHUNK_MAGIC = 0x20060623        # SAVE_CHUNK_MAGIC
CHUNK_FOOTER = 16               # sizeof(struct SaveChunkFooter)
ARRAY_FOOTER = 16               # sizeof(struct SaveArrayFooter)
FOOTER_CRC_AT = 14              # offsetof(struct SaveArrayFooter, crc)
FLASH = 512 * 1024
PAGES_PER_HALF = 64             # the flash is erased in two halves
# PLAYERDATA is { Options options; PlayerProfile profile; ... } and
# Save_PlayerData_GetProfile is "adds r0, #4" after fetching the block, so
# the profile starts four bytes in. PlayerProfile then begins with
# name[PLAYER_NAME_LENGTH + 1] and PlayerProfile_GetNamePtr is a bare
# "bx lr", so the name is at the profile's own start.
PROFILE = 4
NAME = PROFILE
TRAINER_ID = PROFILE + 2 * (PLAYER_NAME_LENGTH + 1)
JOHTO_BADGES = TRAINER_ID + 4 + 4 + 2


@functools.cache
def constants(header, prefix):
    """Every #define with the prefix, by name."""
    text = (ROOT / header).read_text()
    return {m.group(1): int(m.group(2), 0) for m in re.finditer(rf"#define ({prefix}\w+)\s+(0x[0-9A-Fa-f]+|\d+)", text)}


def crc16(data, crc=0xFFFF):
    """GF_CalcCRC16: the SDK's CCITT table, polynomial 0x1021, fed high bit
    first -- which is CRC-CCITT as binascii computes it, in C."""
    return binascii.crc_hqx(bytes(data), crc)


@functools.lru_cache(maxsize=4)
def _measured(build, stamp):
    return save_budget.measure(Path(build))


def measure(build=None):
    """save_budget.measure, once per build of the ROM rather than once per file."""
    build = Path(build or ROOT / "build/heartgold.us")
    return _measured(str(build), tuple((build / name).stat().st_mtime_ns
                                       for name in ("main.sbin", "main.elf")))


def extra_chunks(build=None):
    """The chunks written past the region, with the sector each one lives in.

    gExtraSaveChunkHeaders gives a sector rather than an offset, and
    WriteExtraSaveChunk puts a copy in both halves of the flash.
    """
    _, outside = measure(build)
    return [{"id": i, "size": size, "sector": save_budget.SAVE_PAGE_MAX + offset}
            for i, (_, size, offset) in enumerate(outside)]


def build_save(region, build=None):
    """A whole flash image: the region in both halves, then the extra chunks.

    The extra chunks are written empty. The game only ever creates them when it
    saves, and a save file that has none is read as corrupt -- that is the
    communication error at the main menu -- so they are given the footer
    CreateChunkFooter would give them over a body of zeroes, which is what
    their own init functions would leave for counters and records.
    """
    raw = bytearray(FLASH)
    for half in (0, HALF):
        raw[half:half + len(region)] = region
    for chunk in extra_chunks(build):
        body = bytearray(chunk["size"] + ARRAY_FOOTER)
        struct.pack_into("<IIIH", body, chunk["size"], CHUNK_MAGIC, 1, chunk["size"], chunk["id"])
        struct.pack_into("<H", body, chunk["size"] + FOOTER_CRC_AT,
                         crc16(body[:chunk["size"] + FOOTER_CRC_AT]))
        for sector in (chunk["sector"], chunk["sector"] + PAGES_PER_HALF):
            at = sector * save_budget.SAVE_SECTOR_SIZE
            raw[at:at + len(body)] = body
    return raw


def mon_crypt(data, seed):
    """MonEncryptSegment: a halfword at a time, against the LCRNG's high half.

    _MonEncryptSegment in src/math_util.c, whose generator is
    seed = seed * 1103515245 + 24691 and whose output is the top sixteen bits.
    It is its own inverse, which is why decrypting calls the same function.
    """
    out = bytearray(data)
    for i in range(0, len(out) & ~1, 2):
        seed = (seed * 1103515245 + 24691) & 0xFFFFFFFF
        value = struct.unpack_from("<H", out, i)[0] ^ (seed >> 16)
        struct.pack_into("<H", out, i, value)
    return bytes(out)


def mon_checksum(data):
    """CalcMonChecksum: the halfwords added up, sixteen bits wide."""
    total = 0
    for i in range(0, len(data), 2):
        total += struct.unpack_from("<H", data, i)[0]
    return total & 0xFFFF


# GetSubstruct's table: which of the four blocks sits at each of the four
# offsets, chosen by bits 13 to 17 of the personality value.
SHUFFLE = [
    (0, 1, 2, 3), (0, 1, 3, 2), (0, 2, 1, 3), (0, 3, 1, 2), (0, 2, 3, 1), (0, 3, 2, 1),
    (1, 0, 2, 3), (1, 0, 3, 2), (2, 0, 1, 3), (3, 0, 1, 2), (2, 0, 3, 1), (3, 0, 2, 1),
    (1, 2, 0, 3), (1, 3, 0, 2), (2, 1, 0, 3), (3, 1, 0, 2), (2, 3, 0, 1), (3, 2, 0, 1),
    (1, 2, 3, 0), (1, 3, 2, 0), (2, 1, 3, 0), (3, 1, 2, 0), (2, 3, 1, 0), (3, 2, 1, 0),
    (0, 1, 2, 3), (0, 1, 3, 2), (0, 2, 1, 3), (0, 3, 1, 2), (0, 2, 3, 1), (0, 3, 2, 1),
    (1, 0, 2, 3), (1, 0, 3, 2),
]


def shuffle_order(personality):
    """Where block A, B, C and D go, for this personality."""
    return SHUFFLE[(personality & 0x3E000) >> 13]


# ModifyStatByNature, over gNatureStatMods: +10% on one stat, -10% on another.
NATURE_MODS = [
    (0, 0, 0, 0, 0), (1, -1, 0, 0, 0), (1, 0, -1, 0, 0), (1, 0, 0, -1, 0), (1, 0, 0, 0, -1),
    (-1, 1, 0, 0, 0), (0, 0, 0, 0, 0), (0, 1, -1, 0, 0), (0, 1, 0, -1, 0), (0, 1, 0, 0, -1),
    (-1, 0, 1, 0, 0), (0, -1, 1, 0, 0), (0, 0, 0, 0, 0), (0, 0, 1, -1, 0), (0, 0, 1, 0, -1),
    (-1, 0, 0, 1, 0), (0, -1, 0, 1, 0), (0, 0, -1, 1, 0), (0, 0, 0, 0, 0), (0, 0, 0, 1, -1),
    (-1, 0, 0, 0, 1), (0, -1, 0, 0, 1), (0, 0, -1, 0, 1), (0, 0, 0, -1, 1), (0, 0, 0, 0, 0),
]


@functools.cache
def species_numbers():
    return {m.group(1): int(m.group(2)) for m in
            re.finditer(r"#define SPECIES_([A-Z0-9_]+)\s+(\d+)\s*$",
                        (ROOT / "include/constants/species.h").read_text(), re.M)}


@functools.cache
def personal_records():
    """files/poketool/personal/personal.json, a record for every species."""
    return json.loads((ROOT / "files/poketool/personal/personal.json").read_text())["baseStats"]


def personal(species_name):
    """One species' record, as files/poketool/personal/personal.json holds it."""
    index = species_numbers()[species_name]
    return personal_records()[index], index


@functools.cache
def growth_curves():
    """growtbl.csv: every curve's experience at levels 0 to 100."""
    with (ROOT / "files/poketool/personal/growtbl.csv").open() as f:
        return {row["rate"][len("GROWTH_"):]: [int(row[f"lv{level:03d}"]) for level in range(101)]
                for row in csv.DictReader(f)}


def experience_for(growth_rate, level):
    """The total experience a level costs, from growtbl.csv."""
    if growth_rate not in growth_curves():
        raise SystemExit(f"no growth curve called {growth_rate}")
    return growth_curves()[growth_rate][level]


def level_for(growth_rate, exp):
    """CalcLevelBySpeciesAndExp: the last level whose experience is reached."""
    curve = growth_curves()[growth_rate]
    return next((level - 1 for level in range(1, 101) if curve[level] > exp), 100)


@functools.cache
def learnsets():
    """Every species' level-up moves, as (level, move).

    wotbl.py already decodes the archive and refuses to touch it unless the
    round trip is byte for byte, so the reading is borrowed rather than
    repeated.
    """
    sys.path.insert(0, str(ROOT / "tools/newgold/import"))
    import wotbl
    files, _, _ = wotbl.read_narc(wotbl.ARCHIVE.read_bytes())
    return [[(entry["level"], entry["move"]) for entry in wotbl.decode(f)] for f in files]


def learnset(index, level):
    """The moves this species knows at this level: the last four it learns."""
    known = [move for learned, move in learnsets()[index] if learned <= level]
    return known[-4:]


@functools.cache
def ability_numbers():
    return {m.group(1): int(m.group(2)) for m in
            re.finditer(r"#define ABILITY_([A-Z0-9_]+)\s+(\d+)",
                        (ROOT / "include/constants/abilities.h").read_text())}


def ability_of(record, personality):
    """CreateBoxMon: the second ability on an odd personality, if there is one."""
    numbers = ability_numbers()
    first, second = (numbers[name[len("ABILITY_"):]] for name in record["abilities"])
    return second if second and (personality & 1) else first


def gender_of(record, personality):
    """GetGenderBySpeciesAndPersonality: male, female or none (0, 1, 2)."""
    ratio = GENDER_RATIO(record["genderRatio"])
    if ratio in (0, 254, 255):
        return {0: 0, 254: 1, 255: 2}[ratio]
    return 1 if ratio > (personality & 0xFF) else 0


def move_numbers():
    return {m.group(1): int(m.group(2)) for m in
            re.finditer(r"#define MOVE_([A-Z0-9_]+)\s+(\d+)", (ROOT / "include/constants/moves.h").read_text())}


def build_mon(species_name, level, nature=None, ivs=31, evs=0, item=0,
              ot_name="A", ot_id=0, personality=None, moves=None, ot_codes=None, ot_gender=0):
    """One party Pokemon, encrypted and checksummed the way the game does.

    The four blocks are written in their declared order and then shuffled into
    the order GetSubstruct reads them for this personality, the shuffled
    result is summed for the checksum and encrypted under it, and the party
    stats are encrypted under the personality. CalcMonStats gives the stats.
    """
    record, index = personal(species_name)
    if personality is None:
        personality = 0x00010203
        if nature is not None:
            # GetNatureFromPersonality is the personality modulo 25.
            personality = (personality - personality % 25 + nature) & 0xFFFFFFFF
    if nature is None:
        nature = personality % 25

    ability = ability_of(record, personality)
    exp = experience_for(record["growthRate"], level)
    if moves is None:
        moves = learnset(index, level)
    gender = gender_of(record, personality)

    a = bytearray(BLOCK)
    struct.pack_into("<HHI", a, 0, index, item, ot_id)
    struct.pack_into("<I", a, 8, (exp & 0x1FFFFF) | ((ability >> 8) << 31))
    a[0x0C] = record["friendship"]
    a[0x0D] = ability & 0xFF
    a[0x0F] = LANGUAGE_ENGLISH
    for i in range(6):
        a[0x10 + i] = evs[i] if isinstance(evs, (list, tuple)) else evs

    b = bytearray(BLOCK)
    for i, move in enumerate(moves):
        struct.pack_into("<H", b, 2 * i, move)
        b[8 + i] = 40                       # plenty of PP for a test battle
    iv = ivs if isinstance(ivs, (list, tuple)) else [ivs] * 6
    packed = 0
    for i in range(6):
        packed |= (iv[i] & 0x1F) << (5 * i)
    struct.pack_into("<I", b, 0x10, packed)
    b[0x18] = (gender & 3) << 1

    c = bytearray(BLOCK)
    for i, code in enumerate(charcode(species_name.replace("_", ""))[:POKEMON_NAME_LENGTH + 1]):
        struct.pack_into("<H", c, 2 * i, code)
    c[0x17] = VERSION_HEARTGOLD

    d = bytearray(BLOCK)
    # The original trainer is who the game compares with the player to decide
    # a Pokemon was traded -- the name, the id and the gender -- and a traded
    # Pokemon past the badges' level does not obey. Given the player's own,
    # the party is the player's.
    for i, code in enumerate(ot_codes if ot_codes is not None else charcode(ot_name)):
        struct.pack_into("<H", d, 2 * i, code)
    d[0x1B] = 4                             # ITEM_POKE_BALL
    d[0x1C] = (level & 0x7F) | ((ot_gender & 1) << 7)
    d[0x1E] = 4

    order = shuffle_order(personality)
    blocks_in_place = [None] * 4
    for which, block in enumerate((a, b, c, d)):
        blocks_in_place[order[which]] = block
    body = b"".join(bytes(x) for x in blocks_in_place)

    mon = bytearray(PARTY_MON)
    struct.pack_into("<I", mon, 0, personality)
    checksum = mon_checksum(body)
    struct.pack_into("<H", mon, 6, checksum)
    mon[8:8 + 4 * BLOCK] = mon_crypt(body, checksum)

    stats = stat_line(record, level, iv, evs, nature)
    party = bytearray(PARTY_MON - BOX_MON)
    party[4] = level
    struct.pack_into("<7H", party, 6, stats[0], *stats)
    mon[BOX_MON:] = mon_crypt(bytes(party), personality)
    return bytes(mon)


def stat_line(record, level, iv, evs, nature):
    """CalcMonStats, including the nature's ten per cent either way."""
    ev = evs if isinstance(evs, (list, tuple)) else [evs] * 6
    base = [record["hp"], record["atk"], record["def"],
            record["speed"], record["spatk"], record["spdef"]]
    hp = (base[0] * 2 + iv[0] + ev[0] // 4) * level // 100 + level + 10
    out = [hp]
    for i in range(1, 6):
        value = (base[i] * 2 + iv[i] + ev[i] // 4) * level // 100 + 5
        mod = NATURE_MODS[nature][i - 1]
        if mod > 0:
            value = value * 110 // 100
        elif mod < 0:
            value = value * 90 // 100
        out.append(value)
    # The record's order is hp, atk, def, speed, spatk, spdef; the party keeps
    # hp, atk, def, speed, spatk, spdef too, so nothing is reordered here.
    return out


# struct Bag, in its declared order. Each slot is { u16 id; u16 quantity; }
# and the whole thing is 2252 bytes, which is what the ROM reports for
# Save_Bag_sizeof -- so the pockets below are counted, not guessed.
POCKETS = [("items", 165 + 32), ("keyItems", 50 + 42), ("TMsHMs", 101),
           ("mail", 12), ("medicine", 40), ("berries", 64),
           ("balls", 24 + 2), ("battleItems", 30)]


def pocket_at(name):
    at = 0
    for pocket, count in POCKETS:
        if pocket == name:
            return at, count
        at += 4 * count
    raise SystemExit(f"no pocket called {name}")


def put_in_pocket(block, pocket, item, quantity):
    """The first free slot, or the one already holding it."""
    at, count = pocket_at(pocket)
    for slot in range(count):
        here = at + 4 * slot
        got, _ = struct.unpack_from("<HH", block, here)
        if got in (0, item):
            struct.pack_into("<HH", block, here, item, quantity)
            return slot
    raise SystemExit(f"the {pocket} pocket is full")


# struct Pokedex. NUM_DEX_FLAG_WORDS is CEILDIV(NATIONAL_DEX_COUNT + 8, 32),
# and the offsets below follow include/pokedex.h. The count is read from the
# header, since it has moved twice: it was 574 when this was first written,
# and a number typed here would put every Dex flag in the wrong word.
def _national_dex_count():
    header = (ROOT / "include/constants/species.h").read_text()
    name = re.search(r"#define NATIONAL_DEX_COUNT\s+(\w+)", header).group(1)
    while not name.startswith("SPECIES_"):
        name = re.search(rf"#define {name}\s+(\w+)", header).group(1)
    return int(re.search(rf"#define {name}\s+(\d+)", header).group(1))


NATIONAL_DEX_COUNT = _national_dex_count()
DEX_WORDS = (NATIONAL_DEX_COUNT + 8 + 31) // 32
DEX_CAUGHT = 4
DEX_SEEN = DEX_CAUGHT + 4 * DEX_WORDS
DEX_GENDERS = DEX_SEEN + 4 * DEX_WORDS
DEX_ENABLED = (4 + 4 * DEX_WORDS * 4 + 4 + 4 + 28 + 28
               + ((NATIONAL_DEX_COUNT + 3) & ~3) + 2)
DEX_NATIONAL = DEX_ENABLED + 1


def set_dex_flag(block, at, species):
    """SetDexFlag: the species number, counted from one."""
    flag = species - 1
    block[at + (flag >> 3)] |= 1 << (flag & 7)


# struct PokemonStorageSystem. A box is thirty BoxPokemon and sixteen spare
# bytes, which is exactly 0x1000, so thirty boxes end at 0x1E000.
BOX = 0x1000
BOX_NAME_LENGTH = 20


def blocks(build=None):
    """Every block's id, size and slot, then where each one starts.

    This is SaveData_InitSubstructs: sizes come rounded up to a word with four
    bytes of checksum added, a slot's last block is followed by the chunk
    footer, and the next slot starts on a 0x100 boundary.
    """
    inside, _ = measure(build)
    names = block_ids()
    out, offset = [], 0
    for index, (fn, size, slot) in enumerate(inside):
        chunk = ((size + 3) & ~3) + save_budget.CRC
        out.append({"index": index, "id": names[index], "sizefn": fn,
                    "offset": offset, "size": chunk, "slot": slot})
        offset += chunk
        last = index == len(inside) - 1
        if last or slot != inside[index + 1][2]:
            offset += CHUNK_FOOTER
            if not last and offset % 0x100:
                offset += 0x100 - offset % 0x100
    return out


def block_ids():
    """The SAVE_* name of each block, in the order save_arrays.c declares them."""
    text = (ROOT / "src/save_arrays.c").read_text()
    text = text[:text.index("gExtraSaveChunkHeaders")]
    return [m.group(1) for m in re.finditer(r"\{\s*(SAVE_\w+),", text)]


def slot_specs(table):
    """SaveData_InitSlotSpecs: where each of the two slots sits, and how big."""
    specs, offset = [], 0
    for slot in sorted({b["slot"] for b in table}, key=lambda s: min(
            b["index"] for b in table if b["slot"] == s)):
        size = sum(b["size"] for b in table if b["slot"] == slot) + CHUNK_FOOTER
        specs.append({"slot": int(slot), "offset": offset, "size": size})
        offset += size
        if offset % 0x100:
            offset += 0x100 - offset % 0x100
    return specs


class Save:
    def __init__(self, path, build=None):
        self.path = Path(path)
        self.raw = bytearray(self.path.read_bytes())
        self.table = blocks(build)
        self.specs = slot_specs(self.table)
        self.half = self._newest_half()
        self.region = bytearray(self.raw[self.half:self.half + HALF])
        self.opened = bytes(self.region)

    def counter(self, half=None):
        """The save counter SaveSlot_BuildFooter wrote into this half."""
        return self._footer(self.half if half is None else half, self.specs[0])["count"]

    def _footer(self, half, spec):
        at = half + spec["offset"] + spec["size"] - CHUNK_FOOTER
        count, size, magic, slot, crc = struct.unpack("<IIIHH", self.raw[at:at + CHUNK_FOOTER])
        return {"count": count, "size": size, "magic": magic, "slot": slot, "crc": crc}

    def valid(self, half):
        """A half is good when every slot's footer says what it should."""
        for spec in self.specs:
            f = self._footer(half, spec)
            if f["magic"] != CHUNK_MAGIC or f["size"] != spec["size"] or f["slot"] != spec["slot"]:
                return False
            body = self.raw[half + spec["offset"]:half + spec["offset"] + spec["size"] - CHUNK_FOOTER]
            if crc16(body) != f["crc"]:
                return False
        return True

    def _newest_half(self):
        good = [h for h in (0, HALF) if self.valid(h)]
        if not good:
            raise SystemExit(f"{self.path}: neither half of the flash holds a valid save")
        return max(good, key=lambda h: self._footer(h, self.specs[0])["count"])

    def block(self, name):
        entry = next(b for b in self.table if b["id"] == name)
        return memoryview(self.region)[entry["offset"]:entry["offset"] + entry["size"]]

    def entry(self, name):
        return next(b for b in self.table if b["id"] == name)

    def reseal(self):
        """SaveSubstruct_UpdateCRC for every block, then SaveSlot_BuildFooter."""
        for b in self.table:
            body = b["size"] - save_budget.CRC
            crc = crc16(self.region[b["offset"]:b["offset"] + body])
            struct.pack_into("<H", self.region, b["offset"] + body, crc)
        for spec in self.specs:
            at = spec["offset"] + spec["size"] - CHUNK_FOOTER
            count = struct.unpack_from("<I", self.region, at)[0]
            body = bytes(self.region[spec["offset"]:at])
            struct.pack_into("<IIIHH", self.region, at,
                             count, spec["size"], CHUNK_MAGIC, spec["slot"], crc16(body))

    def write(self, path=None):
        """Both halves get the same sealed region, so either one loads."""
        self.reseal()
        for half in (0, HALF):
            self.raw[half:half + len(self.region)] = self.region
        Path(path or self.path).write_bytes(bytes(self.raw))

    def image(self):
        """The file with this session's changes and nothing else.

        write() seals every block and copies the newest half over the older
        one. The game does neither: most blocks' checksum fields stay zero
        (SaveSubstruct_UpdateCRC runs for three of them), and the older half
        is the save before, which the game falls back to. Here only a block
        that changed gets its checksum, only a slot holding one gets a new
        footer, and only the newest half is touched -- so a save opened and
        written back unchanged is the same bytes.

        The older half is also where the game's next save goes, and of the
        PC slot it writes only the boxes PokemonStorageSystem.boxModifiedFlag
        names (Save_CalcPCBoxModifiedFlags, Save_WriteNextPCBox) under a
        footer computed over all of them. A box changed here is added to the
        flag, or the older half would keep its old bytes under that footer
        and the game would call the save corrupt at the next boot.
        """
        region = bytearray(self.region)
        pc = self.entry("SAVE_PCSTORAGE")["offset"]
        boxes = [n for n in range(NUM_BOXES)
                 if region[pc + n * BOX:pc + (n + 1) * BOX] != self.opened[pc + n * BOX:pc + (n + 1) * BOX]]
        if boxes:
            flags = struct.unpack_from("<I", region, pc + BOX_MODIFIED)[0]
            struct.pack_into("<I", region, pc + BOX_MODIFIED, flags | sum(1 << n for n in boxes))
        slots = set()
        for b in self.table:
            start, end = b["offset"], b["offset"] + b["size"]
            if region[start:end] != self.opened[start:end]:
                body = b["size"] - save_budget.CRC
                struct.pack_into("<H", region, start + body, crc16(region[start:start + body]))
                slots.add(int(b["slot"]))
        for spec in self.specs:
            if spec["slot"] in slots:
                at = spec["offset"] + spec["size"] - CHUNK_FOOTER
                struct.pack_into("<H", region, at + 14, crc16(region[spec["offset"]:at]))
        raw = bytearray(self.raw)
        raw[self.half:self.half + HALF] = region
        return bytes(raw)


def charcode(text):
    """The game's own character codes, from include/constants/charcode.h.

    Letters and digits are contiguous there, so CHAR_A and CHAR_0 place the
    rest. A name has to end in EOS or the game reads past its buffer: that is
    the assertion in CopyU16ArrayToString, which is what an all-zero name in a
    save file trips.
    """
    table = (ROOT / "include/constants/charcode.h").read_text()
    def value(name):
        return int(re.search(rf"#define {name}\s+(\d+)", table).group(1))
    upper, digit, eos = value("CHAR_A"), value("CHAR_0"), 0xFFFF
    out = []
    for character in text:
        if "A" <= character <= "Z":
            out.append(upper + ord(character) - ord("A"))
        elif "a" <= character <= "z":
            out.append(upper + 26 + ord(character) - ord("a"))
        elif character.isdigit():
            out.append(digit + int(character))
        else:
            raise SystemExit(f"{character!r} is not a letter or a digit")
    return out + [eos]


def offsets(struct_name, header, fields):
    """Ask the host compiler where the fields are, from this repository's headers.

    No system header is included: this repository's headers pull in the SDK's
    own stdio and the two disagree. __builtin_offsetof and __builtin_printf
    need neither.
    """
    body = "\n".join(f'    __builtin_printf("%s %lu\\n", "{f}", '
                     f'(unsigned long)__builtin_offsetof({struct_name}, {f}));'
                     for f in fields)
    source = f"""
#include "{header}"
int main(void) {{
    __builtin_printf("sizeof %lu\\n", (unsigned long)sizeof({struct_name}));
{body}
    return 0;
}}
"""
    with tempfile.TemporaryDirectory() as tmp:
        c = Path(tmp) / "probe.c"
        c.write_text(source)
        run = subprocess.run(
            ["cc", "-o", str(Path(tmp) / "probe"), str(c),
             f"-I{ROOT}/include", f"-I{ROOT}/include/library", f"-I{ROOT}/files",
             f"-I{ROOT}/lib/include", "-w"], capture_output=True, text=True)
        if run.returncode:
            raise SystemExit(f"could not lay out {struct_name}:\n{run.stderr[:800]}")
        out = subprocess.run([str(Path(tmp) / "probe")], capture_output=True, text=True).stdout
    return {k: int(v) for k, v in (line.split() for line in out.splitlines())}



# ---------------------------------------------------------------------------
# What main() does, an option at a time. Each changes the Save in memory;
# main() writes it and says what it did.


def seal_from_ram(dump_path, save_path):
    """--from-ram: the region the game laid out before the title screen,
    sealed into a file the game will load."""
    import where
    dump = Path(dump_path).read_bytes()
    pointer = struct.unpack_from("<I", dump, where.symbol("sSaveDataPtr") - where.MAIN_RAM)[0]
    if not where.MAIN_RAM <= pointer < where.MAIN_RAM + len(dump):
        raise SystemExit("sSaveDataPtr is not set in that dump")
    at = pointer - where.MAIN_RAM + 0x10          # SaveData.dynamic_region
    region = bytearray(dump[at:at + save_budget.REGION])
    table = blocks()
    holder = type("_", (), {"region": region, "table": table,
                            "specs": slot_specs(table)})()
    Save.reseal(holder)
    Path(save_path).write_bytes(bytes(build_save(region)))


def set_name(save, name):
    letters = charcode(name)
    if len(letters) > PLAYER_NAME_LENGTH + 1:
        raise SystemExit(f"a name is at most {PLAYER_NAME_LENGTH} characters")
    block = save.block("SAVE_PLAYERDATA")
    for i, value in enumerate(letters):
        struct.pack_into("<H", block, NAME + 2 * i, value)


def owner(save):
    """The player as an original trainer: the name up to its EOS, the id and
    the gender -- what the game compares to decide a Pokemon was traded."""
    profile = save.block("SAVE_PLAYERDATA")
    codes = list(struct.unpack_from(f"<{PLAYER_NAME_LENGTH + 1}H", profile, NAME))
    codes = codes[:codes.index(0xFFFF) + 1] if 0xFFFF in codes else codes
    return {"codes": codes, "id": struct.unpack_from("<I", profile, TRAINER_ID)[0],
            "gender": profile[TRAINER_ID + 4 + 4]}


def parse_party(text):
    """SPECIES:LEVEL[:NATURE][:MOVE+MOVE+...],...; moves not given come from
    the learnset at that level."""
    numbers = move_numbers()
    wanted = []
    for entry in text.split(","):
        parts = entry.split(":")
        moves = None
        if len(parts) > 3 and parts[3]:
            moves = []
            for move in parts[3].upper().split("+"):
                if move not in numbers:
                    raise SystemExit(f"there is no MOVE_{move}")
                moves.append(numbers[move])
            if len(moves) > 4:
                raise SystemExit("a Pokemon knows four moves")
        wanted.append((parts[0].upper(), int(parts[1]),
                       int(parts[2]) if len(parts) > 2 and parts[2] else None, moves))
    return wanted


def set_party(save, wanted):
    """The whole party, always the player's own so that it obeys."""
    if len(wanted) > PARTY_SIZE:
        raise SystemExit(f"a party holds {PARTY_SIZE}")
    block = save.block("SAVE_PARTY")
    # PartyCore is { int maxCount; int curCount; Pokemon mons[PARTY_SIZE]; }
    struct.pack_into("<ii", block, 0, PARTY_SIZE, len(wanted))
    me = owner(save)
    for slot, (name, level, nature, moves) in enumerate(wanted):
        mon = build_mon(name, level, nature=nature, moves=moves,
                        ot_codes=me["codes"], ot_id=me["id"], ot_gender=me["gender"])
        block[8 + slot * PARTY_MON:8 + (slot + 1) * PARTY_MON] = mon


def add_machines(save, machines):
    block = save.block("SAVE_BAG")
    first = int(re.search(r"#define ITEM_TM01\s+(\d+)",
                          (ROOT / "include/constants/items.h").read_text()).group(1))
    for n in machines:
        put_in_pocket(block, "TMsHMs", first + n - 1, 1)


def mark_dex(save, names):
    """Seen and caught, and the Dex and the National Dex switched on."""
    block = save.block("SAVE_POKEDEX")
    numbers = species_numbers()
    for name in names:
        if name not in numbers:
            raise SystemExit(f"there is no SPECIES_{name}")
        set_dex_flag(block, DEX_SEEN, numbers[name])
        set_dex_flag(block, DEX_CAUGHT, numbers[name])
    block[DEX_ENABLED] = 1
    block[DEX_NATIONAL] = 1


def put_in_box(save, number, name, level):
    """--box: the first slot of box `number`, counted from one."""
    if not 1 <= number <= 30:
        raise SystemExit("boxes are numbered one to thirty")
    block = save.block("SAVE_PCSTORAGE")
    at = (number - 1) * BOX
    block[at:at + BOX_MON] = build_mon(name.upper(), int(level))[:BOX_MON]


def set_trainer_id(save, value):
    struct.pack_into("<I", save.block("SAVE_PLAYERDATA"), TRAINER_ID, value)


def set_badges(save, count):
    # PlayerProfile_SetBadgeFlag: badges 0-7 are a bit each in johtoBadges.
    struct.pack_into("<B", save.block("SAVE_PLAYERDATA"), JOHTO_BADGES, (1 << count) - 1)


def set_var(save, name, value):
    """A script variable by its name in include/constants/vars.h. The story
    keeps its place in these: Morty's gym turns the player away while
    VAR_UNK_4079 is 0, and the Burned Tower sets it to 2."""
    number = constants("include/constants/vars.h", "VAR_").get(name)
    if number is None:
        raise SystemExit(f"there is no {name} in include/constants/vars.h")
    value = int(value, 0) if isinstance(value, str) else value
    struct.pack_into("<H", save.block("SAVE_FLAGS"), 2 * (number - 0x4000), value)
    return number


def set_flag(save, name):
    """A script flag by its name in include/constants/flags.h: the cap for
    Falkner is 13 only once FLAG_UNK_076 says Sprout Tower is done."""
    flags = save.block("SAVE_FLAGS")
    number = constants("include/constants/flags.h", "FLAG_").get(name)
    if number is None:
        raise SystemExit(f"there is no {name} in include/constants/flags.h")
    flags[NUM_VARS * 2 + number // 8] |= 1 << (number % 8)
    return number


def set_position(save, map_id, x, y, direction=0):
    block = save.block("SAVE_LOCAL_FIELD_DATA")
    # struct LocalFieldData starts with currentPosition, a Location of
    # { int mapId; int warpId; int x; int y; int direction; }. A warpId of
    # -1 is the value the game uses for a position that is not a warp.
    struct.pack_into("<iiiii", block, 0, map_id, -1, x, y, direction)
    # Continue normally restores the map objects the save holds -- the
    # player object among them, still at the coordinates of wherever the
    # save was really made, which on a one-chunk map is off the map and
    # a null soundplate away from a data abort. The game has a second way
    # in, the one it uses for the Union Room: with FLAG_UNK_966 set,
    # Continue warps to LocalFieldData.dynamicWarp and builds the player,
    # the follower and the map's objects from the zone data instead.
    struct.pack_into("<iiiii", block, 3 * LOCATION, map_id, -1, x, y, direction)
    flags = save.block("SAVE_FLAGS")
    flags[NUM_VARS * 2 + FLAG_CONTINUE_BY_WARP // 8] |= 1 << (FLAG_CONTINUE_BY_WARP % 8)


# ---------------------------------------------------------------------------
# The game's own names for things: its message banks and its character set.

# BufferSpeciesName, BufferMoveName, BufferItemName, BufferAbilityName and
# BufferNatureName in src/message_format.c, and the map sections
# src/field/draw_map_name.c prints on entering one.
SPECIES_NAMES, MOVE_NAMES, ITEM_NAMES, ABILITY_NAMES, NATURE_NAMES, MAPSEC_NAMES = 237, 750, 222, 720, 34, 279


@functools.cache
def bank(number):
    """A message bank's rows, by index, as the game prints them."""
    sys.path.insert(0, str(ROOT / "tools/newgold/import"))
    import gmm
    return [html.unescape(row["text"]) for row in gmm.read(number)]


@functools.cache
def charmap():
    """charmap.txt both ways. A character the table gives twice is written
    with its Western code, the one the English game's own text uses."""
    decode, encode = {}, {}
    for line in (ROOT / "charmap.txt").read_text(encoding="utf-8").splitlines():
        m = re.fullmatch(r"([0-9A-F]{4})=(.)", line)
        if not m:
            continue
        code, character = int(m.group(1), 16), m.group(2)
        decode.setdefault(code, character)
        western = 0x100 <= code < 0x200
        if character not in encode or (western and not 0x100 <= encode[character] < 0x200):
            encode[character] = code
    return decode, encode


def decode_text(codes):
    """Character codes up to EOS as text; one the table lacks is a '?'."""
    decode, _ = charmap()
    out = []
    for code in codes:
        if code == 0xFFFF:
            break
        out.append(decode.get(code, "?"))
    return "".join(out)


def encode_text(text, length):
    """The game's codes for a text of at most `length` characters, and EOS."""
    _, encode = charmap()
    missing = [c for c in text if c not in encode]
    if missing:
        raise ValueError(f"{missing[0]!r} is not in the game's character set")
    if len(text) > length:
        raise ValueError(f"{text!r} is longer than {length}")
    return [encode[c] for c in text] + [0xFFFF]


def species_name(species):
    names = bank(SPECIES_NAMES)
    return names[species] if 0 <= species < len(names) else f"#{species}"


@functools.cache
def species_table():
    """Every species with the name the game prints. A form prints its base's
    name, so it carries its constant as well to tell it apart."""
    numbers = species_numbers()
    by_id = {}
    for name, number in numbers.items():
        by_id.setdefault(number, name)
    gap = range(numbers["EGG"], numbers["ROTOM_MOW"] + 1)
    out = []
    for number in range(1, min(len(bank(SPECIES_NAMES)), len(personal_records()))):
        const = by_id.get(number, "")
        form = number in gap or number > NATIONAL_DEX_COUNT
        out.append({"id": number, "name": species_name(number), "const": const,
                    "label": f"{species_name(number)} ({const.replace('_', ' ').title()})"
                             if form else species_name(number),
                    "dex": not form, "egg": number in (numbers["EGG"], numbers["BAD_EGG"])})
    return out


# The pockets item_data.csv files items in, by the names struct Bag gives them.
POCKET_OF = {"POCKET_ITEMS": "items", "POCKET_KEY_ITEMS": "keyItems", "POCKET_TMHMS": "TMsHMs",
             "POCKET_MAIL": "mail", "POCKET_MEDICINE": "medicine", "POCKET_BERRIES": "berries",
             "POCKET_BALLS": "balls", "POCKET_BATTLE_ITEMS": "battleItems"}


@functools.cache
def item_table():
    """Every item: its name, its constant, and the pocket it goes in
    (fieldPocket, which the csv gives by the item's name)."""
    names = bank(ITEM_NAMES)
    with (ROOT / "files/itemtool/itemdata/item_data.csv").open() as f:
        pockets = {row["item"]: POCKET_OF.get(row["fieldPocket"]) for row in csv.DictReader(f)}
    by_id = {}
    for m in re.finditer(r"^#define (ITEM_\w+)\s+(\d+)\s*$",
                         (ROOT / "include/constants/items.h").read_text(), re.M):
        by_id.setdefault(int(m.group(2)), m.group(1))
    return {number: {"id": number, "const": const, "pocket": pockets.get(const),
                     "name": names[number] if number < len(names) else const}
            for number, const in sorted(by_id.items())}


@functools.cache
def move_table():
    """Every move's name and base PP, the PP out of waza_tbl.narc."""
    sys.path.insert(0, str(ROOT / "tools/newgold/import"))
    import import_moves
    records = import_moves.read_table()
    return [{"id": n, "name": name,
             "pp": struct.unpack(import_moves.RECORD, records[n])[5] if n < len(records) else 0}
            for n, name in enumerate(bank(MOVE_NAMES))]


@functools.cache
def map_table():
    """Every map by id, with the section name the game shows for it."""
    names = bank(MAPSEC_NAMES)
    sections = constants("include/constants/map_sections.h", "MAPSEC_")
    headers = (ROOT / "src/data/map_headers.h").read_text()
    section_of = dict(re.findall(r"\[(MAP_\w+)\] = \{[^}]*?\.mapsec = (MAPSEC_\w+)", headers))
    out = {}
    for const, number in constants("include/constants/maps.h", "MAP_").items():
        section = sections.get(section_of.get(const))
        out.setdefault(number, {"id": number, "const": const,
                                "name": names[section] if section is not None and section < len(names) else ""})
    return dict(sorted(out.items()))


# ---------------------------------------------------------------------------
# One Pokemon, opened and closed the way AcquireBoxMonLock and
# ReleaseBoxMonLock do it.

# ZeroMonData: zeroes, "encrypted" under a checksum and a personality of 0.
EMPTY_BOX_MON = bytes(8) + mon_crypt(bytes(4 * BLOCK), 0)
EMPTY_PARTY_MON = EMPTY_BOX_MON + mon_crypt(bytes(PARTY_MON - BOX_MON), 0)
MINT_MASK = 0x3E            # MON_MINT_NATURE_MASK in blockB->unused2
SWAP_ABILITY_BIT = 1        # MON_SWAP_ABILITY_SLOT_BIT, the Ability Capsule's
HIDDEN_ABILITY_BIT = 1      # MON_HIDDEN_ABILITY_BIT in blockB->unused1
EXP_BITS = 0x1FFFFF         # PokemonDataBlockA.exp : 21
# PartyPokemon.mail, after the status, the level, the capsule, the HP and
# the five stats, as Mail_Init leaves it -- CreateMon and the box-to-party
# copy both run it: no author (name all EOS), MAIL_NONE, no icons, and three
# MailMsg_Init messages (bank MAILMSG_BANK_NONE, words EC_WORD_NULL). An
# all-zero one has an author name with no EOS, and reading a Mail held on
# it ends in CopyU16ArrayToString's assertion and the error screen.
MAIL_AT = 0x14
MAIL_INIT = (struct.pack("<IBBBB8H3HH", 0, 0, LANGUAGE_ENGLISH, VERSION_HEARTGOLD, 0xFF, *[0xFFFF] * 11, 0)
             + struct.pack("<4H", 0xFFFF, 0, 0xFFFF, 0xFFFF) * 3)


def open_mon(raw):
    """A stored Pokemon decrypted: the personality, blocks A to D in their
    declared order, the party part if the bytes have one, and whether the
    checksum holds. None for an empty slot."""
    raw = bytes(raw)
    if not any(raw):
        return None
    personality, flags, checksum = struct.unpack_from("<IHH", raw, 0)
    body = mon_crypt(raw[8:BOX_MON], checksum)
    order = shuffle_order(personality)
    mon = {"personality": personality, "flags": flags, "ok": mon_checksum(body) == checksum,
           "blocks": [bytearray(body[order[w] * BLOCK:(order[w] + 1) * BLOCK]) for w in range(4)],
           "party": bytearray(mon_crypt(raw[BOX_MON:PARTY_MON], personality))
                    if len(raw) >= PARTY_MON else None}
    if mon["ok"] and struct.unpack_from("<H", mon["blocks"][0], 0)[0] == 0:
        return None
    return mon


def seal_mon(mon):
    """The blocks back in this personality's order, summed, and encrypted
    under the sum; the party part under the personality, its mail record
    Mail_Init's if it was all zero (savedit's own before, never the game's)."""
    order = shuffle_order(mon["personality"])
    body = bytearray(4 * BLOCK)
    for which, block in enumerate(mon["blocks"]):
        body[order[which] * BLOCK:(order[which] + 1) * BLOCK] = block
    checksum = mon_checksum(body)
    out = struct.pack("<IHH", mon["personality"], mon["flags"], checksum) + mon_crypt(bytes(body), checksum)
    if mon["party"] is not None:
        party = bytearray(mon["party"])
        if not any(party[MAIL_AT:MAIL_AT + len(MAIL_INIT)]):
            party[MAIL_AT:MAIL_AT + len(MAIL_INIT)] = MAIL_INIT
        out += mon_crypt(bytes(party), mon["personality"])
    return out


def is_shiny(personality, ot_id):
    """SHINY_CHECK in src/pokemon.c."""
    return ((ot_id >> 16) ^ (ot_id & 0xFFFF) ^ (personality >> 16) ^ (personality & 0xFFFF)) < 8


def personality_for_nature(personality, nature, ot_id):
    """A personality whose nature (the value modulo 25) is `nature`, keeping
    what else the old one decided: the low byte (the gender and the ability
    slot) and whether the Pokemon is shiny. Unown's letter, which is spread
    over the whole value, is not kept."""
    if personality % 25 == nature:
        return personality
    low = personality & 0xFFFF
    if not is_shiny(personality, ot_id):
        # 0x10000 is 11 modulo 25, so every nature is within 25 steps.
        for step in range(1, 0x10000):
            candidate = ((((personality >> 16) + step) & 0xFFFF) << 16) | low
            if candidate % 25 == nature and not is_shiny(candidate, ot_id):
                return candidate
    else:
        # A shiny one has eight high halves to choose from, which reach only
        # eight natures; the byte above the low one is free to move as well.
        key = (ot_id >> 16) ^ (ot_id & 0xFFFF)
        for step in range(256):
            low = ((((personality >> 8) + step) & 0xFF) << 8) | (personality & 0xFF)
            for k in range(8):
                candidate = (((key ^ low ^ k) & 0xFFFF) << 16) | low
                if candidate % 25 == nature:
                    return candidate
    raise ValueError(f"no personality gives nature {nature}")


def _set_ability(a, b, personality, species):
    """UpdateBoxMonAbility: the hidden ability when its bit is set and the
    species has one, otherwise the slot the personality picks, turned over
    by an Ability Capsule."""
    record = personal_records()[species]
    numbers = ability_numbers()
    first, second = (numbers[name[len("ABILITY_"):]] for name in record["abilities"])
    hidden = numbers.get(record.get("hiddenAbility", "ABILITY_NONE")[len("ABILITY_"):], 0)
    if struct.unpack_from("<H", b, 0x1A)[0] & SWAP_ABILITY_BIT:
        personality ^= 1
    if (b[0x19] >> 6) & HIDDEN_ABILITY_BIT and hidden:
        ability = hidden
    elif second:
        ability = second if personality & 1 else first
    else:
        ability = first
    a[0x0D] = ability & 0xFF
    word = struct.unpack_from("<I", a, 8)[0]
    struct.pack_into("<I", a, 8, (word & 0x7FFFFFFF) | ((ability >> 8) & 1) << 31)


def _set_party_stats(mon, level):
    """CalcMonStats at this level, the nature a Mint gave if it gave one, and
    HP moved the way CalcMonStats moves it."""
    a, b, _, _ = mon["blocks"]
    party = mon["party"]
    species = struct.unpack_from("<H", a, 0)[0]
    ivword = struct.unpack_from("<I", b, 0x10)[0]
    ivs = [(ivword >> (5 * i)) & 31 for i in range(6)]
    mint = (struct.unpack_from("<H", b, 0x1A)[0] & MINT_MASK) >> 1
    nature = mint - 1 if mint else mon["personality"] % 25
    stats = stat_line(personal_records()[species], level, ivs, list(a[0x10:0x16]), nature)
    shedinja = species == species_numbers()["SHEDINJA"]
    if shedinja:
        stats[0] = 1
    hp, max_hp = struct.unpack_from("<HH", party, 6)
    if hp != 0 or max_hp == 0:
        if shedinja:
            hp = 1
        elif hp == 0:
            hp = stats[0]
        elif stats[0] < max_hp:
            hp = min(hp, stats[0])
        else:
            hp += stats[0] - max_hp
    party[4] = level
    struct.pack_into("<7H", party, 6, hp, *stats)


def edit_mon(raw, species=None, level=None, nature=None, item=None, moves=None,
             ivs=None, evs=None, friendship=None):
    """One stored Pokemon with these things changed as the game changes them,
    and everything else -- its trainer, its ribbons, its met data -- as it was.

    A new species gets form 0, its gender and ability worked out again, and
    the species' name unless it has a nickname; a level is the experience
    that level costs; a nature is a new personality (personality_for_nature)
    with any Mint taken away; a move it already knew keeps its PP and PP Ups,
    a new one gets full PP. A party Pokemon's stats follow.
    """
    mon = open_mon(raw)
    if mon is None or not mon["ok"]:
        raise ValueError("there is no Pokemon here to change, or its checksum is wrong")
    a, b, c, _ = mon["blocks"]
    records = personal_records()
    old_species = struct.unpack_from("<H", a, 0)[0]
    ot_id = struct.unpack_from("<I", a, 4)[0]
    exp = struct.unpack_from("<I", a, 8)[0] & EXP_BITS
    current = mon["party"][4] if mon["party"] is not None else level_for(records[old_species]["growthRate"], exp)
    restat = any(v is not None for v in (level, nature, ivs, evs)) or (species not in (None, old_species))
    if nature is not None:
        mon["personality"] = personality_for_nature(mon["personality"], nature, ot_id)
        struct.pack_into("<H", b, 0x1A, struct.unpack_from("<H", b, 0x1A)[0] & ~MINT_MASK)
    if species is not None and species != old_species:
        if not 0 < species < len(records):
            raise ValueError(f"there is no species {species}")
        struct.pack_into("<H", a, 0, species)
        b[0x18] = (b[0x18] & 1) | gender_of(records[species], mon["personality"]) << 1
        if not struct.unpack_from("<I", b, 0x10)[0] >> 31:
            for i, code in enumerate(encode_text(species_name(species), POKEMON_NAME_LENGTH)):
                struct.pack_into("<H", c, 2 * i, code)
        _set_ability(a, b, mon["personality"], species)
        level = current if level is None else level
    if level is not None:
        if not 1 <= level <= 100:
            raise ValueError("a level is 1 to 100")
        growth = records[struct.unpack_from("<H", a, 0)[0]]["growthRate"]
        word = struct.unpack_from("<I", a, 8)[0]
        struct.pack_into("<I", a, 8, (word & ~EXP_BITS & 0xFFFFFFFF) | experience_for(growth, level))
    if item is not None:
        struct.pack_into("<H", a, 2, item)
    if moves is not None:
        known = [(struct.unpack_from("<H", b, 2 * i)[0], b[8 + i], b[12 + i]) for i in range(4)]
        wanted = [move for move in moves if move][:4]
        table = move_table()
        for i in range(4):
            move = wanted[i] if i < len(wanted) else 0
            kept = next((k for k in known if move and k[0] == move), None)
            pp, ups = (kept[1], kept[2]) if kept else ((table[move]["pp"], 0) if move else (0, 0))
            struct.pack_into("<H", b, 2 * i, move)
            b[8 + i], b[12 + i] = pp, ups
    if ivs is not None:
        word = struct.unpack_from("<I", b, 0x10)[0] & 0xC0000000
        struct.pack_into("<I", b, 0x10, word | sum((iv & 31) << (5 * i) for i, iv in enumerate(ivs)))
    if evs is not None:
        a[0x10:0x16] = bytes(evs)
    if friendship is not None:
        a[0x0C] = friendship
    if mon["party"] is not None and restat:
        _set_party_stats(mon, current if level is None else level)
    return seal_mon(mon)


def new_mon(species, level, me, nature=None, moves=None, item=0, ivs=31, evs=0, party=True):
    """A Pokemon of the player's own, the way build_mon makes one, with a
    personality of its own (not shiny), full PP, the species' name as the
    game prints it and the stats CalcMonStats gives."""
    const = next((row["const"] for row in species_table() if row["id"] == species and not row["egg"]), None)
    if const is None:
        raise ValueError(f"there is no species {species}")
    personality = random.getrandbits(32)
    while is_shiny(personality, me["id"]):
        personality = random.getrandbits(32)
    if nature is not None:
        personality = personality_for_nature(personality, nature, me["id"])
    mon = open_mon(build_mon(const, level, ivs=ivs, evs=evs, item=item, personality=personality,
                             moves=moves, ot_codes=me["codes"], ot_id=me["id"], ot_gender=me["gender"]))
    _, b, c, _ = mon["blocks"]
    table = move_table()
    for i in range(4):
        b[8 + i] = table[struct.unpack_from("<H", b, 2 * i)[0]]["pp"]
    codes = encode_text(species_name(species), POKEMON_NAME_LENGTH)
    c[0:2 * (POKEMON_NAME_LENGTH + 1)] = struct.pack(f"<{POKEMON_NAME_LENGTH + 1}H",
                                                     *codes + [0] * (POKEMON_NAME_LENGTH + 1 - len(codes)))
    _set_party_stats(mon, level)    # build_mon's stats, but Shedinja's one HP
    raw = seal_mon(mon)
    return raw if party else raw[:BOX_MON]


def describe_mon(raw):
    """Everything the page shows about one Pokemon; None for an empty slot,
    {"ok": False} for one whose checksum fails (the game's Bad Egg)."""
    mon = open_mon(raw)
    if mon is None:
        return None
    p = mon["personality"]
    a, b, c, d = mon["blocks"]
    species, item, ot_id, word = struct.unpack_from("<HHII", a, 0)
    if not mon["ok"] or species >= len(personal_records()):
        return {"ok": False, "personality": p}
    exp = word & EXP_BITS
    ivword = struct.unpack_from("<I", b, 0x10)[0]
    mint = (struct.unpack_from("<H", b, 0x1A)[0] & MINT_MASK) >> 1
    nature = mint - 1 if mint else p % 25
    ability = a[0x0D] | (word >> 31) << 8
    moves = []
    for i in range(4):
        move = struct.unpack_from("<H", b, 2 * i)[0]
        if move:
            row = move_table()[move] if move < len(move_table()) else {"name": f"#{move}", "pp": 0}
            moves.append({"id": move, "name": row["name"], "pp": b[8 + i], "pp_ups": b[12 + i],
                          "pp_max": row["pp"] + row["pp"] * b[12 + i] // 5})
    items, abilities, natures = item_table(), bank(ABILITY_NAMES), bank(NATURE_NAMES)
    out = {"ok": True, "personality": p, "species": species, "species_name": species_name(species),
           "form": b[0x18] >> 3, "egg": bool(ivword >> 30 & 1), "nicknamed": bool(ivword >> 31),
           "nickname": decode_text(struct.unpack_from("<11H", c, 0)),
           "exp": exp, "level": level_for(personal_records()[species]["growthRate"], exp),
           "nature": nature, "nature_name": natures[nature] if nature < len(natures) else str(nature),
           "nature_born": p % 25, "mint": mint - 1 if mint else None,
           "ability": ability, "ability_name": abilities[ability] if ability < len(abilities) else str(ability),
           "hidden_ability": bool((b[0x19] >> 6) & HIDDEN_ABILITY_BIT),
           "item": item, "item_name": "" if not item else items[item]["name"] if item in items else f"#{item}",
           "friendship": a[0x0C], "moves": moves,
           "ivs": [(ivword >> (5 * i)) & 31 for i in range(6)], "evs": list(a[0x10:0x16]),
           "ot_name": decode_text(struct.unpack_from("<8H", d, 0)), "ot_id": ot_id & 0xFFFF,
           "ot_sid": ot_id >> 16, "ot_gender": d[0x1C] >> 7, "gender": (b[0x18] >> 1) & 3,
           "shiny": is_shiny(p, ot_id), "ball": d[0x1B], "met_level": d[0x1C] & 0x7F}
    if mon["party"] is not None:
        status, level, _, hp, *stats = struct.unpack_from("<IBBHHHHHHH", mon["party"], 0)
        out.update(level=level, status=status, hp=hp, stats=stats)
    return out


# ---------------------------------------------------------------------------
# The party and the boxes.

PARTY_EXTRA = 8 + PARTY_SIZE * PARTY_MON      # PartyExtra, after PartyCore
PERFORMANCE_MAX = 5                           # sizeof(PartyExtraSub)
NUM_BOXES = MONS_PER_BOX = 30                 # include/constants/pokemon.h
CURRENT_BOX = NUM_BOXES * BOX                 # PokemonStorageSystem.curBox
BOX_MODIFIED = CURRENT_BOX + 4                # .boxModifiedFlag, a bit a box
BOX_NAMES = CURRENT_BOX + 8                   # .box_names, after boxModifiedFlag


def party_raw(save):
    block = save.block("SAVE_PARTY")
    count = struct.unpack_from("<i", block, 4)[0]
    return [bytes(block[8 + i * PARTY_MON:8 + (i + 1) * PARTY_MON]) for i in range(max(0, min(count, PARTY_SIZE)))]


def set_party_mon(save, slot, raw):
    if not 0 <= slot < len(party_raw(save)):
        raise ValueError(f"the party has no slot {slot + 1}")
    save.block("SAVE_PARTY")[8 + slot * PARTY_MON:8 + (slot + 1) * PARTY_MON] = raw


def add_party_mon(save, raw):
    """Party_AddMon: at the end, its Apricorn juice record cleared."""
    block = save.block("SAVE_PARTY")
    count = len(party_raw(save))
    if count >= PARTY_SIZE:
        raise ValueError(f"a party holds {PARTY_SIZE}")
    block[8 + count * PARTY_MON:8 + (count + 1) * PARTY_MON] = raw
    extra = PARTY_EXTRA + count * PERFORMANCE_MAX
    block[extra:extra + PERFORMANCE_MAX] = bytes(PERFORMANCE_MAX)
    struct.pack_into("<i", block, 4, count + 1)


def remove_party_mon(save, slot):
    """Party_RemoveMon: the ones after it move up, and the last is zeroed.
    The last one stays: Continue on an empty party has no one to lead."""
    block = save.block("SAVE_PARTY")
    count = len(party_raw(save))
    if not 0 <= slot < count:
        raise ValueError(f"the party has no slot {slot + 1}")
    if count == 1:
        raise ValueError("the party cannot be left empty")
    for i in range(slot, count - 1):
        block[8 + i * PARTY_MON:8 + (i + 1) * PARTY_MON] = bytes(block[8 + (i + 1) * PARTY_MON:8 + (i + 2) * PARTY_MON])
        extra = PARTY_EXTRA + i * PERFORMANCE_MAX
        block[extra:extra + PERFORMANCE_MAX] = bytes(block[extra + PERFORMANCE_MAX:extra + 2 * PERFORMANCE_MAX])
    last = count - 1
    block[8 + last * PARTY_MON:8 + count * PARTY_MON] = EMPTY_PARTY_MON
    extra = PARTY_EXTRA + last * PERFORMANCE_MAX
    block[extra:extra + PERFORMANCE_MAX] = bytes(PERFORMANCE_MAX)
    struct.pack_into("<i", block, 4, count - 1)


def swap_party_mons(save, one, other):
    """Party_SwapSlots, the Apricorn juice records with them."""
    block = save.block("SAVE_PARTY")
    count = len(party_raw(save))
    if not (0 <= one < count and 0 <= other < count):
        raise ValueError("no such party slot")
    for at, size in ((8, PARTY_MON), (PARTY_EXTRA, PERFORMANCE_MAX)):
        x, y = at + one * size, at + other * size
        block[x:x + size], block[y:y + size] = bytes(block[y:y + size]), bytes(block[x:x + size])


def box_raw(save, box, slot):
    if not (0 <= box < NUM_BOXES and 0 <= slot < MONS_PER_BOX):
        raise ValueError("boxes and their slots are 1 to 30")
    at = box * BOX + slot * BOX_MON
    return bytes(save.block("SAVE_PCSTORAGE")[at:at + BOX_MON])


def set_box_mon(save, box, slot, raw):
    box_raw(save, box, slot)
    at = box * BOX + slot * BOX_MON
    save.block("SAVE_PCSTORAGE")[at:at + BOX_MON] = raw[:BOX_MON]


def deposit(save, slot, box, box_slot):
    """A party Pokemon into an empty box slot, as its BoxPokemon."""
    raw = party_raw(save)
    if not 0 <= slot < len(raw):
        raise ValueError(f"the party has no slot {slot + 1}")
    if len(raw) == 1:
        raise ValueError("the party cannot be left empty")
    if open_mon(box_raw(save, box, box_slot)) is not None:
        raise ValueError(f"box {box + 1} slot {box_slot + 1} is taken")
    set_box_mon(save, box, box_slot, raw[slot])
    remove_party_mon(save, slot)


def withdraw(save, box, box_slot):
    """A boxed Pokemon to the end of the party: the party part built the
    way CalcMonLevelAndStats builds it, at full HP."""
    mon = open_mon(box_raw(save, box, box_slot))
    if mon is None or not mon["ok"]:
        raise ValueError(f"box {box + 1} slot {box_slot + 1} holds nothing that can be taken")
    if len(party_raw(save)) >= PARTY_SIZE:
        raise ValueError(f"a party holds {PARTY_SIZE}")
    a = mon["blocks"][0]
    species = struct.unpack_from("<H", a, 0)[0]
    exp = struct.unpack_from("<I", a, 8)[0] & EXP_BITS
    mon["party"] = bytearray(PARTY_MON - BOX_MON)
    _set_party_stats(mon, level_for(personal_records()[species]["growthRate"], exp))
    add_party_mon(save, seal_mon(mon))
    set_box_mon(save, box, box_slot, EMPTY_BOX_MON)


def boxes(save):
    block = save.block("SAVE_PCSTORAGE")
    names = [decode_text(struct.unpack_from(f"<{BOX_NAME_LENGTH}H", block, BOX_NAMES + 2 * BOX_NAME_LENGTH * n))
             for n in range(NUM_BOXES)]
    return {"current": struct.unpack_from("<i", block, CURRENT_BOX)[0], "names": names,
            "mons": [[describe_mon(box_raw(save, n, s)) for s in range(MONS_PER_BOX)] for n in range(NUM_BOXES)]}


# ---------------------------------------------------------------------------
# The rest of the save, read and written.

MONEY = TRAINER_ID + 4          # PlayerProfile: id, money, gender, language,
GENDER = TRAINER_ID + 8         # johtoBadges, avatar, version, the
PROFILE_FLAGS = TRAINER_ID + 13  # gameClear/natDex bits, dummy, kantoBadges
KANTO_BADGES = TRAINER_ID + 15
COINS = PROFILE + 32            # PLAYERDATA.coins, after the 32-byte profile
PLAY_TIME = COINS + 2           # IGT: u16 hours, u8 minutes, u8 seconds
MAX_MONEY = 999999              # include/player_data.h
MAX_COINS = 50000               # include/coins.h


def profile(save):
    block = save.block("SAVE_PLAYERDATA")
    ident = struct.unpack_from("<I", block, TRAINER_ID)[0]
    return {"name": decode_text(struct.unpack_from(f"<{PLAYER_NAME_LENGTH + 1}H", block, NAME)),
            "id": ident & 0xFFFF, "sid": ident >> 16,
            "money": struct.unpack_from("<I", block, MONEY)[0], "gender": block[GENDER],
            "johto": block[JOHTO_BADGES], "kanto": block[KANTO_BADGES],
            "coins": struct.unpack_from("<H", block, COINS)[0],
            "play_time": list(struct.unpack_from("<HBB", block, PLAY_TIME))}


def set_profile(save, money=None, gender=None, johto=None, kanto=None, coins=None, play_time=None):
    block = save.block("SAVE_PLAYERDATA")
    if money is not None:
        if not 0 <= money <= MAX_MONEY:
            raise ValueError(f"money is 0 to {MAX_MONEY}")
        struct.pack_into("<I", block, MONEY, money)
    if gender is not None:
        if gender not in (0, 1):
            raise ValueError("the gender is 0 or 1")
        block[GENDER] = gender
    for at, bits in ((JOHTO_BADGES, johto), (KANTO_BADGES, kanto)):
        if bits is not None:
            if not 0 <= bits <= 0xFF:
                raise ValueError("eight badges, a bit each")
            block[at] = bits
    if coins is not None:
        if not 0 <= coins <= MAX_COINS:
            raise ValueError(f"coins are 0 to {MAX_COINS}")
        struct.pack_into("<H", block, COINS, coins)
    if play_time is not None:
        hours, minutes, seconds = play_time
        if not (0 <= hours <= 999 and 0 <= minutes < 60 and 0 <= seconds < 60):
            raise ValueError("play time is up to 999:59:59")
        struct.pack_into("<HBB", block, PLAY_TIME, hours, minutes, seconds)


def bag(save):
    block = save.block("SAVE_BAG")
    items = item_table()
    out = {}
    for pocket, count in POCKETS:
        at, _ = pocket_at(pocket)
        slots = [struct.unpack_from("<HH", block, at + 4 * s) for s in range(count)]
        out[pocket] = [{"item": item, "quantity": quantity,
                        "name": items[item]["name"] if item in items else f"#{item}"}
                       for item, quantity in slots if item and quantity]
    return out


def _machine_order(slot):
    """SortTMHMPocket: the TMs, then the TRs, then the HMs, each by item id."""
    const = item_table().get(slot[0], {}).get("const", "")
    return (slot[1] == 0, 2 if const.startswith("ITEM_HM") else 1 if const.startswith("ITEM_TR") else 0, slot[0])


def set_item(save, item, quantity):
    """How many of an item the bag holds, in the pocket the item belongs to.
    0 takes it out and the pocket closes up (PocketCompaction); a new one
    goes in the first free slot, and the berries and the machines are then
    sorted as Bag_AddItem sorts them. A TM is one at most: New Gold never
    uses one up."""
    entry = item_table().get(item)
    if not entry or not entry["pocket"]:
        raise ValueError(f"item {item} goes in no pocket")
    pocket = entry["pocket"]
    limit = 999 if pocket != "TMsHMs" else 1 if entry["const"].startswith("ITEM_TM") else 99
    if not 0 <= quantity <= limit:
        raise ValueError(f"{entry['name']}: 0 to {limit}")
    block = save.block("SAVE_BAG")
    at, count = pocket_at(pocket)
    slots = [list(struct.unpack_from("<HH", block, at + 4 * s)) for s in range(count)]
    held = next((s for s in slots if s[0] == item), None)
    added = False
    if held:
        held[:] = [item, quantity] if quantity else [0, 0]
    elif quantity:
        free = next((s for s in slots if s == [0, 0]), None)
        if free is None:
            raise ValueError(f"the {pocket} pocket is full")
        free[:] = [item, quantity]
        added = True
    if not quantity:
        slots = [s for s in slots if s[1]] + [s for s in slots if not s[1]]
    if added and pocket == "berries":
        slots.sort(key=lambda s: (s[1] == 0, s[0]))
    if added and pocket == "TMsHMs":
        slots.sort(key=_machine_order)
    for s, (got, many) in enumerate(slots):
        struct.pack_into("<HH", block, at + 4 * s, got, many)


UNOWN_SEEN = DEX_GENDERS + 8 * DEX_WORDS + 8   # after spindaPersonality and four form orders
UNOWN_CAUGHT = UNOWN_SEEN + 28


@functools.cache
def dex_species():
    """The species with a Dex page: 1 to NATIONAL_DEX_COUNT but the egg and
    the retail forms numbered between Arceus and the species New Gold adds
    (DexSpeciesIsInvalid)."""
    numbers = species_numbers()
    return [s for s in range(1, NATIONAL_DEX_COUNT + 1) if not numbers["EGG"] <= s <= numbers["ROTOM_MOW"]]


def _dex_bit(block, at, species):
    return (block[at + ((species - 1) >> 3)] >> ((species - 1) & 7)) & 1


def dex(save):
    block = save.block("SAVE_POKEDEX")
    seen = [s for s in dex_species() if _dex_bit(block, DEX_SEEN, s)]
    # Pokedex_CheckMonCaughtFlag wants both flags.
    caught = [s for s in seen if _dex_bit(block, DEX_CAUGHT, s)]
    return {"enabled": bool(block[DEX_ENABLED]), "national": bool(block[DEX_NATIONAL]),
            "seen": seen, "caught": caught}


def set_dex(save, species, seen, caught):
    """Seen and caught for these species; caught is only caught when seen, as
    the game reads it. Unown seen with no letter recorded gets A, so the
    Dex's form page has one to show."""
    block = save.block("SAVE_POKEDEX")
    valid = set(dex_species())
    seen = seen or caught
    for s in species:
        if s not in valid:
            raise ValueError(f"species {s} has no Dex page")
        for at, on in ((DEX_SEEN, seen), (DEX_CAUGHT, caught)):
            bit = 1 << ((s - 1) & 7)
            block[at + ((s - 1) >> 3)] = block[at + ((s - 1) >> 3)] | bit if on else block[at + ((s - 1) >> 3)] & ~bit
        if s == species_numbers()["UNOWN"]:
            for at, on in ((UNOWN_SEEN, seen), (UNOWN_CAUGHT, caught)):
                if on and block[at] == 0xFF:
                    block[at] = 0


def set_dex_switches(save, enabled=None, national=None):
    """The Dex itself, and the National Dex -- which the script that gives
    it sets twice, in the Dex and in the profile (PlayerProfile.natDex)."""
    block = save.block("SAVE_POKEDEX")
    if enabled is not None:
        block[DEX_ENABLED] = int(bool(enabled))
    if national is not None:
        block[DEX_NATIONAL] = int(bool(national))
        player = save.block("SAVE_PLAYERDATA")
        player[PROFILE_FLAGS] = (player[PROFILE_FLAGS] & ~2) | (2 if national else 0)


def position(save):
    block = save.block("SAVE_LOCAL_FIELD_DATA")
    fields = ("map", "warp", "x", "y", "direction")
    return {"current": dict(zip(fields, struct.unpack_from("<5i", block, 0))),
            "warp": dict(zip(fields, struct.unpack_from("<5i", block, 3 * LOCATION))),
            "by_warp": flag_is_set(save, FLAG_CONTINUE_BY_WARP)}


VAR_BASE = 0x4000               # include/constants/vars.h


def num_flags():
    return constants("include/constants/flags.h", "NUM_")["NUM_FLAGS"]


def flag_is_set(save, number):
    return bool((save.block("SAVE_FLAGS")[NUM_VARS * 2 + number // 8] >> (number % 8)) & 1)


def write_flag(save, number, on):
    if not 0 < number < num_flags():
        raise ValueError(f"flag {number:#x} is not one the save keeps")
    flags = save.block("SAVE_FLAGS")
    at = NUM_VARS * 2 + number // 8
    flags[at] = flags[at] | (1 << (number % 8)) if on else flags[at] & ~(1 << (number % 8))


def var_value(save, number):
    return struct.unpack_from("<H", save.block("SAVE_FLAGS"), 2 * (number - VAR_BASE))[0]


def write_var(save, number, value):
    if not VAR_BASE <= number < VAR_BASE + NUM_VARS:
        raise ValueError(f"variable {number:#x} is not one the save keeps")
    if not 0 <= value <= 0xFFFF:
        raise ValueError("a variable is 0 to 65535")
    struct.pack_into("<H", save.block("SAVE_FLAGS"), 2 * (number - VAR_BASE), value)


def find_flags(save, query, limit=300):
    """The flags and variables the save keeps whose name holds the query."""
    query = query.upper()
    out = []
    for name, number in constants("include/constants/flags.h", "FLAG_").items():
        if query in name and 0 < number < num_flags() and not name.startswith("FLAG_ACTION_"):
            out.append({"kind": "flag", "name": name, "number": number, "value": int(flag_is_set(save, number))})
    for name, number in constants("include/constants/vars.h", "VAR_").items():
        if query in name and VAR_BASE <= number < VAR_BASE + NUM_VARS:
            out.append({"kind": "var", "name": name, "number": number, "value": var_value(save, number)})
    return out[:limit]


def info(save):
    return {"half": save.half, "counter": save.counter(),
            "halves": [{"at": h, "valid": save.valid(h), "counter": save.counter(h)} for h in (0, HALF)],
            "blocks": [{k: b[k] for k in ("index", "id", "offset", "size", "slot")} for b in save.table],
            "slots": save.specs}


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("save", type=Path)
    parser.add_argument("--show", action="store_true")
    parser.add_argument("--tm", metavar="N[,N...]",
                        help="put these machines in the bag, e.g. 1,2,26")
    parser.add_argument("--dex", metavar="SPECIES[,...]",
                        help="mark these seen and caught, and switch the Dex on")
    parser.add_argument("--box", metavar="N:SPECIES:LEVEL",
                        help="put one Pokemon in box N, counted from one")
    parser.add_argument("--party", metavar="SPECIES:LEVEL[:NATURE][,...]",
                        help="fill the party, e.g. CHIKORITA:5,PIDGEY:3")
    parser.add_argument("--name", help="the player's name, which the save must carry "
                                       "terminated: the main menu copies it into a String "
                                       "and asserts on one that never ends")
    parser.add_argument("--trainer-id", type=int)
    parser.add_argument("--badges", type=int, help="how many Johto badges to set")
    parser.add_argument("--var", action="append", default=[], metavar="VAR_NAME=VALUE",
                        help="set a script variable by its name in include/constants/vars.h; repeatable")
    parser.add_argument("--flag", action="append", default=[], metavar="FLAG_NAME",
                        help="set a script flag by its name in include/constants/flags.h; repeatable")
    parser.add_argument("--where", metavar="MAP:X:Y[:DIR]",
                        help="put the player on a map, the way the save records it: "
                             "LocalFieldData.currentPosition, which is a Location of "
                             "mapId, warpId, x, y and direction")
    parser.add_argument("--from-ram", type=Path,
                        help="a boot_check memory dump; the game lays out a whole "
                             "save region before the title screen, and this seals it "
                             "into a file the game will load")
    args = parser.parse_args()

    if args.from_ram:
        seal_from_ram(args.from_ram, args.save)
        print(f"wrote {args.save} from {args.from_ram}")

    save = Save(args.save)

    if args.name:
        set_name(save, args.name)
        save.write()
        print(f"named the player {args.name}")

    if args.party:
        wanted = parse_party(args.party)
        set_party(save, wanted)
        save.write()
        print("party: " + ", ".join(f"{n} at level {l}" for n, l, _, _ in wanted))

    if args.tm:
        machines = [int(n) for n in args.tm.split(",")]
        add_machines(save, machines)
        save.write()
        print(f"bag: TM{', TM'.join(f'{n:02d}' for n in machines)}")

    if args.dex:
        mark_dex(save, args.dex.upper().split(","))
        save.write()
        print(f"dex: {args.dex.upper()} seen and caught, and the Dex is on")

    if args.box:
        number, name, level = args.box.split(":")
        put_in_box(save, int(number), name, level)
        save.write()
        print(f"box {int(number)}: {name.upper()} at level {level}")

    if args.trainer_id is not None:
        set_trainer_id(save, args.trainer_id)
        save.write()
        print(f"trainer id {args.trainer_id}")

    if args.badges is not None:
        set_badges(save, args.badges)
        save.write()
        print(f"{args.badges} Johto badges")

    for assignment in args.var:
        name, _, value = assignment.partition("=")
        number = set_var(save, name, value)
        save.write()
        print(f"{name} ({number:#x}) = {value}")

    for name in args.flag:
        number = set_flag(save, name)
        save.write()
        print(f"{name} ({number:#x}) set")

    if args.where:
        parts = args.where.split(":")
        map_id, x, y = (int(v) for v in parts[:3])
        direction = int(parts[3]) if len(parts) > 3 else 0
        set_position(save, map_id, x, y, direction)
        save.write()
        print(f"put the player on map {map_id} at ({x}, {y}) facing {direction}, by warp")

    print(f"{args.save}: half {save.half:#x} is newest, "
          f"save counter {save._footer(save.half, save.specs[0])['count']}")
    if args.show:
        for b in save.table:
            print(f"  {b['index']:2d} {b['id']:<36s} {b['offset']:#08x} {b['size']:6d} {b['slot']}")
        for spec in save.specs:
            print(f"  slot {spec['slot']:<2} {spec['offset']:#08x} {spec['size']:7d}")


if __name__ == "__main__":
    main()
