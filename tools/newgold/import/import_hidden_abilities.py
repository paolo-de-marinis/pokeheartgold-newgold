#!/usr/bin/env python3
"""Give every species its hidden ability.

The reference keeps these in a table of their own rather than in the species
record, because nothing picks one by personality: a Pokemon is only given one
when something asks for it by name, which here means a trainer's roster.

An ability this game does not have is reported and the species is left with
none, rather than being given a number nothing reads.

Usage: import_hidden_abilities.py REFERENCE_CHECKOUT [--write]
"""

import argparse
import collections
import json
import re
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[3]
PERSONAL = ROOT / "files/poketool/personal/personal.json"

sys.path.insert(0, str(Path(__file__).resolve().parent))
import import_species  # noqa: E402


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("reference", type=Path)
    parser.add_argument("--write", action="store_true")
    args = parser.parse_args()

    known = set(re.findall(r"#define (ABILITY_[A-Z0-9_]+)",
                           (ROOT / "include/constants/abilities.h").read_text()))
    table = import_species.hidden_abilities(args.reference)
    for form, base in import_species.base_species_of(args.reference).items():
        table.setdefault("SPECIES_" + form, table.get("SPECIES_" + base, "ABILITY_NONE"))
    data = json.loads(PERSONAL.read_text())

    given, missing = 0, collections.Counter()
    for entry in data["baseStats"]:
        wanted = table.get("SPECIES_" + entry["species"], "ABILITY_NONE")
        if wanted not in known:
            missing[wanted] += 1
            wanted = "ABILITY_NONE"
        if entry.get("hiddenAbility") != wanted:
            entry["hiddenAbility"] = wanted
            if wanted != "ABILITY_NONE":
                given += 1

    have = sum(1 for e in data["baseStats"] if e.get("hiddenAbility", "ABILITY_NONE") != "ABILITY_NONE")
    print(f"{given} records change; {have} of {len(data['baseStats'])} species end up with one")
    for name, count in missing.most_common(8):
        print(f"  {count:4} species want {name}, which this game has not got")
    if len(missing) > 8:
        print(f"  ... and {len(missing) - 8} more abilities")

    if not args.write:
        print("nothing written; pass --write")
        return
    PERSONAL.write_text(json.dumps(data, indent=2) + "\n")
    print(f"wrote {PERSONAL.relative_to(ROOT)}")


if __name__ == "__main__":
    main()
