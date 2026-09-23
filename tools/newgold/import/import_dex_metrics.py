#!/usr/bin/env python3
"""Carry every species' height, weight and scale out of the reference.

zukan_data.json stopped at Arceus: 494 entries, one a species from 0 to 493,
and three places index those tables by species with no bound -- the Heavy
Ball's weight, the link rulesets, and PokedexData_GetWeight, which fills
battleMons[].weight for every battler in every battle and feeds Low Kick,
Grass Knot and Autotomize. For a species past 493 all three read off the end
of the allocation. Nothing crashes; a Low Kick simply does the wrong damage.

The data was always there. Every species in the reference's data/Species.c
carries a metricsData with exactly the fields of an entry here.

The sort lists the Dex builds its list from stopped at Arceus too, so the
Dex listed no added species. They are written here from this tree's own data,
for every Dex species: the National Dex order (the reference's numbering),
the name order (the species names, as retail sorts them), the four size
orders from the entries above, the first letters and the letter groups, and
the seventeen types the search offers, from the reference's types. The
fourteen body styles keep HeartGold's species, as the reference has none
for the others. The Johto order is retail's and stays. And the Dex's area
filter reads one byte per species (zukan_hw_data_1, retail's 494); an added
species is "area unknown" there, as its area page has no map.

    import_dex_metrics.py REFERENCE [--write]
"""
import argparse
import json
import re
from pathlib import Path

import gmm
from import_species import national_numbers

ROOT = Path(__file__).resolve().parents[3]
DATA = ROOT / "files/application/zukanlist/zkn_data/zukan_data.json"
SPECIES_H = ROOT / "include/constants/species.h"
PERSONAL = ROOT / "files/poketool/personal/personal.json"
AREA_FLAGS = ROOT / "files/application/zukanlist/zkn_data/zukan_hw_data"
SPECIES_NAMES = 237
# The search's area flags: 1 Johto, 2 Kanto, 4 unknown, 8 any.
AREA_UNKNOWN = 8 | 4
RETAIL_LAST = 493  # Arceus

# entry field  <-  reference field
FIELDS = {
    "height": "heightDecimetres",
    "weight": "weightHectograms",
    "body_style": "bodyType",
    "scale_f": "femaleTrainerScale",
    "mon_scale_f": "femalePokemonScale",
    "scale_m": "maleTrainerScale",
    "mon_scale_m": "malePokemonScale",
    "ypos_f": "femaleTrainerYOffset",
    "mon_ypos_f": "femalePokemonYOffset",
    "ypos_m": "maleTrainerYOffset",
    "mon_ypos_m": "malePokemonYOffset",
}


def species_numbers(path):
    return {name: int(number) for name, number in
            re.findall(r"^#define SPECIES_([A-Z0-9_]+)\s+(\d+)\s*$", path.read_text(errors="replace"), re.M)}


def body_styles(reference):
    """DEX_SEARCH_BODYTYPE_* is a name in the reference and a number here."""
    header = (reference / "include/constants/pokedex.h")
    if not header.exists():
        header = next((reference / "include").rglob("*.h"))
    text = "\n".join(p.read_text(errors="replace") for p in (reference / "include").rglob("*.h"))
    return {name: int(value) for name, value in
            re.findall(r"^#define\s+DEX_SEARCH_BODYTYPE_([A-Z0-9_]+)\s+(\d+)", text, re.M)}


def metrics(reference, styles):
    """Every species' metricsData, by name, as the numbers an entry wants."""
    text = (reference / "data/Species.c").read_text(errors="replace")
    out = {}
    for block in re.finditer(r"\[SPECIES_([A-Z0-9_]+)\]\s*=\s*\{(.*?)\n    \},", text, re.S):
        name, body = block.group(1), block.group(2)
        found = re.search(r"metricsData\s*=\s*\{(.*?)\n\s*\}", body, re.S)
        if not found:
            continue
        values = dict(re.findall(r"\.([A-Za-z]+)\s*=\s*([^,\n]+),", found.group(1)))
        entry = {}
        for ours, theirs in FIELDS.items():
            raw = values.get(theirs, "0").strip()
            if raw.startswith("DEX_SEARCH_BODYTYPE_"):
                entry[ours] = styles.get(raw[len("DEX_SEARCH_BODYTYPE_"):], 0)
            else:
                entry[ours] = int(raw, 0)
        out[name] = entry
    return out


