#!/usr/bin/env python3
"""Snipe Shot aims where it was told (Pokemon Central, Sonoqui): Follow Me,
Rage Powder, Lightning Rod and Storm Drain do not draw it, as they do not
draw a Propeller Tail or Stalwart user's move. BattlerIgnoresRedirection is
the one question both re-targets ask."""

import unittest

from test_ability_interactions import run_c
from test_level_cap import ROOT
from test_repels import function

OVERLAY = ROOT / "src/battle/overlay_12_0224E4FC.c"

PROGRAM = r"""
#include <assert.h>
#include <stdint.h>
typedef uint16_t u16;
typedef int BOOL;
#include "constants/abilities.h"
#include "constants/moves.h"
typedef struct { int ability[4]; } BattleContext;
static int GetBattlerAbility(BattleContext *ctx, int battlerId) { return ctx->ability[battlerId]; }
@FUNCTIONS@
int main(void) {
    BattleContext ctx = { { ABILITY_NONE, ABILITY_STALWART, ABILITY_NONE, ABILITY_NONE } };
    assert(BattlerIgnoresRedirection(&ctx, 0, MOVE_SNIPE_SHOT));
    assert(!BattlerIgnoresRedirection(&ctx, 0, MOVE_WATER_GUN));
    assert(BattlerIgnoresRedirection(&ctx, 1, MOVE_WATER_GUN));
    return 0;
}
"""


class SnipeShotTests(unittest.TestCase):
    def test_snipe_shot_is_not_redirected(self):
        run_c(PROGRAM.replace("@FUNCTIONS@", function(OVERLAY.read_text(), "BattlerIgnoresRedirection")))


if __name__ == "__main__":
    unittest.main()
