#!/usr/bin/env python3
"""Check the level-up learnset archive.

The archive is a binary pret ships, so the risk in extending it is silently
rewriting what was already there. HeartGold's own species and alternate forms
are compared against the reference's learnsets, the two eggs against the blob
on upstream/master, and every new species is checked for a usable one.
"""

import subprocess
import sys
import re
import unittest
from pathlib import Path

from test_level_cap import ROOT
from test_repels import REFERENCE

sys.path[:0] = [str(ROOT / "tools/newgold" / sub) for sub in ("import", "devkit", "devkit/harness", "devkit/diag")]
import wotbl  # noqa: E402
import import_species  # noqa: E402

ARCHIVE = "files/poketool/personal/wotbl.narc"


def upstream_archive():
    result = subprocess.run(["git", "show", f"upstream/master:{ARCHIVE}"],
                            cwd=ROOT, capture_output=True)
    return result.stdout if result.returncode == 0 else None


class LearnsetTests(unittest.TestCase):
    def setUp(self):
        self.files, _, _ = wotbl.read_narc((ROOT / ARCHIVE).read_bytes())
        self.names = wotbl.species_names()

    def test_every_species_has_a_learnset(self):
        self.assertEqual(len(self.files), max(self.names) + 1)

    def test_every_entry_round_trips(self):
        for index, raw in enumerate(self.files):
            self.assertEqual(wotbl.encode(wotbl.decode(raw)), raw, self.names.get(index, index))

    # HeartGold's own species learn what New Gold teaches them: hg-engine's
    # learnsets from the revision it forked from -- the latest games', not
    # pret's Generation IV ones -- with the fifteen konefr changed on top.
    LEARNSETS_REVISION = wotbl.KONEFR_TIP

    @unittest.skipIf(REFERENCE is None, "the reference checkout is not here")
    def test_retail_species_learn_the_reference_s_moves(self):
        reference = wotbl.reference_learnsets(REFERENCE, self.LEARNSETS_REVISION)
        moves = wotbl.move_names()
        for index in list(range(1, wotbl.LAST_RETAIL_SPECIES + 1)) + list(wotbl.NUMBERED_FORMS):
            name = self.names[index]
            entry = reference.get(wotbl.reference_key(index, self.names))
            if entry is None:
                # Only where the reference has none: Trash Cloak Wormadam.
                entry = wotbl.REFERENCE_DEFECTS[index]
            wanted = [{"level": step["Level"], "move": moves[step["Move"]]} for step in entry["LevelMoves"]]
            self.assertEqual(wotbl.decode(self.files[index]), wanted, name)

    def test_dunsparce_learns_hyper_drill(self):
        # The one way to Dudunsparce: it evolves knowing Hyper Drill.
        moves = wotbl.move_names()
        dunsparce = next(i for i, n in self.names.items() if n == "DUNSPARCE")
        self.assertIn({"level": 32, "move": moves["MOVE_HYPER_DRILL"]},
                      wotbl.decode(self.files[dunsparce]))

    def test_the_eggs_are_pret_s(self):
        original = upstream_archive()
        if original is None:
            self.skipTest("upstream/master is not fetched")
        theirs, _, _ = wotbl.read_narc(original)
        self.assertEqual(len(theirs), 508)
        # Not byte for byte: the entry is a word now, because a move numbered
        # past 511 does not fit the halfword pret packed it into. What has to
        # match is what the entries say.
        for index in [494, 495]:
            self.assertEqual(wotbl.decode(self.files[index]), wotbl.decode_retail(theirs[index]),
                             self.names.get(index, index))

    def test_the_retail_forms_learn_the_later_games_moves(self):
        # Retail's forms kept the fourth generation's lists: Heat Rotom had
        # Ominous Wind at 29 and no Electro Ball, Attack Forme Deoxys no
        # Psyshock, Sandy Cloak Wormadam nothing on evolving.
        moves = wotbl.move_names()
        heat = wotbl.decode(self.files[503])
        self.assertIn({"level": 20, "move": moves["MOVE_ELECTRO_BALL"]}, heat)
        self.assertNotIn(moves["MOVE_OMINOUS_WIND"], [step["move"] for step in heat])
        self.assertIn({"level": 25, "move": moves["MOVE_PSYSHOCK"]}, wotbl.decode(self.files[496]))
        self.assertIn({"level": 0, "move": moves["MOVE_QUIVER_DANCE"]}, wotbl.decode(self.files[499]))

    def test_trash_cloak_wormadam_learns_its_own_moves(self):
        # The reference gives it none; retail's list had Mirror Shot at 26,
        # a move the eighth generation took out.
        moves = wotbl.move_names()
        trash = wotbl.decode(self.files[500])
        for level, move in ((0, "QUIVER_DANCE"), (26, "METAL_BURST"), (29, "METAL_SOUND"), (47, "IRON_HEAD")):
            self.assertIn({"level": level, "move": moves["MOVE_" + move]}, trash)
        self.assertNotIn(moves["MOVE_MIRROR_SHOT"], [step["move"] for step in trash])

    def test_new_species_can_fight(self):
        for name in import_species.added_species():
            index = next(i for i, n in self.names.items() if n == name)
            moves = wotbl.decode(self.files[index])
            self.assertTrue(moves, name)
            # Something is available as soon as the Pokemon is obtained.
            self.assertLessEqual(min(step["level"] for step in moves), 1, name)
            for step in moves:
                self.assertLessEqual(step["move"], wotbl.MOVE_MASK, name)
                self.assertLessEqual(step["level"], 100, name)

    def test_moves_exist(self):
        known = set(wotbl.move_names().values())
        for index, raw in enumerate(self.files):
            for step in wotbl.decode(raw):
                self.assertIn(step["move"], known | {0}, self.names.get(index, index))


class LearnsetBufferTests(unittest.TestCase):
    """The buffer a learnset is read into has to hold the longest one.

    ReadWholeNarcMemberByIdPair writes the whole member whatever the buffer
    is, so a learnset longer than the constant says overruns the heap and
    nothing complains. Retail's longest was twenty-one moves, which is where
    the constant came from; the expansion's species brought a longer one.
    """

    def setUp(self):
        self.files, _, _ = wotbl.read_narc((ROOT / ARCHIVE).read_bytes())
        header = (ROOT / "include/pokemon.h").read_text()
        self.longest = int(re.search(r"#define LEVEL_UP_LEARNSET_MAX\s+(\d+)", header).group(1))

    def test_the_constant_is_the_longest_learnset_there_is(self):
        self.assertEqual(max(len(wotbl.decode(raw)) for raw in self.files), self.longest)

    def test_no_member_is_larger_than_the_buffer(self):
        self.assertLessEqual(max(len(raw) for raw in self.files),
                             (self.longest + 1) * wotbl.ENTRY_SIZE)

    def test_every_reader_asks_for_that_buffer(self):
        for path in ("src/pokemon.c", "src/move_relearner.c"):
            text = (ROOT / path).read_text()
            for line in text.splitlines():
                if "Heap_Alloc" in line and "LEVEL_UP" in line or "levelUpLearnset = Heap_Alloc" in line:
                    self.assertIn("LEVEL_UP_LEARNSET_SIZE", line, f"{path}: {line.strip()}")


if __name__ == "__main__":
    unittest.main()
