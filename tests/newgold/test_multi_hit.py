#!/usr/bin/env python3
"""The hit count of the moves that hit more than once.

SetMultiHit's first operand is the count, and 0 asks BtlCmd_SetMultiHit to
roll two to five. Only a rolled count lets Skill Link and Loaded Dice in, so a
script that names its count outright is a move those two never touch.
"""

import re
import unittest

from test_move_effects import EFFECT_SCRIPTS, moves, records


def script_for(move):
    effect = records()[moves()[move]][0]
    return (EFFECT_SCRIPTS / f"effect_script_{effect:04d}.s").read_text()


def set_multi_hit(script):
    return re.search(r"^\s*SetMultiHit (\d+), (\w+)", script, re.M).groups()


class MultiHitScripts(unittest.TestCase):
    def test_solar_seeds_rolls_two_to_five(self):
        """konefr's own move, Bullet Seed with a burn: SetMultiHit 0 in
        effect_script_0407_BURN_MULTI_HIT at ccf2c9f5."""
        self.assertEqual(set_multi_hit(script_for("SOLAR_SEEDS")), ("0", "MULTIHIT_MULTI_HIT_MOVE"))


if __name__ == "__main__":
    unittest.main()
