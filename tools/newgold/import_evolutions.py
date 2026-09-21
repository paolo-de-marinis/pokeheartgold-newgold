#!/usr/bin/env python3
"""Add the new species' evolutions to files/poketool/personal/evo.json.

Only evolutions this repository can already express are written: an evolution
needing a method, item or move HGSS does not have yet is reported and left out,
so nothing silently evolves into the wrong thing.

Usage: import_evolutions.py REFERENCE_CHECKOUT [--write]
"""

import argparse
import json
import re
from pathlib import Path

ROOT = Path(__file__).resolve().parents[2]
EVOLUTIONS = ROOT / "files/poketool/personal/evo.json"

import import_species  # noqa: E402


def constants(path, prefix):
    return set(re.findall(r"\b(" + prefix + r"[A-Z0-9_]+)", (ROOT / path).read_text()))


def reference_table(reference):
    source = (reference / "data/Evolutions.c").read_text(errors="replace")
    blocks = re.split(r"\n    \[(SPECIES_[A-Z0-9_]+)\] = \{", source)
    return {blocks[i]: blocks[i + 1] for i in range(1, len(blocks), 2)}


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("reference", type=Path)
    parser.add_argument("--write", action="store_true")
    args = parser.parse_args()

    methods = constants("include/constants/pokemon.h", "EVO_")
    species = constants("include/constants/species.h", "SPECIES_")
    moves = constants("include/constants/moves.h", "MOVE_")
    items = constants("include/constants/items.h", "ITEM_")
    types = constants("include/constants/pokemon.h", "TYPE_")
    known = methods | species | moves | items | types

    table = reference_table(args.reference)
    evolutions = json.loads(EVOLUTIONS.read_text())
    already = {entry["baseSpecies"] for entry in evolutions["evoTable"]}
    wanted = {"SPECIES_" + name for name in import_species.added_species()}

    added, skipped = [], []
    for base, body in table.items():
        rows = re.findall(r"\{\s*(EVO_[A-Z0-9_]+)\s*,\s*([^,]+?)\s*,\s*(SPECIES_[A-Z0-9_]+)\s*\}", body)
        rows = [(method, param, target) for method, param, target in rows if target != "SPECIES_NONE"]
        # Only lines that touch a new species: either it evolves, or something
        # already here gains a way to become one.
        rows = [row for row in rows if base in wanted or row[2] in wanted]
        if not rows:
            continue

        if base not in known:
            # A form the reference splits out that this repository does not
            # define, such as Pumpkaboo's sizes.
            skipped.append((base, [("base species not defined", "", "", [base])]))
            continue

        usable, missing = [], []
        for method, param, target in rows:
            needed = [method, target] + ([param] if not param.lstrip("-").isdigit() else [])
            absent = [name for name in needed if name not in known]
            if absent:
                missing.append((method, param, target, absent))
                continue
            usable.append({"method": method, "param": param, "target": target})

        if missing:
            skipped.append((base, missing))
        if not usable:
            continue
        if base in already:
            skipped.append((base, [("already listed", "", "", [])]))
            continue
        added.append({"baseSpecies": base, "evos": usable})

    print(f"{len(added)} species gain evolutions")
    for base, missing in skipped:
        for method, param, target, absent in missing:
            detail = ", ".join(absent) if absent else "the table already lists it"
            print(f"  left out {base} -> {target or '?'} ({method}): {detail}")

    if not args.write:
        return
    evolutions["evoTable"].extend(added)
    EVOLUTIONS.write_text(json.dumps(evolutions, indent=2) + "\n")
    print(f"wrote {EVOLUTIONS.relative_to(ROOT)} with {len(evolutions['evoTable'])} entries")


if __name__ == "__main__":
    main()
