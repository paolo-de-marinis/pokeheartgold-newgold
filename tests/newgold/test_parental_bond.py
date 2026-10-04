#!/usr/bin/env python3
"""Parental Bond: the holder's damaging moves strike twice, the second strike
a quarter of the first (IsValidParentalBondMove, other_battle_calculators.c at
d0380a487; Pokemon Central, Amorefiliale)."""

import os
import re
import shlex
import struct
import subprocess
import sys
import tempfile
import unittest
from pathlib import Path

from test_level_cap import ROOT
from test_repels import function

OVERLAY = ROOT / "src/battle/overlay_12_0224E4FC.c"
COMMANDS = ROOT / "src/battle/battle_command.c"
CONTROLLER = ROOT / "src/battle/battle_controller_player.c"
EFFECTS = ROOT / "files/battledata/script/effect_script"
REFERENCE = Path(os.environ.get(
    "NEWGOLD_REFERENCE", "/home/paolo/Porting HGSS/hg-engine-newgold-reference"))

FIXTURE = r"""
#include <assert.h>
#include <stdint.h>
typedef uint16_t u16;
typedef uint32_t u32;
typedef uint8_t u8;
typedef int BOOL;
enum { FALSE = 0, TRUE = 1 };
#define NELEMS(a) (sizeof(a) / sizeof((a)[0]))
#include "constants/abilities.h"
#include "constants/battle.h"
#include "constants/moves.h"
#include "constants/move_effects.h"
typedef struct { int doubles; } BattleSystem;
typedef struct { u8 category, range; u16 effect; } MoveTbl;
typedef struct { int hp, ability; u32 status; } Mon;
typedef struct { u32 parentalBond : 1; } SelfTurnData;
typedef struct {
    Mon battleMons[4];
    SelfTurnData selfTurnData[4];
    int battlerIdAttacker, battlerIdTarget, battlerIdFainted, moveNoCur, moveNoTemp, damage;
    u32 moveStatusFlag, unk_2184, checkMultiHit;
    int unk_38;
    u8 multiHitCount, multiHitCountTemp;
    MoveTbl move;
} BattleContext;
static int GetBattlerAbility(BattleContext *ctx, int battlerId) { return ctx->battleMons[battlerId].ability; }
static const MoveTbl *BattleMoveTbl(BattleContext *ctx, u32 moveNo) { (void)moveNo; return &ctx->move; }
static int BattleSystem_GetMaxBattlers(BattleSystem *bs) { return bs->doubles ? 4 : 2; }
static int BattleSystem_GetFieldSide(BattleSystem *bs, int battlerId) { (void)bs; return battlerId & 1; }
@FUNCTIONS@
static BattleSystem bs;
static BattleContext ctx;
static void setup(int doubles, int move, int category, int range) {
    BattleContext blank = { 0 };
    ctx = blank;
    bs.doubles = doubles;
    for (int i = 0; i < 4; i++) {
        ctx.battleMons[i].hp = 100;
    }
    ctx.battleMons[0].ability = ABILITY_PARENTAL_BOND;
    ctx.battlerIdFainted = BATTLER_NONE;
    ctx.battlerIdTarget = 1;
    ctx.moveNoCur = move;
    ctx.move.category = category;
    ctx.move.range = range;
}
static int strikes(void) {
    TryStartParentalBond(&bs, &ctx);
    return ctx.selfTurnData[0].parentalBond ? ctx.multiHitCountTemp : 1;
}
int main(void) {
    // A damaging move strikes twice, as a multi-strike move with one accuracy
    // check, one PP and one message.
    setup(0, MOVE_TACKLE, CATEGORY_PHYSICAL, RANGE_SINGLE_TARGET);
    assert(strikes() == 2);
    assert(ctx.multiHitCount == 2 && ctx.checkMultiHit == MULTIHIT_MULTI_HIT_MOVE);
    assert(ctx.unk_38 == AFTER_MOVE_MESSAGE_MULTI_HIT);
    assert(ParentalBond_IsFirstStrike(&ctx) && !ParentalBond_IsSecondStrike(&ctx));
    assert(ParentalBond_StrikeToCome(&ctx));
    ctx.battlerIdFainted = 1;
    assert(!ParentalBond_StrikeToCome(&ctx));
    ctx.battlerIdFainted = BATTLER_NONE;
    // Put to sleep by the first strike, it stops; asleep through Sleep Talk,
    // it goes on.
    ctx.battleMons[0].status = STATUS_SLEEP;
    ctx.moveNoTemp = MOVE_TACKLE;
    assert(!ParentalBond_StrikeToCome(&ctx));
    ctx.moveNoTemp = MOVE_SLEEP_TALK;
    assert(ParentalBond_StrikeToCome(&ctx));
    ctx.battleMons[0].status = 0;
    ctx.multiHitCount = 1;
    assert(ParentalBond_IsSecondStrike(&ctx) && !ParentalBond_StrikeToCome(&ctx));
    // Seismic Toss and the like do too; a status move, another ability, a
    // multi-strike move and the single-strike list do not.
    setup(0, MOVE_SEISMIC_TOSS, CATEGORY_PHYSICAL, RANGE_SINGLE_TARGET);
    assert(strikes() == 2);
    setup(0, MOVE_SWORDS_DANCE, CATEGORY_STATUS, RANGE_USER);
    assert(strikes() == 1);
    setup(0, MOVE_TACKLE, CATEGORY_PHYSICAL, RANGE_SINGLE_TARGET);
    ctx.battleMons[0].ability = ABILITY_SCRAPPY;
    assert(strikes() == 1);
    int single[] = { MOVE_DOUBLE_KICK, MOVE_BULLET_SEED, MOVE_BEAT_UP, MOVE_FISSURE, MOVE_EXPLOSION, MOVE_FLING,
                     MOVE_ROLLOUT, MOVE_UPROAR, MOVE_SOLAR_BEAM, MOVE_FLY, MOVE_ENDEAVOR, MOVE_PRESENT };
    for (unsigned i = 0; i < NELEMS(single); i++) {
        setup(0, single[i], CATEGORY_PHYSICAL, RANGE_SINGLE_TARGET);
        assert(strikes() == 1);
    }
    // Pollen Puff at a foe strikes twice; at the user's ally it heals, once.
    setup(1, MOVE_POLLEN_PUFF, CATEGORY_SPECIAL, RANGE_SINGLE_TARGET);
    assert(strikes() == 2);
    setup(1, MOVE_POLLEN_PUFF, CATEGORY_SPECIAL, RANGE_SINGLE_TARGET);
    ctx.battlerIdTarget = 2;
    assert(strikes() == 1);
    // Bide only as it unleashes what it stored.
    setup(0, MOVE_BIDE, CATEGORY_PHYSICAL, RANGE_SINGLE_TARGET);
    ctx.move.effect = MOVE_EFFECT_BIDE;
    assert(strikes() == 1);
    setup(0, MOVE_BIDE, CATEGORY_PHYSICAL, RANGE_SINGLE_TARGET);
    ctx.move.effect = MOVE_EFFECT_BIDE;
    ctx.damage = 40;
    assert(strikes() == 2);
    int later[] = { MOVE_FUTURE_SIGHT, MOVE_DOOM_DESIRE, MOVE_MISTY_EXPLOSION };
    for (unsigned i = 0; i < NELEMS(later); i++) {
        setup(0, later[i], CATEGORY_SPECIAL, RANGE_SINGLE_TARGET);
        assert(strikes() == 1);
    }
    // Once per move: not again for a spread move's later target, nor over a
    // count a move has already set.
    setup(0, MOVE_TACKLE, CATEGORY_PHYSICAL, RANGE_SINGLE_TARGET);
    ctx.unk_2184 = MULTIHIT_HIT_MULTIPLE_TARGETS;
    assert(strikes() == 1);
    setup(0, MOVE_TACKLE, CATEGORY_PHYSICAL, RANGE_SINGLE_TARGET);
    ctx.multiHitCountTemp = 3;
    TryStartParentalBond(&bs, &ctx);
    assert(!ctx.selfTurnData[0].parentalBond);
    // A move that can hit more than one strikes twice only with one to hit.
    setup(0, MOVE_EARTHQUAKE, CATEGORY_PHYSICAL, RANGE_ALL_ADJACENT);
    assert(strikes() == 2);
    setup(1, MOVE_EARTHQUAKE, CATEGORY_PHYSICAL, RANGE_ALL_ADJACENT);
    assert(strikes() == 1);
    setup(1, MOVE_EARTHQUAKE, CATEGORY_PHYSICAL, RANGE_ALL_ADJACENT);
    ctx.battleMons[1].hp = ctx.battleMons[2].hp = 0;
    assert(strikes() == 2);
    setup(1, MOVE_ROCK_SLIDE, CATEGORY_PHYSICAL, RANGE_ADJACENT_OPPONENTS);
    assert(strikes() == 1);
    setup(1, MOVE_ROCK_SLIDE, CATEGORY_PHYSICAL, RANGE_ADJACENT_OPPONENTS);
    ctx.battleMons[3].hp = 0;
    assert(strikes() == 2);
    return 0;
}
"""


