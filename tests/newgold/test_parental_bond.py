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
        self.assertLess(quarter, body.index("BattlerMoveWeather("))

    def test_it_starts_with_the_move_and_with_a_called_one(self):
        controller = function(CONTROLLER.read_text(), "ov12_0224C38C")
        self.assertLess(controller.index("TryStartParentalBond(battleSystem, ctx);"),
                        controller.index("ReadBattleScriptFromNarc(ctx, NARC_a_0_0_0, ctx->moveNoCur);"))
        commands = COMMANDS.read_text()
        for name in ("BtlCmd_GoToMoveScript", "BtlCmd_SetMirrorMove"):
            self.assertIn("TryStartParentalBond(battleSystem, ctx);", function(commands, name), name)

    def test_what_waits_for_the_second_strike(self):
        body = function(OVERLAY.read_text(), "ov12_02250490")
        waiting = body[body.index("if (ret == TRUE && ParentalBond_StrikeToCome(ctx)) {"):]
        for script in ("ATTACK_THEN_SWITCH_OUT", "FORCE_TARGET_TO_SWITCH_OR_FLEE", "STEAL_ITEM", "PLUCK",
                       "KNOCK_OFF", "HEAL_TARGET_PARALYSIS", "HEAL_TARGET_SLEEP", "FELL_STRAIGHT_DOWN", "MEAN_LOOK",
                       "HANDLE_TERRAIN_END"):
            self.assertIn(f"case BATTLE_SUBSCRIPT_{script}:", waiting)
        self.assertIn("!ParentalBond_StrikeToCome(ctx)", function(CONTROLLER.read_text(), "ov12_0224CC88"))
        self.assertIn("!ParentalBond_IsSecondStrike(ctx)", function(COMMANDS.read_text(), "BtlCmd_CalcFuryCutterPower"))

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
        natural_gift = (EFFECTS / "effect_script_0222.s").read_text()
        self.assertRegex(natural_gift, r"_000:\s*GotoIfSecondHitOfParentalBond _SECOND_STRIKE\s*CalcNaturalGiftParams _006"
                                       r"\s*CalcCrit\s*CalcDamage\s*RemoveItem BATTLER_CATEGORY_ATTACKER")
        self.assertNotIn("RemoveItem", natural_gift[natural_gift.index("_SECOND_STRIKE:"):])

    def test_recoil_comes_once_for_both_strikes(self):
        # Pokemon Central, Amorefiliale: the recoil is worked out from both
        # strikes' damage and taken after the second; a first strike that
        # fells the target is the last, and takes it.
        subscripts = ROOT / "files/battledata/script/subscript"
        for number in (63, 147, 246, 389):
            script = next(subscripts.glob(f"subscript_{number:04d}_*.s")).read_text()
            self.assertIn("GotoIfFirstHitOfParentalBond _FIRST_STRIKE", script, number)
            self.assertRegex(script, r"_FIRST_STRIKE:\s*CompareMonDataToValue OPCODE_NEQ, BATTLER_CATEGORY_DEFENDER, "
                                     r"BMON_DATA_HP, 0, (\w+)\s*GoTo _RECOIL", number)
            if number != 389:
                self.assertIn("BSCRIPT_VAR_HP_CALC, BSCRIPT_VAR_ATTACKER_SHELL_BELL_DAMAGE_DEALT", script, number)
                self.assertNotIn("BSCRIPT_VAR_HIT_DAMAGE", script, number)


if __name__ == "__main__":
    unittest.main()
