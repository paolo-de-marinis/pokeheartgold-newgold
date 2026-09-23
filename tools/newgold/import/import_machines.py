#!/usr/bin/env python3
"""Write every species' machines past HM08 into the personal table.

hg-engine numbers 340 machines (sMachineMoves in its src/item.c): HeartGold's
TM01 to HM08 first, then the later games' TMs, HM07 (Dive), TM00 and the TRs.
Its build sets a species' bit for a machine when the machine's move is in the
species' MachineMoves or LevelMoves (scripts/build_learnsets.py,
write_machine_data), a form with no list of its own reading its base's. The
first 100 are the records' "tms" and "hms"; this writes the rest as
"machines", the places past 99 in that numbering, which the template packs
into the record's machine words.

HeartGold's own alternate forms (496 to 507) have their learnsets under their
number in the reference. The reference has no learnset for 500, Trash Cloak
Wormadam, so it can be taught no machine past HM08 there either.

Usage: import_machines.py REFERENCE_CHECKOUT [--write]
"""

import argparse
import json
from pathlib import Path

import import_species

ROOT = Path(__file__).resolve().parents[3]
PERSONAL = ROOT / "files/poketool/personal/personal.json"
# The block pret numbers after Arceus: the egg, the bad egg and the forms.
NUMBERED_FORMS = range(496, 508)


def wanted(reference, records):
    learnsets = import_species.machine_moves(reference)
    machine_list = import_species.reference_machine_list(reference)
    result = []
    for index, record in enumerate(records):
        name = str(index) if index in NUMBERED_FORMS else record["species"]
        result.append(import_species.machines_past_hm08(learnsets.get(name, set()), machine_list))
    return result


def with_machines(record, machines):
    """The record with its machines after its HMs, where the importer puts them."""
    out = {}
    for key, value in record.items():
        if key != "machines":
            out[key] = value
        if key == "hms":
            out["machines"] = machines
    return out


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("reference", type=Path)
    parser.add_argument("--write", action="store_true")
    args = parser.parse_args()

    personal = json.loads(PERSONAL.read_text())
    records = personal["baseStats"]
    machines = wanted(args.reference, records)
    changed = [record["species"] for record, want in zip(records, machines) if record.get("machines") != want]
    print(f"{len(changed)} records change, {sum(map(len, machines))} compatibilities in all: "
          + ", ".join(changed[:8]) + (" ..." if len(changed) > 8 else ""))
    if not args.write:
        print("nothing written; pass --write")
        return
    personal["baseStats"] = [with_machines(record, want) for record, want in zip(records, machines)]
    PERSONAL.write_text(json.dumps(personal, indent=2) + "\n")
    print(f"wrote {PERSONAL.relative_to(ROOT)}")


if __name__ == "__main__":
    main()
