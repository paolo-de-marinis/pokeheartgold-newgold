#!/usr/bin/env python3
"""Protect's family: what each guard stops, and how the team guards go up.

Wide Guard, Quick Guard, Mat Block and Crafty Shield (MOVE_EFFECT_PROTECT_USER_SIDE)
used to set no flag at all, and King's Shield, Obstruct, Silk Trap and Burning
Bulwark stopped status moves they let through in the reference; none of the
six shields handed anything back to a move that touched it. The real
functions are extracted from src/battle and compiled natively.
"""

import os
from pathlib import Path
import shlex
import subprocess
import tempfile
import unittest

from test_repels import ROOT, function, read

FIXTURE = r"""
#include <assert.h>
#include <stdint.h>
#include <string.h>
#include "constants/moves.h"
#include "constants/move_effects.h"
#include "constants/message_tags.h"
typedef uint8_t u8;
typedef int8_t s8;
typedef uint16_t u16;
typedef uint32_t u32;
typedef int BOOL;
#define TRUE 1
#define FALSE 0
#define NELEMS(a) (sizeof(a) / sizeof(*(a)))
#define msg_0197_00282 282
#define msg_0197_00442 442
#define msg_0197_01565 1565

typedef struct { u16 effect; u8 category; u16 range; s8 priority; } MoveTbl;
typedef struct { u32 protectFlag : 1; u32 endureFlag : 1; u32 gainedProtectFlagFromAlly : 1; } TurnData;
typedef struct { struct { u32 protectSuccessTurns : 2; } unk88; } BattleMon;
typedef struct { u16 id; int tag; int param[4]; } BattleMessage;
typedef struct {
    int battlerIdAttacker, battlerIdTarget, battlersOnField, moveTemp;
    u16 moveNoCur;
    u16 moveNoProtect[4];
    BattleMon battleMons[4];
    TurnData turnData[4];
    BattleMessage buffMsg;
} BattleContext;
typedef struct BattleSystem BattleSystem;

static MoveTbl sMoves[MOVE_BURNING_BULWARK + 1];
static int sRolls;
static u16 sProtectSuccessChance[4] = { 0xFFFF, 0x7FFF, 0x3FFF, 0x1FFF };

static const MoveTbl *BattleMoveTbl(BattleContext *ctx, u32 move) { (void)ctx; return &sMoves[move]; }
static s8 BattlerMovePriority(BattleContext *ctx, int battlerId, u16 move) { (void)ctx; (void)battlerId; return sMoves[move].priority; }
static u32 BattleSystem_Random(BattleSystem *bs) { (void)bs; sRolls++; return 0; }
static void BattleScriptIncrementPointer(BattleContext *ctx, int n) { (void)ctx; (void)n; }
static int BattleScriptReadWord(BattleContext *ctx) { (void)ctx; return 0; }
static int CreateNicknameTag(BattleContext *ctx, int battlerId) { (void)ctx; return battlerId; }

@TEAM_GUARD@
@TEAM_GUARD_MOVE@
@STOPS@
@TRY@
@FEINT@

static void use(BattleContext *ctx, int battler, u16 move) {
    ctx->battlerIdAttacker = battler;
    ctx->moveNoCur = move;
    BtlCmd_TryProtection(0, ctx);
    ctx->moveNoProtect[battler] = move;
}

int main(void) {
    static const u16 protects[] = { MOVE_PROTECT, MOVE_DETECT, MOVE_SPIKY_SHIELD, MOVE_BANEFUL_BUNKER,
        MOVE_KINGS_SHIELD, MOVE_OBSTRUCT, MOVE_SILK_TRAP, MOVE_BURNING_BULWARK, MOVE_MAX_GUARD };
    for (unsigned i = 0; i < NELEMS(protects); i++) sMoves[protects[i]].effect = MOVE_EFFECT_PROTECT;
    sMoves[MOVE_ENDURE].effect = MOVE_EFFECT_SURVIVE_WITH_1_HP;
    sMoves[MOVE_WIDE_GUARD].effect = sMoves[MOVE_QUICK_GUARD].effect = MOVE_EFFECT_PROTECT_USER_SIDE;
    sMoves[MOVE_MAT_BLOCK].effect = sMoves[MOVE_CRAFTY_SHIELD].effect = MOVE_EFFECT_PROTECT_USER_SIDE;
    sMoves[MOVE_TACKLE].category = 0;
    sMoves[MOVE_GROWL].category = CATEGORY_STATUS;
    sMoves[MOVE_GROWL].range = RANGE_ADJACENT_OPPONENTS;
    sMoves[MOVE_EARTHQUAKE].range = RANGE_ALL_ADJACENT;
    sMoves[MOVE_QUICK_ATTACK].priority = 1;

    BattleContext ctx;
    // Each guard stops what the reference's CheckProtectedBySelf says it does.
    assert(GuardStopsMove(&ctx, 0, MOVE_TACKLE, MOVE_PROTECT, TRUE));
    assert(GuardStopsMove(&ctx, 0, MOVE_GROWL, MOVE_PROTECT, TRUE));
    assert(GuardStopsMove(&ctx, 0, MOVE_TACKLE, MOVE_KINGS_SHIELD, TRUE));
    assert(!GuardStopsMove(&ctx, 0, MOVE_GROWL, MOVE_KINGS_SHIELD, TRUE));
    assert(!GuardStopsMove(&ctx, 0, MOVE_GROWL, MOVE_BURNING_BULWARK, TRUE));
    assert(GuardStopsMove(&ctx, 0, MOVE_GROWL, MOVE_CRAFTY_SHIELD, TRUE));
    assert(!GuardStopsMove(&ctx, 0, MOVE_TACKLE, MOVE_CRAFTY_SHIELD, TRUE));
    assert(GuardStopsMove(&ctx, 0, MOVE_TACKLE, MOVE_MAT_BLOCK, TRUE));
    assert(!GuardStopsMove(&ctx, 0, MOVE_GROWL, MOVE_MAT_BLOCK, TRUE));
    assert(GuardStopsMove(&ctx, 0, MOVE_QUICK_ATTACK, MOVE_QUICK_GUARD, TRUE));
    assert(!GuardStopsMove(&ctx, 0, MOVE_TACKLE, MOVE_QUICK_GUARD, TRUE));
    assert(GuardStopsMove(&ctx, 0, MOVE_EARTHQUAKE, MOVE_WIDE_GUARD, TRUE));
    assert(GuardStopsMove(&ctx, 0, MOVE_GROWL, MOVE_WIDE_GUARD, TRUE));
    assert(!GuardStopsMove(&ctx, 0, MOVE_TACKLE, MOVE_WIDE_GUARD, TRUE));
    // An ally's Protect guards nobody else; its Wide Guard does.
    assert(!GuardStopsMove(&ctx, 0, MOVE_TACKLE, MOVE_PROTECT, FALSE));
    assert(!GuardStopsMove(&ctx, 0, MOVE_TACKLE, MOVE_KINGS_SHIELD, FALSE));
    assert(GuardStopsMove(&ctx, 0, MOVE_EARTHQUAKE, MOVE_WIDE_GUARD, FALSE));
    assert(!GuardStopsMove(&ctx, 0, MOVE_TACKLE, MOVE_NONE, TRUE));

    // Wide Guard goes up on the user and its ally, and says so for the side.
    memset(&ctx, 0, sizeof(ctx));
    ctx.battlersOnField = 2;
    sRolls = 0;
    use(&ctx, 1, MOVE_WIDE_GUARD);
    assert(sRolls == 0);
    assert(ctx.turnData[1].protectFlag && !ctx.turnData[1].gainedProtectFlagFromAlly);
    assert(ctx.turnData[3].protectFlag && ctx.turnData[3].gainedProtectFlagFromAlly);
    assert(ctx.buffMsg.id == msg_0197_01565 && ctx.buffMsg.tag == TAG_MOVE_SIDE);
    assert(ctx.buffMsg.param[0] == MOVE_WIDE_GUARD && ctx.buffMsg.param[1] == 1);
    assert(ctx.battleMons[1].unk88.protectSuccessTurns == 1);
    // A Protect straight after counts as a second in a row and rolls for it.
    use(&ctx, 1, MOVE_PROTECT);
    assert(sRolls == 1 && ctx.battleMons[1].unk88.protectSuccessTurns == 2);
    // Its own Protect is its own guard, not the one it was lent.
    use(&ctx, 3, MOVE_PROTECT);
    assert(ctx.turnData[3].protectFlag && !ctx.turnData[3].gainedProtectFlagFromAlly);

    // An ally that already has a guard up keeps it as its own.
    memset(&ctx, 0, sizeof(ctx));
    ctx.battlersOnField = 2;
    use(&ctx, 2, MOVE_PROTECT);
    use(&ctx, 0, MOVE_QUICK_GUARD);
    assert(ctx.turnData[2].protectFlag && !ctx.turnData[2].gainedProtectFlagFromAlly);

    // Mat Block and Crafty Shield do not add to the count; Quick Guard does.
    memset(&ctx, 0, sizeof(ctx));
    ctx.battlersOnField = 2;
    use(&ctx, 0, MOVE_MAT_BLOCK);
    use(&ctx, 0, MOVE_CRAFTY_SHIELD);
    assert(ctx.battleMons[0].unk88.protectSuccessTurns == 0);
    use(&ctx, 0, MOVE_QUICK_GUARD);
    assert(ctx.battleMons[0].unk88.protectSuccessTurns == 1);
    // Any other move in between starts the count again.
    ctx.moveNoProtect[0] = MOVE_TACKLE;
    use(&ctx, 0, MOVE_KINGS_SHIELD);
    assert(ctx.battleMons[0].unk88.protectSuccessTurns == 1);

    // Feint through a team guard lifts it from both battlers it covers,
    // whichever of the two it hits.
    memset(&ctx, 0, sizeof(ctx));
    ctx.battlersOnField = 2;
    use(&ctx, 1, MOVE_WIDE_GUARD);
    ctx.battlerIdTarget = 3;
    BtlCmd_TryFeint(0, &ctx);
    assert(!ctx.turnData[1].protectFlag && !ctx.turnData[3].gainedProtectFlagFromAlly);
    memset(&ctx, 0, sizeof(ctx));
    ctx.battlersOnField = 2;
    use(&ctx, 1, MOVE_WIDE_GUARD);
    ctx.battlerIdTarget = 1;
    BtlCmd_TryFeint(0, &ctx);
    assert(!ctx.turnData[3].protectFlag);
    return 0;
}
"""


