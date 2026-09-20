#!/usr/bin/env python3
"""Generate personal records for the species New Gold adds, in native format.

Reads the behaviour reference's species table, base experience table and
learnsets, and writes pokeheartgold's own `files/poketool/personal/personal.json`
entries plus the matching `SPECIES_*` constants. Nothing is copied: the values
are game data, restated in the shape this repository already uses.

Usage: import_species.py REFERENCE_CHECKOUT [--write]
Without --write it reports what it would change and touches nothing.
"""

import argparse
import json
import re
from pathlib import Path

ROOT = Path(__file__).resolve().parents[2]

# The species reachable in New Gold that HGSS does not have, in National Dex
# order. Derived from the trainer, encounter and headbutt tables closed over
# the evolution table; see docs/newgold/SCOPE.md.
NEW_SPECIES = """
    LILLIPUP HERDIER STOUTLAND PURRLOIN LIEPARD TYMPOLE PALPITOAD SEISMITOAD
    SEWADDLE SWADLOON LEAVANNY YAMASK COFAGRIGUS TRUBBISH GARBODOR EMOLGA
    KARRABLAST ESCAVALIER FOONGUS AMOONGUSS JOLTIK GALVANTULA FERROSEED
    FERROTHORN KLINK KLANG KLINKLANG ELGYEM BEHEEYEM LITWICK LAMPENT CHANDELURE
    SHELMET ACCELGOR BOUFFALANT BUNNELBY DIGGERSBY FLETCHLING FLETCHINDER
    TALONFLAME LITLEO PYROAR ESPURR MEOWSTIC SYLVEON DEDENNE PHANTUMP TREVENANT
    PUMPKABOO GOURGEIST NOIBAT NOIVERN APPLIN FLAPPLE APPLETUN SIZZLIPEDE
    CENTISKORCH WYRDEER KLEAVOR URSALUNA ANNIHILAPE FARIGIRAF DUDUNSPARCE
    DIPPLIN HYDRAPPLE
""".split()

# GENDER_RATIO(frac) stores (u8)(frac * 254.75), and a fraction above one means
# genderless. Every ratio the games use is a multiple of an eighth, so the
# fraction is recovered by rounding and then checked against the stored byte.
def gender_fraction(stored):
    if stored == 255:
        return 2.0
    fraction = round(stored / 254.75 * 8) / 8
    if int(fraction * 254.75) != stored:
        raise ValueError(f"gender ratio byte {stored} is not a multiple of an eighth")
    return fraction

# The original field is a byte; the full value lives beside it in what Gen 4
# left as padding, so nothing is lost and nothing shifts.
MAX_STORED_EXP_YIELD = 255

# Constants this repository spells differently from the reference.
ALIASES = {
    "ABILITY_COMPOUND_EYES": "ABILITY_COMPOUNDEYES",
    "ITEM_TINY_MUSHROOM": "ITEM_TINYMUSHROOM",
}


def native(name):
    return ALIASES.get(name, name)


def species_entries(reference):
    """Split the reference species table into one text block per species."""
    source = (reference / "data/Species.c").read_text(errors="replace")
    blocks = re.split(r"\n    \[(SPECIES_[A-Z0-9_]+)\] = \{", source)
    return {blocks[i][len("SPECIES_"):]: blocks[i + 1] for i in range(1, len(blocks), 2)}


def base_exp_yields(reference):
    table = (reference / "data/BaseExperienceTable.c").read_text(errors="replace")
    return {m[1]: int(m[2]) for m in re.finditer(r"\[SPECIES_([A-Z0-9_]+)\s*\]\s*=\s*(\d+)", table)}


def machine_moves(reference):
    learnsets = json.loads((reference / "data/learnsets/learnsets.json").read_text())
    return {name[len("SPECIES_"):]: set(entry.get("MachineMoves", []))
            for name, entry in learnsets.items()}


def machine_numbers():
    """Map each move HGSS has a machine for to its TM or HM number."""
    source = (ROOT / "src/item.c").read_text()
    table = source[source.index("static const u16 sTMHMMoves[] = {"):]
    table = table[:table.index("};")]
    moves = re.findall(r"(MOVE_[A-Z0-9_]+),", table)
    tms = {move: number for number, move in enumerate(moves[:92], start=1)}
    hms = {move: number for number, move in enumerate(moves[92:], start=1)}
    return tms, hms


