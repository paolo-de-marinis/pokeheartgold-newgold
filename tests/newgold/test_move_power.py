#!/usr/bin/env python3
"""The power of the moves whose power the battle works out rather than reads
from the table, run on the host.

The reference works these out in CalcBaseDamage, so every caller of the damage
calculation sees them; retail worked most of them out in the move's effect
script, which only the move itself runs. CalcMoveDamage takes
test_ability_behaviour's stubbed battle: every stat 100, level 50, no item and
no stage, so a physical move of power P from battler 0 into battler 1 does
(22 * 100 * P / 100) / 50 + 2.
"""

import unittest

from test_ability_behaviour import damage_program, run_c
from test_level_cap import ROOT
from test_repels import function


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


class LashOutTests(unittest.TestCase):
    def test_it_doubles_after_a_drop_this_turn(self):
        """75 is 35, and 150 is 68 once a stat of the user's has been lowered
        this turn (Pokemon Central, Sfogarabbia; CalcBaseDamage.c:498 at
        d0380a487); a drop on another battler, or on another move, does
        nothing."""
        run_c(self, damage_program(r"""
#define HIT(move, attacker, target) CalcMoveDamage(&bs, &ctx, move, 0, 0, 0, TYPE_DARK, attacker, target, 1)
    reset(4); S.move = (MoveTbl){ 75, TYPE_DARK, CATEGORY_PHYSICAL };
    EXPECT(HIT(MOVE_LASH_OUT, 0, 1), 35);
    ctx.moveConditions[0].statLoweredThisTurn = 1;
    EXPECT(HIT(MOVE_LASH_OUT, 0, 1), 68);
    EXPECT(HIT(MOVE_CRUNCH, 0, 1), 35);
    EXPECT(HIT(MOVE_LASH_OUT, 2, 1), 35);
    EXPECT(HIT(MOVE_LASH_OUT, 1, 0), 35);
"""))

    def test_a_drop_is_remembered_until_the_next_turn(self):
        """Every drop the stat-change command makes marks its Pokemon, and the
        marks go when a turn's choices begin -- after the entry abilities of
        what was sent out for it. A Pokemon loaded into a slot starts with its
        move conditions cleared."""
        commands = (ROOT / "src/battle/battle_command.c").read_text()
        controller = (ROOT / "src/battle/battle_controller_player.c").read_text()
        self.assertIn("ctx->moveConditions[ctx->battlerIdStatChange].statLoweredThisTurn = TRUE;",
                      function(commands, "BtlCmd_ChangeStatStage"))
        self.assertIn("ctx->moveConditions[battlerId].statLoweredThisTurn = FALSE;",
                      function(controller, "BattleControllerPlayer_SelectionScreenInit"))


if __name__ == "__main__":
    unittest.main()


def hit(move):
    return f"CalcMoveDamage(&bs, &ctx, {move}, 0, 0, 0, TYPE_NORMAL, 0, 1, 1)"


class FriendshipTests(unittest.TestCase):
    def test_return_and_frustration_read_the_friendship(self):
        # Power 50: (22 * 100 * 50 / 100) / 50 + 2 = 24; power 100: 46.
        # Asked by effect: Pika Papow and Veevee Volley share Return's.
        run_c(self, damage_program(f"""
    reset(4); S.move.effect = MOVE_EFFECT_POWER_BASED_ON_FRIENDSHIP;
    ctx.battleMons[0].friendship = 125; EXPECT({hit("MOVE_RETURN")}, 24);
    ctx.battleMons[0].friendship = 250; EXPECT({hit("MOVE_PIKA_PAPOW")}, 46);
    // The target's friendship is not asked.
    ctx.battleMons[1].friendship = 0; ctx.battleMons[0].friendship = 125; EXPECT({hit("MOVE_RETURN")}, 24);
    S.move.effect = MOVE_EFFECT_POWER_BASED_ON_LOW_FRIENDSHIP;
    ctx.battleMons[0].friendship = 5; EXPECT({hit("MOVE_FRUSTRATION")}, 46);
    ctx.battleMons[0].friendship = 130; EXPECT({hit("MOVE_FRUSTRATION")}, 24);
    // Any other effect keeps its table's power.
    S.move.effect = MOVE_EFFECT_HIT; EXPECT({hit("MOVE_RETURN")}, 46);
"""))

    def test_the_effect_scripts_leave_the_power_alone(self):
        from test_repels import read
        for effect in ("0121", "0123"):
            self.assertNotIn("BSCRIPT_VAR_MOVE_POWER", read(f"files/battledata/script/effect_script/effect_script_{effect}.s"))


class RisingPowerTests(unittest.TestCase):
    def test_triple_kick_and_triple_axel_count_their_strikes(self):
        # 10, 20, 30: 6, 10, 15; 20 and 60: 10 and 28.
        run_c(self, damage_program(f"""
    reset(4);
    ctx.multiHitCount = 3; EXPECT({hit("MOVE_TRIPLE_KICK")}, 6);
    ctx.multiHitCount = 2; EXPECT({hit("MOVE_TRIPLE_KICK")}, 10);
    ctx.multiHitCount = 1; EXPECT({hit("MOVE_TRIPLE_KICK")}, 15);
    ctx.multiHitCount = 3; EXPECT({hit("MOVE_TRIPLE_AXEL")}, 10);
    ctx.multiHitCount = 1; EXPECT({hit("MOVE_TRIPLE_AXEL")}, 28);
    // Outside the move, the table's power; and no other move counts.
    ctx.multiHitCount = 0; EXPECT({hit("MOVE_TRIPLE_KICK")}, 46);
    ctx.multiHitCount = 1; EXPECT({hit("MOVE_DOUBLE_KICK")}, 46);
"""))

    def test_the_effect_scripts_add_nothing(self):
        from test_repels import read
        for effect in ("0104", "0303"):
            self.assertNotIn("BSCRIPT_VAR_MOVE_POWER", read(f"files/battledata/script/effect_script/effect_script_{effect}.s"))


if __name__ == "__main__":
    unittest.main()
