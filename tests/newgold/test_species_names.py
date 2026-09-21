#!/usr/bin/env python3
"""Check the species name bank reaches every species.

Names are read by species number, so a bank that stops short means an
out-of-range read the moment one of the added species has to be named.
"""

import re
import sys
import unittest
import xml.etree.ElementTree as ET
from pathlib import Path

from test_level_cap import ROOT

sys.path.insert(0, str(ROOT / "tools/newgold"))
import import_species  # noqa: E402
import import_species_names  # noqa: E402
import import_species_names as names  # noqa: E402

BANK = ROOT / "files/msgdata/msg/msg_0237.gmm"
NAME_LENGTH = int(re.search(r"#define POKEMON_NAME_LENGTH (\d+)",
                            (ROOT / "include/constants/global.h").read_text()).group(1))


def rows():
    parsed = ET.parse(BANK).getroot().findall("row")
    return {int(row.get("index")): row.find("language[@name='English']").text for row in parsed}


def last_species():
    header = (ROOT / "include/constants/species.h").read_text()
    name = re.search(r"#define NUM_SPECIES SPECIES_([A-Z0-9_]+)", header).group(1)
    return int(re.search(rf"#define SPECIES_{name}\s+(\d+)", header).group(1))


class SpeciesNameTests(unittest.TestCase):
    def setUp(self):
        self.rows = rows()

    def test_the_bank_is_dense_and_reaches_the_last_species(self):
        self.assertEqual(sorted(self.rows), list(range(last_species() + 1)))

    def test_pret_names_are_untouched(self):
        self.assertEqual(self.rows[0], "-----")
        self.assertEqual(self.rows[1], "BULBASAUR")
        self.assertEqual(self.rows[493], "ARCEUS")
        self.assertEqual(self.rows[494], "Egg")
        self.assertEqual(self.rows[495], "Bad Egg")

    # Three names are one letter too long for the ten characters HGSS gives a
    # Pokemon, so the reference shortens them and this keeps its spelling.
    SHORTENED = {
        "FLETCHINDER": "FLECHINDER",
        "CENTISKORCH": "CENTSKORCH",
        "DUDUNSPARCE": "DUDUNSPARS",
    }

    def test_every_added_species_is_named(self):
        header = (ROOT / "include/constants/species.h").read_text()
        for name in import_species.NEW_SPECIES:
            index = int(re.search(rf"#define SPECIES_{name}\s+(\d+)", header).group(1))
            expected = import_species_names.FORM_NAMES.get(
                name, self.SHORTENED.get(name, name.replace("_", " ")))
            self.assertEqual(self.rows[index].upper(), expected.upper(), name)
            if name in self.SHORTENED:
                self.assertEqual(len(name), NAME_LENGTH + 1, name)

    def test_no_name_is_longer_than_the_game_allows(self):
        for index, text in self.rows.items():
            self.assertLessEqual(len(text), NAME_LENGTH, index)

    def test_the_gap_holds_only_placeholders(self):
        for index in range(496, 508):
            self.assertEqual(self.rows[index], names.PLACEHOLDER, index)


if __name__ == "__main__":
    unittest.main()
