#!/usr/bin/env python3
"""A pure Flying type that uses Roost is Normal for the turn (Pokemon
Central, Trespolo): from the fifth generation, where the fourth left it with
no type at all. Battler_GetType answers for every read of a battler's type,
the type chart's among them."""

import unittest

from test_ability_interactions import run_c
from test_level_cap import ROOT
from test_repels import function

OVERLAY = ROOT / "src/battle/overlay_12_0224E4FC.c"

PROGRAM = r"""
#include <assert.h>
#include <stdint.h>
typedef uint8_t u8;
typedef uint16_t u16;
typedef int BOOL;
#include "constants/abilities.h"
#include "constants/species.h"
#include "constants/items.h"
#include "constants/pokemon.h"
#include "constants/battle.h"
#define GF_ASSERT(x) assert(x)
enum { FALSE = 0, TRUE = 1 };
typedef struct { u8 type1, type2, type3; u16 species, ability, item; } BattleMon;
typedef struct { unsigned roostFlag : 1; } TurnData;
typedef struct { BattleMon battleMons[4]; TurnData turnData[4]; } BattleContext;
static int GetItemVar(BattleContext *ctx, u16 item, int var) { (void)ctx; (void)var; return item; }
static u8 GetSilvallyTypeByHeldItemEffect(int effect) { (void)effect; return TYPE_NORMAL; }
@FUNCTIONS@
int main(void) {
    BattleContext ctx = { 0 };
    ctx.battleMons[0] = (BattleMon){ TYPE_FLYING, TYPE_FLYING, TYPE_NONE, SPECIES_TORNADUS, 0, 0 };
    ctx.battleMons[1] = (BattleMon){ TYPE_NORMAL, TYPE_FLYING, TYPE_NONE, SPECIES_PIDGEY, 0, 0 };
    ctx.battleMons[2] = (BattleMon){ TYPE_FLYING, TYPE_FLYING, TYPE_GRASS, SPECIES_TORNADUS, 0, 0 };
    // Before Roost, a Flying type.
    assert(Battler_GetType(&ctx, 0, BMON_DATA_TYPE_1) == TYPE_FLYING);
    ctx.turnData[0].roostFlag = ctx.turnData[1].roostFlag = ctx.turnData[2].roostFlag = 1;
    // Roosting, the pure Flying type is Normal...
    assert(Battler_GetType(&ctx, 0, BMON_DATA_TYPE_1) == TYPE_NORMAL);
    assert(Battler_GetType(&ctx, 0, BMON_DATA_TYPE_2) == TYPE_NORMAL);
    // ...a Normal and Flying one keeps its types, the chart dropping Flying...
    assert(Battler_GetType(&ctx, 1, BMON_DATA_TYPE_2) == TYPE_FLYING);
    // ...and one with an added type is that type.
    assert(Battler_GetType(&ctx, 2, BMON_DATA_TYPE_1) == TYPE_FLYING);
    return 0;
}
"""


class RoostTests(unittest.TestCase):
    def test_a_roosting_pure_flying_type_is_normal(self):
        run_c(PROGRAM.replace("@FUNCTIONS@", function(OVERLAY.read_text(), "Battler_GetType")))


if __name__ == "__main__":
    unittest.main()
