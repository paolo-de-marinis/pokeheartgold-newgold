#!/usr/bin/env python3
"""Which hits a King's Rock, a Razor Fang or Stench can make flinch, and how often.

TryItemFlinch and the move rule it asks are extracted from
src/battle/battle_controller_player.c and driven with a scripted random number
against a three-move table: a plain hit, a move that flinches by itself, and a
status move.
"""

import os
from pathlib import Path
import re
import shlex
import subprocess
import tempfile
import unittest

from test_level_cap import ROOT, function

CONTROLLER = ROOT / "src/battle/battle_controller_player.c"

PREFIX = r'''
#include <assert.h>
#include <stdint.h>
#include <string.h>
#include "constants/abilities.h"
#include "constants/battle.h"
#include "constants/battle_subscript.h"
#include "constants/items.h"
#include "constants/move_effects.h"
typedef uint8_t u8; typedef int8_t s8; typedef uint16_t u16; typedef uint32_t u32;
typedef int BOOL;
#define TRUE 1
#define FALSE 0
enum { NARC_a_0_0_1 = 1 };

typedef struct { u16 effect; u8 category; u8 power; } MoveTbl;
typedef struct { int unused; } BattleSystem;
typedef struct {
    int battlerIdAttacker, battlerIdTarget, battlerIdStatChange, statChangeType;
    u32 moveStatusFlag;
    u16 moveNoCur;
    int command, commandNext, script;
    struct { int physicalDamage, specialDamage; } selfTurnData[4];
    struct { u16 hp; } battleMons[4];
} BattleContext;

enum { PLAIN_HIT = 1, BITE = 2, GROWL = 3 };
static const MoveTbl sMoves[] = {
    [PLAIN_HIT] = { 0, 0, 90 },
    [BITE] = { MOVE_EFFECT_FLINCH_HIT, 0, 60 },
    [GROWL] = { 0, 2, 0 },
};

static int sItem[4], sItemParam[4], sAbility[4];
static u16 sRoll;

static const MoveTbl *BattleMoveTbl(BattleContext *ctx, u32 move) { (void)ctx; return &sMoves[move]; }
static int GetBattlerHeldItemEffect(BattleContext *ctx, int b) { (void)ctx; return sItem[b]; }
static int GetHeldItemModifier(BattleContext *ctx, int b, int flag) { (void)ctx; (void)flag; return sItemParam[b]; }
static u16 GetBattlerAbility(BattleContext *ctx, int b) { (void)ctx; return (u16)sAbility[b]; }
static u16 BattleSystem_Random(BattleSystem *bs) { (void)bs; return sRoll; }
static void ReadBattleScriptFromNarc(BattleContext *ctx, int narc, int file) { assert(narc == NARC_a_0_0_1); ctx->script = file; }
@NATIVE@

// Whether the attacker, with `item` (param `param`) and `ability`, makes the
// target flinch with `move` when the roll is `roll`.
static BOOL flinches(int item, int param, int ability, u16 move, u16 roll) {
    BattleSystem bs = {0};
    BattleContext ctx;
    memset(&ctx, 0, sizeof(ctx));
    ctx.battlerIdAttacker = 0;
    ctx.battlerIdTarget = 1;
    ctx.moveNoCur = move;
    ctx.selfTurnData[1].physicalDamage = 10;
    ctx.battleMons[1].hp = 10;
    sItem[0] = item;
    sItemParam[0] = param;
    sAbility[0] = ability;
    sRoll = roll;
    BOOL ret = TryItemFlinch(&bs, &ctx);
    assert(ret == (ctx.script == BATTLE_SUBSCRIPT_FLINCH_MON));
    return ret;
}

// The highest roll that still flinches, or -1.
static int chance(int item, int param, int ability, u16 move) {
    int last = -1;
    for (u16 roll = 0; roll < 100; roll++) {
        if (flinches(item, param, ability, move, roll)) {
            assert(last == roll - 1);
            last = roll;
        }
    }
    return last + 1;
}

int main(void) {
    // A King's Rock is a tenth on any move with power that does not flinch
    // by itself, and nothing on the rest.
    assert(chance(HOLD_EFFECT_FLINCH_CHANCE, 10, 0, PLAIN_HIT) == 10);
    assert(chance(HOLD_EFFECT_FLINCH_CHANCE, 10, 0, BITE) == 0);
    assert(chance(HOLD_EFFECT_FLINCH_CHANCE, 10, 0, GROWL) == 0);

    // Stench is one without an item, and a second tenth with one.
    assert(chance(0, 0, ABILITY_STENCH, PLAIN_HIT) == 10);
    assert(chance(HOLD_EFFECT_FLINCH_CHANCE, 10, ABILITY_STENCH, PLAIN_HIT) == 20);
    assert(chance(0, 0, ABILITY_STENCH, BITE) == 0);
    // Another item's parameter is not a flinch chance.
    assert(chance(HOLD_EFFECT_CHOICE_ATK, 25, ABILITY_STENCH, PLAIN_HIT) == 10);
    assert(chance(HOLD_EFFECT_CHOICE_ATK, 25, 0, PLAIN_HIT) == 0);

    // Serene Grace doubles it.
    assert(chance(HOLD_EFFECT_FLINCH_CHANCE, 10, ABILITY_SERENE_GRACE, PLAIN_HIT) == 20);

    // A Covert Cloak on the target stops all of it.
    sItem[1] = HOLD_EFFECT_PREVENT_SECONDARY_EFFECTS;
    assert(chance(HOLD_EFFECT_FLINCH_CHANCE, 10, ABILITY_STENCH, PLAIN_HIT) == 0);
    sItem[1] = 0;
    return 0;
}
'''


class KingsRock(unittest.TestCase):
    def test_the_flinch_chance_and_the_moves_it_reaches(self):
        source = CONTROLLER.read_text()
        native = "\n".join([function(source, "MoveIsAffectedByKingsRock"), function(source, "TryItemFlinch")])
        with tempfile.TemporaryDirectory(prefix="newgold-kings-rock-") as temp:
            c, exe = Path(temp) / "check.c", Path(temp) / "check"
            c.write_text(PREFIX.replace("@NATIVE@", native))
            result = subprocess.run(shlex.split(os.environ.get("CC", "cc")) + [
                # MOVE_STATUS_FAIL has a 1 << 31 in it, which the DS compiler
                # takes as meant and a host sanitizer does not.
                "-std=c11", "-O1", "-g", "-fsanitize=address,undefined", "-fno-sanitize=shift-base",
                "-fno-omit-frame-pointer",
                "-iquote", str(ROOT / "include"), str(c), "-o", str(exe)], capture_output=True, text=True)
            self.assertEqual(result.returncode, 0, result.stderr)
            result = subprocess.run([str(exe)], capture_output=True, text=True,
                                    env={**os.environ, "ASAN_OPTIONS": "detect_leaks=0", "UBSAN_OPTIONS": "halt_on_error=1"})
            self.assertEqual(result.returncode, 0, result.stderr)


if __name__ == "__main__":
    unittest.main()
