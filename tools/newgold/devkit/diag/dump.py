#!/usr/bin/env python3
"""One line per memory dump of a harness run, so the run reads as a timeline.

    dump.py OUTDIR [ELF]

OUTDIR holds the r_FRAME.bin dumps boot_check's ram: action wrote, and any
s_FRAME.ppm shots, which are pasted into one contact sheet beside it. A line
that repeats the one before it is left out.
"""
import sys
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parent))
from markers import DIAG_ELF, Markers  # noqa: E402


def report(out, elf=DIAG_ELF):
    markers = Markers(elf)
    last = None
    for dump in sorted(Path(out).glob("r_*.bin")):
        line = markers.describe(dump.read_bytes())
        if line != last:
            print(f"{dump.stem[2:]}: {line}")
            last = line
    shots = sorted(Path(out).glob("s_*.ppm"))
    if shots:
        from PIL import Image
        images = [Image.open(shot) for shot in shots]
        width, height = images[0].size
        columns = 6
        sheet = Image.new("RGB", (width * columns, height * ((len(images) + columns - 1) // columns)))
        for i, image in enumerate(images):
            sheet.paste(image, ((i % columns) * width, (i // columns) * height))
        sheet.save(Path(out).with_name(Path(out).name + "_sheet.png"))
        print(f"{len(images)} shots in {Path(out).name}_sheet.png")


if __name__ == "__main__":
    report(sys.argv[1], Path(sys.argv[2]) if len(sys.argv) > 2 else DIAG_ELF)
