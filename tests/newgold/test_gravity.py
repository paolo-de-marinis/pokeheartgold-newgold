#!/usr/bin/env python3
"""Under Gravity (Pokemon Central, Gravita) Bounce, Fly, Sky Drop, Splash,
Jump Kick, Flying Press and High Jump Kick cannot be used, nor the two
moves that lift, Magnet Rise and Telekinesis; and what those two hold up
comes down as Gravity starts, their effect over."""

import re
import unittest

from test_level_cap import ROOT

OVERLAY = ROOT / "src/battle/overlay_12_0224E4FC.c"
COMMANDS = ROOT / "src/battle/battle_command.c"
START = ROOT / "files/battledata/script/subscript/subscript_0156_GravityStart.s"


class GravityTests(unittest.TestCase):
    def test_the_moves_gravity_forbids(self):
        body = re.search(r"sGravityUnusableMoves\[\] = \{(.*?)\};", OVERLAY.read_text(), re.S).group(1)
        self.assertEqual(sorted(re.findall(r"MOVE_\w+", body)), sorted(
            ["MOVE_BOUNCE", "MOVE_FLY", "MOVE_SKY_DROP", "MOVE_SPLASH", "MOVE_JUMP_KICK", "MOVE_FLYING_PRESS",
             "MOVE_HI_JUMP_KICK", "MOVE_MAGNET_RISE", "MOVE_TELEKINESIS"]))

    def test_magnet_rise_and_telekinesis_end_as_it_starts(self):
        case = re.search(r"case MOVE_GRAVITY:\n(.*?)break;", COMMANDS.read_text(), re.S).group(1)
        self.assertIn("ctx->calcTemp = ctx->moveConditions[battlerId].telekinesisTurns;\n"
                      "        ctx->moveConditions[battlerId].telekinesisTurns = 0;", case)
        start = START.read_text()
        self.assertIn("SetMoveConditionFlag MOVE_GRAVITY, BATTLER_CATEGORY_MSG_TEMP\n"
                      "    CompareMonDataToValue OPCODE_NEQ, BATTLER_CATEGORY_MSG_TEMP, BMON_DATA_MAGNET_RISE_TURNS, 0, _065\n"
                      "    CompareVarToValue OPCODE_NEQ, BSCRIPT_VAR_CALC_TEMP, 0, _078\n", start)
        self.assertIn("_065:\n    UpdateMonData OPCODE_SET, BATTLER_CATEGORY_MSG_TEMP, BMON_DATA_MAGNET_RISE_TURNS, 0\n", start)


if __name__ == "__main__":
    unittest.main()
