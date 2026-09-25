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
CONTROLLER = ROOT / "src/battle/battle_controller_player.c"
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


class BattleBerryTests(unittest.TestCase):
    def test_the_roseli_kee_and_maranga_berries_are_berries_in_battle(self):
        # The reference's IS_ITEM_BERRY takes the three imported after the
        # retail range; ItemIdIsBerry, the field's, does not. Every Berry
        # question in battle -- Bug Bite, Teatime, Stuff Cheeks, Cud Chew,
        # Harvest, Incinerate, Unnerve, Ripen, Cheek Pouch, Belch -- asks the
        # battle's own.
        body = function(OVERLAY.read_text(), "BattleItemIsBerry")
        self.assertIn("item >= ITEM_ROSELI_BERRY && item <= ITEM_MARANGA_BERRY", body)
        for path in sorted((ROOT / "src/battle").glob("*.c")):
            source = re.sub(r"//[^\n]*", "", path.read_text())
            self.assertNotIn("ItemIdIsBerry(", source, path.name)
            if path != OVERLAY:
                self.assertNotIn("FIRST_BERRY_IDX", source, path.name)
        self.assertEqual(OVERLAY.read_text().count("FIRST_BERRY_IDX"), 1)


class EatenBerryTests(unittest.TestCase):
    def test_the_enigma_kee_and_maranga_berries_feed_their_eater(self):
        # Pokemon Central: eaten through Bug Bite, Pluck, Stuff Cheeks,
        # Teatime or Cud Chew, the Enigma Berry gives a quarter of the HP
        # (Baccaenigma, from the eighth generation), the Kee Berry a stage of
        # Defense (Baccalighia), the Maranga one of Sp. Def (Baccapane). Their
        # records have no pluck effect, and they were eaten for nothing.
        eat = function(OVERLAY.read_text(), "TryEatOpponentBerry")
        default = eat[eat.index("    default:"):]
        enigma = default[default.index("== HOLD_EFFECT_HP_RESTORE_SE"):]
        self.assertIn("script = BATTLE_SUBSCRIPT_HELD_ITEM_HP_RESTORE;", enigma[:enigma.index("}")])
        # The Kee and Maranga Berries by their records' pluck effects, the
        # Ganlon and Apicot Berries' cases.
        records = {row[0]: row for row in (line.split(",") for line in
                   (ROOT / "files/itemtool/itemdata/item_data.csv").read_text().splitlines())}
        header = records["item"]
        for item, twin in (("ITEM_KEE_BERRY", "ITEM_GANLON_BERRY"), ("ITEM_MARANGA_BERRY", "ITEM_APICOT_BERRY")):
            pluck = header.index("pluckEffect")
            self.assertEqual(records[item][pluck], records[twin][pluck], item)
        for case, stat in (("STEAL_EFFECT_DEF_UP", "2"), ("STEAL_EFFECT_SPDEF_UP", "5")):
            body = eat[eat.index(f"case {case}:"):]
            self.assertIn(f"ctx->msgTemp = {stat};", body[:body.index("break;")])
        # Bug Bite and Pluck eat a Kee Berry before it raises its holder's
        # Defense, Sticky Hold aside (Baccalighia).
        hit = function(OVERLAY.read_text(), "CheckItemEffectOnHit")
        kee = hit[hit.index("case HOLD_EFFECT_BOOST_DEF_ON_PHYSICAL_HIT:"):]
        kee = kee[:kee.index("break;")]
        self.assertIn("->effect == MOVE_EFFECT_EAT_BERRY", kee)
        self.assertIn("ABILITY_STICKY_HOLD) != TRUE", kee)
        # A user Rough Skin or Iron Barbs has felled, asked before this
        # (ov12_0224CAA4, controller command 29), eats nothing: the Berry
        # answers the hit (Coleomorso).
        self.assertIn("MOVE_EFFECT_EAT_BERRY\n                    && ctx->battleMons[ctx->battlerIdAttacker].hp\n", kee)
        controller = (ROOT / "src/battle/battle_controller_player.c").read_text()
        abilities = function(controller, "ov12_0224CAA4")
        self.assertIn("CheckAbilityEffectOnHit(battleSystem, ctx, &script)", abilities)
        self.assertTrue(abilities.rstrip().endswith("ctx->command = CONTROLLER_COMMAND_31;\n}"))
        self.assertIn("CheckItemEffectOnHit(battleSystem, ctx, &script)", function(controller, "ov12_0224CC88"))


class PluckKlutzTests(unittest.TestCase):
    def test_bug_bite_and_pluck_feed_a_klutz_or_embargo_eater(self):
        # Pokemon Central (Coleomorso, Spennata): from the fifth generation
        # the user has the Berry's effect under Klutz or Embargo. Its own
        # Berry -- Teatime, Stuff Cheeks, Cud Chew -- is still withheld.
        eat = function(OVERLAY.read_text(), "TryEatOpponentBerry")
        self.assertIn("if (battlerId == ctx->battlerIdAttacker && (GetBattlerAbility(ctx, ctx->battlerIdAttacker) == ABILITY_KLUTZ"
                      " || (ctx->battleMons[ctx->battlerIdAttacker].moveEffectFlags & MOVE_EFFECT_FLAG_EMBARGO))) {\n"
                      "            ctx->tempData = 0;", eat)


class MatchaGotchaTests(unittest.TestCase):
    def test_it_drains_on_every_hit_and_burns_one_time_in_five(self):
        # Pokemon Central (Spruzzate): half the damage back on every hit, a
        # burn at 20%. Without ON_HIT ov12_02250490 rolled the 20% first and
        # the subscript rolled the burn again: a drain on 20% of hits, a burn
        # on 4%, and Sheer Force and a Covert Cloak dropped the drain too.
        effect = (ROOT / "files/battledata/script/effect_script/effect_script_0352.s").read_text()
        self.assertIn("MOVE_SIDE_EFFECT_ON_HIT|MOVE_SIDE_EFFECT_TO_DEFENDER|MOVE_SUBSCRIPT_PTR_BURN_AND_DRAIN_HEALTH", effect)
        script = subscript("BurnAndDrainHealth")
        drain = script.index("Call BATTLE_SUBSCRIPT_DRAIN_HALF_DAMAGE_DEALT")
        for check in ("ABILITY_SHEER_FORCE, NoBurn", "HOLD_EFFECT_PREVENT_SECONDARY_EFFECTS, NoBurn", "CheckEffectActivation NoBurn"):
            self.assertLess(drain, script.index(check))
            self.assertLess(script.index(check), script.index("Call BATTLE_SUBSCRIPT_BURN"))
        # Sheer Force still powers it, and leaves it the drain.
        overlay = OVERLAY.read_text()
        self.assertIn("case MOVE_EFFECT_RECOVER_HALF_DAMAGE_DEALT_BURN_HIT:", function(overlay, "IsSuppressibleSecondaryEffect"))
        self.assertIn("->effect != MOVE_EFFECT_RECOVER_HALF_DAMAGE_DEALT_BURN_HIT", function(overlay, "ov12_02250490"))


class MortalSpinTests(unittest.TestCase):
    def test_it_poisons_and_clears_once_the_move_is_over(self):
        # The reference poisons through the side effect and runs Rapid Spin's
        # subscript after the move (ServerDoPostMoveEffects.c:1166-1175), if
        # the user stands (Pokemon Central, Glitturbine).
        effect = (ROOT / "files/battledata/script/effect_script/effect_script_0371.s").read_text()
        self.assertIn("MOVE_SIDE_EFFECT_TO_DEFENDER|MOVE_SUBSCRIPT_PTR_POISON\n", effect)
        self.assertNotIn("MORTAL_SPIN", effect)
        script = subscript("MortalSpin")
        self.assertIn("\n    RapidSpin\n", script)
        self.assertNotIn("POISON", script.split("_000:")[1])
        step = function((ROOT / "src/battle/battle_controller_player.c").read_text(), "TryAdditionalMoveEffect")
        case = step[step.index("case MOVE_EFFECT_MORTAL_SPIN:"):]
        case = case[:case.index("break;")]
        self.assertIn("if (!ctx->battleMons[ctx->battlerIdAttacker].hp) {", case)
        self.assertIn("script = BATTLE_SUBSCRIPT_MORTAL_SPIN;", case)


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

    def test_it_eats_any_berry_and_then_raises_defense(self):
        # Pokemon Central (Riempiguance): the Berry is eaten and has its
        # effect whatever its own condition -- a Liechi Berry at full HP --
        # as Bug Bite's does, then Defense rises by two. The held-item check
        # asked before ate a pinch Berry only in a pinch, and came second.
        body = function(COMMANDS.read_text(), "BtlCmd_StuffCheeks")
        self.assertIn("TryEatOpponentBerry(battleSystem, ctx, ctx->battlerIdAttacker) != TRUE", body)
        self.assertNotIn("CheckUseHeldItem", body)
        script = subscript("StuffCheeks")
        script = script[:script.index("\n_DEFENSE_MAXED:")]
        steps = ["StuffCheeks _RAISE", "RemoveItem BATTLER_CATEGORY_ATTACKER", "CallFromVar BSCRIPT_VAR_TEMP_DATA",
                 "\n_RAISE:", "SELF_TURN_FLAG_PLUCK_BERRY", "MOVE_SUBSCRIPT_PTR_DEFENSE_UP_2_STAGES"]
        self.assertEqual([script.index(step) for step in steps], sorted(script.index(step) for step in steps))
        # Removed once: the eating marks the Berry as Bug Bite's, which its
        # own script's PLUCK_CHECK does not remove again.
        self.assertEqual(script.count("RemoveItem"), 1)


