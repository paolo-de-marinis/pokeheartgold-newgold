#!/usr/bin/env python3
"""Boot a built ROM in an emulator and look at what comes up.

Every test beside this one reads source or data. None of them can tell whether
the ROM starts, and the changes that would stop it starting — the save region,
the heaps — are exactly the ones whose failure is a silent assertion at boot
rather than a build error.

This drives the melonDS libretro core directly, with no emulator front end and
no BIOS of its own: boot_check.c is a headless libretro host, about two hundred
lines, that loads a ROM, runs frames, presses buttons, touches the screen and
writes out what was on it.

    smoke.py --frames 3000 --shot 2999 --out /tmp/shots

Usage without arguments boots both ROMs far enough to know they are running.

boot_check.c takes its actions on the command line, one per argument:

    press:FRAME:LEN:BUTTON          a joypad button, by libretro's id
    mash:FROM:UNTIL:PERIOD:LEN:BUTTON   the same, every PERIOD frames
    touch:FRAME:LEN:X:Y             the touch screen, in its own pixels
    tap:FROM:UNTIL:PERIOD:LEN:X:Y   the same, every PERIOD frames
    shot:FRAME:PATH                 write the framebuffer out
    save:FRAME:PATH                 write the emulator's state out
    load:PATH                       start from a state instead of a boot

The last two are what make anything past the opening practical: reaching the
overworld by script is twenty thousand frames of tutorial, and a state taken
there costs one frame to return to.
"""

import argparse
import shutil
import struct
import subprocess
import sys
import tempfile
import zlib
from pathlib import Path

ROOT = Path(__file__).resolve().parents[2]
HOST = Path(__file__).resolve().parent / "boot_check.c"
CORE = Path("/usr/lib/libretro/melonds_libretro.so")
ROMS = {
    "heartgold": ROOT / "build/heartgold.us/pokeheartgold.us.nds",
    "soulsilver": ROOT / "build/soulsilver.us/pokesoulsilver.us.nds",
}

# Enough to get past the publisher screens, the intro and the title, which is
# where a save or heap that does not fit would have stopped it.
OPENING = ["press:1000:10:8", "press:1200:10:3", "press:1500:10:8",
           "press:1800:10:3", "press:2100:10:8", "press:2400:10:8"]


def build(into):
    host = Path(into) / "boot_check"
    result = subprocess.run(["cc", "-O2", "-o", str(host), str(HOST), "-ldl"],
                            capture_output=True, text=True)
    if result.returncode != 0:
        raise SystemExit(result.stderr.strip())
    return host


def run(host, rom, frames, actions, workdir):
    system = Path(workdir) / "system"
    system.mkdir(exist_ok=True)
    result = subprocess.run([str(host), str(CORE), str(rom), str(system), str(frames)] + actions,
                            capture_output=True, text=True, timeout=900)
    ran = [l for l in result.stdout.splitlines() if l.startswith("ran ")]
    if not ran:
        raise SystemExit(f"{rom.name} did not run: {result.stdout} {result.stderr[-400:]}")
    return ran[0]


def to_png(source, destination):
    data = source.read_bytes()
    fields, at = [], 0
    while len(fields) < 4:
        while data[at:at + 1].isspace():
            at += 1
        end = at
        while not data[end:end + 1].isspace():
            end += 1
        fields.append(data[at:end])
        at = end
    at += 1
    width, height = int(fields[1]), int(fields[2])
    pixels = data[at:at + width * height * 3]
    raw = b"".join(b"\x00" + pixels[y * width * 3:(y + 1) * width * 3] for y in range(height))
    def chunk(kind, body):
        return struct.pack(">I", len(body)) + kind + body + struct.pack(">I", zlib.crc32(kind + body))
    destination.write_bytes(b"\x89PNG\r\n\x1a\n"
                            + chunk(b"IHDR", struct.pack(">IIBBBBB", width, height, 8, 2, 0, 0, 0))
                            + chunk(b"IDAT", zlib.compress(raw, 6))
                            + chunk(b"IEND", b""))


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--frames", type=int, default=3000)
    parser.add_argument("--shot", type=int, action="append", default=[])
    parser.add_argument("--out", type=Path)
    parser.add_argument("--rom", choices=sorted(ROMS), action="append", default=[])
    args = parser.parse_args()

    if not CORE.exists():
        raise SystemExit(f"{CORE} is not installed")
    out = args.out or Path(tempfile.mkdtemp(prefix="newgold-smoke-"))
    out.mkdir(parents=True, exist_ok=True)

    with tempfile.TemporaryDirectory(prefix="newgold-smoke-") as temp:
        host = build(temp)
        for name in args.rom or sorted(ROMS):
            rom = ROMS[name]
            if not rom.exists():
                print(f"  {name}: not built")
                continue
            shots = args.shot or [args.frames - 1]
            actions = OPENING + [f"shot:{at}:{Path(temp) / f'{name}-{at}.ppm'}" for at in shots]
            line = run(host, rom, args.frames, actions, temp)
            for at in shots:
                ppm = Path(temp) / f"{name}-{at}.ppm"
                if ppm.exists():
                    to_png(ppm, out / f"{name}-{at}.png")
            print(f"  {name}: {line}")
    print(f"captures in {out}")


if __name__ == "__main__":
    main()
