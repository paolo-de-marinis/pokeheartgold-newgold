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
import functools
import json
import re
from pathlib import Path

ROOT = Path(__file__).resolve().parents[3]
TRAINERS = ROOT / "files/poketool/trainer/trainers.json"

# The reference's bits for a party entry carrying moves and a held item are the
# ones this repository's TRTYPE names are built from. HAS_ABILITY is a third
# the reference has and this table has not: it lets a party entry name its
# ability outright instead of picking one of the species' slots. Two trainers
# in the whole of konefr's table use it, Bugsy and Whitney, and every ability
# the ten of them ask for is one of that species' own three -- so the name
# resolves back to the slot override this table already carries and nothing
# has to grow a field. An ability that is none of the three would be a real
# gap; resolve_ability raises and the trainer is reported and left alone.
HAS_MOVES, HAS_ITEM, HAS_ABILITY = 0x01, 0x02, 0x04
TYPE_NAMES = {0: "TRTYPE_MON", HAS_MOVES: "TRTYPE_MON_MOVES",
              HAS_ITEM: "TRTYPE_MON_ITEM", HAS_MOVES | HAS_ITEM: "TRTYPE_MON_ITEM_MOVES"}

# The reference's slot constants are the byte its MakeTrainerPokemonParty hands
# to the retail personality code, TrMon_OverridePidGender here, before it
# writes the ability outright. 0x00 leaves the personality alone; 0x20 is this
# table's SECOND nibble and sets its low bit; 0x02 is the FEMALE gender nibble,
# so a hidden slot also sets the personality modifier to the species' gender
# ratio less two -- which carries over to the party members after it. Each is
# translated into the gender and ability nibbles that do the same here: the
# same effect on the personality, and TrMon_ApplyAbilitySlot writing the same
# ability.
ABILITY_SLOTS = {
    "TRAINER_POKEMON_ABILITY_1": ("TRPOKE_GENDER_OVERRIDE_OFF", "TRPOKE_ABILITY_OVERRIDE_OFF"),
    "TRAINER_POKEMON_ABILITY_2": ("TRPOKE_GENDER_OVERRIDE_OFF", "TRPOKE_ABILITY_OVERRIDE_SECOND"),
    "TRAINER_POKEMON_ABILITY_HIDDEN": ("TRPOKE_GENDER_OVERRIDE_FEMALE", "TRPOKE_ABILITY_OVERRIDE_HIDDEN"),
}

# An ability named outright is written instead of the slot's, and the slot
# still acts on the personality. So the nibble keeps the slot's effect on the
# personality and writes the named ability: the second one on a slot that
# leaves the personality alone is SECOND_BY_NAME. A slot whose effect no
# nibble for the named ability shares is reported rather than approximated.
NAMED = {"TRPOKE_ABILITY_OVERRIDE_FIRST": "TRPOKE_ABILITY_OVERRIDE_OFF",
         "TRPOKE_ABILITY_OVERRIDE_SECOND": "TRPOKE_ABILITY_OVERRIDE_SECOND_BY_NAME",
         "TRPOKE_ABILITY_OVERRIDE_HIDDEN": "TRPOKE_ABILITY_OVERRIDE_HIDDEN"}


def named_override(slot, named):
    """The ability nibble for an entry with this slot naming this ability."""
    if slot != "TRAINER_POKEMON_ABILITY_2":
        return NAMED[named]
    if named != "TRPOKE_ABILITY_OVERRIDE_SECOND":
        raise ValueError(f"{slot} with {named} named: no nibble does both")
    return ABILITY_SLOTS[slot][1]

DOUBLE = {"SINGLE_BATTLE": 0, "DOUBLE_BATTLE": 2, "NO_PARTNER_DOUBLE_BATTLE": 3}

# konefr's plain errors, corrected on the way in (Paolo, 2026-09-25: a plain
# konefr error is fixed and stays in docs/newgold/KONEFR-NOTES.md). Each one
# holds only while his data still has the slip: once he changes it, his data
# is taken as it is and the run says the correction is stale.