class LifeDewTests(unittest.TestCase):
    def test_it_heals_the_user_and_its_allies(self):
        # Pokemon Central (Goccia Vitale): a quarter of each one's maximum HP,
        # rounded up, the user and its allies. It healed the user alone, and
        # its full-HP check compared against battle var BMON_DATA_MAXHP.
        heal = subscript("LifeDew")
        self.assertIn("IfSameSide BATTLER_CATEGORY_ATTACKER, BATTLER_CATEGORY_SIDE_EFFECT_MON, _CHECK", heal)
        self.assertIn("GoToIfValidMon BSCRIPT_VAR_BATTLER_SPEED_TEMP, _LOOP", heal)
        self.assertIn("DivideVarByValueRoundUp BSCRIPT_VAR_HP_CALC, 4", heal)
        self.assertNotIn("BMON_DATA_HP, BMON_DATA_MAXHP", heal)
        # With nobody to heal it fails before it runs.
        effect = (ROOT / "files/battledata/script/effect_script/effect_script_0385.s").read_text()
        self.assertLess(effect.index("MOVE_STATUS_FAILED"), effect.index("\n_FOUND:"))
        self.assertIn("MOVE_SIDE_EFFECT_TO_ATTACKER|MOVE_SUBSCRIPT_PTR_LIFE_DEW", effect[effect.index("\n_FOUND:"):])

    def test_an_ally_s_water_absorb_dry_skin_or_storm_drain_takes_it(self):
        # Pokemon Central (Goccia Vitale): the ally's ability answers the move
        # in place of the heal -- a quarter of its HP by Water Absorb or Dry
        # Skin, a stage of Sp. Atk by Storm Drain; not the user's own.
        heal = subscript("LifeDew")
        check = heal[heal.index("\n_CHECK:"):heal.index("\n_HEAL:")]
        self.assertLess(check.index("BSCRIPT_VAR_BATTLER_ATTACKER, _HEAL"), check.index("ABILITY_WATER_ABSORB"))
        for ability, label in (("WATER_ABSORB", "_ABSORB"), ("DRY_SKIN", "_ABSORB"), ("STORM_DRAIN", "_STORM_DRAIN")):
            self.assertIn(f"CheckIgnorableAbility CHECK_OPCODE_HAVE, BATTLER_CATEGORY_SIDE_EFFECT_MON, ABILITY_{ability}, {label}", check)
        absorb = heal[heal.index("\n_ABSORB:"):heal.index("\n_STORM_DRAIN:")]
        self.assertIn("msg_0197_00635, TAG_NICKNAME_ABILITY", absorb)
        self.assertIn("DivideVarByValue BSCRIPT_VAR_HP_CALC, 4", absorb)
        storm = heal[heal.index("\n_STORM_DRAIN:"):heal.index("\n_USELESS:")]
        self.assertIn("MOVE_SUBSCRIPT_PTR_SP_ATTACK_UP_1_STAGE", storm)
        self.assertIn("SIDE_EFFECT_TYPE_ABILITY", storm)
        # Such an ally is someone the move reaches, whatever its HP.
        effect = (ROOT / "files/battledata/script/effect_script/effect_script_0385.s").read_text()
        self.assertIn("ABILITY_STORM_DRAIN, _FOUND", effect)
        self.assertLess(effect.index("ABILITY_WATER_ABSORB, _FOUND"), effect.index("BMON_DATA_HEAL_BLOCK_TURNS"))


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


    def test_the_damage_path_takes_it(self):
        # battle_calc_damage.c: 6.4 multiplies by 150/100, and 6.9.3 gives
        # Sniper another 1.5. HeartGold multiplied by 2, and by 3 for Sniper.
        # An ordinary hit takes the critical hit's half before the roll and
        # Sniper's in the final modifier, as the reference's chain does, and
        # nothing multiplies by the stored number any more. Beat Up used to
        # have a sum of its own; its hits are ordinary ones now.
        source = COMMANDS.read_text()
        self.assertNotIn("*= ctx->criticalMultiplier", source)
        self.assertNotIn("ctx->damage", function(source, "BtlCmd_BeatUp"))
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


NATURAL_GIFT_FIXTURE = r"""
#include <assert.h>
#include <stdint.h>
typedef uint8_t u8;
typedef uint16_t u16;
typedef uint32_t u32;
typedef int BOOL;
enum { FALSE = 0, TRUE = 1 };
#include "constants/battle.h"
#include "constants/move_effects.h"
typedef struct { u16 effect; } MoveTbl;
typedef struct { int hp, item; } Mon;
typedef struct {
    Mon battleMons[4];
    int battlerIdAttacker, battlerIdTarget;
    u32 moveNoCur, battleStatus2, moveStatusFlag;
    MoveTbl move;
} BattleContext;
static const MoveTbl *BattleMoveTbl(BattleContext *ctx, u32 moveNo) { (void)moveNo; return &ctx->move; }
// 80 for the one Berry of the test, as a Berry Klutz, Embargo or Magic Room
// leave unusable reads 0.
static int GetNaturalGiftPower(BattleContext *ctx, int battlerId) { return ctx->battleMons[battlerId].item ? 80 : 0; }
@FUNCTIONS@
static BattleContext ctx;
static void setup(void) {
    BattleContext blank = { 0 };
    ctx = blank;
    ctx.move.effect = MOVE_EFFECT_NATURAL_GIFT;
    ctx.battleMons[0].hp = 100;
    ctx.battleMons[0].item = 1;
    ctx.battleStatus2 = BATTLE_STATUS2_MOVE_SUCCEEDED;
}
int main(void) {
    setup();
    assert(NaturalGiftSpendsBerry(&ctx));
    // Not when a Red Card or the user's own switch has sent it back, nor when
    // it has fainted, nor for a Berry it could not use, nor for a move
    // stopped before it went off.
    setup();
    ctx.battleStatus2 |= BATTLE_STATUS2_UTURN;
    assert(!NaturalGiftSpendsBerry(&ctx));
    setup();
    ctx.battleMons[0].hp = 0;
    assert(!NaturalGiftSpendsBerry(&ctx));
    setup();
    ctx.battleMons[0].item = 0;
    assert(!NaturalGiftSpendsBerry(&ctx));
    setup();
    ctx.battleStatus2 = 0;
    assert(!NaturalGiftSpendsBerry(&ctx));
    setup();
    ctx.move.effect = MOVE_EFFECT_HIT;
    assert(!NaturalGiftSpendsBerry(&ctx));
    // At a target that fainted before the move, the Berry goes; stopped by a
    // primal weather or Powder, it stays.
    setup();
    ctx.battleStatus2 = 0;
    ctx.battlerIdTarget = BATTLER_NONE;
    assert(NaturalGiftSpendsBerry(&ctx));
    ctx.moveStatusFlag = MOVE_STATUS_NO_MORE_WORK;
    assert(!NaturalGiftSpendsBerry(&ctx));
    return 0;
}
"""


NATURAL_GIFT_BEFORE_FIXTURE = r"""
#include <assert.h>
#include <stdint.h>
typedef uint8_t u8;
typedef uint16_t u16;
typedef uint32_t u32;
typedef int BOOL;
enum { FALSE = 0, TRUE = 1 };
#include "constants/battle.h"
#include "constants/move_effects.h"
#include "constants/pokemon.h"
typedef struct { u16 effect; } MoveTbl;
typedef struct { int item; } Mon;
typedef struct {
    Mon battleMons[4];
    int battlerIdAttacker, movePower;
    u32 moveNoCur, moveStatusFlag;
    u8 moveType;
    MoveTbl move;
} BattleContext;
static const MoveTbl *BattleMoveTbl(BattleContext *ctx, u32 moveNo) { (void)moveNo; return &ctx->move; }
// A Cheri Berry, 80 and Fire; nothing, or one it cannot use, 0.
static int GetNaturalGiftPower(BattleContext *ctx, int battlerId) { return ctx->battleMons[battlerId].item ? 80 : 0; }
static int GetNaturalGiftType(BattleContext *ctx, int battlerId) { (void)ctx; (void)battlerId; return TYPE_FIRE; }
@FUNCTIONS@
int main(void) {
    BattleContext ctx = { 0 };
    ctx.move.effect = MOVE_EFFECT_NATURAL_GIFT;
    ctx.battleMons[0].item = 1;
    TryNaturalGift(&ctx);
    assert(ctx.movePower == 80 && ctx.moveType == TYPE_FIRE && !ctx.moveStatusFlag);
    ctx.battleMons[0].item = 0;
    ctx.movePower = 0;
    ctx.moveType = 0;
    TryNaturalGift(&ctx);
    assert(ctx.moveStatusFlag == MOVE_STATUS_FAILED && ctx.moveType == 0);
    ctx.moveStatusFlag = 0;
    ctx.move.effect = MOVE_EFFECT_HIT;
    TryNaturalGift(&ctx);
    assert(!ctx.moveStatusFlag && !ctx.movePower);
    return 0;
}
"""


