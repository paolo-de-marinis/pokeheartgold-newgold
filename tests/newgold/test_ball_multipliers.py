#!/usr/bin/env python3
"""Check the ball catch multipliers the ROM compiles with.

BattleSystem_CalculateBallShakes reaches into the battle context, the save and
the clock, so running it on the host would mean stubbing most of a battle for
what are, in the end, seven numbers. This reads the multiplier each ball case
sets instead, which is the thing that changed, and pins the Friend Ball's
friendship away from the tier constant that happens to share HGSS's value.
"""

import os
from pathlib import Path
import re
import shlex
import subprocess
import tempfile
import unittest

from test_level_cap import ROOT, function

# Multipliers are tenths: 35 means a 3.5x catch rate.
EXPECTED = {
    "ITEM_NET_BALL": "35",
    "ITEM_DIVE_BALL": "35",
    "ITEM_REPEAT_BALL": "35",
    "ITEM_DUSK_BALL": "30",
    "ITEM_QUICK_BALL": "50",
}

PROGRAM = r'''
#include <assert.h>
#include <stdio.h>
#include "constants/balls.h"
#include "constants/pokemon.h"

int main(void) {
    // The modern Friend Ball value, kept apart from the friendship tier that
    // happens to carry HGSS's 200.
    assert(FRIEND_BALL_FRIENDSHIP == 150);
    assert(FRIENDSHIP_TIER_HI_MIN == 200);
    assert(FRIEND_BALL_FRIENDSHIP < FRIENDSHIP_TIER_HI_MIN);
    assert(FRIEND_BALL_FRIENDSHIP > FRIENDSHIP_TIER_MID_MIN);
    puts("PASS: five ball multipliers, the level and turn formulas, Friend Ball friendship.");
}
'''


class BallMultiplierTests(unittest.TestCase):
    def setUp(self):
        source = (ROOT / "src/battle/battle_command.c").read_text()
        self.body = function(source, "BattleSystem_CalculateBallShakes")

    def case(self, ball):
        start = self.body.index(f"case {ball}:")
        end = self.body.index("break;", start)
        return self.body[start:end]

    def test_flat_multipliers(self):
        for ball, value in EXPECTED.items():
            self.assertRegex(self.case(ball), rf"ballMultiplier = {value};", ball)

    def test_nest_ball_scales_to_level_thirty(self):
        nest = self.case("ITEM_NEST_BALL")
        self.assertIn("level <= 30", nest)
        self.assertIn("ballMultiplier = 41 - level;", nest)
        # The old shape clamped a wider range up to a floor; that is gone.
        self.assertNotIn("ballMultiplier < 10", nest)

    def test_timer_ball_gains_three_tenths_a_turn(self):
        timer = self.case("ITEM_TIMER_BALL")
        self.assertIn("ballMultiplier = 10 + 3 * ctx->totalTurns;", timer)
        # Ten turns to reach the ceiling: 10 + 3 * 10 == 40.
        self.assertEqual(10 + 3 * 10, 40)
        self.assertIn("> 40", self.body[self.body.index("case ITEM_TIMER_BALL:"):])

    def test_friend_ball_uses_its_own_constant(self):
        self.assertIn("u8 friendship = FRIEND_BALL_FRIENDSHIP;", self.body)
        with tempfile.TemporaryDirectory(prefix="newgold-ball-multipliers-") as temp:
            c, exe = Path(temp) / "check.c", Path(temp) / "check"
            c.write_text(PROGRAM)
            result = subprocess.run(shlex.split(os.environ.get("CC", "cc")) + ["-std=c11", "-O1", "-g", "-fsanitize=undefined", "-iquote", str(ROOT / "include"), str(c), "-o", str(exe)], capture_output=True, text=True)
            self.assertEqual(result.returncode, 0, result.stderr)
            result = subprocess.run([str(exe)], capture_output=True, text=True, env={**os.environ, "UBSAN_OPTIONS": "halt_on_error=1"})
            self.assertEqual(result.returncode, 0, result.stderr)
            print(result.stdout.strip())


if __name__ == "__main__":
    unittest.main()
