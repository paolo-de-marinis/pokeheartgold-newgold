#!/usr/bin/env python3
"""Have the game save: continue a save, save through the start menu, and
write what the game wrote to flash.

    ingame_save.py SAVE OUT [--keys X,DOWN,RIGHT,A] [--wait 6000] [--shots] [--build DIR]

savedit writes a save the way the game reads it; this is the other half of
the proof -- the game itself reading it, and writing it back. SAVE is
continued on the NEWGOLD_DIAG=1 build (DIR, default build/heartgold.us.diag),
the keys are pressed on the field, then A until the save counter in RAM
moves (the one the game bumps in the chunk footers on a save). The save is
done when Save_WriteManFinish turns SaveData.lastGoodSector to the half it
wrote: the counter moves as it starts, and the PC slot's footer is written
last, some 800 frames later. The flash is then read from the core, which
melonDS DS hands over as memory, and copied to OUT -- not when the flash
first stays still: a save whose boxes are the bytes the flash holds already
leaves it unchanged for seconds between the main slot's footer and the
PC's, and a copy taken then is half a save. melonDS 0.9.3 (NEWGOLD_CORE)
cannot be used: it exposes no save memory and never writes its .sav file,
not after a finished save nor at unload or deinit, so it is refused before
anything is played, as scene.py's save step refuses it. A counter that
never moves says the game refused
(--shots: a screenshot after each key and every few waits, beside OUT, shows
where it stopped).

The start menu is reached with the pad: a touch on it is lost here. X opens
it on its first entry, POKeDEX when the player has one, and SAVE is one down
and one right of that: the default keys. Before the POKeDEX the first entry
is POKeMON, and SAVE is right of it: --keys X,RIGHT,A.
"""
import argparse
import ctypes
import struct
import sys
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parent))
sys.path.insert(0, str(Path(__file__).resolve().parents[1]))
sys.path.insert(0, str(Path(__file__).resolve().parents[1] / "harness"))
import savedit  # noqa: E402
import species  # noqa: E402
import where  # noqa: E402
from gym import quiet  # noqa: E402
from markers import MAIN_RAM  # noqa: E402


def main():
    parser = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    parser.add_argument("save", type=Path)
    parser.add_argument("out", type=Path)
    parser.add_argument("--keys", default="X,DOWN,RIGHT,A", help="buttons, or TOUCH:X:Y")
    parser.add_argument("--wait", type=int, default=6000, help="frames to wait for it at most")
    parser.add_argument("--shots", action="store_true")
    parser.add_argument("--build", type=Path, default=species.BUILD)
    args = parser.parse_args()
    out = quiet()
    say = lambda line: print(line, file=out)  # noqa: E731
    game = species.Game(args.save, args.build)
    core, markers = game.core, game.markers
    if not core._sram:
        game.close()
        say(f"{core.name} hands no flash back: an in-game save needs melonDS DS, core.py's default")
        sys.exit(1)
    shots = [0]

    def shot(tag):
        if args.shots:
            shots[0] += 1
            game.shot().save(f"{args.out}.{shots[0]:02d}-{tag}.png")

    page = where.constant("SAVE_PAGE_MAX", "include/constants/save_arrays.h")
    sector = where.constant("SAVE_SECTOR_SIZE", "include/constants/save_arrays.h")
    save_data = markers.address("sSaveDataPtr")
    (good_at,), _ = savedit.compile_c(("__builtin_offsetof(SaveData, lastGoodSector)",))

    def counter():
        ram = core.ram()
        at = struct.unpack_from("<I", ram, save_data - MAIN_RAM)[0]
        return struct.unpack_from("<I", ram, at + 0x10 + page * sector - MAIN_RAM)[0] if at else None

    def last_good():
        ram = core.ram()
        at = struct.unpack_from("<I", ram, save_data - MAIN_RAM)[0]
        return struct.unpack_from("<H", ram, at + good_at - MAIN_RAM)[0] if at else None

    species.continue_game(game)
    game.step(200)
    start, half = counter(), last_good()
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
    # Done when the game says so (Save_WriteManFinish), not when the flash
    # has been still a while.
    for _ in range(args.wait // 30):
        if last_good() != half:
            say(f"[{core.frames}] the save is done: lastGoodSector {half} -> {last_good()}")
            break
        game.step(30)
    else:
        say(f"[{core.frames}] the save did not finish in {args.wait} frames: lastGoodSector is still {half}")
    finished = last_good() != half
    before, last = args.save.read_bytes(), ctypes.string_at(*core._sram)
    for _ in range(4):
        game.press("B", 30)
    game.close()
    if not finished or last == before:
        say(f"the game's save did not finish, or the flash did not change: {args.out} not written")
        sys.exit(1)
    args.out.write_bytes(last)
    say(f"[{core.frames}] wrote {args.out}")

if __name__ == "__main__":
    main()