class NaturalGiftTests(unittest.TestCase):
    def test_the_berry_is_asked_before_the_move(self):
        # The engine's before-move failures (BattleController_CheckMoveFailures1):
        # once the PP is spent, and before the primal weathers and Powder,
        # which see the Berry's type (Pokemon Central, Dononaturale: they keep
        # the Berry).
        from test_ability_interactions import run_c
        controller = CONTROLLER.read_text()
        run_c(NATURAL_GIFT_BEFORE_FIXTURE.replace("@FUNCTIONS@", function(controller, "TryNaturalGift")))
        steps = function(controller, "ov12_0224C38C")
        self.assertLess(steps.index("ov12_0224B1FC(battleSystem, ctx)"), steps.index("TryNaturalGift(ctx);"))
        self.assertLess(steps.index("TryNaturalGift(ctx);"), steps.index("PrimalWeatherStopsMove("))
        script = (ROOT / "files/battledata/script/effect_script/effect_script_0222.s").read_text()
        self.assertNotIn("CalcNaturalGiftParams", script)

    def test_at_a_fainted_target_the_berry_goes_too(self):
        # Pokemon Central (Dononaturale): the Berry goes when the move fails
        # because the target has already fainted.
        body = function(CONTROLLER.read_text(), "ov12_0224B398")
        self.assertIn("BattleMoveTbl(ctx, ctx->moveNoCur)->effect == MOVE_EFFECT_NATURAL_GIFT) {\n"
                      "            ctx->commandNext = CONTROLLER_COMMAND_36;", body)

    def test_the_berry_goes_once_the_move_is_over(self):
        # Pokemon Central (Dononaturale): spent on a miss, Protect or an
        # immunity, kept when a Red Card sends the user back -- so spent at
        # the end of the move, where the engine spends it (step 25.0, after
        # Pickpocket).
        from test_ability_interactions import run_c
        controller = CONTROLLER.read_text()
        run_c(NATURAL_GIFT_FIXTURE.replace("@FUNCTIONS@", function(controller, "NaturalGiftSpendsBerry")))
        steps = function(controller, "ov12_0224E1BC")
        self.assertLess(steps.index("TryPickpocket("), steps.index("NaturalGiftSpendsBerry(ctx) == TRUE"))
        self.assertLess(steps.index("NaturalGiftSpendsBerry(ctx) == TRUE"), steps.index("HOLD_EFFECT_BOOST_SPATK_ON_SOUND_MOVE"))
        pluck_check = (SUBSCRIPTS / "subscript_0290_Pluck.s").read_text()
        self.assertIn("#define BATTLE_SUBSCRIPT_PLUCK_CHECK                      290",
                      (ROOT / "include/constants/battle_subscript.h").read_text())
        self.assertIn("RemoveItem BATTLER_CATEGORY_MSG_TEMP", pluck_check)


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
    # Gastro Acid, Worry Seed and Simple Beam refuse what the ability table
    # says nothing suppresses or writes over -- the reference's
    # AbilityCantSupress, which its move-failure check asks for all three --
    # and each keeps only its own few beside it: what its reference script
    # adds, and what is listed under ADDED. Role Play and Skill Swap ask the
    # table too (test_ability_interactions).
    SCRIPTS = {
        "subscript/subscript_0163_GastroAcid.s": "subscripts/subscript_0163_SUPPRESS_TARGET_ABILITY.s",
        "subscript/subscript_0167_WorrySeed.s": "subscripts/subscript_0167_GIVE_TARGET_INSOMNIA.s",
        "subscript/subscript_0338_GiveTargetSimple.s": "subscripts/subscript_0377_GIVE_TARGET_SIMPLE.s",
    }
    TABLE = "CompareMonDataToValue OPCODE_FLAG_SET, BATTLER_CATEGORY_DEFENDER, BMON_DATA_ABILITY_FLAGS, ABILITY_FLAG_FAILS_SUPPRESS, _"
    ENTRY = re.compile(r"(?:CompareMonDataToValue OPCODE_EQU, BATTLER_CATEGORY_(\w+), BMON_DATA_(?:ABILITY|HELD_ITEM), (\w+)"
                       r"|CheckAbility CHECK_OPCODE_HAVE, BATTLER_CATEGORY_(\w+), (ABILITY_\w+)), _")

    def entries(self, text):
        return {(a or c, b or d) for a, b, c, d in self.ENTRY.findall(text)}

    @staticmethod
    def unsuppressable():
        from test_ability_interactions import ability_flag_table
        return {ability for ability, flags in ability_flag_table().items() if "ABILITY_FLAG_FAILS_SUPPRESS" in flags}

    def test_they_ask_the_table(self):
        # Comatose, and Gen 9's Zero to Hero and Tera Shift, which Worry Seed
        # and Simple Beam missed (Pokemon Central, Supercambio, Teramorfosi).
        self.assertLessEqual({"ABILITY_COMATOSE", "ABILITY_ZERO_TO_HERO", "ABILITY_TERA_SHIFT"}, self.unsuppressable())
        for name in self.SCRIPTS:
            text = (ROOT / "files/battledata/script" / name).read_text()
            self.assertIn(self.TABLE, text, name)
            self.assertLess(text.index(self.TABLE), text.index("Call BATTLE_SUBSCRIPT_ATTACK_MESSAGE_AND_ANIMATION"), name)
            self.assertEqual({a for _, a in self.entries(text)} & self.unsuppressable(), set(), name)

    # What the port refuses beyond the reference's script, and why: a target
    # holding an Ability Shield (Pokemon Central, Scudo abilita). Retail's
    # Griseous Orb is gone from Worry Seed, as from the fifth generation
    # (Pokemon Central, Affannoseme) and from the reference.
    ADDED = {
        "subscript/subscript_0163_GastroAcid.s": {("DEFENDER", "ITEM_ABILITY_SHIELD")},
    }

    # What the reference refuses and the port does not, and why: the latest
    # game version's rule where Pokemon Central's pages disagree. Commander is
    # suppressed and written over from Scarlet and Violet 2.0.1 (Torre di
    # Comando, over the older lists of Gastroacido and Affannoseme);
    # Protosynthesis and Quark Drive are suppressed from 3.0.0
    # (Paleoattivazione, Carica Quark). Zen Mode stays refused, as Stato Zen
    # has it from the seventh generation.
    REMOVED = {
        "subscript/subscript_0163_GastroAcid.s": {("DEFENDER", "ABILITY_COMMANDER"), ("DEFENDER", "ABILITY_QUARK_DRIVE"),
                                                  ("DEFENDER", "ABILITY_PROTOSYNTHESIS")},
        "subscript/subscript_0167_WorrySeed.s": {("DEFENDER", "ABILITY_COMMANDER")},
    }

    def test_commander_and_the_paradox_abilities_give_way(self):
        # Entrainment too, on the target's side, as Saltamicizia lists them
        # (the decision is in subscript 316's note).
        for name in ("subscript_0163_GastroAcid.s", "subscript_0167_WorrySeed.s", "subscript_0445_CoreEnforcer.s",
                     "subscript_0316_Entrainment.s"):
            code = [line for line in (ROOT / "files/battledata/script/subscript" / name).read_text().splitlines()
                    if not line.strip().startswith("//")]
            for ability in ("ABILITY_COMMANDER", "ABILITY_QUARK_DRIVE", "ABILITY_PROTOSYNTHESIS"):
                self.assertFalse([line for line in code if ability in line], (name, ability))
        self.assertIn("ABILITY_ZEN_MODE", self.unsuppressable())

    def test_worry_seed_ignores_the_griseous_orb(self):
        text = (ROOT / "files/battledata/script/subscript/subscript_0167_WorrySeed.s").read_text()
        self.assertNotIn("ITEM_GRISEOUS_ORB", text)

    def test_the_lists_are_the_reference_s(self):
        from test_repels import REFERENCE, revision
        if REFERENCE is None:
            self.skipTest("no reference checkout")
        table = {("DEFENDER", ability) for ability in self.unsuppressable()}
        for name, theirs in self.SCRIPTS.items():
            ours = self.entries((ROOT / "files/battledata/script" / name).read_text())
            reference = self.entries(revision(REFERENCE, "d0380a487", "data/battle_scripts/" + theirs))
            self.assertEqual(reference - ours - table, self.REMOVED.get(name, set()), name)
            self.assertEqual(ours - reference, self.ADDED.get(name, set()), name)


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


BELCH_FIXTURE = r"""
#include <assert.h>
typedef int BOOL;
enum { FALSE = 0, TRUE = 1 };
typedef struct { int dummy; } Party;
typedef struct { Party *parties[4]; } BattleSystem;
typedef struct { unsigned char berryEaten[4][6]; int selectedMonIndex[4]; } BattleContext;
static int BattleSystem_GetBattlerIdPartner(BattleSystem *bs, int battlerId) { (void)bs; return battlerId ^ 2; }
static Party *BattleSystem_GetParty(BattleSystem *bs, int battlerId) { return bs->parties[battlerId]; }
@FUNCTION@
int main(void) {
    static Party player, enemy, partner;
    // One trainer's double: the Pokemon in slot 3 eats a Berry from the
    // left position and is known to have eaten it from the right one too.
    BattleSystem bs = { { &player, &enemy, &player, &enemy } };
    BattleContext ctx = { { { 0 } }, { 0, 1, 3, 2 } };
    RememberBerryEaten(&bs, &ctx, 2);
    assert(ctx.berryEaten[2][3] && ctx.berryEaten[0][3]);
    assert(!ctx.berryEaten[1][3] && !ctx.berryEaten[3][3] && !ctx.berryEaten[0][0]);
    // A multi battle's partner has a party of its own: its slot 3 is another Pokemon.
    BattleSystem multi = { { &player, &enemy, &partner, &enemy } };
    BattleContext other = { { { 0 } }, { 3, 1, 0, 2 } };
    RememberBerryEaten(&multi, &other, 0);
    assert(other.berryEaten[0][3] && !other.berryEaten[2][3]);
    return 0;
}
"""


class BelchMemoryTests(unittest.TestCase):
    """Belch's eaten Berry is remembered for the Pokemon, whichever position
    of its trainer's pair it comes back to, as the entry abilities are."""

    def test_both_positions_of_a_shared_party_are_told(self):
        commands = COMMANDS.read_text()
        with tempfile.TemporaryDirectory(prefix="newgold-belch-") as directory:
            path = Path(directory)
            (path / "test.c").write_text(BELCH_FIXTURE.replace("@FUNCTION@", function(commands, "RememberBerryEaten")))
            subprocess.run(shlex.split(os.environ.get("CC", "cc")) + [
                "-std=c99", "-Wall", "-Werror", "-Wno-unused-function",
                str(path / "test.c"), "-o", str(path / "test")], check=True)
            subprocess.run([str(path / "test")], check=True)
        self.assertIn("RememberBerryEaten(battleSystem, ctx, battlerId);", function(commands, "BtlCmd_RemoveItem"))

    def test_the_pokemon_that_eats_a_taken_berry_is_told(self):
        """Pokemon Central (Rutto): a Berry plucked by Bug Bite or Pluck counts
        for the plucker, a flung one for the Pokemon it lands on, and neither
        for the Pokemon that held it; one spent on Natural Gift for nobody."""
        commands, overlay = COMMANDS.read_text(), OVERLAY.read_text()
        remove = function(commands, "BtlCmd_RemoveItem")
        self.assertIn("&& !ctx->selfTurnData[battlerId].berryNotEaten) {\n"
                      "        RememberBerryEaten(battleSystem, ctx, battlerId);", remove)
        self.assertIn("ctx->selfTurnData[battlerId].berryNotEaten = FALSE;", remove)
        pluck = function(overlay, "TryEatOpponentBerry")
        self.assertIn("RememberBerryEaten(battleSystem, ctx, ctx->battlerIdAttacker);", pluck)
        self.assertIn("ctx->selfTurnData[battlerId].berryNotEaten = TRUE;", pluck)
        self.assertIn("ctx->selfTurnData[battlerId].berryNotEaten = TRUE;", function(overlay, "TryFling"))
        self.assertIn("RememberBerryEaten(battleSystem, ctx, battlerId);", function(overlay, "FlungItemLands"))
        self.assertIn("ctx->selfTurnData[ctx->battlerIdAttacker].berryNotEaten = TRUE;",
                      function(CONTROLLER.read_text(), "ov12_0224E1BC"))

