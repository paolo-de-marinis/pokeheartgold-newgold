#!/usr/bin/env python3
"""Read and write a save file through this repository's own structures.

Playing the adventure to reach each thing that needs checking is the long
road: a Pokedex entry is an hour of walking away, the thirtieth box needs a
Pokemon Centre, the machine labels need a gym. The save holds all of it, and
the save is decompiled here, so it can be prepared instead.

Nothing here is a guessed offset. The block table is the one
SaveData_InitSubstructs builds, measured out of the built ROM by save_budget;
the flash mapping is GetChunkOffsetFromCurrentSaveSlot; the two checksums are
SaveSubstruct_UpdateCRC and SaveSlot_BuildFooter; and every size, offset
and limit of the save is what the host compiler makes of this repository's
headers as they are now (_layout). Where a field is packed rather than
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
import itertools
import json
import random
import re
import struct
import subprocess
import sys
import tempfile
import threading
from pathlib import Path

ROOT = Path(__file__).resolve().parents[3]
sys.path.insert(0, str(Path(__file__).resolve().parent / "harness"))
import save_budget  # noqa: E402

GENDER_RATIO = lambda frac: int(frac * 254.75) if frac <= 1 else 255   # GENDER_RATIO, constants/pokemon.h
HALF = 0x40000                  # GetChunkOffsetFromCurrentSaveSlot
FLASH = 2 * HALF                # the two halves the game saves in by turns
MAX_PLAY_HOURS = 999            # where AddIGTSeconds stops the clock, at 999:59:59
# Every other size, offset and limit of the save is read from the headers
# by _layout(), below, and set again when one changes.


# What the game data is, read from the tree as it is now. A reader's result
# is kept (tree_cache) only while every file it read (source) is unchanged:
# fresh() forgets them all once one of those files has moved on, so an
# edited table is what the editor shows, offers and enforces next.
_READ = {}
_CACHES = []
GENERATION = 0      # how many times fresh() has found the tree changed
_FORGETTING = threading.Lock()      # fresh()'s forgetting against a reading being kept


def source(path):
    """A file of the tree, noted with its modification time for fresh()."""
    path = ROOT / path
    _READ.setdefault(path, path.stat().st_mtime_ns)
    return path


def tree_cache(fn):
    """functools.cache for a reader of the tree, forgotten by fresh(). A
    reading fresh() overtook -- saveui serves requests in threads, and a
    file changed while one was reading it -- is returned but not kept: it
    may be the old file's, and fresh() has already forgotten that file."""
    kept = {}

    @functools.wraps(fn)
    def read(*args, **kwargs):
        key = (args, tuple(sorted(kwargs.items())))
        if key in kept:
            return kept[key]
        seen = GENERATION
        value = fn(*args, **kwargs)
        with _FORGETTING:
            if seen == GENERATION:
                kept[key] = value
        return value
    read.cache_clear = kept.clear
    _CACHES.append(read)
    return read


def fresh():
    """Every cached reading dropped if a file behind one has changed since.
    saveui calls it before each request; a CLI run reads the tree once."""
    def moved(path, when):
        try:
            return path.stat().st_mtime_ns != when
        except OSError:
            return True
    global GENERATION
    if any(moved(path, when) for path, when in list(_READ.items())):
        with _FORGETTING:
            GENERATION += 1
            _READ.clear()
            for fn in _CACHES:
                fn.cache_clear()
        globals().update(_layout())


@tree_cache
def constants(header, prefix):
    """Every #define with the prefix whose value is a number, by name, as
    the compiler takes it: a comment after the value is not part of it, a
    define commented out or given an expression is not read as a number."""
    text = source(header).read_text()
    return {m.group(1): int(m.group(2), 0) for m in re.finditer(
        rf"^[ \t]*#define ({prefix}\w+)[ \t]+(0x[0-9A-Fa-f]+|\d+)[ \t]*(?://.*|/\*.*)?$", text, re.M)}


def c_function(path, head):
    """The body of the C function in `path` whose definition starts with `head`."""
    text = source(path).read_text()
    at = re.search(re.escape(head) + r"[^;{]*\{", text).start()     # not a prototype
    return text[at:text.index("\n}\n", at)]


def c_table(path, name):
    """What a C array in `path` is initialized with, braces and all."""
    text = source(path).read_text()
    at = re.search(rf"\b{name}\[[^=;]*\]\s*=\s*\{{", text).end()
    return text[at:text.index("};", at)]


# ---------------------------------------------------------------------------
# The save's layout, as this tree's headers give it: the host compiler reads
# them the way config.mk has the game's read -- its defines, 32-bit pointers,
# signed char, C89 -- and says what each size, offset and constant comes to.
# _layout() puts them in this module's names; fresh() does it again when a
# header has changed since.

LAYOUT_HEADERS = ("global.h", "constants/global.h", "constants/pokemon.h", "constants/species.h",
                  "constants/items.h", "constants/vars.h", "constants/flags.h", "constants/mail.h",
                  "constants/easy_chat.h", "constants/charcode.h", "pokemon_types_def.h", "bag_types_def.h",
                  "pokedex.h", "player_data.h", "pokemon_storage_system.h", "save.h", "save_vars_flags.h",
                  "field_types_def.h", "terrain_attributes.h")


@tree_cache
def build_defines():
    """The -D flags config.mk gives the compiler, for the game it builds
    when nothing else is said (its ?= defaults)."""
    mk = source("config.mk").read_text()
    defaults = dict(re.findall(r"^(\w+)\s*\?=\s*(\S+)", mk, re.M))
    flags = []
    for var in ("GF_DEFINES", "GLB_DEFINES"):
        line = re.search(rf"^{var}\s*:=\s*(.*)$", mk, re.M).group(1)
        flags += re.sub(r"\$\((\w+)\)", lambda m: defaults[m.group(1)], line).split()
    return flags


@tree_cache
def compile_c(exprs=(), inits=(), headers=LAYOUT_HEADERS):
    """What the host compiler makes of the headers: each of `exprs`, a C
    constant expression, as a number, and each of `inits`, a (type,
    designated initializer) pair, as the bytes of that value -- which is
    where a bitfield sits. Nothing is run: the values are read out of the
    assembly the compiler writes. Every header it read is noted for fresh()."""
    lines = [f'#include "{h}"' for h in headers]
    lines.append(f"const unsigned int probe_values[] = {{ {', '.join(f'(unsigned int)({e})' for e in exprs) or 0} }};")
    for i, (kind, init) in enumerate(inits):
        lines.append(f"const union {{ {kind} v; unsigned char raw[sizeof({kind})]; }} probe_init_{i} = "
                     f"{{ .v = {{ {init} }} }};")
    with tempfile.TemporaryDirectory() as tmp:
        c = Path(tmp) / "probe.c"
        c.write_text("\n".join(lines) + "\n")
        run = subprocess.run(["cc", "-std=gnu89", "-m32", "-fsigned-char", "-w", "-S", "-o", "-", "-MD", "-MF",
                              str(Path(tmp) / "probe.d"), *build_defines(), str(c),
                              *(f"-I{ROOT / d}" for d in ("include", "include/library", "files", "lib/include"))],
                             capture_output=True, text=True)
        if run.returncode:
            raise SystemExit(f"the host compiler could not read the headers:\n{run.stderr[:1200]}")
        for dep in (Path(tmp) / "probe.d").read_text().replace("\\\n", " ").split()[1:]:
            if Path(dep).resolve().is_relative_to(ROOT):
                source(Path(dep).resolve().relative_to(ROOT))
    data, symbol = {}, None
    for line in run.stdout.splitlines():
        label = re.fullmatch(r"(probe_\w+):", line)
        if label:
            symbol = data.setdefault(label.group(1), bytearray())
            continue
        directive = re.fullmatch(r"\s*\.(long|value|short|byte|zero|quad)\s+(-?\w+)", line)
        if symbol is not None and directive:
            kind, value = directive.group(1), int(directive.group(2), 0)
            if kind == "zero":
                symbol += bytes(value)
            else:
                size = {"long": 4, "value": 2, "short": 2, "byte": 1, "quad": 8}[kind]
                symbol += (value % (1 << 8 * size)).to_bytes(size, "little")
        elif not line.startswith("\t."):
            symbol = None
    values = list(struct.unpack(f"<{len(exprs)}I", bytes(data["probe_values"][:4 * len(exprs)])))
    return values, [bytes(data[f"probe_init_{i}"]) for i in range(len(inits))]


def set_bit(raw):
    """(byte, bit) of the first bit set in an initialized value's bytes."""
    at = next(i for i, b in enumerate(raw) if b)
    return at, (raw[at] & -raw[at]).bit_length() - 1


