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

    def test_an_electric_type_is_not_affected(self):
        # The reference asks all three type slots after "already paralysed"
        # and before any other status sends the Pokemon to the failure line.
        script = subscript("Paralyze")
        for slot in ("TYPE_1", "TYPE_2"):
            self.assertIn(f"BMON_DATA_{slot}, TYPE_ELECTRIC, _ELECTRIC_TYPE", script)
        self.assertIn("GoToIfThirdType BATTLER_CATEGORY_SIDE_EFFECT_MON, TYPE_ELECTRIC, _ELECTRIC_TYPE", script)
        self.assertLess(script.index("STATUS_PARALYSIS, _"), script.index("TYPE_ELECTRIC"))
        self.assertLess(script.index("TYPE_ELECTRIC"), script.index("BMON_DATA_STATUS, STATUS_NONE"))
        block = script[script.index("\n_ELECTRIC_TYPE:"):]
        block = block[:block.index("GoTo")]
        # A secondary effect or Static says nothing; a used move is told.
        self.assertIn("SIDE_EFFECT_TYPE_INDIRECT, _", block)
        self.assertIn("SIDE_EFFECT_TYPE_ABILITY, _", block)
        self.assertIn("msg_0197_00027", block)


class ThawTests(unittest.TestCase):
    def test_matcha_gotcha_thaws_its_user(self):
        # BattleController_BeforeMove.c:1251 and 1785 at d0380a487: the frozen
        # roll lets the three thawing effects through, and the thaw names them.
        source = (ROOT / "src/battle/battle_controller_player.c").read_text()
        self.assertIn("effect != MOVE_EFFECT_THAW_AND_BURN_HIT && effect != MOVE_EFFECT_RECOIL_BURN_HIT"
                      " && effect != MOVE_EFFECT_RECOVER_HALF_DAMAGE_DEALT_BURN_HIT", source)
        self.assertIn("effect == MOVE_EFFECT_THAW_AND_BURN_HIT || effect == MOVE_EFFECT_RECOIL_BURN_HIT"
                      " || effect == MOVE_EFFECT_RECOVER_HALF_DAMAGE_DEALT_BURN_HIT", source)


class MortalSpinTests(unittest.TestCase):
    def test_it_poisons_and_then_clears_as_rapid_spin_does(self):
        # The reference poisons through the side effect and runs Rapid Spin's
        # subscript after the move (ServerDoPostMoveEffects.c:1166-1175).
        effect = (ROOT / "files/battledata/script/effect_script/effect_script_0371.s").read_text()
        self.assertIn("MOVE_SIDE_EFFECT_ON_HIT|MOVE_SIDE_EFFECT_TO_DEFENDER|MOVE_SUBSCRIPT_PTR_MORTAL_SPIN", effect)
        script = subscript("MortalSpin")
        self.assertLess(script.index("BMON_DATA_HP, 0, _SPIN"), script.index("Call BATTLE_SUBSCRIPT_POISON"))
        self.assertLess(script.index("Call BATTLE_SUBSCRIPT_POISON"), script.index("\n    RapidSpin"))
        # The pointer names the new subscript through the table's last entry.
        header = (ROOT / "include/constants/battle_subscript.h").read_text()
        pointer = int(re.search(r"#define MOVE_SUBSCRIPT_PTR_MORTAL_SPIN\s+(\d+)", header).group(1))
        table = OVERLAY.read_text()
        table = table[table.index("sMoveStatusChangeScripts[] = {"):]
        entries = re.findall(r"BATTLE_SUBSCRIPT_\w+", table[:table.index("};")])
        self.assertEqual(entries[pointer], "BATTLE_SUBSCRIPT_MORTAL_SPIN")
        number = int(re.search(r"#define BATTLE_SUBSCRIPT_MORTAL_SPIN\s+(\d+)", header).group(1))
        self.assertTrue((SUBSCRIPTS / f"subscript_{number:04d}_MortalSpin.s").exists())


