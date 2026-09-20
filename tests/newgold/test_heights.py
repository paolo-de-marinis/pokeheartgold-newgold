#!/usr/bin/env python3
"""Check the battle sprite height archive.

Every entry is derived from the sprite it belongs to, so the test worth having
is that the derivation still reproduces what pret shipped, and that the archive
covers every species at the index the game reads.
"""

import subprocess
import sys
import unittest
from pathlib import Path

from test_level_cap import ROOT

sys.path.insert(0, str(ROOT / "tools/newgold"))
import heights  # noqa: E402
import wotbl  # noqa: E402

ARCHIVE = "files/poketool/pokegra/height.narc"
SLOTS_PER_SPECIES = 4


def upstream_entries():
    result = subprocess.run(["git", "show", f"upstream/master:{ARCHIVE}"],
                            cwd=ROOT, capture_output=True)
    if result.returncode:
        return None
    files, _, _ = wotbl.read_narc(result.stdout)
    return files


class HeightTests(unittest.TestCase):
    def setUp(self):
        self.entries, _, _ = wotbl.read_narc((ROOT / ARCHIVE).read_bytes())

    def test_one_entry_per_picture(self):
        slots = sorted(int(p.name) for p in heights.SPRITES.iterdir() if p.name.isdigit())
        self.assertEqual(len(self.entries), len(slots) * SLOTS_PER_SPECIES)

    def test_entries_are_a_single_byte_or_empty(self):
        for index, entry in enumerate(self.entries):
            self.assertIn(len(entry), (0, 1), index)

    def test_an_entry_exists_exactly_when_its_picture_does(self):
        for index, entry in enumerate(self.entries):
            slot, offset = divmod(index, SLOTS_PER_SPECIES)
            gender, picture = heights.SLOTS[offset]
            path = heights.SPRITES / f"{slot:04d}" / gender / picture
            self.assertEqual(bool(entry), bool(path.stat().st_size), f"{slot} {gender} {picture}")

    def test_pret_entries_are_unchanged(self):
        theirs = upstream_entries()
        if theirs is None:
            self.skipTest("upstream/master is not fetched")
        self.assertEqual(self.entries[:len(theirs)], theirs)

    def test_the_derivation_still_holds(self):
        # Regenerating from the sprites must give exactly what is on disk.
        self.assertEqual(heights.entries(), self.entries)


if __name__ == "__main__":
    unittest.main()
