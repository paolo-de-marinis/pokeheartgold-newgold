#!/usr/bin/env python3
"""Write src/data/trainer_seed_species.h, hg-engine's number for each species.

A trainer's Pokemon gets its personality from a seed of its difficulty, level,
species and trainer (CreateNPCTrainerParty; enemy_party.c:277 in the engine).
The species there is hg-engine's number, which past Arceus is not this one:
Annihilape is 1029 there and 568 here, so the same entry got another nature
(Morty's is Jolly in konefr's build). The table gives the seed hg-engine's
number and is read for nothing else.

Species are matched by name, read at the engine's revision with git; its
header is self-contained, and cpp works out the forms' expressions. A name the
engine has not got -- the egg, the bad egg, retail's form records -- keeps its
own number. Up to Arceus the two agree, so the table starts at the egg.

Usage: import_trainer_seed.py [--write]
"""

import argparse
import re
import subprocess
import sys
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parent))
import gmm  # noqa: E402

ROOT = gmm.ROOT
TABLE = ROOT / "src/data/trainer_seed_species.h"


def engine_numbers():
    """{name: number} for every SPECIES_ the engine defines."""
    header = gmm.git_show(gmm.ENGINE, "include/constants/species.h")
    names = re.findall(r"^#define (SPECIES_[A-Z0-9_]+)\s", header, re.M)
    source = header + "\n" + "\n".join(f"{name} X_{name}" for name in names)
    out = subprocess.run(["cpp", "-P", "-"], input=source, capture_output=True, text=True, check=True).stdout
    numbers = {}
    for expression, name in re.findall(r"^(.+?) X_(SPECIES_[A-Z0-9_]+)$", out, re.M):
        if re.fullmatch(r"[\d\s()+*-]+", expression):
            numbers[name] = eval(expression)  # digits and arithmetic only
    return numbers


def our_numbers():
    header = (ROOT / "include/constants/species.h").read_text()
    return {name: int(number) for name, number in
            re.findall(r"^#define (SPECIES_[A-Z0-9_]+)\s+(\d+)\s*$", header, re.M)}


def table():
    """[(our name, engine number)] from the egg to the last species."""
    ours, engine = our_numbers(), engine_numbers()
    by_number = {}
    for name, number in ours.items():
        by_number.setdefault(number, name)
    first, last = ours["SPECIES_EGG"], ours[re.search(
        r"#define NUM_SPECIES (SPECIES_\w+)", (ROOT / "include/constants/species.h").read_text())[1]]
    rows = []
    for number in range(first, last + 1):
        name = by_number[number]
        rows.append((name, engine.get(name, number)))
    return rows


def render(rows):
    lines = ["// hg-engine's number for each species from the egg on, which is what",
             "// CreateNPCTrainerParty seeds a trainer Pokemon's personality with.",
             "// Written by tools/newgold/import/import_trainer_seed.py; do not edit it.",
             "static const u16 sTrainerSeedSpecies[NUM_SPECIES - SPECIES_EGG + 1] = {"]
    lines += [f"    [{name} - SPECIES_EGG] = {number}," for name, number in rows]
    return "\n".join(lines + ["};", ""])


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--write", action="store_true")
    args = parser.parse_args()
    rows = table()
    moved = [(name, number) for name, number in rows if number != our_numbers()[name]]
    print(f"{len(rows)} entries, {len(moved)} numbered differently in the engine")
    if not args.write:
        print("nothing written; pass --write")
        return
    TABLE.write_text(render(rows))
    print(f"wrote {TABLE.relative_to(ROOT)}")


if __name__ == "__main__":
    main()
