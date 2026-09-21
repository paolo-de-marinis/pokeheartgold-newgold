#!/usr/bin/env python3
"""Bring New Gold's added moves into the native move table.

Thirteen of the fourteen are moves from later generations that New Gold's
trainers and learnsets reach; Solar Seeds is konefr's own. Everything about a
move except two bytes comes from the reference: power, type, accuracy, PP,
effect chance, what it targets and what it does.

The two exceptions are the flag byte and the contest byte, which pokeheartgold
has never named. Rather than guess at bits, each added move copies them from a
move already in the table that behaves the same way — a model — and the model
is named here so the choice can be argued with.

The battle animation is borrowed the same way, by number, because the added
moves are past the end of the animation archive.

Usage: import_moves.py REFERENCE_CHECKOUT [--write]
"""

import argparse
import re
import struct
from pathlib import Path

ROOT = Path(__file__).resolve().parents[2]
TABLE = ROOT / "files/poketool/waza/waza_tbl.narc"
NAMES = ROOT / "files/msgdata/msg/msg_0750.gmm"
CAPS = ROOT / "files/msgdata/msg/msg_0751.gmm"
DESCRIPTIONS = ROOT / "files/msgdata/msg/msg_0749.gmm"
ANIMATIONS = ROOT / "files/battledata/script/move_script"

RECORD = "<HBBBBBBHbBBBH"
RECORD_SIZE = 16

# move -> (model for the flag and contest bytes, move whose animation it borrows)
#
# The model is a move of the same shape: the same split, the same kind of
# target, and the same answer to "does it have a secondary effect", which is
# what the flag byte is mostly about.
MODELS = {
    "ACROBATICS": ("AERIAL_ACE", "AERIAL_ACE"),
    "BULLDOZE": ("ROCK_SLIDE", "MAGNITUDE"),
    "COIL": ("BULK_UP", "BULK_UP"),
    "DAZZLING_GLEAM": ("HYPER_VOICE", "SWIFT"),
    "ECHOED_VOICE": ("HYPER_VOICE", "HYPER_VOICE"),
    "HEX": ("SHADOW_BALL", "SHADOW_BALL"),
    "MOONBLAST": ("ENERGY_BALL", "FLASH_CANNON"),
    "MYSTICAL_FIRE": ("ENERGY_BALL", "FLAMETHROWER"),
    "PETAL_BLIZZARD": ("PETAL_DANCE", "PETAL_DANCE"),
    "QUIVER_DANCE": ("DRAGON_DANCE", "DRAGON_DANCE"),
    "RAGE_FIST": ("SHADOW_PUNCH", "SHADOW_PUNCH"),
    "STICKY_WEB": ("SPIKES", "SPIDER_WEB"),
    "STRUGGLE_BUG": ("BUG_BUZZ", "BUG_BUZZ"),
    "SOLAR_SEEDS": ("BULLET_SEED", "EMBER"),
    "TWIN_BEAM": ("DOUBLE_KICK", "PSYBEAM"),
    "HYPER_DRILL": ("MEGAHORN", "DRILL_PECK"),
    "DRAGON_CHEER": ("HELPING_HAND", "HELPING_HAND"),
    "PSYSHIELD_BASH": ("METAL_CLAW", "ZEN_HEADBUTT"),
    "FELL_STINGER": ("TWINEEDLE", "TWINEEDLE"),
    "INFESTATION": ("WHIRLPOOL", "WHIRLPOOL"),
    "TOXIC_THREAD": ("LEER", "STRING_SHOT"),
    "FREEZE_DRY": ("ICE_BEAM", "ICE_BEAM"),
    "FAIRY_WIND": ("SWIFT", "SWIFT"),
    "SCALD": ("HYDRO_PUMP", "SURF"),
    "FLAME_CHARGE": ("FLAME_WHEEL", "FLAME_WHEEL"),
    "INFERNO": ("FIRE_BLAST", "FIRE_BLAST"),
    "RAGE_POWDER": ("FOLLOW_ME", "FOLLOW_ME"),
    "TEARFUL_LOOK": ("LEER", "LEER"),
}

