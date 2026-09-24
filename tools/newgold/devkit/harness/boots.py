#!/usr/bin/env python3
"""Boot a ROM at many console clocks; read the arena and the screen each time.

    boots.py BUILD OUT [--frames 900] [--base 1700000000] [--jobs 4] OFFSET...

The boot takes a random pre-size of up to 0x100 bytes from the main arena,
seeded by the console's clock, before the heaps; a ROM whose arena is short
boots white at some seconds and not others. test_boot boots at one pinned
second and works out the worst pre-size from the map; this boots at many,
BASE + each OFFSET seconds (A:B for the range A..B-1), through boot_check's
clock:, and says for each: whether it ran and drew, the pre-size drawn, the
arena left, and what would be left at the largest pre-size -- then the
worst of them. BUILD is a build directory (build/heartgold.us.diag, ...);
a diagnostics build also prints markers.describe. Dumps go under OUT and are
removed as they are read.
"""
import argparse
import struct
import sys
from concurrent.futures import ThreadPoolExecutor
from pathlib import Path

HERE = Path(__file__).resolve().parent
sys.path[:0] = [str(HERE), str(HERE.parent / "diag")]
import smoke  # noqa: E402
import where  # noqa: E402
from markers import Markers  # noqa: E402

ARENA_INFO = 0x027FFDA0   # OSArenaInfo: lo[9] then hi[9]; lo[0] and hi[0] are the main arena
MAX_PRESIZE = 0x100


def word(ram, address):
    at = (address - 0x02000000) % len(ram)
    return struct.unpack_from("<I", ram, at)[0]


def main():
    parser = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    parser.add_argument("build", type=Path)
    parser.add_argument("out", type=Path)
    parser.add_argument("offsets", nargs="+")
    parser.add_argument("--frames", type=int, default=900)
    parser.add_argument("--base", type=int, default=1700000000)
    parser.add_argument("--jobs", type=int, default=4)
    args = parser.parse_args()
    offsets = []
    for a in args.offsets:
        lo, _, hi = a.partition(":")
        offsets += range(int(lo), int(hi)) if hi else [int(lo)]
    args.out.mkdir(parents=True, exist_ok=True)
    host = smoke.build(args.out)
    rom = next(args.build.glob("*.nds"))
    start = next(int(line.split()[0][2:], 16) for line in (args.build / "main.elf.xMAP").read_text().splitlines()
                 if "SDK_MAIN_ARENA_LO" in line)
    heap_info = where._elf(args.build / "main.elf")["sHeapInfo"][0]
    markers = Markers(args.build / "main.elf") if args.build.name.endswith("diag") else None
    frames = args.frames

    def boot(k):
        run = args.out / f"t{k:06d}"
        run.mkdir(parents=True, exist_ok=True)
        try:
            line = smoke.run(host, rom, frames, [f"clock:{args.base + k}", f"ram:{frames - 1}:{run / 'r.bin'}",
                                                 f"shot:{frames - 1}:{run / 's.ppm'}"], run)
        except SystemExit as stopped:
            return k, f"did not run: {stopped}", 0, None, None, ""
        ram = (run / "r.bin").read_bytes()
        pixels = (run / "s.ppm").read_bytes()
        body = pixels[pixels.index(b"255\n") + 4:]
        colours = len(set(body[j:j + 3] for j in range(0, len(body), 3)))
        (run / "r.bin").unlink()
        lo, hi = word(ram, ARENA_INFO), word(ram, ARENA_INFO + 36)
        presize = word(ram, heap_info) - start
        extra = f" | {markers.describe(ram)}" if markers else ""
        return k, line, colours, presize, hi - lo, extra

    with ThreadPoolExecutor(args.jobs) as pool:
        results = list(pool.map(boot, offsets))
    blank, margins = 0, []
    for k, line, colours, presize, left, extra in results:
        stopped = colours <= 8 or not line.startswith(f"ran {frames}")
        blank += stopped
        arena = ""
        if left is not None:
            margins.append(left + presize - MAX_PRESIZE)
            arena = f"; pre-size {presize:#x}; left {left:#x}; at the largest pre-size {margins[-1]:#x}"
        print(f"{args.build.name} +{k}: {line}; colours {colours}{arena}{extra}{'  <<< BLANK OR STOPPED' if stopped else ''}")
    print(f"== {args.build.name}: {len(results)} boots, arena from {start:#010x}, pre-sizes "
          f"{sorted({hex(r[3]) for r in results if r[3] is not None})}, least left at the largest pre-size "
          f"{min(margins):#x}, blank or stopped {blank}" if margins else f"== {args.build.name}: nothing ran")
    sys.exit(1 if blank or not margins or min(margins) < 0 else 0)


if __name__ == "__main__":
    main()