class StuffCheeksTests(unittest.TestCase):
    @staticmethod
    def items():
        text = (ROOT / "include/constants/items.h").read_text()
        values = {name: int(number) for name, number in re.findall(r"#define (ITEM_\w+)\s+(\d+)", text)}
        for name, alias in re.findall(r"#define (\w+_BERRY_IDX)\s+(ITEM_\w+)", text):
            values[name] = values[alias]
        return values

    def test_it_fails_without_a_berry(self):
        # BattleController_BeforeMove.c:1939 at d0380a487 and its IS_ITEM_BERRY.
        items = self.items()
        script = (ROOT / "files/battledata/script/effect_script/effect_script_0398.s").read_text()
        tests = re.findall(r"CompareMonDataToValue OPCODE_(LTE|GT), BATTLER_CATEGORY_ATTACKER, BMON_DATA_HELD_ITEM, "
                           r"(\w+)(?: - (\d+))?, (_\w+)", script)
        self.assertTrue(tests)

        def refused(item):
            for opcode, name, minus, label in tests:
                bound = items[name] - int(minus or 0)
                if (item <= bound) if opcode == "LTE" else (item > bound):
                    return label == "_NO_BERRY"
            return False

        for item, berry in ((0, False), (items["ITEM_LEFTOVERS"], False), (items["ITEM_CHERI_BERRY"], True),
                            (items["ITEM_ROWAP_BERRY"], True), (items["ITEM_ROWAP_BERRY"] + 1, False),
                            (items["ITEM_ROSELI_BERRY"] - 1, False), (items["ITEM_ROSELI_BERRY"], True),
                            (items["ITEM_MARANGA_BERRY"], True), (items["ITEM_MARANGA_BERRY"] + 1, False)):
            self.assertEqual(refused(item), not berry, item)
        self.assertIn("MOVE_STATUS_FAILED", script[script.index("\n_NO_BERRY:"):])

    def test_it_is_refused_at_plus_six_defense_and_the_berry_stays(self):
        # BattleController_BeforeMove.c:3228: the stat's line, not the berry.
        script = subscript("StuffCheeks")
        self.assertLess(script.index("BMON_DATA_STAT_CHANGE_DEF, 12, _DEFENSE_MAXED"), script.index("PrintAttackMessage"))
        maxed = script[script.index("\n_DEFENSE_MAXED:"):]
        self.assertIn("Call BATTLE_SUBSCRIPT_UPDATE_STAT_STAGE", maxed)
        self.assertNotIn("StuffCheeks", maxed)
        self.assertNotIn("RemoveItem", maxed)

    def test_a_berry_eaten_by_its_own_script_is_not_removed_again(self):
        # RemoveItem keeps the item for Recycle and Harvest; a second one on
        # an empty hand would keep nothing. The Berry's own script eats it, so
        # the move's RemoveItem is only for a Berry that did nothing.
        script = subscript("StuffCheeks")
        tail = script[script.index("CallFromVar BSCRIPT_VAR_TEMP_DATA"):script.index("\n_DEFENSE_MAXED:")]
        guard = "CompareMonDataToValue OPCODE_EQU, BATTLER_CATEGORY_ATTACKER, BMON_DATA_HELD_ITEM, ITEM_NONE, _end"
        self.assertIn(guard, tail)
        self.assertLess(tail.index(guard), tail.index("RemoveItem BATTLER_CATEGORY_ATTACKER"))
        self.assertLess(tail.index("RemoveItem BATTLER_CATEGORY_ATTACKER"), tail.index("\n_end:"))


class SpitUpTests(unittest.TestCase):
    def test_spit_up_rolls_its_damage(self):
        # effect_script_0161_SPIT_UP.s at d0380a487 calls CalcDamage, which
        # rolls; HeartGold's CalcMaxDamage did not.
        script = (ROOT / "files/battledata/script/effect_script/effect_script_0161.s").read_text()
        self.assertRegex(script, r"\n\s*CalcDamage\s*\n")
        self.assertNotRegex(script, r"(?m)^\s*CalcMaxDamage")


class CoachingTests(unittest.TestCase):
    def test_it_needs_a_partner_to_coach(self):
        # BattleController_BeforeMove.c:4618 at d0380a487: a single battle, or
        # no ally standing, and the move fails before it runs.
        script = (ROOT / "files/battledata/script/effect_script/effect_script_0383.s").read_text()
        setting = script.index("MOVE_SUBSCRIPT_PTR_COACHING")
        for test in ("OPCODE_FLAG_NOT, BSCRIPT_VAR_BATTLE_TYPE, BATTLE_TYPE_DOUBLES, _NO_PARTNER",
                     "BATTLER_RELATIVE_ALLY|BATTLER_CATEGORY_ATTACKER, BMON_DATA_HP, 0, _NO_PARTNER"):
            self.assertIn(test, script)
            self.assertLess(script.index(test), setting)
        self.assertIn("MOVE_STATUS_FAILED", script[script.index("\n_NO_PARTNER:"):])


