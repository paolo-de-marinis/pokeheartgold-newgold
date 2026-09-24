#!/usr/bin/env python3
"""A move another move calls goes back through the steps before a move.

Metronome, Sleep Talk, Nature Power, Assist, Me First and Copycat end their
scripts with GoToMoveScript, Mirror Move with SetMirrorMove. The move they
call is sent back to the before-move steps (ov12_0224C38C), as the engine's
GoBackToBeforeMove sends it (BattleController_BeforeMove.c at d0380a487),
past what stops a Pokemon acting and the PP, which were the caller's.
"""

import unittest

from test_ability_interactions import run_c
from test_level_cap import ROOT
from test_repels import function

COMMANDS = ROOT / "src/battle/battle_command.c"
CONTROLLER = ROOT / "src/battle/battle_controller_player.c"

FIXTURE = r"""
#include <assert.h>
#include <stdint.h>
typedef uint8_t u8;
typedef uint16_t u16;
typedef uint32_t u32;
typedef int BOOL;
enum { FALSE = 0, TRUE = 1 };
#include "constants/battle.h"
typedef struct { int unused; } BattleSystem;
typedef struct { u8 unk4; } PlayerAction;
typedef struct {
    PlayerAction playerActions[4];
    int battlerIdAttacker, battlerIdTarget, battleContinueFlag;
    u32 battleStatus, unk_2184, moveNoCur, moveTemp;
    ControllerCommand command, commandNext;
} BattleContext;
static int redirected;
static void BattleScriptIncrementPointer(BattleContext *ctx, int n) { (void)ctx; (void)n; }
static int BattleScriptReadWord(BattleContext *ctx) { (void)ctx; return 0; }
static int ov12_022506D4(BattleSystem *bs, BattleContext *ctx, int attacker, u16 move, int a, int b) {
    (void)bs; (void)ctx; (void)attacker; (void)move; (void)a; (void)b;
    return 1;
}
static void ov12_02250A18(BattleSystem *bs, BattleContext *ctx, int attacker, u16 move) {
    (void)bs; (void)attacker; (void)move;
    redirected = ctx->battlerIdTarget;
}
@FUNCTIONS@
int main(void) {
    BattleSystem bs = { 0 };
    BattleContext ctx = { 0 };
    ctx.battlerIdAttacker = 0;
    ctx.battlerIdTarget = 0;
    ctx.moveNoCur = MOVE_METRONOME;
    ctx.moveTemp = MOVE_EXPLOSION;
    ctx.battleStatus = BATTLE_STATUS_NO_ATTACK_MESSAGE | BATTLE_STATUS_MOVE_ANIMATIONS_OFF;
    ctx.command = CONTROLLER_COMMAND_RUN_SCRIPT;
    ctx.commandNext = CONTROLLER_COMMAND_24;
    // The caller's script ends, and the called move comes back to the steps
    // before a move, past the caller's checks and PP.
    assert(BtlCmd_GoToMoveScript(&bs, &ctx) == TRUE);
    assert(ctx.battleContinueFlag);
    assert(ctx.commandNext == CONTROLLER_COMMAND_23);
    assert(ctx.moveNoCur == MOVE_EXPLOSION && ctx.battlerIdTarget == 1 && ctx.playerActions[0].unk4 == 1);
    assert(redirected == 1);
    assert(ctx.unk_2184 == (MULTIHIT_SKIP_OBEDIENCE_CHECK | MULTIHIT_SKIP_STATUS_CHECK | MULTIHIT_CALLED_MOVE));
    assert(!(ctx.unk_2184 & MULTIHIT_SKIP_PP_DECREMENT));
    assert(!(ctx.battleStatus & (BATTLE_STATUS_NO_ATTACK_MESSAGE | BATTLE_STATUS_MOVE_ANIMATIONS_OFF)));
    return 0;
}
"""