# The reference's effect names, against ours. Six had no script here and were
# written for this; the rest already existed.
EFFECTS = {
    "MOVE_EFFECT_DOUBLE_POWER_WITHOUT_ITEM": "MOVE_EFFECT_DOUBLE_POWER_WITHOUT_ITEM",
    "MOVE_EFFECT_LOWER_SPEED_HIT": "MOVE_EFFECT_LOWER_SPEED_HIT",
    "MOVE_EFFECT_ATK_DEF_ACC_UP": "MOVE_EFFECT_ATK_DEF_ACC_UP",
    "MOVE_EFFECT_HIT": "MOVE_EFFECT_HIT",
    "MOVE_EFFECT_DOUBLE_DAMAGE_ON_STATUS": "MOVE_EFFECT_DOUBLE_DAMAGE_ON_STATUS",
    "MOVE_EFFECT_LOWER_SP_ATK_HIT": "MOVE_EFFECT_LOWER_SP_ATK_HIT",
    "MOVE_EFFECT_SP_ATK_SP_DEF_SPEED_UP": "MOVE_EFFECT_SP_ATK_SP_DEF_SPEED_UP",
    "MOVE_EFFECT_STICKY_WEB": "MOVE_EFFECT_STICKY_WEB",
    "MOVE_EFFECT_BURN_MULTI_HIT": "MOVE_EFFECT_BURN_MULTI_HIT",
    "MOVE_EFFECT_HIT_TWICE": "MOVE_EFFECT_HIT_TWICE",
    "MOVE_EFFECT_RAISE_DEF_HIT": "MOVE_EFFECT_RAISE_DEF_HIT",
    "MOVE_EFFECT_FELL_STINGER": "MOVE_EFFECT_FELL_STINGER",
    "MOVE_EFFECT_BIND_HIT": "MOVE_EFFECT_BIND_HIT",
    "MOVE_EFFECT_TOXIC_THREAD": "MOVE_EFFECT_TOXIC_THREAD",
    "MOVE_EFFECT_FREEZE_HIT": "MOVE_EFFECT_FREEZE_HIT",
    "MOVE_EFFECT_THAW_AND_BURN_HIT": "MOVE_EFFECT_THAW_AND_BURN_HIT",
    "MOVE_EFFECT_RAISE_SPEED_HIT": "MOVE_EFFECT_RAISE_SPEED_HIT",
    "MOVE_EFFECT_BURN_HIT": "MOVE_EFFECT_BURN_HIT",
    "MOVE_EFFECT_MAKE_GLOBAL_TARGET": "MOVE_EFFECT_MAKE_GLOBAL_TARGET",
    "MOVE_EFFECT_ATK_SP_ATK_DOWN": "MOVE_EFFECT_ATK_SP_ATK_DOWN",
}

SPLITS = {"SPLIT_PHYSICAL": 0, "SPLIT_SPECIAL": 1, "SPLIT_STATUS": 2}


def constants(path, prefix):
    """Plain numbers and the (1 << n) the bit-set constants are written as."""
    text = (ROOT / path).read_text()
    out = {}
    for match in re.finditer(r"#define (" + prefix + r"[A-Z0-9_]+)\s+(\(1 << (\d+)\)|\d+)\s*$", text, re.M):
        out[match[1]] = 1 << int(match[3]) if match[3] else int(match[2])
    return out


def reference_records(reference):
    source = (reference / "data/Moves.c").read_text(errors="replace")
    out = {}
    for name in MODELS:
        match = re.search(r"\[MOVE_" + name + r"\]\s*=\s*\{", source)
        if match is None:
            raise SystemExit(f"the reference has no MOVE_{name}")
        start = source.index("{", match.start())
        depth, end = 0, start
        while True:
            depth += (source[end] == "{") - (source[end] == "}")
            end += 1
            if depth == 0:
                break
        out[name] = source[start:end]
    return out


def field(block, key):
    match = re.search(r"\." + key + r"\s*=\s*([^,\n]+)", block)
    return match.group(1).strip() if match else None


def ranges(block):
    """RANGE_ constants are a bit set; the reference names one or more."""
    text = field(block, "target") or "RANGE_SINGLE_TARGET"
    known = constants("include/constants/moves.h", "RANGE_")
    value = 0
    for name in re.findall(r"RANGE_[A-Z_]+", text):
        if name not in known:
            raise SystemExit(f"this game has no {name}")
        value |= known[name]
    return value


def number(block, key):
    """Some numbers are written as a choice between generations. The second is
    the older of the two, which is what this game is."""
    numbers = re.findall(r"\d+", field(block, key) or "0")
    return int(numbers[-1]) if numbers else 0


def read_table():
    data = TABLE.read_bytes()
    count = struct.unpack("<H", data[0x18:0x1A])[0]
    fatb = 0x1C
    offsets = [struct.unpack("<II", data[fatb + 8 * i:fatb + 8 * i + 8]) for i in range(count)]
    gmif = data.index(b"GMIF") + 8
    return [data[gmif + start:gmif + end] for start, end in offsets]