def dex_species(numbers, national):
    """Every species with a Dex entry of its own, by identifier: HeartGold's
    and the ones after the gap, but not the two Galarian forms kept as
    species, which share Slowpoke's and Slowbro's numbers."""
    header = SPECIES_H.read_text(errors="replace")
    edge = {name: numbers[re.search(rf"#define {name}\s+SPECIES_([A-Z0-9_]+)", header).group(1)]
            for name in ("FIRST_DEX_GAP", "LAST_DEX_GAP", "LAST_DEX_SPECIES")}
    names = {number: name for name, number in numbers.items()}
    out = []
    for number in range(1, edge["LAST_DEX_SPECIES"] + 1):
        if edge["FIRST_DEX_GAP"] <= number <= edge["LAST_DEX_GAP"]:
            continue
        if number > edge["LAST_DEX_GAP"] and national[names[number]] <= RETAIL_LAST:
            continue  # a form kept as a species: its number is its base's
        out.append(number)
    return out


def variants(value):
    """A stat as the two archives take it: Giratina's may differ by form."""
    return (value["altered"], value["origin"]) if isinstance(value, dict) else (value, value)


def reference_types(reference, numbers):
    """Each species' two types, as the reference's data/Species.c gives them:
    the type lists follow the tree they are written from, so the engine's
    and New Gold's (whose rebalance retypes a few species) each have their
    own. A species the reference does not type keeps this tree's."""
    personal = json.loads(PERSONAL.read_text())["baseStats"]
    out = [set(entry["types"]) for entry in personal]
    text = (reference / "data/Species.c").read_text(errors="replace")
    for block in re.finditer(r"\[SPECIES_([A-Z0-9_]+)\]\s*=\s*\{(.*?)\n    \},", text, re.S):
        found = re.search(r"\.types\s*=\s*\{\s*(TYPE_\w+)\s*,\s*(TYPE_\w+)\s*\}", block.group(2))
        if found and block.group(1) in numbers and numbers[block.group(1)] < len(out):
            out[numbers[block.group(1)]] = set(found.groups())
    return out


def sort_lists(data, numbers, national, types):
    """The sort lists, as zukan_data.json's "sorting" has them, for every Dex
    species."""
    names = {number: name for name, number in numbers.items()}
    shown = {row["index"]: row["text"] for row in gmm.read(SPECIES_NAMES)}
    stats = data["mon_stats"]
    species = dex_species(numbers, national)
    number = {s: national.get(names[s], s) for s in species}
    by_number = sorted(species, key=lambda s: number[s])
    by_name = sorted(species, key=lambda s: shown[s].upper())

    def constant(s):
        return f"SPECIES_{names[s]}"

    def listed(order):
        return [constant(s) for s in order]

    def sized(field, descending):
        orders = []
        for variant in (0, 1):
            orders.append(listed(sorted(species, key=lambda s: (
                -variants(stats[s][field])[variant] if descending else variants(stats[s][field])[variant], number[s]))))
        return orders[0] if orders[0] == orders[1] else {"altered": orders[0], "origin": orders[1]}

    # The reference gives every species past Arceus the first body style,
    # quadruped, as a placeholder (data/Species.c, bodyType), so only
    # HeartGold's own species have a body style to be searched by: an added
    # species is listed under none rather than under the wrong one.
    shaped = [s for s in by_number if s <= RETAIL_LAST]

    def styled(style):
        orders = [listed([s for s in shaped if variants(stats[s]["body_style"])[variant] == style]) for variant in (0, 1)]
        return orders[0] if orders[0] == orders[1] else {"altered": orders[0], "origin": orders[1]}

    out = []
    for group in data["sorting"]:
        options = []
        for option in group["options"]:
            key, mons = option["id"], option["mons"]
            if group["type"] == "dex_order":
                mons = {"national": listed(by_number), "johto": mons, "alphabetical": listed(by_name),
                        "heaviest": sized("weight", True), "lightest": sized("weight", False),
                        "tallest": sized("height", True), "shortest": sized("height", False)}[key]
            elif group["type"] == "letters":
                mons = [c for c in listed(by_name) if len(key) == 1
                        and shown[numbers[c[len("SPECIES_"):]]].upper().startswith(key.upper())]
            elif group["type"] == "letter_groups":
                mons = [c for c in listed(by_name) if shown[numbers[c[len("SPECIES_"):]]][0].upper() in key.upper()]
            elif group["type"] == "types":
                mons = listed([s for s in by_number if f"TYPE_{key.upper()}" in types[s]])
            elif group["type"] == "body_style":
                mons = styled(len(options))
            options.append({**option, "mons": mons})
        out.append({**group, "options": options})
    return out


