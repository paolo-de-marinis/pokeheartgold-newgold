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
    header = (ROOT / "include/pokemon_icon_idx.h").read_text()
    return int(re.search(rf"#define {name}\s+(\d+)", header).group(1))


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

    def test_every_icon_is_built_4bpp(self):
        # The game reads an icon as 4bpp. nitrogfx builds an 8-bit PNG (16 of
        # the reference's, Walking Wake's among them) as 8bpp unless the rule
        # says otherwise, and such an icon showed as stripes.
        rule = (ICONS / "poke_icon.mk").read_text()
        flags = re.search(r"^POKE_ICON_GFX_FLAGS_ICON := (.*)$", rule, re.M).group(1)
        self.assertIn("-bitdepth 4", flags)
        built = sorted(ICONS.glob("poke_icon_*.NCGR"))
        if not built:
            self.skipTest("the icons are not built")
        for path in built:
            data = path.read_bytes()
            # the CHAR block's depth field: 3 is 4bpp; a 32x64 icon is 1024 bytes
            self.assertEqual((data[0x1C], len(data) - 0x30), (3, 1024), path.name)

    def test_an_icon_takes_the_palette_it_is_drawn_in(self):
        # The reference names palette 0 for Iron Leaves and twenty others
        # whose PNG carries another of the three shared palettes' colours;
        # Iron Leaves showed yellow and orange.
        from import_icons import drawn_in, shared_palettes
        shared = shared_palettes()
        table = [int(v) for v in palette_table()]
        checked = 0
        for offset, name in enumerate(import_species.added_species()):
            drawn = drawn_in(ICONS / f"poke_icon_{self.firstIcon + offset:08d}.png", shared)
            if drawn is not None:
                self.assertEqual(table[self.firstPalette + offset], drawn, name)
                checked += 1
        self.assertGreater(checked, 100)
        offset = import_species.added_species().index("IRON_LEAVES")
        self.assertEqual(table[self.firstPalette + offset], 1)


if __name__ == "__main__":
    unittest.main()
