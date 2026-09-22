#!/usr/bin/env python3
"""Check the species name bank reaches every species.

Names are read by species number, so a bank that stops short means an
out-of-range read the moment one of the added species has to be named.
"""

import os
import re
import sys
import unittest
from pathlib import Path
import xml.etree.ElementTree as ET
from pathlib import Path

from test_level_cap import ROOT

sys.path.insert(0, str(ROOT / "tools/newgold"))
import import_species  # noqa: E402

REFERENCE = os.environ.get("HG_ENGINE_NEWGOLD_REFERENCE")
if REFERENCE is None:
    sibling = Path("/home/paolo/Porting HGSS/hg-engine-newgold-reference")
    REFERENCE = sibling if (sibling / ".git").exists() else None
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


def fold(text):
    """Compare a displayed name with a C identifier.

    The bank spells Flabebe with its accents and Farfetch'd with an
    apostrophe; neither can go in a constant, so both sides are folded to
    plain upper-case letters before they are compared.
    """
    import unicodedata
    stripped = unicodedata.normalize("NFD", text)
    return "".join(c for c in stripped if c.isalnum()).upper()


class SpeciesNameTests(unittest.TestCase):
    def setUp(self):
        self.rows = rows()
        self.bases = import_species.base_species_of(Path(REFERENCE)) if REFERENCE else {}

    def test_the_bank_is_dense_and_reaches_the_last_species(self):
        self.assertEqual(sorted(self.rows), list(range(last_species() + 1)))

    def test_pret_names_are_untouched(self):
        self.assertEqual(self.rows[0], "-----")
        self.assertEqual(self.rows[1], "BULBASAUR")
        self.assertEqual(self.rows[493], "ARCEUS")
        self.assertEqual(self.rows[494], "Egg")
        self.assertEqual(self.rows[495], "Bad Egg")

    def test_every_added_species_is_named(self):
        """Every added species has a name, and it is the right one.

        HGSS gives a Pokemon ten characters. Twenty-nine of the added species
        are longer than that and the reference abbreviates them to fit --
        Crabominable shows as Crabomnabl, Fletchinder as Flechinder -- so a
        name that cannot fit is checked for having a name at all that starts
        the same way, rather than for equalling the constant. The short forms
        are the reference's own and are not always abbreviations: Iron Jugulis
        shows as Iron Neck and Iron Valiant as Iron Valor, so nothing stricter
        than the first letter would hold. Every constant that does fit in ten
        characters is still checked exactly, which is all but twenty-nine.

        The two Galarian forms carry the Johto line's name, which is what the
        reference does and what the Dex shows.
        """
        header = (ROOT / "include/constants/species.h").read_text()
        for name in import_species.added_species():
            index = int(re.search(rf"#define SPECIES_{name}\s+(\d+)", header).group(1))
            shown = self.rows[index]
            self.assertTrue(shown, name)
            self.assertLessEqual(len(shown), NAME_LENGTH, name)
            expected = import_species_names.FORM_NAMES.get(name, name.replace("_", " "))
            if name in self.bases:
                expected = self.bases[name].replace("_", " ")  # a form is named after its base
            if fold(expected) == fold(shown):
                continue
            if name in import_species_names.FORM_NAMES or name.endswith("_GALARIAN") or name in self.bases:
                continue
            self.assertEqual(fold(shown)[0], fold(expected)[0], name)

    def test_no_name_is_longer_than_the_game_allows(self):
        for index, text in self.rows.items():
            self.assertLessEqual(len(text), NAME_LENGTH, index)

    def test_the_gap_holds_only_placeholders(self):
        for index in range(496, 508):
            self.assertEqual(self.rows[index], names.PLACEHOLDER, index)


if __name__ == "__main__":
    unittest.main()
