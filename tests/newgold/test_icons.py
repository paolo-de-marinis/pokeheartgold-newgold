#!/usr/bin/env python3
"""Check the party icons and the numbering that reaches them.

A species' icon is found by arithmetic, not by name, and the range just past
the last species already belongs to the alternate forms. So the risk is an
index that quietly lands on somebody else's picture.
"""

import re
import sys
import unittest
from pathlib import Path

from test_level_cap import ROOT

sys.path[:0] = [str(ROOT / "tools/newgold" / sub) for sub in ("import", "devkit", "devkit/harness", "devkit/diag")]
import import_species  # noqa: E402

ICONS = ROOT / "files/poketool/icongra/poke_icon"
SOURCE = (ROOT / "src/pokemon_icon_idx.c").read_text()


def constant(name):
    return int(re.search(rf"#define {name}\s+(\d+)", SOURCE).group(1))


def species_id(name):
    header = (ROOT / "include/constants/species.h").read_text()
    return int(re.search(rf"#define SPECIES_{name}\s+(\d+)", header).group(1))


def palette_table():
    start = SOURCE.index("sPokemonPalNoBySpeciesAndForm[] = {")
    return re.findall(r"^\s*(\d+),", SOURCE[start:SOURCE.index("\n};", start)], re.M)


class IconTests(unittest.TestCase):
    def setUp(self):
        self.pictures = {int(m.group(1)) for m in
                         (re.match(r"poke_icon_0*(\d+)\.png$", p.name) for p in ICONS.iterdir()) if m}
        self.firstIcon = constant("FIRST_ADDED_ICON")
        self.firstPalette = constant("FIRST_ADDED_PALETTE")
        self.first = species_id(import_species.added_species()[0])
        self.last = species_id(import_species.added_species()[-1])

    def test_the_new_range_starts_clear_of_the_form_icons(self):
        # Everything HGSS names must come before the range we took.
        reserved = {index for index in self.pictures if index < self.firstIcon}
        self.assertEqual(max(reserved) + 1, self.firstIcon)

    def test_every_new_species_has_an_icon(self):
        for offset, name in enumerate(import_species.added_species()):
            self.assertIn(self.firstIcon + offset, self.pictures, name)

    def test_no_new_icon_lands_on_an_old_one(self):
        taken = {index for index in self.pictures if index < self.firstIcon}
        wanted = {self.firstIcon + offset for offset in range(len(import_species.added_species()))}
        self.assertFalse(taken & wanted)

    def test_the_palette_table_covers_the_new_species(self):
        table = palette_table()
        self.assertEqual(len(table), self.firstPalette + len(import_species.added_species()))
        for value in table:
            self.assertIn(int(value), (0, 1, 2))

    def test_both_lookups_recognise_the_new_range(self):
        # The index and the palette must agree on which species are new.
        self.assertEqual(SOURCE.count("species >= SPECIES_LILLIPUP && species <= NUM_SPECIES"), 2)
        self.assertEqual(self.last - self.first + 1, len(import_species.added_species()))


if __name__ == "__main__":
    unittest.main()
