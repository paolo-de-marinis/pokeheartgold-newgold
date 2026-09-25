#!/usr/bin/env python3
"""Check the species' text banks: hg-engine's text, at every species.

Names are read by species number, so a bank that stops short means an
out-of-range read the moment one of the added species has to be named. The
text itself is hg-engine's: import_species_text.py writes 237, 238, 803,
811..817 and 823 from Species.c at a revision, and the tree has to be what it
writes at the engine (d0380a487) or at New Gold (ccf2c9f5).
"""

import re
import sys
import unittest
import xml.etree.ElementTree as ET
from unittest import mock

from test_level_cap import ROOT

sys.path[:0] = [str(ROOT / "tools/newgold" / sub) for sub in ("import", "devkit", "devkit/harness", "devkit/diag")]
import gmm  # noqa: E402
import import_species  # noqa: E402
import import_species_text  # noqa: E402

REFERENCE = gmm.REFERENCE if (gmm.REFERENCE / ".git").exists() else None
BANK = ROOT / "files/msgdata/msg/msg_0237.gmm"
NAME_LENGTH = int(re.search(r"#define POKEMON_NAME_LENGTH (\d+)",
                            (ROOT / "include/constants/global.h").read_text()).group(1))
PLACEHOLDER = "-----"


def rows(bank=237):
    parsed = ET.parse(gmm.path_of(bank)).getroot().findall("row")
    return {int(row.get("index")): row.find("language[@name='English']").text or "" for row in parsed}


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
        self.bases = import_species_text.base_species(gmm.ENGINE) if REFERENCE else {}

    def test_the_bank_is_dense_and_reaches_the_last_species(self):
        self.assertEqual(sorted(self.rows), list(range(last_species() + 1)))

    def test_retail_names_are_the_engines(self):
        """hg-engine writes the names in mixed case, retail's included."""
        self.assertEqual(self.rows[0], "-----")
        self.assertEqual(self.rows[1], "Bulbasaur")
        self.assertEqual(self.rows[83], "Farfetch’d")
        self.assertEqual(self.rows[122], "Mr. Mime")
        self.assertEqual(self.rows[250], "Ho-oh")
        self.assertEqual(self.rows[493], "Arceus")
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

        A form is named after its base, which is what hg-engine shows.
        """
        header = (ROOT / "include/constants/species.h").read_text()
        for name in import_species.added_species():
            index = int(re.search(rf"#define SPECIES_{name}\s+(\d+)", header).group(1))
            shown = self.rows[index]
            self.assertTrue(shown and shown != PLACEHOLDER, name)
            self.assertLessEqual(len(shown), NAME_LENGTH, name)
            expected = self.bases.get(name, name).replace("_", " ")
            if fold(expected) == fold(shown) or name in self.bases:
                continue
            self.assertEqual(fold(shown)[0], fold(expected)[0], name)

    def test_no_name_is_longer_than_the_game_allows(self):
        for index, text in self.rows.items():
            self.assertLessEqual(len(text), NAME_LENGTH, index)

    def test_the_gap_holds_only_placeholders(self):
        for index in range(496, 508):
            self.assertEqual(self.rows[index], PLACEHOLDER, index)


class SpeciesTextTests(unittest.TestCase):
    """The engine's text in the other banks, a few rows each, and every row
    of every bank against the importer."""

    def test_engine_rows(self):
        pinned = {
            238: {0: "a -----", 1: "a Bulbasaur", 2: "an Ivysaur", 1042: "a Venusaur"},
            817: {1: "BULBASAUR", 494: "EGG", 508: "LILLIPUP", 1042: "VENUSAUR"},
            816: {1: "Seed Pokémon", 494: "????? Pokémon", 1042: "Seed Pokémon",
                  1123: "Unique Horn Pokémon"},
            # 812 and 814 are read for Giratina's Origin Forme, 813 and 815
            # for its Altered Forme: the engine's one figure, the Altered
            # Forme's, is in both, and retail's Origin row in 812 and 814
            814: {1: "  2’04”", 487: " 22’08”", 494: "???’??”", 1238: " 21’04”"},
            815: {487: " 14’09”"},
            812: {1: "  15.2 lbs.", 122: " 120.2 lbs.", 487: "1433.0 lbs.", 1238: "1080.3 lbs."},
            813: {487: "1653.5 lbs."},
        }
        for bank, expected in pinned.items():
            have = rows(bank)
            for index, text in expected.items():
                self.assertEqual(have[index], text, f"msg_{bank:04d} row {index}")
        entries = rows(803)
        self.assertEqual(entries[1043], entries[6])     # Mega Charizard X says Charizard's
        self.assertTrue(entries[575].startswith("When it shares the infinite energy"))  # Victini
        self.assertFalse(entries[200].endswith(" "))
        self.assertEqual(entries[494], "-----")

    def test_the_blank_bank_is_the_engines(self):
        """811 is hg-engine's static 811.txt: 1096 rows, spaces as garbage rows."""
        blank = gmm.read(811)
        self.assertEqual(len(blank), 1096)
        self.assertEqual(blank[494]["text"], "-----")
        self.assertEqual(blank[544]["context"], "garbage")
        self.assertEqual(import_species_text.encodes_as(blank[544]), " " * 53)

    @unittest.skipIf(REFERENCE is None, "behaviour reference not present")
    def test_every_bank_is_what_the_importer_writes(self):
        """At the engine or at New Gold, every row, and the two are the same.
        konefr named three Galarian forms by their base's SPECIES_ identifier
        ("SLOWBRO", "FARFETCHD", "SLOWKING"); they take the base's name, as
        the form he left "-----", Galarian Slowpoke, does."""
        engine = import_species_text.wanted(gmm.ENGINE)
        newgold = import_species_text.wanted(gmm.NEWGOLD)
        for bank in import_species_text.BANKS:
            have = [import_species_text.encodes_as(row) for row in gmm.read(bank)]
            self.assertIn(have, (engine[bank], newgold[bank]), f"msg_{bank:04d}")
        differ = {bank: [i for i, (a, b) in enumerate(zip(engine[bank], newgold[bank])) if a != b]
                  for bank in import_species_text.BANKS}
        self.assertEqual({bank: rows_ for bank, rows_ in differ.items() if rows_}, {})
        self.assertEqual([rows(237)[i] for i in (573, 574, 1125, 1131)],
                         ["Slowpoke", "Slowbro", "Farfetch’d", "Slowking"])
        self.assertEqual(rows(817)[1125], "FARFETCH’D")

    def test_a_form_named_by_its_base_s_identifier_is_named_up_the_chain(self):
        """konefr's slip (a form named by its base's SPECIES_ identifier)
        takes its name as a form left "-----" does, through a base that is
        itself a form: a form of a form so named gets the first real name up
        the chain, not its base's "-----". No species is shaped so today."""
        fields = {"pokedexEntry": "x", "classification": "x", "height": "x", "weight": "x"}
        data = {"BASE": dict(fields, name="Base"), "FORM": dict(fields, name=PLACEHOLDER),
                "FORM_OF_FORM": dict(fields, name="FORM")}
        with mock.patch.multiple(import_species_text, text_data=lambda revision: data,
                                 numbers=lambda header, names: {},
                                 base_species=lambda revision: {"FORM": "BASE", "FORM_OF_FORM": "FORM"},
                                 port_species=lambda: {1: "BASE", 2: "FORM", 3: "FORM_OF_FORM"}), \
                mock.patch.object(gmm, "git_show", return_value=""):
            named = {row: row_fields["name"] for row, row_fields in import_species_text.fields_by_port_row("x").items()}
        self.assertEqual(named, {1: "Base", 2: "Base", 3: "Base"})


if __name__ == "__main__":
    unittest.main()
