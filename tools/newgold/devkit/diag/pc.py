#!/usr/bin/env python3
"""Open the PC's storage system from a save that stands in front of a PC, page
through the boxes, and say how full every heap got.

    pc.py SAVE

The save is made with savedit.py --where; in the Pokemon Centers that share
map matrix 0073 (Violet's is map 158) the PC is the tile above (11, 13):

    savedit.py pc.sav --where 158:11:13:0

A is pressed until heap 10, the storage system's own, has been created --
it goes through Continue, the PC's menus and into the first choice, which
opens the boxes -- then R pages through them, which loads each box's
wallpaper and icons. What is printed is gDiagHeapLowWater: for every heap,
the largest block it still had at its fullest.
"""
import sys
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parent))
from core import Core  # noqa: E402
from markers import DIAG_ELF, Markers  # noqa: E402

ROM = Path(__file__).resolve().parents[4] / "build/heartgold.us.diag/pokeheartgold.us.nds"


def main():
    markers = Markers(DIAG_ELF)
    core = Core(ROM, save=sys.argv[1])
    ignore = markers.address("gDiagIgnoreCommunicationError")
    hold = [lambda c: c.poke(ignore, 1)]
    for press in range(440):
        core.press("A", 6, hold)
        core.step(40, hold)
        if "HEAP_ID_10" in markers.heaps(core.ram()):
            print(f"[{core.frames}] the storage system is open")
            break
    else:
        raise SystemExit("the storage system never opened: " + markers.describe(core.ram()))
    core.step(300, hold)
    for page in range(12):
        core.press("R", 6, hold)
        core.step(60, hold)
    core.step(120, hold)
    print(markers.describe(core.ram()))
    for name, value in markers.heaps(core.ram()).items():
        print(f"  {name:<28} largest block at its fullest {value:#8x} ({value})")


if __name__ == "__main__":
    main()
