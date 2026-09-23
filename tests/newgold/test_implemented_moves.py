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

from test_level_cap import ROOT, function

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

    def test_aromatic_mist_raises_the_ally_s_sp_def(self):
        # Pokemon Central (Nebularoma): the ally's Sp. Def, a stage; with no
        # ally standing it fails, as Coaching does.
        self.assertImplemented("AROMATIC_MIST", "MOVE_EFFECT_RAISE_ALLY_SP_DEF")
        script = effect_script("MOVE_EFFECT_RAISE_ALLY_SP_DEF")
        self.assertIn("BSCRIPT_VAR_BATTLE_TYPE, BATTLE_TYPE_DOUBLES, _NO_PARTNER", script)
        self.assertIn("BATTLER_RELATIVE_ALLY|BATTLER_CATEGORY_ATTACKER, BMON_DATA_HP, 0, _NO_PARTNER", script)
        self.assertIn("MOVE_SIDE_EFFECT_TO_DEFENDER|MOVE_SUBSCRIPT_PTR_SP_DEFENSE_UP_1_STAGE", script)

    def test_an_effect_written_here_survives_a_rerun(self):
        # The importer rewrites move_effects.h from the base header and the
        # reference's block; the effects written here sit after that block
        # and must come through both.
        here = import_moves.effects_written_here()
        self.assertIn("MOVE_EFFECT_RAISE_ALLY_SP_DEF", here)
        self.assertEqual(min(here.values()), 409)
        kept = import_moves.original("include/constants/move_effects.h")
        self.assertIn("#define MOVE_EFFECT_RAISE_ALLY_SP_DEF", kept)
        self.assertNotIn("MOVE_EFFECT_HIT_THREE_TIMES_FLAT", kept)

    def test_hard_press_is_worth_the_share_of_hp_left(self):
        # Pokemon Central (Pressa d'Acciaio): 100 times the target's HP over
        # its maximum, 1 at the least; Wring Out's effect, asked for the move.
        self.assertImplemented("HARD_PRESS", "MOVE_EFFECT_INCREASE_POWER_WITH_MORE_HP")
        self.assertEqual(record("HARD_PRESS")[2], 1)
        body = function((ROOT / "src/battle/battle_command.c").read_text(), "BtlCmd_CalcWringOutPower")
        hard = body[body.index("MOVE_HARD_PRESS"):body.index("return FALSE;")]
        self.assertIn("(100 * ctx->battleMons[ctx->battlerIdTarget].hp) / ctx->battleMons[ctx->battlerIdTarget].maxHp", hard)
        self.assertIn("if (ctx->movePower == 0) {\n            ctx->movePower = 1;", hard)

    def test_upper_hand_answers_only_a_priority_attack(self):
        # Pokemon Central (Colpo di Mano): it fails unless the target chose an
        # attack going at +1 to +3 and has not moved; it always flinches.
        self.assertImplemented("UPPER_HAND", "MOVE_EFFECT_UPPER_HAND")
        self.assertEqual(record("UPPER_HAND")[6], 100)
        script = effect_script("MOVE_EFFECT_UPPER_HAND")
        self.assertLess(script.index("TrySuckerPunch _FAILED"), script.index("MOVE_SIDE_EFFECT_TO_DEFENDER|MOVE_SUBSCRIPT_PTR_FLINCH"))
        body = function((ROOT / "src/battle/battle_command.c").read_text(), "BtlCmd_TrySuckerPunch")
        self.assertIn("ctx->moveNoCur == MOVE_UPPER_HAND", body)
        self.assertIn("BattlerMovePriority(ctx, ctx->battlerIdTarget, move) < 1 || BattlerMovePriority(ctx, ctx->battlerIdTarget, move) > 3", body)

if __name__ == "__main__":
    unittest.main()
