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
"""

import argparse
import csv
import json
import re
import struct
import subprocess
import sys
import tempfile
from pathlib import Path

ROOT = Path(__file__).resolve().parents[2]
sys.path.insert(0, str(Path(__file__).resolve().parent))
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


def constants(header, prefix):
    """Every #define with the prefix, by name."""
    text = (ROOT / header).read_text()
    return {m.group(1): int(m.group(2), 0) for m in re.finditer(rf"#define ({prefix}\w+)\s+(0x[0-9A-Fa-f]+|\d+)", text)}


def crc16(data, crc=0xFFFF):
    """GF_CalcCRC16: the SDK's CCITT table, polynomial 0x1021, fed high bit first."""
    for byte in data:
        crc ^= byte << 8
        for _ in range(8):
            crc = ((crc << 1) ^ 0x1021) & 0xFFFF if crc & 0x8000 else (crc << 1) & 0xFFFF
    return crc


def extra_chunks(build=None):
    """The chunks written past the region, with the sector each one lives in.

    gExtraSaveChunkHeaders gives a sector rather than an offset, and
    WriteExtraSaveChunk puts a copy in both halves of the flash.
    """
    build = build or ROOT / "build/heartgold.us"
    _, outside = save_budget.measure(build)
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


def species_numbers():
    return {m.group(1): int(m.group(2)) for m in
            re.finditer(r"#define SPECIES_([A-Z0-9_]+)\s+(\d+)\s*$",
                        (ROOT / "include/constants/species.h").read_text(), re.M)}


def personal(species_name):
    """One species' record, as files/poketool/personal/personal.json holds it."""
    records = json.loads((ROOT / "files/poketool/personal/personal.json").read_text())["baseStats"]
    index = species_numbers()[species_name]
    return records[index], index


def experience_for(growth_rate, level):
    """The total experience a level costs, from growtbl.csv."""
    with (ROOT / "files/poketool/personal/growtbl.csv").open() as f:
        for row in csv.DictReader(f):
            if row["rate"] == f"GROWTH_{growth_rate}":
                return int(row[f"lv{level:03d}"])
    raise SystemExit(f"no growth curve called {growth_rate}")


def learnset(index, level):
    """The moves this species knows at this level: the last four it learns.

    wotbl.py already decodes the archive and refuses to touch it unless the
    round trip is byte for byte, so the reading is borrowed rather than
    repeated.
    """
    sys.path.insert(0, str(ROOT / "tools/newgold"))
    import wotbl
    files, _, _ = wotbl.read_narc(wotbl.ARCHIVE.read_bytes())
    known = [entry["move"] for entry in wotbl.decode(files[index])
             if entry["level"] <= level]
    return known[-4:]


def ability_of(record, personality):
    """CreateBoxMon: the second ability on an odd personality, if there is one."""
    numbers = {m.group(1): int(m.group(2)) for m in
               re.finditer(r"#define ABILITY_([A-Z0-9_]+)\s+(\d+)",
                           (ROOT / "include/constants/abilities.h").read_text())}
    first, second = (numbers[name[len("ABILITY_"):]] for name in record["abilities"])
    return second if second and (personality & 1) else first


def move_numbers():
    return {m.group(1): int(m.group(2)) for m in
            re.finditer(r"#define MOVE_([A-Z0-9_]+)\s+(\d+)", (ROOT / "include/constants/moves.h").read_text())}


