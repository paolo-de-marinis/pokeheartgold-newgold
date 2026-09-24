#!/usr/bin/env python3
"""Drive the diagnostics ROM from a save with a list of steps, measuring the
boot heaps scene by scene (lens.py).

    drive.py SAVE OUTDIR STEP...          (NOIGNORE=1: the communication error is shown)

Steps:
  A B X Y L R START SELECT UP DOWN LEFT RIGHT   press it; BUTTON*N repeats,
                                                 /W waits W frames after each
  w:N                 run N frames
  t:X,Y[/W]           touch the bottom screen at (X, Y)
  shot:NAME           save the next frame as NAME.png
  scene:NAME          a new scene starts here (the one before ends)
  end                 the scene ends
  continue            A until the field is up
  battle:SPECIES      a wild battle against it at the next step, up to the command prompt
  fight[:SLOT]        answer every prompt with that move (default 1) until the battle exits
  runaway             RUN until the battle exits
  ball:X,Y;X,Y;...    at the command prompt, touch these in order (the bag route to a ball)
  state:NAME:MAX      run until gDiagBattleState is NAME, at most MAX frames
  heap:ID:MAX         press A until heap ID has allocated (is in the low-water table)
  hold:BUTTON:N       hold a button N frames (a walk)
  pos                 log where the player stands
  menu:NAME           open the start menu's dex, card, mon, save, bag, options or
                      gear with the pad (a touch right after Continue is lost)
  openpc              A at a PC until the storage system is open, in Move mode
  text                log the lines the battle printed
  commerr[:CODE]      raise a communication error, as a link that drops would
"""
import json
import sys
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parent))
from lens import TREE, Lens  # noqa: E402
from markers import STATES  # noqa: E402
import species as sp  # noqa: E402

FIGHT, RUN = (128, 83), (128, 170)
MOVES = [(64, 51), (192, 51), (64, 116), (192, 116)]