class ScriptStageTests(unittest.TestCase):
    def test_a_script_keeps_a_stage_within_six(self):
        """Steam Engine adds six Speed stages at once through UpdateMonData,
        which wrote whatever the sum was: at +1 it made the stage +7 and
        beyond, past the end of the stat ratio table. The stat-change
        command clamps; the reference's Steam Engine goes through it."""
        update = function(COMMANDS.read_text(), "BtlCmd_UpdateMonData")
        self.assertIn("if (stage >= BMON_DATA_STAT_CHANGE_HP && stage <= BMON_DATA_STAT_CHANGE_EVASION) {\n"
                      "        var = var < 0 ? 0 : var > 12 ? 12 : var;", update)
        self.assertLess(update.index("var = var < 0 ? 0 : var > 12 ? 12 : var;"), update.index("SetBattlerVar(ctx, battlerId, varId, &var);"))


INFILTRATOR_FIXTURE = r"""
#include <assert.h>
#include <stdint.h>
typedef uint32_t u32; typedef uint16_t u16;
typedef int BOOL;
enum { FALSE = 0, TRUE = 1 };
#include "constants/abilities.h"
#include "constants/battle.h"
#include "constants/moves.h"
typedef struct { int dummy; } BattleSystem;
typedef struct {
    struct { u32 status2; int ability; } battleMons[4];
    struct { u32 unk14; } selfTurnData[4];
    int battlerIdAttacker, statChangeType; u32 moveNoCur;
    int words[2], pc;
} BattleContext;
static u16 GetBattlerAbility(BattleContext *ctx, int battlerId) { return ctx->battleMons[battlerId].ability; }
static void BattleScriptIncrementPointer(BattleContext *ctx, int n) { ctx->pc += n; }
static int BattleScriptReadWord(BattleContext *ctx) { return ctx->words[ctx->pc++ - 1]; }
static int BattleSystem_GetBattlerIDBySide(BattleSystem *bs, BattleContext *ctx, int side) { (void)bs; (void)ctx; return side; }
static BOOL BattleMoveIsSoundBased(u32 move) {
    return move == MOVE_GROWL || move == MOVE_SING || move == MOVE_SUPERSONIC || move == MOVE_CONFIDE
        || move == MOVE_PARTING_SHOT || move == MOVE_BUG_BUZZ;
}
@FUNCTIONS@
// Whether CheckSubstitute on battler 1 jumps to its "a substitute is there".
static int stopped(int ability, u32 move, int type, int battler) {
    BattleSystem bs;
    BattleContext ctx = { 0 };
    ctx.battleMons[0].ability = ability;
    ctx.battleMons[battler].status2 = STATUS2_SUBSTITUTE;
    ctx.moveNoCur = move;
    ctx.statChangeType = type;
    ctx.words[0] = battler;
    ctx.words[1] = 100;
    BtlCmd_CheckSubstitute(&bs, &ctx);
    return ctx.pc > 3;
}
int main(void) {
    // A plain user is stopped; an Infiltrator's move, its effect on a hit and
    // its added effect are not.
    assert(stopped(ABILITY_NONE, MOVE_LEECH_SEED, SIDE_EFFECT_TYPE_DIRECT, 1));
    assert(!stopped(ABILITY_INFILTRATOR, MOVE_LEECH_SEED, SIDE_EFFECT_TYPE_DIRECT, 1));
    assert(!stopped(ABILITY_INFILTRATOR, MOVE_GASTRO_ACID, SIDE_EFFECT_TYPE_NONE, 1));
    assert(!stopped(ABILITY_INFILTRATOR, MOVE_THUNDERBOLT, SIDE_EFFECT_TYPE_INDIRECT, 1));
    assert(!stopped(ABILITY_INFILTRATOR, MOVE_FLING, SIDE_EFFECT_TYPE_MOVE_EFFECT, 1));
    // Not Transform, not Sky Drop, not an ability's or an item's doing, and
    // not its own substitute.
    assert(stopped(ABILITY_INFILTRATOR, MOVE_TRANSFORM, SIDE_EFFECT_TYPE_NONE, 1));
    assert(stopped(ABILITY_INFILTRATOR, MOVE_SKY_DROP, SIDE_EFFECT_TYPE_NONE, 1));
    assert(stopped(ABILITY_INFILTRATOR, MOVE_TACKLE, SIDE_EFFECT_TYPE_ABILITY, 1));
    assert(stopped(ABILITY_INFILTRATOR, MOVE_TACKLE, SIDE_EFFECT_TYPE_HELD_ITEM, 1));
    assert(stopped(ABILITY_INFILTRATOR, MOVE_SUBSTITUTE, SIDE_EFFECT_TYPE_NONE, 0));
    // A sound move's own effects go round it as its damage does, from any
    // user; not a Pokemon's own substitute, nor what is not the move's.
    assert(!stopped(ABILITY_NONE, MOVE_GROWL, SIDE_EFFECT_TYPE_DIRECT, 1));
    assert(!stopped(ABILITY_NONE, MOVE_SING, SIDE_EFFECT_TYPE_DIRECT, 1));
    assert(!stopped(ABILITY_NONE, MOVE_SUPERSONIC, SIDE_EFFECT_TYPE_DIRECT, 1));
    assert(!stopped(ABILITY_NONE, MOVE_CONFIDE, SIDE_EFFECT_TYPE_DIRECT, 1));
    assert(!stopped(ABILITY_NONE, MOVE_PARTING_SHOT, SIDE_EFFECT_TYPE_DIRECT, 1));
    assert(!stopped(ABILITY_NONE, MOVE_BUG_BUZZ, SIDE_EFFECT_TYPE_INDIRECT, 1));
    assert(stopped(ABILITY_NONE, MOVE_GROWL, SIDE_EFFECT_TYPE_DIRECT, 0));
    assert(stopped(ABILITY_NONE, MOVE_BUG_BUZZ, SIDE_EFFECT_TYPE_ABILITY, 1));
    return 0;
}
"""


class InfiltratorSubstituteTests(unittest.TestCase):
    def test_infiltrator_s_move_effects_go_round_a_substitute(self):
        # battle_script_commands.c:3716 at d0380a487, and Pokemon Central's
        # Intrapasso for which effects are the move's.
        commands = COMMANDS.read_text()
        functions = "\n".join([function(OVERLAY.read_text(), name) for name in ("InfiltratorGoesRoundSubstitute", "MoveGoesRoundSubstitute")]
                              + [function(commands, name) for name in ("SideEffectIsTheMoves", "BtlCmd_CheckSubstitute")])
        with tempfile.TemporaryDirectory(prefix="newgold-infiltrator-") as directory:
            path = Path(directory)
            (path / "test.c").write_text(INFILTRATOR_FIXTURE.replace("@FUNCTIONS@", functions))
            subprocess.run(shlex.split(os.environ.get("CC", "cc")) + [
                "-std=c99", "-Wall", "-Werror", "-Wno-unused-function", "-iquote", str(ROOT / "include"),
                str(path / "test.c"), "-o", str(path / "test")], check=True)
            subprocess.run([str(path / "test")], check=True)

    def test_a_stat_drop_asks_the_same(self):
        body = function(COMMANDS.read_text(), "BtlCmd_ChangeStatStage")
        self.assertIn("!(SideEffectIsTheMoves(ctx->statChangeType) && MoveGoesRoundSubstitute(ctx, ctx->battlerIdStatChange))", body)

    def test_the_hit_itself_goes_round_it_and_so_does_a_sound_move(self):
        # ServerHPCalc.c:42 at d0380a487: the substitute takes the damage only
        # when the attacker lacks Infiltrator and the move is not a sound move.
        body = function(OVERLAY.read_text(), "SubstituteTakesHit")
        self.assertIn("(ctx->battleMons[battlerId].status2 & STATUS2_SUBSTITUTE)", body)
        self.assertIn("!InfiltratorGoesRoundSubstitute(ctx, battlerId)", body)
        self.assertIn("!BattleMoveIsSoundBased(ctx->moveNoCur)", body)
        hp = function((ROOT / "src/battle/battle_controller_player.c").read_text(), "BattleControllerPlayer_HpCalc")
        self.assertIn("if (SubstituteTakesHit(ctx, ctx->battlerIdTarget) && ctx->damage < 0) {", hp)
        self.assertNotIn("status2 & STATUS2_SUBSTITUTE && ctx->damage < 0", hp)


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

    TARGET_FIXTURE = r"""
#include <assert.h>
#include <stdint.h>
typedef uint32_t u32;
typedef int BOOL;
enum { FALSE = 0, TRUE = 1 };
#include "constants/battle.h"
#include "constants/moves.h"
#include "constants/move_effects.h"
typedef struct { int effect; } MoveTbl;
typedef struct {
    struct { struct { int healBlockTurns; } unk88; } battleMons[4];
    int battlerIdAttacker, battlerIdTarget; u32 moveNoCur;
} BattleContext;
static MoveTbl heal = { MOVE_EFFECT_HEAL_TARGET }, other = { MOVE_EFFECT_HIT };
static const MoveTbl *BattleMoveTbl(BattleContext *ctx, u32 moveNo) { (void)ctx; return moveNo == MOVE_HEAL_PULSE ? &heal : &other; }
@FUNCTION@
static int refused(u32 move, int target, int blocked) {
    BattleContext ctx = { 0 };
    ctx.battlerIdAttacker = 0;
    ctx.battlerIdTarget = target;
    ctx.moveNoCur = move;
    ctx.battleMons[target].unk88.healBlockTurns = blocked;
    return TargetIsHealBlocked(&ctx);
}
int main(void) {
    assert(refused(MOVE_HEAL_PULSE, 1, 5));
    assert(!refused(MOVE_HEAL_PULSE, 1, 0));
    assert(refused(MOVE_POLLEN_PUFF, 2, 5));
    assert(!refused(MOVE_POLLEN_PUFF, 1, 5));
    assert(!refused(MOVE_TACKLE, 1, 5));
    return 0;
}
"""

    def test_heal_pulse_and_a_partner_s_pollen_puff_are_refused_on_a_heal_blocked_target(self):
        # BattleController_CheckHealBlock at d0380a487.
        controller = (ROOT / "src/battle/battle_controller_player.c").read_text()
        fixture = self.TARGET_FIXTURE.replace("@FUNCTION@", function(controller, "TargetIsHealBlocked"))
        with tempfile.TemporaryDirectory(prefix="newgold-heal-block-") as directory:
            path = Path(directory)
            (path / "test.c").write_text(fixture)
            subprocess.run(shlex.split(os.environ.get("CC", "cc")) + [
                "-std=c99", "-Wall", "-Werror", "-Wno-unused-function", "-iquote", str(ROOT / "include"),
                str(path / "test.c"), "-o", str(path / "test")], check=True)
            subprocess.run([str(path / "test")], check=True)
        self.assertIn("|| TargetIsHealBlocked(ctx)) {", function(controller, "ov12_0224B528"))


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
        # Taken at the target's turn in the battlers' order, and only there.
        self.assertRegex(body, r"\n        if \(battlerId == battlerIdTarget && CheckBattlerAbilityIfNotIgnored\(ctx, battlerIdAttacker, battlerIdTarget, ABILITY_ICE_SCALES\)"
                               r" == TRUE && [^\n]*CATEGORY_SPECIAL\) \{\n            modifier = QMul_RoundUp\(modifier, UQ412__0_5\);\n        \}")


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
        self.assertIn("syrupDone = OnceOnlyEntryAbilityDone(battleSystem, ctx, battlerId);", syrup)
        self.assertIn("if (!*syrupDone && ", syrup)
        self.assertIn("*syrupDone = TRUE;", syrup)


