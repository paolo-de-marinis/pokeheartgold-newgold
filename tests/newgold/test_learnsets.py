#!/usr/bin/env python3
"""Check the level-up learnset archive.

The archive is a binary pret ships, so the risk in extending it is silently
rewriting what was already there. This compares the first 508 learnsets against
the blob on upstream/master and checks that every new species has a usable one.
"""

import subprocess
import sys
import unittest
from pathlib import Path

from test_level_cap import ROOT

sys.path.insert(0, str(ROOT / "tools/newgold"))
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

    # The vanilla learnsets New Gold changes, and the only ones it changes.
    # hg-engine replaces every learnset with a modern one; konefr changed
    # fifteen of them himself, and those fifteen are what is ported.
    KONEFR_LEARNSETS = {
        "CHIKORITA", "QUILAVA", "CROCONAW", "ARIADOS", "SUDOWOODO", "POLITOED",
        "SKIPLOOM", "JUMPLUFF", "SUNFLORA", "QUAGSIRE", "GIRAFARIG", "DELIBIRD",
        "STANTLER", "AMBIPOM", "FARIGIRAF",
    }

    def test_pret_data_is_untouched_but_for_the_fifteen(self):
        original = upstream_archive()
        if original is None:
            self.skipTest("upstream/master is not fetched")
        theirs, _, _ = wotbl.read_narc(original)
        self.assertEqual(len(theirs), 508)
        names = wotbl.species_names()
        differing = {names.get(i, str(i)) for i, (a, b)
                     in enumerate(zip(self.files[:len(theirs)], theirs)) if a != b}
        # Farigiraf is one of the added species, past the end of pret's data.
        vanilla = {name for index, name in names.items() if index < len(theirs)}
        self.assertEqual(differing, self.KONEFR_LEARNSETS & vanilla)

    def test_new_species_can_fight(self):
        for name in import_species.NEW_SPECIES:
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


if __name__ == "__main__":
    unittest.main()
