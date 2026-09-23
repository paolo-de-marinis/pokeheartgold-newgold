#!/usr/bin/env python3
"""Dancer: a Pokemon with the ability dances any dance move another Pokemon
has just used (ServerDoPostMoveEffects.c's step 30 at d0380a487; Pokemon
Central, Sincrodanza)."""

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
CONTROLLER = ROOT / "src/battle/battle_controller_player.c"
COMMANDS = ROOT / "src/battle/battle_command.c"
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
#include "constants/abilities.h"
#include "constants/battle.h"
#include "constants/moves.h"
#include "constants/move_effects.h"
typedef struct { int doubles; } BattleSystem;
typedef struct { u16 effect; u8 range; } MoveTbl;
typedef struct {
    int hp, ability;
    u32 status2, moveEffectFlags;
    struct { u16 moveNoChoice, encoredMove; } unk88;
} BattleMon;
typedef struct {
    BattleMon battleMons[4];
    u32 moveNoLockedInto[4];
    u16 danceMove;
    u8 dancersPending, danceUser, danceTarget, dancing;
    u32 battleStatus, battleStatus2, moveStatusFlag, unk_2184;
    int moveNoCur, moveNoTemp, battlerIdAttacker, battlerIdTarget, unk_48, command;
    int turnOrder[4];
    int inits;
} BattleContext;
static u32 MaskOfFlagNo(int n) { return 1u << n; }
static int GetBattlerAbility(BattleContext *ctx, int battlerId) { return ctx->battleMons[battlerId].ability; }
static MoveTbl sMove;
static const MoveTbl *BattleMoveTbl(BattleContext *ctx, u32 moveNo) {
    (void)ctx;
    sMove.range = moveNo == MOVE_SWORDS_DANCE ? RANGE_USER : moveNo == MOVE_TEETER_DANCE ? RANGE_ALL_ADJACENT : RANGE_SINGLE_TARGET;
    sMove.effect = moveNo == MOVE_SWORDS_DANCE ? MOVE_EFFECT_ATK_UP_2 : moveNo == MOVE_FEATHER_DANCE ? MOVE_EFFECT_ATK_DOWN_2 : 0;
    return &sMove;
}
static BOOL BattleMoveIsDance(u32 moveNo) {
    return moveNo == MOVE_SWORDS_DANCE || moveNo == MOVE_FEATHER_DANCE || moveNo == MOVE_FIERY_DANCE || moveNo == MOVE_TEETER_DANCE;
}
static int BattleSystem_GetFieldSide(BattleSystem *bs, int battlerId) { (void)bs; return battlerId & 1; }
static int BattleSystem_GetMaxBattlers(BattleSystem *bs) { return bs->doubles ? 4 : 2; }
// The aim anyone else would take: recognisable, so the test can tell.
static int ov12_022506D4(BattleSystem *bs, BattleContext *ctx, int attacker, u16 move, int a4, int range) {
    (void)bs; (void)ctx; (void)move; (void)range;
    assert(a4 == 1);
    return 10 + attacker;
}
static void BattleContext_Init(BattleContext *ctx) {
    ctx->inits++;
    ctx->battleStatus = 0;
    ctx->battleStatus2 = 0;
    ctx->moveStatusFlag = 0;
    ctx->unk_2184 = 0;
    ctx->unk_48 = 0;
}
static void BattleController_EmitBlankMessage(BattleSystem *bs) { (void)bs; }
@FUNCTIONS@
static BattleSystem bs;
static BattleContext ctx;
static void setup(int doubles) {
    BattleContext blank = { 0 };
    ctx = blank;
    bs.doubles = doubles;
    for (int i = 0; i < 4; i++) {
        ctx.battleMons[i].hp = 100;
        ctx.turnOrder[i] = i;
    }
}
// Battler `user` has just used `move` at `target`.
static void danced(int user, int move, int target) {
    ctx.battlerIdAttacker = user;
    ctx.battlerIdTarget = target;
    ctx.moveNoCur = ctx.moveNoTemp = move;
    ctx.battleStatus2 = BATTLE_STATUS2_MOVE_SUCCEEDED;
}
// Who dances next, and at whom; -1 when nobody.
static int next(int *target) {
    if (!TryDancer(&bs, &ctx)) {
        return -1;
    }
    assert(ctx.dancing && ctx.command == CONTROLLER_COMMAND_23 && ctx.unk_48 == 1);
    assert(ctx.unk_2184 == (MULTIHIT_SKIP_OBEDIENCE_CHECK | MULTIHIT_SKIP_PP_DECREMENT));
    assert(ctx.moveNoCur == ctx.danceMove && ctx.moveNoTemp == ctx.danceMove);
    *target = ctx.battlerIdTarget;
    return ctx.battlerIdAttacker;
}
int main(void) {
    int target;
    // The foe's Swords Dance, copied once and not again from the copy.
    setup(0);
    ctx.battleMons[0].ability = ABILITY_DANCER;
    danced(1, MOVE_SWORDS_DANCE, 1);
    assert(next(&target) == 0 && target == 10);
    assert(ctx.inits == 1);
    ctx.battleStatus2 = BATTLE_STATUS2_MOVE_SUCCEEDED;
    assert(next(&target) == -1 && !ctx.dancing);
    // Not a dance, a dance that missed, or the dancer's own dance.
    setup(0);
    ctx.battleMons[0].ability = ABILITY_DANCER;
    danced(1, MOVE_TACKLE, 0);
    assert(next(&target) == -1);
    danced(1, MOVE_FEATHER_DANCE, 0);
    ctx.moveStatusFlag = MOVE_STATUS_MISSED;
    assert(next(&target) == -1);
    danced(0, MOVE_SWORDS_DANCE, 0);
    assert(next(&target) == -1);
    // A dance that changed nothing: Swords Dance at +6, Feather Dance at -6
    // (the change's failure flag), a several-stat dance with all at the top.
    setup(0);
    ctx.battleMons[0].ability = ABILITY_DANCER;
    danced(1, MOVE_SWORDS_DANCE, 1);
    ctx.battleStatus = BATTLE_STATUS_FAIL_STAT_STAGE_CHANGE;
    assert(next(&target) == -1);
    danced(1, MOVE_FEATHER_DANCE, 0);
    ctx.battleStatus = BATTLE_STATUS_FAIL_STAT_STAGE_CHANGE;
    assert(next(&target) == -1);
    danced(1, MOVE_FIERY_DANCE, 0);
    ctx.battleStatus = BATTLE_STATUS_FAIL_STAT_STAGE_CHANGE;
    assert(next(&target) == 0);
    setup(0);
    ctx.battleMons[0].ability = ABILITY_DANCER;
    danced(1, MOVE_TEETER_DANCE, 0);
    ctx.moveStatusFlag = MOVE_STATUS_NO_MORE_WORK;
    assert(next(&target) == -1);
    ctx.moveStatusFlag = 0;
    // Snatched or bounced back: the battle status says it was not the move set.
    danced(1, MOVE_FEATHER_DANCE, 0);
    ctx.battleStatus = BATTLE_STATUS_NO_MOVE_SET;
    assert(next(&target) == -1);
    ctx.battleStatus = 0;
    // A foe's single-target dance goes back at the foe.
    setup(0);
    ctx.battleMons[0].ability = ABILITY_DANCER;
    danced(1, MOVE_FEATHER_DANCE, 0);
    assert(next(&target) == 0 && target == 1);
    // In a double battle: an ally's dance at a foe goes at that foe, and at
    // the ally when the dancer was its target; two dancers in speed order.
    setup(1);
    ctx.battleMons[0].ability = ABILITY_DANCER;
    danced(2, MOVE_FIERY_DANCE, 3);
    assert(next(&target) == 0 && target == 3);
    setup(1);
    ctx.battleMons[0].ability = ABILITY_DANCER;
    danced(2, MOVE_FEATHER_DANCE, 0);
    assert(next(&target) == 0 && target == 2);
    setup(1);
    ctx.battleMons[0].ability = ctx.battleMons[3].ability = ABILITY_DANCER;
    ctx.turnOrder[0] = 3; ctx.turnOrder[1] = 1; ctx.turnOrder[2] = 0; ctx.turnOrder[3] = 2;
    danced(1, MOVE_TEETER_DANCE, 0);
    assert(next(&target) == 3 && target == 13);
    assert(next(&target) == 0 && target == 10);
    assert(next(&target) == -1);
    // Its foe fainted: aimed as anyone's would be.
    setup(1);
    ctx.battleMons[0].ability = ABILITY_DANCER;
    danced(1, MOVE_FIERY_DANCE, 0);
    ctx.battleMons[1].hp = 0;
    assert(next(&target) == 0 && target == 10);
    // Fainted, in the air, or without the ability.
    for (int lock = 0; lock < 3; lock++) {
        setup(0);
        ctx.battleMons[0].ability = ABILITY_DANCER;
        switch (lock) {
        case 0: ctx.battleMons[0].hp = 0; break;
        case 1: ctx.battleMons[0].moveEffectFlags = MOVE_EFFECT_FLAG_FLY; break;
        case 2: ctx.battleMons[0].ability = ABILITY_OWN_TEMPO; break;
        }
        danced(1, MOVE_SWORDS_DANCE, 1);
        assert(next(&target) == -1);
    }
    // Locked into another move by a Choice item, an Encore or a rampage, it
    // takes the dance up, and the check before the move fails it.
    for (int lock = 0; lock < 3; lock++) {
        setup(0);
        ctx.battleMons[0].ability = ABILITY_DANCER;
        switch (lock) {
        case 0: ctx.battleMons[0].unk88.moveNoChoice = MOVE_TACKLE; break;
        case 1: ctx.battleMons[0].unk88.encoredMove = MOVE_TACKLE; break;
        case 2: ctx.battleMons[0].status2 = STATUS2_RAMPAGE; ctx.moveNoLockedInto[0] = MOVE_OUTRAGE; break;
        }
        danced(1, MOVE_SWORDS_DANCE, 1);
        assert(next(&target) == 0 && Battler_DanceLocked(&ctx, 0));
    }
    // Locked into the dance itself, it dances and does not fail.
    setup(0);
    ctx.battleMons[0].ability = ABILITY_DANCER;
    ctx.battleMons[0].unk88.moveNoChoice = MOVE_SWORDS_DANCE;
    danced(1, MOVE_SWORDS_DANCE, 1);
    assert(next(&target) == 0 && !Battler_DanceLocked(&ctx, 0));
    return 0;
}
"""


def table(name):
    body = re.search(r"static const u16 " + name + r"\[\] = \{(.*?)\};", OVERLAY.read_text(), re.S).group(1)
    return re.findall(r"MOVE_[A-Z0-9_]+", body)


class DancerTests(unittest.TestCase):
    def test_who_dances_and_at_whom(self):
        source = CONTROLLER.read_text()
        functions = "\n".join(function(source, name) for name in (
            "Battler_DanceLocked", "Battler_CanDance", "Dancer_Target", "Dance_ChangedNothing", "TryDancer"))
        with tempfile.TemporaryDirectory(prefix="newgold-dancer-") as directory:
            path = Path(directory)
            (path / "test.c").write_text(FIXTURE.replace("@FUNCTIONS@", functions))
            subprocess.run(shlex.split(os.environ.get("CC", "cc")) + [
                "-std=c99", "-Wall", "-Werror", "-Wno-unused-function", "-iquote", str(ROOT / "include"),
                str(path / "test.c"), "-o", str(path / "test")], check=True)
            subprocess.run([str(path / "test")], check=True)

    def test_a_locked_dancer_fails_the_dance(self):
        # Pokemon Central, Sincrodanza: it tries the dance and fails unless the
        # dance is the move it is locked into.
        checks = function(CONTROLLER.read_text(), "ov12_0224B528")
        self.assertRegex(checks, r"if \(ctx->dancing && Battler_DanceLocked\(ctx, ctx->battlerIdAttacker\)\) \{\s*"
                                 r"ReadBattleScriptFromNarc\(ctx, NARC_a_0_0_1, BATTLE_SUBSCRIPT_DANCE_FAILED\);")
        number = int(re.search(r"#define BATTLE_SUBSCRIPT_DANCE_FAILED\s+(\d+)",
                               (ROOT / "include/constants/battle_subscript.h").read_text()).group(1))
        script = next((ROOT / "files/battledata/script/subscript").glob(f"subscript_{number:04d}_*.s")).read_text()
        self.assertRegex(script, r"PrintAttackMessage\s*Wait\s*WaitButtonABTime 30\s*Call BATTLE_SUBSCRIPT_BUT_IT_FAILED")

    def test_the_dances_are_the_reference_s(self):
        moves = table("sDanceMoves")
        self.assertEqual(moves, sorted(set(moves)))
        self.assertEqual(len(moves), 12)
        if not REFERENCE.exists():
            self.skipTest("Pinned NewGold reference checkout not configured")
        source = subprocess.run(["git", "-C", str(REFERENCE), "show", "d0380a487:src/battle/other_battle_calculators.c"],
                                capture_output=True, text=True, check=True).stdout
        body = re.search(r"DanceMoveTable\[\]\s*=\s*\{(.*?)\};", source, re.S).group(1)
        self.assertEqual(set(moves), set(re.findall(r"MOVE_[A-Z0-9_]+", body)))

    def test_it_comes_at_the_end_of_the_move(self):
        end = function(CONTROLLER.read_text(), "ov12_0224D368")
        self.assertLess(end.index("ov12_0224DC0C(battleSystem, ctx);"), end.index("TryDancer(battleSystem, ctx) == TRUE"))
        self.assertLess(end.index("TryDancer(battleSystem, ctx) == TRUE"), end.index("ctx->executionIndex++;"))

    def test_a_copy_is_not_the_move_last_used_and_does_not_rampage(self):
        after = function(CONTROLLER.read_text(), "ov12_0224D23C")
        self.assertIn("BOOL copied = ctx->dancing;", after)
        self.assertIn("if (!copied && !userGone) {", after)
        self.assertIn("if (!copied && !userGone && ctx->battleStatus2 & BATTLE_STATUS2_DISPLAY_ATTACK_MESSAGE) {", after)
        self.assertIn("if (!userGone && copyLocks && ", after)
        effect = function(COMMANDS.read_text(), "BtlCmd_GoToEffectScript")
        self.assertIn("ctx->dancing && effect == MOVE_EFFECT_CONTINUE_AND_CONFUSE_SELF", effect)


if __name__ == "__main__":
    unittest.main()
