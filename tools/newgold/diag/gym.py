#!/usr/bin/env python3
"""Fight what a save stands the player in front of, and report it as text.

    gym.py SAVE [--move N] [--frames N]

The ROM is the NEWGOLD_DIAG=1 build, run in-process by core.py. Nothing is
drawn and nothing is looked at: after every few frames the diagnostics'
memory says what the battle printed, who is fighting, and whether the game
is waiting for the player, and the player answers through the game's own
menus -- a touch on FIGHT, on a move, on a Pokemon -- exactly where a thumb
would go. B moves text on and declines "will you switch?".

The report is the battle's own lines, the battlers each turn, what the
trainer's AI spent, anything that asserted, and the party before and after.
"""
import argparse
import os
import struct
import sys
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parent))
from core import Core  # noqa: E402
from markers import DIAG_ELF, STATES, Markers  # noqa: E402
from party import party  # noqa: E402

ROOT = Path(__file__).resolve().parents[3]
ROM = ROOT / "build/heartgold.us.diag/pokeheartgold.us.nds"
# The bottom screen, in its own pixels (256 by 192).
FIGHT = (128, 83)
MOVES = [(64, 51), (192, 51), (64, 116), (192, 116)]
PARTY = [(64, 35), (192, 38), (64, 78), (192, 81), (64, 123), (192, 126)]
SHIFT = (127, 113)
KEEP_BATTLING = (128, 139)   # "will you switch?" -- the lower of the two
BATTLE_MAIN, EXIT = STATES.index("BATTLE_MAIN"), STATES.index("EXIT")


def quiet():
    """The core prints its own diagnostics to the process's stdout; keep ours."""
    keep = os.dup(1)
    null = os.open(os.devnull, os.O_WRONLY)
    os.dup2(null, 1)
    os.dup2(null, 2)
    return os.fdopen(keep, "w", buffering=1)


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("save", type=Path)
    parser.add_argument("--move", type=int, default=0, help="the move slot to use, 1 to 4; 0 for the first with PP")
    parser.add_argument("--frames", type=int, default=40000)
    args = parser.parse_args()

    out = quiet()
    say = lambda line: print(line, file=out)  # noqa: E731
    markers = Markers(DIAG_ELF)
    core = Core(ROM, save=args.save)
    ignore = markers.address("gDiagIgnoreCommunicationError")
    hold = [lambda c: c.poke(ignore, 1)]
    read = lambda name: markers.read(core.ram(), name)  # noqa: E731

    # Title, Continue, and the leader's lines: A until the battle is up.
    while core.frames < 6000 and read("gDiagBattleState") != BATTLE_MAIN:
        core.press("A", 6, hold)
        core.step(30, hold)
    say(f"[{core.frames}] the battle is up")
    before = None

    seen, last_view, stuck, idle, last_line = set(), None, 0, 0, ""
    refused, last_slot = set(), None   # moves the game turned down this turn: Taunt, Disable, no PP
    last_count, last_asserts, restarts = 0, 0, 0
    while core.frames < args.frames:
        core.step(4, hold)
        ram = core.ram()
        # A console reset clears the diagnostics with the rest of memory: the
        # line counter going backwards is how it shows. Say so, and start the
        # lines over, or everything after it looks like silence.
        count = markers.read(ram, "gDiagBattleTextCount")
        if count < last_count:
            restarts += 1
            say(f"[{core.frames}] the game restarted")
            seen = set()
            if restarts > 2:
                break
        last_count = count
        asserts = markers.read(ram, "gDiagAssertCount")
        if asserts != last_asserts:
            say(f"[{core.frames}] an assertion failed: " + markers.describe(ram).split("asserts ", 1)[1].split(" | ")[0])
            at = markers.address("gDiagLastMessage")
            if at is not None:
                say(f"[{core.frames}]   the last message asked for: row, tag, params = {struct.unpack_from('<5I', ram, at - 0x02000000)}")
                say(f"[{core.frames}]   the script running: archive, member, position = "
                    f"{struct.unpack_from('<3I', ram, markers.address('gDiagBattleScript') - 0x02000000)}")
            last_asserts = asserts
        for index, line in markers.text(ram):
            if index not in seen and line:
                seen.add(index)
                last_line = line
                if last_slot is not None and any(word in line for word in ("can’t use", "can't use", "is disabled", "no PP left", "can’t be used")):
                    refused.add(last_slot)
                if " used " in line and not line.startswith("The foe") and "Leader" not in line:
                    refused.clear()
                if not line.startswith("What will"):
                    say(f"[{core.frames}] {line.split('?{')[0]}")
        state = markers.read(ram, "gDiagBattleState")
        if state == EXIT:
            say(f"[{core.frames}] the battle is over")
            break
        view = markers.battle(ram)
        prompt = markers.read(ram, "gDiagBattlePrompt")
        you_hp = int(view[0].split()[3].split("/")[0]) if view and view[0].startswith("you") else 1
        if prompt in (1, 2):
            if view != last_view:
                say(f"[{core.frames}]   " + "\n          ".join(view[:-1]))
                last_view = view
            core.touch(*FIGHT, 6, hold)
            core.step(20, hold)
        elif prompt in (3, 4):
            moves = view[0].split("|")[1].split(",")
            usable = [i for i, part in enumerate(moves) if not part.strip().endswith(" 0") and i not in refused]
            slot = args.move - 1 if 1 <= args.move <= 4 and args.move - 1 not in refused else (usable or [0])[0]
            last_slot = slot
            core.touch(*MOVES[slot], 6, hold)
            core.step(20, hold)
        elif you_hp == 0 and state == BATTLE_MAIN:
            stuck += 1
            if stuck > 60:
                # The party screen after a faint, in the battle's own order:
                # the first Pokemon with HP left is the one to send.
                species = struct.unpack_from("<6H", ram, markers.address("gDiagPartySpecies") - 0x02000000)
                hp = struct.unpack_from("<6H", ram, markers.address("gDiagPartyHp") - 0x02000000)
                alive = [i for i in range(6) if species[i] and hp[i]]
                if alive:
                    core.touch(*PARTY[alive[0]], 6, hold)
                    core.step(30, hold)
                    core.touch(*SHIFT, 6, hold)
                    core.step(60, hold)
                stuck = 0
        elif "Will you switch" in last_line:
            core.touch(*KEEP_BATTLING, 6, hold)
            core.step(30, hold)
            last_line = ""
        else:
            stuck = 0
            idle += 1
            if idle % 8 == 0:
                core.press("B", 4, hold)

    ram = core.ram()
    say(f"[{core.frames}] trainer items {markers.read(ram, 'gDiagAiItemCount')}")
    say("at the end: " + markers.describe(ram))
    if markers.read(ram, "gDiagBattleState") != EXIT:
        say("the battle did not finish; last prompt " + str(markers.read(ram, "gDiagBattlePrompt"))
            + ", last line: " + repr(last_line[:80]))
    try:
        say("party at the end:\n  " + "\n  ".join(party(ram, DIAG_ELF)))
    except SystemExit as field_down:
        say(f"party: {field_down}")
    core.close()


if __name__ == "__main__":
    main()
