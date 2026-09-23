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
import subprocess
from pathlib import Path

ROOT = Path(__file__).resolve().parents[3]

# Every species the reference defines that this repository has not got, in
# National Dex order.
#
# This used to be a list of sixty-seven, closed over the evolution table from
# what New Gold's own trainers and encounters reach. That was the right list
# while the rule was "implement only what the game reaches". It is not any
# more: konefr develops New Gold on this repository now, so the platform has
# to carry what he could reach, not what he reaches today -- he must be able
# to open Trainers.c and put any Pokemon in it without asking for an import.
# See docs/newgold/SCOPE.md.
#
# The reference numbers a species by its National Dex number below 494, and by
# that number plus fifty above it, with the fifty in between given to forms.
# The base species are therefore ids 1 to 493 and 544 to 1075, and the ones
# missing here are added in that order so a later import is stable.
FORM_BLOCK = range(494, 544)
LAST_BASE = 1075


def reference_species(reference):
    """Every base species the reference defines, in its own order."""
    header = (reference / "include/constants/species.h").read_text()
    numbered = sorted((int(number), name) for name, number in
                      re.findall(r"#define SPECIES_([A-Z0-9_]+)\s+(\d+)", header))
    return [name for number, name in numbered
            if number not in FORM_BLOCK and 1 <= number <= LAST_BASE]


def added_species():
    """The species this repository has that HeartGold did not.

    Everything past the form block: the egg, the bad egg and the alternate
    forms sit between Arceus and the first added species, and LAST_DEX_GAP
    names the last of them.
    """
    header = (ROOT / "include/constants/species.h").read_text()
    numbered = {name: int(number) for name, number in
                re.findall(r"#define SPECIES_([A-Z0-9_]+)\s+(\d+)", header)}
    last_gap = re.search(r"#define LAST_DEX_GAP\s+SPECIES_([A-Z0-9_]+)", header).group(1)
    after = numbered[last_gap]
    return [name for name, number in sorted(numbered.items(), key=lambda kv: kv[1])
            if number > after]


def reference_forms(reference):
    """The reference's forms, in its own order, as species names.

    Past SPECIES_MEGA_START the reference numbers every mega, regional,
    Gigantamax and other form as a species of its own, by an expression on a
    marker (SPECIES_MEGA_START + 1); its own preprocessor says what each one
    comes to. Only a form with a personal block in Species.c and pictures is
    a species: the overworld-only variants (a female Venusaur, Unown's
    letters) have neither and are skipped.
    """
    header = (reference / "include/constants/species.h").read_text()
    names = re.findall(r"^#define SPECIES_([A-Z0-9_]+)\s+\(", header, re.M)
    source = '#include "constants/species.h"\n' + "\n".join(f"SPECIES_{n} X_{n}" for n in names)
    out = subprocess.run(["cpp", "-P", "-I", str(reference / "include"), "-"],
                         input=source, capture_output=True, text=True, check=True).stdout
    numbered = []
    for m in re.finditer(r"^(.+?) X_([A-Z0-9_]+)$", out, re.M):
        expression = m.group(1).strip()
        if re.fullmatch(r"[\d\s()+*-]+", expression):
            numbered.append((eval(expression), m.group(2)))  # digits and arithmetic only
    blocks = species_entries(reference)
    sprites = reference / "data/graphics/sprites"
    bases = base_species_of(reference)
    # A real form has a base species in the reference's own table; the
    # filler slots it keeps in a range have a block and no base.
    return [name for number, name in sorted(set(numbered))
            if name in blocks and name in bases and (sprites / name.lower()).is_dir()]


def base_species_of(reference):
    """Each form's base species, from the reference's own table."""
    table = (reference / "data/FormToSpeciesMapping.c").read_text(errors="replace")
    return dict(re.findall(r"\[SPECIES_([A-Z0-9_]+) - SPECIES_MEGA_START\]\s*=\s*SPECIES_([A-Z0-9_]+)", table))


def species_to_add(reference):
    """Those of them this repository has not got yet: the base species first,
    then the forms, each in the reference's order."""
    have = set(re.findall(r"#define SPECIES_([A-Z0-9_]+)",
                          (ROOT / "include/constants/species.h").read_text()))
    return [name for name in reference_species(reference) + reference_forms(reference) if name not in have]

