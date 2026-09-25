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

sys.path.insert(0, str(DIAG))
import core  # noqa: E402
import scene  # noqa: E402

CORE = str(core.CORE)       # the one NEWGOLD_CORE names, or core.py's default


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

    def test_a_forced_wild_pokemon_is_rolled_from_a_pinned_rng(self):
        # A forced wild Pokemon's stats come from the field's RNG, which
        # Continue seeds with the VBlank count, and that count moves with the
        # core, its JIT and the loading before Continue (rolls_forced_high.json's
        # about): a scenario that forces one sets sLCRNG_State after the field
        # comes up, or the HP it expects is luck.
        for path in sorted(SCENARIOS.glob("*.json")):
            spec = json.loads(path.read_text())
            steps = [s for s in spec["steps"] if isinstance(s, str)]
            if any("gDiagForceBattleSpecies" in s for s in steps) or "gDiagForceBattleSpecies" in spec.get("hold", {}):
                with self.subTest(path.name):
                    pin = "poke:sLCRNG_State=0xbb160215"
                    self.assertIn(pin, steps)
                    self.assertLess(steps.index("field"), steps.index(pin))

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
        self.assertTrue(scene.Scene.wanted("music", "SEQ_GS_R_1_29")[0](1028))


class RecordingTests(unittest.TestCase):
    def test_a_run_records_its_frames_and_sound_to_an_mp4(self):
        # Three seconds from the boot, recorded by core.py through ffmpeg:
        # every frame there, both screens at twice their size, and a sound
        # track as long as the picture. The clip goes with the directory.
        import shutil
        import tempfile
        for needed in (ROM, CORE):
            if not os.path.exists(needed):
                self.skipTest(f"{needed} is not there")
        if not shutil.which("ffmpeg") or not shutil.which("ffprobe"):
            self.skipTest("ffmpeg is not installed")
        with tempfile.TemporaryDirectory(prefix="newgold-record-") as temp:
            clip = os.path.join(temp, "clip.mp4")
            script = (f"import sys; sys.path.insert(0, {str(DIAG)!r}); import core; "
                      f"c = core.Core({str(ROM)!r}, record={clip!r}); c.step(180); c.close()")
            subprocess.run([sys.executable, "-c", script], check=True, capture_output=True, timeout=600)
            probe = json.loads(subprocess.run(["ffprobe", "-v", "error", "-show_streams", "-of", "json", clip],
                                              capture_output=True, text=True, check=True).stdout)
            streams = {s["codec_type"]: s for s in probe["streams"]}
            video, audio = streams["video"], streams["audio"]
            self.assertEqual((video["codec_name"], video["width"], video["height"]), ("h264", 512, 768))
            self.assertEqual(int(video["nb_frames"]), 180)
            self.assertAlmostEqual(float(audio["duration"]), float(video["duration"]), delta=0.1)
            self.assertEqual(audio["channels"], 2)

    def test_an_mp4_ffmpeg_could_not_finish_fails_the_run(self):
        # ffmpeg writes the mp4's index last; if that fails (a full disk),
        # close() says so rather than leave a broken file behind quietly. An
        # ffmpeg that takes everything and exits 1 stands in for it.
        import tempfile
        for needed in (ROM, CORE):
            if not os.path.exists(needed):
                self.skipTest(f"{needed} is not there")
        with tempfile.TemporaryDirectory(prefix="newgold-record-") as temp:
            fake = os.path.join(temp, "ffmpeg")
            with open(fake, "w") as out:
                out.write("#!/bin/sh\ncat > /dev/null\nexit 1\n")
            os.chmod(fake, 0o755)
            script = (f"import sys; sys.path.insert(0, {str(DIAG)!r}); import core; "
                      f"c = core.Core({str(ROM)!r}, record={os.path.join(temp, 'clip.mp4')!r}); c.step(5); c.close()")
            run = subprocess.run([sys.executable, "-c", script], capture_output=True, text=True, timeout=600,
                                 env={**os.environ, "PATH": f"{temp}:{os.environ['PATH']}"})
            self.assertNotEqual(run.returncode, 0)
            self.assertIn("ffmpeg could not finish", run.stderr)

    def test_each_core_is_the_one_named_and_its_sound_gets_through(self):
        # NEWGOLD_CORE picks the core, and what it mixes reaches the mp4: a
        # save continued, A pressed at the title and its menu, recorded. The
        # title's music never plays on this ROM (the sound heap has no room
        # for it; DIAGNOSTICS.md), so the sound is the menu's: its first
        # clicks come about eleven seconds in. The same stretch before the
        # presses is silence -- it would not be, were the samples noise.
        import re
        import shutil
        import tempfile
        save = scene.SAVES / "route29-official.sav"
        for needed in (ROM, save):
            if not os.path.exists(needed):
                self.skipTest(f"{needed} is not there")
        if not shutil.which("ffmpeg"):
            self.skipTest("ffmpeg is not installed")

        def loudest(clip, start, length):
            run = subprocess.run(["ffmpeg", "-hide_banner", "-ss", str(start), "-t", str(length), "-i", clip,
                                  "-af", "volumedetect", "-f", "null", "-"], capture_output=True, text=True)
            return float(re.search(r"max_volume: (-?[\d.]+|-inf) dB", run.stderr).group(1))

        for path, name in ((core.MELONDS, "melonDS 0.9.3"), (core.MELONDSDS, "melonDS DS 1.3.1")):
            with self.subTest(name):
                if not path.exists():
                    self.skipTest(f"{path} is not there")
                with tempfile.TemporaryDirectory(prefix="newgold-sound-") as temp:
                    clip = os.path.join(temp, "clip.mp4")
                    script = (f"import sys; sys.path.insert(0, {str(DIAG)!r}); import core; core.pin_clock(); "
                              f"c = core.Core({str(ROM)!r}, save={str(save)!r}, record={clip!r}); "
                              "c.step(300)\nfor _ in range(20): c.press('A', 6); c.step(50)\n"
                              "print('core:', c.name, file=sys.stderr); c.close()")
                    run = subprocess.run([sys.executable, "-c", script], capture_output=True, text=True,
                                         timeout=600, env={**os.environ, "NEWGOLD_CORE": str(path)})
                    self.assertEqual(run.returncode, 0, run.stderr[-2000:])
                    self.assertTrue(re.search(r"core: (.*)", run.stderr).group(1).startswith(name))
                    self.assertLess(loudest(clip, 0, 5), -80)
                    self.assertGreater(loudest(clip, 5, 20), -40)