class CalledMoveTests(unittest.TestCase):
    def test_a_called_move_goes_back_through_the_steps_before_a_move(self):
        commands = COMMANDS.read_text()
        functions = function(commands, "CallMove") + function(commands, "BtlCmd_GoToMoveScript")
        run_c(FIXTURE.replace("@FUNCTIONS@", functions).replace(
            '#include "constants/battle.h"', '#include "constants/battle.h"\n#include "constants/moves.h"'))

    METRONOME_ITEM = r"""
#include <assert.h>
#include <stdint.h>
#include <string.h>
#include "constants/battle.h"
#include "constants/items.h"
#include "constants/moves.h"
typedef uint16_t u16; typedef uint32_t u32;
typedef struct BattleSystem BattleSystem;
typedef struct { u32 status2; struct { int metronomeTurns; } unk88; } BattleMon;
typedef struct { u32 metronomeLanded : 1; int rolloutCount; } SelfTurnData;
typedef struct {
    int battlerIdAttacker; u32 battleStatus, moveStatusFlag; u16 moveNoTemp; u16 moveNoMetronome[4];
    BattleMon battleMons[4]; SelfTurnData selfTurnData[4];
} BattleContext;
static int GetBattlerHeldItemEffect(BattleContext *ctx, int battlerId) { (void)ctx; (void)battlerId; return HOLD_EFFECT_BOOST_REPEATED; }
@FUNCTIONS@
int main(void) {
    BattleContext ctx;
    memset(&ctx, 0, sizeof(ctx));
    ctx.moveNoTemp = ctx.moveNoMetronome[0] = MOVE_EARTHQUAKE;
    // A third Earthquake in a row that hit one foe and not the Flying-type
    // after it keeps its count; one that hit nothing gives it back.
    ctx.battleMons[0].unk88.metronomeTurns = 2;
    ctx.moveStatusFlag = MOVE_STATUS_NO_EFFECT;
    ctx.selfTurnData[0].metronomeLanded = 1;
    ov12_02256694(0, &ctx);
    assert(ctx.battleMons[0].unk88.metronomeTurns == 2);
    ctx.selfTurnData[0].metronomeLanded = 0;
    ov12_02256694(0, &ctx);
    assert(ctx.battleMons[0].unk88.metronomeTurns == 1);
    return 0;
}
"""

    def test_the_metronome_item_counts_a_spread_move_once(self):
        # Pokemon Central (Plessimetro): a move that hits several Pokemon is
        # one use, if it hits one. Its later targets are no use of their
        # own, and a last target that avoided it takes nothing back once an
        # earlier one was hit.
        controller = CONTROLLER.read_text()
        overlay = (ROOT / "src/battle/overlay_12_0224E4FC.c").read_text()
        run_c(self.METRONOME_ITEM.replace("@FUNCTIONS@", function(overlay, "ov12_02256694")))
        loop = function(controller, "ov12_0224D03C")
        self.assertLess(loop.index("ctx->selfTurnData[ctx->battlerIdAttacker].metronomeLanded = TRUE;"), loop.index("BATTLE_STATUS2_MAGIC_COAT"))
        self.assertIn("if (!(ctx->moveStatusFlag & MOVE_STATUS_FAIL)) {\n        ctx->selfTurnData[ctx->battlerIdAttacker].metronomeLanded = TRUE;", loop)

    def test_mirror_move_s_copy_does_too(self):
        body = function(COMMANDS.read_text(), "BtlCmd_SetMirrorMove")
        self.assertIn("return CallMove(ctx);", body)
        self.assertNotIn("NARC_a_0_0_0", body)

    def test_the_steps_skip_the_caller_s_pp_and_metronome_count(self):
        # The PP was the calling move's; the Metronome item counted the
        # calling move once.
        controller = CONTROLLER.read_text()
        steps = function(controller, "ov12_0224C38C")
        self.assertIn("!(ctx->unk_2184 & (MULTIHIT_SKIP_PP_DECREMENT | MULTIHIT_CALLED_MOVE)) && ov12_0224B1FC(", steps)
        # Nor a spread move's later targets, which come back with unk_2184 at
        # 13: one use, one count (Pokemon Central, Plessimetro).
        self.assertRegex(steps, r"if \(!\(ctx->unk_2184 & MULTIHIT_CALLED_MOVE\) && ctx->unk_2184 != MULTIHIT_HIT_MULTIPLE_TARGETS\) \{\n\s+ov12_022565E0\(battleSystem, ctx\);")
        self.assertIn("ctx->unk_2184 = 13;", function(controller, "ov12_0224D03C"))
        # Parental Bond starts for the called move where it does for a
        # chosen one, once the steps are through: CallMove leaves the PP flag
        # TryStartParentalBond asks off.
        self.assertLess(steps.index("TryStartParentalBond(battleSystem, ctx);"),
                        steps.index("ReadBattleScriptFromNarc(ctx, NARC_a_0_0_0, ctx->moveNoCur);"))

    def test_the_called_move_is_noted_as_the_move_used(self):
        run_c(NOTED.replace("@FUNCTIONS@", function(CONTROLLER.read_text(), "NoteMoveUsed")))

    def test_pressure_charges_the_caller_for_the_move_called(self):
        controller = CONTROLLER.read_text()
        run_c(PRESSURE.replace("@FUNCTIONS@", function(controller, "PressurePP") + function(controller, "ChargeCallerPressure")))
        steps = function(controller, "ov12_0224C38C")
        self.assertIn("if ((ctx->unk_2184 & (MULTIHIT_SKIP_PP_DECREMENT | MULTIHIT_CALLED_MOVE)) == MULTIHIT_CALLED_MOVE) {\n"
                      "            ChargeCallerPressure(battleSystem, ctx);", steps)


