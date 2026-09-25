#!/usr/bin/env python3
"""A place left empty in a double battle has no Pokemon to read.

When a battler faints and its party has nothing left to send in, the end of
the turn (ov12_0224D540) raises its switch-in flag and sets its
selectedMonIndex to 6, one past the party; SwitchAndUpdateMon puts both back
when something comes in again. Retail asks the flag before it reads such a
battler's Pokemon. The port's own code has to as well: Party_GetMonByIndex
asserts the slot, and asserts are on in every build, so a read of slot 6
resets the game. Each function that reads a battler's party Pokemon is
compiled here with a party that asserts the same way.
"""

import os
import shlex
import subprocess
import tempfile
import unittest
from pathlib import Path

from test_repels import ROOT, function

COMMANDS = (ROOT / "src/battle/battle_command.c").read_text()

HEADER = r"""
#include <assert.h>
#include <stdint.h>
#include <string.h>
#include "constants/battle.h"
#include "constants/pokemon.h"
#include "constants/species.h"
typedef uint8_t u8; typedef uint16_t u16; typedef uint32_t u32; typedef int8_t s8; typedef int32_t s32;
typedef int BOOL;
#define TRUE 1
#define FALSE 0
typedef struct BattleSystem BattleSystem;
typedef struct { u16 species, speed; } Pokemon;

// Two parties, the player's and the opponent's, each of sCount[side]
// Pokemon; a slot past the count fails the way PARTY_ASSERT_SLOT does.
static Pokemon sParties[2][6];
static int sCount[2] = { 6, 6 };
static int sMaxBattlers = 4;
static u32 MaskOfFlagNo(int flagno) { return 1u << flagno; }
static int BattleSystem_GetMaxBattlers(BattleSystem *bs) { (void)bs; return sMaxBattlers; }
static int BattleSystem_GetFieldSide(BattleSystem *bs, int battlerId) { (void)bs; return battlerId & 1; }
static Pokemon *BattleSystem_GetPartyMon(BattleSystem *bs, int battlerId, int index) {
    (void)bs;
    assert(index >= 0 && index < sCount[battlerId & 1] && "PARTY_ASSERT_SLOT");
    return &sParties[battlerId & 1][index];
}
"""


def run(test, program, functions):
    source = program.replace("@FUNCTIONS@", "\n".join(function(COMMANDS, name) for name in functions))
    with tempfile.TemporaryDirectory(prefix="newgold-empty-place-") as directory:
        path = Path(directory)
        (path / "test.c").write_text(HEADER + source)
        result = subprocess.run(shlex.split(os.environ.get("CC", "cc")) + [
            "-std=c99", "-Wall", "-Werror", "-Wno-unused-function", "-iquote", str(ROOT / "include"),
            str(path / "test.c"), "-o", str(path / "test")], capture_output=True, text=True)
        test.assertEqual(result.returncode, 0, result.stderr)
        result = subprocess.run([str(path / "test")], capture_output=True, text=True)
    test.assertEqual(result.returncode, 0, result.stderr)


RAW_SPEED = r"""
typedef struct { u8 selectedMonIndex[4]; u8 switchInFlag; } BattleContext;
static u32 GetMonData(Pokemon *mon, int id, void *data) {
    (void)data;
    assert(id == MON_DATA_SPEED);
    return mon->speed;
}
@FUNCTIONS@

int main(void) {
    static BattleContext ctx;
    int order[BATTLER_MAX];

    // Twins, two Pokemon each: the player's Houndoom in 0 and Honchkrow in
    // 2, the Azumarill in 1 and the Flaaffy in 3.
    sCount[0] = 2;
    sCount[1] = 2;
    sParties[0][0].speed = 120;
    sParties[0][1].speed = 90;
    sParties[1][0].speed = 50;
    sParties[1][1].speed = 60;
    ctx.selectedMonIndex[0] = 0;
    ctx.selectedMonIndex[1] = 0;
    ctx.selectedMonIndex[2] = 1;
    ctx.selectedMonIndex[3] = 1;
    assert(RawSpeedOrder(0, &ctx, order) == 4);
    assert(order[0] == 0 && order[1] == 2 && order[2] == 3 && order[3] == 1);

    // The Houndoom has fainted and there is nothing to send in: its place
    // is empty, and the rest keep their order ahead of it.
    ctx.switchInFlag |= MaskOfFlagNo(0);
    ctx.selectedMonIndex[0] = 6;
    assert(RawSpeedOrder(0, &ctx, order) == 4);
    assert(order[0] == 2 && order[1] == 3 && order[2] == 1 && order[3] == 0);

    // And the Azumarill on the other side too.
    ctx.switchInFlag |= MaskOfFlagNo(1);
    ctx.selectedMonIndex[1] = 6;
    assert(RawSpeedOrder(0, &ctx, order) == 4);
    assert(order[0] == 2 && order[1] == 3);
    return 0;
}
"""


class EmptyPlaceTests(unittest.TestCase):
    def test_the_final_modifier_orders_an_empty_place_without_reading_it(self):
        run(self, RAW_SPEED, ("RawSpeedGoesFirst", "RawSpeedOrder"))


if __name__ == "__main__":
    unittest.main()
