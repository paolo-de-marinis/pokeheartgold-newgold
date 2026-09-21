#!/usr/bin/env python3
"""Bring New Gold's trainers into the native trainer table.

files/poketool/trainer/trainers.json is already a text source describing the
same thing as the reference's table, entry for entry in the same order, so this
is a translation: class, items, AI flags, battle type, and a party of levels,
species, held items and moves.

A trainer naming something this repository does not define is reported and left
as it was rather than half-written.

Usage: import_trainers.py REFERENCE_CHECKOUT [--write] [--index N]
"""

import argparse
import collections
import json
import re
from pathlib import Path

ROOT = Path(__file__).resolve().parents[2]
TRAINERS = ROOT / "files/poketool/trainer/trainers.json"

# The reference's bits for a party entry carrying moves and a held item are the
# ones this repository's TRTYPE names are built from.
HAS_MOVES, HAS_ITEM = 0x01, 0x02
TYPE_NAMES = {0: "TRTYPE_MON", HAS_MOVES: "TRTYPE_MON_MOVES",
              HAS_ITEM: "TRTYPE_MON_ITEM", HAS_MOVES | HAS_ITEM: "TRTYPE_MON_ITEM_MOVES"}

# A hidden ability has no counterpart yet, so those Pokemon keep the ability
# their personality gives them until hidden abilities exist.
ABILITY_SLOTS = {"TRAINER_POKEMON_ABILITY_1": "TRPOKE_ABILITY_OVERRIDE_FIRST",
                 "TRAINER_POKEMON_ABILITY_2": "TRPOKE_ABILITY_OVERRIDE_SECOND",
                 "TRAINER_POKEMON_ABILITY_HIDDEN": "TRPOKE_ABILITY_OVERRIDE_OFF"}

DOUBLE = {"SINGLE_BATTLE": 0, "DOUBLE_BATTLE": 2}

# Names this repository spells differently from the reference.
ALIASES = {
    "MOVE_FEINT_ATTACK": "MOVE_FAINT_ATTACK",
    "MOVE_SMOKESCREEN": "MOVE_SMOKE_SCREEN",
    "MOVE_SELF_DESTRUCT": "MOVE_SELFDESTRUCT",
    "MOVE_HIGH_JUMP_KICK": "MOVE_HI_JUMP_KICK",
    "MOVE_SOFT_BOILED": "MOVE_SOFTBOILED",
    "ITEM_TWISTED_SPOON": "ITEM_TWISTEDSPOON",
    "ITEM_LEEK": "ITEM_STICK",
}


def native(name):
    return ALIASES.get(name, name)


def constants(path, prefix):
    text = (ROOT / path).read_text()
    return {m[1]: int(m[2], 0) for m in
            re.finditer(r"#define (" + prefix + r"[A-Z0-9_]+)\s+(0x[0-9A-Fa-f]+|\d+)", text)}


def defined(path, prefix):
    return set(re.findall(r"\b(" + prefix + r"[A-Z0-9_]+)", (ROOT / path).read_text()))


def flag_values(reference):
    """Every AI flag, including the ones defined as a combination of others."""
    text = (reference / "include/trainer_data.h").read_text(errors="replace")
    values = {m[1]: 1 << int(m[2]) for m in re.finditer(r"#define (F_[A-Z0-9_]+)\s+\(1 << (\d+)\)", text)}
    for match in re.finditer(r"#define (F_[A-Z0-9_]+)\s+\(([^)]*\|[^)]*)\)", text):
        parts = re.findall(r"F_[A-Z0-9_]+", match.group(2))
        if all(part in values for part in parts):
            values[match.group(1)] = 0
            for part in parts:
                values[match.group(1)] |= values[part]
    return values


def entries(reference):
    source = (reference / "data/Trainers.c").read_text(errors="replace")
    blocks = re.split(r"\n\s*\[(\d+)\] = \{", source)
    return {int(blocks[i]): blocks[i + 1] for i in range(1, len(blocks), 2)}


def section(block, name):
    start = block.index("." + name + " = {")
    depth, end = 0, start + len("." + name + " = ")
    while True:
        depth += (block[end] == "{") - (block[end] == "}")
        end += 1
        if depth == 0:
            return block[start:end]


def party_members(block):
    if ".party = {" not in block:
        return []
    body = section(block, "party")[len(".party = "):]
    members, depth, start = [], 0, None
    for index, character in enumerate(body[1:-1], start=1):
        if character == "{":
            if depth == 0:
                start = index
            depth += 1
        elif character == "}":
            depth -= 1
            if depth == 0:
                members.append(body[start:index + 1])
    return members


