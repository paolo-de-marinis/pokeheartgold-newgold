#!/usr/bin/env python3
"""Every scenario in tests/newgold/scenarios, played on the diagnostics ROM.

A scenario (tools/newgold/devkit/diag/scene.py says what one holds) is a
save, the steps played from it and what the game's memory and its battle
lines have to show afterwards: a harness run with expectations, so what was
seen running once is checked every time. Each file is a test of its own
here -- `-k NAME` runs one -- played by scene.py in a process of its own,
since the core it drives pins the clock by starting its process again.

The ROM is the NEWGOLD_DIAG=1 HeartGold build; without it, or without the
libretro core, or without the save a scenario starts from (Paolo's saves,
~/hgss-saves), a test is skipped and says why.
"""
import json
import os
import subprocess
import sys
import unittest

from test_level_cap import ROOT

DIAG = ROOT / "tools/newgold/devkit/diag"
SCENARIOS = ROOT / "tests/newgold/scenarios"
ROM = ROOT / "build/heartgold.us.diag/pokeheartgold.us.nds"
ELF = ROOT / "build/heartgold.us.diag/main.elf"
CORE = "/usr/lib/libretro/melonds_libretro.so"

sys.path.insert(0, str(DIAG))
import scene  # noqa: E402


class ScenarioFileTests(unittest.TestCase):
    def test_every_scenario_is_one_scene_py_can_play(self):
        # A typo in a step or an expectation is found here, without the
        # emulator, rather than twenty seconds into a run.
        for path in sorted(SCENARIOS.glob("*.json")):
            with self.subTest(path.name):
                spec = json.loads(path.read_text())
                self.assertLessEqual(set(spec), {"about", "save", "edit", "hold", "steps", "expect"})
                self.assertTrue(spec.get("about") and spec.get("save") and spec.get("steps"))
                self.assertEqual([s for s in spec["steps"] if not scene.readable(s)], [])
                self.assertEqual([k for k in spec.get("expect", {}) if not scene.readable(k, key=True)], [])
                self.assertTrue(all(name.startswith("gDiag") for name in spec.get("hold", {})))

    def test_an_expectation_reads_what_it_names(self):
        # The checks themselves, on values given rather than read.
        self.assertTrue(scene.Scene.wanted("x", 663)[0](663))
        self.assertFalse(scene.Scene.wanted("x", 663)[0](664))
        self.assertTrue(scene.Scene.wanted("badges", [1, 8])[0](8))
        self.assertFalse(scene.Scene.wanted("badges", [1, 8])[0](0))
        self.assertTrue(scene.Scene.wanted("battler1.status", "BRN")[0](1 << 4))
        self.assertFalse(scene.Scene.wanted("battler1.status", "BRN")[0](0))
        self.assertTrue(scene.Scene.wanted("battler1.status", "")[0](0))
        self.assertTrue(scene.Scene.wanted("map", "MAP_ROUTE_29")[0](33))


def play(path):
    def test(self):
        for needed, how in ((ROM, "make NEWGOLD_DIAG=1 COMPARE=0 build/heartgold.us.diag/pokeheartgold.us.nds"),
                            (ELF, "the same build"), (CORE, "the melonDS libretro core")):
            if not os.path.exists(needed):
                self.skipTest(f"{needed} is not there: {how}")
        run = subprocess.run([sys.executable, str(DIAG / "scene.py"), "--scenario", str(path)],
                             capture_output=True, text=True, timeout=1800)
        report = run.stdout.strip() or run.stderr.strip()[-2000:]
        if report.startswith("SKIP"):
            self.skipTest(report)
        print(report.splitlines()[0])
        self.assertEqual(run.returncode, 0, report)
        self.assertTrue(report.startswith("PASS"), report)
    return test


class ScenarioTests(unittest.TestCase):
    pass


for _path in sorted(SCENARIOS.glob("*.json")):
    setattr(ScenarioTests, f"test_{_path.stem}", play(_path))


if __name__ == "__main__":
    unittest.main()
