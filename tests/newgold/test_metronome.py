#!/usr/bin/env python3
"""Run Metronome's roll and the Metronome/Mimic ban list with host sanitizers.

BtlCmd_Metronome, CheckLegalMetronomeMove, CheckLegalMimicMove and the list
they share are extracted from the port's C and driven with a scripted random
number. Where the reference checkout is present, the list is also compared by
move name with the engine's at d0380a487.
"""

import os
from pathlib import Path
import re
import shlex
import subprocess
import tempfile
import unittest

from test_level_cap import ROOT, function
from test_repels import REFERENCE, revision

ENGINE_COMMIT = "d0380a487"
COMMAND = ROOT / "src/battle/battle_command.c"
OVERLAY = ROOT / "src/battle/overlay_12_0224E4FC.c"

PREFIX = r'''
#include <assert.h>
#include <stdint.h>
#include "constants/moves.h"
#include "constants/pokemon.h"
typedef uint16_t u16; typedef uint32_t u32;
typedef int BOOL;
#define TRUE 1
#define FALSE 0

typedef struct { int unused; } BattleSystem;
typedef struct {
    struct { u16 moves[MAX_MON_MOVES]; } battleMons[4];
    int battlerIdAttacker;
    u16 moveTemp;
} BattleContext;

static u16 rolls[8];
static int rollCount;
static u16 BattleSystem_Random(BattleSystem *bs) { (void)bs; assert(rollCount < 8); return rolls[rollCount++]; }
static void BattleScriptIncrementPointer(BattleContext *ctx, int n) { (void)ctx; (void)n; }
static BOOL BattleContext_CheckMoveUnuseableInGravity(BattleSystem *bs, BattleContext *ctx, int b, u16 m) { (void)bs; (void)ctx; (void)b; (void)m; return FALSE; }
static BOOL BattleContext_CheckMoveHealBlocked(BattleSystem *bs, BattleContext *ctx, int b, u16 m) { (void)bs; (void)ctx; (void)b; (void)m; return FALSE; }
@NATIVE@

// The move Metronome calls when the first roll is `roll` and every later one
// lands on Pound.
static u16 metronome(u16 roll) {
    BattleSystem bs = {0};
    BattleContext ctx = {0};
    rolls[0] = roll;
    for (int i = 1; i < 8; i++) rolls[i] = MOVE_POUND - 1;
    rollCount = 0;
    BtlCmd_Metronome(&bs, &ctx);
    return ctx.moveTemp;
}

int main(void) {
    BattleSystem bs = {0};
    BattleContext ctx = {0};

    // Every move up to the last one can come out, and nothing past it.
    int reached = 0;
    for (u32 roll = 0; roll < NUM_MOVES_TOTAL; roll++) {
        u16 move = roll + 1;
        if (CheckLegalMetronomeMove(&bs, &ctx, 0, move) && move != MOVE_REVIVAL_BLESSING) {
            assert(metronome(roll) == move);
            reached++;
        }
    }
    // Revival Blessing is Metronome's own refusal, not the shared list's:
    // Showdown's gen-9 data gives it no metronome flag, and Copycat copies it.
    assert(CheckLegalMetronomeMove(&bs, &ctx, 0, MOVE_REVIVAL_BLESSING));
    assert(metronome(MOVE_REVIVAL_BLESSING - 1) == MOVE_POUND);
    // Sky Drop comes out, as it did in the games that had it.
    assert(metronome(MOVE_SKY_DROP - 1) == MOVE_SKY_DROP);
    assert(metronome(NUM_MOVES_TOTAL) == MOVE_POUND);
    assert(metronome(NUM_MOVES_TOTAL - 1) == MOVE_MALIGNANT_CHAIN);
    assert(metronome(MOVE_SOLAR_SEEDS - 1) == MOVE_SOLAR_SEEDS);
    assert(reached > NUM_MOVES);

    // Banned for both: retail's own, and the engine's Z-, Let's Go and Max
    // moves and placeholders.
    static const u16 both[] = {
        MOVE_METRONOME, MOVE_STRUGGLE, MOVE_SKETCH, MOVE_MIMIC, MOVE_CHATTER,
        MOVE_BEHEMOTH_BLADE, MOVE_BREAKNECK_BLITZ_PHYSICAL, MOVE_CATASTROPIKA,
        MOVE_ZIPPY_ZAP, MOVE_MAX_GUARD, MOVE_MAX_STEELSPIKE, MOVE_468, MOVE_470,
    };
    for (unsigned i = 0; i < sizeof(both) / sizeof(both[0]); i++) {
        assert(!CheckLegalMetronomeMove(&bs, &ctx, 0, both[i]));
        assert(!CheckLegalMimicMove(both[i]));
    }

    // Banned for Metronome alone: Mimic can still copy them.
    static const u16 metronomeOnly[] = {
        MOVE_PROTECT, MOVE_COUNTER, MOVE_SWITCHEROO, MOVE_TRANSFORM,
        MOVE_AFTER_YOU, MOVE_BELCH, MOVE_WIDE_GUARD, MOVE_ASTRAL_BARRAGE,
    };
    for (unsigned i = 0; i < sizeof(metronomeOnly) / sizeof(metronomeOnly[0]); i++) {
        assert(!CheckLegalMetronomeMove(&bs, &ctx, 0, metronomeOnly[i]));
        assert(CheckLegalMimicMove(metronomeOnly[i]));
    }

    // And the ordinary moves stay open to both.
    static const u16 open[] = { MOVE_POUND, MOVE_SHADOW_FORCE, MOVE_ACROBATICS, MOVE_MOONBLAST, MOVE_MALIGNANT_CHAIN };
    for (unsigned i = 0; i < sizeof(open) / sizeof(open[0]); i++) {
        assert(CheckLegalMetronomeMove(&bs, &ctx, 0, open[i]));
        assert(CheckLegalMimicMove(open[i]));
    }
    return 0;
}
'''


