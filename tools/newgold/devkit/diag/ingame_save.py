#!/usr/bin/env python3
"""Have the game save: continue a save, save through the start menu, and
write what the game wrote to flash.

    ingame_save.py SAVE OUT [--keys X,DOWN,RIGHT,A] [--after 300] [--wait 6000] [--shots] [--build DIR]

savedit writes a save the way the game reads it; this is the other half of
the proof -- the game itself reading it, and writing it back. SAVE is
continued on the NEWGOLD_DIAG=1 build (DIR, default build/heartgold.us.diag),
the keys are pressed on the field, then A until the save counter in RAM
moves (the one the game bumps in the chunk footers on a save). The core
writes the flash to its .sav file a while after the game's last write: once
that file has changed and stayed the same for AFTER frames, it is copied to
OUT. A counter that never moves says the game refused (--shots: a screenshot
after each key and every few waits, beside OUT, shows where it stopped).

The start menu is reached with the pad: a touch on it is lost here. X opens
it on its first entry, POKeDEX when the player has one, and SAVE is one down
and one right of that: the default keys. Before the POKeDEX the first entry
is POKeMON, and SAVE is right of it: --keys X,RIGHT,A.
"""
import argparse
import struct
import sys
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parent))
sys.path.insert(0, str(Path(__file__).resolve().parents[1] / "harness"))
import species  # noqa: E402
import where  # noqa: E402
from gym import quiet  # noqa: E402
from markers import MAIN_RAM  # noqa: E402


def main():
    parser = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    parser.add_argument("save", type=Path)
    parser.add_argument("out", type=Path)
    parser.add_argument("--keys", default="X,DOWN,RIGHT,A", help="buttons, or TOUCH:X:Y")
    parser.add_argument("--after", type=int, default=300, help="frames the save file must stay the same")
    parser.add_argument("--wait", type=int, default=6000, help="frames to wait for it at most")
    parser.add_argument("--shots", action="store_true")
    parser.add_argument("--build", type=Path, default=species.BUILD)
    args = parser.parse_args()
    out = quiet()
    say = lambda line: print(line, file=out)  # noqa: E731
    game = species.Game(args.save, args.build)
    core, markers = game.core, game.markers
    shots = [0]

    def shot(tag):
        if args.shots:
            shots[0] += 1
            game.shot().save(f"{args.out}.{shots[0]:02d}-{tag}.png")

    page = where.constant("SAVE_PAGE_MAX", "include/constants/save_arrays.h")
    sector = where.constant("SAVE_SECTOR_SIZE", "include/constants/save_arrays.h")
    save_data = markers.address("sSaveDataPtr")

    def counter():
        ram = core.ram()
        at = struct.unpack_from("<I", ram, save_data - MAIN_RAM)[0]
        return struct.unpack_from("<I", ram, at + 0x10 + page * sector - MAIN_RAM)[0] if at else None

    species.continue_game(game)
    game.step(200)
    start = counter()
    say(f"[{core.frames}] on the field; the save counter in RAM is {start}")
    shot("field")
    for key in args.keys.split(","):
        if key.startswith("TOUCH:"):
            _, x, y = key.split(":")
            game.touch(int(x), int(y), 30)
        else:
            game.press(key, 30)
        shot(key.replace(":", "_"))
    for i in range(80):
        game.step(30)
        if counter() != start:
            say(f"[{core.frames}] the save counter {start} -> {counter()}")
            break
        if i % 4 == 3:
            shot("wait")
            game.press("A")
    else:
        say(f"[{core.frames}] the game did not save: the counter is still {counter()}; the last message asked for "
            f"{struct.unpack_from('<5I', core.ram(), markers.address('gDiagLastMessage') - MAIN_RAM)}")
    # The core writes the flash to its .sav file a while after the game's
    # last write to it: wait for the file to change, then to stay the same.
    flash = next(Path(core.dir).glob("*.sav"))   # where core.py put SAVE
    before, last, still = args.save.read_bytes(), None, 0
    for _ in range(args.wait // 60):
        game.step(60)
        now = flash.read_bytes()
        still = still + 1 if now == last and now != before else 0
        last = now
        if still * 60 >= args.after:
            break
    for _ in range(4):
        game.press("B", 30)
    game.close()
    if last is None or last == before:
        say(f"the core's save file did not change in {args.wait} frames: {args.out} not written")
        sys.exit(1)
    args.out.write_bytes(last)
    say(f"[{core.frames}] wrote {args.out}")

if __name__ == "__main__":
    main()