class ShedTailTests(unittest.TestCase):
    def test_the_user_leaves_its_decoy_behind(self):
        # ServerDoPostMoveEffects.c:2136-2147 at d0380a487 switches the user
        # out after the move, with the Baton Pass flag the subscript sets.
        # Here the subscript ends in Baton Pass's own switch.
        script = subscript("HandleShedTail")
        baton = subscript("BatonPass")
        switch = baton[baton.index("DeletePokemon"):baton.index("GoToSubscript BATTLE_SUBSCRIPT_SHOW_PARTY_LIST")]
        decoy = script.index("STATUS2_SUBSTITUTE\n")
        self.assertIn(switch, script[decoy:])
        self.assertLess(script.index("BMON_DATA_STAT_CHANGE_ATK, 6"), script.index(switch))
        self.assertIn("GoToSubscript BATTLE_SUBSCRIPT_SHOW_PARTY_LIST", script[decoy:])


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
        # Beat Up's own sum takes both halves at once; an ordinary hit takes
        # the critical hit's before the roll and Sniper's in the final
        # modifier, as the reference's chain does. Neither multiplies by the
        # stored number any more.
        source = COMMANDS.read_text()
        self.assertNotIn("*= ctx->criticalMultiplier", source)
        self.assertIn("ApplyCriticalHit(ctx);", function(source, "BtlCmd_BeatUp"))
        self.assertRegex(function(source, "DamageCalcDefault"),
                         r"criticalMultiplier > 1\) \{\n\s*damage = damage \* 150 / 100;")
        self.assertRegex(function(source, "FinalDamageModifier"),
                         r"criticalMultiplier == 3\) \{\n\s*modifier = QMul_RoundUp\(modifier, UQ412__1_5\);")


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


class HeldItemSafeguardTests(unittest.TestCase):
    @staticmethod
    def held_item_path(script):
        # From the question that sends every other source elsewhere to the
        # label it sends them to.
        match = re.search(r"OPCODE_NEQ, BSCRIPT_VAR_SIDE_EFFECT_TYPE, SIDE_EFFECT_TYPE_HELD_ITEM, (_\w+)", script)
        return script[match.end():script.index(f"\n{match.group(1)}:")]

    def test_the_orbs_work_behind_safeguard(self):
        # The reference comments the test out in both, as Generation V's rule.
        for name in ("Burn", "BadPoison"):
            self.assertNotIn("SIDE_CONDITION_SAFEGUARD", self.held_item_path(subscript(name)), name)

    def test_a_berry_s_confusion_keeps_the_reference_s_test(self):
        # Its subscript_0037_CONFUSE.s keeps the line live, under a comment
        # saying it should not be needed.
        self.assertIn("SIDE_CONDITION_SAFEGUARD", self.held_item_path(subscript("Confuse")))


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


CURE_FIXTURE = r"""
#include <assert.h>
#include <stdint.h>
typedef uint32_t u32;
typedef int BOOL;
enum { FALSE = 0, TRUE = 1, NARC_a_0_0_1 = 0 };
#include "constants/abilities.h"
#include "constants/battle.h"
typedef struct { int dummy; } BattleSystem;
typedef struct {
    struct { u32 status, status2; int item, ability; struct { int knockOffFlag; } unk88; } battleMons[4];
    int msgTemp, battlerIdTemp, abilityTemp, commandNext, command;
} BattleContext;
static int GetBattlerAbility(BattleContext *ctx, int battlerId) { return ctx->battleMons[battlerId].ability; }
static void ReadBattleScriptFromNarc(BattleContext *ctx, int narc, int script) { (void)ctx; (void)narc; (void)script; }
@FUNCTIONS@
static int cure(int ability, u32 status) {
    BattleSystem bs;
    BattleContext ctx = { 0 };
    ctx.battleMons[0].ability = ability;
    ctx.battleMons[0].status = status;
    ctx.msgTemp = -1;
    return CheckStatusHealAbility(&bs, &ctx, 0, 1) ? ctx.msgTemp : -1;
}
int main(void) {
    assert(cure(ABILITY_WATER_BUBBLE, STATUS_BURN) == 2);
    assert(cure(ABILITY_THERMAL_EXCHANGE, STATUS_BURN) == 2);
    assert(cure(ABILITY_PASTEL_VEIL, STATUS_POISON) == 1);
    assert(cure(ABILITY_PASTEL_VEIL, STATUS_BAD_POISON) == 1);
    assert(cure(ABILITY_WATER_BUBBLE, STATUS_PARALYSIS) == -1);
    assert(CheckStatusHealSwitch(0, ABILITY_WATER_BUBBLE, STATUS_BURN));
    assert(CheckStatusHealSwitch(0, ABILITY_THERMAL_EXCHANGE, STATUS_BURN));
    assert(CheckStatusHealSwitch(0, ABILITY_PASTEL_VEIL, STATUS_BAD_POISON));
    assert(!CheckStatusHealSwitch(0, ABILITY_THERMAL_EXCHANGE, STATUS_FREEZE));
    return 0;
}
"""


