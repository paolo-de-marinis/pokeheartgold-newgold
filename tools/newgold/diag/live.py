#!/usr/bin/env python3
"""Read the game somebody is playing in melonDS, without touching it.

    live.py [--follow] [ELF]

melonDS keeps the console's main RAM in a shared mapping its own process holds
open, so /proc/PID/fd/N is the emulated memory, live. With --follow a reading
is printed every few seconds, until Ctrl-C, and only when it changes.

The ELF has to be the one the running ROM was linked from: every symbol moves
with every build. The default is the NEWGOLD_DIAG=1 build's.
"""
import os
import sys
import time
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parent))
from markers import DIAG_ELF, Markers  # noqa: E402


def main_ram():
    pids = os.popen("pgrep -x melonDS").read().split()
    if not pids:
        raise SystemExit("melonDS is not running")
    for fd in os.listdir(f"/proc/{pids[0]}/fd"):
        try:
            if "melondsfastmem" in os.readlink(f"/proc/{pids[0]}/fd/{fd}"):
                with open(f"/proc/{pids[0]}/fd/{fd}", "rb") as f:
                    return f.read(4 * 1024 * 1024)
        except OSError:
            continue
    raise SystemExit("melonDS has no fastmem mapping open; is a ROM loaded?")


def main():
    args = [a for a in sys.argv[1:] if not a.startswith("--")]
    markers = Markers(Path(args[0]) if args else DIAG_ELF)
    if "--follow" not in sys.argv:
        print(markers.describe(main_ram()))
        return
    last = None
    while True:
        line = markers.describe(main_ram())
        if line != last:
            print(time.strftime("%H:%M:%S"), line, flush=True)
            last = line
        time.sleep(2)


if __name__ == "__main__":
    main()
