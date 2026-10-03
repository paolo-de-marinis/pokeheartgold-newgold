#!/usr/bin/env python3
"""Castform and Cherrim, the two Pokemon whose form follows the weather.

Battler_CheckWeatherFormChange changes them by the retail species and form
number. Forecast asks for Castform's form, not its type (Pokemon Central,
Previsioni): a type a move gave it stays until the form changes. They come
into a battle in the form they have out of one, the weather's form species
and a retail weather form alike (BattleSystem_GetBattleMon). A Pokemon
transformed into one keeps the form it copied (Previsioni from the fifth
generation; Showdown's gen-9 Forecast and Flower Gift).
"""

import re
import unittest

from test_level_cap import ROOT
from test_repels import function

OVERLAY = ROOT / "src/battle/overlay_12_0224E4FC.c"
SPECIES = ROOT / "include/constants/species.h"
REVERSION = ROOT / "src/data/form_reversion.h"
TRANSFORMED = ("SPECIES && ctx->battleMons[ctx->battlerIdTemp].hp"
               " && !(ctx->battleMons[ctx->battlerIdTemp].status2 & STATUS2_TRANSFORM)) {")


class ForecastTests(unittest.TestCase):
    def setUp(self):
        self.source = OVERLAY.read_text()
        body = function(self.source, "Battler_CheckWeatherFormChange")
        self.castform = body[body.index("SPECIES_CASTFORM"):body.index("SPECIES_CHERRIM")]

    def test_it_compares_the_form_not_the_type(self):
        # Compared by type, a Soaked Castform went back to the Normal Form at
        # once, and one in a weather form with the Normal type kept its form.
        self.assertIn("if (ctx->battleMons[ctx->battlerIdTemp].form != form) {", self.castform)
        self.assertNotRegex(self.castform, r"type[12] != TYPE_")

    def test_the_form_brings_its_type_and_drops_an_added_one(self):
        # Trick-or-Treat's added type goes with Soak's (Previsioni).
        self.assertIn("type1 = sCastformTypes[form];", self.castform)
        self.assertIn("type2 = sCastformTypes[form];", self.castform)
        self.assertIn("type3 = TYPE_NONE;", self.castform)
        table = re.search(r"sCastformTypes\[CASTFORM_FORM_MAX\] = \{ ([^}]*) \};", self.source).group(1)
        self.assertEqual(table, "TYPE_NORMAL, TYPE_FIRE, TYPE_WATER, TYPE_ICE")

    def test_without_forecast_it_goes_back_to_its_normal_form(self):
        # Lost or suppressed, Forecast leaves Castform in its Normal Form
        # (Previsioni): the ability is asked for the weather's form only.
        self.assertRegex(self.castform, r"^SPECIES_CASTFORM && ctx->battleMons\[ctx->battlerIdTemp\]\.hp && [^{]*\) \{\s*"
                                        r"form = CASTFORM_NORMAL;\s*if \(GetBattlerAbility\(ctx, ctx->battlerIdTemp\) == ABILITY_FORECAST\s")

    def test_a_transformed_one_keeps_its_form(self):
        # A Ditto that copied Castform keeps the form it copied (Previsioni).
        self.assertTrue(self.castform.startswith(TRANSFORMED.replace("SPECIES", "SPECIES_CASTFORM")))

    def test_each_weather_its_form(self):
        # Hail and snow alike bring the Snowy Form (Previsioni).
        for weather, form in (("SUN_ALL", "SUNNY"), ("RAIN_ALL", "RAINY"), ("HAIL_ALL | FIELD_CONDITION_SNOW_ALL", "SNOWY")):
            self.assertRegex(self.castform, rf"if \(weather & \(?FIELD_CONDITION_{re.escape(weather)}\)?\) \{{\s*(//.*\s*)*form = CASTFORM_{form};")
        self.assertLess(self.castform.index("form = CASTFORM_NORMAL;"), self.castform.index("ABILITY_CLOUD_NINE"))


class FlowerGiftTests(unittest.TestCase):
    def setUp(self):
        body = function(OVERLAY.read_text(), "Battler_CheckWeatherFormChange")
        self.cherrim = body[body.index("SPECIES_CHERRIM"):body.index("SPECIES_ARCEUS")]

    def test_the_sunshine_form_needs_the_ability(self):
        # Without Flower Gift -- Skill Swap, Gastro Acid, Neutralizing Gas --
        # Cherrim goes back to its Overcast Form, in the sun too (Regalfiore).
        self.assertRegex(self.cherrim, r"form = CHERRIM_CLOUDY;\s*if \(GetBattlerAbility\(ctx, ctx->battlerIdTemp\) == ABILITY_FLOWER_GIFT && \(weather & FIELD_CONDITION_SUN_ALL\)")
        self.assertIn("form = CHERRIM_SUNNY;", self.cherrim)
        self.assertIn("if (ctx->battleMons[ctx->battlerIdTemp].form != form) {", self.cherrim)
        self.assertEqual(self.cherrim.count("form = "), 3)

    def test_a_transformed_one_keeps_its_form(self):
        # As Castform does (Showdown's gen-9 Flower Gift).
        self.assertTrue(self.cherrim.startswith(TRANSFORMED.replace("SPECIES", "SPECIES_CHERRIM")))


class EntryTests(unittest.TestCase):
    def setUp(self):
        self.body = function(OVERLAY.read_text(), "BattleSystem_GetBattleMon")
        start = self.body.index("u16 species = ctx->battleMons[battlerId].species;")
        self.block = self.body[start:self.body.index("ctx->battleMons[battlerId].level =", start)]

    def test_they_come_in_in_their_form_out_of_battle(self):
        # After the party's form and types are read, which it replaces.
        start = self.body.index(self.block)
        self.assertLess(self.body.index("GetMonData(mon, MON_DATA_FORM, NULL)"), start)
        self.assertLess(self.body.index("GetMonData(mon, MON_DATA_TYPE_2, NULL)"), start)
        castform, cherrim = self.block.split("} else if")
        self.assertIn("species == SPECIES_CASTFORM || (species >= SPECIES_CASTFORM_SUNNY && species <= SPECIES_CASTFORM_SNOWY)", castform)
        for line in ("species = SPECIES_CASTFORM;", "form = CASTFORM_NORMAL;", "type1 = TYPE_NORMAL;", "type2 = TYPE_NORMAL;"):
            self.assertIn(f"ctx->battleMons[battlerId].{line}", castform)
        self.assertIn("species == SPECIES_CHERRIM || species == SPECIES_CHERRIM_SUNSHINE", cherrim)
        for line in ("species = SPECIES_CHERRIM;", "form = CHERRIM_CLOUDY;"):
            self.assertIn(f"ctx->battleMons[battlerId].{line}", cherrim)

    def test_those_are_all_their_weather_form_species(self):
        # The range above holds every species the reversion table sends back
        # to Castform, and Cherrim has the one.
        numbers = {name: int(value) for name, value in
                   re.findall(r"#define SPECIES_(\w+)\s+(\d+)\s*$", SPECIES.read_text(), re.M)}
        back = re.findall(r"\[SPECIES_(\w+) - NATIONAL_DEX_COUNT - 1\] = SPECIES_(CASTFORM|CHERRIM),", REVERSION.read_text())
        castform = sorted(numbers[form] for form, base in back if base == "CASTFORM")
        self.assertEqual(castform, list(range(numbers["CASTFORM_SUNNY"], numbers["CASTFORM_SNOWY"] + 1)))
        self.assertEqual([form for form, base in back if base == "CHERRIM"], ["CHERRIM_SUNSHINE"])


if __name__ == "__main__":
    unittest.main()