def main():
    if len(sys.argv) < 4:
        sys.exit(__doc__)
    save, out, steps = Path(sys.argv[1]), Path(sys.argv[2]), sys.argv[3:]
    out.mkdir(parents=True, exist_ok=True)
    sp.quiet_keep = None
    logf = open(out / "log.txt", "w", buffering=1)
    say = lambda s: print(s, file=logf)  # noqa: E731
    game = sp.Game(save)
    import os
    if os.environ.get("NOIGNORE"):
        game.hold.clear()   # the communication error is shown, as on a DS with no partner
    lens = Lens(game.core, game.markers, log=say)
    game.hold.append(lens.hook)
    lens.begin("continue from the save: title, main menu, load the field")
    read = lambda n: game.markers.read(game.core.ram(), n)  # noqa: E731
    # The start menu: a grid of two columns, the cursor remembered between
    # openings (touches on it are lost right after Continue, so the pad).
    grid = {"dex": (0, 0), "card": (1, 0), "mon": (0, 1), "save": (1, 1), "bag": (0, 2),
            "options": (1, 2), "gear": (0, 3)}
    cursor = [0, 0]
    try:
        for step in steps:
            if step.startswith("scene:"):
                lens.begin(step[6:])
            elif step == "end":
                lens.end()
            elif step == "continue":
                sp.continue_game(game)
                say(f"[{game.core.frames}] field up")
            elif step.startswith("w:"):
                game.step(int(step[2:]))
            elif step.startswith("t:"):
                spec, _, wait = step[2:].partition("/")
                x, y = map(int, spec.split(","))
                game.touch(x, y, int(wait or 20))
            elif step.startswith("shot:"):
                game.shot().save(out / f"{step[5:]}.png")
            elif step.startswith("battle:"):
                game.core.poke(game.markers.address("gDiagForceBattleSpecies"), int(step[7:]), 2)
                for button in ("DOWN", "UP"):
                    game.core.press(button, 16, game.hold)
                    if read("gDiagBattleState") not in (0, STATES.index("EXIT")) or read("gDiagWildStage"):
                        break
                for _ in range(600):
                    game.step(10)
                    if read("gDiagBattleState") == STATES.index("BATTLE_MAIN") and read("gDiagBattlePrompt") in (1, 2):
                        break
                say(f"[{game.core.frames}] battle: {game.markers.describe(game.core.ram())}")
                say("   " + " / ".join(game.markers.battle(game.core.ram())))
            elif step.startswith("fight") or step == "runaway":
                slot = int(step.split(":")[1]) - 1 if ":" in step else 0
                for _ in range(3000):
                    game.step(4)
                    state, prompt = read("gDiagBattleState"), read("gDiagBattlePrompt")
                    if state == STATES.index("EXIT") or state == 0 and read("gDiagBattleTicks") > 0:
                        break
                    if prompt in (1, 2):
                        game.touch(*(RUN if step == "runaway" else FIGHT), 20)
                    elif prompt in (3, 4):
                        game.touch(*MOVES[slot], 20)
                    elif prompt in (5, 6):
                        game.touch(60, 44, 20)       # the left foe (sTouchscreenRectTargetMenuButtons)
                    elif prompt in (9, 10):
                        # a Pokemon fainted: the first party slot with HP that is not out
                        import struct as _s
                        ram = game.core.ram()
                        hp = _s.unpack_from("<6H", ram, game.markers.address("gDiagPartyHp") - 0x02000000)
                        spc = _s.unpack_from("<6H", ram, game.markers.address("gDiagPartySpecies") - 0x02000000)
                        alive = [i for i in range(6) if spc[i] and hp[i]]
                        spots = [(64, 35), (192, 38), (64, 78), (192, 81), (64, 123), (192, 126)]
                        if alive:
                            game.touch(*spots[alive[-1]], 30)
                            game.touch(127, 113, 60)
                    else:
                        game.press("B", 4)
                say(f"[{game.core.frames}] after {step}: {game.markers.describe(game.core.ram())}")
                say("   " + " / ".join(game.markers.battle(game.core.ram())))
            elif step.startswith("ball:"):
                for _ in range(600):
                    if read("gDiagBattlePrompt") in (1, 2):
                        break
                    game.step(10)
                for spot in step[5:].split(";"):
                    x, y = map(int, spot.split(","))
                    game.touch(x, y, 60)
                say(f"[{game.core.frames}] after {step}: {game.markers.describe(game.core.ram())}")
            elif step.startswith("hold:"):
                _, button, frames = step.split(":")
                game.core.press(button, int(frames), game.hold)
            elif step == "pos":
                say(f"[{game.core.frames}] " + game.markers.describe(game.core.ram()).split(" | ")[0])
            elif step.startswith("menu:"):
                x, y = grid[step[5:]]
                game.press("X", 60)
                while cursor[1] != y:
                    game.press("DOWN" if y > cursor[1] else "UP", 15)
                    cursor[1] += 1 if y > cursor[1] else -1
                while cursor[0] != x:
                    game.press("RIGHT" if x > cursor[0] else "LEFT", 15)
                    cursor[0] += 1 if x > cursor[0] else -1
                game.press("A", 300)
            elif step.startswith("commerr"):
                # A communication error, as a link that drops would raise it:
                # the comm work's error byte (sub_020399B8 reads +0x56) set,
                # and the harness's own switch that ignores such errors off.
                import struct as _s
                fn = game.markers.address("sub_020399B8") & ~1
                sbin = (TREE / "build/heartgold.us.diag/main.sbin").read_bytes()
                work = _s.unpack_from("<I", sbin, fn - 0x02000000 + 0x20)[0]   # its literal: =_021D4150
                game.hold.pop(0)
                game.core.poke(game.markers.address("gDiagIgnoreCommunicationError"), 0)
                ptr = lens.u32(work)
                say(f"[{game.core.frames}] comm work at {ptr:#x}")
                if ptr:
                    game.core.poke(ptr + 0x56, int(step.split(":")[1]) if ":" in step else 5, 1)
            elif step == "openpc":
                game.open_pc()
            elif step == "text":
                for index, line in game.markers.text(game.core.ram()):
                    say(f"   text {index}: {line}")
            elif step.startswith("state:"):
                _, name, most = step.split(":")
                for _ in range(int(most) // 10):
                    if read("gDiagBattleState") == STATES.index(name):
                        break
                    game.step(10)
                say(f"[{game.core.frames}] state {STATES[read('gDiagBattleState')]}")
            elif step.startswith("heap:"):
                _, hid, most = step.split(":")
                name = f"HEAP_ID_{hid}"
                for _ in range(int(most)):
                    game.press("A", 40)
                    if name in game.markers.heaps(game.core.ram()):
                        break
                say(f"[{game.core.frames}] heap {hid}: {name in game.markers.heaps(game.core.ram())}")
            else:
                spec, _, wait = step.partition("/")
                button, _, times = spec.partition("*")
                for _ in range(int(times or 1)):
                    game.press(button, int(wait or 20))
    finally:
        lens.end()
        say("at the end: " + game.markers.describe(game.core.ram()))
        say("child heaps least left: " + json.dumps({k: hex(v) for k, v in game.markers.heaps(game.core.ram()).items()}))
        lens.dump(out / "lens.json")
        game.close()


if __name__ == "__main__":
    main()