def field(block, name, pattern=r"([A-Z0-9_]+|-?\d+)"):
    match = re.search(r"\." + name + r"\s*=\s*" + pattern, block)
    if match is None:
        raise ValueError(f"field {name} not found")
    return match.group(1)


def pair(block, name):
    match = re.search(r"\." + name + r"\s*=\s*\{\s*([A-Z0-9_]+)\s*,\s*([A-Z0-9_]+)\s*\}", block)
    if match is None:
        raise ValueError(f"pair {name} not found")
    return [match.group(1), match.group(2)]


def section(block, name):
    start = block.index("." + name + " = {")
    depth, end = 0, start + len("." + name + " = ")
    while True:
        depth += (block[end] == "{") - (block[end] == "}")
        end += 1
        if depth == 0:
            return block[start:end]


def record(name, block, expYield, learned, tms, hms):
    stats = section(block, "baseStats")
    yields = section(block, "evYields")
    items = section(block, "wildHeldItems")
    try:
        genderRatio = gender_fraction(int(field(block, "genderRatio")))
    except ValueError as error:
        raise ValueError(f"{name}: {error}") from error
    return {
        "species": name,
        "hp": int(field(stats, "hp")),
        "atk": int(field(stats, "attack")),
        "def": int(field(stats, "defense")),
        "speed": int(field(stats, "speed")),
        "spatk": int(field(stats, "spAttack")),
        "spdef": int(field(stats, "spDefense")),
        "types": [native(name) for name in pair(block, "types")],
        "catchRate": int(field(block, "catchRate")),
        "expYield": min(expYield, MAX_STORED_EXP_YIELD),
        "expYieldFull": expYield,
        "hp_yield": int(field(yields, "hp")),
        "atk_yield": int(field(yields, "attack")),
        "def_yield": int(field(yields, "defense")),
        "speed_yield": int(field(yields, "speed")),
        "spatk_yield": int(field(yields, "spAttack")),
        "spdef_yield": int(field(yields, "spDefense")),
        "items": [native(field(items, "common")), native(field(items, "rare"))],
        "genderRatio": genderRatio,
        "eggCycles": int(field(block, "hatchCycles")),
        "friendship": int(field(block, "baseFriendship")),
        "growthRate": field(block, "expRate")[len("GROWTH_"):],
        "eggGroups": pair(block, "eggGroups"),
        "abilities": [native(name) for name in pair(block, "abilities")],
        "greatMarshRate": int(field(block, "safariFleeRate")),
        "color": COLORS[field(block, "bodyColor")],
        "flip": int(field(block, "flipSprite")),
        "tms": sorted(tms[move] for move in learned if move in tms),
        "hms": sorted(hms[move] for move in learned if move in hms),
    }


COLORS = {f"BODY_COLOR_{name}": number for number, name in enumerate(
    "RED BLUE YELLOW GREEN BLACK BROWN PURPLE GRAY WHITE PINK EGG".split())}


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("reference", type=Path)
    parser.add_argument("--write", action="store_true")
    args = parser.parse_args()

    blocks = species_entries(args.reference)
    yields = base_exp_yields(args.reference)
    learnsets = machine_moves(args.reference)
    tms, hms = machine_numbers()

    personalPath = ROOT / "files/poketool/personal/personal.json"
    personal = json.loads(personalPath.read_text())
    existing = {entry["species"] for entry in personal["baseStats"]}

    added, clamped = [], []
    for name in NEW_SPECIES:
        if name in existing:
            continue
        entry = record(name, blocks[name], yields[name], learnsets.get(name, set()), tms, hms)
        if yields[name] > MAX_STORED_EXP_YIELD:
            clamped.append((name, yields[name]))
        added.append(entry)

    first = len(personal["baseStats"])
    print(f"{len(added)} species to append, identifiers {first} to {first + len(added) - 1}")
    if clamped:
        print("yields that do not fit the record's byte, stored as 255:",
              ", ".join(f"{name} {value}" for name, value in clamped))

    constants = "\n".join(f"#define SPECIES_{name:<15} {first + i}"
                          for i, name in enumerate(n["species"] for n in added))
    if not args.write:
        print(constants)
        return

    personal["baseStats"].extend(added)
    personalPath.write_text(json.dumps(personal, indent=2) + "\n")
    print(f"wrote {personalPath.relative_to(ROOT)}")
    print(constants)


if __name__ == "__main__":
    main()
