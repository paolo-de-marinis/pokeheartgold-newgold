#!/usr/bin/env python3
"""The added moves' targets and flags where the engine's records are wrong.

The importer writes them (import_moves.FIELDS_HERE); each test reads the
record in files/poketool/waza/waza_tbl.narc and fails if the importer's
correction is taken back.
"""

import unittest

from test_implemented_moves import record
import import_moves

RANGE_USER = 1 << 4
FLAG = import_moves.FLAG_BITS


def flags(move):
    return {name for name, bit in FLAG.items() if record(move)[9] & (1 << bit)}


class TakeHeartTests(unittest.TestCase):
    def test_take_heart_is_aimed_at_its_user(self):
        # Pokemon Central, Baldimpulso: the user; snatched, not stopped by
        # Protect, not sent back, not copied by Mirror Move.
        self.assertEqual(record("TAKE_HEART")[7], RANGE_USER)
        self.assertEqual(flags("TAKE_HEART") & {"FLAG_PROTECT", "FLAG_MAGIC_COAT", "FLAG_MIRROR_MOVE", "FLAG_SNATCH"},
                         {"FLAG_SNATCH"})


if __name__ == "__main__":
    unittest.main()
