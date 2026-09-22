#!/usr/bin/env python3
"""Give every species a move tutor entry.

fielddata/wazaoshie/waza_oshie.bin holds one record a species -- eight bytes,
a bit for each of the fifty-two moves this game's tutors teach -- with the egg
and the bad egg left out, and the game checks its length against NUM_SPECIES
before reading. The file was retail's 505 records while the species ran to
1437, so that check failed and the tutor asserted for everyone.

The added species get the moves the reference's own tutor list gives them,
kept to the fifty-two this game teaches; a form takes its base species' list.

Usage: import_tutor_moves.py REFERENCE_CHECKOUT [--write]
"""

import argparse
import json
import re
from pathlib import Path

ROOT = Path(__file__).resolve().parents[3]
TUTOR = ROOT / "files/fielddata/wazaoshie/waza_oshie.json"

import import_species  # noqa: E402


def tutor_slots():
    return {m.group(1) for m in re.finditer(r"#define TUTOR_([A-Z0-9_]+)\s+\d+",
                                            (ROOT / "include/constants/moves.h").read_text())}


def species_numbers():
    return {m.group(1): int(m.group(2)) for m in
            re.finditer(r"#define SPECIES_([A-Z0-9_]+)\s+(\d+)", (ROOT / "include/constants/species.h").read_text())}


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("reference", type=Path)
    parser.add_argument("--write", action="store_true")
    args = parser.parse_args()

    slots = tutor_slots()
    numbers = species_numbers()
    theirs = json.loads((args.reference / "data/learnsets/learnsets.json").read_text())
    bases = import_species.base_species_of(args.reference)
    entries = json.loads(TUTOR.read_text())["tutor"]
    # The records are dense from Bulbasaur with the two eggs left out, so a
    # species sits at its own number minus however many of them are below it.
    kept = [entry for entry in entries if not entry["mon"].startswith("SPECIES_" + "UNUSED")]
    written = {entry["mon"] for entry in kept}

    added = []
    for name in import_species.added_species():
        full = "SPECIES_" + name
        if full in written:
            continue
        source = theirs.get(full) or theirs.get("SPECIES_" + bases.get(name, ""), {})
        moves = sorted("TUTOR_" + move[len("MOVE_"):] for move in source.get("TutorMoves", [])
                       if move[len("MOVE_"):] in slots)
        added.append({"mon": full, "moves": moves})

    taught = sum(1 for entry in added if entry["moves"])
    print(f"{len(kept)} records now, {len(added)} to add; {taught} of the added species "
          f"can be taught something, {len(added) - taught} nothing")
    if not args.write:
        print("nothing written; pass --write")
        return
    TUTOR.write_text(json.dumps({"tutor": kept + added}, indent=2) + "\n")
    print(f"wrote {TUTOR.relative_to(ROOT)} with {len(kept) + len(added)} records")


if __name__ == "__main__":
    main()
