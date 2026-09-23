#!/usr/bin/env python3
"""Pin the battle numbers this port takes from the reference's generation.

HeartGold's battle engine is Generation IV; hg-engine replaces its numbers with
later ones, and konefr's New Gold keeps those. Each class here pins one number
the port changed to match, so turning it back to HeartGold's fails here.
"""

import os
import re
import shlex
import subprocess
import tempfile
import unittest
from pathlib import Path

from test_level_cap import ROOT
from test_repels import function

OVERLAY = ROOT / "src/battle/overlay_12_0224E4FC.c"
COMMANDS = ROOT / "src/battle/battle_command.c"
SUBSCRIPTS = ROOT / "files/battledata/script/subscript"


def subscript(name):
    matches = sorted(SUBSCRIPTS.glob(f"subscript_*_{name}.s"))
    assert len(matches) == 1, f"{name}: {matches}"
    return matches[0].read_text()


class BurnTests(unittest.TestCase):
    def test_a_burn_takes_a_sixteenth_and_heatproof_halves_that(self):
        # The reference's subscript_0026_BURN_DAMAGE.s divides by 16, and by 2
        # again for Heatproof. HeartGold divided by 8.
        divisions = re.findall(r"DivideVarByValue BSCRIPT_VAR_HP_CALC, (\d+)", subscript("BurnDamage"))
        self.assertEqual(divisions, ["16", "2"])


class ParalysisTests(unittest.TestCase):
    def test_paralysis_halves_speed_on_both_sides_of_the_comparison(self):
        # The reference's CalcSpeed takes QMul_RoundUp(speed, UQ412__0_5):
        # half, a half rounded up. HeartGold divided by 4.
        body = function(OVERLAY.read_text(), "CheckSortSpeed")
        halvings = re.findall(r"STATUS_PARALYSIS\) \{\n(?:\s*//[^\n]*\n)*\s*(speed\d) = \(\1 \+ 1\) / 2;", body)
        self.assertEqual(halvings, ["speed1", "speed2"])


class CriticalHitTests(unittest.TestCase):
    def test_the_odds_at_each_stage_are_the_reference_s(self):
        # other_battle_calculators.c's CriticalRateTable. HeartGold's was
        # 16, 8, 4, 3, 2.
        table = re.search(r"sCritChance\[\] = \{([^}]*)\}", OVERLAY.read_text()).group(1)
        self.assertEqual([int(n) for n in table.split(",")], [24, 8, 2, 1, 1])


    def test_a_critical_hit_is_half_again_and_sniper_half_again_on_that(self):
        # battle_calc_damage.c: 6.4 multiplies by 150/100, and 6.9.3 gives
        # Sniper another 1.5. HeartGold multiplied by 2, and by 3 for Sniper.
        program = "typedef struct { int damage, criticalMultiplier; } BattleContext;\n"
        program += function(COMMANDS.read_text(), "ApplyCriticalHit")
        program += """
#include <assert.h>
int main(void) {
    int expected[] = { 0, 100, 150, 225 };
    for (int crit = 1; crit <= 3; crit++) {
        BattleContext ctx = { 100, crit };
        ApplyCriticalHit(&ctx);
        assert(ctx.damage == expected[crit]);
    }
    return 0;
}
"""
        with tempfile.TemporaryDirectory(prefix="newgold-crit-") as directory:
            path = Path(directory)
            (path / "test.c").write_text(program)
            subprocess.run(shlex.split(os.environ.get("CC", "cc")) + [
                "-std=c99", "-Wall", "-Werror", str(path / "test.c"), "-o", str(path / "test")], check=True)
            subprocess.run([str(path / "test")], check=True)

    def test_both_damage_paths_take_it(self):
        # The ordinary calculation and Beat Up's own; neither multiplies by
        # the stored number any more.
        source = COMMANDS.read_text()
        self.assertNotIn("*= ctx->criticalMultiplier", source)
        for name in ("DamageCalcDefault", "BtlCmd_BeatUp"):
            self.assertIn("ApplyCriticalHit(ctx);", function(source, name), name)


class ExplosionTests(unittest.TestCase):
    def test_the_target_s_defense_is_not_halved(self):
        # HeartGold halved the target's Defense for effect 7 (Explosion and
        # Self-Destruct). The reference keeps the effect only for fainting the
        # user; its move records carry the later powers instead, and so do
        # this game's.
        self.assertNotIn("MOVE_EFFECT_HALVE_DEFENSE", function(OVERLAY.read_text(), "CalcMoveDamage"))