class NavigatorTests(unittest.TestCase):
    """scene.py's goto plans from the tree's own map data; these read the plan
    without the emulator."""

    def test_a_walk_leaves_a_building_by_its_mat_and_crosses_maps(self):
        # Elm's lab to where the old scripted walk ended on Route 29: out
        # through the mat at (4, 14), pressed down into the wall below it,
        # onto New Bark Town's lab door, and west across the town into the
        # route's own chunks, without a tile a wall or water stands on.
        path = scene.plan((61, 1, 11), [(33, 606, 410)])
        nodes = [node for node, _ in path]
        self.assertEqual(nodes[-1], (33, 606, 410))
        mat = nodes.index((61, 4, 14))
        self.assertEqual((path[mat][1], nodes[mat + 1]), ("DOWN", (60, 684, 393)))
        self.assertIn(60, {m for m, _, _ in nodes})
        for node in nodes[mat + 2:]:
            self.assertFalse(scene.tile(*node)[1] & scene.savedit.COLLISION, node)

    def test_a_ledge_is_jumped_one_way_only(self):
        # Route 29's ledges at x = 651 face east: over one in two tiles going
        # east, round by the shore coming back.
        self.assertEqual(scene.plan((33, 650, 400), [(33, 653, 400)]),
                         [((33, 650, 400), "RIGHT"), ((33, 652, 400), "RIGHT"), ((33, 653, 400), None)])
        self.assertGreater(len(scene.plan((33, 653, 400), [(33, 650, 400)])), 20)


def play(path):
    def test(self):
        for needed, how in ((ROM, "make NEWGOLD_DIAG=1 COMPARE=0 build/heartgold.us.diag/pokeheartgold.us.nds"),
                            (ELF, "the same build"), (CORE, "the libretro core (NEWGOLD_CORE)")):
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
