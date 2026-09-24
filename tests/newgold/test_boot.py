#!/usr/bin/env python3
"""Boot both ROMs, and both diagnostics builds, in an emulator.

Every other test here reads source or data, and none of them can tell whether
the ROM starts. The changes most likely to stop it starting are the ones this
port keeps making — the save region, the heaps — and they fail as an assertion
at boot rather than as a build error, which is to say silently.

The run is short on purpose: far enough to know the ROM is executing and
drawing, not far enough to be a play session. tools/newgold/devkit/harness/smoke.py takes it
further when a change deserves it.

The boot draws a random pre-size of up to 0x100 bytes from the main arena,
seeded by the console's clock, which the emulator takes from the host's. So
the same ROM booted white in some runs and not in others while the arena was
short: the test boots at a fixed clock, which gives the same screen every
run, and measures the arena the boot left against the largest pre-size.
"""

import re
import struct
import subprocess
import sys
import tempfile
import time
import unittest
from pathlib import Path

from test_heaps import MAX_PRESIZE, arena_lo
from test_level_cap import ROOT

sys.path[:0] = [str(ROOT / "tools/newgold" / sub) for sub in ("import", "devkit", "devkit/harness", "devkit/diag")]
import smoke  # noqa: E402

FRAMES = 900
CLOCK = smoke.CLOCK          # any fixed second: 2023-11-14 22:13:20 UTC
MAIN_MEMORY = 0x02000000     # the ram: dump starts here, 4 MB, mirrored above
ARENA_INFO = 0x027FFDA0      # HW_ARENA_INFO_BUF: OSArenaInfo, lo[9] then hi[9]
RTC = 0x027FFDE8             # OSSystemWork.real_time_clock: the date in BCD first


def arena(build, ram):
    """The pre-size the boot drew and the main arena it left, from a dump of
    main memory: Heap_InitSystem puts the heap table right after the
    pre-size, and nothing takes from the arena after the boot."""
    heap_info = re.search(r"^\s+([0-9A-F]{8}) [0-9A-F]{8} \.bss\s+sHeapInfo\s", (build / "main.elf.xMAP").read_text(), re.M)
    table = struct.unpack_from("<I", ram, int(heap_info.group(1), 16) - MAIN_MEMORY)[0]
    info = (ARENA_INFO - MAIN_MEMORY) % len(ram)
    lo, hi = struct.unpack_from("<I", ram, info)[0], struct.unpack_from("<I", ram, info + 36)[0]
    return table - arena_lo(build), hi - lo


class BootTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        if not smoke.CORE.exists():
            raise unittest.SkipTest(f"{smoke.CORE} is not installed")
        missing = [name for name, rom in smoke.ROMS.items() if not rom.exists()]
        if missing:
            raise unittest.SkipTest(f"not built: {', '.join(missing)}")
        cls.temp = tempfile.TemporaryDirectory(prefix="newgold-boot-")
        cls.host = smoke.build(cls.temp.name)

    @classmethod
    def tearDownClass(cls):
        if hasattr(cls, "temp"):
            cls.temp.cleanup()

    def boot(self, name, rom=None):
        rom = rom or smoke.ROMS[name]
        shot = Path(self.temp.name) / f"{name}.ppm"
        ram = Path(self.temp.name) / f"{name}.ram"
        line = smoke.run(self.host, rom, FRAMES,
                         [f"clock:{CLOCK}", f"shot:{FRAMES - 1}:{shot}", f"ram:{FRAMES - 1}:{ram}"], self.temp.name)
        self.assertIn(f"ran {FRAMES} frames", line)
        self.assertTrue(shot.exists(), f"{name} drew nothing")
        dump = ram.read_bytes()
        at = (RTC - MAIN_MEMORY) % len(dump)
        self.assertEqual(dump[at:at + 3].hex(), time.strftime("%y%m%d", time.gmtime(CLOCK)),
                         f"{name}'s console date is not the pinned clock's")
        presize, left = arena(rom.parent, dump)
        pixels = shot.read_bytes()
        # A ROM that stopped early leaves the screen one flat colour.
        body = pixels[pixels.index(b"255\n") + 4:]
        self.assertGreater(len(set(body[i:i + 3] for i in range(0, len(body), 3))), 8,
                           f"{name} is showing a blank screen (pre-size {presize:#x}, "
                           f"{left:#x} of the main arena left)")
        self.assertGreaterEqual(
            left - (MAX_PRESIZE - presize), 0,
            f"{name} booted at a pre-size of {presize:#x} with {left:#x} of the main arena "
            f"left; at the largest, {MAX_PRESIZE:#x}, the file system's table would not fit "
            "and the screen would stay white")
        print(f"PASS: {name} {line}, screen has content; {left - (MAX_PRESIZE - presize):#x} "
              f"of the main arena left at the largest pre-size.")

    def test_heartgold_boots(self):
        self.boot("heartgold")

    def test_soulsilver_boots(self):
        self.boot("soulsilver")

    def test_heartgold_with_diagnostics_boots(self):
        # The diagnostics add to the static module, and the main arena after
        # boot is tight: this is where too much of them shows up.
        if not smoke.DIAG_ROM.exists():
            self.skipTest("not built: make NEWGOLD_DIAG=1 COMPARE=0")
        self.boot("heartgold.diag", smoke.DIAG_ROM)

    def test_soulsilver_with_diagnostics_boots(self):
        rom = ROOT / "build/soulsilver.us.diag/pokesoulsilver.us.nds"
        if not rom.exists():
            self.skipTest("not built: make NEWGOLD_DIAG=1 GAME_VERSION=SOULSILVER COMPARE=0")
        self.boot("soulsilver.diag", rom)


class ClockTests(unittest.TestCase):
    def test_a_run_is_at_the_pinned_clock_unless_told(self):
        # The other harness tools (diag/battle.py, smoke.py's routes) name no
        # clock; at the host's, the RNG and the time of day followed the
        # second the run started in. A stand-in host says what it was given.
        with tempfile.TemporaryDirectory(prefix="newgold-clock-") as temp:
            host = Path(temp) / "host"
            host.write_text('#!/bin/sh\necho "ran $*"\n')
            host.chmod(0o755)
            self.assertIn(f" clock:{CLOCK} ", smoke.run(host, "rom", 1, ["shot:0:x"], temp) + " ")
            self.assertNotIn(f"clock:{CLOCK}", smoke.run(host, "rom", 1, ["clock:-1"], temp))

    def test_the_in_process_core_is_at_the_pinned_clock(self):
        # diag/core.py's scripts (gym.py, pc.py, species.py) load the core
        # into Python, where it binds the C library's time(): pin_clock()
        # runs the script again with one that answers the pinned second.
        script = "import core, ctypes; core.pin_clock(); print(ctypes.CDLL(None).time(None))"
        result = subprocess.run([sys.executable, "-c", script], capture_output=True, text=True,
                                cwd=ROOT / "tools/newgold/devkit/diag")
        self.assertEqual(result.stdout.strip(), str(CLOCK), result.stderr)


if __name__ == "__main__":
    unittest.main()
