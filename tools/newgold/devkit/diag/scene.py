#!/usr/bin/env python3
"""Play a scene from a save with steps given on the command line, and read
how full every heap got on the way.

    scene.py SAVE OUT STEP... [--rom ROM] [--elf ELF]

A step is one of
    A, B, X, Y, START, SELECT, UP, DOWN, LEFT, RIGHT, L, R   a press, then 20 frames
    BUTTON*N                    the same N times
    wait:N                      N frames
    touch:X,Y                   a tap on the bottom screen, in its own pixels
    drag:X1,Y1,X2,Y2            a touch held from one point to the other
    shot:NAME                   the next frame, both screens, to OUT/NAME.png
    heaps:LABEL                 every heap's largest block at its fullest, and
                                the allocation failures and asserts so far
    untilheap:HEAP_ID_N[:MAX]   A, every 40 frames, until that heap is made
                                (400 presses at most by default)
    poke:SYMBOL=VALUE           a word of the ROM's memory, by name

    scene.py mart.sav out wait:300 A*3 untilheap:HEAP_ID_FIELD2 heaps:mart shot:mart

The ROM is the NEWGOLD_DIAG=1 HeartGold build, run by core.py at the pinned
clock; the heaps are its gDiagHeapLowWater, read by markers.py. The harness
has no wireless, so the communication error the game raises for it is held
off (gDiagIgnoreCommunicationError) every frame, and the Union Room, trades
and the GTS's first screens can be reached. A battle draws black here.
"""
import argparse
import sys
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parent))
from core import Core, pin_clock  # noqa: E402
from markers import DIAG_ELF, Markers  # noqa: E402

ROM = Path(__file__).resolve().parents[4] / "build/heartgold.us.diag/pokeheartgold.us.nds"


def main():
    pin_clock()
    parser = argparse.ArgumentParser()
    parser.add_argument("save")
    parser.add_argument("out", type=Path)
    parser.add_argument("steps", nargs="+")
    parser.add_argument("--rom", default=ROM)
    parser.add_argument("--elf", type=Path, default=DIAG_ELF)
    args = parser.parse_args()
    args.out.mkdir(parents=True, exist_ok=True)
    markers = Markers(args.elf)
    core = Core(args.rom, save=args.save)
    ignore = markers.address("gDiagIgnoreCommunicationError")
    hold = [lambda c: c.poke(ignore, 1)]

    def failures(ram):
        return " ".join(f"{label}={markers.read(ram, name)}" for label, name in (
            ("allocfail", "gDiagAllocFailCount"), ("heap", "gDiagAllocFailHeap"),
            ("size", "gDiagAllocFailSize"), ("asserts", "gDiagAssertCount")))

    for step in args.steps:
        kind, _, rest = step.partition(":")
        if kind == "wait":
            core.step(int(rest), hold)
        elif kind == "touch":
            x, y = map(int, rest.split(","))
            core.touch(x, y, 6, hold)
            core.step(20, hold)
        elif kind == "drag":
            x1, y1, x2, y2 = map(int, rest.split(","))
            core.touching = True
            for k in range(21):
                # core.touch's mapping: the pointer spans both screens, top over bottom
                x, y = x1 + (x2 - x1) * k / 20, y1 + (y2 - y1) * k / 20
                core.tx = int(((x / 256.0) * 2 - 1) * 0x7FFF)
                core.ty = int((((y + 192) / 384.0) * 2 - 1) * 0x7FFF)
                core.step(3 if 0 < k < 20 else 10, hold)
            core.touching = False
            core.step(20, hold)
        elif kind == "shot":
            core.shot(hold).save(args.out / f"{rest}.png")
        elif kind == "poke":
            name, value = rest.split("=")
            core.poke(markers.address(name), int(value, 0))
        elif kind == "heaps":
            ram = core.ram()
            print(f"== {rest} [frame {core.frames}] {failures(ram)}")
            for name, value in markers.heaps(ram).items():
                print(f"   {name:<24} {value:#8x} ({value})")
            sys.stdout.flush()
        elif kind == "untilheap":
            heap, _, most = rest.partition(":")
            for press in range(int(most or 400)):
                core.press("A", 6, hold)
                core.step(40, hold)
                if heap in markers.heaps(core.ram()):
                    print(f"[{core.frames}] {heap} made after {press + 1} presses")
                    break
            else:
                print(f"{heap} was never made: {markers.describe(core.ram())}")
        else:
            button, _, times = step.partition("*")
            for _ in range(int(times or 1)):
                core.press(button, 6, hold)
                core.step(20, hold)
    print(markers.describe(core.ram()))
    core.close()


if __name__ == "__main__":
    main()
