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


class EchoedVoiceTests(unittest.TestCase):
    def test_it_grows_40_a_turn_in_a_row_to_200(self):
        """40 times one more than the turns in a row before this one that it
        was used, 200 at most (Pokemon Central, Echeggiavoce): 40, 80, 120,
        160, 200 are 19, 37, 54, 72, 90."""
        run_c(self, damage_program(r"""
#define VOICE(move) CalcMoveDamage(&bs, &ctx, move, 0, 0, 0, TYPE_NORMAL, 0, 1, 1)
    reset(4); S.move.power = 40;
    EXPECT(VOICE(MOVE_ECHOED_VOICE), 19);
    ctx.echoedVoiceTurns = 1; EXPECT(VOICE(MOVE_ECHOED_VOICE), 37);
    ctx.echoedVoiceTurns = 2; EXPECT(VOICE(MOVE_ECHOED_VOICE), 54);
    ctx.echoedVoiceTurns = 3; EXPECT(VOICE(MOVE_ECHOED_VOICE), 72);
    ctx.echoedVoiceTurns = 4; EXPECT(VOICE(MOVE_ECHOED_VOICE), 90);
    // No other move reads the run.
    EXPECT(VOICE(MOVE_HYPER_VOICE), 19);
"""))


class RoundTests(unittest.TestCase):
    def test_every_round_in_a_turn_but_the_first_is_120(self):
        """60 is 28 and 120 is 54 once another Pokemon, of either side, has
        used Round this turn (Pokemon Central, Coro)."""
        run_c(self, damage_program(r"""
#define ROUND(attacker) CalcMoveDamage(&bs, &ctx, MOVE_ROUND, 0, 0, 0, TYPE_NORMAL, attacker, 1, 1)
    reset(4); S.move.power = 60;
    ctx.roundUsers = 1 << 0; EXPECT(ROUND(0), 28);
    ctx.roundUsers = 1 << 0 | 1 << 2; EXPECT(ROUND(2), 54);
    ctx.roundUsers = 1 << 1 | 1 << 3; EXPECT(ROUND(3), 54);
    EXPECT(CalcMoveDamage(&bs, &ctx, MOVE_HYPER_VOICE, 0, 0, 0, TYPE_NORMAL, 0, 1, 1), 28);
"""))


class FusionTests(unittest.TestCase):
    def test_each_doubles_straight_after_the_other(self):
        """100 is 46 and 200 is 90 when the move used just before this one,
        this turn and by anyone, was the other of the pair (Pokemon Central,
        Incrofiamma, Incrotuono)."""
        run_c(self, damage_program(r"""
#define FUSION(move) CalcMoveDamage(&bs, &ctx, move, 0, 0, 0, TYPE_FIRE, 0, 1, 1)
    reset(4);
    EXPECT(FUSION(MOVE_FUSION_FLARE), 46);
    ctx.moveUsedBefore = MOVE_FUSION_BOLT; EXPECT(FUSION(MOVE_FUSION_FLARE), 90);
    EXPECT(FUSION(MOVE_FUSION_BOLT), 46);
    ctx.moveUsedBefore = MOVE_FUSION_FLARE; EXPECT(FUSION(MOVE_FUSION_BOLT), 90);
    EXPECT(FUSION(MOVE_FUSION_FLARE), 46);
    ctx.moveUsedBefore = MOVE_TACKLE; EXPECT(FUSION(MOVE_FUSION_BOLT), 46);
"""))


class WonderRoomTests(unittest.TestCase):
    def test_the_two_defences_swap_while_it_lasts(self):
        """Defense 200 and Sp. Def 100: a physical 100 is 24, and 46 once
        Wonder Room has swapped the stats; a special one the other way
        round (Pokemon Central, Mirabilzona)."""
        run_c(self, damage_program(r"""
    reset(4); S.def = 200;
    EXPECT(damage(0, 1), 24);
    ctx.wonderRoomTurns = 5; EXPECT(damage(0, 1), 46);
    S.move.category = CATEGORY_SPECIAL; EXPECT(damage(0, 1), 24);
    ctx.wonderRoomTurns = 0; EXPECT(damage(0, 1), 46);
"""))


