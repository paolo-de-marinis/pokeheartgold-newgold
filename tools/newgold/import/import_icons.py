#!/usr/bin/env python3
"""Copy the new species' party icons and their palette numbers.

The icon archive is built from PNGs by wildcard, so a picture is a file. What
needs care is the numbering: HGSS reads a species' icon at species + 7, and
the entries just past the last species are already taken by the alternate form
icons. The new species are given the range after all of those instead, which
GetMonIconNaixEx has to be told about.

An icon is drawn in one of three palettes the icons share
(poke_icon_00000000.pal), and each species names its own in the reference's
data/IconPaletteTable.c. For 21 of the added species that number is not the
palette the icon was drawn in -- Iron Leaves, green and pink, is given the
yellow and orange palette 0 -- while the icon's PNG carries its palette's
colours: where the PNG's palette is one of the three on every colour it
uses, that one is the icon's.

Usage: import_icons.py REFERENCE_CHECKOUT [--write]
"""

import argparse
import re
import shutil
from pathlib import Path

from PIL import Image

ROOT = Path(__file__).resolve().parents[3]
ICONS = ROOT / "files/poketool/icongra/poke_icon"
INDEX = ROOT / "src/pokemon_icon_idx.c"

import import_species  # noqa: E402
import own_art  # noqa: E402

FIRST_ADDED_SPECIES = 508


def first_added_icon():
    """Where the added species' icons start, as the game's own lookup has it.

    This used to be "the first free entry", which is not the same thing twice:
    a second run appended another copy of every icon and left the lookup
    pointing at the first, so the forms imported in the second run showed
    another species' picture. The number comes from the C now, and a species
    is always written at the same entry.
    """
    source = (ROOT / "include/pokemon_icon_idx.h").read_text()
    return int(re.search(r"#define FIRST_ADDED_ICON\s+(\d+)", source).group(1))


def shared_palettes():
    """The three palettes the icons share, sixteen colours each."""
    lines = (ICONS / "poke_icon_00000000.pal").read_text().split("\n")[3:]
    colours = [tuple(int(v) for v in line.split()) for line in lines if line.strip()]
    return [colours[16 * k:16 * k + 16] for k in range(3)]


def drawn_in(png, shared):
    """The shared palette an icon's PNG has on every colour it uses, if one."""
    image = Image.open(png)
    own = image.getpalette() or []
    used = {pixel for pixel in image.getdata() if pixel}
    found = [k for k, palette in enumerate(shared)
             if all(tuple(own[3 * i:3 * i + 3]) == palette[i] for i in used)]
    return found[0] if len(found) == 1 else None


def palette_numbers(reference):
    table = (reference / "data/IconPaletteTable.c").read_text(errors="replace")
    return {m[1]: int(m[2]) for m in
            re.finditer(r"\[SPECIES_([A-Z0-9_]+)\s*\]\s*=\s*(\d+)", table)}


def plan(reference):
    """(name, picture, palette number, the reference's number) of every added
    species, in order: the picture its icon is copied from and the shared
    palette it is drawn in.
    A species whose pictures are Paolo's own (own_art.py) keeps the tree's
    icon, and its number is the palette that icon is drawn in."""
    sprites = reference / "data/graphics/sprites"
    palettes = palette_numbers(reference)
    for form, base in import_species.base_species_of(reference).items():
        if form not in palettes and base in palettes:
            palettes[form] = palettes[base]
    first = first_added_icon()
    added = import_species.added_species()
    pictures = {name: ICONS / f"poke_icon_{first + offset:08d}.png" if name in own_art.SPECIES
                else sprites / name.lower() / "icon.png" for offset, name in enumerate(added)}

    missing = [name for name in added if not pictures[name].exists()]
    if missing:
        raise SystemExit(f"no icon for: {', '.join(missing)}")
    unknown = [name for name in added if name not in palettes and name not in own_art.SPECIES]
    if unknown:
        raise SystemExit(f"no palette number for: {', '.join(unknown)}")

    shared = shared_palettes()
    out = []
    for name in added:
        drawn = drawn_in(pictures[name], shared)
        if name in own_art.SPECIES and drawn is None:
            raise SystemExit(f"{name}: Paolo's icon is not drawn in one of the shared palettes")
        out.append((name, pictures[name], palettes[name] if drawn is None else drawn, palettes.get(name)))
    return out


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("reference", type=Path)
    parser.add_argument("--write", action="store_true")
    args = parser.parse_args()

    first = first_added_icon()
    icons = plan(args.reference)
    print(f"the added species take icons {first} to {first + len(icons) - 1}, "
          f"{len(icons)} of them")
    for name, _picture, number, theirs in icons:
        if number != theirs:
            print(f"{name}: drawn in palette {number}, the reference says {theirs}")
    numbers = [number for _name, _picture, number, _theirs in icons]
    print("palette numbers:", ", ".join(str(n) for n in sorted(set(numbers))))

    if not args.write:
        print("nothing written; pass --write")
        return

    for offset, (name, picture, *_numbers) in enumerate(icons):
        if name not in own_art.SPECIES:
            shutil.copyfile(picture, ICONS / f"poke_icon_{first + offset:08d}.png")

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
                + ",\n    ".join(f"{number}, // {name}" for name, _picture, number, _theirs in icons))
    INDEX.write_text(source[:table.start(2)] + body + addition + source[table.end(2):])
    print(f"wrote {len(numbers)} icons and their palette numbers")


if __name__ == "__main__":
    main()
