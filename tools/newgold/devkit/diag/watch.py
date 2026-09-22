#!/usr/bin/env python3
"""Follow the battle in the melonDS that is running, as text.

    watch.py [--once] [ELF]

Prints every line the battle prints, as it prints it, and the battlers each
time the game waits for the player -- the whole screen in a few lines, read
from the diagnostics build's memory without touching the emulator. --once
prints what is there now and stops.
"""
import sys
import time
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parent))
from live import main_ram  # noqa: E402
from markers import DIAG_ELF, Markers  # noqa: E402


def main():
    args = [a for a in sys.argv[1:] if not a.startswith("--")]
    markers = Markers(Path(args[0]) if args else DIAG_ELF)
    seen, last_view = set(), None
    while True:
        ram = main_ram()
        if not markers.matches(ram):
            raise SystemExit("the game running is not the build this ELF is from; reopen the ROM")
        for index, line in markers.text(ram):
            if index not in seen and line:
                seen.add(index)
                print(line, flush=True)
        view = markers.battle(ram)
        if view and view != last_view and (view[-1].startswith("prompt: choose") or "--once" in sys.argv):
            print("  " + "\n  ".join(view), flush=True)
            last_view = view
        if "--once" in sys.argv:
            return
        time.sleep(0.5)


if __name__ == "__main__":
    main()
