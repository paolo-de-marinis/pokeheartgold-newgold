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


    def test_a_battle_is_judged_by_both_its_pictures(self):
        # The foe's front and the leader's back, drawn where a battle draws
        # them -- the back in the front's palette, as the game loads it --
        # score full; a black frame scores next to nothing (the outlines),
        # and the back in the PNG's own palette does not pass.
        from PIL import Image
        e = next(x for x in species.entries() if x["species"] == sv.species_numbers()["LILLIPUP"])
        fronts, front, back = species.battle_pictures(e)
        palette = Image.open(front).getpalette()

        def frame(back_palette):
            screen = Image.new("RGB", (256, 384), (90, 90, 120))
            for png, at, pal in ((fronts[0], (species.BATTLE_FRONT[0], species.BATTLE_FRONT[1] + 6), palette),
                                 (back, (species.BATTLE_BACK[0], species.BATTLE_BACK[1] - 10), back_palette)):
                picture = Image.open(png)
                picture.putpalette(pal)
                cell = picture.crop((0, 0, 80, 80))
                opaque = Image.frombytes("L", cell.size, bytes(255 if i else 0 for i in cell.tobytes()))
                screen.paste(cell.convert("RGB"), at, opaque)
            return screen

        self.assertEqual(species.battle_scores(frame(palette), e), (1.0, 1.0))
        self.assertLess(max(species.battle_scores(Image.new("RGB", (256, 384)), e)), 0.1)
        self.assertLess(species.battle_scores(frame(Image.open(back).getpalette()), e)[1], species.PASS)

    def test_a_battle_puts_out_only_what_the_tree_explains(self):
        # Judged by who the battle says is out, a Mega Tatsugiri Stretchy
        # that came in as the Droopy form scored full; the species put out
        # in the variant's place has to be the form form_reversion.h sends it
        # back to, a battle form of it, its species' base or its own other
        # gender's.
        n = sv.species_numbers()
        entry = lambda name: next(x for x in species.entries() if x["species"] == n[name])  # noqa: E731
        cases = (("MEGA_TATSUGIRI_STRETCHY", "TATSUGIRI_STRETCHY", True), ("MEGA_TATSUGIRI_STRETCHY", "TATSUGIRI_DROOPY", False),
                 ("GIGANTAMAX_URSHIFU_RAPID_STRIKE", "URSHIFU_RAPID_STRIKE", True),
                 ("GIGANTAMAX_URSHIFU_RAPID_STRIKE", "URSHIFU", False), ("XERNEAS", "XERNEAS_ACTIVE", True),
                 ("GENESECT_DOUSE_DRIVE", "GENESECT", True), ("UNFEZANT", "UNFEZANT_FEMALE", True),
                 ("TERAPAGOS_STELLAR", "TERAPAGOS_TERASTAL", True), ("OGERPON_WELLSPRING_MASK_TERASTAL", "OGERPON", True),
                 ("MINIOR_CORE_ORANGE", "MINIOR_METEOR_ORANGE", True),
                 ("PICHU", "PIKACHU", False))
        for variant, drawn, fine in cases:
            record = {"walk": "battle", "state": "BATTLE_MAIN", "prompt": 2, "became": [None, n[drawn]]}
            wrong = species.problems(record, entry(variant))
            self.assertEqual(not wrong, fine, (variant, drawn, wrong))

    def test_the_added_sample_is_every_species_past_arceus_and_every_form_group(self):
        n = sv.species_numbers()
        picked = {(e["species"], e["form"]) for e in species.added(species.entries())}
        self.assertEqual({s for s, _ in picked if s > n["ARCEUS"]}, set(range(n["ARCEUS"] + 1, max(n.values()) + 1))
                         - set(range(n["EGG"], n["ROTOM_MOW"] + 1)))
        for name, (count, _) in species.form_species().items():
            self.assertEqual({f for s, f in picked if s == n[name]}, set(range(count)), name)
        self.assertNotIn(n["BULBASAUR"], {s for s, _ in picked})

    def test_forms_lists_what_the_dex_lists(self):
        n = sv.species_numbers()
        self.assertEqual(species.forms_entries(n["BULBASAUR"]), [("gender", 0), ("gender", 1)])
        self.assertEqual(species.forms_entries(n["NIDORAN_F"]), [("gender", 1)])
        self.assertEqual(species.forms_entries(n["MAGNEMITE"]), [("gender", 2)])
        # the Dex save has every form of these seen (dex_jobs)
        self.assertEqual(species.forms_entries(n["UNOWN"]), [("form", f) for f in range(28)])
        self.assertEqual(species.forms_entries(n["ROTOM"]), [("form", f) for f in range(6)])
        self.assertEqual(species.forms_entries(n["CASTFORM"]), [("form", f) for f in range(4)])
        # the bar says "One form" for every Unown letter, not for Shellos's two
        unown, shellos = (next(e for e in species.entries() if e["species"] == n[s]) for s in ("UNOWN", "SHELLOS"))
        bar = lambda e, f: species.expected_text(e, {"entry": ["form", f]})["forms name"]  # noqa: E731
        self.assertEqual(bar(unown, 0), bar(unown, 3))
        self.assertNotEqual(bar(shellos, 0), bar(shellos, 1))
        # Pichu's entries are a male, a female and the Spiky-eared
        self.assertEqual([species.forms_pictures(n["PICHU"], ("form", f))[0].parent.name for f in range(3)],
                         [species.form_species()["PICHU"][1][f] for f in (0, 0, 1)])

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
