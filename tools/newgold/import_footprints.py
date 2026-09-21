#!/usr/bin/env python3
"""Give the added species their Dex footprints.

The footprint archive is one member per species, in order, and it stops at the
egg. A hole in it would not leave one species without a print: nothing indexes
the archive by name, so every member after the hole would shift and every
species after it would show the wrong footprint. The forms between Arceus and
the added species therefore get filled too, from the species they are forms of.

The images are the reference's, which ships the archive extracted. They arrive
already compressed in exactly the form this build produces, so the conversion
is checked both ways: a member here, converted forward, reproduces the
reference's file byte for byte.

Usage: import_footprints.py REFERENCE_CHECKOUT [--write]
"""

import argparse
import os
import re
import subprocess
import sys
import tempfile
from pathlib import Path

ROOT = Path(__file__).resolve().parents[2]
FOOTPRINTS = ROOT / "files/poketool/pokefoot/pokefoot"
PALETTE = FOOTPRINTS / "pokefoot_00000000.NCLR"
GFX = ROOT / "tools/nitrogfx/nitrogfx"

sys.path.insert(0, str(Path(__file__).resolve().parent))
import import_dex_text  # noqa: E402
import import_species  # noqa: E402

# Member 3 holds species 1.
MEMBER_OFFSET = 2

# The reference's own archive stops before its regional forms, so these two
# take the print of the species they are a form of. A Galarian Slowpoke leaves
# the same footprint as a Johto one.
BORROW_FROM = {
    "SLOWPOKE_GALARIAN": 79,
    "SLOWBRO_GALARIAN": 80,
}


def their_numbers(reference, names):
    """What the reference numbers each species.

    Its constants are chains of expressions rather than plain integers, so the
    C preprocessor resolves them rather than a half-written one here.
    """
    header = reference / "include/constants/species.h"
    program = "\n".join([f'#include "{header}"'] +
                        [f"MARK {name} SPECIES_{name}" for name in names])
    with tempfile.TemporaryDirectory(prefix="newgold-species-") as temp:
        source = Path(temp) / "numbers.c"
        source.write_text(program + "\n")
        result = subprocess.run([os.environ.get("CC", "cc"), "-E", "-P", "-I",
                                 str(reference / "include"), str(source)],
                                capture_output=True, text=True)
    if result.returncode != 0:
        raise SystemExit(result.stderr.strip().splitlines()[-1] if result.stderr else "cpp failed")
    found = {}
    for line in result.stdout.splitlines():
        match = re.fullmatch(r"MARK (\w+) (.+)", line.strip())
        if not match:
            continue
        expression = match.group(2)
        if not re.fullmatch(r"[\d\s()+*-]+", expression):
            continue
        found[match.group(1)] = eval(expression)  # only digits and arithmetic
    return found


def to_png(source, destination):
    """The reference ships the archive compressed; the converter reads the
    format from the extension, so the member is named before it is read."""
    with tempfile.TemporaryDirectory(prefix="newgold-footprint-") as temp:
        packed = Path(temp) / "print.NCGR.lz"
        chars = Path(temp) / "print.NCGR"
        packed.write_bytes(Path(source).read_bytes())
        subprocess.run([GFX, packed, chars], check=True, capture_output=True)
        subprocess.run([GFX, chars, destination, "-palette", PALETTE], check=True, capture_output=True)


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("reference", type=Path)
    parser.add_argument("--write", action="store_true")
    args = parser.parse_args()

    theirs = their_numbers(args.reference, import_species.added_species())
    prints = args.reference / "rawdata/footprints"
    if not prints.is_dir():
        raise SystemExit(f"{prints} is not there")

    # Every species between the egg and the first added one, by the species
    # whose footprint it should borrow.
    wanted = {}
    for species, base in import_dex_text.FORM_BASES.items():
        wanted[species] = FOOTPRINTS / f"pokefoot_{base + MEMBER_OFFSET:08d}.png"
    for species in (495, 496, 497):
        # The bad egg and the first forms: borrow the egg's own blank member,
        # which is the last one the archive already has.
        wanted.setdefault(species, FOOTPRINTS / f"pokefoot_{494 + MEMBER_OFFSET:08d}.png")

    added = {}
    for offset, name in enumerate(import_species.added_species()):
        species = import_dex_text.FIRST_ADDED + offset
        number = theirs.get(name)
        if number is None:
            raise SystemExit(f"the reference has no number for SPECIES_{name}")
        source = prints / f"a069_{number + MEMBER_OFFSET:04d}"
        if not source.exists():
            if name not in BORROW_FROM:
                raise SystemExit(f"the reference has no footprint for SPECIES_{name} ({source.name})")
            wanted[species] = FOOTPRINTS / f"pokefoot_{BORROW_FROM[name] + MEMBER_OFFSET:08d}.png"
            continue
        added[species] = source

    writing, borrowed = 0, 0
    for species in sorted(list(wanted) + list(added)):
        target = FOOTPRINTS / f"pokefoot_{species + MEMBER_OFFSET:08d}.png"
        if target.exists():
            continue
        if species in added:
            writing += 1
            if args.write:
                to_png(added[species], target)
        else:
            borrowed += 1
            if args.write:
                target.write_bytes(wanted[species].read_bytes())

    print(f"{writing} footprints from the reference, {borrowed} borrowed for the forms")
    members = sorted(int(p.stem.split("_")[1]) for p in FOOTPRINTS.glob("pokefoot_*.png"))
    gaps = [n for n in range(members[0], members[-1] + 1) if n not in members]
    print(f"members {members[0]}..{members[-1]}, {len(gaps)} holes")
    if gaps:
        raise SystemExit(f"the archive would have holes at {gaps[:8]}")
    if not args.write:
        print("nothing written; pass --write")


if __name__ == "__main__":
    main()
