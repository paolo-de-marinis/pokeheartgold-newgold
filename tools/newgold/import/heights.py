#!/usr/bin/env python3
"""Derive the battle sprite height archive from the sprites themselves.

pret ships files/poketool/pokegra/height.narc as a binary. Every entry turns
out to be one byte: the number of rows between the bottom of the sprite's first
frame and the lowest row that has any pixel in it, which is what positions the
Pokemon on the ground. That rule reproduces all 954 of pret's non-empty entries
exactly, so the archive can be regenerated rather than hand-extended.

    heights.py verify    rebuild the archive and compare it with the original
    heights.py write     regenerate it for every species present

Entries are read as species * 4 + facing + (gender is not female), and a gender
with no picture gets an empty entry, exactly as pret's archive does.
"""

import argparse
import struct
import sys
import zlib
from pathlib import Path

ROOT = Path(__file__).resolve().parents[3]
ARCHIVE = ROOT / "files/poketool/pokegra/height.narc"
SPRITES = ROOT / "files/poketool/pokegra/pokegra"

FRAME_WIDTH = 80
PRET_SPECIES = 508  # what pret ships heights for: the species, the egg, the bad egg and the forms
# Back and front, each for the female then the male picture.
SLOTS = (("female", "back.png"), ("male", "back.png"),
         ("female", "front.png"), ("male", "front.png"))

sys.path.insert(0, str(Path(__file__).resolve().parent))
from wotbl import build_narc, read_narc  # noqa: E402


def png_rows(data):
    """Return the image's height, bit depth and unfiltered rows."""
    position, pixels = 8, b""
    width = height = depth = 0
    while position < len(data):
        length = struct.unpack_from(">I", data, position)[0]
        kind = data[position + 4:position + 8]
        body = data[position + 8:position + 8 + length]
        if kind == b"IHDR":
            width, height, depth = struct.unpack(">IIB", body[:9])
        elif kind == b"IDAT":
            pixels += body
        position += 12 + length
    raw = zlib.decompress(pixels)
    stride = (width * depth + 7) // 8
    step = max(1, depth // 8)
    rows, previous, offset = [], bytes(stride), 0
    for _ in range(height):
        filter_ = raw[offset]
        line = bytearray(raw[offset + 1:offset + 1 + stride])
        offset += 1 + stride
        for i in range(len(line)):
            left = line[i - step] if i >= step else 0
            above = previous[i]
            corner = previous[i - step] if i >= step else 0
            if filter_ == 1:
                line[i] = (line[i] + left) & 0xFF
            elif filter_ == 2:
                line[i] = (line[i] + above) & 0xFF
            elif filter_ == 3:
                line[i] = (line[i] + (left + above) // 2) & 0xFF
            elif filter_ == 4:
                estimate = left + above - corner
                distances = (abs(estimate - left), abs(estimate - above), abs(estimate - corner))
                nearest = left if distances[0] <= min(distances[1:]) else (
                    above if distances[1] <= distances[2] else corner)
                line[i] = (line[i] + nearest) & 0xFF
        previous = bytes(line)
        rows.append(bytes(line))
    return height, depth, rows


def height_of(path):
    """One byte of clearance below the sprite, or nothing when there is none."""
    data = path.read_bytes()
    if not data:
        return b""
    height, depth, rows = png_rows(data)
    stride = (FRAME_WIDTH * depth + 7) // 8
    lowest = max((index for index, row in enumerate(rows) if any(row[:stride])), default=-1)
    return struct.pack("<B", height - 1 - lowest)


def entries():
    slots = sorted(int(p.name) for p in SPRITES.iterdir() if p.name.isdigit())
    if slots != list(range(len(slots))):
        raise SystemExit("the sprite tree has a gap; fix that before the heights")
    return [height_of(SPRITES / f"{slot:04d}" / gender / picture)
            for slot in slots for gender, picture in SLOTS]


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("command", choices=("verify", "write"))
    args = parser.parse_args()

    original, _, _ = read_narc(ARCHIVE.read_bytes())
    generated = entries()

    # The proof of the rule is pret's own archive, the first 508 species; the
    # entries after those were derived by this tool and change whenever a
    # picture is added, a female one for instance.
    shared = min(len(original), len(generated), PRET_SPECIES * len(SLOTS))
    mismatched = [i for i in range(shared) if original[i] != generated[i]]
    if mismatched:
        print(f"{len(mismatched)} of pret's {shared} entries do not regenerate, "
              f"first at {mismatched[0]}", file=sys.stderr)
        raise SystemExit(1)

    if args.command == "verify":
        print(f"{shared} entries regenerate exactly; the tree would give {len(generated)}")
        return

    ARCHIVE.write_bytes(build_narc(generated))
    print(f"wrote {ARCHIVE.relative_to(ROOT)} with {len(generated)} entries, "
          f"{len(generated) // len(SLOTS)} species")


if __name__ == "__main__":
    main()
