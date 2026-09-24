#!/usr/bin/env python3
"""gym.py for Whitney, and the walk her badge waits for.

    whitney.py SAVE [gym.py options]

Retail gives the Plain Badge only after the fight's aftermath: Whitney
cries, and the badge comes when the player walks south onto the trigger at
(13, 11) -- the Lass's scene (FLAG_UNK_0B7) -- then back north to Whitney
and talks to her again. gym.py alone stops after the fight with no badge.
This runs gym.py, and after the fight takes that walk and presses A until
the badge count moves, saying each step on stderr (gym.py's report is on
stdout). SAVE is whitney.sav or one like it: a scratch copy, as for gym.py.
"""
import re
import sys
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parent))
import core  # noqa: E402
import gym  # noqa: E402
from markers import DIAG_ELF, Markers  # noqa: E402
from party import badges  # noqa: E402


def main():
    if len(sys.argv) < 2 or sys.argv[1] in ("-h", "--help"):
        sys.exit(__doc__)
    markers = Markers(DIAG_ELF)
    ignore = markers.address("gDiagIgnoreCommunicationError")
    hold = [lambda c: c.poke(ignore, 1)]
    close = core.Core.close

    def say(line):
        print(line, file=sys.stderr, flush=True)

    def at(c):
        m = re.search(r"at \((\d+), (\d+)\)", markers.describe(c.ram()))
        return (int(m.group(1)), int(m.group(2))) if m else None

    def walk(c, button, done):
        for _ in range(40):
            here = at(c)
            if here and done(here):
                break
            c.press(button, 16, hold)
            c.step(4, hold)

    def then_walk(self):
        held = badges(self.ram(), DIAG_ELF)
        say(f"[{self.frames}] after the fight: at {at(self)}, badges {held}")
        walk(self, "DOWN", lambda here: here[1] >= 11)
        say(f"[{self.frames}] at {at(self)}; the Lass's scene")
        for _ in range(30):
            self.press("A", 6, hold)
            self.step(40, hold)
        say(f"[{self.frames}] after the scene: at {at(self)}")
        walk(self, "UP", lambda here: here[1] <= 5)
        self.press("UP", 4, hold)
        say(f"[{self.frames}] in front of Whitney: at {at(self)}")
        for _ in range(60):
            self.press("A", 6, hold)
            self.step(60, hold)
            try:
                now = badges(self.ram(), DIAG_ELF)
            except SystemExit:   # the field is down for a moment
                continue
            if now != held:
                say(f"[{self.frames}] badges {held} -> {now}")
                held = now
        say(f"[{self.frames}] badges held: {held} | {markers.describe(self.ram())}")
        close(self)

    core.Core.close = then_walk
    gym.main()


if __name__ == "__main__":
    main()
