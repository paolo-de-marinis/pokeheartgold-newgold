#!/usr/bin/env python3
"""Write the egg-move archive, files/fielddata/sodateya/kowaza_list.narc.

Retail's was one list of species markers (species + 20000) each followed by
its moves, 198 species up to Weavile, searched from the start for the egg's
marker. hg-engine replaced it with a fixed table, and this writes that one:
MAX_EGG_MOVES halfwords a species, the list ended by 0xFFFF where it is
shorter, read at species * MAX_EGG_MOVES. MAX_EGG_MOVES is the longest list
plus its terminator, as the reference's build_learnsets.py sets it, and is
written into include/constants/daycare.h.

The lists are the EggMoves of the reference's data/learnsets/learnsets.json
at the engine's revision, by species and move name; konefr's range changes
none of them. A form is a species here and has a record of its own; one the
reference gives no list takes its base's, as the reference's generator does.

Usage: import_egg_moves.py REFERENCE_CHECKOUT [--write]
"""

import argparse
import json
import re
import struct
import subprocess
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[3]
ARCHIVE = ROOT / "files/fielddata/sodateya/kowaza_list.narc"
HEADER = ROOT / "include/constants/daycare.h"

sys.path.insert(0, str(Path(__file__).resolve().parent))
import wotbl  # noqa: E402

ENGINE_REVISION = "d0380a487"
TERMINATOR = 0xFFFF


def show(reference, path):
    return subprocess.run(["git", "-C", str(reference), "show", f"{ENGINE_REVISION}:{path}"],
                          capture_output=True, text=True, check=True).stdout


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("reference", type=Path)
    parser.add_argument("--write", action="store_true")
    args = parser.parse_args()

    learnsets = json.loads(show(args.reference, "data/learnsets/learnsets.json"))
    bases = dict(re.findall(r"\[(SPECIES_[A-Z0-9_]+) - SPECIES_MEGA_START\]\s*=\s*(SPECIES_[A-Z0-9_]+)",
                            show(args.reference, "data/FormToSpeciesMapping.c")))
    width = max(len(entry.get("EggMoves", [])) for entry in learnsets.values()) + 1

    names = wotbl.species_names()
    moves = wotbl.move_names()
    member, listed = b"", 0
    for number in range(max(names) + 1):
        key = "SPECIES_" + names[number]
        wanted = learnsets.get(key, {}).get("EggMoves", [])
        if not wanted and key in bases:
            wanted = learnsets.get(bases[key], {}).get("EggMoves", [])
        missing = [move for move in wanted if move not in moves]
        if missing:
            raise SystemExit(f"{key}: no such move here: {', '.join(missing)}")
        listed += bool(wanted)
        record = [moves[move] for move in wanted] + [TERMINATOR] * (width - len(wanted))
        member += struct.pack(f"<{width}H", *record)

    print(f"{max(names) + 1} records of {width} halfwords; {listed} species have egg moves")
    if not args.write:
        print("nothing written; pass --write")
        return
    ARCHIVE.write_bytes(wotbl.build_narc([member], align=4))
    HEADER.write_text(re.sub(r"#define MAX_EGG_MOVES\s+\d+", f"#define MAX_EGG_MOVES     {width}",
                             HEADER.read_text()))
    print(f"wrote {ARCHIVE.relative_to(ROOT)} and MAX_EGG_MOVES {width}")


if __name__ == "__main__":
    main()
