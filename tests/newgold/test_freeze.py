#!/usr/bin/env python3
"""What thaws a frozen Pokemon a move hits (Pokemon Central, Congelamento):
a Fire move, and Scald, Steam Eruption, Scorching Sands and Matcha Gotcha
(Spruzzate); Hydro Steam too, which Showdown's gen-9 data marks thawsTarget
where Pokemon Central says nothing."""

import re
import unittest

from test_ability_interactions import run_c
from test_level_cap import ROOT
from test_repels import function

CONTROLLER = ROOT / "src/battle/battle_controller_player.c"

PROGRAM = r"""
#include <assert.h>
#include <stdint.h>
typedef uint16_t u16;
typedef int BOOL;
#include "constants/moves.h"
@FUNCTIONS@
int main(void) {
    assert(MoveThawsTarget(MOVE_SCALD) && MoveThawsTarget(MOVE_STEAM_ERUPTION) && MoveThawsTarget(MOVE_SCORCHING_SANDS));
    assert(MoveThawsTarget(MOVE_MATCHA_GOTCHA) && MoveThawsTarget(MOVE_HYDRO_STEAM));
    assert(!MoveThawsTarget(MOVE_SURF) && !MoveThawsTarget(MOVE_TACKLE));
    return 0;
}
"""


class FreezeTests(unittest.TestCase):
    def test_the_water_moves_that_thaw_their_target(self):
        controller = CONTROLLER.read_text()
        run_c(PROGRAM.replace("@FUNCTIONS@", function(controller, "MoveThawsTarget")))
        # The hit's thaw step asks it beside the Fire type.
        self.assertRegex(controller, re.escape("&& (moveType == TYPE_FIRE || MoveThawsTarget(ctx->moveNoCur))) {")
                         + r"\s+ctx->battlerIdTemp = ctx->battlerIdTarget;\s+"
                         + re.escape("ReadBattleScriptFromNarc(ctx, NARC_a_0_0_1, BATTLE_SUBSCRIPT_THAW_OUT);"))


if __name__ == "__main__":
    unittest.main()
