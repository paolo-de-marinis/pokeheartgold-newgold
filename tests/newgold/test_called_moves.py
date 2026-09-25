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
        # The PP and Pressure were the calling move's; the Metronome item
        # counted the calling move once; the calling move was the one noted.
        controller = CONTROLLER.read_text()
        steps = function(controller, "ov12_0224C38C")
        self.assertIn("!(ctx->unk_2184 & (MULTIHIT_SKIP_PP_DECREMENT | MULTIHIT_CALLED_MOVE)) && ov12_0224B1FC(", steps)
        # Nor a spread move's later targets, which come back with unk_2184 at
        # 13: one use, one count (Pokemon Central, Plessimetro).
        self.assertRegex(steps, r"if \(!\(ctx->unk_2184 & MULTIHIT_CALLED_MOVE\) && ctx->unk_2184 != MULTIHIT_HIT_MULTIPLE_TARGETS\) \{\n\s+ov12_022565E0\(battleSystem, ctx\);")
        self.assertIn("ctx->unk_2184 = 13;", function(controller, "ov12_0224D03C"))
        noted = function(controller, "NoteMoveUsed")
        called = noted.index("if (ctx->unk_2184 & MULTIHIT_CALLED_MOVE) {")
        self.assertLess(called, noted.index("ctx->moveUsedBefore"))
        # But a called Photon Geyser or Shell Side Arm chooses its category
        # (Pokemon Central, Geyser Fotonico, Armaguscio).
        self.assertIn("ChooseMoveCategory(battleSystem, ctx);\n        return;", noted[called:])
        # Parental Bond starts for the called move where it does for a
        # chosen one, once the steps are through: CallMove leaves the PP flag
        # TryStartParentalBond asks off.
        self.assertLess(steps.index("TryStartParentalBond(battleSystem, ctx);"),
                        steps.index("ReadBattleScriptFromNarc(ctx, NARC_a_0_0_0, ctx->moveNoCur);"))


if __name__ == "__main__":
    unittest.main()
