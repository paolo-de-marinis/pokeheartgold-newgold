#!/usr/bin/env python3
"""What thaws a frozen Pokemon (Pokemon Central, Congelamento): a Fire move
hitting it, and Scald, Steam Eruption, Scorching Sands and Matcha Gotcha
(Spruzzate); Hydro Steam too, which Showdown's gen-9 data marks thawsTarget
where Pokemon Central says nothing. And the moves that thaw their own
frozen user, Pyro Ball, Scorching Sands and Burn Up among them."""

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

    def test_the_moves_that_thaw_their_user(self):
        run_c(USER.replace("@FUNCTIONS@", function(CONTROLLER.read_text(), "MoveThawsUser")))


USER = r"""
#include <assert.h>
#include <stddef.h>
#include <stdint.h>
typedef uint8_t u8;
typedef uint16_t u16;
typedef uint32_t u32;
typedef int BOOL;
enum { FALSE = 0, TRUE = 1 };
#include "constants/battle.h"
#include "constants/moves.h"
#include "constants/move_effects.h"
#include "constants/pokemon.h"
typedef struct { u16 moveNoCur; int battlerIdAttacker; u8 types[3]; } BattleContext;
static int GetBattlerVar(BattleContext *ctx, int battlerId, int var, void *data) {
    (void)battlerId; (void)data;
    return ctx->types[var - BMON_DATA_TYPE_1];
}
@FUNCTIONS@
static BOOL thaws(u16 move, int effect, u8 type) {
    BattleContext ctx = { move, 0, { type, type, TYPE_NONE } };
    return MoveThawsUser(&ctx, effect);
}
int main(void) {
    assert(thaws(MOVE_FLAME_WHEEL, MOVE_EFFECT_THAW_AND_BURN_HIT, TYPE_NORMAL));
    assert(thaws(MOVE_FUSION_FLARE, MOVE_EFFECT_HIT, TYPE_NORMAL));
    assert(thaws(MOVE_PYRO_BALL, MOVE_EFFECT_BURN_HIT, TYPE_NORMAL));
    assert(thaws(MOVE_SCORCHING_SANDS, MOVE_EFFECT_BURN_HIT, TYPE_NORMAL));
    assert(thaws(MOVE_HYDRO_STEAM, MOVE_EFFECT_HIT, TYPE_NORMAL));
    assert(!thaws(MOVE_FLAMETHROWER, MOVE_EFFECT_BURN_HIT, TYPE_FIRE));
    // Burn Up, only for a user that is part Fire.
    assert(thaws(MOVE_BURN_UP, MOVE_EFFECT_REMOVE_USER_FIRE_TYPE_HIT, TYPE_FIRE));
    assert(!thaws(MOVE_BURN_UP, MOVE_EFFECT_REMOVE_USER_FIRE_TYPE_HIT, TYPE_NORMAL));
    return 0;
}
"""


if __name__ == "__main__":
    unittest.main()
