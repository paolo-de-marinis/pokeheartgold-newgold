#!/usr/bin/env python3
"""Check the assembled ball-throw script really grants experience on a capture.

The interesting part of a battle script is its control flow, and the jump
offsets only exist once the assembler has run. So this decodes the built
bytecode rather than reading the source, and skips when the script has not been
built yet. It does not run the script: that needs a ROM.
"""

import struct
from pathlib import Path
import unittest

from test_level_cap import ROOT

SCRIPT = ROOT / "files/battledata/script/subscript/subscript_0011_ThrowBall.bin"

# Command numbers from asm/macros/btlcmd.inc.
UPDATE_VAR = 50
CALC_EXP_GAIN = 39
START_GET_EXP_TASK = 40
WAIT_GET_EXP_TASK = 41
DUMMY_2A = 42
TRY_RESTORE_STATUS_ON_SWITCH = 209

# Constants the script uses, from include/constants.
OPCODE_SET = 7
BSCRIPT_VAR_BATTLER_FAINTED = 18
BATTLER_ENEMY = 1


class CaptureExperienceTests(unittest.TestCase):
    def setUp(self):
        if not SCRIPT.exists():
            self.skipTest(f"{SCRIPT.name} is a build artefact; build a ROM first")
        data = SCRIPT.read_bytes()
        self.words = list(struct.unpack("<%dI" % (len(data) // 4), data))

    def test_capture_runs_the_experience_commands(self):
        words = self.words
        self.assertEqual(words.count(CALC_EXP_GAIN), 1, "one experience grant, on the capture path")
        start = words.index(CALC_EXP_GAIN)

        # The battler the experience is calculated for is set just before it.
        setter = start - 4
        self.assertEqual(
            words[setter:start],
            [UPDATE_VAR, OPCODE_SET, BSCRIPT_VAR_BATTLER_FAINTED, BATTLER_ENEMY],
        )

        # Then the ordinary experience sequence, as subscript 276 spells it.
        self.assertEqual(words[start + 2], START_GET_EXP_TASK)
        self.assertEqual(words[start + 3], WAIT_GET_EXP_TASK)
        self.assertEqual(words[start + 4], DUMMY_2A)

    def test_no_experience_rejoins_the_capture_path(self):
        words = self.words
        start = words.index(CALC_EXP_GAIN)
        # A relative jump, counted from the word after the operand.
        jump = struct.unpack("<i", struct.pack("<I", words[start + 1]))[0]
        target = start + 2 + jump
        self.assertGreater(jump, 0, "the skip goes forward, past the experience commands")
        self.assertEqual(
            words[target],
            TRY_RESTORE_STATUS_ON_SWITCH,
            "skipping experience must land back on the capture path, not past it",
        )


if __name__ == "__main__":
    unittest.main()
