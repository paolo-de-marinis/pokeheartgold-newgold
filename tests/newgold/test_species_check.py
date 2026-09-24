#!/usr/bin/env python3
"""The species check (tools/newgold/devkit/diag/species.py) without the game:
that it looks at every species and form there is, and that its text rule
flags both ways a text can be wrong."""

import sys
import unittest

from test_level_cap import ROOT

sys.path[:0] = [str(ROOT / "tools/newgold" / sub) for sub in ("import", "devkit", "devkit/diag")]
import savedit as sv  # noqa: E402
import species  # noqa: E402


class SpeciesCheckTests(unittest.TestCase):
    def test_every_species_and_form_is_looked_at(self):
        n = sv.species_numbers()
        looked = {(e["species"], e["form"]) for e in species.entries()}
        numbers = {s for s, _ in looked}
        # Every species number but the eggs and the retail form rows, which
        # are looked at as their species' forms.
        wanted = set(range(1, max(n.values()) + 1)) - set(range(n["EGG"], n["ROTOM_MOW"] + 1))
        self.assertEqual(numbers, wanted)
        for name, (count, folders) in species.form_species().items():
            self.assertEqual({f for s, f in looked if s == n[name]}, set(range(count)), name)

    def test_a_text_drawn_two_ways_or_two_texts_drawn_one_way(self):
        table = {0: {"species": 1, "form": 0, "ability": 65},
                 1: {"species": 1, "form": 0, "ability": 65},
                 2: {"species": 4, "form": 0, "ability": 66}}
        records = [{"n": 0, "text": {"summary ability": "a"}},
                   {"n": 1, "text": {"summary ability": "b"}},
                   {"n": 2, "text": {"summary ability": "b"}}]
        original = species.expected_text
        species.expected_text = lambda e, r=None: {"summary ability": e["ability"]}
        try:
            found = species.text_failures(records, table)
        finally:
            species.expected_text = original
        messages = [what for _, _, what, _ in found]
        self.assertTrue(any("drawn another way" in m for m in messages), messages)
        self.assertTrue(any("drawn exactly like" in m for m in messages), messages)

    def test_the_texts_it_expects_are_read_from_their_banks(self):
        text = species.expected_text(next(e for e in species.entries() if e["species"] == 1))
        self.assertEqual((text["ability"], text["category"]), ("Overgrow", "Seed Pok\u00e9mon"))
        self.assertTrue(text["ability description"].startswith("Powers up Grass-type"))
        self.assertTrue(text["entry"].startswith("The seed on its back"))


    def test_forms_lists_what_the_dex_lists(self):
        n = sv.species_numbers()
        self.assertEqual(species.forms_entries(n["BULBASAUR"]), [("gender", 0), ("gender", 1)])
        self.assertEqual(species.forms_entries(n["NIDORAN_F"]), [("gender", 1)])
        self.assertEqual(species.forms_entries(n["MAGNEMITE"]), [("gender", 2)])
        self.assertEqual(species.forms_entries(n["UNOWN"]), [("form", 0)])
        self.assertEqual(species.forms_entries(n["CASTFORM"]), [("form", f) for f in range(4)])

    def test_a_split_species_female_is_drawn_from_its_female_species(self):
        n = sv.species_numbers()
        front, back = species.forms_pictures(n["MEOWSTIC"], ("gender", 1))
        self.assertEqual(front.parent.parent.name, f"{n['MEOWSTIC_FEMALE']:04d}")
        front, back = species.forms_pictures(n["VENUSAUR"], ("gender", 1))
        self.assertEqual((front.parent.name, back.name), ("female", "back.png"))
        front, back = species.forms_pictures(n["NIDORAN_M"], ("gender", 1))
        self.assertEqual(front.parent.name, "male")   # no female picture of its own

    def test_the_area_page_is_read_from_the_records(self):
        n = sv.species_numbers()
        self.assertTrue(species.area_unknown(n["BULBASAUR"]))
        self.assertFalse(species.area_unknown(n["PIDGEY"]))
        self.assertFalse(species.area_unknown(n["APPLIN"]))   # Ilex Forest, New Gold's
        table = {0: {"species": n["BULBASAUR"]}, 1: {"species": n["IVYSAUR"]}, 2: {"species": n["PIDGEY"]},
                 3: {"species": n["VENUSAUR"]}}
        records = [{"n": 0, "walk": "area", "banner": "unknown"}, {"n": 1, "walk": "area", "banner": "unknown"},
                   {"n": 2, "walk": "area", "banner": "unknown"}, {"n": 3, "walk": "area", "banner": "a map"}]
        self.assertEqual(sorted(n for n, _ in species.area_failures(records, table)), [2, 3])


if __name__ == "__main__":
    unittest.main()