class StatusCureTests(unittest.TestCase):
    def test_the_three_abilities_cure_their_status_in_battle_and_on_the_bench(self):
        # ServerDoPostMoveEffects.c's Activate_AbilityHealingStatusCondition
        # and battle_script_commands.c's CheckStatusRecoverFromAbilityOnSwitch-
        # Wrapper: Water Bubble and Thermal Exchange cure a burn, Pastel Veil
        # poison.
        source = OVERLAY.read_text()
        functions = "\n".join(function(source, name) for name in ("CheckStatusHealAbility", "CheckStatusHealSwitch"))
        with tempfile.TemporaryDirectory(prefix="newgold-cure-") as directory:
            path = Path(directory)
            (path / "test.c").write_text(CURE_FIXTURE.replace("@FUNCTIONS@", functions))
            subprocess.run(shlex.split(os.environ.get("CC", "cc")) + [
                "-std=c99", "-Wall", "-Werror", "-Wno-unused-function", "-iquote", str(ROOT / "include"),
                str(path / "test.c"), "-o", str(path / "test")], check=True)
            subprocess.run([str(path / "test")], check=True)


class HexTests(unittest.TestCase):
    def test_a_comatose_target_counts_as_suffering(self):
        # effect_script_0287_DOUBLE_DAMAGE_ON_STATUS.s doubles Hex against a
        # Comatose target, reading the ability raw.
        script = (ROOT / "files/battledata/script/effect_script/effect_script_0279.s").read_text()
        self.assertRegex(script, r"CompareMonDataToValue OPCODE_EQU, BATTLER_CATEGORY_DEFENDER, BMON_DATA_ABILITY, "
                                 r"ABILITY_COMATOSE, (_\w+)\n(?:.*\n)*?\1:\n    UpdateVar OPCODE_SET, BSCRIPT_VAR_POWER_MULTI, 20")


class AbilityBlockListTests(unittest.TestCase):
    # Role Play (its effect script and its subscript), Skill Swap, Gastro Acid
    # and Worry Seed each refuse a list of abilities; the lists are the
    # reference's, Comatose among them, with retail's Griseous Orb kept.
    SCRIPTS = {
        "effect_script/effect_script_0178.s": "effects/effect_script_0178_COPY_ABILITY.s",
        "subscript/subscript_0135_CopyAbility.s": "subscripts/subscript_0135_COPY_ABILITY.s",
        "subscript/subscript_0143_SwapAbility.s": "subscripts/subscript_0143_EXCHANGE_ABILITIES.s",
        "subscript/subscript_0163_GastroAcid.s": "subscripts/subscript_0163_SUPPRESS_TARGET_ABILITY.s",
        "subscript/subscript_0167_WorrySeed.s": "subscripts/subscript_0167_GIVE_TARGET_INSOMNIA.s",
    }
    ENTRY = re.compile(r"(?:CompareMonDataToValue OPCODE_EQU, BATTLER_CATEGORY_(\w+), BMON_DATA_(?:ABILITY|HELD_ITEM), (\w+)"
                       r"|CheckAbility CHECK_OPCODE_HAVE, BATTLER_CATEGORY_(\w+), (ABILITY_\w+)), _")

    def entries(self, text):
        return {(a or c, b or d) for a, b, c, d in self.ENTRY.findall(text)}

    def test_comatose_is_refused(self):
        expected = {
            "effect_script/effect_script_0178.s": {"ATTACKER"},
            "subscript/subscript_0135_CopyAbility.s": {"ATTACKER", "DEFENDER"},
            "subscript/subscript_0143_SwapAbility.s": {"ATTACKER", "DEFENDER"},
            "subscript/subscript_0163_GastroAcid.s": {"DEFENDER"},
            "subscript/subscript_0167_WorrySeed.s": {"DEFENDER"},
        }
        for name, battlers in expected.items():
            found = {b for b, a in self.entries((ROOT / "files/battledata/script" / name).read_text())
                     if a == "ABILITY_COMATOSE"}
            self.assertEqual(found, battlers, name)

    # What the port refuses beyond the reference, and why: Gastro Acid also
    # turns away the two the games' unsuppressible list has and the
    # reference's list lacks, since its mark would not hold on them.
    ADDED = {
        "subscript/subscript_0163_GastroAcid.s": {("DEFENDER", "ABILITY_ZEN_MODE"), ("DEFENDER", "ABILITY_TERA_SHIFT")},
    }

    def test_the_lists_are_the_reference_s(self):
        from test_repels import REFERENCE, revision
        if REFERENCE is None:
            self.skipTest("no reference checkout")
        for name, theirs in self.SCRIPTS.items():
            ours = self.entries((ROOT / "files/battledata/script" / name).read_text())
            reference = self.entries(revision(REFERENCE, "d0380a487", "data/battle_scripts/" + theirs))
            added = self.ADDED.get(name, set()) | {(b, "ITEM_GRISEOUS_ORB") for b in ("ATTACKER", "DEFENDER")}
            self.assertEqual(ours - added, reference, name)
            self.assertLessEqual(self.ADDED.get(name, set()), ours, name)


