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
    int battlerIdAttacker; u32 battleStatus, moveStatusFlag; u16 moveNoCur; u16 moveNoMetronome[4];
    BattleMon battleMons[4]; SelfTurnData selfTurnData[4];
} BattleContext;
typedef int BOOL;
#define TRUE 1
#define FALSE 0
static int GetBattlerHeldItemEffect(BattleContext *ctx, int battlerId) { (void)ctx; (void)battlerId; return HOLD_EFFECT_BOOST_REPEATED; }
@FUNCTIONS@
int main(void) {
    BattleContext ctx;
    memset(&ctx, 0, sizeof(ctx));
    ctx.moveNoCur = ctx.moveNoMetronome[0] = MOVE_EARTHQUAKE;
    // A third Earthquake in a row that hit one foe and not the Flying-type
    // after it keeps its count; one that hit nothing starts it over, the
    // next Earthquake being a first (Plessimetro, from the fifth generation).
    ctx.battleMons[0].unk88.metronomeTurns = 2;
    ctx.moveStatusFlag = MOVE_STATUS_NO_EFFECT;
    ctx.selfTurnData[0].metronomeLanded = 1;
    ov12_02256694(0, &ctx);
    ctx.moveStatusFlag = 0;
    ov12_022565E0(0, &ctx);
    assert(ctx.battleMons[0].unk88.metronomeTurns == 3);
    ctx.moveStatusFlag = MOVE_STATUS_NO_EFFECT;
    ctx.selfTurnData[0].metronomeLanded = 0;
    ov12_02256694(0, &ctx);
    ctx.moveStatusFlag = 0;
    ov12_022565E0(0, &ctx);
    assert(ctx.battleMons[0].unk88.metronomeTurns == 0 && ctx.moveNoMetronome[0] == MOVE_EARTHQUAKE);
    // A first use that missed is no first of a run either; one that hit is.
    ctx.moveStatusFlag = MOVE_STATUS_MISSED;
    ov12_02256694(0, &ctx);
    ctx.moveStatusFlag = 0;
    ov12_022565E0(0, &ctx);
    assert(ctx.battleMons[0].unk88.metronomeTurns == 0);
    ov12_02256694(0, &ctx);
    ov12_022565E0(0, &ctx);
    assert(ctx.battleMons[0].unk88.metronomeTurns == 1);
    ov12_02256694(0, &ctx);

    // A charge move's hit is its use: the charge turn's count goes back once
    // it is over, and the first hit is worth 1.2, the second use's 1.4
    // (Plessimetro, from the fifth generation). Before, the charge turn
    // counted and the hit did not: 1.0, then 1.2.
    ctx.moveNoCur = MOVE_SOLAR_BEAM;
    for (int use = 1; use <= 2; use++) {
        ov12_022565E0(0, &ctx);
        ctx.battleStatus = BATTLE_STATUS_CHARGE_TURN;
        ov12_02256694(0, &ctx);
        ctx.battleStatus = 0;
        assert(ctx.battleMons[0].unk88.metronomeTurns == use - 1);
        ov12_022565E0(0, &ctx);
        assert(ctx.battleMons[0].unk88.metronomeTurns == use);
        ov12_02256694(0, &ctx);
    }
    // Outrage's and Rollout's forced turns count, each as a use in a row
    // (Showdown's gen-9 item); a forced turn that fails starts it over.
    ctx.moveNoCur = MOVE_OUTRAGE;
    ctx.battleMons[0].status2 = STATUS2_RAMPAGE;
    for (int turn = 0; turn < 3; turn++) {
        ov12_022565E0(0, &ctx);
        assert(ctx.battleMons[0].unk88.metronomeTurns == turn);
        ov12_02256694(0, &ctx);
    }
    ctx.moveNoCur = MOVE_ROLLOUT;
    ctx.battleMons[0].status2 = STATUS2_LOCKED_INTO_MOVE;
    ov12_022565E0(0, &ctx);
    ov12_022565E0(0, &ctx);
    assert(ctx.battleMons[0].unk88.metronomeTurns == 1);
    ctx.moveStatusFlag = MOVE_STATUS_MISSED;
    ov12_02256694(0, &ctx);
    ctx.moveStatusFlag = 0;
    ov12_022565E0(0, &ctx);
    assert(ctx.battleMons[0].unk88.metronomeTurns == 0);

    // A move another calls is counted, not the move calling it (Showdown's
    // gen-9 item): a Copycat that copies the Tackle used the turn before
    // goes on with its run, and Metronome twice is a run only if it calls
    // one move twice. Before, the caller was counted and the called move
    // not: Tackle then Copycat's Tackle started over, any two Metronomes ran.
    ctx.battleMons[0].status2 = 0;
    ctx.moveNoCur = MOVE_TACKLE;
    ov12_022565E0(0, &ctx);
    ov12_02256694(0, &ctx);
    ctx.moveNoCur = MOVE_COPYCAT;
    ov12_022565E0(0, &ctx);
    ctx.moveNoCur = MOVE_TACKLE;
    ov12_022565E0(0, &ctx);
    ov12_02256694(0, &ctx);
    assert(ctx.battleMons[0].unk88.metronomeTurns == 1 && ctx.moveNoMetronome[0] == MOVE_TACKLE);
    ctx.moveNoCur = MOVE_METRONOME;
    ov12_022565E0(0, &ctx);
    ctx.moveNoCur = MOVE_EMBER;
    ov12_022565E0(0, &ctx);
    ov12_02256694(0, &ctx);
    ctx.moveNoCur = MOVE_NATURE_POWER;
    ov12_022565E0(0, &ctx);
    ctx.moveNoCur = MOVE_EMBER;
    ov12_022565E0(0, &ctx);
    ov12_02256694(0, &ctx);
    assert(ctx.battleMons[0].unk88.metronomeTurns == 1 && ctx.moveNoMetronome[0] == MOVE_EMBER);
    ctx.moveNoCur = MOVE_METRONOME;
    ov12_022565E0(0, &ctx);
    ctx.moveNoCur = MOVE_WATER_GUN;
    ov12_022565E0(0, &ctx);
    assert(ctx.battleMons[0].unk88.metronomeTurns == 0);
    ov12_02256694(0, &ctx);
    // A calling move that fails with nothing to call is a failed use: the
    // next use of the move before it starts over (moveLastTurnResult).
    ctx.moveNoCur = MOVE_COPYCAT;
    ov12_022565E0(0, &ctx);
    ctx.moveStatusFlag = MOVE_STATUS_FAILED;
    ov12_02256694(0, &ctx);
    ctx.moveStatusFlag = 0;
    assert(ctx.moveNoMetronome[0] == MOVE_NONE);
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
        run_c(self.METRONOME_ITEM.replace("@FUNCTIONS@", function(overlay, "CheckMoveCallsOtherMove")
                                          + function(overlay, "ov12_022565E0") + function(overlay, "ov12_02256694")))
        loop = function(controller, "ov12_0224D03C")
        self.assertLess(loop.index("ctx->selfTurnData[ctx->battlerIdAttacker].metronomeLanded = TRUE;"), loop.index("BATTLE_STATUS2_MAGIC_COAT"))
        self.assertIn("if (!(ctx->moveStatusFlag & MOVE_STATUS_FAIL)) {\n        ctx->selfTurnData[ctx->battlerIdAttacker].metronomeLanded = TRUE;", loop)

    CALLERS = r"""
#include <assert.h>
#include <stdint.h>
#include "constants/moves.h"
typedef uint16_t u16;
typedef int BOOL;
#define TRUE 1
#define FALSE 0
@FUNCTIONS@
int main(void) {
    static const u16 callers[] = { MOVE_METRONOME, MOVE_MIRROR_MOVE, MOVE_SLEEP_TALK, MOVE_NATURE_POWER, MOVE_ASSIST,
        MOVE_COPYCAT, MOVE_ME_FIRST };
    for (unsigned i = 0; i < sizeof(callers) / sizeof(*callers); i++) {
        assert(CheckMoveCallsOtherMove(callers[i]));
    }
    assert(!CheckMoveCallsOtherMove(MOVE_TACKLE) && !CheckMoveCallsOtherMove(MOVE_INSTRUCT));
    return 0;
}
"""

    def test_the_moves_that_call_another_are_showdown_s_seven(self):
        # Nature Power among them, which retail's list left out: Instruct
        # does not have it used again (Pokemon Central, Imposizione), and the
        # Metronome item passes over it for the move it calls (Showdown's
        # gen-9 callsMove: Metronome, Mirror Move, Sleep Talk, Nature Power,
        # Assist, Copycat, Me First).
        run_c(self.CALLERS.replace("@FUNCTIONS@", function((ROOT / "src/battle/overlay_12_0224E4FC.c").read_text(), "CheckMoveCallsOtherMove")))

    def test_mirror_move_s_copy_does_too(self):
        body = function(COMMANDS.read_text(), "BtlCmd_SetMirrorMove")
        self.assertIn("return CallMove(ctx);", body)
        self.assertNotIn("NARC_a_0_0_0", body)

    def test_the_steps_skip_the_caller_s_pp_and_count_the_called_move(self):
        # The PP was the calling move's; the Metronome item counts the move
        # called, which comes through the steps (ov12_022565E0 passes over
        # the caller).
        controller = CONTROLLER.read_text()
        steps = function(controller, "ov12_0224C38C")
        self.assertIn("!(ctx->unk_2184 & (MULTIHIT_SKIP_PP_DECREMENT | MULTIHIT_CALLED_MOVE)) && ov12_0224B1FC(", steps)
        # Not a spread move's later targets, which come back with unk_2184 at
        # 13: one use, one count (Pokemon Central, Plessimetro).
        self.assertRegex(steps, r"if \(ctx->unk_2184 != MULTIHIT_HIT_MULTIPLE_TARGETS\) \{\n\s+ov12_022565E0\(battleSystem, ctx\);")
        self.assertIn("ctx->unk_2184 = 13;", function(controller, "ov12_0224D03C"))
        # Parental Bond starts for the called move where it does for a
        # chosen one, once the steps are through: CallMove leaves the PP flag
        # TryStartParentalBond asks off.
        self.assertLess(steps.index("TryStartParentalBond(battleSystem, ctx);"),
                        steps.index("ReadBattleScriptFromNarc(ctx, NARC_a_0_0_0, ctx->moveNoCur);"))

    def test_gravity_and_heal_block_stop_the_called_move(self):
        # From the fifth generation Metronome, Copycat and Assist call a move
        # Gravity or Heal Block would stop, and it fails as it is used
        # (Pokemon Central, Metronomo; Showdown's gen-9 gravity and healblock
        # onModifyMove): the called move goes past what stops its user acting
        # but not past these two. The call itself no longer asks them.
        steps = function(CONTROLLER.read_text(), "ov12_0224C38C")
        self.assertRegex(steps, r"if \(\(ctx->unk_2184 & MULTIHIT_CALLED_MOVE\)\n\s+&& \(MoveStoppedByGravityOrHealBlock\(battleSystem, ctx\) == TRUE"
                                r" \|\| MoveStoppedByThroatChop\(ctx\) == TRUE\)\) \{\n"
                                r"\s+ctx->battleStatus \|= BATTLE_STATUS_CHECK_LOOP_ONLY_ONCE;\n\s+ctx->moveStatusFlag \|= MOVE_STATUS_NO_MORE_WORK;\n\s+return;")
        self.assertLess(steps.index("ov12_0224B528(battleSystem, ctx)"), steps.index("MoveStoppedByGravityOrHealBlock"))
        self.assertLess(steps.index("MoveStoppedByGravityOrHealBlock"), steps.index("TryDisobedience"))
        called = function((ROOT / "src/battle/overlay_12_0224E4FC.c").read_text(), "CheckLegalCalledMove")
        self.assertNotIn("Gravity", called)
        self.assertNotIn("HealBlocked", called)

    def test_throat_chop_stops_a_called_sound_move(self):
        # From the seventh generation a sound move another calls under Throat
        # Chop is called and fails (Pokemon Central, Sonnolalia; Showdown's
        # gen-9 throatchop onModifyMove), as a chosen one is refused among
        # what stops a Pokemon acting; one check serves both.
        controller = CONTROLLER.read_text()
        stop = function(controller, "MoveStoppedByThroatChop")
        self.assertIn("!ctx->moveConditions[ctx->battlerIdAttacker].throatChopTimer || !BattleMoveIsSoundBased(ctx->moveNoCur)", stop)
        self.assertIn("BATTLE_SUBSCRIPT_MOVE_FAIL_THROAT_CHOP", stop)
        self.assertIn("if (MoveStoppedByThroatChop(ctx) == TRUE) {\n                ret = 1;", function(controller, "ov12_0224B528"))
        self.assertIn("MoveStoppedByThroatChop(ctx) == TRUE", function(controller, "ov12_0224C38C"))

    def test_sleep_talk_calls_what_its_user_could_not_choose(self):
        # From the fifth generation (Pokemon Central, Sonnolalia; Showdown's
        # gen-9 sleeptalk): a Disabled move, one Torment or Imprison holds
        # back, one Gravity, Heal Block or Throat Chop stops (it fails as it
        # is used), and Sleep Talk again under a Choice item or an Encore of
        # it. The real StruggleCheck is beside it, so asking it again fails.
        overlay, commands = (ROOT / "src/battle/overlay_12_0224E4FC.c").read_text(), COMMANDS.read_text()
        start = commands.index("static const u16 sSleepTalkUncallable[]")
        code = "\n".join((function(overlay, "CheckMoveCallsOtherMove"), function(overlay, "StruggleCheck"),
                          commands[start:commands.index("};", start) + 2], function(commands, "SleepTalkCannotCall"),
                          function(commands, "BtlCmd_TrySleepTalk")))
        run_c(SLEEP_TALK_PICK.replace("@FUNCTIONS@", code))

    def test_the_called_move_is_noted_as_the_move_used(self):
        run_c(NOTED.replace("@FUNCTIONS@", function(CONTROLLER.read_text(), "NoteMoveUsed")))

    def test_pressure_charges_the_caller_for_the_move_called(self):
        controller = CONTROLLER.read_text()
        run_c(PRESSURE.replace("@FUNCTIONS@", function(controller, "PressurePP") + function(controller, "ChargeCallerPressure")))
        steps = function(controller, "ov12_0224C38C")
        self.assertIn("if ((ctx->unk_2184 & (MULTIHIT_SKIP_PP_DECREMENT | MULTIHIT_CALLED_MOVE)) == MULTIHIT_CALLED_MOVE) {\n"
                      "            ChargeCallerPressure(battleSystem, ctx);", steps)

    def test_pressure_counts_where_lightning_rod_draws_a_chosen_move(self):
        # The engine redirects, then spends the PP (BEFORE_MOVE_STATE_REDIRECT_TARGET
        # before BEFORE_MOVE_STATE_DECREMENT_PP at d0380a487), as a called
        # move's BtlCmd_GoToMoveScript does: Pressure is counted at the
        # Pokemon Lightning Rod or Storm Drain has drawn the move to.
        steps = function(CONTROLLER.read_text(), "ov12_0224C38C")
        redirect = "ov12_02250A18(battleSystem, ctx, ctx->battlerIdAttacker, ctx->moveNoCur);"
        self.assertEqual(steps.count(redirect), 1)
        self.assertLess(steps.index("TryStanceChange(battleSystem, ctx)"), steps.index(redirect))
        self.assertLess(steps.index(redirect), steps.index("ov12_0224B1FC(battleSystem, ctx)"))
        self.assertLess(steps.index(redirect), steps.index("ChargeCallerPressure(battleSystem, ctx);"))
        self.assertLess(steps.index(redirect), steps.index("ov12_0224C204(battleSystem, ctx)"))


# BtlCmd_TrySleepTalk with the real StruggleCheck: a sleeper knowing Sleep Talk
# and Tackle, under each thing that keeps a move from being chosen.
SLEEP_TALK_PICK = r"""
#include <assert.h>
#include <stdint.h>
typedef uint8_t u8;
typedef uint16_t u16;
typedef uint32_t u32;
typedef int BOOL;
enum { FALSE = 0, TRUE = 1 };
#define NELEMS(a) (sizeof(a) / sizeof(*(a)))
#define MAX_MON_MOVES 4
#include "constants/battle.h"
#include "constants/moves.h"
#include "constants/abilities.h"
#include "constants/move_effects.h"
#include "constants/items.h"
typedef struct { int unused; } BattleSystem;
typedef struct { int effect, power, category; } MoveTbl;
typedef struct { u16 disabledMove, encoredMove, moveNoChoice; u8 tauntTurns; } Unk88;
typedef struct { u16 moves[4]; u8 movePPCur[4]; u32 status2; Unk88 unk88; } BattleMon;
typedef struct { u8 throatChopTimer; } MoveConditions;
typedef struct {
    BattleMon battleMons[4];
    int battlerIdAttacker, item, selectedMonIndex[4];
    u32 moveTemp;
    MoveTbl move;
    u16 moveNoBattlerPrev[4];
    MoveConditions moveConditions[4];
    u8 berryEaten[4][6];
} BattleContext;
static int sBlocked;  // the move Imprison, Gravity or Heal Block holds back
static u32 sRandom;
static MoveTbl *BattleMoveTbl(BattleContext *ctx, int move) {
    ctx->move.effect = 0;
    ctx->move.power = move == MOVE_TACKLE;
    ctx->move.category = 0;
    return &ctx->move;
}
static void BattleScriptIncrementPointer(BattleContext *ctx, int n) { (void)ctx; (void)n; }
static int BattleScriptReadWord(BattleContext *ctx) { (void)ctx; return 0; }
static u32 MaskOfFlagNo(int flag) { return 1u << flag; }
static u32 BattleSystem_Random(BattleSystem *bs) { (void)bs; return sRandom++; }
static int GetBattlerHeldItemEffect(BattleContext *ctx, int b) { (void)b; return ctx->item; }
static int GetBattlerAbility(BattleContext *ctx, int b) { (void)ctx; (void)b; return ABILITY_NONE; }
static BOOL BattleMoveIsSoundBased(u32 m) { return (int)m == sBlocked; }
static BOOL BattleContext_CheckMoveImprisoned(BattleSystem *bs, BattleContext *c, int b, int m) { (void)bs; (void)c; (void)b; return m == sBlocked; }
static BOOL BattleContext_CheckMoveUnuseableInGravity(BattleSystem *bs, BattleContext *c, int b, int m) { (void)bs; (void)c; (void)b; return m == sBlocked; }
static BOOL BattleContext_CheckMoveHealBlocked(BattleSystem *bs, BattleContext *c, int b, int m) { (void)bs; (void)c; (void)b; return m == sBlocked; }
static int BattleMon_GetMoveIndex(BattleMon *mon, u16 move) {
    for (int i = 0; i < 4; i++) {
        if (mon->moves[i] == move) {
            return i;
        }
    }
    return 4;
}
static BOOL BattleCtx_IsIdenticalToCurrentMove(BattleContext *c, u16 m) { (void)c; (void)m; return FALSE; }
static BOOL IsChargeTurnEffect(int e) { (void)e; return FALSE; }
@FUNCTIONS@
static u32 Called(BattleContext *ctx) {
    BattleSystem bs;
    ctx->moveTemp = MOVE_NONE;
    BtlCmd_TrySleepTalk(&bs, ctx);
    return ctx->moveTemp;
}
int main(void) {
    BattleContext base = { 0 }, ctx;
    base.battleMons[0].moves[0] = MOVE_SLEEP_TALK;
    base.battleMons[0].moves[1] = MOVE_TACKLE;
    base.battleMons[0].movePPCur[0] = base.battleMons[0].movePPCur[1] = 10;
    ctx = base;
    assert(Called(&ctx) == MOVE_TACKLE);
    // Its second turn locked into Sleep Talk by a Choice Band, or encored
    // into it: before, every other move was refused and it failed.
    ctx = base;
    ctx.item = HOLD_EFFECT_CHOICE_ATK;
    ctx.battleMons[0].unk88.moveNoChoice = MOVE_SLEEP_TALK;
    assert(Called(&ctx) == MOVE_TACKLE);
    ctx = base;
    ctx.battleMons[0].unk88.encoredMove = MOVE_SLEEP_TALK;
    assert(Called(&ctx) == MOVE_TACKLE);
    ctx = base;
    ctx.battleMons[0].unk88.disabledMove = MOVE_TACKLE;
    assert(Called(&ctx) == MOVE_TACKLE);
    ctx = base;
    ctx.battleMons[0].status2 = STATUS2_TORMENT;
    ctx.moveNoBattlerPrev[0] = MOVE_TACKLE;
    assert(Called(&ctx) == MOVE_TACKLE);
    // Imprisoned, under Gravity or Heal Block, a sound move under Throat Chop.
    ctx = base;
    sBlocked = MOVE_TACKLE;
    ctx.moveConditions[0].throatChopTimer = 2;
    assert(Called(&ctx) == MOVE_TACKLE);
    sBlocked = MOVE_NONE;
    ctx = base;
    ctx.battleMons[0].movePPCur[1] = 0;
    assert(Called(&ctx) == MOVE_TACKLE);
    // Nothing else known: nothing to call.
    ctx = base;
    ctx.battleMons[0].moves[1] = MOVE_NONE;
    assert(Called(&ctx) == MOVE_NONE);
    return 0;
}
"""

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