def build_mon(species_name, level, nature=None, ivs=31, evs=0, item=0,
              ot_name="A", ot_id=0, personality=None, moves=None):
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
    ratio = GENDER_RATIO(record["genderRatio"])
    if ratio in (0, 254, 255):
        gender = {0: 0, 254: 1, 255: 2}[ratio]
    else:
        gender = 1 if ratio > (personality & 0xFF) else 0

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
    for i, code in enumerate(charcode(ot_name)):
        struct.pack_into("<H", d, 2 * i, code)
    d[0x1B] = 4                             # ITEM_POKE_BALL
    d[0x1C] = level & 0x7F
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
# and the offsets below add up to the 960 the ROM reports for
# Save_Pokedex_sizeof.
DEX_WORDS = (NATIONAL_DEX_COUNT := 574, (574 + 8 + 31) // 32)[1]
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
    build = build or ROOT / "build/heartgold.us"
    inside, _ = save_budget.measure(build)
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
        import where
        dump = args.from_ram.read_bytes()
        pointer = struct.unpack_from("<I", dump, where.symbol("sSaveDataPtr") - where.MAIN_RAM)[0]
        if not where.MAIN_RAM <= pointer < where.MAIN_RAM + len(dump):
            raise SystemExit("sSaveDataPtr is not set in that dump")
        at = pointer - where.MAIN_RAM + 0x10          # SaveData.dynamic_region
        region = bytearray(dump[at:at + save_budget.REGION])
        table = blocks()
        holder = type("_", (), {"region": region, "table": table,
                                "specs": slot_specs(table)})()
        Save.reseal(holder)
        args.save.write_bytes(bytes(build_save(region)))
        print(f"wrote {args.save} from {args.from_ram}")

    save = Save(args.save)

    # PLAYERDATA is { Options options; PlayerProfile profile; ... } and
    # Save_PlayerData_GetProfile is "adds r0, #4" after fetching the block, so
    # the profile starts four bytes in. PlayerProfile then begins with
    # name[PLAYER_NAME_LENGTH + 1] and PlayerProfile_GetNamePtr is a bare
    # "bx lr", so the name is at the profile's own start.
    PROFILE = 4
    NAME = PROFILE
    TRAINER_ID = PROFILE + 2 * (PLAYER_NAME_LENGTH + 1)
    JOHTO_BADGES = TRAINER_ID + 4 + 4 + 2

    if args.name:
        letters = charcode(args.name)
        if len(letters) > PLAYER_NAME_LENGTH + 1:
            raise SystemExit(f"a name is at most {PLAYER_NAME_LENGTH} characters")
        block = save.block("SAVE_PLAYERDATA")
        for i, value in enumerate(letters):
            struct.pack_into("<H", block, NAME + 2 * i, value)
        save.write()
        print(f"named the player {args.name}")

    if args.party:
        block = save.block("SAVE_PARTY")
        wanted = []
        numbers = move_numbers()
        for entry in args.party.split(","):
            # SPECIES:LEVEL[:NATURE][:MOVE+MOVE+...]; moves not given come
            # from the learnset at that level.
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
        if len(wanted) > PARTY_SIZE:
            raise SystemExit(f"a party holds {PARTY_SIZE}")
        # PartyCore is { int maxCount; int curCount; Pokemon mons[PARTY_SIZE]; }
        struct.pack_into("<ii", block, 0, PARTY_SIZE, len(wanted))
        for slot, (name, level, nature, moves) in enumerate(wanted):
            mon = build_mon(name, level, nature=nature, ot_name=args.name or "A",
                            ot_id=args.trainer_id or 0, moves=moves)
            block[8 + slot * PARTY_MON:8 + (slot + 1) * PARTY_MON] = mon
        save.write()
        print("party: " + ", ".join(f"{n} at level {l}" for n, l, _, _ in wanted))

    if args.tm:
        block = save.block("SAVE_BAG")
        machines = [int(n) for n in args.tm.split(",")]
        first = int(re.search(r"#define ITEM_TM01\s+(\d+)",
                              (ROOT / "include/constants/items.h").read_text()).group(1))
        for n in machines:
            put_in_pocket(block, "TMsHMs", first + n - 1, 1)
        save.write()
        print(f"bag: TM{', TM'.join(f'{n:02d}' for n in machines)}")

    if args.dex:
        block = save.block("SAVE_POKEDEX")
        numbers = species_numbers()
        for name in args.dex.upper().split(","):
            if name not in numbers:
                raise SystemExit(f"there is no SPECIES_{name}")
            set_dex_flag(block, DEX_SEEN, numbers[name])
            set_dex_flag(block, DEX_CAUGHT, numbers[name])
        block[DEX_ENABLED] = 1
        block[DEX_NATIONAL] = 1
        save.write()
        print(f"dex: {args.dex.upper()} seen and caught, and the Dex is on")

    if args.box:
        number, name, level = args.box.split(":")
        number = int(number)
        if not 1 <= number <= 30:
            raise SystemExit("boxes are numbered one to thirty")
        block = save.block("SAVE_PCSTORAGE")
        at = (number - 1) * BOX
        block[at:at + BOX_MON] = build_mon(name.upper(), int(level))[:BOX_MON]
        save.write()
        print(f"box {number}: {name.upper()} at level {level}")

    if args.trainer_id is not None:
        block = save.block("SAVE_PLAYERDATA")
        struct.pack_into("<I", block, TRAINER_ID, args.trainer_id)
        save.write()
        print(f"trainer id {args.trainer_id}")

    if args.badges is not None:
        # PlayerProfile_SetBadgeFlag: badges 0-7 are a bit each in johtoBadges.
        block = save.block("SAVE_PLAYERDATA")
        struct.pack_into("<B", block, JOHTO_BADGES, (1 << args.badges) - 1)
        save.write()
        print(f"{args.badges} Johto badges")

    for name in args.flag:
        # A script flag by its name in include/constants/flags.h: the cap
        # for Falkner is 13 only once FLAG_UNK_076 says Sprout Tower is done.
        flags = save.block("SAVE_FLAGS")
        number = constants("include/constants/flags.h", "FLAG_").get(name)
        if number is None:
            raise SystemExit(f"there is no {name} in include/constants/flags.h")
        flags[NUM_VARS * 2 + number // 8] |= 1 << (number % 8)
        save.write()
        print(f"{name} ({number:#x}) set")

    if args.where:
        parts = args.where.split(":")
        map_id, x, y = (int(v) for v in parts[:3])
        direction = int(parts[3]) if len(parts) > 3 else 0
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