ONCE_FIXTURE = r"""
#include <assert.h>
#include <stdint.h>
typedef uint8_t u8;
enum { BATTLER_MAX = 4, PARTY_SIZE = 6 };
typedef struct { int dummy; } Party;
typedef struct { Party parties[4]; int multi; } BattleSystem;
typedef struct { u8 onceOnlyEntryAbilityDone[BATTLER_MAX][PARTY_SIZE]; u8 selectedMonIndex[4]; } BattleContext;
// BattleSystem_GetParty's rule: a battler's own party in a multi battle, its
// side's otherwise.
static Party *BattleSystem_GetParty(BattleSystem *bs, int battlerId) { return &bs->parties[bs->multi ? battlerId : battlerId & 1]; }
@FUNCTION@
int main(void) {
    BattleSystem bs = { .multi = 1 };
    BattleContext ctx = { 0 };
    // The player's and the partner's first Pokemon are two Pokemon.
    assert(OnceOnlyEntryAbilityDone(&bs, &ctx, 0) != OnceOnlyEntryAbilityDone(&bs, &ctx, 2));
    assert(OnceOnlyEntryAbilityDone(&bs, &ctx, 1) != OnceOnlyEntryAbilityDone(&bs, &ctx, 3));
    // One trainer's double battle: the same Pokemon sent to either slot.
    bs.multi = 0;
    ctx.selectedMonIndex[0] = 4;
    ctx.selectedMonIndex[2] = 4;
    assert(OnceOnlyEntryAbilityDone(&bs, &ctx, 0) == OnceOnlyEntryAbilityDone(&bs, &ctx, 2));
    ctx.selectedMonIndex[2] = 3;
    assert(OnceOnlyEntryAbilityDone(&bs, &ctx, 0) != OnceOnlyEntryAbilityDone(&bs, &ctx, 2));
    return 0;
}
"""


class OnceOnlyEntryAbilityTests(unittest.TestCase):
    def test_multi_battle_partners_remember_their_own_pokemon(self):
        # The reference keys it by SanitizeClientForTeamAccess and the party
        # slot; a flag by side and slot let the partner's first Pokemon spend
        # the player's Intrepid Sword.
        source = OVERLAY.read_text()
        with tempfile.TemporaryDirectory(prefix="newgold-once-") as directory:
            path = Path(directory)
            (path / "test.c").write_text(ONCE_FIXTURE.replace("@FUNCTION@", function(source, "OnceOnlyEntryAbilityDone")))
            subprocess.run(shlex.split(os.environ.get("CC", "cc")) + [
                "-std=c99", "-Wall", "-Werror", "-Wno-unused-function", str(path / "test.c"), "-o", str(path / "test")], check=True)
            subprocess.run([str(path / "test")], check=True)
        entry = function(source, "TryAbilityOnEntry")
        self.assertNotIn("onceOnlyEntryAbilityDone[", entry)
        self.assertEqual(entry.count("OnceOnlyEntryAbilityDone(battleSystem, ctx, battlerId)"), 3)


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

    FLING_FIXTURE = r"""
#include <assert.h>
#include <stdint.h>
typedef uint32_t u32; typedef uint16_t u16; typedef int8_t s8;
typedef int BOOL;
enum { FALSE = 0, TRUE = 1 };
#include "constants/battle.h"
#include "constants/battle_subscript.h"
typedef struct { int unused; } BattleSystem;
typedef struct { int hp; u32 status2; s8 statChanges[8]; int pp[4]; } BattleMon;
typedef struct {
    BattleMon battleMons[4];
    struct { u32 unk14; } selfTurnData[4];
    int battlerIdAttacker, battlerIdStatChange, flingScript, flingData, infiltrator, copied;
    u16 moveTemp;
    u16 recycleItem[4];
    int kept[4];
    int ate[4];
} BattleContext;
static BOOL BattleItemIsBerry(u16 item) { return item == 149; }
static void RememberBerryEaten(BattleSystem *bs, BattleContext *ctx, int battlerId) { (void)bs; ctx->ate[battlerId] = 1; }
static BOOL InfiltratorGoesRoundSubstitute(BattleContext *ctx, int battlerId) { (void)battlerId; return ctx->infiltrator; }
static void CudChewKeepsBerry(BattleContext *ctx, int eater, u16 item) { ctx->kept[eater] = item; }
static int BattleMon_GetMoveIndex(BattleMon *mon, u16 move) { (void)mon; return move - 100; }
static void BattleMon_AddVar(BattleMon *mon, u32 varId, int data) { mon->pp[varId - BMON_DATA_CUR_PP_1] += data; }
static void CopyBattleMonToPartyMon(BattleSystem *bs, BattleContext *ctx, int battlerId) { (void)bs; ctx->copied = battlerId + 1; }
@FUNCTION@
static BattleContext ctx;
static int kept(int flingScript, int hp, u32 status2, int infiltrator) {
    BattleSystem bs;
    ctx = (BattleContext){ 0 };
    ctx.battlerIdAttacker = 0;
    ctx.battlerIdStatChange = 1;
    ctx.flingScript = flingScript;
    ctx.battleMons[1].hp = hp;
    ctx.battleMons[1].status2 = status2;
    ctx.battleMons[1].statChanges[2] = 4;
    ctx.battleMons[1].statChanges[5] = 9;
    ctx.infiltrator = infiltrator;
    ctx.recycleItem[0] = 149;
    ctx.moveTemp = 102;
    ctx.flingData = 10;
    FlungItemLands(&bs, &ctx);
    return ctx.kept[1];
}
int main(void) {
    assert(kept(198, 50, 0, 0) == 149);
    // Belch counts the landed Berry for the Pokemon it landed on, not the thrower.
    assert(ctx.ate[1] && !ctx.ate[0]);
    assert(kept(0, 50, 0, 0) == 0);
    assert(!ctx.ate[1]);
    assert(kept(198, 0, 0, 0) == 0);
    assert(kept(198, 50, STATUS2_SUBSTITUTE, 0) == 0);
    assert(kept(198, 50, STATUS2_SUBSTITUTE, 1) == 149);
    // A Leppa Berry restores the chosen move's PP when it lands, not before.
    kept(BATTLE_SUBSCRIPT_HELD_ITEM_PP_RESTORE, 50, 0, 0);
    assert(ctx.battleMons[1].pp[2] == 10 && ctx.copied == 2);
    kept(BATTLE_SUBSCRIPT_HELD_ITEM_PP_RESTORE, 50, STATUS2_SUBSTITUTE, 0);
    assert(ctx.battleMons[1].pp[2] == 0);
    // A White Herb resets the lowered stats when it lands, and only those.
    kept(BATTLE_SUBSCRIPT_HELD_ITEM_STATDOWN_RESTORE, 50, 0, 0);
    assert(ctx.battleMons[1].statChanges[2] == 6 && ctx.battleMons[1].statChanges[5] == 9 && ctx.battleMons[1].statChanges[0] == 6);
    return 0;
}
"""

    def test_a_flung_berry_is_kept_by_the_one_it_hit(self):
        # Pokemon Central, Ruminante: a Berry flung at it counts when its
        # effect goes off; that is known once the hit is. So is the PP a
        # Leppa Berry gives back and the stats a White Herb puts right.
        source = OVERLAY.read_text()
        fixture = self.FLING_FIXTURE.replace("@FUNCTION@", function(source, "FlungItemLands"))
        with tempfile.TemporaryDirectory(prefix="newgold-cud-chew-") as directory:
            path = Path(directory)
            (path / "test.c").write_text(fixture)
            subprocess.run(shlex.split(os.environ.get("CC", "cc")) + [
                "-std=c99", "-Wall", "-Werror", "-Wno-unused-function", "-iquote", str(ROOT / "include"),
                str(path / "test.c"), "-o", str(path / "test")], check=True)
            subprocess.run([str(path / "test")], check=True)
        # Asked by the step that runs the flung item's script, for a move that
        # hit, just before the move's other effects are rolled.
        step = function(source, "TryFlungItemEffect")
        self.assertIn("(ctx->moveStatusFlag & MOVE_STATUS_FAIL)", step)
        self.assertLess(step.index("FlungItemLands(battleSystem, ctx);"), step.index("BATTLE_SUBSCRIPT_FLING"))
        chains = function((ROOT / "src/battle/battle_controller_player.c").read_text(), "ov12_0224CAA4")
        flings = [i for i in range(len(chains)) if chains.startswith("TryFlungItemEffect(battleSystem, ctx)", i)]
        rolls = [i for i in range(len(chains)) if chains.startswith("ov12_02250490(battleSystem, ctx, &script)", i)]
        self.assertEqual(len(flings), 2)
        self.assertTrue(all(fling < roll for fling, roll in zip(flings, rolls)))
        fling = function(source, "TryFling")
        self.assertNotIn("BattleMon_AddVar", fling)
        self.assertNotIn("statChanges[stat] = 6", fling)

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


