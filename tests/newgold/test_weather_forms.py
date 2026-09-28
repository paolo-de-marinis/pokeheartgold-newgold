#!/usr/bin/env python3
"""Castform and Cherrim, the two Pokemon whose form follows the weather.

Battler_CheckWeatherFormChange changes them by the retail species and form
number. Forecast asks for Castform's form, not its type (Pokemon Central,
Previsioni): a type a move gave it stays until the form changes.
"""

import re
import unittest

from test_level_cap import ROOT
from test_repels import function

OVERLAY = ROOT / "src/battle/overlay_12_0224E4FC.c"


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

    def test_each_weather_its_form(self):
        for weather, form in (("SUN_ALL", "SUNNY"), ("RAIN_ALL", "RAINY"), ("HAIL_ALL", "SNOWY")):
            self.assertRegex(self.castform, rf"if \(weather & FIELD_CONDITION_{weather}\) \{{\s*form = CASTFORM_{form};")
        self.assertLess(self.castform.index("form = CASTFORM_NORMAL;"), self.castform.index("ABILITY_CLOUD_NINE"))


if __name__ == "__main__":
    unittest.main()