class SubstituteTests(unittest.TestCase):
    # BattleController_CheckSubstituteBlockingOtherEffects fails these before
    # they run, unless the user has Infiltrator; Decorate is in the stat-drop
    # list beside it, which says "It doesn't affect {0}..." instead.
    SCRIPTS = {
        "subscript/subscript_0351_ChangeTargetToWaterType.s": "MOVE_STATUS_FAILED",      # Soak
        "subscript/subscript_0323_ChangeTargetToPsychicType.s": "MOVE_STATUS_FAILED",    # Magic Powder
        "subscript/subscript_0325_AddTypeGrass.s": "MOVE_STATUS_FAILED",                 # Forest's Curse
        "subscript/subscript_0324_AddTypeGhost.s": "MOVE_STATUS_FAILED",                 # Trick-or-Treat
        "subscript/subscript_0341_HandleQuash.s": "MOVE_STATUS_FAILED",
        "subscript/subscript_0320_HealPulse.s": "MOVE_STATUS_FAILED",
        "subscript/subscript_0314_Decorate.s": "MOVE_STATUS_NO_EFFECT",
        "effect_script/effect_script_0288.s": "MOVE_STATUS_FAILED",                      # Guard Split
        "effect_script/effect_script_0289.s": "MOVE_STATUS_FAILED",                      # Power Split
    }

    def test_a_substitute_stops_the_imported_moves(self):
        for name, flag in self.SCRIPTS.items():
            script = (ROOT / "files/battledata/script" / name).read_text()
            body = [line.strip() for line in script[script.index(":\n") + 2:].splitlines()
                    if line.strip() and not line.strip().startswith("//")]
            self.assertEqual(body[:2], [
                "CheckAbility CHECK_OPCODE_HAVE, BATTLER_CATEGORY_ATTACKER, ABILITY_INFILTRATOR, _PAST_SUBSTITUTE",
                "CheckSubstitute BATTLER_CATEGORY_DEFENDER, _SUBSTITUTE"], name)
            failure = script[script.index("\n_SUBSTITUTE:"):]
            self.assertIn(f"BSCRIPT_VAR_MOVE_STATUS_FLAGS, {flag}\n    End", failure, name)


