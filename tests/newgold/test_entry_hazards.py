#!/usr/bin/env python3
"""The hazards a Pokemon meets as it comes out.

Subscript 99 is where a Pokemon switching in meets the spikes, the poison
spikes, the web and the pointed stones laid on its side.
"""

import unittest

from test_repels import read

HAZARDS = "files/battledata/script/subscript/subscript_0099_HazardsCheck.s"


class GroundedTests(unittest.TestCase):
    def test_the_ground_hazards_ask_the_battle_s_own_test(self):
        # Retail asked Gravity, the Iron Ball, Levitate, the two types and
        # Magnet Rise by hand, so an Air Balloon or Eelevate still took the
        # spikes. BattlerIsGrounded knows both.
        text = read(HAZARDS)
        self.assertIn("GotoIfGrounded BATTLER_CATEGORY_SWITCHED_MON", text)
        for asked in ("ABILITY_LEVITATE", "TYPE_FLYING", "MOVE_EFFECT_FLAG_MAGNET_RISE", "FIELD_CONDITION_GRAVITY"):
            self.assertNotIn(asked, text)
        grounded = read("src/battle/overlay_12_0224E4FC.c")
        grounded = grounded[grounded.index("BOOL BattlerIsGrounded("):]
        grounded = grounded[:grounded.index("\n}\n")]
        for lifted in ("ABILITY_LEVITATE", "ABILITY_EELEVATE", "HOLD_EFFECT_UNGROUND_DESTROYED_ON_HIT"):
            self.assertIn(lifted, grounded)


if __name__ == "__main__":
    unittest.main()