def write_table(records):
    """Rebuild the archive: one member per record, all the same size."""
    fatb = b"BTAF" + struct.pack("<IHH", 12 + 8 * len(records), len(records), 0)
    fatb += b"".join(struct.pack("<II", i * RECORD_SIZE, (i + 1) * RECORD_SIZE)
                     for i in range(len(records)))
    fnbt = b"BTNF" + struct.pack("<IIHH", 16, 4, 0, 1)
    data = b"".join(records)
    gmif = b"GMIF" + struct.pack("<I", 8 + len(data)) + data
    size = 16 + len(fatb) + len(fnbt) + len(gmif)
    header = b"NARC" + struct.pack("<HHIHH", 0xFFFE, 0x0100, size, 16, 3)
    return header + fatb + fnbt + gmif


def rows(path):
    return re.findall(r'<row id="([^"]+)" index="(\d+)">\s*<attribute[^>]*>[^<]*</attribute>\s*'
                      r'<language name="English">(.*?)</language>', path.read_text(), re.S)


def append_rows(path, prefix, texts, start, write):
    """Rewrite every row from `start` on, so running this twice is the same as
    running it once."""
    text = path.read_text()
    text = re.sub(r'\t<row id="[^"]+" index="(\d+)">.*?\t</row>\n',
                  lambda m: "" if int(m.group(1)) >= start else m.group(0), text, flags=re.S)
    block = ""
    for offset, value in enumerate(texts):
        index = start + offset
        name = (f"{prefix}_{value.lower().replace(' ', '_')}" if prefix == "msg_0751"
                else f"{prefix}_{index:05d}")
        block += (f'\t<row id="{name}" index="{index}">\n'
                  f'\t\t<attribute name="window_context_name">used</attribute>\n'
                  f'\t\t<language name="English">{value}</language>\n'
                  f'\t</row>\n')
    if write:
        path.write_text(text.replace("</body>", block + "</body>", 1))
    return len(texts)


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("reference", type=Path)
    parser.add_argument("--write", action="store_true")
    args = parser.parse_args()

    moves = constants("include/constants/moves.h", "MOVE_")
    effects = constants("include/constants/move_effects.h", "MOVE_EFFECT_")
    blocks = reference_records(args.reference)
    table = read_table()

    first = min(moves[f"MOVE_{name}"] for name in MODELS)
    order = sorted(MODELS, key=lambda name: moves[f"MOVE_{name}"])
    if [moves[f"MOVE_{name}"] for name in order] != list(range(first, first + len(order))):
        raise SystemExit("the added moves are not numbered consecutively")

    while len(table) < first + len(order):
        table.append(bytes(RECORD_SIZE))

    names, capsNames, descriptions = [], [], []
    for name in order:
        block = blocks[name]
        model, _ = MODELS[name]
        modelRecord = table[moves[f"MOVE_{model}"]]
        modelFields = struct.unpack(RECORD, modelRecord)
        effect = field(block, "effect")
        if effect not in EFFECTS or EFFECTS[effect] not in effects:
            raise SystemExit(f"MOVE_{name} wants {effect}, which this game has no script for")
        record = struct.pack(
            RECORD,
            effects[EFFECTS[effect]],
            SPLITS[field(block, "split")],
            number(block, "power"),
            constants("include/constants/pokemon.h", "TYPE_")[field(block, "type")],
            number(block, "accuracy"),
            number(block, "pp"),
            number(block, "effectChance"),
            ranges(block),
            number(block, "priority"),
            modelFields[9],   # the flag byte, from the model
            modelFields[10],  # and the contest appeal
            modelFields[11],
            0,
        )
        table[moves[f"MOVE_{name}"]] = record
        text = re.search(r'\.name = "([^"]*)"', block).group(1)
        names.append(text)
        capsNames.append(re.search(r'\.capsName = "([^"]*)"', block).group(1))
        descriptions.append(re.search(r'\.description = "([^"]*)"', block).group(1).replace("\\\\n", "\\n"))
        print(f"  {moves[f'MOVE_{name}']:3} {text:16} model {model}")

    print(f"{len(order)} moves, table {len(table)} records")
    if not args.write:
        print("nothing written; pass --write")
        return

    TABLE.write_bytes(write_table(table))
    append_rows(NAMES, "msg_0750", names, first, True)
    append_rows(CAPS, "msg_0751", capsNames, first, True)
    append_rows(DESCRIPTIONS, "msg_0749", descriptions, first, True)
    print(f"wrote {TABLE.relative_to(ROOT)} and three message banks")


if __name__ == "__main__":
    main()
