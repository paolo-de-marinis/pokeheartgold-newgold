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
        species.expected_text = lambda e: {"summary ability": e["ability"]}
        try:
            found = species.text_failures(records, table)
        finally:
            species.expected_text = original
        messages = [what for _, _, what, _ in found]
        self.assertTrue(any("drawn another way" in m for m in messages), messages)
        self.assertTrue(any("drawn exactly like" in m for m in messages), messages)


if __name__ == "__main__":
    unittest.main()