def reference_list(name):
    source = subprocess.run(["git", "-C", str(REFERENCE), "show", "d0380a487:src/battle/other_battle_calculators.c"],
                            capture_output=True, text=True, check=True).stdout
    body = re.search(name + r"\[\]\s*=\s*\{(.*?)\};", source, re.S).group(1)
    return set(re.findall(r"MOVE_[A-Z0-9_]+", body))


def table(name):
    body = re.search(r"static const u16 " + name + r"\[\] = \{(.*?)\};", OVERLAY.read_text(), re.S).group(1)
    return re.findall(r"MOVE_[A-Z0-9_]+", body)


class ParentalBondTests(unittest.TestCase):
    def test_which_moves_strike_twice(self):
        source = OVERLAY.read_text()
        functions = "\n".join(
            [re.search(r"static const u16 " + name + r"\[\] = \{.*?\};", source, re.S).group(0)
             for name in ("sMultiStrikeMoves", "sParentalBondSingleStrikeMoves")]
            + [function(source, "MoveIsInList")]
            + [function(source, name) for name in (
                "ParentalBond_MoveApplies", "TryStartParentalBond", "ParentalBond_IsFirstStrike",
                "ParentalBond_IsSecondStrike", "MultiHit_StoppedBySleep", "ParentalBond_StrikeToCome")])
        with tempfile.TemporaryDirectory(prefix="newgold-parental-") as directory:
            path = Path(directory)
            (path / "test.c").write_text(FIXTURE.replace("@FUNCTIONS@", functions))
            subprocess.run(shlex.split(os.environ.get("CC", "cc")) + [
                "-std=c99", "-Wall", "-Werror", "-Wno-unused-function", "-iquote", str(ROOT / "include"),
                str(path / "test.c"), "-o", str(path / "test")], check=True)
            subprocess.run([str(path / "test")], check=True)

    def test_the_lists_are_the_reference_s(self):
        for name in ("sMultiStrikeMoves", "sParentalBondSingleStrikeMoves"):
            moves = table(name)
            self.assertEqual(moves, sorted(set(moves)), name)
        if not REFERENCE.exists():
            self.skipTest("Pinned NewGold reference checkout not configured")
        # Tachyon Cutter strikes twice of itself; the reference left it off.
        # Solar Seeds is New Gold's, and strikes two to five times.
        self.assertEqual(set(table("sMultiStrikeMoves")),
                         reference_list("MultiHitMovesList") | {"MOVE_TACHYON_CUTTER", "MOVE_SOLAR_SEEDS"})
        # Future Sight and Doom Desire strike later; Misty Explosion faints its
        # user. The reference leaves the three off.
        self.assertEqual(set(table("sParentalBondSingleStrikeMoves")),
                         reference_list("ParentalBondSingleStrikeMovesList")
                         | {"MOVE_FUTURE_SIGHT", "MOVE_DOOM_DESIRE", "MOVE_MISTY_EXPLOSION"})

    def test_every_move_that_sets_its_own_strikes_is_on_the_list(self):
        # A move whose script counts its own strikes would have the count
        # taken from it, SetMultiHit giving way to one already set. Present's
        # script strikes twice for the ability itself.
        effects = {int(m.group(1)) for path in EFFECTS.glob("effect_script_*.s")
                   for m in [re.match(r"effect_script_(\d+)\.s", path.name)]
                   if re.search(r"^\s*(SetMultiHit|BeatUp)\b", path.read_text(), re.M)}
        sys.path.insert(0, str(ROOT / "tools/newgold/import"))
        import import_moves
        records = import_moves.read_table()
        moves = {}
        for name, n in re.findall(r"#define (MOVE_[A-Z0-9_]+)\s+(\d+)\s*$",
                                  (ROOT / "include/constants/moves.h").read_text(), re.M):
            moves.setdefault(int(n), name)
        listed = set(table("sMultiStrikeMoves")) | set(table("sParentalBondSingleStrikeMoves"))
        for number, record in enumerate(records):
            if number in moves and struct.unpack("<H", record[:2])[0] in effects:
                self.assertIn(moves[number], listed, f"{moves[number]} strikes more than once")

    def test_the_second_strike_is_a_quarter(self):
        body = function(COMMANDS.read_text(), "DamageCalcDefault")
        quarter = body.index("if (ParentalBond_IsSecondStrike(ctx)) {\n        damage = QMul_RoundDown(damage, UQ412__0_25);")
        # 6.2, after the spread's three quarters and before the weather.
        self.assertLess(body.index("UQ412__0_75"), quarter)
        self.assertLess(quarter, body.index("BattlerMoveWeatherAt("))

    def test_it_starts_with_the_move_and_with_a_called_one(self):
        # A called move comes back through the before-move steps
        # (test_called_moves), and starts there as a chosen one does.
        controller = function(CONTROLLER.read_text(), "ov12_0224C38C")
        self.assertLess(controller.index("TryStartParentalBond(battleSystem, ctx);"),
                        controller.index("ReadBattleScriptFromNarc(ctx, NARC_a_0_0_0, ctx->moveNoCur);"))
        commands = COMMANDS.read_text()
        for name in ("BtlCmd_GoToMoveScript", "BtlCmd_SetMirrorMove"):
            self.assertIn("return CallMove(ctx);", function(commands, name), name)

    def test_what_waits_for_the_second_strike(self):
        # Nothing a strike's side effect does is held back for the second
        # strike: Smack Down's fall, the terrain's end and Dragon Tail's drag
        # are marked as the hit lands and done once the move is over, both
        # strikes over (Pokemon Central, Amorefiliale; TryFallAfterHit,
        # TerrainEnds, TryAdditionalMoveEffect).
        body = function(OVERLAY.read_text(), "ov12_02250490")
        self.assertNotIn("ParentalBond", body)
        for script in ("FELL_STRAIGHT_DOWN", "HANDLE_TERRAIN_END", "FORCE_TARGET_TO_SWITCH_OR_FLEE"):
            self.assertIn(f"*out == BATTLE_SUBSCRIPT_{script}", body)
        self.assertIn("ctx->selfTurnData[ctx->battlerIdStatChange].dragPending = TRUE;", body)
        # Anchor Shot's hold is no side effect: it comes once the move is over.
        tail = body[body.index("*out == BATTLE_SUBSCRIPT_FELL_STRAIGHT_DOWN"):]
        self.assertNotIn("MEAN_LOOK", tail[:tail.index("return ret;")])
        self.assertIn("!ParentalBond_StrikeToCome(ctx)", function(CONTROLLER.read_text(), "ov12_0224CC88"))
        self.assertIn("!ParentalBond_IsSecondStrike(ctx)", function(COMMANDS.read_text(), "BtlCmd_CalcFuryCutterPower"))

    def test_the_second_strike_rolls_no_accuracy_and_so_never_misses(self):
        # Pokemon Central (Amorefiliale): one accuracy check for the two
        # strikes. The second comes back through the before-move checks with
        # the multi-strike flags, which skip the roll and what overrides it,
        # and a miss is only ever the roll's: MOVE_STATUS_MULTI_HIT_DISRUPTED
        # is set only for a later strike that missed, so it never cuts off
        # what the first strike held back for the second (ov12_02250490).
        self.assertIn("ctx->checkMultiHit = MULTIHIT_MULTI_HIT_MOVE;", function(OVERLAY.read_text(), "TryStartParentalBond"))
        flags = (ROOT / "include/constants/battle.h").read_text()
        multi = re.search(r"#define MULTIHIT_MULTI_HIT_MOVE\s+\((.*)\)", flags).group(1)
        triple = re.search(r"#define MULTIHIT_TRIPLE_KICK\s+\((.*)\)", flags).group(1)
        self.assertIn("MULTIHIT_SKIP_ACCURACY_CHECK", multi)
        self.assertIn("MULTIHIT_SKIP_ACCURACY_OVERRIDES", triple)
        controller = CONTROLLER.read_text()
        self.assertIn("ctx->unk_2184 = ctx->checkMultiHit;", function(controller, "ov12_0224CF14"))
        checks = function(controller, "ov12_0224C4D8")
        self.assertIn("if (!(ctx->unk_2184 & 0x20) && ctx->battlerIdTarget != BATTLER_NONE && BattleSystem_CheckMoveHit(", checks)
        self.assertIn("if (!(ctx->unk_2184 & 0x40) && ctx->battlerIdTarget != BATTLER_NONE && BattleSystem_CheckMoveEffect(", checks)
        sources = "".join(path.read_text() for path in sorted((ROOT / "src/battle").glob("*.c")))
        self.assertEqual(sources.count("|= MOVE_STATUS_MISSED"), 1)
        self.assertIn("ctx->moveStatusFlag |= MOVE_STATUS_MISSED;", function(controller, "BattleSystem_CheckMoveHit"))
        self.assertEqual(sources.count("|= MOVE_STATUS_MULTI_HIT_DISRUPTED"), 1)
        self.assertIn("} else if (ctx->unk_2180 && (ctx->moveStatusFlag & MOVE_STATUS_MISSED)) {", function(controller, "ov12_0224C5F8"))
        scripts = "".join(path.read_text() for path in (ROOT / "files/battledata/script").rglob("*.s"))
        self.assertIsNone(re.search(r"UpdateVar +OPCODE_(FLAG_ON|SET|ADD), *BSCRIPT_VAR_MOVE_STATUS_FLAGS, *[^/\n]*"
                                    r"MOVE_STATUS_(MISSED|MULTI_HIT_DISRUPTED)", scripts))

    def test_a_pokemon_being_dragged_out_answers_neither_strike(self):
        # Pokemon Central (Codadrago): a Pokemon being dragged out does not
        # answer with Color Change or Anger Shell. The first strike marks the
        # drag as the second does, so neither strike is answered; before, the
        # first left the drag to the second and was answered. The drag waits
        # for the move's end, which Effect Spore's sleep can bring after the
        # first strike (Spargispora): nothing is replayed then, the mark being
        # there already. The recoil is a post-move step (TryRecoil) and waits
        # for nothing.
        overlay, controller = OVERLAY.read_text(), CONTROLLER.read_text()
        self.assertNotIn("ov12_02250490", function(controller, "ov12_0224CF14"))
        self.assertNotIn("parentalBondDeferred", (ROOT / "include/battle/battle.h").read_text())
        self.assertIn("|| (ability != ABILITY_BERSERK && Battler_WillBeDraggedOut(battleSystem, ctx, target))) {", function(overlay, "CheckColorChangeAngerShellAndBerserk"))
        self.assertIn("if (!ctx->selfTurnData[battlerId].dragPending", function(overlay, "Battler_WillBeDraggedOut"))
        self.assertIn("if (target != BATTLER_NONE && ctx->selfTurnData[target].dragPending) {", function(controller, "TryAdditionalMoveEffect"))

    def test_the_scripts_that_ask(self):
        pay_day = (EFFECTS / "effect_script_0034.s").read_text()
        self.assertLess(pay_day.index("GotoIfSecondHitOfParentalBond _NO_COINS"), pay_day.index("MOVE_SUBSCRIPT_PTR_PAY_DAY"))
        present = (EFFECTS / "effect_script_0122.s").read_text()
        self.assertLess(present.index("GotoIfSecondHitOfParentalBond _SECOND_STRIKE"), present.index("Present _004"))
        self.assertIn("SetParentalBondFlag", present[present.index("Present _004"):present.index("_SECOND_STRIKE:")])
        # The first strike spends the stockpile and the Berry, and may be the
        # last; the second strikes with what the first worked out.
        spit_up = (EFFECTS / "effect_script_0161.s").read_text()
        self.assertRegex(spit_up, r"_000:\s*GotoIfSecondHitOfParentalBond _STRIKE\s*CompareMonDataToValue")
        self.assertNotIn("GotoIfFirstHitOfParentalBond", spit_up)
        self.assertIn("BMON_DATA_STOCKPILE_COUNT, 0\n", spit_up[:spit_up.index("_STRIKE:")])
        secret_power = (EFFECTS / "effect_script_0197.s").read_text()
        self.assertNotIn("GetTerrainSecondaryEffect", secret_power[secret_power.index("_FIRST_STRIKE:"):])
        # Natural Gift's Berry is spent once the move is over, so both strikes
        # have it (test_battle_mechanics' NaturalGiftTests).
        natural_gift = (EFFECTS / "effect_script_0222.s").read_text()
        self.assertNotIn("RemoveItem", natural_gift)
        self.assertNotIn("ParentalBond", natural_gift)

    def test_recoil_comes_once_for_both_strikes(self):
        # Pokemon Central, Amorefiliale: the recoil is worked out from both
        # strikes' damage and taken after the second; a first strike that
        # fells the target is the last, and takes it. The recoil comes once
        # the move is over (TryRecoil, from the post-move steps), so the
        # subscripts need not ask which strike it is.
        subscripts = ROOT / "files/battledata/script/subscript"
        for number in (63, 147, 246, 389):
            script = next(subscripts.glob(f"subscript_{number:04d}_*.s")).read_text()
            self.assertNotIn("ParentalBond", script, number)
            if number != 389:
                self.assertIn("BSCRIPT_VAR_HP_CALC, BSCRIPT_VAR_ATTACKER_SHELL_BELL_DAMAGE_DEALT", script, number)
                self.assertNotIn("BSCRIPT_VAR_HIT_DAMAGE", script, number)
        self.assertIn("TryRecoil(ctx)", function(CONTROLLER.read_text(), "ov12_0224E1BC"))

    def test_color_change_and_anger_shell_answer_once_the_move_is_over(self):
        # Color Change and Anger Shell answer a move that strikes more than
        # once after its last strike, Anger Shell on the whole move's damage
        # (Pokemon Central, Cambiacolore from the fifth generation;
        # Bulbapedia's Color Change and Anger Shell; Showdown's gen-9
        # onAfterMoveSecondary on move.totalDamage). Before, both answered
        # after each strike.
        from test_ability_interactions import run_c
        overlay, controller = OVERLAY.read_text(), CONTROLLER.read_text()
        run_c(AFTER_STRIKES.replace("@FUNCTIONS@", function(overlay, "Battler_ArmRetreat")
                                    + function(overlay, "CheckColorChangeAngerShellAndBerserk")))
        on_hit = function(overlay, "CheckAbilityEffectOnHit")
        case = on_hit[on_hit.index("case ABILITY_ANGER_SHELL:\n    case ABILITY_BERSERK: {"):]
        case = case[:case.index("case ABILITY_GULP_MISSILE:")]
        self.assertIn("if (ctx->multiHitCountTemp == 0 && !(ctx->moveStatusFlag & MOVE_STATUS_FAIL)) {\n"
                      "            ret = CheckColorChangeAngerShellAndBerserk(battleSystem, ctx, script);", case)
        # The first of the post-move steps, before the recoil and the drag,
        # for a move that struck more than once.
        end = function(controller, "ov12_0224E1BC")
        ask = "if (ctx->multiHitCountTemp != 0 && ctx->battlerIdTarget != BATTLER_NONE\n                && CheckColorChangeAngerShellAndBerserk(battleSystem, ctx, &script) == TRUE) {"
        self.assertIn(ask, end)
        # Berserk's rise credited to the ability, which RunPostMoveScript's
        # SIDE_EFFECT_TYPE_MOVE_EFFECT would not.
        self.assertIn(ask + "\n                RunPostMoveScript(ctx, script);\n"
                      "                // Berserk's rise is the ability's, as it is for a single hit.\n"
                      "                ctx->statChangeType = SIDE_EFFECT_TYPE_ABILITY;", end)
        self.assertLess(end.index("case 0:"), end.index(ask))
        self.assertLess(end.index(ask), end.index("case 1:"))
        self.assertLess(end.index("case 1:"), end.index("TryRecoil(ctx)"))

    def test_berserk_and_anger_shell_answer_a_hit_after_the_stat_items(self):
        # Absorb Bulb, Weakness Policy and Luminous Moss act before Berserk
        # (Pokemon Central, Furore), Cell Battery and Snowball with them, and
        # Anger Shell waits for them as Berserk does (Showdown's gen-9 items in
        # onDamagingHit, the abilities in onAfterMoveSecondary): a holder of
        # one has a single hit answered by the step after
        # CheckItemEffectOnHit, before the thaw and the other held items; a
        # Sitrus Berry's holder, as before, where CheckAbilityEffectOnHit asks,
        # before the Berry (TryUseHeldItem). Color Change does not wait.
        on_hit = function(OVERLAY.read_text(), "CheckAbilityEffectOnHit")
        case = on_hit[on_hit.index("case ABILITY_ANGER_SHELL:\n    case ABILITY_BERSERK: {"):on_hit.index("case ABILITY_COLOR_CHANGE:")]
        self.assertIn("if (ctx->multiHitCountTemp == 0\n"
                      "            && ((item >= HOLD_EFFECT_BOOST_SPECIAL_ATTACK_ON_WATER_HIT && item <= HOLD_EFFECT_BOOST_ATK_ON_ICE_HIT)\n"
                      "                || item == HOLD_EFFECT_BOOST_SPECIAL_DEFENSE_ON_WATER_HIT || item == HOLD_EFFECT_BOOST_ATK_AND_SPATK_ON_SE)) {\n"
                      "            ctx->selfTurnData[ctx->battlerIdTarget].answerAfterItem = TRUE;\n"
                      "            break;", case)
        items = (ROOT / "include/constants/items.h").read_text()
        numbers = [int(re.search(rf"#define {name}\s+(\d+)", items).group(1)) for name in (
            "HOLD_EFFECT_BOOST_SPECIAL_ATTACK_ON_WATER_HIT", "HOLD_EFFECT_BOOST_ATK_ON_ELECTRIC_HIT", "HOLD_EFFECT_BOOST_ATK_ON_ICE_HIT")]
        self.assertEqual(numbers, list(range(numbers[0], numbers[0] + 3)))
        steps = function(CONTROLLER.read_text(), "ov12_0224CC88")
        item = steps.index("CheckItemEffectOnHit(battleSystem, ctx, &script)")
        after = steps.index("if (ctx->battlerIdTarget != BATTLER_NONE && ctx->selfTurnData[ctx->battlerIdTarget].answerAfterItem\n"
                            "            && CheckColorChangeAngerShellAndBerserk(battleSystem, ctx, &script) == TRUE) {")
        self.assertLess(item, after)
        self.assertLess(after, steps.index("BATTLE_SUBSCRIPT_THAW_OUT"))
        self.assertLess(steps.index("TryUseHeldItem(battleSystem, ctx, ctx->battlerIdTarget)"), item)