# GENDER_RATIO(frac) stores (u8)(frac * 254.75), and a fraction above one means
# genderless. Every ratio the games use is a multiple of an eighth, so the
# fraction is recovered by rounding and then checked against the stored byte.
def gender_fraction(stored):
    if stored == 255:
        return 2.0
    fraction = round(stored / 254.75 * 8) / 8
    # The reference stores 190 where this repository's arithmetic gives 191 for
    # the same three-quarters, so a byte either side counts as a match.
    if abs(int(fraction * 254.75) - stored) > 1:
        raise ValueError(f"gender ratio byte {stored} is not a multiple of an eighth")
    return fraction

# The original field is a byte; the full value lives beside it in what Gen 4
# left as padding, so nothing is lost and nothing shifts.
MAX_STORED_EXP_YIELD = 255

# Constants this repository spells differently from the reference, or that the
# later games renamed.
ALIASES = {
    "ABILITY_COMPOUND_EYES": "ABILITY_COMPOUNDEYES",
    "ABILITY_LIGHTNING_ROD": "ABILITY_LIGHTNINGROD",
    "ITEM_TINY_MUSHROOM": "ITEM_TINYMUSHROOM",
    "ITEM_BRIGHT_POWDER": "ITEM_BRIGHTPOWDER",
    "ITEM_NEVER_MELT_ICE": "ITEM_NEVERMELTICE",
    "ITEM_DEEP_SEA_SCALE": "ITEM_DEEPSEASCALE",
    "ITEM_DEEP_SEA_TOOTH": "ITEM_DEEPSEATOOTH",
    "ITEM_SILVER_POWDER": "ITEM_SILVERPOWDER",
    "ITEM_TWISTED_SPOON": "ITEM_TWISTEDSPOON",
    "ITEM_UP_GRADE": "ITEM_UPGRADE",
    "ITEM_LEEK": "ITEM_STICK",
}


def known_items():
    return set(re.findall(r"#define (ITEM_[A-Z0-9_]+)",
                          (ROOT / "include/constants/items.h").read_text()))


def native_item(name, known, dropped):
    """The item under this repository's spelling, or nothing.

    The reference spells a few items with an underscore this game does not
    (ITEM_BLACK_GLASSES against ITEM_BLACKGLASSES). A wild held item that does
    not exist here is recorded as none rather than invented, and reported --
    though since the six that were missing were added, none of them is.
    """
    if name in known:
        return name
    squashed = {item.replace("_", ""): item for item in known}
    found = squashed.get(name.replace("_", ""))
    if found:
        return found
    dropped.add(name)
    return "ITEM_NONE"


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


def reference_machines(reference):
    """The moves the reference has a machine for: TM01 to HM08 as here, then
    the later games' TMs and TRs, which have no machine in this game."""
    source = (reference / "src/item.c").read_text(errors="replace")
    table = source[source.index("sMachineMoves[] = {"):]
    return set(re.findall(r"MOVE_[A-Z0-9_]+", table[:table.index("};")]))


def machine_moves(reference, level_up=True):
    """Each species' machine moves, by the reference's rule (hg-engine's
    scripts/build_learnsets.py, write_machine_data): a species can be taught a
    machine's move if its MachineMoves list names it or it learns it by
    level-up. A form with no list of its own takes its base species' -- the
    reference reads the base's for it -- so 324 forms do not come out unable
    to learn any TM. level_up=False leaves the level-up half out."""
    learnsets = json.loads((reference / "data/learnsets/learnsets.json").read_text())
    bases = base_species_of(reference)

    def listed(name, key):
        found = learnsets.get("SPECIES_" + name, {}).get(key, [])
        if not found and name in bases:
            found = learnsets.get("SPECIES_" + bases[name], {}).get(key, [])
        return found

    machines = reference_machines(reference)
    moves = {}
    for name in {key[len("SPECIES_"):] for key in learnsets} | set(bases):
        taught = set(listed(name, "MachineMoves"))
        if level_up:
            taught |= {entry["Move"] for entry in listed(name, "LevelMoves") if "Move" in entry}
        moves[name] = taught & machines
    return moves


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