class LastRespectsTests(unittest.TestCase):
    def test_it_grows_50_for_each_faint_in_the_party(self):
        """50 times one more than the faints in the user's party, 5050 at
        most: 50, 100, 300 are 24, 46, 134 and 5050 is 2224 (Pokemon Central,
        Omaggio ai KO). BattlerPartyFaintCount is stubbed to the user's own
        count; the party walk is the Supreme Overlord's."""
        run_c(self, damage_program(r"""
#define RESPECTS(move) CalcMoveDamage(&bs, &ctx, move, 0, 0, 0, TYPE_GHOST, 0, 1, 1)
    reset(4); S.move.power = 50;
    EXPECT(RESPECTS(MOVE_LAST_RESPECTS), 24);
    ctx.totalTimesFainted[0] = 1; EXPECT(RESPECTS(MOVE_LAST_RESPECTS), 46);
    ctx.totalTimesFainted[0] = 5; EXPECT(RESPECTS(MOVE_LAST_RESPECTS), 134);
    ctx.totalTimesFainted[0] = 100; EXPECT(RESPECTS(MOVE_LAST_RESPECTS), 2224);
    ctx.totalTimesFainted[0] = 150; EXPECT(RESPECTS(MOVE_LAST_RESPECTS), 2224);
    EXPECT(RESPECTS(MOVE_SHADOW_CLAW), 24);
"""))


class RageFistTests(unittest.TestCase):
    def test_it_grows_50_for_each_hit_taken(self):
        """50 times one more than the hits its user has taken, which the
        controller stops at six: 50, 100, 350 are 24, 46, 156 (Pokemon Central,
        Pugno Furibondo). The count is stubbed by battler."""
        run_c(self, damage_program(r"""
#define FIST(move, attacker) CalcMoveDamage(&bs, &ctx, move, 0, 0, 0, TYPE_GHOST, attacker, 1, 1)
    reset(4); S.move.power = 50;
    EXPECT(FIST(MOVE_RAGE_FIST, 0), 24);
    S.rageFist[0] = 1; EXPECT(FIST(MOVE_RAGE_FIST, 0), 46);
    S.rageFist[0] = 6; EXPECT(FIST(MOVE_RAGE_FIST, 0), 156);
    // The user's hits, not the target's; and only Rage Fist asks.
    S.rageFist[0] = 0; S.rageFist[1] = 6; EXPECT(FIST(MOVE_RAGE_FIST, 0), 24);
    S.rageFist[0] = 6; EXPECT(FIST(MOVE_DRAIN_PUNCH, 0), 24);
"""))