class EndOfTurnAttackerTests(unittest.TestCase):
    """The scripts of the end of the turn ask the attacker -- Mold Breaker's
    question in the status subscripts an Orb runs, Infiltrator's and a sound
    move's in CheckSubstitute -- and nothing moves then: the Pokemon whose
    condition is running stands in, instead of whoever moved last."""

    def test_each_pokemon_s_conditions_run_as_its_own(self):
        body = function((ROOT / "src/battle/battle_controller_player.c").read_text(), "BattleControllerPlayer_UpdateMonCondition")
        loop = body[body.index("while (ctx->updateMonConditionData < maxBattlers) {"):]
        self.assertLess(loop.index("ctx->battlerIdAttacker = battlerId;"), loop.index("switch (ctx->stateUpdateMonCondition) {"))
        self.assertGreater(loop.index("ctx->battlerIdAttacker = battlerId;"), loop.index("battlerId = ctx->turnOrder[ctx->updateMonConditionData];"))

DRAGGED_IN_FIXTURE = r"""
#include <assert.h>
typedef int BOOL;
typedef struct { struct { int hitCount; } battleMons[4]; struct { int physicalDamage, specialDamage; } selfTurnData[4]; } BattleContext;
@FUNCTION@
int main(void) {
    BattleContext ctx = { 0 };
    ctx.selfTurnData[1].physicalDamage = -30;
    assert(Battler_CameInAfterTheHit(&ctx, 1));          // damage on record, no hit: dragged in
    ctx.battleMons[1].hitCount = 1;
    assert(!Battler_CameInAfterTheHit(&ctx, 1));         // it took the hit
    ctx.battleMons[2].hitCount = 0;
    assert(!Battler_CameInAfterTheHit(&ctx, 2));         // nothing on record: not hit at all
    ctx.selfTurnData[3].specialDamage = -5;
    assert(Battler_CameInAfterTheHit(&ctx, 3));
    return 0;
}
"""


class DraggedInTests(unittest.TestCase):
    """A Pokemon brought into a slot after the hit on record there -- by a Red
    Card, an Eject Button, or Dragon Tail's and Circle Throw's drag -- did not
    take that hit, and answers none of it: not with its abilities, its held
    item or a flinch, as c172085f1 already had it for the Red Card and the
    Eject Button. The Pokemon that was hit answers it before it is dragged."""

    def test_the_slot_s_hit_is_not_the_newcomer_s(self):
        overlay = OVERLAY.read_text()
        with tempfile.TemporaryDirectory(prefix="newgold-dragged-in-") as directory:
            path = Path(directory)
            (path / "test.c").write_text(DRAGGED_IN_FIXTURE.replace("@FUNCTION@", function(overlay, "Battler_CameInAfterTheHit")))
            subprocess.run(shlex.split(os.environ.get("CC", "cc")) + [
                "-std=c99", "-Wall", "-Werror", str(path / "test.c"), "-o", str(path / "test")], check=True)
            subprocess.run([str(path / "test")], check=True)
        guard = "if (Battler_CameInAfterTheHit(ctx, ctx->battlerIdTarget) == TRUE) {\n        return ret;\n    }"
        for name in ("CheckAbilityEffectOnHit", "CheckItemEffectOnHit"):
            body = function(overlay, name)
            self.assertIn(guard, body, name)
            self.assertLess(body.index(guard), body.index("switch ("), name)
        flinch = function((ROOT / "src/battle/battle_controller_player.c").read_text(), "TryItemFlinch")
        self.assertLess(flinch.index("!Battler_CameInAfterTheHit(ctx, ctx->battlerIdTarget)"), flinch.index("BattleSystem_Random"))

    def test_dragon_tail_drags_once_the_hit_is_answered(self):
        """In the games the Pokemon Dragon Tail or Circle Throw hits answers
        the hit -- Rough Skin, Justified, a Rocky Helmet -- and is dragged out
        at the end of the move. The hit's side effect marks it instead of
        dragging it, and the move's end drags it in the engine's step for the
        move's additional effects, after the recoil and before Magician and
        the switching items (Pokemon Central, Cartelrosso: a holder dragged
        out uses no card)."""
        dispatch = function(OVERLAY.read_text(), "ov12_02250490")
        self.assertIn("if (ret == TRUE && *out == BATTLE_SUBSCRIPT_FORCE_TARGET_TO_SWITCH_OR_FLEE\n"
                      "        && BattleMoveTbl(ctx, ctx->moveNoCur)->category != CATEGORY_STATUS) {\n"
                      "        ctx->selfTurnData[ctx->battlerIdStatChange].dragPending = TRUE;\n"
                      "        ret = FALSE;", dispatch)
        # After Parental Bond's hold-back, so only the last strike drags.
        self.assertLess(dispatch.index("ParentalBond_StrikeToCome(ctx)"), dispatch.index("dragPending = TRUE"))
        controller = (ROOT / "src/battle/battle_controller_player.c").read_text()
        effects = function(controller, "TryAdditionalMoveEffect")
        drag = effects.index("RunPostMoveScript(ctx, BATTLE_SUBSCRIPT_FORCE_TARGET_TO_SWITCH_OR_FLEE);")
        self.assertLess(effects.index("ctx->selfTurnData[target].dragPending = FALSE;"), drag)
        # Not once the user has fainted to what the hit set off (Codadrago).
        self.assertIn("if (!ctx->battleMons[target].hp || !ctx->battleMons[ctx->battlerIdAttacker].hp) {\n"
                      "            return FALSE;", effects[:drag])
        end = function(controller, "ov12_0224E1BC")
        step = end.index("TryAdditionalMoveEffect(ctx)")
        self.assertLess(end.index("TryRecoil(ctx)"), step)
        self.assertLess(step, end.index("TryMagician("))
        self.assertLess(step, end.index("CheckSwitchItemOnHit("))

    def test_a_pokemon_being_dragged_out_does_not_answer_with_three_abilities(self):
        """Pokemon Central (Codadrago): the target's Pickpocket, Color Change
        and Anger Shell do not act when the move drags it out -- Emergency
        Exit and Wimp Out go with the slot's clearing. Kept in by Ingrain or
        with nobody to come in, it answers as usual. Pickpocket is a
        post-move step, after the drag, and passes over a Pokemon that came in
        after the hit."""
        overlay = OVERLAY.read_text()
        will = function(overlay, "Battler_WillBeDraggedOut")
        for part in ("!ctx->selfTurnData[battlerId].dragPending", "MOVE_EFFECT_FLAG_INGRAIN",
                     "return CanSwitchMon(battleSystem, ctx, battlerId);", "return WhirlwindCheck(battleSystem, ctx);"):
            self.assertIn(part, will)
        hit = function(overlay, "CheckAbilityEffectOnHit")
        for ability in ("ABILITY_COLOR_CHANGE", "ABILITY_ANGER_SHELL"):
            case = hit[hit.index(f"case {ability}:"):]
            case = case[:case.index("break;")]
            self.assertIn("!Battler_WillBeDraggedOut(battleSystem, ctx, ctx->battlerIdTarget)", case, ability)
        self.assertIn("|| Battler_CameInAfterTheHit(ctx, battlerId)", function(overlay, "PickpocketLifts"))
        end = function((ROOT / "src/battle/battle_controller_player.c").read_text(), "ov12_0224E1BC")
        self.assertLess(end.index("TryAdditionalMoveEffect(ctx)"), end.index("TryPickpocket("))

    def test_a_user_its_item_will_fell_drags_nothing(self):
        # Pokemon Central (Codadrago): a user a Rocky Helmet fells drags
        # nothing, so the target's Color Change and Anger Shell answer the hit.
        from test_ability_interactions import run_c
        overlay = OVERLAY.read_text()
        functions = function(overlay, "DamageDivide") + function(overlay, "Battler_WillBeDraggedOut")
        run_c(DRAG_FIXTURE.replace("@FUNCTIONS@", functions))

