#!/usr/bin/env python3
"""Write files/poketool/personal/pms.narc, the species an egg hatches as.

The file is one halfword a species, read by ReadFromPersonalPmsNarc: the
Day-Care makes the mother's entry, and a link battle's "no evolved Pokemon"
rule compares a species with its own. Retail's covers species 0 to 507, so a
mother past that was answered with species 0 and the egg was nothing.

hg-engine generates the file from data/BabyMons.c by species name, and this
reads that table at the engine's revision. A form there is its base species
with a form number, and the Day-Care hands the mother's form number to the
egg (GiveEggToPlayer, unchanged in the engine): an Alolan Ninetales lays an
Alolan Vulpix. A form is a species here, so its entry is the same-numbered form
of its base's baby where this game has that form as a species, and the baby
itself where it has not. Numbers the table does not name -- the egg, the bad
egg and retail's own form records -- keep the value they have.

Usage: import_baby_species.py REFERENCE_CHECKOUT [--write]
"""

import argparse
import re
import struct
import subprocess
from pathlib import Path

ROOT = Path(__file__).resolve().parents[3]
TABLE = ROOT / "files/poketool/personal/pms.narc"

# hg-engine as it was before konefr's first commit; his range does not touch
# BabyMons.c or the form table.
ENGINE_REVISION = "d0380a487"


def show(reference, path):
    return subprocess.run(["git", "-C", str(reference), "show", f"{ENGINE_REVISION}:{path}"],
                          capture_output=True, text=True, check=True).stdout


def egg_species(reference):
    """Every species' egg species, by name, from the reference."""
    babies = dict(re.findall(r"\[SPECIES_([A-Z0-9_]+)\]\s*=\s*SPECIES_([A-Z0-9_]+)",
                             show(reference, "data/BabyMons.c")))
    forms = {m[1]: re.findall(r"SPECIES_([A-Z0-9_]+)", m[2]) for m in
             re.finditer(r"\[SPECIES_([A-Z0-9_]+)\] = \{(.*?)\}", show(reference, "data/PokeFormDataTbl.c"), re.S)}
    for base, listed in forms.items():
        baby = babies.get(base)
        if baby is None:
            continue
        theirs = forms.get(baby, [])
        for number, form in enumerate(listed):
            babies.setdefault(form, theirs[number] if number < len(theirs) else baby)
    return babies


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("reference", type=Path)
    parser.add_argument("--write", action="store_true")
    args = parser.parse_args()

    header = (ROOT / "include/constants/species.h").read_text()
    numbers = {name: int(n) for name, n in re.findall(r"#define SPECIES_([A-Z0-9_]+)\s+(\d+)\s*$", header, re.M)}
    last = numbers[re.search(r"#define NUM_SPECIES SPECIES_([A-Z0-9_]+)", header).group(1)]
    names = {}
    for name, number in numbers.items():
        names.setdefault(number, name)

    old = TABLE.read_bytes()
    table = list(struct.unpack(f"<{len(old) // 2}H", old))[:last + 1]
    table += [0] * (last + 1 - len(table))
    babies = egg_species(args.reference)
    kept = []
    for number in range(last + 1):
        baby = babies.get(names[number])
        if baby is None:
            kept.append(names[number])
        elif baby not in numbers:
            raise SystemExit(f"{names[number]}: its egg species {baby} is not a species here")
        else:
            table[number] = numbers[baby]
    empty = [names[n] for n in range(1, last + 1) if table[n] == 0]
    if empty:
        raise SystemExit(f"no egg species for: {', '.join(empty)}")

    print(f"{last + 1} entries; kept as they were: {', '.join(kept)}")
    if not args.write:
        print("nothing written; pass --write")
        return
    TABLE.write_bytes(struct.pack(f"<{len(table)}H", *table))
    print(f"wrote {TABLE.relative_to(ROOT)}")


if __name__ == "__main__":
    main()