class BorrowedStatTests(unittest.TestCase):
    def test_foul_play_body_press_and_psyshock_read_other_stats(self):
        """Stats 100 but for the one each move reads, 200: a physical 100 is
        90 on it, 178 at +2; 46 on anything else. Foul Play strikes with the
        target's Attack and stages (Pokemon Central, Ripicca), Body Press
        with the user's Defense and stages (Schiacciacorpo); Psyshock,
        Psystrike and Secret Sword meet the target's Defense and its stages,
        200 making a special 100 24 (Psicoshock)."""
        run_c(self, damage_program(r"""
    reset(4); S.atkOf[1] = 200;
    EXPECT(CalcMoveDamage(&bs, &ctx, MOVE_FOUL_PLAY, 0, 0, 0, TYPE_DARK, 0, 1, 1), 90);
    EXPECT(damage(0, 1), 46);
    S.atkStage[1] = 8; EXPECT(CalcMoveDamage(&bs, &ctx, MOVE_FOUL_PLAY, 0, 0, 0, TYPE_DARK, 0, 1, 1), 178);
    S.atkStage[1] = 0; S.atkStage[0] = 8; EXPECT(CalcMoveDamage(&bs, &ctx, MOVE_FOUL_PLAY, 0, 0, 0, TYPE_DARK, 0, 1, 1), 90);
    reset(4); S.defOf[0] = 200;
    EXPECT(CalcMoveDamage(&bs, &ctx, MOVE_BODY_PRESS, 0, 0, 0, TYPE_FIGHTING, 0, 1, 1), 90);
    S.defStage[0] = 8; EXPECT(CalcMoveDamage(&bs, &ctx, MOVE_BODY_PRESS, 0, 0, 0, TYPE_FIGHTING, 0, 1, 1), 178);
    S.defStage[0] = 0; S.atkStage[0] = 8; EXPECT(CalcMoveDamage(&bs, &ctx, MOVE_BODY_PRESS, 0, 0, 0, TYPE_FIGHTING, 0, 1, 1), 90);
    reset(4); S.move.category = CATEGORY_SPECIAL; S.defOf[1] = 200;
    EXPECT(CalcMoveDamage(&bs, &ctx, MOVE_PSYSHOCK, 0, 0, 0, TYPE_PSYCHIC, 0, 1, 1), 24);
    EXPECT(CalcMoveDamage(&bs, &ctx, MOVE_PSYSTRIKE, 0, 0, 0, TYPE_PSYCHIC, 0, 1, 1), 24);
    EXPECT(CalcMoveDamage(&bs, &ctx, MOVE_SECRET_SWORD, 0, 0, 0, TYPE_FIGHTING, 0, 1, 1), 24);
    EXPECT(CalcMoveDamage(&bs, &ctx, MOVE_PSYCHIC, 0, 0, 0, TYPE_PSYCHIC, 0, 1, 1), 46);
    S.defStage[1] = 4; EXPECT(CalcMoveDamage(&bs, &ctx, MOVE_PSYSHOCK, 0, 0, 0, TYPE_PSYCHIC, 0, 1, 1), 46);
"""))


class OrderUpTests(unittest.TestCase):
    def test_sheer_force_always_boosts_it(self):
        """80 is 37, and Sheer Force's 104 is 47, with no added effect to give
        up (Pokemon Central, Alta Cucina); another plain hit gets nothing."""
        run_c(self, damage_program(r"""
#define ORDER(move) CalcMoveDamage(&bs, &ctx, move, 0, 0, 0, TYPE_DRAGON, 0, 1, 1)
    reset(4); S.move.power = 80;
    EXPECT(ORDER(MOVE_ORDER_UP), 37);
    S.ability[0] = ABILITY_SHEER_FORCE;
    EXPECT(ORDER(MOVE_ORDER_UP), 47);
    EXPECT(ORDER(MOVE_DRAGON_CLAW), 37);
"""))


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


