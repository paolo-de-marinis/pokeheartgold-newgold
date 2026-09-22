#!/usr/bin/env python3
"""Every species' icon is the entry the game reads for it.

GetMonIconNaixEx maps a species past Arceus to FIRST_ADDED_ICON plus its
distance from the first added species, so the icon files have to be written
at exactly those entries. The importer once wrote them at "the first free
entry" instead, which is a different number on a second run: the forms
imported later landed 733 entries past where the game looks, and every one
of them would have shown another Pokemon's icon.
"""

import filecmp
import os
import re
import sys
import unittest
from pathlib import Path

from test_level_cap import ROOT

sys.path.insert(0, str(ROOT / "tools/newgold"))
import import_species  # noqa: E402

ICONS = ROOT / "files/poketool/icongra/poke_icon"
REFERENCE = os.environ.get("HG_ENGINE_NEWGOLD_REFERENCE")
if REFERENCE is None:
    sibling = Path("/home/paolo/Porting HGSS/hg-engine-newgold-reference")
    REFERENCE = sibling if (sibling / ".git").exists() else None


class IconPlaceTests(unittest.TestCase):
    def setUp(self):
        source = (ROOT / "src/pokemon_icon_idx.c").read_text()
        self.first = int(re.search(r"#define FIRST_ADDED_ICON\s+(\d+)", source).group(1))
        self.added = import_species.added_species()

    def test_the_added_species_fill_the_entries_the_game_reads(self):
        for offset in (0, len(self.added) // 2, len(self.added) - 1):
            entry = ICONS / f"poke_icon_{self.first + offset:08d}.png"
            self.assertTrue(entry.exists(), f"{self.added[offset]} has no icon at {entry.name}")

    def test_no_entry_is_written_past_the_last_species(self):
        last = self.first + len(self.added) - 1
        stray = sorted(int(m.group(1)) for m in
                       (re.match(r"poke_icon_0*(\d+)\.png$", p.name) for p in ICONS.iterdir()) if m and int(m.group(1)) > last)
        self.assertEqual(stray, [], "icons past the last species the lookup can ask for")

    def test_each_icon_is_the_right_species(self):
        if REFERENCE is None:
            self.skipTest("reference checkout not present")
        sprites = Path(REFERENCE) / "data/graphics/sprites"
        for offset, name in list(enumerate(self.added))[::97]:
            theirs = sprites / name.lower() / "icon.png"
            ours = ICONS / f"poke_icon_{self.first + offset:08d}.png"
            self.assertTrue(filecmp.cmp(ours, theirs, shallow=False), f"{name} at {ours.name}")


if __name__ == "__main__":
    unittest.main()
