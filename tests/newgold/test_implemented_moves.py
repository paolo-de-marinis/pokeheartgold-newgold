#!/usr/bin/env python3
"""The added moves the engine leaves unimplemented, given their effect here.

hg-engine (d0380a487) flags seventy-nine moves FLAG_UNUSABLE_UNIMPLEMENTED
and gives them a bare hit; the flag keeps them out of learnsets, trainers and
battle. Paolo's rule is that nothing the reference leaves empty stays empty:
each move here is written as Pokemon Central has it, loses the flag, and is
named in import_moves.IMPLEMENTED_HERE with its effect so the importer writes
the same record on a rerun. Each test fails if its move is taken back.
"""

import re
import struct
import sys
import unittest

from test_level_cap import ROOT

sys.path[:0] = [str(ROOT / "tools/newgold/import")]
import import_moves  # noqa: E402

SCRIPTS = ROOT / "files/battledata/script"


def defines(path, prefix):
    return {name: int(value) for name, value in re.findall(
        r"#define (" + prefix + r"[A-Z0-9_]+)\s+(\d+)\b", (ROOT / path).read_text())}


MOVES = defines("include/constants/moves.h", "MOVE_")
EFFECTS = defines("include/constants/move_effects.h", "MOVE_EFFECT_")


def record(move):
    return struct.unpack(import_moves.RECORD, import_moves.read_table()[MOVES[f"MOVE_{move}"]])


def effect_script(effect):
    return (SCRIPTS / f"effect_script/effect_script_{EFFECTS[effect]:04d}.s").read_text()


class ImplementedMoveTests(unittest.TestCase):
    def assertImplemented(self, move, effect):
        fields = record(move)
        self.assertEqual(fields[0], EFFECTS[effect], move)
        self.assertFalse(fields[9] & 1 << 5, f"{move} still carries the unimplemented flag")
        self.assertEqual(import_moves.IMPLEMENTED_HERE.get(move), effect, move)

    def test_tera_blast_is_a_plain_hit_without_terastallization(self):
        # Pokemon Central (Terascoppio): it changes type and split only when
        # the user is terastallized, which no Pokemon here can be.
        self.assertImplemented("TERA_BLAST", "MOVE_EFFECT_HIT")


    def test_confide_lowers_sp_atk_through_protect(self):
        # Pokemon Central (Confidenza): one stage, past Protect -- its record
        # has no protect bit -- and past a substitute, as a sound move.
        self.assertImplemented("CONFIDE", "MOVE_EFFECT_SP_ATK_DOWN")
        self.assertIn("MOVE_SUBSCRIPT_PTR_SP_ATTACK_DOWN_1_STAGE", effect_script("MOVE_EFFECT_SP_ATK_DOWN"))
        self.assertFalse(record("CONFIDE")[9] & 1 << 1)

if __name__ == "__main__":
    unittest.main()