def area_flags(numbers):
    """zukan_hw_data_1, one byte of area flags a species, carried to the last
    Dex species: an added species is found nowhere this Dex maps."""
    last = numbers[re.search(r"#define LAST_DEX_SPECIES\s+SPECIES_([A-Z0-9_]+)", SPECIES_H.read_text()).group(1)]
    out = {}
    for path in sorted(AREA_FLAGS.glob("zukan_hw_data_1_*.bin")):
        flags = path.read_bytes()[:RETAIL_LAST + 1]
        out[path] = flags + bytes([AREA_UNKNOWN]) * (last + 1 - len(flags))
    return out


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("reference", type=Path)
    parser.add_argument("--write", action="store_true")
    args = parser.parse_args()

    numbers = species_numbers(SPECIES_H)
    styles = body_styles(args.reference)
    theirs = metrics(args.reference, styles)
    data = json.loads(DATA.read_text())
    rows = data["mon_stats"]

    # The entries are positional: row N is species N, and the file must stay
    # dense because the built tables are indexed by species.
    by_number = {numbers[r["species"][len("SPECIES_"):]]: r
                 for r in rows if r["species"][len("SPECIES_"):] in numbers}
    highest = max(numbers.values())
    added = changed = missing = 0
    for number in range(highest + 1):
        name = next((n for n, v in numbers.items() if v == number), None)
        if name is None:
            continue
        row = by_number.get(number)
        want = theirs.get(name)
        if want is None:
            # A form or a gap the reference does not carry: give it its base
            # species' numbers rather than a hole, the way the Dex text does.
            if row is None:
                missing += 1
            continue
        if row is None:
            by_number[number] = {"species": f"SPECIES_{name}", **want}
            added += 1
        elif any(row.get(k) != v for k, v in want.items()):
            row.update(want)
            changed += 1
    # Anything still absent takes the row before it, so the table is dense.
    filled = []
    previous = None
    for number in range(highest + 1):
        row = by_number.get(number)
        if row is None:
            name = next((n for n, v in numbers.items() if v == number), None)
            row = dict(previous or {})
            row["species"] = f"SPECIES_{name}" if name else f"SPECIES_NONE"
            added += 1
        filled.append(row)
        previous = row
    data["mon_stats"] = filled

    print(f"entries: {len(rows)} -> {len(filled)}")
    print(f"added {added}, updated {changed}, species the reference has no metrics for: {missing}")
    data["sorting"] = sort_lists(data, numbers, national_numbers(args.reference), reference_types(args.reference, numbers))
    national = next(o["mons"] for g in data["sorting"] if g["type"] == "dex_order" for o in g["options"] if o["id"] == "national")
    print(f"sort lists: {len(national)} species in National Dex order")
    flags = area_flags(numbers)
    if args.write:
        DATA.write_text(json.dumps(data, indent=2) + "\n")
        for path, content in flags.items():
            path.write_bytes(content)
        print("written")
    else:
        print("nothing written; pass --write")


if __name__ == "__main__":
    main()
