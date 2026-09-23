#!/usr/bin/env python3
"""Run the added abilities' C on the host.

Each class takes the port's own functions out of the source, compiles them
against a small stubbed battle, and checks what the ability does with worked
numbers. Taking the ability out of the function makes its class fail.
"""

import os
from pathlib import Path
import re
import shlex
import subprocess
import tempfile
import unittest

from test_level_cap import ROOT
from test_repels import function

OVERLAY = (ROOT / "src/battle/overlay_12_0224E4FC.c").read_text()


def run_c(test, program):
    with tempfile.TemporaryDirectory(prefix="newgold-ability-") as directory:
        path = Path(directory)
        (path / "test.c").write_text(program)
        result = subprocess.run(shlex.split(os.environ.get("CC", "cc")) + [
            "-std=c99", "-Wall", "-Werror", "-Wno-unused-function", "-Wno-unused-variable", "-Wno-unused-but-set-variable",
            "-iquote", str(ROOT / "include"), str(path / "test.c"), "-o", str(path / "test")],
            capture_output=True, text=True)
        test.assertEqual(result.returncode, 0, result.stderr)
        result = subprocess.run([str(path / "test")], capture_output=True, text=True)
        test.assertEqual(result.returncode, 0, result.stderr)


HEADER = r"""
#include <assert.h>
#include <stdint.h>
#include <stdio.h>
#include <string.h>
#include "constants/abilities.h"
#include "constants/battle.h"
#include "constants/battle_subscript.h"
#include "constants/items.h"
#include "constants/move_effects.h"
#include "constants/moves.h"
#include "constants/pokemon.h"
#include "constants/species.h"
typedef uint8_t u8; typedef uint16_t u16; typedef uint32_t u32;
typedef int8_t s8; typedef int16_t s16; typedef int32_t s32;
typedef int BOOL;
#define TRUE 1
#define FALSE 0
#define NELEMS(a) (sizeof(a) / sizeof((a)[0]))
#define GF_ASSERT(x) assert(x)
#define EXPECT(what, expected) do { int got_ = (what); if (got_ != (expected)) { \
    fprintf(stderr, "%s:%d: %s is %d, expected %d\n", __FILE__, __LINE__, #what, got_, (expected)); return 1; } } while (0)
"""


