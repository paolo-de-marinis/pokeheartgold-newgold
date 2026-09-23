#!/usr/bin/env python3
"""How long Bind and the other binding moves hold, run on the host.

BtlCmd_SetBindingTurns and the end-of-turn countdown, BindTurnPasses, are
taken out of the port's C and run against a stubbed battle: each end of
turn the target is hurt while it is still held, and let go the turn it is
not.
"""

import os
import shlex
import subprocess
import tempfile
import unittest
from pathlib import Path

from test_level_cap import ROOT
from test_repels import function

PROGRAM = r"""
#include <assert.h>
#include <stdint.h>
#include <stdio.h>
#include "constants/battle.h"
#include "constants/items.h"
typedef uint8_t u8; typedef uint16_t u16; typedef uint32_t u32;
typedef int BOOL;
#define TRUE 1
#define FALSE 0
typedef struct BattleSystem BattleSystem;
typedef struct { u8 bindEighthTurn : 1; } MoveConditions;
typedef struct {
    u32 status2;
    struct { u32 battlerIdBinding : 2; u16 bindingMove; } unk88;
} BattleMon;
typedef struct {
    int battlerIdAttacker, battlerIdTarget;
    u32 moveNoCur;
    int skipped;
    BattleMon battleMons[4];
    MoveConditions moveConditions[4];
    u8 bindingBandBinds;
} BattleContext;
static int MaskOfFlagNo(int n) { return 1 << n; }
static int sItem;
static u16 sRandom;
static void BattleScriptIncrementPointer(BattleContext *ctx, int n) { if (n == 5) ctx->skipped = 1; }
static int BattleScriptReadWord(BattleContext *ctx) { (void)ctx; return 5; }
static int GetBattlerHeldItemEffect(BattleContext *ctx, int battlerId) { (void)ctx; (void)battlerId; return sItem; }
static u16 BattleSystem_Random(BattleSystem *bs) { (void)bs; return sRandom; }
@FUNCTIONS@

// The turns of damage a bind deals before the target is let go.
static int held(int item, u16 random) {
    static BattleContext ctx;
    int turns = 0;
    ctx = (BattleContext){ 0 };
    ctx.battlerIdAttacker = 0;
    ctx.battlerIdTarget = 1;
    // A Grip Claw's bit left over from a bind that ended some other way.
    ctx.moveConditions[1].bindEighthTurn = TRUE;
    sItem = item;
    sRandom = random;
    BtlCmd_SetBindingTurns(0, &ctx);
    assert(!ctx.skipped && (ctx.battleMons[1].status2 & STATUS2_BIND));
    while (BindTurnPasses(&ctx, 1)) {
        turns++;
    }
    assert(!(ctx.battleMons[1].status2 & STATUS2_BIND) && !ctx.moveConditions[1].bindEighthTurn);
    return turns;
}

int main(void) {
    static BattleContext ctx;
    assert(held(0, 0) == 4);
    assert(held(0, 1) == 5);
    assert(held(HOLD_EFFECT_EXTEND_TRAPPING, 0) == 7);
    assert(held(HOLD_EFFECT_EXTEND_TRAPPING, 1) == 7);
    // A Pokemon already held is not bound again.
    ctx.battlerIdTarget = 1;
    ctx.battleMons[1].status2 = 2 << STATUS2_BINDING_SHIFT;
    BtlCmd_SetBindingTurns(0, &ctx);
    assert(ctx.skipped && ctx.battleMons[1].status2 == (2 << STATUS2_BINDING_SHIFT));
    return 0;
}
"""


class BindTests(unittest.TestCase):
    def test_four_or_five_turns_and_seven_with_a_grip_claw(self):
        """Pokemon Central (Legatutto) and btl_scr_cmd_F7_setbindingcounter
        at d0380a487; retail's were two to five, and five with the claw."""
        functions = "\n".join([
            function((ROOT / "src/battle/battle_command.c").read_text(), "BtlCmd_SetBindingTurns"),
            function((ROOT / "src/battle/battle_controller_player.c").read_text(), "BindTurnPasses")])
        with tempfile.TemporaryDirectory(prefix="newgold-bind-") as directory:
            path = Path(directory)
            (path / "test.c").write_text(PROGRAM.replace("@FUNCTIONS@", functions))
            result = subprocess.run(shlex.split(os.environ.get("CC", "cc")) + [
                "-std=c99", "-Wall", "-Werror", "-iquote", str(ROOT / "include"),
                str(path / "test.c"), "-o", str(path / "test")], capture_output=True, text=True)
            self.assertEqual(result.returncode, 0, result.stderr)
            result = subprocess.run([str(path / "test")], capture_output=True, text=True)
        self.assertEqual(result.returncode, 0, result.stderr)

    def test_the_moves_bind_through_the_command(self):
        """Subscript 58 is the reference's: SetBindingTurns decides, where
        retail's rolled its own count in the script."""
        script = (ROOT / "files/battledata/script/subscript/subscript_0058_BindStart.s").read_text()
        self.assertIn("SetBindingTurns _018", script)
        self.assertNotIn("Random", script)
        controller = function((ROOT / "src/battle/battle_controller_player.c").read_text(),
                              "BattleControllerPlayer_UpdateMonCondition")
        self.assertIn("if (BindTurnPasses(ctx, battlerId)) {", controller)


if __name__ == "__main__":
    unittest.main()