class DoublingTests(unittest.TestCase):
    def test_smelling_salts_and_wake_up_slap_double_against_what_they_cure(self):
        # The engine's CalcBaseDamage, not the effect scripts: 46, doubled 90,
        # against a paralysed or a sleeping or Comatose target, not behind a
        # substitute that takes the hit.
        run_c(self, damage_program(f"""
    reset(4); S.move.effect = MOVE_EFFECT_DOUBLE_POWER_AND_CURE_PARALYSIS; EXPECT({hit("MOVE_SMELLING_SALTS")}, 46);
    S.status[1] = STATUS_PARALYSIS; EXPECT({hit("MOVE_SMELLING_SALTS")}, 90);
    S.substitute[1] = TRUE; EXPECT({hit("MOVE_SMELLING_SALTS")}, 46);
    reset(4); S.move.effect = MOVE_EFFECT_DOUBLE_POWER_AND_CURE_PARALYSIS; S.status[0] = STATUS_PARALYSIS;
    EXPECT({hit("MOVE_SMELLING_SALTS")}, 46);
    reset(4); S.move.effect = MOVE_EFFECT_DOUBLE_POWER_HEAL_SLEEP; S.status[1] = STATUS_PARALYSIS;
    EXPECT({hit("MOVE_WAKE_UP_SLAP")}, 46);
    S.status[1] = STATUS_SLEEP; EXPECT({hit("MOVE_WAKE_UP_SLAP")}, 90);
    S.status[1] = 0; S.ability[1] = ABILITY_COMATOSE; EXPECT({hit("MOVE_WAKE_UP_SLAP")}, 90);
    S.status[1] = STATUS_SLEEP; EXPECT({hit("MOVE_WAKE_UP_SLAP")}, 90);
    reset(4); S.move.effect = MOVE_EFFECT_HIT; S.status[1] = STATUS_SLEEP | STATUS_PARALYSIS; EXPECT({hit("MOVE_TACKLE")}, 46);
"""))

    def test_reckless_pays_for_the_recoil_moves(self):
        # 100 is 46; a fifth more, 120, is 54. The crash moves' fifth is their
        # scripts' POWER_MULTI. Chloroblast has none (Pokemon Central,
        # Clorofillaser).
        run_c(self, damage_program(f"""
    reset(4); S.ability[0] = ABILITY_RECKLESS; S.move.effect = MOVE_EFFECT_RECOIL_THIRD; EXPECT({hit("MOVE_DOUBLE_EDGE")}, 54);
    S.move.effect = MOVE_EFFECT_RECOIL_QUARTER_DAMAGE_DELT; EXPECT({hit("MOVE_TAKE_DOWN")}, 54);
    S.move.effect = MOVE_EFFECT_RECOIL_HALF_MAX_HP; EXPECT({hit("MOVE_CHLOROBLAST")}, 46);
    S.move.effect = MOVE_EFFECT_CRASH_ON_MISS; EXPECT({hit("MOVE_JUMP_KICK")}, 46);
    S.move.effect = MOVE_EFFECT_HIT; EXPECT({hit("MOVE_TACKLE")}, 46);
    reset(4); S.move.effect = MOVE_EFFECT_RECOIL_THIRD; EXPECT({hit("MOVE_DOUBLE_EDGE")}, 46);
"""))

    def test_assurance_doubles_against_a_pokemon_hurt_this_turn(self):
        # Power 100 from the stubbed table: 46; doubled, 200: 90.
        run_c(self, damage_program(f"""
    reset(4); EXPECT({hit("MOVE_ASSURANCE")}, 46);
    ctx.turnData[1].unk3C = -20; EXPECT({hit("MOVE_ASSURANCE")}, 90);
    // The target's hurt, not the user's; and only Assurance asks.
    reset(4); ctx.turnData[0].unk3C = -20; EXPECT({hit("MOVE_ASSURANCE")}, 46);
    reset(4); ctx.turnData[1].unk3C = -20; EXPECT({hit("MOVE_TACKLE")}, 46);
"""))
        from test_repels import read
        self.assertNotIn("BSCRIPT_VAR_MOVE_POWER", read("files/battledata/script/effect_script/effect_script_0231.s"))

    def test_payback_doubles_against_a_pokemon_that_has_acted(self):
        run_c(self, damage_program(f"""
    reset(4); EXPECT({hit("MOVE_PAYBACK")}, 46);
    S.acted[1] = TRUE; EXPECT({hit("MOVE_PAYBACK")}, 90);
    // The target's action, not the user's; and only Payback asks.
    reset(4); S.acted[0] = TRUE; EXPECT({hit("MOVE_PAYBACK")}, 46);
    reset(4); S.acted[1] = TRUE; EXPECT({hit("MOVE_TACKLE")}, 46);
    // A Pokemon that came in during the turn has not acted, from Generation V
    // (Pokemon Central, Rivincita), though it has no action left either.
    reset(4); S.acted[1] = TRUE; ctx.turnData[1].switchedIn = TRUE; EXPECT({hit("MOVE_PAYBACK")}, 46);
"""))
        from test_repels import read
        self.assertNotIn("CalcPaybackPower", read("files/battledata/script/effect_script/effect_script_0230.s"))


if __name__ == "__main__":
    unittest.main()