class SandstormTests(unittest.TestCase):
    def test_the_sand_abilities_are_spared_the_chip_damage(self):
        # battle_script_commands.c's BtlCmd_EndOfTurnWeatherEffect spares
        # Sand Veil, Sand Rush and Sand Force alike.
        body = function(COMMANDS.read_text(), "BtlCmd_EndOfTurnWeatherEffect")
        sand = re.search(r"FIELD_CONDITION_SANDSTORM_ALL\) \{\n\s*if \(([^\n]*)\) \{", body).group(1)
        for ability in ("SAND_VEIL", "SAND_RUSH", "SAND_FORCE"):
            self.assertIn(f"GetBattlerAbility(ctx, battlerId) != ABILITY_{ability}", sand)


class PriorityBlockTests(unittest.TestCase):
    def test_the_three_abilities_read_the_priority_the_turn_order_used(self):
        # The reference tests clientPriority, which Prankster, Gale Wings,
        # Triage and Grassy Glide have already raised; the move table's own
        # number misses all four.
        body = function(OVERLAY.read_text(), "BattleContext_CheckMoveImmunityFromAbility")
        guard = body[:body.index("ABILITY_ARMOR_TAIL")]
        guard = guard[guard.rindex("if ("):]
        self.assertIn("BattlerMovePriority(ctx, battlerIdAttacker, ctx->moveNoCur) > 0", guard)
        self.assertNotIn("->priority", guard)


class PranksterTests(unittest.TestCase):
    def test_a_dark_type_across_the_field_is_not_affected(self):
        # BattleController_CheckTypeBasedMoveConditionImmunities1: a status
        # move, Prankster, a non-zero priority, a Dark type in any of the three
        # slots, an enemy -- and "It doesn't affect {0}...".
        body = function(OVERLAY.read_text(), "BattleContext_CheckMoveImmunityFromAbility")
        match = re.search(r"if \((GetBattlerAbility\(ctx, battlerIdAttacker\) == ABILITY_PRANKSTER.*?)\) \{(.*?)\n    \}", body, re.S)
        self.assertIsNotNone(match, "Prankster is not asked about in the immunity sweep")
        condition, action = match.groups()
        for term in ("CATEGORY_STATUS", "BattlerMovePriority(ctx, battlerIdAttacker, ctx->moveNoCur) != 0",
                     "(battlerIdAttacker & 1) != (battlerIdTarget & 1)"):
            self.assertIn(term, condition)
        for slot in (1, 2, 3):
            self.assertIn(f"BMON_DATA_TYPE_{slot}, NULL) == TYPE_DARK", condition)
        self.assertIn("ctx->moveStatusFlag |= MOVE_STATUS_NO_EFFECT;", action)


class InfiltratorTests(unittest.TestCase):
    # Every status subscript whose Safeguard test a used move reaches. The
    # reference gives each of them an _handleInfiltrator bypass.
    SAFEGUARDED = ("FallAsleep", "Poison", "Burn", "Freeze", "Paralyze", "Confuse", "BadPoison", "Yawn")

    def test_it_slips_past_safeguard_with_its_own_moves(self):
        for name in self.SAFEGUARDED:
            script = subscript(name)
            # The move path's Safeguard test goes through the Infiltrator
            # question and can come straight back past itself.
            self.assertIn("SIDE_CONDITION_SAFEGUARD, _SAFEGUARD\n_BYPASS_SAFEGUARD:\n", script, name)
            block = script[script.index("\n_SAFEGUARD:"):]
            self.assertIn("BATTLER_CATEGORY_ATTACKER, BMON_DATA_ABILITY, ABILITY_INFILTRATOR, _BYPASS_SAFEGUARD", block, name)
            if name != "Yawn":
                # Not a secondary effect or a held item's: only a move used.
                self.assertIn("SIDE_EFFECT_TYPE_DIRECT, _SAFEGUARD_INFILTRATOR", block, name)
                self.assertIn("OPCODE_NEQ, BSCRIPT_VAR_SIDE_EFFECT_TYPE, SIDE_EFFECT_TYPE_MOVE_EFFECT", block, name)

    def test_it_slips_past_mist_but_intimidate_does_not(self):
        body = function(COMMANDS.read_text(), "BtlCmd_ChangeStatStage")
        mist = re.search(r"if \((ctx->fieldSideConditionData\[[^\n]*\]\.mistTurns[^{]*)\) \{", body).group(1)
        self.assertIn("GetBattlerAbility(ctx, ctx->battlerIdAttacker) != ABILITY_INFILTRATOR", mist)
        self.assertIn("ctx->statChangeType == SIDE_EFFECT_TYPE_ABILITY", mist)