DRAG_FIXTURE = r"""
#include <assert.h>
#include <stdint.h>
typedef uint8_t u8;
typedef uint16_t u16;
typedef uint32_t u32;
typedef int BOOL;
enum { FALSE = 0, TRUE = 1 };
#include "constants/abilities.h"
#include "constants/battle.h"
#include "constants/items.h"
typedef struct { int unused; } BattleSystem;
typedef struct { int hp, maxHp; u32 moveEffectFlags; int ability, holdEffect, modifier; } Mon;
typedef struct { u32 dragPending : 1; int physicalDamage; } SelfTurnData;
typedef struct { Mon battleMons[4]; SelfTurnData selfTurnData[4]; int battlerIdAttacker; u32 moveNoCur; } BattleContext;
static BOOL contact;
static int GetBattlerHeldItemEffect(BattleContext *ctx, int battlerId) { return ctx->battleMons[battlerId].holdEffect; }
static int GetHeldItemModifier(BattleContext *ctx, int battlerId, int flag) { (void)flag; return ctx->battleMons[battlerId].modifier; }
static int GetBattlerAbility(BattleContext *ctx, int battlerId) { return ctx->battleMons[battlerId].ability; }
static BOOL BattleMoveMakesContact(BattleContext *ctx, u32 moveNo) { (void)ctx; (void)moveNo; return contact; }
static u32 BattleSystem_GetBattleType(BattleSystem *bs) { (void)bs; return BATTLE_TYPE_TRAINER; }
static BOOL CanSwitchMon(BattleSystem *bs, BattleContext *ctx, int battlerId) { (void)bs; (void)ctx; (void)battlerId; return TRUE; }
static BOOL WhirlwindCheck(BattleSystem *bs, BattleContext *ctx) { (void)bs; (void)ctx; return TRUE; }
static BOOL Battler_HeldByCommander(BattleContext *ctx, int battlerId) { (void)ctx; (void)battlerId; return FALSE; }
@FUNCTIONS@
static BattleSystem bs;
static BattleContext ctx;
static void reset(void) {
    // The user 0, at 60 of 120 HP, Dragon Tails 1, which holds a Rocky Helmet.
    ctx = (BattleContext){ 0 };
    ctx.battleMons[0] = (Mon){ 60, 120, 0, ABILITY_NONE, HOLD_EFFECT_NONE, 0 };
    ctx.battleMons[1] = (Mon){ 50, 100, 0, ABILITY_COLOR_CHANGE, HOLD_EFFECT_DAMAGE_ON_CONTACT, 6 };
    ctx.selfTurnData[1].dragPending = TRUE; ctx.selfTurnData[1].physicalDamage = 30;
    contact = TRUE;
}
int main(void) {
    reset(); assert(Battler_WillBeDraggedOut(&bs, &ctx, 1));
    // The helmet takes 20: at 20 HP the user faints and the target stays.
    reset(); ctx.battleMons[0].hp = 20; assert(!Battler_WillBeDraggedOut(&bs, &ctx, 1));
    reset(); ctx.battleMons[0].hp = 21; assert(Battler_WillBeDraggedOut(&bs, &ctx, 1));
    reset(); ctx.battleMons[0].hp = 20; ctx.battleMons[0].ability = ABILITY_MAGIC_GUARD; assert(Battler_WillBeDraggedOut(&bs, &ctx, 1));
    reset(); ctx.battleMons[0].hp = 20; contact = FALSE; assert(Battler_WillBeDraggedOut(&bs, &ctx, 1));
    // A Jaboca Berry on a physical hit, likewise: an eighth, 15.
    reset(); ctx.battleMons[0].hp = 15; ctx.battleMons[1].holdEffect = HOLD_EFFECT_RECOIL_PHYSICAL; ctx.battleMons[1].modifier = 8;
    assert(!Battler_WillBeDraggedOut(&bs, &ctx, 1));
    reset(); ctx.battleMons[0].hp = 16; ctx.battleMons[1].holdEffect = HOLD_EFFECT_RECOIL_PHYSICAL; ctx.battleMons[1].modifier = 8;
    assert(Battler_WillBeDraggedOut(&bs, &ctx, 1));
    reset(); ctx.battleMons[0].hp = 15; ctx.battleMons[1].holdEffect = HOLD_EFFECT_RECOIL_PHYSICAL; ctx.battleMons[1].modifier = 8;
    ctx.selfTurnData[1].physicalDamage = 0; assert(Battler_WillBeDraggedOut(&bs, &ctx, 1));
    // Ingrain, or no drag pending.
    reset(); ctx.battleMons[1].moveEffectFlags = MOVE_EFFECT_FLAG_INGRAIN; assert(!Battler_WillBeDraggedOut(&bs, &ctx, 1));
    reset(); ctx.selfTurnData[1].dragPending = FALSE; assert(!Battler_WillBeDraggedOut(&bs, &ctx, 1));
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
        knockout = hit[hit.index("u8 *bondSpent = OnceOnlyEntryAbilityDone(battleSystem, ctx, ctx->battlerIdAttacker);"):]
        self.assertLess(knockout.index("BattlerBattleBondBoosts(ctx, ctx->battlerIdAttacker, *bondSpent) == TRUE"),
                        knockout.index("*bondSpent = TRUE;"))
        self.assertIn("*script = BATTLE_SUBSCRIPT_BATTLE_BOND;", knockout)
        script = subscript("BattleBond")
        for stat in ("ATTACK", "SP_ATTACK", "SPEED"):
            self.assertIn(f"MOVE_SUBSCRIPT_PTR_{stat}_UP_1_STAGE\n    Call BATTLE_SUBSCRIPT_UPDATE_STAT_STAGE", script)


class PsychUpTests(unittest.TestCase):
    def test_focus_energy_is_copied_not_added(self):
        # Pokemon Central, Psicamisu: from Generation VI the user takes the
        # target's critical-hit rise, and loses its own if the target has none.
        body = function(COMMANDS.read_text(), "BtlCmd_CopyStatStages")
        self.assertIn("status2 & ~STATUS2_FOCUS_ENERGY)", body)
        self.assertNotIn("status2 |=", body)


class Conversion2Tests(unittest.TestCase):
    def test_it_reads_the_move_its_target_last_used(self):
        # Pokemon Central, Conversione2, from Generation V: the target's last
        # move, not the one that last hit the user; none or Struggle fails.
        body = function(COMMANDS.read_text(), "BtlCmd_TryConversion2")
        self.assertIn("ctx->conversion2Move[target] == MOVE_NONE || ctx->conversion2Move[target] == MOVE_STRUGGLE", body)
        self.assertIn("ctx->conversion2Type[target]", body)
        self.assertIn("type3 = TYPE_NONE", body)
        record = function((ROOT / "src/battle/battle_controller_player.c").read_text(), "ov12_0224DD74")
        self.assertIn("ctx->conversion2Move[ctx->battlerIdAttacker] = ctx->moveNoCur;", record)
        self.assertNotIn("conversion2Move[ctx->battlerIdTarget]", record)


class SleepTalkMultiStrikeTests(unittest.TestCase):
    def test_a_move_sleep_talk_calls_strikes_every_time(self):
        # Pokemon Central, Mossa multicolpo: falling asleep partway stops a
        # multi-strike move, but not one used through Sleep Talk.
        self.assertIn("(ctx->battleMons[ctx->battlerIdAttacker].status & STATUS_SLEEP) && ctx->moveNoTemp != MOVE_SLEEP_TALK",
                      function(OVERLAY.read_text(), "MultiHit_StoppedBySleep"))
        loop = function((ROOT / "src/battle/battle_controller_player.c").read_text(), "ov12_0224CF14")
        self.assertEqual(loop.count("MultiHit_StoppedBySleep(ctx)"), 3)
        self.assertNotIn("STATUS_SLEEP", loop)
        # Parental Bond's wait for its second strike asks the same.
        self.assertIn("!MultiHit_StoppedBySleep(ctx)", function(OVERLAY.read_text(), "ParentalBond_StrikeToCome"))


class TypeChangeTests(unittest.TestCase):
    def test_a_type_change_takes_an_added_type_away(self):
        # Pokemon Central (Inondazione, Magipolvere): Soak and Magic Powder
        # leave the target purely Water or Psychic, ending Trick-or-Treat and
        # Forest's Curse; Camouflage and Conversion set the user's type the
        # same way. Burn Up and Double Shock only take a type away.
        commands = COMMANDS.read_text()
        self.assertIn("ctx->battleMons[battlerId].type3 = TYPE_NONE;", function(commands, "MakeBattlerPureType"))
        self.assertNotIn("type3", function(commands, "RemoveBattlerType"))
        self.assertIn("ctx->battleMons[ctx->battlerIdAttacker].type3 = TYPE_NONE;", function(commands, "BtlCmd_TryCamouflage"))
        self.assertIn("mon->type3 = TYPE_NONE;", function(commands, "BtlCmd_TryConversion"))

    def test_burn_up_leaves_a_pure_fire_type_typeless(self):
        # Pokemon Central (Ultima Fiamma, Doppiolampo): typeless, which is
        # TYPE_MYSTERY here, the one type the chart has no row for; Normal
        # would be immune to Ghost and weak to Fighting.
        body = function(COMMANDS.read_text(), "RemoveBattlerType")
        self.assertEqual(body.count("= TYPE_MYSTERY;"), 2)
        self.assertNotIn("TYPE_NORMAL", body)
        chart = OVERLAY.read_text()
        chart = chart[chart.index("sTypeEffectiveness[][3] = {"):]
        self.assertNotIn("TYPE_MYSTERY", chart[:chart.index("};")])

    def test_conversion_takes_its_first_move_s_type(self):
        # Pokemon Central, Conversione, from Generation VI: the type of the
        # move in the first slot, failing when the user has it already, an
        # added type included; no longer a random move's.
        body = function(COMMANDS.read_text(), "BtlCmd_TryConversion")
        self.assertIn("moveType = BattleMoveTbl(ctx, mon->moves[0])->type;", body)
        self.assertIn("|| mon->type3 == moveType) {", body)
        self.assertNotIn("BattleSystem_Random", body)

    def test_soak_and_magic_powder_leave_arceus_and_silvally_alone(self):
        # Pokemon Central (Inondazione): they fail against Arceus and
        # Silvally, not against a Pokemon wearing their looks by Transform or
        # Imposter; past the substitute, before the move is shown.
        for name in ("subscript_0351_ChangeTargetToWaterType.s", "subscript_0323_ChangeTargetToPsychicType.s"):
            script = (ROOT / "files/battledata/script/subscript" / name).read_text()
            refusal = script[script.index("_PAST_SUBSTITUTE:"):script.index("_CHANGE_TYPE:")]
            self.assertIn("BATTLER_CATEGORY_DEFENDER, BMON_DATA_STATUS2, STATUS2_TRANSFORM, _PURE_TYPE", refusal, name)
            for ability in ("ABILITY_MULTITYPE", "ABILITY_RKS_SYSTEM"):
                self.assertIn(f"BATTLER_CATEGORY_DEFENDER, BMON_DATA_ABILITY, {ability}, _FAILED", refusal, name)
            self.assertLess(script.index("_CHANGE_TYPE:"), script.index("Call BATTLE_SUBSCRIPT_ATTACK_MESSAGE_AND_ANIMATION"), name)
            self.assertIn("_FAILED:\n    UpdateVar OPCODE_FLAG_ON, BSCRIPT_VAR_MOVE_STATUS_FLAGS, MOVE_STATUS_FAILED\n    End", script, name)

    def test_soak_and_magic_powder_fail_on_a_target_of_their_type(self):
        # Pokemon Central (Inondazione, Magipolvere): a target purely Water,
        # or Psychic, already is not changed; one with a type added is.
        for name, type_ in (("subscript_0351_ChangeTargetToWaterType.s", "TYPE_WATER"),
                            ("subscript_0323_ChangeTargetToPsychicType.s", "TYPE_PSYCHIC")):
            script = (ROOT / "files/battledata/script/subscript" / name).read_text()
            check = script[script.index("_PURE_TYPE:"):script.index("_CHANGE_TYPE:")]
            self.assertIn(f"CompareMonDataToValue OPCODE_NEQ, BATTLER_CATEGORY_DEFENDER, BMON_DATA_TYPE_1, {type_}, _CHANGE_TYPE\n"
                          f"    CompareMonDataToValue OPCODE_NEQ, BATTLER_CATEGORY_DEFENDER, BMON_DATA_TYPE_2, {type_}, _CHANGE_TYPE\n"
                          "    CompareMonDataToValue OPCODE_EQU, BATTLER_CATEGORY_DEFENDER, BMON_DATA_TYPE_3, TYPE_NONE, _FAILED\n", check, name)

    def test_the_target_is_the_one_named(self):
        # "{0} transformed into the Psychic type!" names the target, as
        # Soak's line does; the reference's names the message battler, left
        # over from whatever set it last.
        for name, row in (("subscript_0351_ChangeTargetToWaterType.s", "01330"),
                          ("subscript_0323_ChangeTargetToPsychicType.s", "01585")):
            script = (ROOT / "files/battledata/script/subscript" / name).read_text()
            self.assertIn(f"PrintMessage msg_0197_{row}, TAG_NICKNAME, BATTLER_CATEGORY_DEFENDER\n", script, name)

    def test_arceus_and_silvally_cannot_change_their_own_type(self):
        # Pokemon Central (Sistema Primevo): no move changes the type of a
        # Pokemon with RKS System, as none does one with Multitype.
        from test_hold_effects import run_c
        commands = COMMANDS.read_text()
        for name in ("BtlCmd_TryConversion", "BtlCmd_TryConversion2", "BtlCmd_TryCamouflage"):
            self.assertIn("BattlerTypeIsItsAbilitys(ctx, ctx->battlerIdAttacker)", function(commands, name), name)
            self.assertNotIn("ABILITY_MULTITYPE", function(commands, name), name)
        run_c(r"""
