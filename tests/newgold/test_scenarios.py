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
NEWGOLD_PLAYTHROUGH=0 leaves every leg of a chain out (skipped, not played);
unset, they play. NEWGOLD_CHAIN_FROM=DIR plays every leg at once instead,
each from the save the leg before it left in DIR -- the cache of the last
good run of the whole chain, tools/newgold/chain.sh's -- the longest there
first: a round's check, where the whole chain plays once after the landing.

Up to three scene.py processes play at once (WORKERS; NEWGOLD_WORKERS=2
plays two, as a round's agent, allowed two emulators, must), started when the
first scenario test runs, for every scenario the run selected: a chain's
legs in one worker, leg before leg, so each finds the save of the one
before, and the others take the single scenarios meanwhile -- the chain,
a new game to Goldenrod's Radio Card in 25 legs, plays for about two hours
and a half alone.
"""
import json
import os
import re
import struct
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
        for key in ("party0.item", "party5.species", "bag:ITEM_ORAN_BERRY", "money"):
            self.assertTrue(scene.readable(key, key=True), key)
        for key in ("party6.item", "party0.moves", "bag:ORAN_BERRY"):
            self.assertFalse(scene.readable(key, key=True), key)

    def test_a_scenario_can_read_what_the_ev_iv_trainer_changes(self):
        # The money paid, the EVs and IVs in the record's order, the stats
        # they make, and the Hyper trained ones as a mask.
        for key in ("money", "party0.ev0", "party5.ev5", "party0.iv3", "party0.atk", "party0.spdef", "party2.hyper"):
            self.assertTrue(scene.readable(key, key=True), key)
        for key in ("party0.ev6", "party0.evs", "party0.hp_ev", "cash"):
            self.assertFalse(scene.readable(key, key=True), key)

    def test_every_scenario_is_one_scene_py_can_play(self):
        # A typo in a step or an expectation is found here, without the
        # emulator, rather than twenty seconds into a run.
        for path in sorted(SCENARIOS.glob("*.json")):
            with self.subTest(path.name):
                spec = json.loads(path.read_text())
                self.assertLessEqual(set(spec), {"about", "save", "from", "edit", "hold", "steps", "expect", "jit"})
                self.assertIs(spec.get("jit", True), True)
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

    def test_the_playthrough_is_one_chain_from_a_new_game_with_its_own_team(self):
        # Every leg follows the one before it, from the new game to
        # Goldenrod's Radio Card, one line with no branch; the party is the one the
        # bot caught and trained: no leg edits the save (--party, --level,
        # --teach, --train, the last of them gone from leg 08b's Bugsy in
        # round 15) -- the bot trains in play, learns by gym.py's rule and
        # teaches a machine from the bag. No step writes it either (set:,
        # teach:, a poke: or hold: of anything but the pinned RNG and battle
        # seed).
        legs_ = {path.stem: json.loads(path.read_text()) for path in SCENARIOS.glob("playthrough_*.json")}
        line, leg = [], "playthrough_10_goldenrod"
        while leg:
            line.append(leg)
            leg = legs_[leg].get("from")
        self.assertEqual(line[-1], "playthrough_01_new_game")
        self.assertNotIn("save", legs_[line[-1]])
        self.assertEqual(sorted(line), sorted(legs_))
        for name, spec in legs_.items():
            with self.subTest(name):
                self.assertNotIn("edit", spec)
                # Nor does a step write the party or the battle: the field's
                # RNG is pinned and the battle's seed held, and nothing else
                # is poked, held, set or taught.
                self.assertLessEqual(set(spec.get("hold", {})), {"gDiagBattleSeed"})
                for step in spec["steps"]:
                    kind, _, rest = step.partition(":") if isinstance(step, str) else ("", "", "")
                    self.assertNotIn(kind, ("set", "teach"), step)
                    if kind in ("poke", "hold"):
                        self.assertIn(rest.partition("=")[0], {"sLCRNG_State", "gDiagBattleSeed"}, step)

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
        s.catch, s.shift = None, None
        battles = iter([True, True])
        s.in_battle = lambda: next(battles, False)
        s.movable, s.textbox, s.partner_prompt, s._collect = (lambda: True), (lambda: False), (lambda: None), (lambda core: None)
        s.frame_script_due = lambda: None
        with mock.patch.object(gym, "fight", lambda *args, **kwargs: asked.append(kwargs)):
            s.run("field")
        self.assertEqual([kwargs.get("flee") for kwargs in asked], [40])

    def test_catch_wants_a_species_the_dex_lacks_while_a_ball_is_left(self):
        # catch: tells gym.fight how many balls to spend on a wild Pokemon:
        # the bag's, for the species asked (or any, catch:new) that the Dex
        # has not caught; none otherwise.
        import party
        import savedit
        from unittest import mock
        s = scene.Scene.__new__(scene.Scene)
        ram = bytearray(0x400000)
        s.core = type("Core", (), {"ram": lambda self: bytes(ram)})()
        s.elf, s.catch, s.hooks = None, None, []
        s.caught = lambda ram_, species: species == 163           # a Hoothoot is in the Dex
        start, _ = savedit.pocket_at("balls")
        ram[0x100000 + start + 2] = 3                               # three Poke Balls
        with mock.patch.object(party, "block", lambda memory, elf, index: 0x02100000):
            self.assertEqual(s.balls_for(95), 0)                    # nothing asked
            s.run("catch:new")
            self.assertEqual((s.balls_for(95), s.balls_for(163)), (3, 0))
            s.run("catch:SPECIES_ONIX")
            self.assertEqual((s.balls_for(95), s.balls_for(19)), (3, 0))
            ram[0x100000 + start + 2] = 0
            self.assertEqual(s.balls_for(95), 0)                    # no ball left
            s.run("catch:none")
            self.assertIsNone(s.catch)
        self.assertTrue(scene.readable("caught:SPECIES_ONIX", key=True))

    def test_pace_walks_to_and_fro_until_the_value_and_heals_its_first(self):
        # pace: goes from one tile to the other and back until the key reads
        # enough; between two walks, at heal:'s tile when the party's first
        # has under flee:'s share of its HP.
        import party
        from unittest import mock

        class Core:
            frames = 0

            def ram(self):
                return b""
        s = scene.Scene.__new__(scene.Scene)
        s.core, s.say, s.flee, s.healer, s.elf, s.shift = Core(), (lambda line: None), 40, (158, 8, 13), None, None
        s.hooks = []
        values, hps, walks, steps = iter([5, 5, 6, 8]), iter([20, 7, 20]), [], []

        def goto(goal, frames):
            s.core.frames += 100
            walks.append(goal)
            return True, "there"
        flees = []
        s.goto, s.run = goto, (lambda step: (steps.append(step), flees.append(s.flee)))
        s.value = lambda ram, key: next(values)
        with mock.patch.object(party, "mons", lambda ram, elf: [{"hp": next(hps), "maxHp": 20, "sealed": True}]):
            self.assertIsNone(s.pace((33, 1, 2), (33, 3, 4), "party0.level", 8, 10000))
        self.assertEqual(walks, [(33, 1, 2), (33, 3, 4), (33, 1, 2)])
        self.assertEqual(steps, ["goto:158,8,13", "UP", "A", "field"])
        self.assertEqual((flees, s.flee), ([101] * 4, 40))     # runs from all on the way, then as before
        s.value = lambda ram, key: 5
        with mock.patch.object(party, "mons", lambda ram, elf: [{"hp": 20, "maxHp": 20, "sealed": True}]):
            self.assertIn("under 8", s.pace((33, 1, 2), (33, 3, 4), "party0.level", 8, 1000)[0])
        # With shift:, the one sent in for the first fights: its HP counts too.
        steps.clear()
        s.shift, values = 1, iter([5, 8])
        s.value = lambda ram, key: next(values)
        with mock.patch.object(party, "mons", lambda ram, elf: [{"hp": 20, "maxHp": 20, "sealed": True}, {"hp": 5, "maxHp": 30, "sealed": True}]):
            self.assertIsNone(s.pace((33, 1, 2), (33, 3, 4), "party0.level", 8, 10000))
        self.assertEqual(steps, ["goto:158,8,13", "UP", "A", "field"])

    def test_again_plays_the_steps_before_until_the_value(self):
        # again: a leader fought again after a loss: the steps before it,
        # from where the blackout left the player, until the key reads
        # enough; at most N times, and it says so when that was not enough.
        s = scene.Scene.__new__(scene.Scene)
        s.core = type("Core", (), {"ram": lambda self: b"", "frames": 0})()
        s.hooks, s.say, played, seeds = [], (lambda line: None), [], []
        s.done = ["field", "goto:MAP_VIOLET_GYM,15,4", {"expect": {}}, "A", "fight"]
        s.markers = type("Markers", (), {"address": lambda self, name: 0x100})()
        s.holds = {0x100: (1, 4)}                   # gDiagBattleSeed held at 1
        badges = iter([0, 0, 1])
        s.value = lambda ram, key: next(badges)
        real = scene.Scene.run

        def run(step):
            if isinstance(step, str) and step.startswith("again:"):
                return real(s, step)
            played.append(step)
            seeds.append(s.holds[0x100][0])
        s.run = run
        self.assertIsNone(s.run("again:4,badges,1"))
        self.assertEqual(played, ["goto:MAP_VIOLET_GYM,15,4", "A", "fight"] * 2)
        # each attempt a new battle: the seed one higher, the old one back after
        self.assertEqual(seeds, [2, 2, 2, 3, 3, 3])
        self.assertEqual(s.holds[0x100], (1, 4))
        s.value = lambda ram, key: 0
        self.assertIn("under 1", s.run("again:3,badges,1,2")[0])

    def test_the_party_is_read_once_the_game_has_sealed_it(self):
        # swap: read the species before it, right after another swap, with a
        # Pokemon half decrypted (17223) and never saw the trade it waited
        # for: the menu swapped the two back and forth for 6000 frames.
        import party
        from unittest import mock

        class Core:
            frames = 0

            def ram(self):
                return b""

            def step(self, frames, hooks):
                self.frames += frames
        s = scene.Scene.__new__(scene.Scene)
        s.core, s.hooks, s.elf = Core(), [], None
        reads = iter([[{"species": 17223, "sealed": False}], [{"species": 163, "sealed": True}]])
        with mock.patch.object(party, "mons", lambda ram, elf: next(reads)):
            self.assertEqual(s.mons(), [{"species": 163, "sealed": True}])
        self.assertEqual(s.core.frames, 1)

    def test_a_swap_that_does_not_happen_leaves_the_menus(self):
        # The menus left open sent the next goto nowhere for 30000 frames.
        import party
        from unittest import mock

        class Core:
            frames, pressed = 0, []

            def ram(self):
                return b""

            def word(self, address, size=4):
                return 99                   # a party menu state no branch answers

            def step(self, frames, hooks):
                self.frames += frames

            def press(self, button, frames, hooks):
                self.pressed.append(button)
                self.frames += frames
        s = scene.Scene.__new__(scene.Scene)
        s.core, s.hooks, s.elf, s.say = Core(), [], None, (lambda line: None)
        s.markers = type("Markers", (), {"address": lambda self, name: 0x100})()
        s.start_menu = lambda action, end: None
        s.app = lambda: ("PartyMenuApp_Main", 0x200)
        s.movable = lambda: s.core.pressed.count("B") >= 2
        mons = [{"species": 155, "sealed": True}, {"species": 163, "sealed": True}]
        with mock.patch.object(party, "mons", lambda ram, elf: mons):
            self.assertIn("not traded", s.swap(0, 1, frames=100)[0])
        self.assertEqual(s.core.pressed[-2:], ["B", "B"])

    def test_answers_give_each_yes_no_in_order_and_a_through_the_text(self):
        # The Radio Tower's quiz: A through its lines, and at each yes/no
        # the script waits on, A for Y and B for N, once, in order -- the
        # menu stays up a few frames after the press, and a second press
        # there would answer the next question too.
        script = iter(["text", "ask", "ask", "text", "ask", "text", "ask", "free"])

        class Core:
            frames, pressed = 0, []

            def press(self, button, frames, hooks):
                self.pressed.append(button)
                self.frames += frames
                if s.now == "ask":
                    s.lag = 3                       # the menu closes a few frames on
                else:
                    s.now = next(script)

            def step(self, frames, hooks):
                self.frames += frames
                if s.now == "ask" and s.lag:
                    s.lag -= 1
                    if not s.lag:
                        s.now = next(script)
        s = scene.Scene.__new__(scene.Scene)
        s.core, s.hooks, s.say, s.now, s.lag = Core(), [], (lambda line: None), next(script), 0
        s.asking = lambda: s.now == "ask" and not s.lag
        s.textbox = lambda: s.now == "text"
        s.movable = lambda: s.now == "free"
        s._chain = lambda *fields: 1
        self.assertIsNone(s.answers("YNYN", frames=2000))
        self.assertEqual(s.core.pressed, ["A", "A", "B", "A", "A", "A", "B"])
        self.assertTrue(scene.readable("answers:YYYNYN"))

    def test_a_machine_goes_through_the_bag_to_the_move_the_rule_lets_go(self):
        # machine: the TMs & HMs tab until the bag shows it, the machine's
        # place until the bag has it picked, USE; the party menu's panel; on
        # the summary screen the cursor onto the move gym.py's rule lets go,
        # and A. A machine the rule would not keep is refused at once.
        numbers = scene.savedit.move_numbers()
        items = scene.savedit.constants("include/constants/items.h", "ITEM_")
        bag, app = scene.machine_layout(), scene.app_layout()
        party = [{"species": scene.savedit.species_numbers()["QUILAVA"],
                  "moves": [numbers[m] for m in ("TACKLE", "EMBER", "SMOKESCREEN", "FLAME_WHEEL")]}]
        MANAGER, DATA, VIEW, SLOTS = 0x100, 0x1000, 0x5000, 0x6000
        tms = VIEW + bag["pockets"] + 3 * bag["entry"]
        memory = {MANAGER + app["OverlayManager.proc_state"]: bag["pick"], MANAGER + app["OverlayManager.data"]: DATA,
                  DATA + bag["view"]: VIEW, tms + bag["id"]: bag["tms"], tms + bag["slots"]: SLOTS,
                  tms + bag["count"]: 2, SLOTS: items["ITEM_TM51"], SLOTS + 4: items["ITEM_HM01"]}
        screens = {"bag": "Bag_Main", "party": "PartyMenuApp_Main", "summary": "PokemonSummary_Main", "field": None}

        class Core:
            frames, touches = 0, []

            def word(self, address, size=4):
                return memory.get(address, 0)

            def step(self, frames, hooks):
                self.frames += frames

            def touch(self, x, y, frames, hooks):
                self.touches.append((x, y))
                effect = {scene.TABS[3]: (VIEW + bag["pocket"], 3), scene.CELLS[1]: (VIEW + bag["item"], items["ITEM_HM01"])}
                if (x, y) in effect:
                    memory.__setitem__(*effect[(x, y)])
                s.screen = {scene.BAG_USE: "party", scene.PANELS[0]: "summary"}.get((x, y), s.screen)

            def press(self, button, frames, hooks):
                cursor = DATA + bag["cursor"]
                if s.screen == "summary" and button == "DOWN":
                    memory[cursor] = memory.get(cursor, 0) + 1
                elif s.screen == "summary" and button == "A":
                    party[0]["moves"][memory.get(cursor, 0)] = numbers["CUT"]
                    s.screen = "field"
        s = scene.Scene.__new__(scene.Scene)
        s.core, s.hooks, s.say, s.screen = Core(), [], (lambda line: None), "bag"
        s.start_menu = lambda action, end: None
        s.mons = lambda: party
        s.movable = lambda: s.screen == "field"
        s.app = lambda: (screens[s.screen], MANAGER if screens[s.screen] else 0)
        self.assertIsNone(s.machine(items["ITEM_HM01"], 0, frames=3000))
        self.assertEqual(party[0]["moves"], [numbers[m] for m in ("TACKLE", "EMBER", "CUT", "FLAME_WHEEL")])
        self.assertEqual(s.core.touches[:4], [scene.TABS[3], scene.CELLS[1], scene.BAG_USE, scene.PANELS[0]])
        self.assertIn("keeps", s.machine(items["ITEM_TM17"], 0)[0])         # Protect over four attacks
        party[0]["species"] = scene.savedit.species_numbers()["FLAAFFY"]
        self.assertIn("cannot learn", s.machine(items["ITEM_HM01"], 0)[0])  # leg 09b's first try: no Cut for it
        self.assertTrue(scene.readable("machine:ITEM_HM01,2"))
        self.assertTrue(scene.readable("party2.move3", key=True))

    def test_buy_walks_a_mart_s_cursor_to_any_item_from_anywhere(self):
        # buy: moves the mart list's cursor by keys, as Task_Mart reads them
        # (ov03_0225947A): two to a row, six to a page, RIGHT off the right
        # column and LEFT off the left one turn the page, and DOWN off the
        # right column's bottom lands on cancel. From every place the cursor
        # can be, every item of a ten- and a fourteen-item list is reached
        # and A pressed on it.
        table = [[4, 2, 6, 1], [8, 3, 0, 7], [0, 4, 6, 3], [1, 5, 2, 7], [2, 0, 6, 5], [3, 8, 4, 7], [4, 0, 8, 8],
                 [4, 0, 8, 8], [5, 1, 8, 8]]
        keys = {"UP": 0, "DOWN": 1, "LEFT": 2, "RIGHT": 3}
        import re
        source = re.search(r"ov03_0225947A\[9\]\[4\] = \{(.*?)\};", (ROOT / "src/overlay_03/shop_menu.c").read_text(), re.S)
        self.assertEqual([[int(v) for v in row] for row in re.findall(r"\{ (\d), (\d), (\d), (\d) \}", source.group(1))], table)
        for count in (10, 14):
            for index in range(count):
                for start in range(9):
                    page, cursor, key = 0, start, None
                    for _ in range(20):
                        key = scene.mart_key(index, page, cursor)
                        if key == "A":
                            break
                        after = table[cursor][keys[key]]
                        if (key, after) in (("RIGHT", 7), ("LEFT", 6)):
                            page += 6 if key == "RIGHT" and page + 6 < count else -6 if key == "LEFT" and page else 0
                        else:
                            cursor = after
                    self.assertEqual((key, page + cursor), ("A", index), (count, index, start))

    def test_fight_stops_waiting_at_a_beaten_trainer(self):
        # fight: after A beside a trainer the bot has beaten: his line after
        # the battle comes at every press, the field free between two. Route
        # 35's leg waited 300 presses, 12,000 frames, twice. It gives up
        # after the second such talk now; a speech before a battle, the
        # field never free, is waited through; nobody there, five looks.
        def looks(frees):
            idle = talks = 0
            for presses, free in enumerate(frees):
                idle, talks, done = scene.waiting(free, idle, talks, presses)
                if done:
                    return presses
            return None
        self.assertEqual(looks([False, True, False, True, False, True]), 3)
        self.assertIsNone(looks([False] * 40))
        self.assertEqual(looks([True] * 8), 4)

    def test_retry_gives_the_battle_after_a_loss_a_new_seed(self):
        # retry:on -- after a loss on a goto, the held seed one higher; a win
        # leaves it, and a seed not held is not made one.
        s = scene.Scene.__new__(scene.Scene)
        s.core, s.say = type("Core", (), {"frames": 0})(), (lambda line: None)
        s.markers = type("Markers", (), {"address": lambda self, name: 0x100})()
        s.holds = {0x100: (1, 4)}
        s.reseed(["Bird Keeper Rod sent out Delibird!", "You defeated Bird Keeper Rod!"])
        self.assertEqual(s.holds[0x100], (1, 4))
        s.reseed(["You have no more Pokémon that can fight!", "You were overwhelmed by your defeat!"])
        self.assertEqual(s.holds[0x100], (2, 4))
        s.holds = {}
        s.reseed(["You were overwhelmed by your defeat!"])
        self.assertEqual(s.holds, {})
        self.assertTrue(scene.readable("retry:on"))

    def test_a_trainer_beaten_is_read_from_its_flag(self):
        # trainer:TRAINER_... -- TrainerFlagCheck's flag, TRAINER_FLAG_BASE
        # plus the trainer's number, in the save's flags: what again: waits
        # on for a gym's trainer fought again after a loss.
        import party
        from unittest import mock
        s = scene.Scene.__new__(scene.Scene)
        s.markers, s.elf = None, None
        ram = bytearray(0x400000)
        number = 0x550 + scene.savedit.constants("include/constants/trainers.h", "TRAINER_")["TRAINER_BUG_CATCHER_JOSH"]
        with mock.patch.object(party, "block", lambda memory, elf, index: 0x02100000):
            self.assertEqual(s.value(bytes(ram), "trainer:TRAINER_BUG_CATCHER_JOSH"), 0)
            ram[0x100000 + scene.savedit.FLAGS_AT + number // 8] |= 1 << number % 8
            self.assertEqual(s.value(bytes(ram), "trainer:TRAINER_BUG_CATCHER_JOSH"), 1)
        self.assertTrue(scene.readable("trainer:TRAINER_LEADER_WHITNEY", key=True))

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
        for key in ("battler0.pp0", "battler3.move3", "party0.item", "party5.species", "party1.move3", "running_shoes",
                    "options.textSpeed", "options.battleScene"):
            self.assertTrue(scene.readable(key, key=True), key)
        for key in ("battler0.pp4", "party6.item", "party0.ability", "party0.move4", "options.speed"):
            self.assertFalse(scene.readable(key, key=True), key)
        # A battler's types are the battle's, read in its BattleMon (found
        # by what gDiagBattlers shows): a Castform in its Snowy Form, form 3,
        # is Ice, which no record in personal.json says.
        from markers import BATTLER
        layout, ram = scene.battle_layout(), bytearray(0x400000)
        struct.pack_into(BATTLER, ram, 0x100000 + struct.calcsize(BATTLER), 351, 30, 31, 10, 0, 0, 0,
                         *[0] * 8, 3, 0)
        mon = 0x200000
        struct.pack_into("<H", ram, mon, 351)
        struct.pack_into("<iI", ram, mon + layout["hp"], 30, 31)
        ram[mon + layout["type1"]] = ram[mon + layout["type2"]] = scene.Scene.number("TYPE_ICE")
        s = scene.Scene.__new__(scene.Scene)
        s.core = type("Core", (), {"ram": lambda self: bytes(ram)})()
        s.markers = type("Markers", (), {"address": lambda self, name: 0x02100000})()
        types = s.value(bytes(ram), "battler1.types")
        self.assertEqual(types, [15, 15])
        self.assertTrue(scene.Scene.wanted("battler1.types", "TYPE_ICE")[0](types))
        self.assertFalse(scene.Scene.wanted("battler1.types", "TYPE_NORMAL")[0](types))
        # The options word leads PLAYERDATA: text speed in its low four bits,
        # the battle style and scene the two above the sound method's two.
        layout = scene.options_layout()
        self.assertEqual(layout["textSpeed"], (0, 1, 0x0F))
        self.assertEqual(layout["battleStyle"], (0, 1, 0x40))
        self.assertEqual(layout["battleScene"], (0, 1, 0x80))

    def test_a_layer_s_tile_is_read_from_the_field_s_bg_config(self):
        # bgN:X,Y: the entry the field's BgConfig holds for layer N, row by
        # row 32 tiles wide, found from sFieldSysPtr; a window's frame drawn
        # there or not (ev_iv_trainer_shop_window).
        self.assertTrue(scene.readable("bg3:2,18", key=True))
        for key in ("bg3:2", "bg8:2,18", "bg3"):
            self.assertFalse(scene.readable(key, key=True), key)
        layout, ram = scene.bg_layout(), bytearray(0x400000)
        field, config, buffer = 0x02100000, 0x02200000, 0x02300000
        struct.pack_into("<I", ram, 0x1000, field)
        struct.pack_into("<I", ram, field - 0x02000000 + layout["FieldSystem.bgConfig"], config)
        bg = config - 0x02000000 + layout["BgConfig.bgs"] + 3 * layout["Background.sizeof"]
        struct.pack_into("<I", ram, bg + layout["Background.tilemapBuffer"], buffer)
        ram[bg + layout["Background.size"]] = layout["32 wide"][0]
        struct.pack_into("<H", ram, buffer - 0x02000000 + 2 * (18 * 32 + 2), 0xA3E4)
        s = scene.Scene.__new__(scene.Scene)
        s._field = 0x02001000
        s.markers = None
        self.assertIsNone(s.value(bytes(ram), "bg3:2,18"), "no field map running: an app's screen, the BgConfig freed")
        struct.pack_into("<I", ram, field - 0x02000000 + layout["FieldSystem.runningFieldMap"], 1)
        self.assertEqual(s.value(bytes(ram), "bg3:2,18"), 0xA3E4)
        self.assertEqual(s.value(bytes(ram), "bg3:2,19"), 0)
        ram[bg + layout["Background.size"]] = 0xFF
        self.assertIsNone(s.value(bytes(ram), "bg3:2,18"), "a layer not 32 wide: a failed expectation, not an abort")
        self.assertTrue(scene.Scene.wanted("bg3:2,18", "0xA3E4")[0](0xA3E4))


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

    def test_a_leg_from_a_cache_starts_from_the_save_there_and_never_plays_the_leg_before(self):
        from unittest import mock
        with tempfile.TemporaryDirectory() as chain, tempfile.TemporaryDirectory() as cache:
            leg = self.leg(chain)
            (Path(cache) / "before.sav").write_bytes(b"flash")
            with mock.patch.object(scene.subprocess, "run") as played:
                self.assertEqual(scene.leg_save(leg, Path(chain), start=Path(cache)), (Path(cache) / "before.sav", []))
                (Path(cache) / "before.sav").unlink()
                save, report = scene.leg_save(leg, Path(chain), start=Path(cache))
            played.assert_not_called()
            self.assertIsNone(save)
            self.assertEqual(report, [f"SKIP after.json: {cache} has no save of the leg before, before"])

    def test_newgold_chain_from_plays_every_leg_alone_the_longest_there_first(self):
        # Each leg a job of its own, so the workers play them at once, the
        # one that took longest in the cache's run first; each is handed the
        # cache (scene.py --from), and a cache that is not there fails.
        from unittest import mock
        legs_ = [SCENARIOS / f"{name}.json" for name in
                 ("playthrough_01_new_game", "playthrough_02_cherrygrove", "playthrough_03_mr_pokemon")]
        with tempfile.TemporaryDirectory() as cache, \
                mock.patch.dict(os.environ, {"NEWGOLD_CHAIN_FROM": cache, "NEWGOLD_PLAYTHROUGH": "1"}):
            (Path(cache) / "playthrough_02_cherrygrove.txt").write_text(
                "PASS playthrough_02_cherrygrove.json: 19811 frames in 215 s\n  played on 6fee9b238\n")
            (Path(cache) / "playthrough_03_mr_pokemon.txt").write_text(
                "PASS playthrough_03_mr_pokemon.json: 34215 frames in 312 s\n  played on 6fee9b238\n")
            self.assertEqual(jobs(legs_), [[legs_[2]], [legs_[1]], [legs_[0]]])
            with mock.patch.object(subprocess, "run", return_value=subprocess.CompletedProcess([], 0, "PASS", "")) as played:
                run(legs_[1])
            command = played.call_args[0][0]
            self.assertEqual(command[command.index("--from") + 1], cache)
            os.environ["NEWGOLD_CHAIN_FROM"] = str(Path(cache) / "nowhere")
            with self.assertRaisesRegex(AssertionError, "nowhere is not a directory"):
                play(legs_[1])(self)

    def test_chain_sh_takes_the_legs_in_the_chain_s_order(self):
        # tools/newgold/chain.sh plays the legs as the C locale sorts their
        # names, which Python's sort is: that has to be the line "from" draws.
        legs_ = sorted(SCENARIOS.glob("playthrough_*.json"))
        self.assertNotIn("from", json.loads(legs_[0].read_text()))
        for before, after in zip(legs_, legs_[1:]):
            self.assertEqual(json.loads(after.read_text()).get("from"), before.stem)

    def test_three_play_at_once_and_a_chains_legs_in_order(self):
        self.assertEqual(self.most_at_once({}), WORKERS)

    def test_newgold_workers_sets_how_many_play_at_once(self):
        self.assertEqual(self.most_at_once({"NEWGOLD_WORKERS": "2"}), 2)

    def most_at_once(self, env):
        # run() faked: each scenario takes a moment, noting who plays at once.
        from unittest import mock
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
            with mock.patch.dict(os.environ):
                os.environ.pop("NEWGOLD_WORKERS", None)
                os.environ.update(env)
                start(paths)
            reports = [RESULTS[path].result(timeout=10)[1] for path in paths]
        finally:
            run = real
            for path in paths:
                RESULTS.pop(path, None)
        self.assertEqual(reports, [f"PASS {path.name}" for path in paths])
        self.assertEqual([stem for stem in order if stem in legs_], legs_)
        return most[0]

    def test_newgold_playthrough_0_leaves_the_chain_out(self):
        # The playthrough's legs, its first among them, are skipped without
        # playing; a scenario of its own is not a leg. Unset, they play.
        from unittest import mock
        first, leg, alone = (SCENARIOS / f"{name}.json" for name in
                             ("playthrough_01_new_game", "playthrough_05_falkner", "catch_route29"))
        self.assertEqual([chained(path) for path in (first, leg, alone)], [True, True, False])
        with mock.patch.dict(os.environ, {"NEWGOLD_PLAYTHROUGH": "0"}):
            self.assertFalse(playthrough())
            for path in (first, leg):
                with self.assertRaisesRegex(unittest.SkipTest, "NEWGOLD_PLAYTHROUGH=0"):
                    play(path)(self)
                self.assertNotIn(path, RESULTS)
        with mock.patch.dict(os.environ, {"NEWGOLD_PLAYTHROUGH": "1"}):
            self.assertTrue(playthrough())
        with mock.patch.dict(os.environ):
            os.environ.pop("NEWGOLD_PLAYTHROUGH", None)
            self.assertTrue(playthrough())

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
            # The index (moov) comes before the frames (mdat), so a player
            # that streams a long run's file can start at once: written at
            # the end, a 700 MB playthrough played black in the app.
            boxes, at = [], 0
            with open(clip, "rb") as mp4:
                size = mp4.seek(0, 2)
                while at < size:
                    mp4.seek(at)
                    length, kind = struct.unpack(">I4s", mp4.read(8))
                    if length == 1:
                        length = struct.unpack(">Q", mp4.read(8))[0]
                    boxes.append(kind.decode())
                    at += length
            self.assertLess(boxes.index("moov"), boxes.index("mdat"), boxes)

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


class HarnessToolTests(unittest.TestCase):
    """The harness's scripts run as Paolo runs them: a process each."""

    def test_step_mode_keeps_the_cores_chatter_out(self):
        # 'scene.py SAVE OUT STEPS' let melonDS DS print its own lines among
        # scene.py's -- a retro_get_memory_data line at every read of main
        # RAM, 600,000 lines a playthrough leg; --scenario never did.
        if not ROM.exists() or not core.MELONDSDS.exists():
            self.skipTest("the diagnostics ROM or melonDS DS is not there")
        with tempfile.TemporaryDirectory(prefix="newgold-steps-") as temp:
            run = subprocess.run([sys.executable, str(DIAG / "scene.py"), "new", temp, "wait:30"], capture_output=True,
                                 text=True, timeout=600, env={**os.environ, "NEWGOLD_CORE": str(core.MELONDSDS)})
        self.assertEqual(run.returncode, 0, run.stderr[-2000:])
        self.assertNotIn("retro_get_memory_data", run.stdout + run.stderr)
        lines = run.stdout.splitlines()
        self.assertEqual(len(lines), 1, lines[:5])
        self.assertIn("| battle ", lines[0])         # markers.describe's, the step mode's last word

    def test_an_in_game_save_on_melonds_093_is_refused_at_once(self):
        # melonDS 0.9.3 never writes its .sav, so ingame_save.py's path for
        # it played a whole save to end "the flash did not change"; it is
        # refused before anything is played, as scene.py's save step is.
        if not ROM.exists() or not core.MELONDS.exists():
            self.skipTest("the diagnostics ROM or melonDS 0.9.3 is not there")
        with tempfile.TemporaryDirectory(prefix="newgold-ingame-") as temp:
            flash, out = Path(temp) / "empty.sav", Path(temp) / "out.sav"
            flash.write_bytes(bytes(0x80000))
            run = subprocess.run([sys.executable, str(DIAG / "ingame_save.py"), str(flash), str(out)], capture_output=True,
                                 text=True, timeout=600, env={**os.environ, "NEWGOLD_CORE": str(core.MELONDS)})
            self.assertEqual(run.returncode, 1, run.stderr[-2000:])
            self.assertIn("hands no flash back: an in-game save needs melonDS DS", run.stdout)
            self.assertFalse(out.exists())


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

    def test_kurt_s_house_runs_its_frame_table_on_his_variable(self):
        self.assertEqual(scene.frame_table(164), [("VAR_UNK_4080", 2)])    # MAP_AZALEA_KURT_HOUSE
        self.assertEqual(scene.frame_table(180), [])                        # MAP_AZALEA_GYM

    def test_field_and_goto_wait_for_a_frame_table_script_due(self):
        # field let go on the first frame the player could move, and goto 16
        # frames after its goal, while a script was about to run: Kurt's on
        # arriving in his house (VAR_UNK_4080 2) some 30 frames later, a
        # coord event's on the goal with its message not through. Faked: the
        # player may move throughout, a frame-table script due until 30.
        from unittest import mock

        class Core:
            frames, buttons = 0, set()

            def step(self, frames, hold):
                self.frames += frames

            def press(self, key, frames, hold):
                self.frames += frames
        fake = object.__new__(scene.Scene)
        fake.core, fake.hooks, fake.say = Core(), [], lambda line: None
        fake.in_battle = lambda: False
        fake.movable = lambda: True
        fake.textbox = lambda: False
        fake._chain = lambda *fields: 1
        fake.walls, fake.standing = set(), (lambda here: here + (0,))
        fake.frame_script_due = lambda: "VAR_UNK_4080" if fake.core.frames < 30 else None
        fake.run("field")
        self.assertEqual(fake.core.frames, 30)
        fake.core.frames = 0
        fake.location = lambda: (164, 3, 4)
        fake.objects = lambda: {}
        with mock.patch.object(scene, "tile", lambda *at: (164, 0)):
            done, said = fake.goto((164, 3, 4))
        self.assertTrue(done, said)
        self.assertGreaterEqual(fake.core.frames, 30)
        # and a script the goal sets off, its text box up until frame 60
        fake.core.frames = 0
        fake.frame_script_due = lambda: None
        fake.movable = lambda: not 16 <= fake.core.frames < 60
        fake.textbox = lambda: not fake.movable()
        with mock.patch.object(scene, "tile", lambda *at: (164, 0)):
            done, said = fake.goto((164, 3, 4))
        self.assertTrue(done, said)
        self.assertGreaterEqual(fake.core.frames, 60)

    def test_a_walk_keeps_to_the_floor_the_player_stands_on(self):
        # Goldenrod Gym's walkways stand 52 over its floor, its arches a
        # walkway over a path, none of which the tile attributes say: the
        # walk to Whitney, on the walkway over the arch at (13, 10), pressed
        # up into the floor below. The BDHC's heights: a step that climbs
        # 20 or more is no step, so the walk takes the stairs and the floor,
        # and goes under the arch to her; the side walls a behaviour names
        # (0x30 to 0x37) are kept too.
        gym = scene.savedit.constants("include/constants/maps.h", "MAP_")["MAP_GOLDENROD_GYM"]
        self.assertEqual(sorted(scene.heights(gym, 13, 10)[1]), [0, 52])
        self.assertEqual(sorted(scene.heights(gym, 4, 17)[1]), [26])           # a stair
        self.assertIsNone(scene.plan((gym, 13, 10, 52), [(gym, 13, 9)], most=50))
        self.assertEqual(scene.plan((gym, 13, 10, 0), [(gym, 13, 9)]), [((gym, 13, 10), "UP"), ((gym, 13, 9), None)])
        path = [node for node, _ in scene.plan((gym, 6, 24), [(gym, 13, 5)])]
        self.assertEqual(path.count((gym, 13, 10)), 2)                        # over the arch, then under it
        self.assertEqual(path[-6:], [(gym, 13, 10), (gym, 13, 9), (gym, 13, 8), (gym, 13, 7), (gym, 13, 6), (gym, 13, 5)])
        self.assertEqual(scene.behaviours()["walls"]["LEFT"] & {0x31}, {0x31})
        self.assertNotIn((gym, 9, 25), [node for node, _ in scene.plan((gym, 8, 25), [(gym, 10, 25)]) or []][1:2])

    def test_a_lift_up_is_planned_as_flat_when_no_stair_climbs(self):
        # Violet Gym's upper floor is reached by the lift at (15, 20), a
        # script: on the floor's heights there is no way to Falkner, so goto
        # plans that one as if none climbed (the walk before the heights).
        maps = scene.savedit.constants("include/constants/maps.h", "MAP_")
        pc, gym = maps["MAP_VIOLET_POKECENTER_1F"], maps["MAP_VIOLET_GYM"]
        self.assertIsNone(scene.plan((pc, 8, 13), [(gym, 15, 5)]))
        self.assertIsNotNone(scene.plan((pc, 8, 13), [(gym, 15, 5)], climb=False))

    def test_a_goto_tells_a_wall_from_someone_in_the_way(self):
        # Stuck before a tile no one stands on, goto learns a wall (the
        # step, kept for the scene); before someone, it waits for them to
        # walk on, as it always did.
        from unittest import mock
        tiles = iter([(1, 5, 5)] * 60 + [(1, 6, 5)] * 4)

        class Core:
            frames, buttons = 0, set()

            def step(self, frames, hooks):
                self.frames += frames
        s = scene.Scene.__new__(scene.Scene)
        s.core, s.hooks, s.walls, s.say = Core(), [], set(), (lambda line: None)
        s.in_battle, s.movable = (lambda: False), (lambda: True)
        s.location = lambda: next(tiles, (1, 6, 5))
        s.objects = lambda: {}
        s.standing = lambda here: here + (0,)
        s.frame_script_due = lambda: None
        plans = []

        def plan(here, goals, blocked=frozenset(), most=0, walls=frozenset()):
            plans.append(walls)
            return [(here[:3], "RIGHT" if not walls else "DOWN"), ((1, 6, 5), None)]
        with mock.patch.object(scene, "plan", plan), mock.patch.object(scene, "tile", lambda m, x, z: (m, 0)):
            done, said = s.goto((1, 6, 5), frames=500)
        self.assertTrue(done, said)
        self.assertEqual(s.walls, {((1, 5, 5, 0), "RIGHT")})
        self.assertEqual(plans[-1], frozenset({((1, 5, 5, 0), "RIGHT")}))

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


def chained(path):
    """Whether a scenario is a leg of a chain (the playthrough): it names the
    leg before it, or another leg names it."""
    return "from" in json.loads(path.read_text()) or any(
        json.loads(other.read_text()).get("from") == path.stem for other in SCENARIOS.glob("*.json"))


def playthrough():
    """Whether this run plays the chains: not under NEWGOLD_PLAYTHROUGH=0,
    which leaves their legs out -- the playthrough alone plays for well over
    an hour."""
    return os.environ.get("NEWGOLD_PLAYTHROUGH", "1") != "0"


WORKERS = 3                 # scene.py processes at once, an emulator each, unless NEWGOLD_WORKERS
RESULTS = {}                # a scenario's path -> the Future of run(path)


def chain_from():
    """NEWGOLD_CHAIN_FROM's directory, where each leg finds the save of the
    leg before it (scene.py --from), or None: the legs play as one chain."""
    return Path(os.environ["NEWGOLD_CHAIN_FROM"]) if os.environ.get("NEWGOLD_CHAIN_FROM") else None


def run(path):
    """One scenario played by scene.py: (its exit code, its report)."""
    start = ["--from", str(chain_from())] if chain_from() else []
    done = subprocess.run([sys.executable, str(DIAG / "scene.py"), "--scenario", str(path), "--chain", CHAIN.name,
                           *start], capture_output=True, text=True, timeout=1800 * (1 if start else legs(path)))
    return done.returncode, done.stdout.strip() or done.stderr.strip()[-2000:]


def seconds(path):
    """How long a leg played in NEWGOLD_CHAIN_FROM's run, by the report it
    left there ("PASS NAME.json: N frames in S s"); 0 when it left none."""
    report = chain_from() / f"{path.stem}.txt"
    played = re.search(r" in (\d+) s", report.read_text()) if report.exists() else None
    return int(played[1]) if played else 0


def jobs(paths):
    """The scenarios as the workers take them: each alone, but the legs of a
    chain together, first leg first; the longest job first. Under
    NEWGOLD_CHAIN_FROM every leg is a job alone, the longest there first."""
    if chain_from():
        return sorted(([path] for path in paths), key=lambda job: seconds(job[0]), reverse=True)

    def first(path):
        before = json.loads(path.read_text()).get("from")
        return first(SCENARIOS / f"{before}.json") if before else path
    chains = {}
    for path in paths:
        chains.setdefault(first(path), []).append(path)
    return sorted((sorted(job, key=legs) for job in chains.values()), key=len, reverse=True)


def start(paths):
    """Play `paths` in the background, NEWGOLD_WORKERS (or WORKERS) at a
    time; RESULTS holds a Future for each."""
    def work(job):
        for path in job:
            try:
                RESULTS[path].set_result(run(path))
            except Exception as e:
                RESULTS[path].set_exception(e)
    paths = [path for path in paths if path not in RESULTS]
    for path in paths:
        RESULTS[path] = Future()
    pool = ThreadPoolExecutor(int(os.environ.get("NEWGOLD_WORKERS", WORKERS)))
    for job in jobs(paths):
        pool.submit(work, job)
    pool.shutdown(wait=False)


def play(path):
    def test(self):
        if not playthrough() and chained(path):
            self.skipTest("NEWGOLD_PLAYTHROUGH=0: the playthrough's legs are left out")
        if chain_from() and not chain_from().is_dir():
            self.fail(f"NEWGOLD_CHAIN_FROM: {chain_from()} is not a directory")
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
            start([path for path in cls.selected if playthrough() or not chained(path)])


for _path in sorted(SCENARIOS.glob("*.json")):
    setattr(ScenarioTests, f"test_{_path.stem}", play(_path))


if __name__ == "__main__":
    unittest.main()