def hidden_abilities(reference):
    """The reference keeps these in a table of their own rather than in the
    species record, because nothing picks one by personality: it is given only
    when something asks for it by name."""
    source = (reference / "data/HiddenAbilityTable.c").read_text(errors="replace")
    return {m[1]: native(m[2]) for m in
            re.finditer(r"\[\s*(SPECIES_[A-Z0-9_]+)\s*\]\s*=\s*(ABILITY_[A-Z0-9_]+)", source)}


def record(name, block, expYield, learned, tms, hms, hidden="ABILITY_NONE"):
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
        "items": [native_item(native(field(items, "common")), known_items(), set()),
                  native_item(native(field(items, "rare")), known_items(), set())],
        "genderRatio": genderRatio,
        "eggCycles": int(field(block, "hatchCycles")),
        "friendship": int(field(block, "baseFriendship")),
        "growthRate": field(block, "expRate")[len("GROWTH_"):],
        "eggGroups": pair(block, "eggGroups"),
        "abilities": [native(name) for name in pair(block, "abilities")],
        "hiddenAbility": hidden,
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
    # A form the reference gives no yield of its own inherits its base's.
    bases = base_species_of(args.reference)
    for form, base in bases.items():
        yields.setdefault(form, yields.get(base, 0))
    learnsets = machine_moves(args.reference)
    tms, hms = machine_numbers()

    personalPath = ROOT / "files/poketool/personal/personal.json"
    personal = json.loads(personalPath.read_text())
    existing = {entry["species"] for entry in personal["baseStats"]}

    wanted = species_to_add(args.reference)
    wanted_all = set(added_species())
    added, clamped, absent = [], [], []
    for name in wanted:
        if name in existing:
            continue
        if name not in blocks:
            absent.append(name)
            continue
        entry = record(name, blocks[name], yields.get(name, 0), learnsets.get(name, set()), tms, hms)
        if yields.get(name, 0) > MAX_STORED_EXP_YIELD:
            clamped.append((name, yields[name]))
        added.append(entry)
    if absent:
        print(f"{len(absent)} named in the reference's header with no block in "
              f"Species.c, left alone: {', '.join(absent[:6])}"
              + (" ..." if len(absent) > 6 else ""))

    # The records already written keep everything but their machine moves,
    # which follow the rule above: a second run brings them up to date.
    refreshed = 0
    for entry in personal["baseStats"]:
        name = entry["species"]
        if name in wanted_all and name in learnsets:
            fresh = sorted(tms[m] for m in learnsets[name] if m in tms), sorted(hms[m] for m in learnsets[name] if m in hms)
            if (entry["tms"], entry["hms"]) != fresh:
                entry["tms"], entry["hms"] = fresh
                refreshed += 1
    print(f"{refreshed} records already written take new machine moves")

    # This game has TM01 to HM08 only; the reference's other machines have no
    # item here, so a species' compatibility with them has nowhere to go.
    dropped = {name: learnsets.get(name, set()) - tms.keys() - hms.keys() for name in wanted_all}
    past = sorted(set().union(*dropped.values()))
    print(f"{sum(map(len, dropped.values()))} machine compatibilities dropped from "
          f"{sum(1 for moves in dropped.values() if moves)} species, {len(past)} moves "
          f"with no machine past HM08: {', '.join(past[:6])}" + (" ..." if len(past) > 6 else ""))

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
    if added:
        # The constants go in ahead of NUM_SPECIES, which then names the last.
        headerPath = ROOT / "include/constants/species.h"
        header = headerPath.read_text()
        last = added[-1]["species"]
        header = re.sub(r"\n#define NUM_SPECIES SPECIES_[A-Z0-9_]+\n",
                        "\n" + constants + f"\n\n#define NUM_SPECIES SPECIES_{last}\n", header, count=1)
        headerPath.write_text(header)
        print(f"wrote {headerPath.relative_to(ROOT)}: NUM_SPECIES is SPECIES_{last}")
    print(constants)


if __name__ == "__main__":
    main()