#include <assert.h>
#include "constants/abilities.h"
typedef int BOOL;
typedef struct { int ability; } BattleContext;
static int GetBattlerAbility(BattleContext *ctx, int battlerId) { (void)battlerId; return ctx->ability; }
""" + function(commands, "BattlerTypeIsItsAbilitys") + r"""
int main(void) {
    BattleContext ctx = { ABILITY_MULTITYPE };
    assert(BattlerTypeIsItsAbilitys(&ctx, 0));
    ctx.ability = ABILITY_RKS_SYSTEM;
    assert(BattlerTypeIsItsAbilitys(&ctx, 0));
    ctx.ability = ABILITY_PROTEAN;
    assert(!BattlerTypeIsItsAbilitys(&ctx, 0));
    return 0;
}
""")


class PaybackTests(unittest.TestCase):
    def test_it_does_not_double_against_what_came_in_this_turn(self):
        # Pokemon Central, Rivincita: from Generation V a Pokemon that switched
        # in is no longer one that acted. What comes in during a turn is marked
        # so, and the mark goes with the turn's data as the next one begins.
        calc = function(OVERLAY.read_text(), "CalcMoveDamage")
        self.assertIn("moveNo == MOVE_PAYBACK && ov12_0225561C(ctx, battlerIdTarget) == TRUE && !ctx->turnData[battlerIdTarget].switchedIn", calc)
        self.assertIn("ctx->turnData[battlerId].switchedIn = TRUE;", function(OVERLAY.read_text(), "InitSwitchWork"))
        self.assertIn("MI_CpuClearFast((u32 *)&ctx->turnData[battlerId], sizeof(TurnData));", function(OVERLAY.read_text(), "ov12_02251710"))



class GhostTypeTests(unittest.TestCase):
    """From the sixth generation nothing holds a Ghost-type on the field, and
    it gets away from a wild battle whatever its Speed (Pokemon Central,
    Spettro (tipo); Malosguardo). HeartGold and the reference hold it."""

    def test_no_hold_keeps_it_in(self):
        overlay = OVERLAY.read_text()
        ghost = function(overlay, "Battler_HasGhostType")
        for part in ("BMON_DATA_TYPE_1", "BMON_DATA_TYPE_2", "type3"):
            self.assertIn(part, ghost)
        escape = function(overlay, "CantEscape")
        self.assertLess(escape.index("|| Battler_HasGhostType(ctx, battlerId)) {\n        return FALSE;"),
                        escape.index("ABILITY_SHADOW_TAG"))
        switch = function(overlay, "BattlerCanSwitch")
        # Commander's hold, and Sky Drop's beside it, still come first.
        self.assertLess(switch.index("Battler_KeptOnField(ctx, battlerId)"), switch.index("Battler_HasGhostType"))
        self.assertLess(switch.index("== HOLD_EFFECT_SWITCH || Battler_HasGhostType(ctx, battlerId)) {\n        return FALSE;"),
                        switch.index("STATUS2_MEAN_LOOK"))
        run = function(overlay, "BattleTryRun")
        self.assertLess(run.index("} else if (Battler_HasGhostType(ctx, battlerId)) {\n        ret = TRUE;"),
                        run.index("ctx->battleMons[battlerId].speed <"))

    def test_a_wild_ghost_flees_and_the_ai_switches_it(self):
        controller = (ROOT / "src/battle/battle_controller_player.c").read_text()
        self.assertIn("(STATUS2_BIND | STATUS2_MEAN_LOOK)) && !Battler_HasGhostType(ctx, ctx->battlerIdAttacker)",
                      function(controller, "BattleControllerPlayer_RunInput"))
        ai = function((ROOT / "src/battle/trainer_ai_0222036C.c").read_text(), "ov10_022203A4")
        self.assertIn("|| (!Battler_HasGhostType(ctx, battlerId)\n            && ((ctx->battleMons[battlerId].status2 & (STATUS2_BIND | STATUS2_MEAN_LOOK))", ai)

    def test_mean_look_block_and_spider_web_fail_on_it(self):
        script = subscript("MeanLook")
        for part in ("BMON_DATA_TYPE_1", "BMON_DATA_TYPE_2", "BMON_DATA_TYPE_3"):
            self.assertLess(script.index(f"CompareMonDataToValue OPCODE_EQU, BATTLER_CATEGORY_DEFENDER, {part}, TYPE_GHOST, _048"),
                            script.index("UpdateMonData OPCODE_FLAG_ON, BATTLER_CATEGORY_DEFENDER, BMON_DATA_STATUS2, STATUS2_MEAN_LOOK"))


class FormHeldItemTests(unittest.TestCase):
    """hg-engine keeps a form as its base species and a form number, so its
    Leek, Thick Club and Light Ball answer every form of the species they are
    for. Here a form is a species of its own (Galarian Farfetch'd, Alolan
    Marowak, the Pikachu forms) and asks as its base, SpeciesToDexSpecies."""

    def test_the_leek_thick_club_and_light_ball_take_forms(self):
        overlay = OVERLAY.read_text()
        self.assertIn("species = SpeciesToDexSpecies(ctx->battleMons[battlerIdAttacker].species);",
                      function(overlay, "TryCriticalHit"))
        damage = function(overlay, "CalcMoveDamage")
        self.assertIn("calcAttacker.item == HOLD_EFFECT_PIKA_SPATK_UP && SpeciesToDexSpecies(calcAttacker.species) == SPECIES_PIKACHU", damage)
        self.assertIn("calcAttacker.item == HOLD_EFFECT_CUBONE_ATK_UP && (SpeciesToDexSpecies(calcAttacker.species) == SPECIES_CUBONE"
                      " || SpeciesToDexSpecies(calcAttacker.species) == SPECIES_MAROWAK)", damage)
        # And the forms map to them.
        pokedex = (ROOT / "src/pokedex.c").read_text()
        for form, base in (("FARFETCHD_GALARIAN", "FARFETCHD"), ("MAROWAK_ALOLAN", "MAROWAK"), ("PIKACHU_LIBRE", "PIKACHU")):
            self.assertIn(f"[SPECIES_{form} - NATIONAL_DEX_COUNT - 1] = SPECIES_{base},", pokedex)


if __name__ == "__main__":
    unittest.main()