class HealBlockTests(unittest.TestCase):
    # Moves the reference's HealBlockUnusableMoveEffects reaches by effect,
    # retail's fourteen among them, and the two it names by move.
    BLOCKED = ("ABSORB", "GIGA_DRAIN", "DRAIN_PUNCH", "DRAINING_KISS", "BOUNCY_BUBBLE", "DREAM_EATER",
               "MATCHA_GOTCHA", "RECOVER", "SOFT_BOILED", "ROOST", "SYNTHESIS", "SHORE_UP", "REST",
               "SWALLOW", "LUNAR_DANCE", "HEALING_WISH", "WISH", "HEAL_PULSE", "LIFE_DEW")
    BY_MOVE = ("FLORAL_HEALING", "LUNAR_BLESSING")

    def test_the_reference_s_effects_are_blocked(self):
        import struct
        from test_moves import constants, import_moves
        moves = constants("include/constants/moves.h", "MOVE_")
        effects = {int(number): name for name, number in re.findall(
            r"#define (MOVE_EFFECT_\w+)\s+(\d+)", (ROOT / "include/constants/move_effects.h").read_text())}
        table = import_moves.read_table()
        source = OVERLAY.read_text()
        self.assertIn("sHealBlockUnusableMoveEffects[] = {", source)
        listed = source[source.index("sHealBlockUnusableMoveEffects[] = {"):]
        listed = set(re.findall(r"(MOVE_EFFECT_\w+),", listed[:listed.index("};")]))
        for move in self.BLOCKED:
            effect = effects[struct.unpack_from("<H", table[moves["MOVE_" + move]])[0]]
            self.assertIn(effect, listed, move)
        named = source[source.index("sHealBlockUnusableMoves[] = {"):]
        named = named[:named.index("};")]
        for move in self.BY_MOVE:
            self.assertIn(f"MOVE_{move},", named)
        body = function(source, "BattleContext_CheckMoveHealBlocked")
        self.assertIn("sHealBlockUnusableMoveEffects[i] == effect", body)

class TintedLensTests(unittest.TestCase):
    def test_a_resisted_hit_is_doubled(self):
        # The reference multiplies by 1.25 (battle_calc_damage.c:677, UQ412__1_25),
        # Neuroforce's number; Paolo's rule (2026-09-23) keeps the canonical 2.
        body = function(COMMANDS.read_text(), "FinalDamageModifier")
        self.assertRegex(body, r"effectiveness < 8 && [^\n]*== ABILITY_TINTED_LENS\) \{\n\s*modifier = QMul_RoundUp\(modifier, UQ412__2_0\);")


class IceScalesTests(unittest.TestCase):
    def test_a_special_hit_is_halved_once(self):
        # The reference halves inside its loop over the battlers
        # (battle_calc_damage.c:788), so a quarter in a single battle and a
        # sixteenth in a double; Paolo's rule (2026-09-23) keeps the one half.
        body = function(COMMANDS.read_text(), "FinalDamageModifier")
        self.assertEqual(body.count("ABILITY_ICE_SCALES"), 1)
        self.assertRegex(body, r"\n    if \(CheckBattlerAbilityIfNotIgnored\(ctx, battlerIdAttacker, battlerIdTarget, ABILITY_ICE_SCALES\)"
                               r" == TRUE && [^\n]*CATEGORY_SPECIAL\) \{\n        modifier = QMul_RoundUp\(modifier, UQ412__0_5\);\n    \}")


class RuinTests(unittest.TestCase):
    def test_each_ruin_spares_its_own_bearer(self):
        # Tablets and Vessel cut the attacker's stat and Sword and Beads the
        # defender's, so each spares the side whose stat it cuts. The reference
        # (CalcBaseDamage.c:1292 and :1304) exempts the defender for all four,
        # a copy of the Sword block; that slip is not copied.
        body = function(OVERLAY.read_text(), "CalcMoveDamage")
        for ability, side in (("TABLETS_OF_RUIN", "calcAttacker"), ("VESSEL_OF_RUIN", "calcAttacker"),
                              ("SWORD_OF_RUIN", "calcTarget"), ("BEADS_OF_RUIN", "calcTarget")):
            self.assertIn(f"ABILITY_{ability}) && {side}.ability != ABILITY_{ability})", body)


class AuraTests(unittest.TestCase):
    def test_each_aura_powers_its_own_type(self):
        # The reference's Fairy Aura block tests TYPE_DARK (CalcBaseDamage.c:609),
        # a copy of the Dark Aura one; that slip is not copied.
        body = function(OVERLAY.read_text(), "CalcMoveDamage")
        self.assertIn("moveType == TYPE_DARK && CheckAbilityActive(battleSystem, ctx, CHECK_ABILITY_ALL_HP, 0, ABILITY_DARK_AURA)", body)
        self.assertIn("moveType == TYPE_FAIRY && CheckAbilityActive(battleSystem, ctx, CHECK_ABILITY_ALL_HP, 0, ABILITY_FAIRY_AURA)", body)