def ban_list(text, start):
    body = text[text.index(start):]
    body = body[:body.index("};")]
    names = re.findall(r"\bMOVE_\w+|0xFFF[EF]", body)
    split = names.index("0xFFFE")
    return set(names[:split]), set(names[split + 1:]) - {"0xFFFF"}


class MetronomeTests(unittest.TestCase):
    def test_metronome_reaches_every_move_but_the_banned(self):
        overlay = OVERLAY.read_text()
        table = overlay[overlay.index("static const u16 sMetronomeUnuseableMoves[]"):]
        table = table[:table.index("};") + 2]
        native = "\n".join([
            table,
            function(overlay, "CheckLegalMimicMove"),
            function(overlay, "CheckLegalMetronomeMove"),
            function(COMMAND.read_text(), "BtlCmd_Metronome"),
        ])
        with tempfile.TemporaryDirectory(prefix="newgold-metronome-") as temp:
            c, exe = Path(temp) / "check.c", Path(temp) / "check"
            c.write_text(PREFIX.replace("@NATIVE@", native))
            result = subprocess.run(shlex.split(os.environ.get("CC", "cc")) + ["-std=c11", "-O1", "-g", "-fsanitize=address,undefined", "-fno-omit-frame-pointer", "-iquote", str(ROOT / "include"), str(c), "-o", str(exe)], capture_output=True, text=True)
            self.assertEqual(result.returncode, 0, result.stderr)
            result = subprocess.run([str(exe)], capture_output=True, text=True, env={**os.environ, "ASAN_OPTIONS": "detect_leaks=0", "UBSAN_OPTIONS": "halt_on_error=1"})
            self.assertEqual(result.returncode, 0, result.stderr)

    def test_the_list_is_the_engines_by_name(self):
        if REFERENCE is None:
            self.skipTest("no reference checkout")
        engine = revision(REFERENCE, ENGINE_COMMIT, "src/battle/other_battle_calculators.c")
        both, metronome = ban_list(engine, "u16 sMetronomeMimicMoveBanList[]")
        port_both, port_metronome = ban_list(OVERLAY.read_text(), "sMetronomeUnuseableMoves[]")
        self.assertEqual(port_both, both)
        # Double Iron Bash and Dynamax Cannon sit on both sides of the engine's
        # marker; the Mimic half already covers them here.
        self.assertEqual(port_metronome, metronome - both)


if __name__ == "__main__":
    unittest.main()
