#!/usr/bin/env python3
"""Powder: a Fire move by a Pokemon covered in it goes off in its face."""

import unittest

from test_level_cap import ROOT
from test_repels import function

CONTROLLER = (ROOT / "src/battle/battle_controller_player.c").read_text()


class PowderTests(unittest.TestCase):
    def test_the_move_s_pp_is_spent_first(self):
        """The explosion is one of the checks after the PP goes, after the
        primal weathers' (BattleController_CheckMoveFailures1, run after
        BEFORE_MOVE_STATE_DECREMENT_PP and _PRIMAL_WEATHER at d0380a487);
        here it stopped the move among the status checks, before any PP was
        taken."""
        before = function(CONTROLLER, "ov12_0224C38C")
        self.assertNotIn("powderBlockingFireMove", function(CONTROLLER, "ov12_0224B528"))
        self.assertLess(before.index("ov12_0224B1FC(battleSystem, ctx)"), before.index("PrimalWeatherStopsMove("))
        self.assertLess(before.index("PrimalWeatherStopsMove("), before.index("powderBlockingFireMove"))
        self.assertLess(before.index("powderBlockingFireMove"), before.index("ABILITY_PROTEAN"))
        self.assertIn("BATTLE_SUBSCRIPT_TAKE_POWDER_DAMAGE", before)


if __name__ == "__main__":
    unittest.main()