class StatusImmunityTests(unittest.TestCase):
    # How many ways each status subscript can be entered -- a used move, a
    # move's own effect, Toxic Spikes, a held item -- and so how many times
    # each of these abilities has to be asked. The reference asks them on
    # every one; Comatose raw wherever a used move could have Mold Breaker.
    PATHS = {
        #  name          paths  raw Comatose  ally Flower Veil
        "FallAsleep":   (2,     2,            1),
        "Poison":       (2,     1,            2),
        "Burn":         (2,     1,            1),
        "Freeze":       (1,     1,            1),
        "Paralyze":     (1,     1,            1),
        "BadPoison":    (3,     1,            3),
    }

    def test_every_path_refuses_comatose_and_purifying_salt(self):
        for name, (paths, raw, _) in self.PATHS.items():
            script = subscript(name)
            self.assertEqual(len(re.findall(r"ABILITY_COMATOSE, _", script)), paths, name)
            self.assertEqual(len(re.findall(
                r"CompareMonDataToValue OPCODE_EQU, BATTLER_CATEGORY_SIDE_EFFECT_MON, BMON_DATA_ABILITY, ABILITY_COMATOSE", script)),
                raw, name)
            self.assertEqual(len(re.findall(r"ABILITY_PURIFYING_SALT, _", script)), paths, name)

    def test_a_burn_is_also_refused_by_water_bubble_and_thermal_exchange(self):
        script = subscript("Burn")
        for ability in ("WATER_BUBBLE", "THERMAL_EXCHANGE"):
            self.assertEqual(len(re.findall(rf"ABILITY_{ability}, _", script)), 2, ability)

    def test_flower_veil_shelters_a_grass_type_from_its_ally_too(self):
        for name, (_, _, allies) in self.PATHS.items():
            script = subscript(name)
            self.assertEqual(len(re.findall(
                r"BATTLER_RELATIVE_ALLY\|BATTLER_CATEGORY_SIDE_EFFECT_MON, ABILITY_FLOWER_VEIL, _", script)), allies, name)
            self.assertIn("BMON_DATA_TYPE_1, TYPE_GRASS", script, name)
            self.assertIn("GoToIfThirdType BATTLER_CATEGORY_SIDE_EFFECT_MON, TYPE_GRASS", script, name)

    def test_a_script_can_name_a_battler_s_ally(self):
        body = function(COMMANDS.read_text(), "BattleSystem_GetBattlerIDBySide")
        self.assertIn("side &= ~BATTLER_RELATIVE_ALLY;", body)
        self.assertIn("return ally ? (battlerID ^ 2) : battlerID;", body)


class StatusMoveRefusalTests(unittest.TestCase):
    # BattleController_CheckAbilityFailures4_StatusBasedFailures: a status
    # move is refused before it lands when its target cannot take the status.
    STATUSES = ("SLEEP", "SLEEP_NEXT_TURN", "PARALYZE", "POISON", "BADLY_POISON", "BURN")

    def setUp(self):
        self.body = function(OVERLAY.read_text(), "BattleContext_CheckMoveImmunityFromAbility")

    def guard(self, needle):
        """The `if (...)` that leads to the needle."""
        head = self.body[:self.body.index(needle)]
        return head[head.rindex("if ("):]

    def test_the_six_statuses_are_the_ones_asked_about(self):
        gives = re.search(r"BOOL givesStatus = (.*?);", self.body, re.S).group(1)
        self.assertEqual(sorted(re.findall(r"MOVE_EFFECT_STATUS_(\w+)", gives)), sorted(self.STATUSES))

    def test_comatose_takes_none_of_them(self):
        guard = self.guard("ABILITY_COMATOSE")
        self.assertIn("givesStatus", guard)
        self.assertIn("BATTLE_SUBSCRIPT_BLOCKED_BY_ABILITY", self.body[self.body.index("ABILITY_COMATOSE"):][:200])

    def test_pastel_veil_keeps_poison_off_its_side(self):
        self.assertIn("BattlerOrAllyWithAbility(ctx, battlerIdAttacker, battlerIdTarget, ABILITY_PASTEL_VEIL)", self.body)
        guard = self.guard("ABILITY_PASTEL_VEIL")
        self.assertIn("MOVE_EFFECT_STATUS_POISON", guard)
        self.assertIn("MOVE_EFFECT_STATUS_BADLY_POISON", guard)

    def test_flower_veil_keeps_them_off_a_grass_type_on_its_side(self):
        self.assertIn("BattlerOrAllyWithAbility(ctx, battlerIdAttacker, battlerIdTarget, ABILITY_FLOWER_VEIL)", self.body)
        guard = self.guard("ABILITY_FLOWER_VEIL")
        self.assertIn("givesStatus", guard)
        for slot in (1, 2, 3):
            self.assertIn(f"BMON_DATA_TYPE_{slot}, NULL) == TYPE_GRASS", guard)


if __name__ == "__main__":
    unittest.main()