# konefr's first Silver: 5cfd84cc7 gives trainers 2, 3 and 265 (Silver with
# Cyndaquil, Totodile, Chikorita) L7, difficulty 40 and a Potion, and his
# worklog says the same for each variant ("Target level / ace: 7", "Potion
# IVs 40", "increased difficulty"). Cherrygrove's script (scr_seq_0850_T21.s)
# fights the Passerby Boy 495-497 instead, which he never touched, and no
# script fights 2, 3 or 265. His party and items go to the trainer the script
# uses, one species for one; the Boy's class, name and lines stay, since the
# rival has no name yet there. KONEFR-NOTES.md, Allenatori 1.
FIRST_SILVER = {495: 265, 496: 2, 497: 3}

# Names this repository spells differently from the reference.
ALIASES = {
    "MOVE_FEINT_ATTACK": "MOVE_FAINT_ATTACK",
    "MOVE_SMOKESCREEN": "MOVE_SMOKE_SCREEN",
    "MOVE_SELF_DESTRUCT": "MOVE_SELFDESTRUCT",
    "MOVE_HIGH_JUMP_KICK": "MOVE_HI_JUMP_KICK",
    "MOVE_SOFT_BOILED": "MOVE_SOFTBOILED",
    "ITEM_TWISTED_SPOON": "ITEM_TWISTEDSPOON",
    "ITEM_LEEK": "ITEM_STICK",
    "ABILITY_COMPOUND_EYES": "ABILITY_COMPOUNDEYES",
}


def native(name):
    return ALIASES.get(name, name)


@functools.lru_cache(maxsize=1)
def personal_abilities():
    """Each species' first, second and hidden ability, from the personal data.

    This is what a slot override resolves to at battle time:
    TrMon_ApplyAbilitySlot writes the first, the second or the hidden one.
    """
    rows = json.loads((ROOT / "files/poketool/personal/personal.json").read_text())["baseStats"]
    return {"SPECIES_" + row["species"]:
            (row["abilities"][0], row["abilities"][1], row.get("hiddenAbility"))
            for row in rows}


def resolve_ability(abilities, species, ability):
    """The slot override that gives this species this ability."""
    slots = abilities.get(species)
    if slots is None:
        raise ValueError(f"no personal record for {species}")
    first, second, hidden = slots
    if ability == first:
        return "TRPOKE_ABILITY_OVERRIDE_FIRST"
    if ability == second:
        return "TRPOKE_ABILITY_OVERRIDE_SECOND"
    if ability == hidden:
        return "TRPOKE_ABILITY_OVERRIDE_HIDDEN"
    raise ValueError(f"{species} has no slot for {ability}; it has {slots}")


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
        slot = re.search(r"\.abilitySlot\s*=\s*(\w+)", member).group(1)
        entry = {
            "difficulty": int(re.search(r"\.ivs\s*=\s*(\d+)", member).group(1)),
            "genderOverride": ABILITY_SLOTS[slot][0],
            "abilityOverride": ABILITY_SLOTS[slot][1],
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
        if trainerType & HAS_ABILITY:
            # The ability named outright wins over the slot the entry also
            # gives: the reference writes both and reads the name.
            named = re.search(r"\.ability\s*=\s*(ABILITY_[A-Z0-9_]+)", member)
            if named:
                entry["abilityOverride"] = named_override(slot, resolve_ability(
                    personal_abilities(), entry["species"], native(named.group(1))))
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
    hidden, stale = 0, []
    for index, trainer in enumerate(trainers):
        if index not in table:
            problems["no reference entry"] += 1
            continue
        block = table[index]
        try:
            wanted = translate(block, flags, types)
            if index in FIRST_SILVER:
                his = translate(table[FIRST_SILVER[index]], flags, types)
                if (not wanted["items"] and his["type"] == wanted["type"]
                        and all(m["level"] == 5 and m["difficulty"] == 0 for m in wanted["party"])
                        and [m["species"] for m in his["party"]] == [m["species"] for m in wanted["party"]]):
                    wanted.update(items=his["items"], party=his["party"])
                else:
                    stale.append(f"{index}: not the retail first Silver any more (FIRST_SILVER)")
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
        print(f"  {hidden} Pokemon ask for a hidden ability")
    for problem, count in problems.most_common():
        print(f"  left alone, {count}: {problem}")
    for line in stale:
        print(f"  correction stale, his data taken: {line}")

    if not args.write:
        print("nothing written; pass --write")
        return
    TRAINERS.write_text(json.dumps(data, indent=2) + "\n")
    print(f"wrote {TRAINERS.relative_to(ROOT)}")


if __name__ == "__main__":
    main()
