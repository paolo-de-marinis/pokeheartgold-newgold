#!/usr/bin/env python3
"""The battle scripts a turn runs through, frame by frame.

    trace.py SAVE [--touch X,Y,WAIT ...] [--frames N] [--build DIR]

Continues the save, presses A until a battle starts (a trainer the save
stands in front of, as gym.py does), waits for the first command prompt,
plays the touches given -- bottom-screen pixels, then frames to wait -- and
then prints, for N frames, every change of the script the battle runs
(gDiagBattleScript: archive and member, with the position it is at) and of
the controller's command (gDiagBattleCommand), each with its frame. The touches are the
turn to watch: with Ally Switch second in the first battler's moves,
FIGHT, the move, then FIGHT and the second battler's move and target:

    trace.py twins.sav --touch 128,84,40 --touch 192,59,60 --touch 60,116,60 \\
        --touch 128,84,40 --touch 64,114,40 --touch 195,116,0

DIR is the NEWGOLD_DIAG=1 build (default build/heartgold.us.diag).
"""
import argparse
import struct
import sys
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parent))
import species  # noqa: E402
from gym import quiet  # noqa: E402
from markers import MAIN_RAM, STATES  # noqa: E402


def main():
    parser = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    parser.add_argument("save", type=Path)
    parser.add_argument("--touch", action="append", default=[], help="X,Y,WAIT")
    parser.add_argument("--frames", type=int, default=2400)
    parser.add_argument("--build", type=Path, default=species.BUILD)
    args = parser.parse_args()
    out = quiet()
    say = lambda line: print(line, file=out)  # noqa: E731
    game = species.Game(args.save, args.build)
    battle_main = STATES.index("BATTLE_MAIN")
    species.continue_game(game)
    for _ in range(60):
        game.press("A", 40)
        if game.read("gDiagBattleState"):
            break
    for _ in range(400):
        game.step(10)
        if game.read("gDiagBattleState") == battle_main and game.read("gDiagBattlePrompt") in (1, 2):
            break
    else:
        sys.exit("no command prompt: " + game.markers.describe(game.core.ram()))
    say(f"[{game.core.frames}] the first command prompt")
    game.step(120)
    for touch in args.touch:
        x, y, wait = map(int, touch.split(","))
        game.touch(x, y, wait)
    script = game.markers.address("gDiagBattleScript") - MAIN_RAM
    last = None
    for frame in range(args.frames):
        game.step(1)
        ram = game.core.ram()
        archive, member, position = struct.unpack_from("<3I", ram, script)
        now = (archive, member, game.markers.read(ram, "gDiagBattleCommand"))
        if now != last:
            say(f"{frame}: script {archive}/{member} at {position:#x}, command {now[2]}")
            last = now
    say(game.markers.describe(game.core.ram()))
    game.close()


if __name__ == "__main__":
    main()
