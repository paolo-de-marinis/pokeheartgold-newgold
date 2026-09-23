#!/usr/bin/env python3
"""The trainer AI reads a move's data through BattleMoveTbl.

The move table a battle keeps (trainerAIData.moveData) is retail's length;
the added moves live past the end of the context and only BattleMoveTbl
knows where. A routine that indexes moveData itself reads an unrelated part
of the context for every move numbered past 467 -- hg-engine repoints each
of these reads to its own, full-length table.
"""

import unittest

from test_level_cap import ROOT

# The routines that read a move's data, as they come out of the assembly.
SOURCES = (
    "src/battle/overlay_12_02258800.c",
)


class TrainerAIMoveData(unittest.TestCase):
    def test_no_read_by_offset(self):
        for path in SOURCES:
            with self.subTest(path=path):
                source = (ROOT / path).read_text()
                self.assertNotIn("trainerAIData.moveData", source)
                self.assertIn("BattleMoveTbl(ctx, ", source)


if __name__ == "__main__":
    unittest.main()
