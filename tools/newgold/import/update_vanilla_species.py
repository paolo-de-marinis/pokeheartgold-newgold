#!/usr/bin/env python3
"""Bring the personal records of HGSS's own species up to New Gold's values.

New Gold does not only add species: it rebalances the ones already there, with
the later generations' stats, types, abilities, wild held items, base
friendship and experience yields. Those records are regenerated here from the
same reference the new species came from, into the same table.

The species' names, identifiers and order are untouched; only their contents
change, and only where the reference differs.

Usage: update_vanilla_species.py REFERENCE_CHECKOUT [--write] [--field NAME]
"""

import argparse
import collections
import json
from pathlib import Path

ROOT = Path(__file__).resolve().parents[3]
PERSONAL = ROOT / "files/poketool/personal/personal.json"

import import_species  # noqa: E402

# HGSS's own species, leaving the egg, the bad egg and the alternate forms
# alone: those records are not species and the reference does not describe them.
LAST_VANILLA = 493


def pending(reference):
    """What --write would change: the personal table, each species whose
    record differs as (index, the record it would get, the fields that
    differ), and the species left alone."""
    blocks = import_species.species_entries(reference)
    yields = import_species.base_exp_yields(reference)
    learnsets = import_species.machine_moves(reference)
    tms, hms = import_species.machine_numbers()
    machine_list = import_species.reference_machine_list(reference)

    personal = json.loads(PERSONAL.read_text())
    records = personal["baseStats"]
    updates, skipped = [], []

    for index in range(1, LAST_VANILLA + 1):
        record = records[index]
        name = record["species"]
        if name not in blocks:
            skipped.append(name)
            continue
        # The hidden ability is not in the reference's species block but in
        # a table of its own, which import_hidden_abilities.py writes; the
        # record's is passed through, or --write would reset 451 of them.
        try:
            wanted = import_species.record(
                name, blocks[name], yields.get(name, record["expYieldFull"]),
                learnsets.get(name, set()), tms, hms, machine_list, record["hiddenAbility"])
        except ValueError as error:
            skipped.append(f"{name} ({error})")
            continue

        differing = [key for key in record if record[key] != wanted[key]]
        if differing:
            updates.append((index, wanted, differing))
    return personal, updates, skipped


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("reference", type=Path)
    parser.add_argument("--write", action="store_true")
    parser.add_argument("--field", help="show every species that changes in one field")
    args = parser.parse_args()

    personal, updates, skipped = pending(args.reference)
    changes = collections.Counter()
    listed = collections.defaultdict(list)
    for index, wanted, differing in updates:
        for key in differing:
            changes[key] += 1
            listed[key].append(wanted["species"])
        if args.write:
            personal["baseStats"][index] = wanted

    print(f"{len(updates)} of {LAST_VANILLA} species change")
    for key, count in changes.most_common():
        print(f"  {key}: {count}")
    if skipped:
        print(f"left alone: {', '.join(skipped)}")
    if args.field:
        print(f"\n{args.field}: {', '.join(listed[args.field])}")

    if not args.write:
        print("\nnothing written; pass --write")
        return
    PERSONAL.write_text(json.dumps(personal, indent=2) + "\n")
    print(f"\nwrote {PERSONAL.relative_to(ROOT)}")


if __name__ == "__main__":
    main()
