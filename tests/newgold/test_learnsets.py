#!/usr/bin/env python3
"""Check the level-up learnset archive.

The archive is a binary pret ships, so the risk in extending it is silently
rewriting what was already there. This compares the first 508 learnsets against
the blob on upstream/master and checks that every new species has a usable one.
"""

import subprocess
import sys
import re
import unittest
from pathlib import Path

from test_level_cap import ROOT

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
        # Not byte for byte: the entry is a word now, because a move numbered
        # past 511 does not fit the halfword pret packed it into. What has to
        # match is what the entries say.
        differing = {names.get(i, str(i)) for i, (a, b)
                     in enumerate(zip(self.files[:len(theirs)], theirs))
                     if wotbl.decode(a) != wotbl.decode_retail(b)}
        # Farigiraf is one of the added species, past the end of pret's data.
        vanilla = {name for index, name in names.items() if index < len(theirs)}
        self.assertEqual(differing, self.KONEFR_LEARNSETS & vanilla)

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