class QuickDrawTests(unittest.TestCase):
    def test_three_in_ten_and_only_for_an_attack(self):
        # 100 / 30 is 3 in integer division, which made it one in three; and a
        # status move never goes first by it.
        body = function(OVERLAY.read_text(), "CheckSortSpeed")
        for n in (1, 2):
            self.assertIn(f"ability{n} == ABILITY_QUICK_DRAW && moveNo{n} && BattleMoveTbl(ctx, moveNo{n})->category != CATEGORY_STATUS"
                          f" && (ctx->unk_310C[battlerId{n}] >> 8) % 10 < 3", body)
        self.assertNotIn("100 / 30", body)

    def test_it_raises_its_own_flag_and_says_so(self):
        # Not the Quick Claw's: that one plays the held-item animation for a
        # Pokemon holding nothing, and item thieves stand aside for it.
        body = function(OVERLAY.read_text(), "CheckSortSpeed")
        for n in (1, 2):
            self.assertIn(f"ctx->battleMons[battlerId{n}].unk88.quickDrawFlag = TRUE;", body)
        self.assertEqual(body.count("quickClawFlag = TRUE"), 2)
        self.assertIn("BMON_DATA_QUICK_DRAW_FLAG, 0, _custap", subscript("CheckQuickClaw"))


class SupersweetSyrupTests(unittest.TestCase):
    def test_once_per_pokemon_per_battle(self):
        # Its evasion drop is spent once per battle, not at every send-out: the
        # BattleMon is rebuilt each time, so the party slot remembers it.
        body = function(OVERLAY.read_text(), "TryAbilityOnEntry")
        syrup = body[body.index("case 15: // Supersweet Syrup"):body.index("case 16:")]
        self.assertIn("syrupDone = &ctx->onceOnlyEntryAbilityDone[", syrup)
        self.assertIn("if (!*syrupDone && ", syrup)
        self.assertIn("*syrupDone = TRUE;", syrup)


class EntryAbilityFlagTests(unittest.TestCase):
    def test_every_entry_ability_flag_is_cleared_when_a_pokemon_comes_in(self):
        # A flag that TryAbilityOnEntry sets and loading a Pokemon does not
        # clear makes its ability speak for the first Pokemon in that slot only.
        source = OVERLAY.read_text()
        load = function(source, "BattleSystem_GetBattleMon")
        entry = function(source, "TryAbilityOnEntry")
        for flag in sorted(set(re.findall(r"ctx->battleMons\[battlerId\]\.(\w+Flag) = TRUE;", entry))):
            self.assertIn(f"ctx->battleMons[battlerId].{flag} = 0;", load, flag)


class NeutralizingGasTests(unittest.TestCase):
    def test_it_says_when_it_comes_and_when_it_goes_before_anything_else(self):
        # The first thing the switch-in check asks, as the gas goes first in
        # the later games; once it has gone, what it held back speaks below.
        body = function(OVERLAY.read_text(), "TryAbilityOnEntry")
        first = body[body.index("case 0:"):body.index("case 1:")]
        self.assertIn("script = BATTLE_SUBSCRIPT_NEUTRALIZING_GAS_END;", first)
        self.assertIn("script = BATTLE_SUBSCRIPT_NEUTRALIZING_GAS;", first)
        self.assertLess(first.index("NEUTRALIZING_GAS"), first.index("weatherCheckFlag"))


class CudChewTests(unittest.TestCase):
    def test_a_berry_eaten_is_eaten_again_at_the_end_of_the_next_turn(self):
        source = OVERLAY.read_text()
        # Kept whenever a Berry goes down: from the hand, and plucked off a foe.
        for name in ("TryUseHeldItem", "CheckUseHeldItem"):
            self.assertIn("CudChewKeepsBerry(ctx, battlerId, ctx->battleMons[battlerId].item);", function(source, name), name)
        self.assertIn("CudChewKeepsBerry(ctx, ctx->battlerIdAttacker, ctx->battleMons[battlerId].item);",
                      function(source, "TryEatOpponentBerry"))
        self.assertIn("ctx->cudChewTurn[eater] = ctx->totalTurns + 1;", function(source, "CudChewKeepsBerry"))
        # Not across a switch.
        self.assertIn("ctx->cudChewBerry[battlerId] = ITEM_NONE;", function(source, "BattleSystem_GetBattleMon"))
        # Eaten by Pluck's routine, which applies a Berry whatever the moment,
        # at the end of the turn it was kept for, and only the once.
        end = function(source, "ov12_02253068")
        chew = end[end.index("case ABILITY_CUD_CHEW:"):]
        chew = chew[:chew.index("break;")]
        self.assertIn("ctx->cudChewTurn[battlerId] == (u16)ctx->totalTurns", chew)
        self.assertLess(chew.index("TryEatOpponentBerry(battleSystem, ctx, battlerId);"),
                        chew.index("ctx->cudChewBerry[battlerId] = ITEM_NONE;"))
        self.assertIn("script = BATTLE_SUBSCRIPT_CUD_CHEW;", chew)
        self.assertIn("CallFromVar BSCRIPT_VAR_TEMP_DATA", subscript("CudChew"))


