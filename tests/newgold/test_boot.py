#!/usr/bin/env python3
"""Boot both ROMs in an emulator.

Every other test here reads source or data, and none of them can tell whether
the ROM starts. The changes most likely to stop it starting are the ones this
port keeps making — the save region, the heaps — and they fail as an assertion
at boot rather than as a build error, which is to say silently.

The run is short on purpose: far enough to know the ROM is executing and
drawing, not far enough to be a play session. tools/newgold/smoke.py takes it
further when a change deserves it.
"""

import subprocess
import sys
import tempfile
import unittest
from pathlib import Path

from test_level_cap import ROOT

sys.path.insert(0, str(ROOT / "tools/newgold"))
import smoke  # noqa: E402

FRAMES = 900


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
        line = smoke.run(self.host, rom, FRAMES, [f"shot:{FRAMES - 1}:{shot}"], self.temp.name)
        self.assertIn(f"ran {FRAMES} frames", line)
        self.assertTrue(shot.exists(), f"{name} drew nothing")
        pixels = shot.read_bytes()
        # A ROM that stopped early leaves the screen one flat colour.
        body = pixels[pixels.index(b"255\n") + 4:]
        self.assertGreater(len(set(body[i:i + 3] for i in range(0, len(body), 3))), 8,
                           f"{name} is showing a blank screen")
        print(f"PASS: {name} {line}, screen has content.")

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


if __name__ == "__main__":
    unittest.main()