def _layout():
    """The save's layout, by the names this module uses for it."""
    offset = "__builtin_offsetof"
    names = {
        "GAME_VERSION": "GAME_VERSION", "GAME_LANGUAGE": "GAME_LANGUAGE",
        "PLAYER_NAME_LENGTH": "PLAYER_NAME_LENGTH", "POKEMON_NAME_LENGTH": "POKEMON_NAME_LENGTH",
        "PARTY_SIZE": "PARTY_SIZE", "EOS": "EOS",
        "BOX_MON": "sizeof(BoxPokemon)", "PARTY_MON": "sizeof(Pokemon)", "BLOCK": "sizeof(PokemonDataBlock)",
        "LOCATION": "sizeof(Location)",
        "CHUNK_MAGIC": "SAVE_CHUNK_MAGIC", "CHUNK_FOOTER": "sizeof(struct SaveChunkFooter)",
        "CHUNK_CRC_AT": f"{offset}(struct SaveChunkFooter, crc)",
        "ARRAY_FOOTER": "sizeof(struct SaveArrayFooter)", "FOOTER_CRC_AT": f"{offset}(struct SaveArrayFooter, crc)",
        # SAVE_PLAYERDATA: the options, the profile, the coins, the play time.
        "PROFILE": f"{offset}(PLAYERDATA, profile)", "NAME_IN_PROFILE": f"{offset}(PlayerProfile, name)",
        "ID_IN_PROFILE": f"{offset}(PlayerProfile, id)", "MONEY_IN_PROFILE": f"{offset}(PlayerProfile, money)",
        "GENDER_IN_PROFILE": f"{offset}(PlayerProfile, gender)",
        "JOHTO_IN_PROFILE": f"{offset}(PlayerProfile, johtoBadges)",
        "KANTO_IN_PROFILE": f"{offset}(PlayerProfile, kantoBadges)",
        "COINS": f"{offset}(PLAYERDATA, coins)", "PLAY_TIME": f"{offset}(PLAYERDATA, igt)",
        "MAX_MONEY": "MAX_MONEY", "MAX_COINS": "MAX_COINS",
        # SAVE_FLAGS: the variables, then the flags. FLAG_UNK_966 is the one
        # CallFieldTask_ContinueGame_Normal reads: Continue warps in.
        "NUM_VARS": "NUM_VARS", "VAR_BASE": "VAR_BASE", "FLAGS_AT": f"{offset}(SaveVarsFlags, flags)",
        "FLAG_CONTINUE_BY_WARP": "FLAG_UNK_966",
        # SAVE_POKEDEX, whose flag words NATIONAL_DEX_COUNT sizes.
        "NATIONAL_DEX_COUNT": "NATIONAL_DEX_COUNT", "FIRST_DEX_GAP": "FIRST_DEX_GAP", "LAST_DEX_GAP": "LAST_DEX_GAP",
        "DEX_CAUGHT": f"{offset}(Pokedex, caughtSpecies)", "DEX_SEEN": f"{offset}(Pokedex, seenSpecies)",
        "DEX_ENABLED": f"{offset}(Pokedex, dexEnabled)", "DEX_NATIONAL": f"{offset}(Pokedex, nationalDex)",
        "UNOWN_SEEN": f"{offset}(Pokedex, unownSeenOrder)", "UNOWN_CAUGHT": f"{offset}(Pokedex, unownCaughtOrder)",
        # SAVE_PCSTORAGE.
        "NUM_BOXES": "NUM_BOXES", "MONS_PER_BOX": "MONS_PER_BOX", "BOX_NAME_LENGTH": "BOX_NAME_LENGTH",
        "BOX": "sizeof(PC_BOX)", "CURRENT_BOX": f"{offset}(struct PokemonStorageSystem, curBox)",
        "BOX_MODIFIED": f"{offset}(struct PokemonStorageSystem, boxModifiedFlag)",
        "BOX_NAMES": f"{offset}(struct PokemonStorageSystem, box_names)",
        # SAVE_PARTY: PartyCore's counts and Pokemon, then PartyExtra's
        # Apricorn juice records.
        "PARTY_COUNT_AT": f"{offset}(PartyCore, curCount)", "PARTY_AT": f"{offset}(PartyCore, mons)",
        "PARTY_EXTRA": f"{offset}(Party, extra)", "PERFORMANCE_MAX": "sizeof(PartyExtraSub)",
        "MAIL_AT": f"{offset}(PartyPokemon, mail)",
        # Mail_Init's values, and the ball a Pokemon made here comes in.
        "PLAYER_GENDER_MALE": "PLAYER_GENDER_MALE", "MAIL_NONE": "MAIL_NONE", "MAILMSG_BANK_NONE": "MAILMSG_BANK_NONE",
        "MAILMSG_FIELDS_MAX": "MAILMSG_FIELDS_MAX", "EC_WORD_NULL": "EC_WORD_NULL", "ITEM_POKE_BALL": "ITEM_POKE_BALL",
        # The bits a Pokemon keeps its hidden ability and its Capsule in.
        "HIDDEN_ABILITY_BIT": "MON_HIDDEN_ABILITY_BIT", "SWAP_ABILITY_BIT": "MON_SWAP_ABILITY_SLOT_BIT",
        "CHUNK_TILES": "MAP_TILES_COUNT_X",
        # GetGenderBySpeciesAndPersonality's, and how many of an item a slot takes.
        "MON_RATIO_MALE": "MON_RATIO_MALE", "MON_RATIO_FEMALE": "MON_RATIO_FEMALE",
        "MON_RATIO_UNKNOWN": "MON_RATIO_UNKNOWN", "MON_MALE": "MON_MALE", "MON_FEMALE": "MON_FEMALE",
        "MON_GENDERLESS": "MON_GENDERLESS",
        "BAG_SLOT_QUANTITY_MAX": "BAG_SLOT_QUANTITY_MAX", "BAG_TMHM_QUANTITY_MAX": "BAG_TMHM_QUANTITY_MAX",
        # What a Pokemon can be: its level, nature, moves, stats and EVs.
        "MAX_LEVEL": "MAX_LEVEL", "NATURE_NUM": "NATURE_NUM", "MAX_MON_MOVES": "MAX_MON_MOVES",
        "NUM_STATS": "NUM_STATS", "MAX_EV_PER_STAT": "MAX_EV_PER_STAT", "MAX_EV_SUM": "MAX_EV_SUM",
        "DIR_MAX": "DIR_MAX",   # the directions the player can face
        "DYNAMIC_REGION": f"{offset}(SaveData, dynamic_region)",   # where the region sits in RAM's SaveData
    }
    values, (natdex, ivs, forms) = compile_c(tuple(names.values()), (("PlayerProfile", ".natDex = 1"),
                                                                     ("PokemonDataBlockB", ".hpIV = ~0u"),
                                                                     ("PokemonDataBlockB", ".form = ~0u")))
    out = dict(zip(names, values))
    at = out["PROFILE"]
    out.update(NAME=at + out["NAME_IN_PROFILE"], TRAINER_ID=at + out["ID_IN_PROFILE"], MONEY=at + out["MONEY_IN_PROFILE"],
               GENDER=at + out["GENDER_IN_PROFILE"], JOHTO_BADGES=at + out["JOHTO_IN_PROFILE"],
               KANTO_BADGES=at + out["KANTO_IN_PROFILE"])
    byte, bit = set_bit(natdex)
    out.update(PROFILE_FLAGS=at + byte, NATDEX_MASK=1 << bit)
    byte, bit = set_bit(ivs)
    out["MAX_IV"] = int.from_bytes(ivs[byte:byte + 4], "little") >> bit   # the most an IV's field holds
    byte, bit = set_bit(forms)
    out["MAX_FORM"] = forms[byte] >> bit                                   # and a form's
    out["MINT_MASK"] = constants("src/pokemon.c", "MON_MINT_")["MON_MINT_NATURE_MASK"]   # pokemon.c's own
    out["PAGES_PER_HALF"] = HALF // save_budget.SAVE_SECTOR_SIZE
    # ZeroMonData: zeroes, "encrypted" under a checksum and a personality of 0.
    out["EMPTY_BOX_MON"] = bytes(8) + mon_crypt(bytes(out["BOX_MON"] - 8), 0)
    out["EMPTY_PARTY_MON"] = out["EMPTY_BOX_MON"] + mon_crypt(bytes(out["PARTY_MON"] - out["BOX_MON"]), 0)
    # PartyPokemon.mail as Mail_Init leaves it -- CreateMon and the
    # box-to-party copy both run it: no author (a name all EOS), MAIL_NONE,
    # no icons, and three MailMsg_Init messages (MAILMSG_BANK_NONE, the words
    # EC_WORD_NULL, the number left alone). An all-zero one has an author
    # name with no EOS, and reading a Mail held on it ends in
    # CopyU16ArrayToString's assertion and the error screen.
    name, fields = out["PLAYER_NAME_LENGTH"] + 1, out["MAILMSG_FIELDS_MAX"]
    message = struct.pack(f"<HH{fields}H", out["MAILMSG_BANK_NONE"], 0, *[out["EC_WORD_NULL"]] * fields)
    out["MAIL_INIT"] = struct.pack(f"<IBBBB{name}H3HH", 0, out["PLAYER_GENDER_MALE"], out["GAME_LANGUAGE"],
                                   out["GAME_VERSION"], out["MAIL_NONE"], *[out["EOS"]] * name, *[0xFFFF] * 3,
                                   0) + message * 3
    return out


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


def build_behind(build=None):
    """The headers the save's layout is read from (_layout) saved after the
    build was linked. The blocks' sizes are measured from the build -- the
    game's Save_*_sizeof functions exist in no other form -- and the fields
    inside them are read from the headers: until make runs again, a
    changed struct can make the two disagree."""
    linked = (Path(build or ROOT / "build/heartgold.us") / "main.elf").stat().st_mtime_ns
    newer = []
    for path in list(_READ):
        try:
            if path.suffix == ".h" and path.stat().st_mtime_ns > linked:
                newer.append(str(path.relative_to(ROOT)))
        except OSError:
            continue
    return sorted(newer)


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


