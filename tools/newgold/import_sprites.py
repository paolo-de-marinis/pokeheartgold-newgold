#!/usr/bin/env python3
"""Copy the new species' battle sprites into the native graphics tree.

pokeheartgold builds files/poketool/pokegra/pokegra.narc from PNGs under
files/poketool/pokegra/pokegra/NNNN/, and the reference stores its sprites in
the same four-file layout, so this is a copy rather than a conversion.

The archive is read by index: a species' pictures live at species * 6, so the
directories have to stay dense. Identifiers 494 to 507 belong to the egg, the
bad egg and the alternate forms, whose pictures come from otherpoke.narc
instead, so those fourteen slots are padded here purely to keep the numbering
aligned; nothing reads them.

Usage: import_sprites.py REFERENCE_CHECKOUT [--write]
"""

import argparse
import filecmp
import json
import shutil
from pathlib import Path

ROOT = Path(__file__).resolve().parents[2]
SPRITES = ROOT / "files/poketool/pokegra/pokegra"

import import_species  # noqa: E402

# The pictures the padding slots borrow. Only their size matters: a palette is
# built from whichever of the two genders has a picture, and a slot with none
# would produce no palette at all and shift every later index.
PADDING_SOURCE = "0201"
FIRST_PADDED, LAST_PADDED = 494, 507

FILES = ("front.png", "front.png.key", "back.png", "back.png.key")


def copy_species(source, destination, write, can_be_female=True):
    """Copy one species' pictures.

    The game asks for the female picture of every female Pokemon, and the
    repository keeps one for every species that can be female -- the male
    picture again when there is no difference -- leaving a gender's files
    empty only where that gender does not exist. The reference keeps a
    female picture only where it differs, so the male one stands in. An
    earlier version left the female empty when it matched the male, which
    made every female of 504 imported species abort the game on the way in.
    """
    actions = []
    for gender in ("male", "female"):
        for name in FILES:
            origin = source / gender / name
            target = destination / gender / name
            if gender == "female" and can_be_female:
                picture = name.removesuffix(".key")
                male = source / "male" / picture
                female = source / "female" / picture
                if not female.exists() or (male.exists() and filecmp.cmp(female, male, shallow=False)):
                    origin = source / "male" / name
            if gender == "female" and not can_be_female:
                actions.append((None, target))
                continue
            if not origin.exists():
                continue
            actions.append((origin, target))
    if not write:
        return actions
    for origin, target in actions:
        target.parent.mkdir(parents=True, exist_ok=True)
        if origin is None:
            target.write_bytes(b"")
        else:
            shutil.copyfile(origin, target)
    return actions


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("reference", type=Path)
    parser.add_argument("--write", action="store_true")
    args = parser.parse_args()

    reference = args.reference / "data/graphics/sprites"
    existing = sorted(int(p.name) for p in SPRITES.iterdir() if p.name.isdigit())
    print(f"{len(existing)} slots present, {existing[0]} to {existing[-1]}")

    padded, copied, emptied = [], 0, 0
    for identifier in range(FIRST_PADDED, LAST_PADDED + 1):
        if identifier in existing:
            continue
        padded.append(identifier)
        if args.write:
            destination = SPRITES / f"{identifier:04d}"
            for gender in ("male", "female"):
                (destination / gender).mkdir(parents=True, exist_ok=True)
            for name in FILES:
                shutil.copyfile(SPRITES / PADDING_SOURCE / "male" / name,
                                destination / "male" / name)
            for name in ("front.png", "back.png"):
                (destination / "female" / name).write_bytes(b"")

    personal = json.loads((ROOT / "files/poketool/personal/personal.json").read_text())["baseStats"]
    names = {name: 508 + index for index, name in enumerate(import_species.added_species())}
    for name, identifier in names.items():
        source = reference / name.lower()
        if not source.is_dir():
            raise SystemExit(f"the reference has no sprites for {name}")
        # genderRatio is a fraction: 0 is male only, 1 female only, above one genderless.
        ratio = personal[identifier]["genderRatio"]
        actions = copy_species(source, SPRITES / f"{identifier:04d}", args.write, can_be_female=0 < ratio <= 1)
        copied += sum(1 for origin, _ in actions if origin is not None)
        emptied += sum(1 for origin, _ in actions if origin is None)

    print(f"padding slots {padded[0]} to {padded[-1]}" if padded else "no padding needed")
    print(f"{len(names)} species: {copied} files copied, {emptied} female pictures left empty")
    if not args.write:
        print("nothing written; pass --write")


if __name__ == "__main__":
    main()
