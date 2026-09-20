#!/usr/bin/env python3
"""Check the ability list.

An ability added under a name the repository already has, spelled differently,
gets a second number that no battle code reads: the Pokemon carrying it would
appear to have the ability and it would do nothing. That is invisible until
someone plays the battle, so it is checked here.
"""

import json
import re
import unittest
from pathlib import Path

from test_level_cap import ROOT

HEADER = ROOT / "include/constants/abilities.h"
LAST_VANILLA = 123
SAVED_ABILITY_BITS = 9


def abilities():
    return [(m.group(1), int(m.group(2))) for m in
            re.finditer(r"#define ABILITY_([A-Z0-9_]+)\s+(\d+)", HEADER.read_text())]


class AbilityTests(unittest.TestCase):
    def setUp(self):
        self.abilities = abilities()
        self.added = [(name, value) for name, value in self.abilities if value > LAST_VANILLA]

    def test_numbers_are_unique_and_dense(self):
        values = [value for _, value in self.abilities]
        self.assertEqual(sorted(values), list(range(len(values))))

    def test_no_added_ability_repeats_one_that_exists(self):
        squash = lambda name: name.replace("_", "")
        existing = {squash(name): name for name, value in self.abilities if value <= LAST_VANILLA}
        for name, value in self.added:
            self.assertNotIn(squash(name), existing,
                             f"ABILITY_{name} repeats ABILITY_{existing.get(squash(name))}")

    def test_every_ability_fits_the_saved_record(self):
        # A saved Pokemon keeps nine bits of ability.
        for name, value in self.abilities:
            self.assertLess(value, 1 << SAVED_ABILITY_BITS, name)

    def test_the_egg_marker_matches_no_ability_in_play(self):
        marker = re.search(r"#define NUM_ABILITIES ABILITY_([A-Z0-9_]+)", HEADER.read_text()).group(1)
        self.assertEqual(marker, "BAD_DREAMS")

    def test_species_only_name_abilities_that_exist(self):
        known = {f"ABILITY_{name}" for name, _ in self.abilities}
        records = json.loads((ROOT / "files/poketool/personal/personal.json").read_text())["baseStats"]
        for record in records:
            for ability in record["abilities"]:
                self.assertIn(ability, known, record["species"])


if __name__ == "__main__":
    unittest.main()
