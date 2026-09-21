#!/usr/bin/env python3
"""Check the battle sprite tree stays dense and complete.

A species' pictures live at species * 6 in pokegra.narc, which is built from
whatever directories exist, in name order. A missing directory does not fail
the build: it silently shifts every later species onto the wrong sprite. So the
invariant worth testing is the tree, not the archive.
"""

import re
import sys
import unittest
from pathlib import Path

from test_level_cap import ROOT

sys.path.insert(0, str(ROOT / "tools/newgold"))
import import_species  # noqa: E402
import import_sprites  # noqa: E402

SPRITES = ROOT / "files/poketool/pokegra/pokegra"
PICTURES_PER_SPECIES = 6


def last_species():
    header = (ROOT / "include/constants/species.h").read_text()
    name = re.search(r"#define NUM_SPECIES SPECIES_([A-Z0-9_]+)", header).group(1)
    return int(re.search(rf"#define SPECIES_{name}\s+(\d+)", header).group(1))


class SpriteTreeTests(unittest.TestCase):
    def setUp(self):
        self.slots = sorted(int(p.name) for p in SPRITES.iterdir() if p.name.isdigit())

    def test_the_tree_is_dense(self):
        self.assertEqual(self.slots, list(range(len(self.slots))))

    def test_every_species_has_a_slot(self):
        self.assertEqual(self.slots[-1], last_species())

    def test_each_slot_can_produce_all_six_entries(self):
        for slot in self.slots:
            directory = SPRITES / f"{slot:04d}"
            for gender in ("male", "female"):
                for picture in ("front.png", "back.png"):
                    self.assertTrue((directory / gender / picture).exists(), f"{slot} {gender} {picture}")
            # A palette is built from whichever gender has a picture; a slot
            # with neither would produce no palette and shift the archive.
            for picture in ("front.png", "back.png"):
                sizes = [(directory / gender / picture).stat().st_size for gender in ("male", "female")]
                self.assertTrue(any(sizes), f"{slot} has no {picture} at all")

    def test_new_species_have_pictures(self):
        """A picture from each side, under whichever gender has one.

        Eight of the added species are female only -- Vullaby, Salazzle,
        Tsareena and the rest -- so the reference has no male picture for them
        and neither does this. What must not happen is a slot with no picture
        at all, which would leave the archive a member short and shift every
        species after it.
        """
        for index, name in enumerate(import_species.added_species()):
            directory = SPRITES / f"{508 + index:04d}"
            for picture in ("front.png", "back.png"):
                sizes = [(directory / gender / picture).stat().st_size
                         for gender in ("male", "female")]
                self.assertTrue(any(sizes), f"{name} has no {picture} at all")

    def test_padding_slots_are_only_padding(self):
        # 494 to 507 are the egg, the bad egg and the alternate forms, whose
        # pictures come from otherpoke.narc.
        for slot in range(import_sprites.FIRST_PADDED, import_sprites.LAST_PADDED + 1):
            directory = SPRITES / f"{slot:04d}"
            source = SPRITES / import_sprites.PADDING_SOURCE
            self.assertEqual((directory / "male/front.png").read_bytes(),
                             (source / "male/front.png").read_bytes(), slot)

    def test_a_female_picture_is_empty_or_has_its_key(self):
        for slot in self.slots:
            directory = SPRITES / f"{slot:04d}"
            for picture in ("front.png", "back.png"):
                path = directory / "female" / picture
                if path.stat().st_size:
                    self.assertTrue(path.with_suffix(path.suffix + ".key").exists(), f"{slot} {picture}")


if __name__ == "__main__":
    unittest.main()