# CalcMoveDamage, the tables it reads and the structure it fills, with the
# battle around it stubbed: every battler has 100 in each stat, level 50, no
# item, no stage, and the ability the scenario gives it. A 100-power physical
# move from battler 0 into battler 1 is ((22 * 100 * 100 / 100) / 50) + 2 = 46.
DAMAGE = HEADER + r"""
typedef struct { int unused; } BattleSystem;
typedef struct {
    int hp; u16 species; u32 moveEffectFlags; u8 canStillEvolve;
    struct { int meFirstFlag, meFirstCount, fakeOutCount; } unk88;
} BattleMon;
typedef struct {
    int unk_2158; u8 terrainOverlayType; int meFirstTotal; int totalTurns;
    u32 effectiveSpeed[4]; u8 paradoxBoostedStat[4]; u8 supremeOverlordFallen[4];
    int totalTimesFainted[4];
    BattleMon battleMons[4];
    struct { int helpingHandFlag; } turnData[4];
} BattleContext;
typedef struct { int power, type, category; } MoveTbl;

static struct { int maxBattlers; int ability[4]; MoveTbl move; } S;

static int GetBattlerVar(BattleContext *ctx, int battlerId, u32 varId, void *data) {
    (void)data;
    switch (varId) {
    case BMON_DATA_ATK: case BMON_DATA_DEF: case BMON_DATA_SPATK: case BMON_DATA_SPDEF: return 100;
    case BMON_DATA_STAT_CHANGE_ATK: case BMON_DATA_STAT_CHANGE_DEF:
    case BMON_DATA_STAT_CHANGE_SPATK: case BMON_DATA_STAT_CHANGE_SPDEF: return 6;
    case BMON_DATA_LEVEL: return 50;
    case BMON_DATA_SPECIES: return ctx->battleMons[battlerId].species;
    case BMON_DATA_HP: return ctx->battleMons[battlerId].hp;
    case BMON_DATA_MAXHP: return 100;
    case BMON_DATA_GENDER: return MON_GENDERLESS;
    case BMON_DATA_TYPE_1: case BMON_DATA_TYPE_2: return TYPE_NORMAL;
    default: return 0;
    }
}
static u16 GetBattlerAbility(BattleContext *ctx, int battlerId) { (void)ctx; return S.ability[battlerId]; }
static u16 GetBattlerHeldItem(BattleContext *ctx, int battlerId) { (void)ctx; (void)battlerId; return 0; }
static int GetItemVar(BattleContext *ctx, u16 item, u32 var) { (void)ctx; (void)item; (void)var; return 0; }
static int BattleSystem_GetMaxBattlers(BattleSystem *bs) { (void)bs; return S.maxBattlers; }
static const MoveTbl *BattleMoveTbl(BattleContext *ctx, u32 moveNo) { (void)ctx; (void)moveNo; return &S.move; }
static u8 BattleMoveTypeForAbility(BattleContext *ctx, int ability, u32 moveNo, int type) { (void)ctx; (void)ability; (void)moveNo; return type; }
static BOOL BattlerIsGrounded(BattleContext *ctx, int battlerId) { (void)ctx; (void)battlerId; return TRUE; }
static BOOL BattlerCheckSubstitute(BattleContext *ctx, int battlerId) { (void)ctx; (void)battlerId; return FALSE; }
static BOOL IsSuppressibleSecondaryEffect(BattleContext *ctx, u32 moveNo) { (void)ctx; (void)moveNo; return FALSE; }
static BOOL BattleMoveMakesContact(BattleContext *ctx, u32 moveNo) { (void)ctx; (void)moveNo; return FALSE; }
static BOOL BattleMoveIsSoundBased(u32 moveNo) { (void)moveNo; return FALSE; }
static int CheckAbilityActive(BattleSystem *bs, BattleContext *ctx, int flag, int battlerId, int ability) {
    (void)bs; (void)ctx; (void)flag; (void)battlerId; (void)ability; return 0;
}
static BOOL CheckBattlerAbilityIfNotIgnored(BattleContext *ctx, int a, int t, int ability) { (void)ctx; (void)a; (void)t; (void)ability; return FALSE; }
static int CheckMoveEffectOnField(BattleSystem *bs, BattleContext *ctx, u32 flag) { (void)bs; (void)ctx; (void)flag; return 0; }
static int ov12_022581D4(BattleSystem *bs, BattleContext *ctx, int var, int battlerId) { (void)bs; (void)ctx; (void)var; (void)battlerId; return 0; }
@MOVE_IS_IN_LIST@
@SLICING@
@CALC@

static BattleSystem bs;
static BattleContext ctx;

static void reset(int maxBattlers) {
    memset(&S, 0, sizeof(S));
    memset(&ctx, 0, sizeof(ctx));
    S.maxBattlers = maxBattlers;
    S.move = (MoveTbl){ 100, TYPE_NORMAL, CATEGORY_PHYSICAL };
    ctx.unk_2158 = 10;
    for (int i = 0; i < 4; i++) {
        ctx.battleMons[i].hp = 100;
        ctx.battleMons[i].species = SPECIES_BULBASAUR;
    }
}

static int damage(int attacker, int target) {
    return CalcMoveDamage(&bs, &ctx, MOVE_TACKLE, 0, 0, 0, TYPE_NORMAL, attacker, target, 1);
}

int main(void) {
    reset(4); EXPECT(damage(0, 1), 46);
@CHECKS@
    return 0;
}
"""


def damage_program(checks):
    start = OVERLAY.index("typedef struct MoveDamageCalc {")
    calc = OVERLAY[start:OVERLAY.index(function(OVERLAY, "CalcMoveDamage")) + len(function(OVERLAY, "CalcMoveDamage"))]
    slicing = re.search(r"static const u16 sSlicingMoves\[\] = \{.*?\};", OVERLAY, re.S).group(0)
    return (DAMAGE.replace("@MOVE_IS_IN_LIST@", function(OVERLAY, "MoveIsInList"))
            .replace("@SLICING@", slicing).replace("@CALC@", calc).replace("@CHECKS@", checks))


class PowerSpotTests(unittest.TestCase):
    def test_the_ally_s_moves_take_three_tenths(self):
        # Power 130: (22 * 100 * 130 / 100) / 50 + 2 = 59.
        run_c(self, damage_program(r"""
    reset(4); S.ability[2] = ABILITY_POWER_SPOT; EXPECT(damage(0, 1), 59);
    // Never the holder's own moves.
    reset(4); S.ability[0] = ABILITY_POWER_SPOT; EXPECT(damage(0, 1), 46);
    // Nor from a fainted holder, which the reference still counts.
    reset(4); S.ability[2] = ABILITY_POWER_SPOT; ctx.battleMons[2].hp = 0; EXPECT(damage(0, 1), 46);
    // Nor from the stale slot of a single battle.
    reset(2); S.ability[2] = ABILITY_POWER_SPOT; EXPECT(damage(0, 1), 46);
"""))

if __name__ == "__main__":
    unittest.main()
