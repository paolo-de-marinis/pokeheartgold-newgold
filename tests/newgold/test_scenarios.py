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

The legs of the playthrough are a chain: a leg names the one before it
("from") and starts from the in-game save that one made. They share one
directory for the run (CHAIN); one run alone plays the legs before it first.

Up to three scene.py processes play at once (WORKERS), started when the
first scenario test runs, for every scenario the run selected: a chain's
legs in one worker, leg before leg, so each finds the save of the one
before, and the other two take the single scenarios meanwhile -- the chain
alone plays for over half an hour.
"""
import json
import os
import subprocess
import sys
import tempfile
import threading
import time
import unittest
from concurrent.futures import Future, ThreadPoolExecutor
from pathlib import Path

from test_level_cap import ROOT

DIAG = ROOT / "tools/newgold/devkit/diag"
SCENARIOS = ROOT / "tests/newgold/scenarios"
ROM = ROOT / "build/heartgold.us.diag/pokeheartgold.us.nds"
ELF = ROOT / "build/heartgold.us.diag/main.elf"

sys.path.insert(0, str(DIAG))
import core  # noqa: E402
import scene  # noqa: E402

CORE = str(core.CORE)       # the one NEWGOLD_CORE names, or core.py's default
CHAIN = tempfile.TemporaryDirectory(prefix="newgold-chain-")    # the legs' saves, for this run


class ScenarioFileTests(unittest.TestCase):
    def test_a_scenario_can_read_the_party_and_the_bag(self):
        # After the battle, on the field: what the party holds and what the
        # bag has, as the battle's end left them.
        for key in ("party0.item", "party5.species", "bag:ITEM_ORAN_BERRY"):
            self.assertTrue(scene.readable(key, key=True), key)
        for key in ("party6.item", "party0.moves", "bag:ORAN_BERRY"):
            self.assertFalse(scene.readable(key, key=True), key)

    def test_every_scenario_is_one_scene_py_can_play(self):
        # A typo in a step or an expectation is found here, without the
        # emulator, rather than twenty seconds into a run.
        for path in sorted(SCENARIOS.glob("*.json")):
            with self.subTest(path.name):
                spec = json.loads(path.read_text())
                self.assertLessEqual(set(spec), {"about", "save", "from", "edit", "hold", "steps", "expect"})
                self.assertTrue(spec.get("about") and spec.get("steps"))
                # a save, the leg before, or neither: a new game (which has nothing to edit)
                self.assertFalse("save" in spec and "from" in spec)
                self.assertTrue("edit" not in spec or "save" in spec or "from" in spec)
                if "from" in spec:     # a leg before it in the run's order
                    self.assertTrue((SCENARIOS / f"{spec['from']}.json").exists(), spec["from"])
                    self.assertLess(spec["from"], path.stem)
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

    def test_new_lines_start_where_the_check_before_ended(self):
        # A later phase's lines are not matched by an earlier phase's alike:
        # a Power Herb turn that said its attack message after the charge
        # passed "lines", its Solar Beam lines found in the turn before.
        s = scene.Scene.__new__(scene.Scene)
        s.lines, s._checked = ["Pikachu used Solar Beam!", "Pikachu absorbed light!"], 0
        s._collect = lambda core: None
        s.core = type("Core", (), {"ram": lambda self: b""})()
        s.markers = type("Markers", (), {"heaps": lambda self, ram: {}})()
        self.assertEqual(s.check({"new_lines": ["used Solar Beam!", "absorbed light!"]}), [])
        s.lines += ["Pikachu absorbed light!", "Pikachu became fully charged due to its Power Herb!", "Pikachu used Solar Beam!"]
        turn = ["used Solar Beam!", "absorbed light!", "fully charged"]
        self.assertEqual(s.check({"lines": turn}), [])
        s._checked = 2
        wrong = s.check({"new_lines": turn})
        self.assertEqual(len(wrong), 2, wrong)
        self.assertIn("since the check before", wrong[0])
        self.assertEqual(s._checked, 5)
        self.assertTrue(scene.readable("new_lines", key=True))

    def test_once_lines_count_what_was_printed_since_the_check_before(self):
        # One line where a rule prints one: an Opportunist copying Belly
        # Drum's rise printed its line twice and passed "lines".
        s = scene.Scene.__new__(scene.Scene)
        s.lines, s._checked = ["Chansey’s Opportunist raised its Attack!"], 0
        s._collect = lambda core: None
        s.core = type("Core", (), {"ram": lambda self: b""})()
        s.markers = type("Markers", (), {"heaps": lambda self, ram: {}})()
        once = {"once_lines": ["Opportunist raised its Attack!"]}
        self.assertEqual(s.check(once), [])
        s.lines += ["Chansey’s Opportunist raised its Attack!"] * 2
        self.assertIn("printed 2 times", s.check(once)[0])
        self.assertIn("printed 0 times", s.check(once)[0])
        self.assertTrue(scene.readable("once_lines", key=True))

    def test_a_fight_with_nobody_to_fight_gives_up_soon(self):
        # fight after a goto on which the trainer spotted and fought the
        # player: the field stays free, with no text box, press after press.
        # Five presses and the step is done, where 300 took about 12,000 frames.
        class Core:
            frames = 0

            def ram(self):
                return b""

            def press(self, button, frames, hooks):
                self.frames += frames

            def step(self, frames, hooks):
                self.frames += frames

        said = []
        s = scene.Scene.__new__(scene.Scene)
        s.core, s.hooks, s.say = Core(), [], said.append
        s.markers = type("Markers", (), {"read": lambda self, ram, name: 0})()
        s.movable, s.textbox = (lambda: True), (lambda: False)
        self.assertIsNone(s.run("fight"))
        self.assertLess(s.core.frames, 400)
        self.assertIn("no battle came up", said[-1])
        # A text box up, or the field taken by a script, keeps it pressing.
        s.core.frames, s.movable = 0, (lambda: s.core.frames > 3000)
        s.run("fight")
        self.assertGreater(s.core.frames, 3000)

    def test_a_battle_on_the_way_runs_as_flee_says(self):
        # flee:N holds for the battles scene.py plays on the way somewhere:
        # goto's, and the field step's, which plays a battle up on its way.
        import gym
        from unittest import mock

        class Core:
            frames = 0

            def word(self, address):
                return 0

            def step(self, frames, hooks):
                self.frames += frames

        asked = []
        s = scene.Scene.__new__(scene.Scene)
        s.core, s.hooks, s.say, s.markers, s.flee, s._text_count = Core(), [], print, None, 40, 0
        battles = iter([True, True])
        s.in_battle = lambda: next(battles, False)
        s.movable, s.textbox, s.partner_prompt, s._collect = (lambda: True), (lambda: False), (lambda: None), (lambda core: None)
        with mock.patch.object(gym, "fight", lambda *args, **kwargs: asked.append(kwargs)):
            s.run("field")
        self.assertEqual([kwargs.get("flee") for kwargs in asked], [40])

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
        # The keys a battle scenario reads beyond the battlers' HP: a move's
        # PP, and the party's items once the battle has given them back.
        for key in ("battler0.pp0", "battler3.move3", "party0.item", "party5.species", "running_shoes",
                    "options.textSpeed", "options.battleScene"):
            self.assertTrue(scene.readable(key, key=True), key)
        for key in ("battler0.pp4", "party6.item", "party0.ability", "options.speed"):
            self.assertFalse(scene.readable(key, key=True), key)
        # The options word leads PLAYERDATA: text speed in its low four bits,
        # the battle style and scene the two above the sound method's two.
        layout = scene.options_layout()
        self.assertEqual(layout["textSpeed"], (0, 1, 0x0F))
        self.assertEqual(layout["battleStyle"], (0, 1, 0x40))
        self.assertEqual(layout["battleScene"], (0, 1, 0x80))


class ChainTests(unittest.TestCase):
    """A leg starts from the save the leg before it left in the chain's
    directory, and does not play when that leg did not pass; read without
    the emulator."""

    def leg(self, chain, report=None, save=None):
        folder = Path(chain)
        (folder / "before.json").write_text(json.dumps({"about": "a", "steps": ["save"]}))
        (folder / "after.json").write_text(json.dumps({"about": "b", "from": "before", "steps": ["A"]}))
        if report is not None:
            (folder / "before.txt").write_text(report)
        if save is not None:
            (folder / "before.sav").write_bytes(save)
        return folder / "after.json"

    def test_a_leg_starts_from_the_save_the_leg_before_left(self):
        with tempfile.TemporaryDirectory() as chain:
            leg = self.leg(chain, "PASS before.json\n", b"flash")
            self.assertEqual(scene.leg_save(leg, Path(chain)), (Path(chain) / "before.sav", []))

    def test_a_leg_before_plays_on_the_rom_its_leg_was_given(self):
        # A leg run alone against another ROM plays the legs before it on
        # that ROM, not on the default one.
        from unittest import mock
        with tempfile.TemporaryDirectory() as chain:
            leg = self.leg(chain)
            with mock.patch.object(scene.subprocess, "run") as run:
                scene.leg_save(leg, Path(chain), "/x/other.nds", Path("/x/other.elf"))
            command = run.call_args[0][0]
            self.assertEqual(command[command.index("--rom") + 1], "/x/other.nds")
            self.assertEqual(command[command.index("--elf") + 1], "/x/other.elf")

    def test_a_leg_after_one_that_failed_fails_without_playing(self):
        with tempfile.TemporaryDirectory() as chain:
            leg = self.leg(chain, "FAIL before.json: 10 frames\n  map is 60, not 61\n")
            passed, report = scene.scenario(leg, chain=chain)
            self.assertIs(passed, False)
            self.assertEqual(report[0], "FAIL after.json: the leg before, before, left no save")
            self.assertIn("map is 60, not 61", report[-1])
            self.assertTrue((Path(chain) / "after.txt").read_text().startswith("FAIL"))

    def test_a_leg_after_one_that_could_not_run_is_skipped(self):
        with tempfile.TemporaryDirectory() as chain:
            leg = self.leg(chain, "SKIP before.json: no ROM\n")
            self.assertIsNone(scene.scenario(leg, chain=chain)[0])

    def test_three_play_at_once_and_a_chains_legs_in_order(self):
        # run() faked: each scenario takes a moment, noting who plays at once.
        legs_ = ["playthrough_01_new_game", "playthrough_02_cherrygrove", "playthrough_03_mr_pokemon"]
        alone = ["fairy_chart", "chuck", "thaw_scald_scorching_sands", "red_card_disarms_retreat", "snipe_shot_not_redirected"]
        paths = [SCENARIOS / f"{name}.json" for name in alone + legs_[::-1]]
        jobs_ = jobs(paths)
        self.assertEqual(jobs_[0], [SCENARIOS / f"{name}.json" for name in legs_])
        self.assertEqual(len(jobs_), 1 + len(alone))
        playing, most, order, lock = set(), [0], [], threading.Lock()

        def fake(path):
            with lock:
                playing.add(path)
                most[0] = max(most[0], len(playing))
            time.sleep(0.2)
            with lock:
                playing.discard(path)
                order.append(path.stem)
            return 0, f"PASS {path.name}"
        global run
        real, run = run, fake
        try:
            start(paths)
            reports = [RESULTS[path].result(timeout=10)[1] for path in paths]
        finally:
            run = real
            for path in paths:
                RESULTS.pop(path, None)
        self.assertEqual(reports, [f"PASS {path.name}" for path in paths])
        self.assertEqual(most[0], WORKERS)
        self.assertEqual([stem for stem in order if stem in legs_], legs_)

    def test_the_run_starts_what_its_loader_selected(self):
        loader, kept = unittest.TestLoader(), ScenarioTests.selected
        loader.testNamePatterns = ["*.test_chuck"]
        ScenarioTests.selected = []
        try:
            loader.loadTestsFromName("ScenarioTests", sys.modules[__name__])
            self.assertEqual(ScenarioTests.selected, [SCENARIOS / "chuck.json"])
        finally:
            ScenarioTests.selected = kept


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
        # boot's white screen and first notices are silence -- they would not
        # be, were the samples noise -- and its sound starts 5.2 seconds in
        # on either core, the title's and the menu's after it. And
        # ffmpeg is given as much sound as picture from the first frame on:
        # about 547 samples a frame on either core (melonDS 0.9.3 gives none
        # with its first, and core.py fills that frame with silence).
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
                              "fed, put = [], c._sounds.put\n"
                              "c._sounds.put = lambda chunk: (fed.append(len(chunk or b'')), put(chunk))\n"
                              "c.step(300)\nfor _ in range(20): c.press('A', 6); c.step(50)\n"
                              "print('core:', c.name, file=sys.stderr)\n"
                              "print('sound:', sum(fed) // 4, c.frames, file=sys.stderr); c.close()")
                    run = subprocess.run([sys.executable, "-c", script], capture_output=True, text=True,
                                         timeout=600, env={**os.environ, "NEWGOLD_CORE": str(path)})
                    self.assertEqual(run.returncode, 0, run.stderr[-2000:])
                    self.assertTrue(re.search(r"core: (.*)", run.stderr).group(1).startswith(name))
                    samples, frames = map(int, re.search(r"sound: (\d+) (\d+)", run.stderr).groups())
                    self.assertLess(abs(samples - frames * 32728.498 / 59.826098), 100)
                    self.assertLess(loudest(clip, 0, 4), -80)
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

    def test_a_ladder_foot_is_not_walked_off_its_way(self):
        # Sprout Tower 1F's ladder is two tiles, (6, 16) climbed pressing up
        # and (6, 15) pressing down: from the foot the walk goes round it,
        # not up into it and back to 2F. The way down from 3F to Violet
        # City came to (6, 16) and looped there.
        path = scene.plan((110, 6, 16), [(110, 7, 9)])
        self.assertEqual(path[1][0], (110, 7, 16))
        self.assertNotIn((110, 6, 15), [node for node, _ in path])
        # and up it still goes, pressed down from its other end
        up = scene.plan((110, 6, 14), [(155, 6, 17)])
        self.assertEqual(up[:2], [((110, 6, 14), "DOWN"), ((110, 6, 15), "DOWN")])

    def test_a_ledge_is_jumped_one_way_only(self):
        # Route 29's ledges at x = 651 face east: over one in two tiles going
        # east, round by the shore coming back.
        self.assertEqual(scene.plan((33, 650, 400), [(33, 653, 400)]),
                         [((33, 650, 400), "RIGHT"), ((33, 652, 400), "RIGHT"), ((33, 653, 400), None)])
        self.assertGreater(len(scene.plan((33, 653, 400), [(33, 650, 400)])), 20)


def legs(path):
    """How many legs a run of this scenario plays: itself and those before it."""
    before = json.loads(path.read_text()).get("from")
    return 1 + (legs(SCENARIOS / f"{before}.json") if before else 0)


WORKERS = 3                 # scene.py processes at once, an emulator each
RESULTS = {}                # a scenario's path -> the Future of run(path)


def run(path):
    """One scenario played by scene.py: (its exit code, its report)."""
    done = subprocess.run([sys.executable, str(DIAG / "scene.py"), "--scenario", str(path), "--chain", CHAIN.name],
                          capture_output=True, text=True, timeout=1800 * legs(path))
    return done.returncode, done.stdout.strip() or done.stderr.strip()[-2000:]


def jobs(paths):
    """The scenarios as the workers take them: each alone, but the legs of a
    chain together, first leg first; the longest job first."""
    def first(path):
        before = json.loads(path.read_text()).get("from")
        return first(SCENARIOS / f"{before}.json") if before else path
    chains = {}
    for path in paths:
        chains.setdefault(first(path), []).append(path)
    return sorted((sorted(job, key=legs) for job in chains.values()), key=len, reverse=True)


def start(paths, workers=WORKERS):
    """Play `paths` in the background, `workers` at a time; RESULTS holds a
    Future for each."""
    def work(job):
        for path in job:
            try:
                RESULTS[path].set_result(run(path))
            except Exception as e:
                RESULTS[path].set_exception(e)
    paths = [path for path in paths if path not in RESULTS]
    for path in paths:
        RESULTS[path] = Future()
    pool = ThreadPoolExecutor(workers)
    for job in jobs(paths):
        pool.submit(work, job)
    pool.shutdown(wait=False)


def play(path):
    def test(self):
        for needed, how in ((ROM, "make NEWGOLD_DIAG=1 COMPARE=0 build/heartgold.us.diag/pokeheartgold.us.nds"),
                            (ELF, "the same build"), (CORE, "the libretro core (NEWGOLD_CORE)")):
            if not os.path.exists(needed):
                self.skipTest(f"{needed} is not there: {how}")
        start([path])       # nothing when the class has started it
        returncode, report = RESULTS[path].result()
        if report.startswith("SKIP"):
            self.skipTest(report)
        print(report.splitlines()[0])
        self.assertEqual(returncode, 0, report)
        self.assertTrue(report.startswith("PASS"), report)
    return test


class ScenarioTests(unittest.TestCase):
    selected = []           # the scenarios this run's loader made a test of (-k too)

    def __init__(self, name="runTest"):
        super().__init__(name)
        if name.startswith("test_"):
            self.selected.append(SCENARIOS / f"{name[5:]}.json")

    @classmethod
    def setUpClass(cls):
        if all(os.path.exists(needed) for needed in (ROM, ELF, CORE)):
            start(cls.selected)


for _path in sorted(SCENARIOS.glob("*.json")):
    setattr(ScenarioTests, f"test_{_path.stem}", play(_path))


if __name__ == "__main__":
    unittest.main()
