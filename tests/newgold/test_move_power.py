#!/usr/bin/env python3
"""Moves whose power the battle changes, run on the host.

CalcMoveDamage takes test_ability_behaviour's stubbed battle: every stat 100,
level 50, no item and no stage, so a physical move of power P from battler 0
into battler 1 does (22 * 100 * P / 100) / 50 + 2.
"""

import unittest

from test_ability_behaviour import damage_program, run_c


class SolarBladeTests(unittest.TestCase):
    def test_it_is_halved_in_any_weather_but_the_sun(self):
        """As Solar Beam: 125 is 57 in the sun and under a clear sky, 62 and
        so 29 in the rain, the sand, the hail, the snow and the fog
        (Pokemon Central, Solarlama; CalcBaseDamage.c:535 at d0380a487)."""
        run_c(self, damage_program(r"""
#define SOLAR(move) CalcMoveDamage(&bs, &ctx, move, 0, S.weather, 0, TYPE_GRASS, 0, 1, 1)
    reset(4); S.move.power = 125;
    EXPECT(SOLAR(MOVE_SOLAR_BLADE), 57);
    S.weather = FIELD_CONDITION_SUN; EXPECT(SOLAR(MOVE_SOLAR_BLADE), 57);
    S.weather = FIELD_CONDITION_RAIN; EXPECT(SOLAR(MOVE_SOLAR_BLADE), 29); EXPECT(SOLAR(MOVE_SOLAR_BEAM), 29);
    S.weather = FIELD_CONDITION_SANDSTORM; EXPECT(SOLAR(MOVE_SOLAR_BLADE), 29);
    S.weather = FIELD_CONDITION_HAIL; EXPECT(SOLAR(MOVE_SOLAR_BLADE), 29);
    S.weather = FIELD_CONDITION_SNOW_TEMP; EXPECT(SOLAR(MOVE_SOLAR_BLADE), 29);
    S.weather = FIELD_CONDITION_FOG; EXPECT(SOLAR(MOVE_SOLAR_BLADE), 29);
    // Nothing else is halved.
    EXPECT(SOLAR(MOVE_LEAF_BLADE), 57);
"""))


if __name__ == "__main__":
    unittest.main()
