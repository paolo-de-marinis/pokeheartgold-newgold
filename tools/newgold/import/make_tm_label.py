#!/usr/bin/env python3
"""Draw the bag's TM label from the HM label the game already has.

The bag draws a small rounded badge beside every machine in the list. HeartGold
has one, member 37 of the bag archive, and it reads HM; TMs get a "No." glyph
instead. New Gold gives TMs a badge of their own, so one is needed, and the
honest way to get it is to take the HM badge and redraw the first letter: same
box, same palette, same shadow, one letter apart.

The letter shapes follow the reference's own TM badge, which keeps the box and
the M untouched and centres a T over five pixels. Its copy lost the shadow
colour in conversion; this one keeps HeartGold's.

The TRs hg-engine adds get the third badge it has, member 96: the same T, and
an R where the M stood, as wide as the M, with the shadow falling to the right
of every run of letter the way HeartGold's does.

Usage: make_tm_label.py [--check]
"""

import argparse
import struct
import subprocess
import tempfile
import sys
import zlib
from pathlib import Path

ROOT = Path(__file__).resolve().parents[3]
BAG = ROOT / "files/graphic/bag_gra"
HM_BADGE = BAG / "bag_gra_00000037.NCGR"
PALETTE = BAG / "bag_gra_00000038.NCLR"
TM_BADGE = BAG / "bag_gra_00000095.png"
TR_BADGE = BAG / "bag_gra_00000096.png"
GFX = ROOT / "tools/nitrogfx/nitrogfx"

BOX, LETTER, SHADOW = 9, 0xB, 8

# The badge is 104x16; the letters sit in the first cell, rows 5 to 10. The H
# stands on two stems seven pixels apart, the T on a bar with one stem under it.
TOP, BOTTOM = 5, 10
BAR = range(5, 10)
STEM = 7

# The M stands in columns 13 to 18 with its shadow in 19; the R takes the same
# six columns. Each row is the columns of letter in it, top to bottom.
SECOND_CELL = range(12, 21)
R_LEFT = 13
R_ROWS = [range(0, 5), (0, 5), (0, 5), range(0, 5), (0, 4), (0, 5)]


def chunks(data):
    index = 8
    while index < len(data):
        length = struct.unpack(">I", data[index:index + 4])[0]
        yield data[index + 4:index + 8], data[index + 8:index + 8 + length]
        index += 12 + length


def rebuild(source, rows, width):
    out = bytearray(b"\x89PNG\r\n\x1a\n")
    raw = bytearray()
    for row in rows:
        raw.append(0)
        for x in range(0, width, 2):
            raw.append((row[x] << 4) | row[x + 1])
    for kind, body in chunks(source):
        if kind == b"IDAT":
            body = zlib.compress(bytes(raw), 9)
        out += struct.pack(">I", len(body)) + kind + body
        out += struct.pack(">I", zlib.crc32(kind + body))
    return bytes(out)


def unfilter(raw, width, height):
    rows, stride, previous, at = [], (width + 1) // 2, bytearray((width + 1) // 2), 0
    for _ in range(height):
        kind, line, at = raw[at], bytearray(raw[at + 1:at + 1 + stride]), at + 1 + stride
        for x in range(stride):
            left = line[x - 1] if x else 0
            up = previous[x]
            upleft = previous[x - 1] if x else 0
            if kind == 1:
                line[x] = (line[x] + left) & 0xFF
            elif kind == 2:
                line[x] = (line[x] + up) & 0xFF
            elif kind == 3:
                line[x] = (line[x] + (left + up) // 2) & 0xFF
            elif kind == 4:
                guess = left + up - upleft
                best = min((abs(guess - v), i) for i, v in enumerate((left, up, upleft)))[1]
                line[x] = (line[x] + (left, up, upleft)[best]) & 0xFF
        previous = line
        rows.append([v for byte in line for v in (byte >> 4, byte & 15)][:width])
    return rows


def draw_t(rows):
    for y in range(TOP, BOTTOM + 1):
        for x in range(4, 11):
            rows[y][x] = BOX
    for x in BAR:
        rows[TOP][x] = LETTER
    rows[TOP][BAR.stop] = SHADOW
    for y in range(TOP + 1, BOTTOM + 1):
        rows[y][STEM] = LETTER
        rows[y][STEM + 1] = SHADOW
    return rows


def draw_r(rows):
    for y in range(TOP, BOTTOM + 1):
        for x in SECOND_CELL:
            rows[y][x] = BOX
    for y, columns in zip(range(TOP, BOTTOM + 1), R_ROWS):
        for column in columns:
            rows[y][R_LEFT + column] = LETTER
        for column in columns:
            if R_LEFT + column + 1 not in [R_LEFT + c for c in columns]:
                rows[y][R_LEFT + column + 1] = SHADOW
    return rows


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--check", action="store_true", help="compare, do not write")
    args = parser.parse_args()

    with tempfile.TemporaryDirectory(prefix="newgold-tm-label-") as temp:
        render = Path(temp) / "hm.png"
        subprocess.run([GFX, HM_BADGE, render, "-palette", PALETTE],
                       check=True, capture_output=True)
        rendered = render.read_bytes()
    width = height = None
    for kind, body in chunks(rendered):
        if kind == b"IHDR":
            width, height, depth, colour = struct.unpack(">IIBB", body[:10])
        elif kind == b"IDAT":
            idat = body
    if (depth, colour) != (4, 3):
        raise SystemExit(f"the HM badge came back {depth}-bit type {colour}, not a 4-bit palette")

    badges = {
        TM_BADGE: rebuild(rendered, draw_t(unfilter(zlib.decompress(idat), width, height)), width),
        TR_BADGE: rebuild(rendered, draw_r(draw_t(unfilter(zlib.decompress(idat), width, height))), width),
    }
    for path, wanted in badges.items():
        if args.check:
            have = path.read_bytes() if path.exists() else b""
            if have != wanted:
                sys.exit(f"{path.relative_to(ROOT)} is not what the HM badge redraws to")
            print(f"{path.relative_to(ROOT)} matches")
            continue
        path.write_bytes(wanted)
        print(f"wrote {path.relative_to(ROOT)}")


if __name__ == "__main__":
    main()