AFTER_STRIKES = r"""
#include <assert.h>
#include <stdint.h>
#include <string.h>
typedef uint8_t u8;
typedef uint16_t u16;
typedef uint32_t u32;
typedef int BOOL;
enum { FALSE = 0, TRUE = 1 };
#include "constants/abilities.h"
#include "constants/battle.h"
#include "constants/battle_subscript.h"
#include "constants/moves.h"
#include "constants/pokemon.h"
typedef struct { int unused; } BattleSystem;
typedef struct { u8 power; } MoveTbl;
typedef struct { int hp, maxHp, ability, type1, type2; int statChanges[8]; } BattleMon;
typedef struct { u32 retreatArmed : 1; int physicalDamage, specialDamage; } SelfTurnData;
typedef struct {
    BattleMon battleMons[4]; SelfTurnData selfTurnData[4];
    int battlerIdAttacker, battlerIdTarget, battlerIdStatChange, battlerIdTemp, msgTemp, statChangeParam, statChangeType;
    u32 moveNoCur, battleStatus2;
    u8 multiHitCount, multiHitCountTemp;
} BattleContext;
static BOOL dragged, sheerForce;
static MoveTbl move = { 30 };
static int GetBattlerAbility(BattleContext *ctx, int battlerId) { return ctx->battleMons[battlerId].ability; }
static int GetBattlerVar(BattleContext *ctx, int battlerId, u32 varId, void *data) {
    (void)data;
    return varId == BMON_DATA_TYPE_1 ? ctx->battleMons[battlerId].type1 : ctx->battleMons[battlerId].type2;
}
static u8 BattleMoveAdjustedType(BattleContext *ctx, int battlerId, u32 moveNo) { (void)ctx; (void)battlerId; (void)moveNo; return TYPE_FIGHTING; }
static const MoveTbl *BattleMoveTbl(BattleContext *ctx, u32 moveNo) { (void)ctx; (void)moveNo; return &move; }
static BOOL Battler_WillBeDraggedOut(BattleSystem *bs, BattleContext *ctx, int battlerId) { (void)bs; (void)ctx; (void)battlerId; return dragged; }
static BOOL SheerForceTradedEffect(BattleContext *ctx) { (void)ctx; return sheerForce; }
@FUNCTIONS@
static BattleSystem bs;
static BattleContext ctx;
static int script;
static void strike(int damage) {
    // A strike lands on 1: armed as it lands, then its damage taken, and
    // one strike fewer to come.
    Battler_ArmRetreat(&ctx, 1);
    ctx.battleMons[1].hp -= damage;
    ctx.selfTurnData[1].physicalDamage = -damage;
    ctx.multiHitCount--;
}
static void reset(int ability, int hp) {
    memset(&ctx, 0, sizeof(ctx));
    dragged = sheerForce = FALSE;
    ctx.battlerIdTarget = 1;
    ctx.moveNoCur = MOVE_DOUBLE_KICK;
    ctx.multiHitCount = ctx.multiHitCountTemp = 2;
    ctx.battleMons[1] = (BattleMon){ hp, 100, ability, TYPE_NORMAL, TYPE_NORMAL, { 6, 6, 6, 6, 6, 6, 6, 6 } };
    script = 0;
}
static BOOL answers(void) { return CheckColorChangeAngerShellAndBerserk(&bs, &ctx, &script); }
int main(void) {
    // Color Change takes the move's type once the strikes are over.
    reset(ABILITY_COLOR_CHANGE, 100);
    strike(20); strike(5);
    assert(answers() && script == BATTLE_SUBSCRIPT_COLOR_CHANGE && ctx.msgTemp == TYPE_FIGHTING);
    // Not with the type already, not when no strike reached the Pokemon
    // itself, not for a Pokemon that fell or is dragged out, not after
    // Sheer Force, not for Struggle.
    reset(ABILITY_COLOR_CHANGE, 100); strike(20); ctx.battleMons[1].type2 = TYPE_FIGHTING;
    assert(!answers());
    reset(ABILITY_COLOR_CHANGE, 100);
    assert(!answers());
    reset(ABILITY_COLOR_CHANGE, 20); strike(20);
    assert(!answers());
    reset(ABILITY_COLOR_CHANGE, 100); strike(20); dragged = TRUE;
    assert(!answers());
    reset(ABILITY_COLOR_CHANGE, 100); strike(20); sheerForce = TRUE;
    assert(!answers());
    reset(ABILITY_COLOR_CHANGE, 100); strike(20); ctx.moveNoCur = MOVE_STRUGGLE;
    assert(!answers());
    // Nor any other ability, which the post-move step asks as well.
    reset(ABILITY_STATIC, 100); strike(20); strike(20);
    assert(!answers() && script == 0);
    // Anger Shell cracks once a hit found it above half and the move has
    // left it at half or below: from 60, 5 and 10 take it to 45; 5 and 4
    // leave it at 51; from 50 it was never above half.
    reset(ABILITY_ANGER_SHELL, 60); strike(5); strike(10);
    assert(answers() && script == BATTLE_SUBSCRIPT_ANGER_SHELL);
    assert(ctx.battlerIdStatChange == 1 && ctx.battlerIdTemp == 1);
    reset(ABILITY_ANGER_SHELL, 60); strike(5); strike(4);
    assert(!answers());
    reset(ABILITY_ANGER_SHELL, 50); strike(5); strike(10);
    assert(!answers());
    // Nor when it was at half or below as the move began and a Sitrus Berry
    // took it back above half between the strikes, the second taking it to
    // half or below again (Pokemon Central, Iraguscio): from 50, 10 to 40,
    // the Berry's 25 to 65, 20 to 45. From 60 it was above half: 20 to 40,
    // the Berry to 65, 20 to 45, and it cracks.
    reset(ABILITY_ANGER_SHELL, 50); strike(10); ctx.battleMons[1].hp += 25; strike(20);
    assert(ctx.battleMons[1].hp == 45 && !answers());
    reset(ABILITY_ANGER_SHELL, 60); strike(20); ctx.battleMons[1].hp += 25; strike(20);
    assert(ctx.battleMons[1].hp == 45 && answers());
    // A single hit: from 60 to 40.
    reset(ABILITY_ANGER_SHELL, 60); strike(20);
    assert(answers());
    // Nothing left to change; any one stage with room is enough.
    reset(ABILITY_ANGER_SHELL, 60); strike(20);
    ctx.battleMons[1].statChanges[STAT_ATK] = ctx.battleMons[1].statChanges[STAT_SPATK] = ctx.battleMons[1].statChanges[STAT_SPEED] = 12;
    ctx.battleMons[1].statChanges[STAT_DEF] = ctx.battleMons[1].statChanges[STAT_SPDEF] = 0;
    assert(!answers());
    ctx.battleMons[1].statChanges[STAT_SPDEF] = 1;
    assert(answers());
    // A move Sheer Force powered arms nothing.
    reset(ABILITY_ANGER_SHELL, 60); sheerForce = TRUE; strike(20); sheerForce = FALSE;
    assert(!answers());
    // Berserk is Anger Shell's crossing with a stage of Sp. Atk (Pokemon
    // Central, Furore: after the last strike): from 60, 5 and 10 to 45; not
    // 5 and 4; not from 50; not with the Sp. Atk at +6; and, Codadrago naming
    // only Color Change and Anger Shell, for a Pokemon dragged out too.
    reset(ABILITY_BERSERK, 60); strike(5); strike(10);
    assert(answers() && script == BATTLE_SUBSCRIPT_ABILITY_STAT_CHANGE);
    assert(ctx.statChangeParam == MOVE_SUBSCRIPT_PTR_SP_ATTACK_UP_1_STAGE && ctx.statChangeType == SIDE_EFFECT_TYPE_ABILITY);
    assert(ctx.battlerIdStatChange == 1 && ctx.battlerIdTemp == 1);
    reset(ABILITY_BERSERK, 60); strike(5); strike(4);
    assert(!answers());
    reset(ABILITY_BERSERK, 50); strike(5); strike(10);
    assert(!answers());
    // Furore has no such rule as Iraguscio's for a Berry between the
    // strikes: back above half, the second strike arms it again.
    reset(ABILITY_BERSERK, 50); strike(10); ctx.battleMons[1].hp += 25; strike(20);
    assert(ctx.battleMons[1].hp == 45 && answers());
    reset(ABILITY_BERSERK, 60); strike(20); ctx.battleMons[1].statChanges[STAT_SPATK] = 12;
    assert(!answers());
    reset(ABILITY_BERSERK, 60); strike(20); dragged = TRUE;
    assert(answers());
    reset(ABILITY_BERSERK, 60); sheerForce = TRUE; strike(20);
    assert(!answers());
    return 0;
}
"""

if __name__ == "__main__":
    unittest.main()
