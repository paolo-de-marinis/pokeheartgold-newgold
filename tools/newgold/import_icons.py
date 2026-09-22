#!/usr/bin/env python3
"""Copy the new species' party icons and their palette numbers.

The icon archive is built from PNGs by wildcard, so a picture is a file. What
needs care is the numbering: HGSS reads a species' icon at species + 7, and
the entries just past the last species are already taken by the alternate form
icons. The new species are given the range after all of those instead, which
GetMonIconNaixEx has to be told about.

Usage: import_icons.py REFERENCE_CHECKOUT [--write]
"""

import argparse
import re
import shutil
from pathlib import Path

ROOT = Path(__file__).resolve().parents[2]
ICONS = ROOT / "files/poketool/icongra/poke_icon"
INDEX = ROOT / "src/pokemon_icon_idx.c"

import import_species  # noqa: E402

FIRST_ADDED_SPECIES = 508


def first_free_icon():
    """The first archive entry after everything the game already names."""
    used = sorted(int(m.group(1)) for m in
                  (re.match(r"poke_icon_0*(\d+)\.png$", p.name) for p in ICONS.iterdir()) if m)
    return used[-1] + 1


def palette_numbers(reference):
    table = (reference / "data/IconPaletteTable.c").read_text(errors="replace")
    return {m[1]: int(m[2]) for m in
            re.finditer(r"\[SPECIES_([A-Z0-9_]+)\s*\]\s*=\s*(\d+)", table)}


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("reference", type=Path)
    parser.add_argument("--write", action="store_true")
    args = parser.parse_args()

    sprites = args.reference / "data/graphics/sprites"
    palettes = palette_numbers(args.reference)
    for form, base in import_species.base_species_of(args.reference).items():
        if form not in palettes and base in palettes:
            palettes[form] = palettes[base]
    first = first_free_icon()
    print(f"icons already go up to {first - 1}; the new species take {first} to "
          f"{first + len(import_species.added_species()) - 1}")

    missing = [name for name in import_species.added_species()
               if not (sprites / name.lower() / "icon.png").exists()]
    if missing:
        raise SystemExit(f"the reference has no icon for: {', '.join(missing)}")
    unknown = [name for name in import_species.added_species() if name not in palettes]
    if unknown:
        raise SystemExit(f"no palette number for: {', '.join(unknown)}")

    numbers = [palettes[name] for name in import_species.added_species()]
    print("palette numbers:", ", ".join(str(n) for n in sorted(set(numbers))))

    if not args.write:
        print("nothing written; pass --write")
        return

    for offset, name in enumerate(import_species.added_species()):
        shutil.copyfile(sprites / name.lower() / "icon.png",
                        ICONS / f"poke_icon_{first + offset:08d}.png")

    source = INDEX.read_text()
    table = re.search(r"(static const u8 sPokemonPalNoBySpeciesAndForm\[\] = \{)(.*?)(\n\};)",
                      source, re.S)
    marker = "\n    // The species New Gold adds"
    body = table.group(2)
    # Rewrite what was added last time rather than adding it again, so running
    # this twice leaves the table the length it should be.
    if marker in body:
        body = body[:body.index(marker)]
    addition = (marker + ", in identifier order from "
                f"{FIRST_ADDED_SPECIES}.\n    "
                + ",\n    ".join(f"{number}, // {name}" for number, name
                                 in zip(numbers, import_species.added_species())))
    INDEX.write_text(source[:table.start(2)] + body + addition + source[table.end(2):])
    print(f"wrote {len(numbers)} icons and their palette numbers")


if __name__ == "__main__":
    main()