@tree_cache
def block_order():
    """GetSubstruct (src/pokemon.c): the bits of the personality it picks a
    row by, as (mask, shift), and its rows -- where block A, B, C and D sit,
    counted in blocks."""
    body = c_function("src/pokemon.c", "PokemonDataBlock *GetSubstruct(")
    rows = [tuple(int(v, 0) // BLOCK for v in re.findall(r"0x[0-9A-Fa-f]+|\d+", row))
            for row in re.findall(r"\{([^{}]*)\}", body[body.index("= {"):body.index("};")])]
    mask, shift = re.search(r"pid = \(\(pid & (0x[0-9A-Fa-f]+)\) >> (\d+)\);", body).groups()
    return int(mask, 16), int(shift), rows


def shuffle_order(personality):
    """Where block A, B, C and D go, for this personality."""
    mask, shift, rows = block_order()
    return rows[(personality & mask) >> shift]


@tree_cache
def nature_mods():
    """gNatureStatMods (src/pokemon.c), a row a nature: 1 on the stat
    ModifyStatByNature raises by a tenth, -1 on the one it lowers, over the
    stats after HP."""
    return [tuple(int(v) for v in row.split(",") if v.strip())
            for row in re.findall(r"\{([^{}]*)\}", c_table("src/pokemon.c", "gNatureStatMods"))]


def species_numbers():
    return {name[len("SPECIES_"):]: n for name, n in constants("include/constants/species.h", "SPECIES_").items()}


@tree_cache
def personal_records():
    """files/poketool/personal/personal.json, a record for every species."""
    return json.loads(source("files/poketool/personal/personal.json").read_text())["baseStats"]


def personal(species_name):
    """One species' record, as files/poketool/personal/personal.json holds it."""
    index = species_numbers()[species_name]
    return personal_records()[index], index


@tree_cache
def growth_curves():
    """growtbl.csv: every curve's experience at levels 0 to 100."""
    with source("files/poketool/personal/growtbl.csv").open() as f:
        return {row["rate"][len("GROWTH_"):]: [int(row[f"lv{level:03d}"]) for level in range(MAX_LEVEL + 1)]
                for row in csv.DictReader(f)}


def experience_for(growth_rate, level):
    """The total experience a level costs, from growtbl.csv."""
    if growth_rate not in growth_curves():
        raise SystemExit(f"no growth curve called {growth_rate}")
    return growth_curves()[growth_rate][level]


def level_for(growth_rate, exp):
    """CalcLevelBySpeciesAndExp: the last level whose experience is reached."""
    curve = growth_curves()[growth_rate]
    return next((level - 1 for level in range(1, MAX_LEVEL + 1) if curve[level] > exp), MAX_LEVEL)


@tree_cache
def move_records():
    """waza_tbl.narc's records, a move each (LoadMoveEntry)."""
    sys.path.insert(0, str(ROOT / "tools/newgold/import"))
    import import_moves
    source(import_moves.TABLE)
    return import_moves.read_table()


@tree_cache
def move_attr(attr):
    """Every move's value of one MoveAttr, as GetMoveTblAttr (src/move.c)
    reads it: the MoveTbl field its case returns, where and how wide the
    compiler makes that field (include/move.h)."""
    field = re.search(rf"case {attr}:\s*return moveTbl->(\w+);", c_function("src/move.c", "u32 GetMoveTblAttr(")).group(1)
    (at, width), _ = compile_c((f"__builtin_offsetof(MoveTbl, {field})", f"sizeof(((MoveTbl *)0)->{field})"),
                               headers=LAYOUT_HEADERS + ("move.h",))
    return [int.from_bytes(record[at:at + width], "little") for record in move_records()]


@tree_cache
def unimplemented_moves():
    """The moves IsMoveUnimplemented (src/move.c) says yes to: the bit it
    tests set in the MoveAttr it reads."""
    attr, flag = re.search(r"GetMoveAttr\(moveId, (MOVEATTR_\w+)\) & (\w+)",
                           c_function("src/move.c", "BOOL IsMoveUnimplemented(")).groups()
    (bit,), _ = compile_c((flag,), headers=LAYOUT_HEADERS + ("move.h",))
    return frozenset(move for move, value in enumerate(move_attr(attr)) if value & bit)


@tree_cache
def learnsets():
    """Every species' level-up moves, as (level, move), as
    LoadLevelUpLearnset_HandleAlternateForm gives them to every reader --
    a new Pokemon's moves, a level-up, the Move Relearner, an egg's
    inheritance: without the moves IsMoveUnimplemented says yes to.

    An entry is what the loader's array holds (its element type), the move
    and the level taken out of it with include/pokemon.h's
    LEVEL_UP_LEARNSET_ masks and shifts, up to LEVEL_UP_LEARNSET_END. The
    archive itself is wotbl.py's to read.
    """
    sys.path.insert(0, str(ROOT / "tools/newgold/import"))
    import wotbl
    element = re.search(r"LoadLevelUpLearnset_HandleAlternateForm\(int species, int form, (\w+) \*levelUpLearnset\)",
                        source("include/pokemon.h").read_text()).group(1)
    (width, move_mask, move_shift, level_mask, level_shift, end), _ = compile_c(
        (f"sizeof({element})", "LEVEL_UP_LEARNSET_MOVEID_MASK", "LEVEL_UP_LEARNSET_MOVEID_SHIFT",
         "LEVEL_UP_LEARNSET_LEVEL_MASK", "LEVEL_UP_LEARNSET_LEVEL_SHIFT", "LEVEL_UP_LEARNSET_END"),
        headers=LAYOUT_HEADERS + ("pokemon.h",))
    files, _, _ = wotbl.read_narc(source(wotbl.ARCHIVE).read_bytes())
    unimplemented = unimplemented_moves()
    out = []
    for member in files:
        entries = [int.from_bytes(member[at:at + width], "little") for at in range(0, len(member) - width + 1, width)]
        entries = itertools.takewhile(lambda entry: entry != end, entries)
        out.append([((entry & level_mask) >> level_shift, (entry & move_mask) >> move_shift) for entry in entries
                    if (entry & move_mask) >> move_shift not in unimplemented])
    return out


def preset_moves(species, level, form=0):
    """The moves the game gives a Pokemon of this species at this level, a
    wild one or one made new (InitBoxMonMoveset): the learnset of its form's
    row up to the level, each move appended unless already known
    (MOVE_APPEND_KNOWN), the first dropped when four are known -- so a move
    learned twice is known once. A species written over a Pokemon brings
    these with it."""
    moves = []
    for learned, move in learnsets()[personal_row(species, form)]:
        if learned > level:
            break
        if move not in moves:
            moves = (moves + [move])[-MAX_MON_MOVES:]
    return moves


def ability_numbers():
    return {name[len("ABILITY_"):]: n for name, n in constants("include/constants/abilities.h", "ABILITY_").items()}


def ability_of(record, personality):
    """CreateBoxMon: the second ability on an odd personality, if there is one."""
    numbers = ability_numbers()
    first, second = (numbers[name[len("ABILITY_"):]] for name in record["abilities"])
    return second if second and (personality & 1) else first


def gender_of(record, personality):
    """GetGenderBySpeciesAndPersonality: MON_MALE, MON_FEMALE or MON_GENDERLESS."""
    ratio = GENDER_RATIO(record["genderRatio"])
    fixed = {MON_RATIO_MALE: MON_MALE, MON_RATIO_FEMALE: MON_FEMALE, MON_RATIO_UNKNOWN: MON_GENDERLESS}
    if ratio in fixed:
        return fixed[ratio]
    return MON_FEMALE if ratio > (personality & 0xFF) else MON_MALE


def move_numbers():
    return {name[len("MOVE_"):]: n for name, n in constants("include/constants/moves.h", "MOVE_").items()}


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
        moves = preset_moves(index, level)
    gender = gender_of(record, personality)

    a = bytearray(BLOCK)
    struct.pack_into("<HHI", a, 0, index, item, ot_id)
    struct.pack_into("<I", a, 8, (exp & 0x1FFFFF) | ((ability >> 8) << 31))
    a[0x0C] = record["friendship"]
    a[0x0D] = ability & 0xFF
    a[0x0F] = GAME_LANGUAGE
    for i in range(NUM_STATS):
        a[0x10 + i] = evs[i] if isinstance(evs, (list, tuple)) else evs

    b = bytearray(BLOCK)
    for i, move in enumerate(moves):
        struct.pack_into("<H", b, 2 * i, move)
        b[8 + i] = 40                       # plenty of PP for a test battle
    iv = ivs if isinstance(ivs, (list, tuple)) else [ivs] * NUM_STATS
    packed = 0
    for i in range(NUM_STATS):
        packed |= (iv[i] & MAX_IV) << (5 * i)
    struct.pack_into("<I", b, 0x10, packed)
    b[0x18] = (gender & 3) << 1

    c = bytearray(BLOCK)
    for i, code in enumerate(encode_text(bank(SPECIES_NAMES)[index], POKEMON_NAME_LENGTH)):
        struct.pack_into("<H", c, 2 * i, code)      # the name the game prints
    c[0x17] = GAME_VERSION

    d = bytearray(BLOCK)
    # The original trainer is who the game compares with the player to decide
    # a Pokemon was traded -- the name, the id and the gender -- and a traded
    # Pokemon past the badges' level does not obey. Given the player's own,
    # the party is the player's.
    for i, code in enumerate(ot_codes if ot_codes is not None else charcode(ot_name)):
        struct.pack_into("<H", d, 2 * i, code)
    d[0x1B] = ITEM_POKE_BALL
    d[0x1C] = (level & 0x7F) | ((ot_gender & 1) << 7)
    d[0x1E] = ITEM_POKE_BALL

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
    ev = evs if isinstance(evs, (list, tuple)) else [evs] * NUM_STATS
    base = [record["hp"], record["atk"], record["def"],
            record["speed"], record["spatk"], record["spdef"]]
    hp = (base[0] * 2 + iv[0] + ev[0] // 4) * level // 100 + level + 10
    out = [hp]
    for i in range(1, NUM_STATS):
        value = (base[i] * 2 + iv[i] + ev[i] // 4) * level // 100 + 5
        mod = nature_mods()[nature][i - 1]
        if mod > 0:
            value = value * 110 // 100
        elif mod < 0:
            value = value * 90 // 100
        out.append(value)
    # The record's order is hp, atk, def, speed, spatk, spdef; the party keeps
    # hp, atk, def, speed, spatk, spdef too, so nothing is reordered here.
    return out


@tree_cache
def pockets():
    """The bag's pockets, in the order the game shows them (sPockets,
    src/start_menu.c): each one's field in struct Bag, the POCKET_ constant
    items are filed in it by (Bag_GetItemPocket's switch, src/bag.c), and
    where its slots start in the block and how many there are."""
    text = source("include/bag_types_def.h").read_text()
    text = text[text.index("typedef struct Bag {"):]
    fields = re.findall(r"ItemSlot (\w+)\[\w+\];", text[:text.index("} Bag;")])
    switch = c_function("src/bag.c", "static u32 Bag_GetItemPocket(")
    const_of = {field: const for const, field in re.findall(r"case (POCKET_\w+):\s*\*itemSlots = bag->(\w+);", switch)}
    values, _ = compile_c(tuple(e for f in fields for e in (f"__builtin_offsetof(Bag, {f})",
                                                             f"sizeof(((Bag *)0)->{f}) / sizeof(ItemSlot)")))
    rows = {const_of[f]: {"name": f, "const": const_of[f], "at": values[2 * i], "slots": values[2 * i + 1]}
            for i, f in enumerate(fields)}
    order = [c for c in re.findall(r"POCKET_\w+", c_table("src/start_menu.c", "sPockets")) if c in rows]
    return [rows[c] for c in order] + [row for c, row in rows.items() if c not in order]


def pocket_at(name):
    """Where a pocket's slots start in the bag, and how many there are."""
    found = next((p for p in pockets() if p["name"] == name), None)
    if found is None:
        raise SystemExit(f"no pocket called {name}")
    return found["at"], found["slots"]


def pocket_const(name):
    """The POCKET_ constant of a pocket, by its field in struct Bag."""
    return next(p["const"] for p in pockets() if p["name"] == name)


@tree_cache
def item_kind(test):
    """The items one of src/item.c's tests -- ItemIsTM, ItemIsHM, ItemIsTR --
    says yes to: the ranges and the single items it names."""
    body = c_function("src/item.c", f"BOOL {test}(")
    items = constants("include/constants/items.h", "ITEM_")
    out = {items[name] for name in re.findall(r"itemId == (ITEM_\w+)", body)}
    for low, high in re.findall(r"itemId >= (ITEM_\w+) && itemId <= (ITEM_\w+)", body):
        out.update(range(items[low], items[high] + 1))
    return frozenset(out)


def item_limit(item):
    """How many of an item the bag takes (Bag_GetItemSlotForAdd): of a TM
    one, as New Gold never uses one up; of another machine
    BAG_TMHM_QUANTITY_MAX; of anything else BAG_SLOT_QUANTITY_MAX."""
    if pocket_const(item_table()[item]["pocket"]) == "POCKET_TMHMS":
        return 1 if item in item_kind("ItemIsTM") else BAG_TMHM_QUANTITY_MAX
    return BAG_SLOT_QUANTITY_MAX


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


def set_dex_flag(block, at, species):
    """SetDexFlag: the species number, counted from one."""
    flag = species - 1
    block[at + (flag >> 3)] |= 1 << (flag & 7)


def blocks(build=None, legacy=False):
    """Every block's id, size and slot, then where each one starts.

    This is SaveData_InitSubstructs: sizes come rounded up to a word with four
    bytes of checksum added, a slot's last block is followed by the chunk
    footer, and the next slot starts on a 0x100 boundary. With `legacy`, the
    layout of a save made before the misc block grew for the DNA Splicers
    (Save_GetLegacySlotSpecs): the same blocks with SAVE_MISC at
    SAVE_MISC_LEGACY_SIZE, laid out the same way.
    """
    inside, _ = measure(build)
    names = block_ids()
    out, offset = [], 0
    for index, (fn, size, slot) in enumerate(inside):
        if legacy and names[index] == "SAVE_MISC":
            size = constants("include/save_misc_data.h", "SAVE_MISC_LEGACY_")["SAVE_MISC_LEGACY_SIZE"]
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
        # A save made before the misc block grew is read, and written, in its
        # own layout: the game converts it when it loads it
        # (Save_LoadLegacySlots), so it is left for the game to do.
        self.legacy = False
        if not any(self.valid(h) for h in (0, HALF)):
            table = blocks(build, legacy=True)
            if table != self.table:
                self.table, self.specs, self.legacy = table, slot_specs(table), True
                if not any(self.valid(h) for h in (0, HALF)):
                    self.table, self.specs, self.legacy = blocks(build), slot_specs(blocks(build)), False
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
                struct.pack_into("<H", region, at + CHUNK_CRC_AT, crc16(region[spec["offset"]:at]))
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
    upper, digit, eos = value("CHAR_A"), value("CHAR_0"), EOS
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
    at = pointer - where.MAIN_RAM + DYNAMIC_REGION
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
    codes = codes[:codes.index(EOS) + 1] if EOS in codes else codes
    return {"codes": codes, "id": struct.unpack_from("<I", profile, TRAINER_ID)[0],
            "gender": profile[GENDER]}


def pickable(name):
    """A species constant (without SPECIES_) a Pokemon may be made as:
    species_table's "pick", as the page holds it -- not the egg, a retail
    form row, a battle's form."""
    number = species_numbers().get(name)
    if number is None:
        raise SystemExit(f"there is no SPECIES_{name}")
    if not next((row["pick"] for row in species_table() if row["id"] == number), False):
        raise SystemExit(f"SPECIES_{name} is not a species a Pokemon can be made as (the egg, a form row, a battle's form)")
    return name


def parse_party(text):
    """SPECIES:LEVEL[:NATURE][:MOVE+MOVE+...],...; moves not given are the
    game's at that level (preset_moves), moves given must be ones it can
    learn, each once."""
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
            if len(moves) > MAX_MON_MOVES or len(set(moves)) != len(moves):
                raise SystemExit(f"a Pokemon knows at most {MAX_MON_MOVES} moves, each once")
            if parts[0].upper() in species_numbers():
                try:
                    check_moves(species_numbers()[parts[0].upper()], moves)
                except Illegal as e:
                    raise SystemExit(str(e))
        wanted.append((pickable(parts[0].upper()), int(parts[1]),
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
        block[PARTY_AT + slot * PARTY_MON:PARTY_AT + (slot + 1) * PARTY_MON] = mon


def add_machines(save, machines):
    block = save.block("SAVE_BAG")
    first = int(re.search(r"#define ITEM_TM01\s+(\d+)",
                          (ROOT / "include/constants/items.h").read_text()).group(1))
    for n in machines:
        put_in_pocket(block, next(p["name"] for p in pockets() if p["const"] == "POCKET_TMHMS"), first + n - 1, 1)


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
    if not 1 <= number <= NUM_BOXES:
        raise SystemExit(f"boxes are numbered 1 to {NUM_BOXES}")
    block = save.block("SAVE_PCSTORAGE")
    at = (number - 1) * BOX
    block[at:at + BOX_MON] = build_mon(pickable(name.upper()), int(level))[:BOX_MON]


def set_trainer_id(save, value):
    struct.pack_into("<I", save.block("SAVE_PLAYERDATA"), TRAINER_ID, value)


@tree_cache
def badges():
    """The badges by number (include/constants/badge.h), each with the
    profile byte and bit PlayerProfile_SetBadgeFlag keeps it in: the first
    eight in johtoBadges, the rest in kantoBadges."""
    return [{"const": const, "number": number, "field": "johto" if number < 8 else "kanto", "bit": number % 8}
            for const, number in sorted(constants("include/constants/badge.h", "BADGE_").items(), key=lambda kv: kv[1])]


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
    struct.pack_into("<H", save.block("SAVE_FLAGS"), 2 * (number - VAR_BASE), value)
    return number


def set_flag(save, name):
    """A script flag by its name in include/constants/flags.h: the cap for
    Falkner is 13 only once FLAG_UNK_076 says Sprout Tower is done."""
    flags = save.block("SAVE_FLAGS")
    number = constants("include/constants/flags.h", "FLAG_").get(name)
    if number is None:
        raise SystemExit(f"there is no {name} in include/constants/flags.h")
    flags[FLAGS_AT + number // 8] |= 1 << (number % 8)
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
    flags[FLAGS_AT + FLAG_CONTINUE_BY_WARP // 8] |= 1 << (FLAG_CONTINUE_BY_WARP % 8)


# ---------------------------------------------------------------------------
# The game's own names for things: its message banks and its character set.

# The banks the game prints these names from: each the one a function of
# src/message_format.c opens (the map sections' is the one the field's
# map name reads too).
SPECIES_NAMES, MOVE_NAMES, ITEM_NAMES, ABILITY_NAMES, NATURE_NAMES, MAPSEC_NAMES = (
    "BufferSpeciesName", "BufferMoveName", "BufferItemName", "BufferAbilityName", "BufferNatureName",
    "BufferLandmarkName")


@tree_cache
def bank(which):
    """A message bank's rows, by index, as the game prints them: the bank
    `which`, a function of src/message_format.c, opens."""
    body = c_function("src/message_format.c", f"void {which}(")
    number = int(re.search(r"NARC_msg_msg_(\d+)_bin", body).group(1))
    sys.path.insert(0, str(ROOT / "tools/newgold/import"))
    import gmm
    source(gmm.path_of(number))
    return [html.unescape(row["text"]) for row in gmm.read(number)]


@tree_cache
def charmap():
    """charmap.txt both ways. A character the table gives twice is written
    with its Western code, the one the English game's own text uses."""
    decode, encode = {}, {}
    for line in source("charmap.txt").read_text(encoding="utf-8").splitlines():
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
        if code == EOS:
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
    return [encode[c] for c in text] + [EOS]


def species_name(species):
    names = bank(SPECIES_NAMES)
    return names[species] if 0 <= species < len(names) else f"#{species}"


@tree_cache
def battle_forms():
    """The species a battle turns into and back (Megas, Gigantamax and the
    like): src/data/form_reversion.h, hg-engine's FormReversionMapping."""
    numbers = species_numbers()
    text = source("src/data/form_reversion.h").read_text()
    return {numbers[name] for name in re.findall(r"\[SPECIES_(\w+) - NATIONAL_DEX_COUNT - 1\] = SPECIES_", text)}


@tree_cache
def species_table():
    """Every species with the name the game prints. A form, or any species
    whose name a lower number already prints (the Galarian Slowpoke), carries
    its constant as well to tell it apart.

    "pick" is whether a Pokemon may be made as that species. Not the egg, the
    bad egg and the retail forms between them (FIRST_DEX_GAP to LAST_DEX_GAP):
    those numbers are rows of the form table ResolveMonForm reads, and the
    game keeps a Rotom Wash as SPECIES_ROTOM with form 2 -- stored as 504 it
    is a nameless '-----' with a '?' icon. Nor a form only a battle has."""
    numbers = species_numbers()
    by_id = {}
    for name, number in numbers.items():
        by_id.setdefault(number, name)
    gap = range(FIRST_DEX_GAP, LAST_DEX_GAP + 1)
    out, named = [], set()
    for number in range(1, min(len(bank(SPECIES_NAMES)), len(personal_records()))):
        const, name = by_id.get(number, ""), species_name(number)
        form = number in gap or number > NATIONAL_DEX_COUNT
        out.append({"id": number, "name": name, "const": const,
                    "label": f"{name} ({const.replace('_', ' ').title()})" if form or name in named else name,
                    "dex": not form, "egg": number in (numbers["EGG"], numbers["BAD_EGG"]),
                    "pick": number not in gap and number not in battle_forms()})
        named.add(name)
    return out


@tree_cache
def item_table():
    """Every item: its name, its constant, and the pocket it goes in
    (fieldPocket, which the csv gives by the item's name)."""
    names = bank(ITEM_NAMES)
    with source("files/itemtool/itemdata/item_data.csv").open() as f:
        pocket_of = {p["const"]: p["name"] for p in pockets()}
        filed = {row["item"]: pocket_of.get(row["fieldPocket"]) for row in csv.DictReader(f)}
    by_id = {}
    for const, number in constants("include/constants/items.h", "ITEM_").items():
        by_id.setdefault(number, const)
    return {number: {"id": number, "const": const, "pocket": filed.get(const),
                     "name": names[number] if number < len(names) else const}
            for number, const in sorted(by_id.items())}


@tree_cache
def move_table():
    """Every move's name and base PP, the PP out of waza_tbl.narc where
    GetMoveMaxPP's MOVEATTR_PP reads it."""
    pp = move_attr("MOVEATTR_PP")
    return [{"id": n, "name": name, "pp": pp[n] if n < len(pp) else 0} for n, name in enumerate(bank(MOVE_NAMES))]


@tree_cache
def map_table():
    """Every map by id, with the section name the game shows for it."""
    names = bank(MAPSEC_NAMES)
    sections = constants("include/constants/map_sections.h", "MAPSEC_")
    headers = source("src/data/map_headers.h").read_text()
    section_of = dict(re.findall(r"\[(MAP_\w+)\] = \{[^}]*?\.mapsec = (MAPSEC_\w+)", headers))
    out = {}
    for const, number in constants("include/constants/maps.h", "MAP_").items():
        section = sections.get(section_of.get(const))
        out.setdefault(number, {"id": number, "const": const,
                                "name": names[section] if section is not None and section < len(names) else ""})
    return dict(sorted(out.items()))


MATRICES = ROOT / "files/fielddata/mapmatrix/map_matrix"


@tree_cache
def _matrix_of():
    """Each map's matrix, as its header in src/data/map_headers.h names it."""
    number = constants("include/constants/maps.h", "MAP_")
    headers = source("src/data/map_headers.h").read_text()
    return {number[const]: int(m) for const, m in re.findall(
        r"\[(MAP_\w+)\] = \{[^}]*?\.matrixId = NARC_map_matrix_map_matrix_(\d{4})", headers) if const in number}


@tree_cache
def map_chunks(map_id):
    """The chunks of its matrix that are this map's, as (column, row).

    MapMatrix_MapMatrixData_Load: width, height, whether there is a layer
    naming each chunk's map (without one every chunk is the map's own), one
    of altitudes, then each chunk's land data, 0xFFFF where there is none --
    the black void. The matrix is the one the map's header names."""
    matrix = _matrix_of().get(map_id)
    if matrix is None:
        return frozenset()
    data = source(next(p for p in source(MATRICES).iterdir()
                       if re.fullmatch(rf"map_matrix_{matrix:04d}(_\w+)?\.bin", p.name))).read_bytes()
    width, height, has_maps, has_altitudes, name_length = data[:5]
    at = 5 + name_length
    cells = width * height
    owners = struct.unpack_from(f"<{cells}H", data, at) if has_maps else [map_id] * cells
    at += 2 * cells if has_maps else 0
    at += cells if has_altitudes else 0
    land = struct.unpack_from(f"<{cells}H", data, at)
    return frozenset((i % width, i // width) for i in range(cells) if land[i] != 0xFFFF and owners[i] == map_id)


def on_map(map_id, x, y):
    """Whether the tile is on a chunk of this map, not off its matrix or in
    the void between chunks, where Continue leaves the player on black."""
    return (x // CHUNK_TILES, y // CHUNK_TILES) in map_chunks(map_id)


# ---------------------------------------------------------------------------
# One Pokemon, opened and closed the way AcquireBoxMonLock and
# ReleaseBoxMonLock do it.

EXP_BITS = 0x1FFFFF         # PokemonDataBlockA.exp : 21


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


def personality_for_nature(personality, nature, ot_id, shiny=None):
    """A personality whose nature (the value modulo 25) is `nature`, keeping
    what else the old one decided: the low byte (the gender and the ability
    slot) and whether the Pokemon is shiny (or becoming `shiny`, for a low
    byte changed first). Unown's letter, which is spread over the whole
    value, is not kept."""
    shiny = is_shiny(personality, ot_id) if shiny is None else shiny
    if personality % 25 == nature and is_shiny(personality, ot_id) == shiny:
        return personality
    low = personality & 0xFFFF
    if not shiny:
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


def personality_for_bit(personality, bit, ot_id, record):
    """A personality whose low bit -- the ability slot -- is `bit`, keeping
    the nature, the gender and whether it is shiny: the nearest low byte
    that gives this record the same gender, then personality_for_nature's
    high half."""
    gender = gender_of(record, personality)
    low = min((c for c in range(256) if c & 1 == bit and gender_of(record, c) == gender),
              key=lambda c: abs(c - (personality & 0xFF)))
    return personality_for_nature((personality & 0xFFFFFF00) | low, personality % 25, ot_id,
                                  shiny=is_shiny(personality, ot_id))


@tree_cache
def form_rows():
    """ResolveMonForm's cases (src/pokemon.c): for each species whose forms
    have base stats of their own, its base form, how many forms it has, and
    the personal record of its first other form and which form that is."""
    cases = re.findall(r"case SPECIES_(\w+):\s*if \(form != (\w+) && form <= (\w+) - 1\) \{\s*"
                       r"return SPECIES_(\w+) \+ form - (\w+);", c_function("src/pokemon.c", "int ResolveMonForm("))
    if not cases:
        raise SystemExit("ResolveMonForm in src/pokemon.c no longer reads the way savedit expects")
    values, _ = compile_c(tuple(name for case in cases for name in (case[1], case[2], case[4])))
    numbers = species_numbers()
    return {numbers[case[0]]: (values[3 * i], values[3 * i + 1], numbers[case[3]], values[3 * i + 2])
            for i, case in enumerate(cases)}


def personal_row(species, form):
    """ResolveMonForm: the personal record CalcMonStats reads for a species
    in this form."""
    if species in form_rows():
        base, count, row, first = form_rows()[species]
        if form != base and form <= count - 1:
            return row + form - first
    return species


# ---------------------------------------------------------------------------
# What a species can know and be, read from what the build compiles: the
# level-up learnsets, the machines, the tutors, the egg moves, the
# evolutions and the abilities.

@tree_cache
def machines():
    """Each machine by its place in hg-engine's numbering -- the bit a
    species' record sets -- as (move, item): sTMHMMoves in src/item.c, and
    the place ItemToTMHMId gives each machine item."""
    text = source("src/item.c").read_text()
    table = text[text.index("sTMHMMoves[] = {"):]
    moves = move_numbers()
    taught = [moves[name] for name in re.findall(r"\bMOVE_(\w+),", table[:table.index("};")])]
    body = text[text.index("u16 ItemToTMHMId("):]
    body = body[:body.index("\n}\n")]
    items = constants("include/constants/items.h", "ITEM_")
    item_at = {int(place): items[item] for item, place in
               re.findall(r"itemId == (ITEM_\w+)\) \{\s*return (\d+);", body)}
    for low, high, base, add in re.findall(r"itemId >= (ITEM_\w+) && itemId <= (ITEM_\w+)\) \{\s*"
                                           r"return itemId - (ITEM_\w+)(?: \+ (\d+))?;", body):
        for item in range(items[low], items[high] + 1):
            item_at[item - items[base] + int(add or 0)] = item
    return [(move, item_at.get(place)) for place, move in enumerate(taught)]


def machine_places(record):
    """The places GetTMHMCompatBySpeciesAndForm finds set in a record: the
    template packs TM n at n - 1, HM n after the NUM_TMS TMs, and each of
    "machines" at its own place."""
    tms = constants("include/constants/items.h", "NUM_")["NUM_TMS"]
    return [n - 1 for n in record["tms"]] + [tms + n - 1 for n in record["hms"]] + record.get("machines", [])


@tree_cache
def tutor_records():
    """waza_oshie.json's records in the order the build writes them, each
    the moves of sTutorMoves (src/field/scrcmd_move_tutor.c) its TUTOR_
    bits name."""
    text = source("src/field/scrcmd_move_tutor.c").read_text()
    table = text[text.index("sTutorMoves[] = {"):]
    moves = move_numbers()
    taught = [moves[name] for name in re.findall(r"\{\s*MOVE_(\w+),", table[:table.index("};")])]
    slots = constants("include/constants/moves.h", "TUTOR_")
    return [[taught[slots[name]] for name in entry["moves"]]
            for entry in json.loads(source("files/fielddata/wazaoshie/waza_oshie.json").read_text())["tutor"]]


def tutor_moves(row):
    """GetMoveTutorLearnsetIndex: a species' record (a retail form's row
    for its form), counted without species 0 and, past Arceus, without the
    egg and the bad egg."""
    index = (row - 2 if row > species_numbers()["ARCEUS"] else row) - 1
    records = tutor_records()
    return records[index] if 0 <= index < len(records) else []


@tree_cache
def egg_moves():
    """LoadEggMoves: kowaza_list.narc's one member, MAX_EGG_MOVES halfwords
    a species, each list ended by 0xFFFF."""
    sys.path.insert(0, str(ROOT / "tools/newgold/import"))
    import wotbl
    width = constants("include/constants/daycare.h", "MAX_")["MAX_EGG_MOVES"]
    member = wotbl.read_narc(source("files/fielddata/sodateya/kowaza_list.narc").read_bytes())[0][0]
    records = struct.iter_unpack(f"<{width}H", member[:len(member) - len(member) % (2 * width)])
    return [list(itertools.takewhile(lambda move: move != 0xFFFF, record)) for record in records]


@tree_cache
def pre_evolutions():
    """evo.json, which the build packs into evo.narc for GetMonEvolution,
    turned around: the species each one evolves from. EvolvedPassiveForm's
    cases (src/pokemon.c) are evolutions too: a form 1 Dunsparce or
    Tandemaus becomes the form species it names, from the same species the
    target it replaces comes from."""
    numbers = species_numbers()
    out = {}
    for entry in json.loads(source("files/poketool/personal/evo.json").read_text())["evoTable"]:
        for evo in entry["evos"]:
            if evo["target"] != "SPECIES_NONE":
                out.setdefault(numbers[evo["target"][len("SPECIES_"):]], set()).add(
                    numbers[entry["baseSpecies"][len("SPECIES_"):]])
    passive = c_function("src/pokemon.c", "static u16 EvolvedPassiveForm(")
    for target, form in re.findall(r"case SPECIES_(\w+):\s*return SPECIES_(\w+);", passive):
        out.setdefault(numbers[form], set()).update(out.get(numbers[target], set()))
    return out


@tree_cache
def incense_parents():
    """sIncenseMons (src/get_egg.c): the species an egg hatches as instead
    of the baby when neither parent holds the incense."""
    text = source("src/get_egg.c").read_text()
    text = text[text.index("sIncenseMons[]"):]
    numbers = species_numbers()
    return {numbers[parent] for parent in
            re.findall(r"\{\s*SPECIES_\w+,\s*ITEM_\w+,\s*SPECIES_(\w+)\s*\}", text[:text.index("};")])}


# The Blackthorn move tutor's script: Draco Meteor, for a Pokemon of a type.
TYPE_TUTOR = "files/fielddata/script/scr_seq/scr_seq_0948_T30R0601.s"


@tree_cache
def type_tutors():
    """What the Blackthorn tutor's script teaches for a type: the move its
    MoveTutorInit names, to a Pokemon whose GetMonTypes gives a type its
    tests compare with (include/constants/pokemon.h's TYPE_ by number).
    [(move, type name without TYPE_)]."""
    text = source(TYPE_TUTOR).read_text()
    names = {}
    for name, number in constants("include/constants/pokemon.h", "TYPE_").items():
        names.setdefault(number, name[len("TYPE_"):])      # the types come first, TYPE_MUL_ after
    types = {names[int(n)] for _, n in re.findall(r"GetMonTypes (VAR_\w+), (?:VAR_\w+), \w+\s+Compare \1, (\d+)", text)}
    moves = [move_numbers()[name] for name in re.findall(r"MoveTutorInit VAR_\w+, MOVE_(\w+)", text)]
    return [(move, kind) for move in moves for kind in sorted(types)]


def possible_types(species, form=0):
    """Every type GetMonData can give a Pokemon of this species (mon_types):
    its form's record's, and for Arceus with Multitype and Silvally with RKS
    System every type a held plate or memory makes it."""
    out = set(mon_types(species, 0, 0, form))
    numbers, abilities = species_numbers(), constants("include/constants/abilities.h", "ABILITY_")
    has = {entry["id"] for entry in species_abilities(species, form)}
    arceus, silvally, _ = item_types()
    for table, name, ability in ((arceus, "ARCEUS", "ABILITY_MULTITYPE"), (silvally, "SILVALLY", "ABILITY_RKS_SYSTEM")):
        if species == numbers.get(name) and abilities[ability] in has:
            out |= {kind[len("TYPE_"):] for kind in table.values()}
    return out


@tree_cache
def form_moves():
    """sRotomFormMoves (src/pokemon.c): the move each form of the species
    Mon_UpdateRotomForm changes has of its own, which the Rotom Catalog
    teaches with the form. {species: [move, by form]}."""
    moves = move_numbers()
    table = [moves[name] for name in re.findall(r"MOVE_(\w+)", c_table("src/pokemon.c", "sRotomFormMoves"))]
    species = re.search(r"MON_DATA_SPECIES, NULL\) != SPECIES_(\w+)\)",
                        c_function("src/pokemon.c", "BOOL Mon_UpdateRotomForm(")).group(1)
    return {species_numbers()[species]: table}


@tree_cache
def item_egg_moves():
    """Daycare_LightBallCheck (src/get_egg.c): the move an egg of the
    species GiveEggToPlayer checks is given when a parent holds the item.
    {species: [(move, item)]}."""
    check = c_function("src/get_egg.c", "static void Daycare_LightBallCheck(")
    item = constants("include/constants/items.h", "ITEM_")[re.search(r"== (ITEM_\w+)", check).group(1)]
    move = move_numbers()[re.search(r"TryAppendMonMove\(egg, MOVE_(\w+)\)", check).group(1)]
    species = re.search(r"if \(species == SPECIES_(\w+)\) \{\s*Daycare_LightBallCheck\(",
                        source("src/get_egg.c").read_text()).group(1)
    return {species_numbers()[species]: [(move, item)]}


@tree_cache
def egg_species():
    """The species an egg can hatch as: each one pms.narc gives a mother
    (ReadFromPersonalPmsNarc, a halfword a species), the ones
    Daycare_GetEggSpecies turns those into, and the parents an incense baby
    hatches as without its incense."""
    raw = source("files/poketool/personal/pms.narc").read_bytes()
    numbers = species_numbers()
    turned = re.findall(r"eggSpecies = SPECIES_(\w+);", c_function("src/get_egg.c", "static u16 Daycare_GetEggSpecies("))
    return (set(struct.unpack(f"<{len(raw) // 2}H", raw)) - {0}) | {numbers[name] for name in turned} | incense_parents()


def evolution_line(species):
    """The species and every species it can have been before evolving,
    nearest first, each with whether an egg can hatch as it (egg_species)."""
    before = lambda s: pre_evolutions().get(s, set())
    line, todo = [], [species]
    while todo:
        s = todo.pop(0)
        if s not in [t for t, _ in line]:
            line.append((s, s in egg_species()))
            todo += sorted(before(s))
    return line


def learnable_moves(species, form=0):
    """Every move this species can know, whatever its level, with every way
    it is learnt, never only the first: {move: [source, ...]}. A source is
    {"how": "level", "level": n} (0: on evolving), {"how": "machine",
    "item": the TM, HM or TR}, {"how": "tutor"} ("type": the type the
    Blackthorn tutor teaches it for, type_tutors), {"how": "egg"} ("item":
    the one a parent holds, item_egg_moves; "daycare": learnt at the
    Day-Care, by a species no egg hatches as) or
    {"how": "form"} (the move a Rotom form has of its own), with
    "from": the species when it is a pre-evolution's -- a move learnt
    before evolving is kept. Its own form's row (ResolveMonForm) for its
    learnset, machines and tutors; egg moves are each species' own record.
    A pre-evolution's machine or tutor that the
    species has itself is the same way, and is not repeated."""
    out = {}
    for s, hatches in evolution_line(species):
        row = personal_row(s, form) if s == species else s
        found = [(move, {"how": "level", "level": level}) for level, move in learnsets()[row]]
        found += [(machines()[place][0], {"how": "machine", "item": machines()[place][1]})
                  for place in machine_places(personal_records()[row]) if place < len(machines())]
        found += [(move, {"how": "tutor"}) for move in tutor_moves(row)]
        kinds = possible_types(s, form if s == species else 0)
        found += [(move, {"how": "tutor", "type": kind}) for move, kind in type_tutors() if kind in kinds]
        own = form_moves().get(s, []) if s == species else []
        found += [(own[form], {"how": "form"})] if form < len(own) else []
        # Its own egg moves: an egg's, or at the Day-Care, where
        # Daycare_LearnEggMovesFrom teaches a Pokemon of any stage those of
        # its species' that the other one knows (a Mirror Herb, or the same
        # species).
        own = {"how": "egg"} if hatches else {"how": "egg", "daycare": True}
        found += [(move, own) for move in (egg_moves()[s] if s < len(egg_moves()) else [])]
        found += [(move, {"how": "egg", "item": item}) for move, item in (item_egg_moves().get(s, []) if hatches else [])]
        for move, how in found:
            if s != species and how["how"] in ("machine", "tutor") and how in out.get(move, []):
                continue
            how = how if s == species else {**how, "from": s}
            if move and how not in out.setdefault(move, []):
                out[move].append(how)
    return out


class Illegal(ValueError):
    """What a species cannot have: moves it never learns, or an ability
    slot it has no ability in."""

    def __init__(self, species, moves=(), ability=None):
        self.species, self.moves, self.ability = species, list(moves), ability
        what = [move_table()[m]["name"] for m in self.moves] or [f"an ability in slot {ability}"]
        super().__init__(f"{species_name(species)} cannot have {', '.join(what)}")


def check_moves(species, moves, form=0, kept=()):
    """Illegal for a move the species cannot learn -- one of `kept`, an
    event move the Pokemon already knows, excepted."""
    legal = learnable_moves(species, form)
    wrong = [move for move in moves if move and move not in legal and move not in kept]
    if wrong:
        raise Illegal(species, moves=wrong)


HIDDEN_SLOT = 2     # the slot MON_HIDDEN_ABILITY_BIT picks; 0 and 1 the personality's


def species_abilities(species, form=0):
    """The abilities a Pokemon of this species can have, each with the slot
    the game keeps it by: 0 and 1 the personality's low bit (turned over by
    an Ability Capsule's bit), HIDDEN_SLOT the hidden-ability bit. A second
    ability that is none, or the first again, is no slot of its own."""
    record = personal_records()[personal_row(species, form)]
    numbers, names = ability_numbers(), bank(ABILITY_NAMES)
    first, second, hidden = (numbers.get(name[len("ABILITY_"):], 0) for name in
                             (*record["abilities"], record.get("hiddenAbility", "ABILITY_NONE")))
    slots = ((0, first), (1, second if second != first else 0), (HIDDEN_SLOT, hidden))
    return [{"slot": slot, "id": ability, "name": names[ability] if ability < len(names) else str(ability)}
            for slot, ability in slots if ability]


def ability_slot(species, form, hidden_bit, low_bit):
    """UpdateBoxMonAbility's choice: the hidden ability when its bit is set
    and the species has one, else the second when the low bit (turned by a
    Capsule) asks for it and there is one, else the first."""
    have = {entry["slot"] for entry in species_abilities(species, form)}
    if hidden_bit and HIDDEN_SLOT in have:
        return HIDDEN_SLOT
    return 1 if low_bit and 1 in have else 0


def _ability_bits(mon):
    """The hidden-ability bit and the low bit UpdateBoxMonAbility reads."""
    b = mon["blocks"][1]
    swap = struct.unpack_from("<H", b, 0x1A)[0] & SWAP_ABILITY_BIT
    return bool((b[0x19] >> 6) & HIDDEN_ABILITY_BIT), (mon["personality"] ^ swap) & 1


def _set_ability(mon):
    """UpdateBoxMonAbility: the ability field from the bits the Pokemon
    keeps, as the game writes it again on evolving or changing form."""
    a, b = mon["blocks"][:2]
    species, form = struct.unpack_from("<H", a, 0)[0], b[0x18] >> 3
    slot = ability_slot(species, form, *_ability_bits(mon))
    ability = next((entry["id"] for entry in species_abilities(species, form) if entry["slot"] == slot), 0)
    a[0x0D] = ability & 0xFF
    word = struct.unpack_from("<I", a, 8)[0]
    struct.pack_into("<I", a, 8, (word & 0x7FFFFFFF) | ((ability >> 8) & 1) << 31)


def _choose_ability(mon, slot):
    """The bits that make UpdateBoxMonAbility give this slot, so the game
    keeps it, through evolution too: the hidden-ability bit, or for the
    first two a personality whose low bit (turned by a Capsule's) picks it
    -- personality_for_bit, nature, gender and shininess kept. The first
    sets the bit even for a species with no second: the one it evolves
    into may have one."""
    a, b = mon["blocks"][:2]
    species, form = struct.unpack_from("<H", a, 0)[0], b[0x18] >> 3
    have = {entry["slot"] for entry in species_abilities(species, form)}
    if slot not in have:
        raise Illegal(species, ability=slot)
    b[0x19] = (b[0x19] & ~(HIDDEN_ABILITY_BIT << 6) & 0xFF) | (HIDDEN_ABILITY_BIT << 6 if slot == HIDDEN_SLOT else 0)
    swap = struct.unpack_from("<H", b, 0x1A)[0] & SWAP_ABILITY_BIT
    if slot != HIDDEN_SLOT and _ability_bits(mon)[1] != slot:
        mon["personality"] = personality_for_bit(mon["personality"], slot ^ swap, struct.unpack_from("<I", a, 4)[0],
                                                 personal_records()[personal_row(species, form)])
    _set_ability(mon)


def _set_party_stats(mon, level):
    """CalcMonStats at this level, the nature a Mint gave if it gave one, and
    HP moved the way CalcMonStats moves it."""
    a, b, _, _ = mon["blocks"]
    party = mon["party"]
    species = struct.unpack_from("<H", a, 0)[0]
    ivword = struct.unpack_from("<I", b, 0x10)[0]
    ivs = [(ivword >> (5 * i)) & MAX_IV for i in range(NUM_STATS)]
    mint = (struct.unpack_from("<H", b, 0x1A)[0] & MINT_MASK) >> 1
    nature = mint - 1 if mint else mon["personality"] % 25
    stats = stat_line(personal_records()[personal_row(species, b[0x18] >> 3)], level, ivs, list(a[0x10:0x16]), nature)
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
             ivs=None, evs=None, friendship=None, ability=None):
    """One stored Pokemon with these things changed as the game changes them,
    and everything else -- its trainer, its ribbons, its met data -- as it was.

    A new species gets form 0, its gender worked out again, the species'
    name unless it has a nickname, and -- unless they are given -- its own
    moves at that level (preset_moves) and the ability the game gives it
    from the bits the Pokemon keeps (UpdateBoxMonAbility), never the old
    species' left behind. Moves given must be ones the species can learn
    (learnable_moves); only a Pokemon keeping its species keeps a move it
    already knew that the rules do not list, an event's. An ability is its
    slot (species_abilities), written the way the game keeps it
    (_choose_ability). A level is the experience that level costs; a nature
    is a new personality (personality_for_nature) with any Mint taken away;
    a move it already knew keeps its PP and PP Ups, a new one gets full PP.
    A party Pokemon's stats follow. Illegal, a ValueError, says what the
    species cannot have.
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
    knew = [struct.unpack_from("<H", b, 2 * i)[0] for i in range(MAX_MON_MOVES)]
    if level is not None and not 1 <= level <= MAX_LEVEL:
        raise ValueError(f"a level is 1 to {MAX_LEVEL}")
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
        level = current if level is None else level
        if moves is None:
            moves = preset_moves(species, level)
        knew = []
        if ability is None:
            _set_ability(mon)
    if ability is not None:
        _choose_ability(mon, ability)
    if level is not None:
        growth = records[struct.unpack_from("<H", a, 0)[0]]["growthRate"]
        word = struct.unpack_from("<I", a, 8)[0]
        struct.pack_into("<I", a, 8, (word & ~EXP_BITS & 0xFFFFFFFF) | experience_for(growth, level))
    if item is not None:
        struct.pack_into("<H", a, 2, item)
    if moves is not None:
        check_moves(struct.unpack_from("<H", a, 0)[0], moves, b[0x18] >> 3, kept=knew)
        known = [(struct.unpack_from("<H", b, 2 * i)[0], b[8 + i], b[12 + i]) for i in range(MAX_MON_MOVES)]
        wanted = [move for move in moves if move][:MAX_MON_MOVES]
        table = move_table()
        for i in range(MAX_MON_MOVES):
            move = wanted[i] if i < len(wanted) else 0
            kept = next((k for k in known if move and k[0] == move), None)
            pp, ups = (kept[1], kept[2]) if kept else ((table[move]["pp"], 0) if move else (0, 0))
            struct.pack_into("<H", b, 2 * i, move)
            b[8 + i], b[12 + i] = pp, ups
    if ivs is not None:
        word = struct.unpack_from("<I", b, 0x10)[0] & 0xC0000000
        struct.pack_into("<I", b, 0x10, word | sum((iv & MAX_IV) << (5 * i) for i, iv in enumerate(ivs)))
    if evs is not None:
        a[0x10:0x16] = bytes(evs)
    if friendship is not None:
        a[0x0C] = friendship
    if mon["party"] is not None and restat:
        _set_party_stats(mon, current if level is None else level)
    return seal_mon(mon)


def new_mon(species, level, me, nature=None, moves=None, item=0, ivs=31, evs=0, party=True, ability=None):
    """A Pokemon of the player's own, the way build_mon makes one, with a
    personality of its own (not shiny), full PP and the stats CalcMonStats
    gives. Moves given must be
    ones it can learn, an ability one of its slots; without them, its
    moves at that level and the ability its personality picks."""
    const = next((row["const"] for row in species_table() if row["id"] == species and row["pick"]), None)
    if const is None:
        raise ValueError(f"there is no species {species}")
    personality = random.getrandbits(32)
    while is_shiny(personality, me["id"]):
        personality = random.getrandbits(32)
    if nature is not None:
        personality = personality_for_nature(personality, nature, me["id"])
    if moves:
        check_moves(species, moves)
    mon = open_mon(build_mon(const, level, ivs=ivs, evs=evs, item=item, personality=personality,
                             moves=moves or preset_moves(species, level), ot_codes=me["codes"], ot_id=me["id"],
                             ot_gender=me["gender"]))
    if ability is not None:
        _choose_ability(mon, ability)
    b = mon["blocks"][1]
    table = move_table()
    for i in range(MAX_MON_MOVES):
        b[8 + i] = table[struct.unpack_from("<H", b, 2 * i)[0]]["pp"]
    _set_party_stats(mon, level)    # build_mon's stats, but Shedinja's one HP
    raw = seal_mon(mon)
    return raw if party else raw[:BOX_MON]


@tree_cache
def item_types():
    """GetArceusTypeByHeldItemEffect and GetSilvallyTypeByHeldItemEffect as
    src/pokemon.c writes them -- hold effect to type, "default" for the rest
    -- and every item's hold effect from item_data.csv, by item id."""
    text = source("src/pokemon.c").read_text()
    tables = {}
    for fn in ("GetArceusTypeByHeldItemEffect", "GetSilvallyTypeByHeldItemEffect"):
        start = text.index(f"u32 {fn}(")
        table, waiting = {}, []
        for line in text[start:text.index("\n}\n", start)].splitlines():
            case = re.match(r"\s*(?:case (HOLD_EFFECT_\w+)|(default)):", line)
            if case:
                waiting.append(case.group(1) or "default")
            ret = re.search(r"return (TYPE_\w+);", line)
            if ret:
                table.update({key: ret.group(1) for key in waiting})
                waiting = []
        tables[fn] = table
    with source("files/itemtool/itemdata/item_data.csv").open() as f:
        effect = {row["item"]: row["holdEffect"] for row in csv.DictReader(f)}
    held = {number: effect.get(row["const"], "HOLD_EFFECT_NONE") for number, row in item_table().items()}
    return tables["GetArceusTypeByHeldItemEffect"], tables["GetSilvallyTypeByHeldItemEffect"], held


def mon_types(species, ability, item, form=0):
    """GetMonData's MON_DATA_TYPE_1 and _2: Arceus with Multitype is its
    plate's type and Silvally with RKS System its memory's, the rest those
    of its form's record (GetMonBaseStat_HandleAlternateForm: a Wormadam
    in its Sandy Cloak is Ground). Names without TYPE_, one when both are
    the same."""
    numbers, abilities = species_numbers(), constants("include/constants/abilities.h", "ABILITY_")
    arceus, silvally, held = item_types()
    if species == numbers["ARCEUS"] and ability == abilities["ABILITY_MULTITYPE"]:
        types = [arceus.get(held.get(item, "HOLD_EFFECT_NONE"), arceus.get("default", "TYPE_NORMAL"))] * 2
    elif species == numbers.get("SILVALLY") and ability == abilities["ABILITY_RKS_SYSTEM"]:
        types = [silvally.get(held.get(item, "HOLD_EFFECT_NONE"), silvally.get("default", "TYPE_NORMAL"))] * 2
    else:
        types = personal_records()[personal_row(species, form)]["types"]
    out = []
    for name in types:
        name = name[len("TYPE_"):]
        if name not in out:
            out.append(name)
    return out


def describe_mon(raw):
    """Everything the page shows about one Pokemon; None for an empty slot,
    {"ok": False} for one whose checksum fails (the game's Bad Egg).
    "ability_ok" is whether its ability is the one UpdateBoxMonAbility
    would give it (in "ability_slot"): not, when its species was written
    without it (an older editor) or the species' abilities changed since."""
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
    for i in range(MAX_MON_MOVES):
        move = struct.unpack_from("<H", b, 2 * i)[0]
        if move:
            row = move_table()[move] if move < len(move_table()) else {"name": f"#{move}", "pp": 0}
            moves.append({"id": move, "name": row["name"], "pp": b[8 + i], "pp_ups": b[12 + i],
                          "pp_max": row["pp"] + row["pp"] * b[12 + i] // 5})
    items, abilities, natures = item_table(), bank(ABILITY_NAMES), bank(NATURE_NAMES)
    slot = ability_slot(species, b[0x18] >> 3, *_ability_bits(mon))
    given = next((entry["id"] for entry in species_abilities(species, b[0x18] >> 3) if entry["slot"] == slot), 0)
    out = {"ok": True, "personality": p, "species": species, "species_name": species_name(species),
           "form": b[0x18] >> 3, "egg": bool(ivword >> 30 & 1), "nicknamed": bool(ivword >> 31),
           "nickname": decode_text(struct.unpack_from("<11H", c, 0)),
           "exp": exp, "level": level_for(personal_records()[species]["growthRate"], exp),
           "nature": nature, "nature_name": natures[nature] if nature < len(natures) else str(nature),
           "nature_born": p % 25, "mint": mint - 1 if mint else None,
           "ability": ability, "ability_name": abilities[ability] if ability < len(abilities) else str(ability),
           "hidden_ability": bool((b[0x19] >> 6) & HIDDEN_ABILITY_BIT), "ability_bit": _ability_bits(mon)[1],
           "ability_slot": slot, "ability_ok": ability == given,     # not: the species was changed alone
           "item": item, "item_name": "" if not item else items[item]["name"] if item in items else f"#{item}",
           "types": mon_types(species, ability, item, b[0x18] >> 3),
           "friendship": a[0x0C], "moves": moves,
           "ivs": [(ivword >> (5 * i)) & MAX_IV for i in range(NUM_STATS)], "evs": list(a[0x10:0x10 + NUM_STATS]),
           "ot_name": decode_text(struct.unpack_from("<8H", d, 0)), "ot_id": ot_id & 0xFFFF,
           "ot_sid": ot_id >> 16, "ot_gender": d[0x1C] >> 7, "gender": (b[0x18] >> 1) & 3,
           "shiny": is_shiny(p, ot_id), "ball": d[0x1B], "met_level": d[0x1C] & 0x7F}
    if mon["party"] is not None:
        status, level, _, hp, *stats = struct.unpack_from("<IBBHHHHHHH", mon["party"], 0)
        out.update(level=level, status=status, hp=hp, stats=stats)
    return out


# ---------------------------------------------------------------------------
# The party and the boxes.

def party_raw(save):
    block = save.block("SAVE_PARTY")
    count = struct.unpack_from("<i", block, PARTY_COUNT_AT)[0]
    return [bytes(block[PARTY_AT + i * PARTY_MON:PARTY_AT + (i + 1) * PARTY_MON]) for i in range(max(0, min(count, PARTY_SIZE)))]


def set_party_mon(save, slot, raw):
    if not 0 <= slot < len(party_raw(save)):
        raise ValueError(f"the party has no slot {slot + 1}")
    save.block("SAVE_PARTY")[PARTY_AT + slot * PARTY_MON:PARTY_AT + (slot + 1) * PARTY_MON] = raw


def add_party_mon(save, raw):
    """Party_AddMon: at the end, its Apricorn juice record cleared."""
    block = save.block("SAVE_PARTY")
    count = len(party_raw(save))
    if count >= PARTY_SIZE:
        raise ValueError(f"a party holds {PARTY_SIZE}")
    block[PARTY_AT + count * PARTY_MON:PARTY_AT + (count + 1) * PARTY_MON] = raw
    extra = PARTY_EXTRA + count * PERFORMANCE_MAX
    block[extra:extra + PERFORMANCE_MAX] = bytes(PERFORMANCE_MAX)
    struct.pack_into("<i", block, PARTY_COUNT_AT, count + 1)


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
        block[PARTY_AT + i * PARTY_MON:PARTY_AT + (i + 1) * PARTY_MON] = bytes(
            block[PARTY_AT + (i + 1) * PARTY_MON:PARTY_AT + (i + 2) * PARTY_MON])
        extra = PARTY_EXTRA + i * PERFORMANCE_MAX
        block[extra:extra + PERFORMANCE_MAX] = bytes(block[extra + PERFORMANCE_MAX:extra + 2 * PERFORMANCE_MAX])
    last = count - 1
    block[PARTY_AT + last * PARTY_MON:PARTY_AT + count * PARTY_MON] = EMPTY_PARTY_MON
    extra = PARTY_EXTRA + last * PERFORMANCE_MAX
    block[extra:extra + PERFORMANCE_MAX] = bytes(PERFORMANCE_MAX)
    struct.pack_into("<i", block, PARTY_COUNT_AT, count - 1)


def swap_party_mons(save, one, other):
    """Party_SwapSlots, the Apricorn juice records with them."""
    block = save.block("SAVE_PARTY")
    count = len(party_raw(save))
    if not (0 <= one < count and 0 <= other < count):
        raise ValueError("no such party slot")
    for at, size in ((PARTY_AT, PARTY_MON), (PARTY_EXTRA, PERFORMANCE_MAX)):
        x, y = at + one * size, at + other * size
        block[x:x + size], block[y:y + size] = bytes(block[y:y + size]), bytes(block[x:x + size])


def box_raw(save, box, slot):
    if not (0 <= box < NUM_BOXES and 0 <= slot < MONS_PER_BOX):
        raise ValueError(f"the boxes are 1 to {NUM_BOXES}, their slots 1 to {MONS_PER_BOX}")
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


def party_from_box(raw):
    """A BoxPokemon as a party Pokemon: the party part built the way
    CalcMonLevelAndStats builds it, at full HP."""
    mon = open_mon(raw)
    if mon is None or not mon["ok"]:
        raise ValueError("that slot holds nothing that can be taken")
    a = mon["blocks"][0]
    species = struct.unpack_from("<H", a, 0)[0]
    exp = struct.unpack_from("<I", a, 8)[0] & EXP_BITS
    mon["party"] = bytearray(PARTY_MON - BOX_MON)
    _set_party_stats(mon, level_for(personal_records()[species]["growthRate"], exp))
    return seal_mon(mon)


def withdraw(save, box, box_slot):
    """A boxed Pokemon to the end of the party, at full HP."""
    raw = box_raw(save, box, box_slot)
    if len(party_raw(save)) >= PARTY_SIZE:
        raise ValueError(f"a party holds {PARTY_SIZE}")
    add_party_mon(save, party_from_box(raw))
    set_box_mon(save, box, box_slot, EMPTY_BOX_MON)


def can_battle(raw):
    """A party Pokemon that is not an egg and has HP: what the PC counts
    before it lets the party's last one go."""
    mon = describe_mon(raw)
    return bool(mon and mon.get("ok") and not mon["egg"] and mon.get("hp", 0) > 0)


def move_mon(save, src, dst):
    """Where a dragged Pokemon goes. A place is ("party", slot) or
    ("box", box, slot). Onto another Pokemon the two swap, as the PC's own
    move does; onto an empty box slot, or past the party's last, it moves
    there (a party Pokemon moved past the last goes to the end, the others
    closing up). A box Pokemon joins the party at full HP. Nothing is done,
    and ValueError says why, if the party would be left with no Pokemon
    able to battle."""
    if tuple(src) == tuple(dst):
        return
    party = party_raw(save)
    count = len(party)

    def box_of(place):
        return box_raw(save, place[1], place[2])

    if src[0] == "party" and not 0 <= src[1] < count:
        raise ValueError(f"the party has no slot {src[1] + 1}")
    if src[0] == "box" and open_mon(box_of(src)) is None:
        raise ValueError(f"box {src[1] + 1} slot {src[2] + 1} is empty")
    if src[0] == "party" and dst[0] == "party":
        if dst[1] >= count:
            for k in range(src[1], count - 1):
                swap_party_mons(save, k, k + 1)
        else:
            swap_party_mons(save, src[1], dst[1])
    elif src[0] == "box" and dst[0] == "box":
        one, other = box_of(src), box_of(dst)
        set_box_mon(save, src[1], src[2], other)
        set_box_mon(save, dst[1], dst[2], one)
    elif src[0] == "party":
        held = box_of(dst)
        if open_mon(held) is None:
            if count == 1:
                raise ValueError("the party cannot be left empty")
            set_box_mon(save, dst[1], dst[2], party[src[1]])
            remove_party_mon(save, src[1])
        else:
            set_party_mon(save, src[1], party_from_box(held))
            set_box_mon(save, dst[1], dst[2], party[src[1]])
    else:
        raw = box_of(src)
        if dst[1] >= count:
            if count >= PARTY_SIZE:
                raise ValueError(f"a party holds {PARTY_SIZE}")
            add_party_mon(save, party_from_box(raw))
            set_box_mon(save, src[1], src[2], EMPTY_BOX_MON)
        else:
            set_party_mon(save, dst[1], party_from_box(raw))
            set_box_mon(save, src[1], src[2], party[dst[1]])
    if not any(can_battle(raw) for raw in party_raw(save)):
        raise ValueError("the party would have no Pokemon able to battle")


def boxes(save):
    block = save.block("SAVE_PCSTORAGE")
    names = [decode_text(struct.unpack_from(f"<{BOX_NAME_LENGTH}H", block, BOX_NAMES + 2 * BOX_NAME_LENGTH * n))
             for n in range(NUM_BOXES)]
    return {"current": struct.unpack_from("<i", block, CURRENT_BOX)[0], "names": names,
            "mons": [[describe_mon(box_raw(save, n, s)) for s in range(MONS_PER_BOX)] for n in range(NUM_BOXES)]}


# ---------------------------------------------------------------------------
# The rest of the save, read and written.

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
        if not (0 <= hours <= MAX_PLAY_HOURS and 0 <= minutes < 60 and 0 <= seconds < 60):
            raise ValueError(f"play time is up to {MAX_PLAY_HOURS}:59:59")
        struct.pack_into("<HBB", block, PLAY_TIME, hours, minutes, seconds)


def bag(save):
    block = save.block("SAVE_BAG")
    items = item_table()
    out = {}
    for pocket in pockets():
        at, count = pocket["at"], pocket["slots"]
        slots = [struct.unpack_from("<HH", block, at + 4 * s) for s in range(count)]
        out[pocket["name"]] = [{"item": item, "quantity": quantity,
                                "name": items[item]["name"] if item in items else f"#{item}"}
                               for item, quantity in slots if item and quantity]
    return out


def _machine_order(slot):
    """SortTMHMPocket's MachineSortGroup: the TMs, then the TRs, then the
    HMs, each by item id."""
    group = 2 if slot[0] in item_kind("ItemIsHM") else 1 if slot[0] in item_kind("ItemIsTR") else 0
    return (slot[1] == 0, group, slot[0])


def set_item(save, item, quantity):
    """How many of an item the bag holds, in the pocket the item belongs to.
    0 takes it out and the pocket closes up (PocketCompaction); a new one
    goes in the first free slot, and the berries and the machines are then
    sorted as Bag_AddItem sorts them. A TM is one at most: New Gold never
    uses one up."""
    entry = item_table().get(item)
    if not entry or not entry["pocket"]:
        raise ValueError(f"item {item} goes in no pocket")
    pocket, limit = entry["pocket"], item_limit(item)
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
    if added and pocket_const(pocket) == "POCKET_BERRIES":
        slots.sort(key=lambda s: (s[1] == 0, s[0]))
    if added and pocket_const(pocket) == "POCKET_TMHMS":
        slots.sort(key=_machine_order)
    for s, (got, many) in enumerate(slots):
        struct.pack_into("<HH", block, at + 4 * s, got, many)


@tree_cache
def dex_species():
    """The species with a Dex page: 1 to NATIONAL_DEX_COUNT but the egg and
    the retail forms numbered between Arceus and the species New Gold adds
    (DexSpeciesIsInvalid)."""
    return [s for s in range(1, NATIONAL_DEX_COUNT + 1) if not FIRST_DEX_GAP <= s <= LAST_DEX_GAP]


def _dex_bit(block, at, species):
    return (block[at + ((species - 1) >> 3)] >> ((species - 1) & 7)) & 1


def dex(save):
    block = save.block("SAVE_POKEDEX")
    seen = [s for s in dex_species() if _dex_bit(block, DEX_SEEN, s)]
    # Pokedex_CheckMonCaughtFlag wants both flags.
    caught = [s for s in seen if _dex_bit(block, DEX_CAUGHT, s)]
    return {"enabled": bool(block[DEX_ENABLED]) and flag_is_set(save, _got_pokedex()),
            "national": bool(block[DEX_NATIONAL]), "seen": seen, "caught": caught}


def _got_pokedex():
    return constants("include/constants/flags.h", "FLAG_")["FLAG_GOT_POKEDEX"]


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
    """The Dex itself -- Pokedex.dexEnabled, and FLAG_GOT_POKEDEX, which is
    what puts POKéDEX in the start menu (CheckGotPokedex) -- and the
    National Dex, which the script that gives it sets twice, in the Dex and
    in the profile (PlayerProfile.natDex)."""
    block = save.block("SAVE_POKEDEX")
    if enabled is not None:
        block[DEX_ENABLED] = int(bool(enabled))
        write_flag(save, _got_pokedex(), bool(enabled))
    if national is not None:
        block[DEX_NATIONAL] = int(bool(national))
        player = save.block("SAVE_PLAYERDATA")
        player[PROFILE_FLAGS] = (player[PROFILE_FLAGS] & ~NATDEX_MASK) | (NATDEX_MASK if national else 0)


def position(save):
    block = save.block("SAVE_LOCAL_FIELD_DATA")
    fields = ("map", "warp", "x", "y", "direction")
    return {"current": dict(zip(fields, struct.unpack_from("<5i", block, 0))),
            "warp": dict(zip(fields, struct.unpack_from("<5i", block, 3 * LOCATION))),
            "by_warp": flag_is_set(save, FLAG_CONTINUE_BY_WARP)}


def num_flags():
    return constants("include/constants/flags.h", "NUM_")["NUM_FLAGS"]


def flag_is_set(save, number):
    return bool((save.block("SAVE_FLAGS")[FLAGS_AT + number // 8] >> (number % 8)) & 1)


def write_flag(save, number, on):
    if not 0 < number < num_flags():
        raise ValueError(f"flag {number:#x} is not one the save keeps")
    flags = save.block("SAVE_FLAGS")
    at = FLAGS_AT + number // 8
    flags[at] = flags[at] | (1 << (number % 8)) if on else flags[at] & ~(1 << (number % 8))


def var_value(save, number):
    return struct.unpack_from("<H", save.block("SAVE_FLAGS"), 2 * (number - VAR_BASE))[0]


def write_var(save, number, value):
    if not VAR_BASE <= number < VAR_BASE + NUM_VARS:
        raise ValueError(f"variable {number:#x} is not one the save keeps")
    if not 0 <= value <= 0xFFFF:
        raise ValueError("a variable is 0 to 65535")
    struct.pack_into("<H", save.block("SAVE_FLAGS"), 2 * (number - VAR_BASE), value)


def find_flags(save, query):
    """The variables, then the flags, the save keeps whose name holds the
    query. VAR_BASE is where the variables start, not one of them."""
    query = query.upper()
    out = []
    for name, number in constants("include/constants/vars.h", "VAR_").items():
        if query in name and VAR_BASE <= number < VAR_BASE + NUM_VARS and name != "VAR_BASE":
            out.append({"kind": "var", "name": name, "number": number, "value": var_value(save, number)})
    for name, number in constants("include/constants/flags.h", "FLAG_").items():
        if query in name and 0 < number < num_flags() and not name.startswith("FLAG_ACTION_"):
            out.append({"kind": "flag", "name": name, "number": number, "value": int(flag_is_set(save, number))})
    return out


def info(save):
    return {"half": save.half, "counter": save.counter(), "legacy": save.legacy,
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


globals().update(_layout())     # fresh() sets it again when a header changes


if __name__ == "__main__":
    main()