CONTACT_FIXTURE = r"""
#include <assert.h>
#include <stddef.h>
#include <stdint.h>
#include <string.h>
#include "constants/abilities.h"
#include "constants/battle.h"
#include "constants/battle_subscript.h"
#include "constants/moves.h"
#include "constants/pokemon.h"
typedef uint8_t u8;
typedef uint16_t u16;
typedef uint32_t u32;
typedef int BOOL;
#define TRUE 1
#define FALSE 0
enum { NARC_a_0_0_1 = 1 };
#pragma GCC diagnostic ignored "-Wunknown-pragmas"

typedef struct { u32 gainedProtectFlagFromAlly : 1; } TurnData;
typedef struct { int hp, maxHp; u32 status; int statChanges[8]; int ability, type1, type2; } BattleMon;
typedef struct {
    int battlerIdAttacker, battlerIdTarget, battlerIdTemp, battlerIdStatChange;
    int statChangeParam, statChangeType, hpCalc;
    u32 battleStatus;
    u16 moveNoCur;
    u16 moveNoProtect[4];
    BattleMon battleMons[4];
    TurnData turnData[4];
} BattleContext;
typedef struct BattleSystem BattleSystem;

static BOOL sContact;
static int sSubscript;
static BOOL BattleMoveMakesContact(BattleContext *ctx, u32 move) { (void)ctx; (void)move; return sContact; }
static int GetBattlerAbility(BattleContext *ctx, int battlerId) { return ctx->battleMons[battlerId].ability; }
static int GetBattlerVar(BattleContext *ctx, int battlerId, u32 varId, void *data) {
    (void)data;
    return varId == BMON_DATA_TYPE_1 ? ctx->battleMons[battlerId].type1 : ctx->battleMons[battlerId].type2;
}
static int DamageDivide(int num, int denom) { return num / denom; }
static void BattleScriptIncrementPointer(BattleContext *ctx, int n) { (void)ctx; (void)n; }
static void BattleScriptGotoSubscript(BattleContext *ctx, int narc, int script) { (void)ctx; assert(narc == NARC_a_0_0_1); sSubscript = script; }

@CONTACT@

static int hit(u16 shield, BattleContext *ctx) {
    ctx->moveNoProtect[1] = shield;
    sSubscript = 0;
    BtlCmd_CheckProtectContactMoves(0, ctx);
    return sSubscript;
}

int main(void) {
    BattleContext ctx;
    memset(&ctx, 0, sizeof(ctx));
    ctx.battlerIdAttacker = 0;
    ctx.battlerIdTarget = 1;
    ctx.battleMons[0].hp = ctx.battleMons[0].maxHp = 80;
    for (int i = 0; i < 8; i++) ctx.battleMons[0].statChanges[i] = 6;
    sContact = TRUE;

    assert(hit(MOVE_KINGS_SHIELD, &ctx) == BATTLE_SUBSCRIPT_UPDATE_STAT_STAGE);
    assert(ctx.statChangeParam == MOVE_SUBSCRIPT_PTR_ATTACK_DOWN_1_STAGE && ctx.battlerIdStatChange == 0);
    assert(hit(MOVE_OBSTRUCT, &ctx) == BATTLE_SUBSCRIPT_UPDATE_STAT_STAGE);
    assert(ctx.statChangeParam == MOVE_SUBSCRIPT_PTR_DEFENSE_DOWN_2_STAGES);
    assert(hit(MOVE_SILK_TRAP, &ctx) == BATTLE_SUBSCRIPT_UPDATE_STAT_STAGE);
    assert(ctx.statChangeParam == MOVE_SUBSCRIPT_PTR_SPEED_DOWN_1_STAGE);
    assert(hit(MOVE_SPIKY_SHIELD, &ctx) == BATTLE_SUBSCRIPT_SPIKY_SHIELD);
    assert(ctx.hpCalc == -10 && ctx.battlerIdTemp == 0);
    assert(hit(MOVE_BANEFUL_BUNKER, &ctx) == BATTLE_SUBSCRIPT_POISON && ctx.battlerIdStatChange == 0);
    assert(hit(MOVE_BURNING_BULWARK, &ctx) == BATTLE_SUBSCRIPT_BURN && ctx.battlerIdStatChange == 0);
    assert(hit(MOVE_PROTECT, &ctx) == 0);

    // Nothing at the bottom of the stat, nothing through Magic Guard, nothing
    // for a Pokemon that is already poisoned, or poison-proof.
    ctx.battleMons[0].statChanges[STAT_ATK] = 0;
    assert(hit(MOVE_KINGS_SHIELD, &ctx) == 0);
    ctx.battleMons[0].ability = ABILITY_MAGIC_GUARD;
    assert(hit(MOVE_SPIKY_SHIELD, &ctx) == 0);
    ctx.battleMons[0].ability = 0;
    ctx.battleMons[0].type2 = TYPE_STEEL;
    assert(hit(MOVE_BANEFUL_BUNKER, &ctx) == 0);
    ctx.battleMons[0].type2 = 0;
    ctx.battleMons[0].status = 1;
    assert(hit(MOVE_BURNING_BULWARK, &ctx) == 0);
    ctx.battleMons[0].status = 0;

    // Nothing without contact, on a charging turn, through a guard the
    // ally lent, or from a fainted attacker.
    sContact = FALSE;
    assert(hit(MOVE_SPIKY_SHIELD, &ctx) == 0);
    sContact = TRUE;
    ctx.battleStatus = BATTLE_STATUS_CHARGE_TURN;
    assert(hit(MOVE_SPIKY_SHIELD, &ctx) == 0);
    ctx.battleStatus = 0;
    ctx.turnData[1].gainedProtectFlagFromAlly = 1;
    assert(hit(MOVE_SPIKY_SHIELD, &ctx) == 0);
    ctx.turnData[1].gainedProtectFlagFromAlly = 0;
    ctx.battleMons[0].hp = 0;
    assert(hit(MOVE_SPIKY_SHIELD, &ctx) == 0);
    return 0;
}
"""


