#!/usr/bin/env python3
"""Solar Beam's and Shadow Force's first turn is the controller's, as the
engine asks it before the move (BattleController_CheckChargeMoves and
CheckPowerHerb at d0380a487), and effect scripts 151 and 272 keep only the
hit. The charge turn says the attack message first, "X used Solar Beam!",
as the engine's subscripts and Showdown's gen-9 move line do; in harsh
sunlight Solar Beam says "absorbed light!" before its hit."""

import re
import unittest

from test_ability_interactions import run_c
from test_level_cap import ROOT
from test_repels import function

CONTROLLER = ROOT / "src/battle/battle_controller_player.c"
SCRIPTS = ROOT / "files/battledata/script"

PROGRAM = r"""
#include <assert.h>
#include <stdint.h>
typedef uint8_t u8;
typedef uint16_t u16;
typedef uint32_t u32;
typedef int BOOL;
enum { FALSE = 0, TRUE = 1 };
#include "constants/battle.h"
#include "constants/battle_subscript.h"
#include "constants/message_tags.h"
#include "constants/move_effects.h"
#include "constants/moves.h"
#define msg_0197_00214 214
#define msg_0197_01082 1082
enum { NARC_a_0_0_1 = 1 };
typedef struct { int unused; } BattleSystem;
typedef struct { int effect; } MoveTbl;
typedef struct { u32 status2, moveEffectFlags; } BattleMon;
typedef struct { int id, tag, param[6]; } BattleMessage;
typedef struct {
    BattleMon battleMons[4];
    BattleMessage buffMsg;
    int battlerIdAttacker, script;
    u32 battleStatus, weather;
    u16 moveNoCur;
    MoveTbl move;
} BattleContext;
static MoveTbl *BattleMoveTbl(BattleContext *ctx, u16 move) { (void)move; return &ctx->move; }
static u32 BattlerMoveWeather(BattleSystem *bs, BattleContext *ctx, int battlerId) { (void)bs; (void)battlerId; return ctx->weather; }
static u32 BattlerMoveWeatherAt(BattleSystem *bs, BattleContext *ctx, int battlerIdAttacker, int battlerId) { (void)battlerId; return BattlerMoveWeather(bs, ctx, battlerIdAttacker); }
static int CreateNicknameTag(BattleContext *ctx, int battlerId) { (void)ctx; return 100 + battlerId; }
static void ReadBattleScriptFromNarc(BattleContext *ctx, int narc, int script) { assert(narc == NARC_a_0_0_1); ctx->script = script; }
@FUNCTIONS@
static BattleContext charge(int effect, u32 status2, u32 weather) {
    BattleSystem bs = { 0 };
    BattleContext ctx = { 0 };
    ctx.battlerIdAttacker = 1;
    ctx.move.effect = effect;
    ctx.battleMons[1].status2 = status2;
    ctx.weather = weather;
    ctx.script = -1;
    assert(TryChargeTurn(&bs, &ctx) == (ctx.script != -1));
    return ctx;
}
int main(void) {
    // Solar Beam's first turn: the subscript, the line buffered.
    BattleContext ctx = charge(MOVE_EFFECT_151, 0, 0);
    assert(ctx.script == BATTLE_SUBSCRIPT_CHARGE_TURN);
    assert(ctx.buffMsg.id == 214 && ctx.buffMsg.tag == TAG_NICKNAME && ctx.buffMsg.param[0] == 101);
    assert(!(ctx.battleMons[1].moveEffectFlags & MOVE_EFFECT_FLAG_PHANTOM_FORCE));
    // In the sun, or on the second turn, the move script.
    assert(charge(MOVE_EFFECT_151, 0, FIELD_CONDITION_SUN).script == -1);
    assert(charge(MOVE_EFFECT_151, STATUS2_LOCKED_INTO_MOVE, 0).script == -1);
    // Shadow Force's first turn, its user marked as it vanishes.
    ctx = charge(MOVE_EFFECT_SHADOW_FORCE, 0, FIELD_CONDITION_SUN);
    assert(ctx.script == BATTLE_SUBSCRIPT_CHARGE_TURN && ctx.buffMsg.id == 1082);
    assert(ctx.battleMons[1].moveEffectFlags & MOVE_EFFECT_FLAG_PHANTOM_FORCE);
    assert(charge(MOVE_EFFECT_SHADOW_FORCE, STATUS2_LOCKED_INTO_MOVE, 0).script == -1);
    // Nothing else.
    assert(charge(MOVE_EFFECT_FLY, 0, 0).script == -1);
    return 0;
}
"""


def script(kind, pattern):
    return next((SCRIPTS / kind).glob(pattern)).read_text()


class ChargeTurnTests(unittest.TestCase):
    def test_the_controller_starts_the_charge(self):
        controller = CONTROLLER.read_text()
        run_c(PROGRAM.replace("@FUNCTIONS@", function(controller, "SolarBeamFiresAtOnce") + function(controller, "TryChargeTurn")))
        # In place of the move script, which buffered the line and charged.
        self.assertIn("if (TryChargeTurn(battleSystem, ctx) == FALSE) {\n"
                      "            ReadBattleScriptFromNarc(ctx, NARC_a_0_0_0, ctx->moveNoCur);", function(controller, "ov12_0224C38C"))

    def test_the_charge_turn_says_the_attack_message_first(self):
        charge = script("subscript", "subscript_0473_*.s")
        self.assertEqual(charge.split("_000:\n")[1].split("\n")[0].strip(), "PrintAttackMessage")
        # Then retail's charge -- subscript 13 as the side effect, the line and
        # the lock -- or the Power Herb and the hit.
        self.assertIn("MOVE_SIDE_EFFECT_TO_ATTACKER|MOVE_SUBSCRIPT_PTR_VANISH_CHARGE_TURN", charge)
        herb = charge[charge.index("\n_POWER_HERB:"):]
        self.assertIn("Call BATTLE_SUBSCRIPT_ITEM_SKIP_CHARGE_TURN", herb)
        self.assertIn("LockMoveChoice BATTLER_CATEGORY_ATTACKER\n    GoToEffectScript", herb)

    def test_solar_beam_in_the_sun_absorbs_light_before_its_hit(self):
        solar = script("effect_script", "effect_script_0151.s")
        unlocked = solar[solar.index("_033\n"):solar.index("\n_033:")]
        self.assertLess(unlocked.index("PrintAttackMessage"), unlocked.index("PrintMessage msg_0197_00214, TAG_NICKNAME"))
        # The hit plays the animation, once.
        self.assertNotIn("    PlayMoveAnimation", solar)
        self.assertNotIn("HOLD_EFFECT_CHARGE_SKIP", solar)
        self.assertNotRegex(script("effect_script", "effect_script_0272_*.s"), r"CHARGE_SKIP|LOCKED_INTO_MOVE")


if __name__ == "__main__":
    unittest.main()