PRESSURE = r"""
#include <assert.h>
#include <stdint.h>
typedef uint8_t u8;
typedef uint16_t u16;
typedef uint32_t u32;
typedef int BOOL;
enum { FALSE = 0, TRUE = 1 };
#include "constants/abilities.h"
#include "constants/battle.h"
#include "constants/moves.h"
typedef struct { int unused; } BattleSystem;
typedef struct { u16 moves[4]; u8 movePPCur[4]; int ability; } BattleMon;
typedef struct { u8 ignorePressure; } SelfTurnData;
typedef struct { u16 range; } MoveTbl;
typedef struct {
    BattleMon battleMons[4];
    SelfTurnData selfTurnData[4];
    int battlerIdAttacker, battlerIdTarget, copies;
    u16 moveNoCur, moveNoTemp;
} BattleContext;
static MoveTbl sMove;
static MoveTbl *BattleMoveTbl(BattleContext *ctx, u16 move) {
    (void)ctx;
    sMove.range = move == MOVE_METRONOME ? RANGE_SINGLE_TARGET_SPECIAL : move == MOVE_SURF ? RANGE_ALL_ADJACENT : RANGE_SINGLE_TARGET;
    return &sMove;
}
static int GetBattlerAbility(BattleContext *ctx, int battlerId) { return ctx->battleMons[battlerId].ability; }
static int CheckAbilityActive(BattleSystem *bs, BattleContext *ctx, int mode, int battlerId, int ability) {
    int count = 0;
    (void)bs;
    for (int i = 0; i < 4; i++) {
        if (i != battlerId && ctx->battleMons[i].ability == ability && (mode != CHECK_ABILITY_OPPOSING_SIDE_HP || (i & 1) != (battlerId & 1))) {
            count++;
        }
    }
    return count;
}
static int BattleMon_GetMoveIndex(BattleMon *mon, u16 move) {
    int i;
    for (i = 0; i < 4 && mon->moves[i] != move; i++) { }
    return i;
}
static void CopyBattleMonToPartyMon(BattleSystem *bs, BattleContext *ctx, int battlerId) { (void)bs; (void)battlerId; ctx->copies++; }
@FUNCTIONS@
int main(void) {
    BattleSystem bs = { 0 };
    BattleContext ctx = { 0 };
    ctx.battleMons[0].moves[1] = MOVE_METRONOME;
    ctx.battleMons[0].movePPCur[1] = 9;
    ctx.battleMons[1].ability = ABILITY_PRESSURE;
    ctx.battleMons[3].ability = ABILITY_PRESSURE;
    ctx.moveNoTemp = MOVE_METRONOME;
    // Metronome is aimed at its user: nothing for Pressure.
    ctx.battlerIdTarget = 0;
    assert(PressurePP(&bs, &ctx, MOVE_METRONOME) == 0);
    // Its Tackle, aimed at a Pressure holder, costs Metronome a PP more.
    ctx.moveNoCur = MOVE_TACKLE; ctx.battlerIdTarget = 1;
    ChargeCallerPressure(&bs, &ctx);
    assert(ctx.battleMons[0].movePPCur[1] == 8 && ctx.copies == 1);
    // Its Surf, one for each of the two holders around it.
    ctx.moveNoCur = MOVE_SURF;
    ChargeCallerPressure(&bs, &ctx);
    assert(ctx.battleMons[0].movePPCur[1] == 6);
    // A Tackle at a Pokemon without it, nothing.
    ctx.moveNoCur = MOVE_TACKLE; ctx.battlerIdTarget = 2;
    ChargeCallerPressure(&bs, &ctx);
    assert(ctx.battleMons[0].movePPCur[1] == 6 && ctx.copies == 2);
    return 0;
}
"""