BOND_FIXTURE = r"""
#include <assert.h>
#include <stdint.h>
typedef uint8_t u8;
typedef int8_t s8;
typedef uint16_t u16;
typedef uint32_t u32;
typedef int BOOL;
enum { FALSE = 0, TRUE = 1 };
#include "constants/abilities.h"
#include "constants/battle.h"
#include "constants/pokemon.h"
#include "constants/species.h"
typedef struct {
    struct { u16 species, ability; u32 status2; s8 statChanges[8]; } battleMons[4];
} BattleContext;
static u16 GetBattlerAbility(BattleContext *ctx, int battlerId) { return ctx->battleMons[battlerId].ability; }
@FUNCTIONS@
int main(void) {
    BattleContext ctx = { 0 };
    ctx.battleMons[0].species = SPECIES_GRENINJA_BATTLE_BOND;
    ctx.battleMons[0].ability = ABILITY_BATTLE_BOND;
    for (int i = 0; i < 8; i++) {
        ctx.battleMons[0].statChanges[i] = 6;
    }
    assert(BattlerBattleBondBoosts(&ctx, 0, FALSE));
    // Once a battle.
    assert(!BattlerBattleBondBoosts(&ctx, 0, TRUE));
    // Kept for later while all three are at +6; one with room is enough.
    ctx.battleMons[0].statChanges[STAT_ATK] = 12;
    ctx.battleMons[0].statChanges[STAT_SPATK] = 12;
    ctx.battleMons[0].statChanges[STAT_SPEED] = 12;
    assert(!BattlerBattleBondBoosts(&ctx, 0, FALSE));
    ctx.battleMons[0].statChanges[STAT_SPEED] = 11;
    assert(BattlerBattleBondBoosts(&ctx, 0, FALSE));
    // Not an Ash-Greninja, not an ordinary Greninja, not a copy.
    ctx.battleMons[0].species = SPECIES_GRENINJA_ASH;
    assert(!BattlerBattleBondBoosts(&ctx, 0, FALSE));
    ctx.battleMons[0].species = SPECIES_GRENINJA_BATTLE_BOND;
    ctx.battleMons[0].ability = ABILITY_TORRENT;
    assert(!BattlerBattleBondBoosts(&ctx, 0, FALSE));
    ctx.battleMons[0].ability = ABILITY_BATTLE_BOND;
    ctx.battleMons[0].status2 = STATUS2_TRANSFORM;
    assert(!BattlerBattleBondBoosts(&ctx, 0, FALSE));
    return 0;
}
"""


class BattleBondTests(unittest.TestCase):
    def test_a_knockout_raises_three_stats_once_a_battle(self):
        source = OVERLAY.read_text()
        with tempfile.TemporaryDirectory(prefix="newgold-bond-") as directory:
            path = Path(directory)
            (path / "test.c").write_text(BOND_FIXTURE.replace("@FUNCTIONS@", function(source, "BattlerBattleBondBoosts")))
            subprocess.run(shlex.split(os.environ.get("CC", "cc")) + [
                "-std=c99", "-Wall", "-Werror", "-Wno-unused-function", "-iquote", str(ROOT / "include"),
                str(path / "test.c"), "-o", str(path / "test")], check=True)
            subprocess.run([str(path / "test")], check=True)
        hit = function(source, "CheckAbilityEffectOnHit")
        knockout = hit[hit.index("u8 *bondSpent = &ctx->onceOnlyEntryAbilityDone["):]
        self.assertLess(knockout.index("BattlerBattleBondBoosts(ctx, ctx->battlerIdAttacker, *bondSpent) == TRUE"),
                        knockout.index("*bondSpent = TRUE;"))
        self.assertIn("*script = BATTLE_SUBSCRIPT_BATTLE_BOND;", knockout)
        script = subscript("BattleBond")
        for stat in ("ATTACK", "SP_ATTACK", "SPEED"):
            self.assertIn(f"MOVE_SUBSCRIPT_PTR_{stat}_UP_1_STAGE\n    Call BATTLE_SUBSCRIPT_UPDATE_STAT_STAGE", script)


if __name__ == "__main__":
    unittest.main()
