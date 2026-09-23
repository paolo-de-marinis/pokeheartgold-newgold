#!/usr/bin/env python3
"""Run the actual ported C functions with a small host-side battle fixture.

This checks function semantics, not the DS ABI, overlays, or ROM integration.
No copied implementation of the functions under test is compiled here.
"""

import os
from pathlib import Path
import re
import shlex
import subprocess
import tempfile
import unittest


ROOT = Path(__file__).resolve().parents[2]


def function(source, name):
    match = re.search(r"^static (?:void|int) " + name + r"\([^;]*?\) \{", source, re.M)
    if match is None:
        raise ValueError(f"Function definition not found: {name}")
    depth = 1
    end = match.end()
    while depth:
        depth += (source[end] == "{") - (source[end] == "}")
        end += 1
    return source[match.start():end]


FIXTURE = r"""
#include <assert.h>
#include <stdint.h>
#include "constants/battle.h"
#include "constants/battle_subscript.h"
#include "constants/message_tags.h"
#include "constants/moves.h"

enum { NARC_a_0_0_1 = 0, TRUE = 1 };
typedef uint32_t u32;
typedef struct {
    int maxBattlers;
    int randomCalls;
} BattleSystem;
typedef struct {
    int stateBeforeTurn, beforeTurnData, executionOrder[BATTLER_MAX];
    u32 switchInFlag;
    struct { u32 status, status2; } battleMons[BATTLER_MAX];
    struct { int struggleFlag, beakBlastCharging; } turnData[BATTLER_MAX];
    struct { int id, tag, param[6]; } buffMsg;
    int battlerIdTemp, commandNext, command;
    u32 unk_310C[BATTLER_MAX];
    int selectedMove[BATTLER_MAX];
} BattleContext;

static int BattleSystem_GetMaxBattlers(BattleSystem *bs) { return bs->maxBattlers; }
static u32 MaskOfFlagNo(int battler) { return 1u << battler; }
static int GetBattlerSelectedMove(BattleContext *ctx, int battler) { return ctx->selectedMove[battler]; }
static int CheckTruant(BattleContext *ctx, int battler) { (void)ctx; (void)battler; return 0; }
static void BattleController_EmitBlankMessage(BattleSystem *bs) { (void)bs; }
static int CreateNicknameTag(BattleContext *ctx, int battler) { (void)ctx; return battler; }
static void ReadBattleScriptFromNarc(BattleContext *ctx, int narc, int script) {
    (void)ctx; (void)narc; (void)script;
    assert(0 && "Unexpected script while processing Rage");
}
static u32 BattleSystem_Random(BattleSystem *bs) { return 100u + ++bs->randomCalls; }

@BEFORE_TURN_ENUM@
@BEFORE_TURN_FUNCTION@

static void check_rage(u32 otherFlags, int maxBattlers) {
    BattleSystem bs = { .maxBattlers = maxBattlers };
    BattleContext ctx = { .stateBeforeTurn = BT_STATE_RAGE };
    ctx.battleMons[0].status2 = STATUS2_RAGE | otherFlags;
    ctx.selectedMove[0] = MOVE_POUND;
    ctx.battleMons[1].status2 = STATUS2_RAGE | otherFlags;
    ctx.selectedMove[1] = MOVE_RAGE;
    ctx.battleMons[2].status2 = otherFlags;
    ctx.selectedMove[2] = MOVE_POUND;
    ctx.battleMons[3].status2 = STATUS2_RAGE;
    ctx.selectedMove[3] = MOVE_POUND;

    BattleControllerPlayer_BeforeTurn(&bs, &ctx);

    assert(ctx.battleMons[0].status2 == otherFlags);
    assert(ctx.battleMons[1].status2 == (STATUS2_RAGE | otherFlags));
    assert(ctx.battleMons[2].status2 == otherFlags);
    assert(ctx.battleMons[3].status2 == (maxBattlers == 4 ? 0 : STATUS2_RAGE));
    assert(ctx.stateBeforeTurn == BT_STATE_FOCUS_PUNCH);
    assert(ctx.command == CONTROLLER_COMMAND_8);
    assert(bs.randomCalls == BATTLER_MAX);
    for (int battler = 0; battler < BATTLER_MAX; battler++) {
        assert(ctx.unk_310C[battler] == 101u + battler);
    }
}

int main(void) {
    for (int maxBattlers = 2; maxBattlers <= 4; maxBattlers += 2) {
        check_rage(0, maxBattlers);
        check_rage(~(u32)STATUS2_RAGE, maxBattlers);
        for (int bit = 0; bit < 32; bit++) {
            if ((1u << bit) != STATUS2_RAGE) {
                check_rage(1u << bit, maxBattlers);
            }
        }
    }
    return 0;
}
"""


class BattleRegressions(unittest.TestCase):
    def test_rage_cleanup_preserves_other_flags_and_turn_sequence(self):
        source = (ROOT / "src/battle/battle_controller_player.c").read_text()
        enum = re.search(r"typedef enum BeforeTurnState \{.*?\} BeforeTurnState;", source, re.S)
        self.assertIsNotNone(enum)
        program = FIXTURE.replace("@BEFORE_TURN_ENUM@", enum.group())
        before = function(source, "BattleControllerPlayer_BeforeTurn")
        program = program.replace("@BEFORE_TURN_FUNCTION@", before)
        # The lines the turn start prints are named by their rows.
        program = "".join(f"#define {row} {int(row[len('msg_0197_'):])}\n" for row in sorted(set(re.findall(r"msg_0197_\d+", before)))) + program
        with tempfile.TemporaryDirectory(prefix="newgold-battle-") as directory:
            path = Path(directory)
            (path / "test.c").write_text(program)
            subprocess.run(shlex.split(os.environ.get("CC", "cc")) + [
                "-std=c99", "-Wall", "-Wextra", "-Werror", "-iquote", str(ROOT / "include"),
                str(path / "test.c"), "-o", str(path / "test"),
            ], check=True)
            subprocess.run([str(path / "test")], check=True, cwd=directory)


if __name__ == "__main__":
    unittest.main()
