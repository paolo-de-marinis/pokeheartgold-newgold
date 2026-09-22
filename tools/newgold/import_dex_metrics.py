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

    import_dex_metrics.py REFERENCE [--write]
"""
import argparse
import json
import re
from pathlib import Path

ROOT = Path(__file__).resolve().parents[2]
DATA = ROOT / "files/application/zukanlist/zkn_data/zukan_data.json"
SPECIES_H = ROOT / "include/constants/species.h"

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
    if args.write:
        DATA.write_text(json.dumps(data, indent=2) + "\n")
        print("written")
    else:
        print("nothing written; pass --write")


if __name__ == "__main__":
    main()