class ProtectTests(unittest.TestCase):
    def test_the_real_guard_check_and_protection_command(self):
        controller = read("src/battle/battle_controller_player.c")
        commands = read("src/battle/battle_command.c")
        source = FIXTURE
        for token, replacement in {
            "@TEAM_GUARD@": function(commands, "IsTeamGuard"),
            "@TEAM_GUARD_MOVE@": function(controller, "IsTeamGuardMove"),
            "@STOPS@": function(controller, "GuardStopsMove"),
            "@TRY@": function(commands, "BtlCmd_TryProtection"),
            "@FEINT@": function(commands, "BtlCmd_TryFeint"),
        }.items():
            source = source.replace(token, replacement)
        with tempfile.TemporaryDirectory(prefix="newgold-protect-") as directory:
            path = Path(directory)
            (path / "check.c").write_text(source)
            result = subprocess.run(shlex.split(os.environ.get("CC", "cc")) + [
                "-std=c99", "-Wall", "-Werror", "-Wno-unused-function", "-iquote", str(ROOT / "include"),
                str(path / "check.c"), "-o", str(path / "check")], capture_output=True, text=True)
            self.assertEqual(result.returncode, 0, result.stderr)
            result = subprocess.run([str(path / "check")], capture_output=True, text=True)
            self.assertEqual(result.returncode, 0, result.stderr)

    def test_the_protected_line_names_a_team_guard(self):
        """The check leaves the guard's move in moveTemp and the Miss subscript
        prints "{1} protected {0}!" for it, "{0} protected itself!" for none."""
        miss = read("files/battledata/script/subscript/subscript_0007_Miss.s")
        self.assertIn("CompareVarToValue OPCODE_EQU, BSCRIPT_VAR_MSG_MOVE_TEMP, 0, _PROTECTED_ITSELF", miss)
        self.assertIn("PrintMessage msg_0197_01567, TAG_NICKNAME_MOVE, BATTLER_CATEGORY_DEFENDER, "
                      "BATTLER_CATEGORY_MSG_TEMP", miss)

    def test_the_real_contact_penalties(self):
        source = CONTACT_FIXTURE.replace(
            "@CONTACT@", function(read("src/battle/battle_command.c"), "BtlCmd_CheckProtectContactMoves"))
        with tempfile.TemporaryDirectory(prefix="newgold-protect-contact-") as directory:
            path = Path(directory)
            (path / "check.c").write_text(source)
            result = subprocess.run(shlex.split(os.environ.get("CC", "cc")) + [
                "-std=c99", "-Wall", "-Werror", "-iquote", str(ROOT / "include"),
                str(path / "check.c"), "-o", str(path / "check")], capture_output=True, text=True)
            self.assertEqual(result.returncode, 0, result.stderr)
            result = subprocess.run([str(path / "check")], capture_output=True, text=True)
            self.assertEqual(result.returncode, 0, result.stderr)

    def test_the_protected_path_runs_the_penalties(self):
        miss = read("files/battledata/script/subscript/subscript_0007_Miss.s")
        protected = miss[miss.index("_PROTECTED_MSG:"):miss.index("_CHECK_LEVITATE:")]
        self.assertIn("CheckProtectContactMoves", protected)

    def test_mat_block_is_a_first_turn_move(self):
        script = read("files/battledata/script/effect_script/effect_script_0373.s")
        self.assertIn("MOVE_MAT_BLOCK", script)
        self.assertIn("BMON_DATA_FAKE_OUT, BSCRIPT_VAR_TOTAL_TURNS, _FAIL", script)


if __name__ == "__main__":
    unittest.main()
