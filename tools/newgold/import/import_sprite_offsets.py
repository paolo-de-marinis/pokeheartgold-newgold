#!/usr/bin/env python3
"""Carry every species' picture record out of the reference into a/1/8/0.

a/1/8/0 is one member of 89-byte records, one a species: the cry delay and
animation of the front and back pictures, then the Y offset and the shadow a
battle draws under the Pokemon. Retail's stops at Arceus, 494 records, and six
readers index it by species with no bound, so every added species read the
record out of whatever followed the member.

hg-engine builds the archive from data/SpriteOffsets.c at d0380a487, the same
record per species (SpriteFrameData). Its first 494 records are retail's byte
for byte. This takes each species here by its constant's name, and the forms
between the bad egg and Lillipup by number: the reference calls them
SPECIES_496..507, and both games keep retail's numbers there.

    import_sprite_offsets.py [--reference PATH] [--write]
"""
import argparse
import re
import subprocess
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[3]
ARCHIVE = ROOT / "files/a/1/8/0"
SPECIES_H = ROOT / "include/constants/species.h"
REFERENCE = Path("/home/paolo/Porting HGSS/hg-engine-newgold-reference")
COMMIT = "d0380a487"
RECORD = 89
RETAIL = 494  # species 0..493

sys.path.insert(0, str(Path(__file__).resolve().parent))
from wotbl import build_narc, read_narc  # noqa: E402


def reference_records(reference):
    """Every [SPECIES_X] record in the reference, as the 89 bytes it builds."""
    text = subprocess.run(["git", "-C", str(reference), "show", f"{COMMIT}:data/SpriteOffsets.c"],
                          capture_output=True, text=True, check=True).stdout
    parts = re.split(r"^    \[(SPECIES_\w+)\] = \{", text, flags=re.M)
    out = {}
    for name, body in zip(parts[1::2], parts[2::2]):
        values = []
        for side in ("front", "back"):
            header = re.search(r"\." + side + r"Header = \{\s*\.cryDelay = (-?\d+),\s*"
                               r"\.animation = (-?\d+),\s*\.animationDelay = (-?\d+),", body)
            frames = re.search(r"\." + side + r"Frames = \{(.*?)\n        \},", body, re.S).group(1)
            frames = re.findall(r"\{ \.frameNo = (-?\d+), \.duration = (-?\d+), "
                                r"\.horizontalShift = (-?\d+), \.verticalShift = (-?\d+) \}", frames)
            if header is None or len(frames) != 10:
                raise ValueError(f"{name}: cannot read the {side} picture")
            values += header.groups() + tuple(v for frame in frames for v in frame)
        for field in ("spriteYOffset", "shadowXOffset", "shadowSize"):
            values.append(re.search(r"\." + field + r" = (-?\d+),", body).group(1))
        if name in out:
            raise ValueError(f"{name} twice")
        out[name] = bytes(int(v) & 0xFF for v in values)
    return out


def port_species():
    """number -> the first constant naming it, 0..NUM_SPECIES."""
    names = {}
    for name, number in re.findall(r"^#define (SPECIES_\w+)\s+(\d+)\s*$", SPECIES_H.read_text(), re.M):
        names.setdefault(int(number), name)
    last = re.search(r"^#define NUM_SPECIES (SPECIES_\w+)", SPECIES_H.read_text(), re.M).group(1)
    count = next(n for n, name in names.items() if name == last) + 1
    return [names[n] for n in range(count)]


def records(reference):
    theirs = reference_records(reference)
    out = []
    for number, name in enumerate(port_species()):
        record = theirs.get(name) or theirs.get(f"SPECIES_{number}")
        if record is None:
            raise ValueError(f"{name}: no record in the reference")
        out.append(record)
    return out


def main():
    parser = argparse.ArgumentParser(description=__doc__.split("\n")[0])
    parser.add_argument("--reference", type=Path, default=REFERENCE)
    parser.add_argument("--write", action="store_true")
    args = parser.parse_args()
    new = records(args.reference)
    old = read_narc(ARCHIVE.read_bytes())[0][0]
    if b"".join(new[:RETAIL]) != old[:RETAIL * RECORD]:
        raise SystemExit("the reference's retail records differ from retail's")
    print(f"{len(new)} records, the first {RETAIL} retail's")
    if args.write:
        ARCHIVE.write_bytes(build_narc([b"".join(new)], align=4))


if __name__ == "__main__":
    main()