NOTED = r"""
#include <assert.h>
#include <stdint.h>
typedef uint8_t u8;
typedef uint16_t u16;
typedef uint32_t u32;
typedef int BOOL;
enum { FALSE = 0, TRUE = 1 };
#include "constants/battle.h"
#include "constants/battle_menu.h"
#include "constants/battle_script_imports.h"
#include "constants/moves.h"
typedef struct { int unused; } BattleSystem;
typedef struct { u16 hp; u16 moves[4]; } BattleMon;
typedef struct { int inputSelection; } PlayerAction;
typedef struct { u8 struggleFlag, forceExecutionOrder; } TurnData;
typedef struct {
    BattleMon battleMons[4];
    PlayerAction playerActions[4];
    TurnData turnData[4];
    u8 movePos[4];
    int battlerIdAttacker, categories, echoedVoiceUsed;
    u32 unk_2184, roundUsers;
    u16 moveNoCur, moveUsedLast, moveUsedBefore;
} BattleContext;
static int BattleSystem_GetMaxBattlers(BattleSystem *bs) { (void)bs; return 4; }
static u32 MaskOfFlagNo(int n) { return 1u << n; }
static BOOL ov12_0225561C(BattleContext *ctx, int battlerId) { (void)ctx; (void)battlerId; return FALSE; }
static void ChooseMoveCategory(BattleSystem *bs, BattleContext *ctx) { (void)bs; ctx->categories++; }
@FUNCTIONS@
int main(void) {
    BattleSystem bs = { 0 };
    BattleContext ctx = { 0 };
    // Thunderbolt, then a Metronome that calls Fusion Bolt: Metronome is
    // noted as it is used, and the move it calls in its place.
    ctx.moveNoCur = MOVE_THUNDERBOLT; NoteMoveUsed(&bs, &ctx);
    ctx.moveNoCur = MOVE_METRONOME; NoteMoveUsed(&bs, &ctx);
    assert(ctx.moveUsedLast == MOVE_METRONOME && ctx.moveUsedBefore == MOVE_THUNDERBOLT);
    ctx.unk_2184 = MULTIHIT_SKIP_OBEDIENCE_CHECK | MULTIHIT_SKIP_STATUS_CHECK | MULTIHIT_CALLED_MOVE;
    ctx.moveNoCur = MOVE_FUSION_BOLT; NoteMoveUsed(&bs, &ctx);
    assert(ctx.moveUsedLast == MOVE_FUSION_BOLT && ctx.moveUsedBefore == MOVE_THUNDERBOLT);
    assert(ctx.categories == 3);
    // The next move sees Fusion Bolt as the move before it.
    ctx.unk_2184 = 0;
    ctx.moveNoCur = MOVE_FUSION_FLARE; NoteMoveUsed(&bs, &ctx);
    assert(ctx.moveUsedBefore == MOVE_FUSION_BOLT);
    // A called Echoed Voice counts.
    ctx.unk_2184 = MULTIHIT_CALLED_MOVE;
    ctx.moveNoCur = MOVE_ECHOED_VOICE; NoteMoveUsed(&bs, &ctx);
    assert(ctx.echoedVoiceUsed);
    // A spread move's later targets note nothing.
    ctx.unk_2184 = 13;
    ctx.moveNoCur = MOVE_SURF; NoteMoveUsed(&bs, &ctx);
    assert(ctx.moveUsedLast == MOVE_ECHOED_VOICE);
    return 0;
}
"""


if __name__ == "__main__":
    unittest.main()