def translate(block, flags, types):
    trainerType = 0
    for name in re.findall(r"TRAINER_DATA_TYPE_[A-Z_]+", re.search(r"\.trainerType\s*=\s*([^,]+),", block).group(1)):
        trainerType |= types[name]

    aiText = re.search(r"\.aiFlags\s*=\s*([^,]+),", block).group(1)
    ai = 0
    for name in re.findall(r"F_[A-Z0-9_]+", aiText):
        ai |= flags[name]
    if not re.search(r"F_[A-Z0-9_]+", aiText):
        ai = int(aiText.strip(), 0)

    items = [native(name) for name in re.findall(r"\bITEM_[A-Z0-9_]+", section(block, "items"))
             if name != "ITEM_NONE"] if ".items = {" in block else []

    party = []
    for member in party_members(block):
        entry = {
            "difficulty": int(re.search(r"\.ivs\s*=\s*(\d+)", member).group(1)),
            "genderOverride": "TRPOKE_GENDER_OVERRIDE_OFF",
            "abilityOverride": ABILITY_SLOTS[re.search(r"\.abilitySlot\s*=\s*(\w+)", member).group(1)],
            "level": int(re.search(r"\.level\s*=\s*(\d+)", member).group(1)),
            "species": re.search(r"\.species\s*=\s*(SPECIES_[A-Z0-9_]+)", member).group(1),
        }
        if trainerType & HAS_ITEM:
            # A party entry that carries no item simply omits the field.
            held = re.search(r"\.item\s*=\s*(ITEM_[A-Z0-9_]+)", member)
            entry["item"] = native(held.group(1)) if held else "ITEM_NONE"
        if trainerType & HAS_MOVES:
            moves = re.findall(r"\bMOVE_[A-Z0-9_]+", section(member, "moves")) if ".moves = {" in member else []
            entry["moves"] = [native(move) for move in moves if move != "MOVE_NONE"]
        seal = re.search(r"\.ballSeal\s*=\s*(\d+)", member)
        entry["capsule"] = int(seal.group(1)) if seal else 0
        party.append(entry)

    return {
        "type": TYPE_NAMES[trainerType & (HAS_MOVES | HAS_ITEM)],
        "class": re.search(r"\.trainerClass\s*=\s*(TRAINERCLASS_[A-Z0-9_]+)", block).group(1),
        "name": "{TRNAME}" + re.search(r'\.name\s*=\s*"([^"]*)"', block).group(1),
        "items": items,
        "ai_flags": ai,
        "double": DOUBLE[re.search(r"\.battleType\s*=\s*(\w+)", block).group(1)],
        "party": party,
    }


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("reference", type=Path)
    parser.add_argument("--write", action="store_true")
    parser.add_argument("--index", type=int)
    args = parser.parse_args()

    flags = flag_values(args.reference)
    types = constants("../hgss-newgold/include/constants/trainers.h", "TRTYPE_") if False else {}
    types = {m[1]: int(m[2], 0) for m in re.finditer(
        r"#define (TRAINER_DATA_TYPE_[A-Z_]+)\s+(0x[0-9A-Fa-f]+)",
        (args.reference / "include/trainer_data.h").read_text(errors="replace"))}

    known = (defined("include/constants/species.h", "SPECIES_")
             | defined("include/constants/items.h", "ITEM_")
             | defined("include/constants/moves.h", "MOVE_")
             | defined("include/constants/trainer_class.h", "TRAINERCLASS_"))

    table = entries(args.reference)
    data = json.loads(TRAINERS.read_text())
    trainers = data["trainers"]

    counts = collections.Counter()
    changed, problems = 0, collections.Counter()
    hidden = 0
    for index, trainer in enumerate(trainers):
        if index not in table:
            problems["no reference entry"] += 1
            continue
        block = table[index]
        try:
            wanted = translate(block, flags, types)
        except (AttributeError, KeyError, ValueError) as error:
            problems[f"unreadable: {error}"] += 1
            continue
        hidden += block.count("TRAINER_POKEMON_ABILITY_HIDDEN")
        missing = sorted({name for name in re.findall(r"\b(?:SPECIES|ITEM|MOVE|TRAINERCLASS)_[A-Z0-9_]+",
                                                      json.dumps(wanted)) if name not in known})
        if missing:
            problems[f"undefined {missing[0]}"] += 1
            continue
        differing = [key for key in wanted if trainer.get(key) != wanted[key]]
        if not differing:
            continue
        changed += 1
        counts.update(differing)
        if args.index == index:
            print(json.dumps({"before": {k: trainer.get(k) for k in differing},
                              "after": {k: wanted[k] for k in differing}}, indent=1)[:2000])
        if args.write:
            trainer.update(wanted)

    print(f"{changed} of {len(trainers)} trainers change")
    for key, count in counts.most_common():
        print(f"  {key}: {count}")
    if hidden:
        print(f"  {hidden} Pokemon ask for a hidden ability, which does not exist yet; "
              f"they keep the one their personality gives them")
    for problem, count in problems.most_common():
        print(f"  left alone, {count}: {problem}")

    if not args.write:
        print("nothing written; pass --write")
        return
    TRAINERS.write_text(json.dumps(data, indent=2) + "\n")
    print(f"wrote {TRAINERS.relative_to(ROOT)}")


if __name__ == "__main__":
    main()
