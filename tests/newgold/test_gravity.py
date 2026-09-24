#!/usr/bin/env python3
"""Under Gravity (Pokemon Central, Gravita) Bounce, Fly, Sky Drop, Splash,
Jump Kick, Flying Press and High Jump Kick cannot be used, nor the two
moves that lift, Magnet Rise and Telekinesis."""

import re
import unittest

from test_level_cap import ROOT

OVERLAY = ROOT / "src/battle/overlay_12_0224E4FC.c"


class GravityTests(unittest.TestCase):
    def test_the_moves_gravity_forbids(self):
        body = re.search(r"sGravityUnusableMoves\[\] = \{(.*?)\};", OVERLAY.read_text(), re.S).group(1)
        self.assertEqual(sorted(re.findall(r"MOVE_\w+", body)), sorted(
            ["MOVE_BOUNCE", "MOVE_FLY", "MOVE_SKY_DROP", "MOVE_SPLASH", "MOVE_JUMP_KICK", "MOVE_FLYING_PRESS",
             "MOVE_HI_JUMP_KICK", "MOVE_MAGNET_RISE", "MOVE_TELEKINESIS"]))


if __name__ == "__main__":
    unittest.main()
