#!/usr/bin/env python3
"""The added moves' targets and flags where the engine's records are wrong.

The importer writes them (import_moves.FIELDS_HERE); each test reads the
record in files/poketool/waza/waza_tbl.narc and fails if the importer's
correction is taken back.
"""

import struct
import unittest

from test_implemented_moves import MOVES, record
import import_moves

RANGE_USER = 1 << 4
FLAG = import_moves.FLAG_BITS


def record_at(table, move):
    return struct.unpack(import_moves.RECORD, table[move])


def flags(move):
    return {name for name, bit in FLAG.items() if record(move)[9] & (1 << bit)}


class TakeHeartTests(unittest.TestCase):
    def test_take_heart_is_aimed_at_its_user(self):
        # Pokemon Central, Baldimpulso: the user; snatched, not stopped by
        # Protect, not sent back, not copied by Mirror Move.
        self.assertEqual(record("TAKE_HEART")[7], RANGE_USER)
        self.assertEqual(flags("TAKE_HEART") & {"FLAG_PROTECT", "FLAG_MAGIC_COAT", "FLAG_MIRROR_MOVE", "FLAG_SNATCH"},
                         {"FLAG_SNATCH"})


class UnguardedMoveTests(unittest.TestCase):
    def test_no_move_aimed_at_its_user_or_the_field_has_the_protect_flag(self):
        # Pokemon Central: "Non è bloccata da Protezione e Individua" for each
        # of them; the engine's records gave twenty-eight the flag. Bide,
        # retail's hit at whoever struck its user, keeps it.
        table = import_moves.read_table()
        flagged = [move for move in range(1, len(table))
                   if record_at(table, move)[7] & import_moves.UNGUARDED_TARGETS
                   and record_at(table, move)[9] & (1 << FLAG["FLAG_PROTECT"])]
        self.assertEqual(flagged, [MOVES["MOVE_BIDE"]])
        for move in ("VICTORY_DANCE", "ELECTRIC_TERRAIN", "AURORA_VEIL", "SHED_TAIL"):
            self.assertNotIn("FLAG_PROTECT", flags(move), move)


if __name__ == "__main__":
    unittest.main()
