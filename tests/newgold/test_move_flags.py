#!/usr/bin/env python3
"""The added moves' targets and flags where the engine's records are wrong.

The importer writes them (import_moves.FIELDS_HERE); each test reads the
record in files/poketool/waza/waza_tbl.narc and fails if the importer's
correction is taken back.
"""

import struct
import unittest

from test_implemented_moves import MOVES, record
from test_level_cap import ROOT, function
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

    def test_no_move_aimed_at_its_user_an_ally_or_the_field_is_sent_back(self):
        # Pokemon Central: "Non è riflessa da Magivelo e Magispecchio" for each
        # of them; the engine's records gave thirty-three the Magic Coat flag,
        # and a Magic Bounce holder bounced its own Victory Dance back at
        # itself without end.
        table = import_moves.read_table()
        flagged = [move for move in range(1, len(table))
                   if record_at(table, move)[7] & import_moves.UNREFLECTED_TARGETS
                   and record_at(table, move)[9] & (1 << FLAG["FLAG_MAGIC_COAT"])]
        self.assertEqual(flagged, [])
        # Nor is anything sent back to a Pokemon that is its own target.
        bounce = function((ROOT / "src/battle/battle_controller_player.c").read_text(), "ov12_0224C204")
        self.assertIn("&& ctx->battlerIdTarget != ctx->battlerIdAttacker && !(ctx->battleStatus2 & BATTLE_STATUS2_MAGIC_COAT) "
                      "&& (ctx->turnData[ctx->battlerIdTarget].magicCoatFlag || bouncedByAbility)", bounce)

    def test_a_move_sent_back_is_not_sent_back_again(self):
        # Showdown, gen 9: a bounced move hasBounced. BtlCmd_MagicCoat marks
        # the move it turns round, and the move's end clears the mark: two
        # Magic Bounce holders sent a Toxic back and forth without end.
        bounce = function((ROOT / "src/battle/battle_controller_player.c").read_text(), "ov12_0224C204")
        self.assertIn("!(ctx->battleStatus2 & BATTLE_STATUS2_MAGIC_COAT) && (ctx->turnData[ctx->battlerIdTarget].magicCoatFlag", bounce)
        coat = function((ROOT / "src/battle/battle_command.c").read_text(), "BtlCmd_MagicCoat")
        self.assertIn("ctx->battleStatus2 |= BATTLE_STATUS2_MAGIC_COAT;", coat)
        end = function((ROOT / "src/battle/battle_controller_player.c").read_text(), "ov12_0224D03C")
        self.assertIn("ctx->battleStatus2 &= ~BATTLE_STATUS2_MAGIC_COAT;", end)

    def test_none_of_them_is_copied_by_mirror_move_but_five(self):
        # Pokemon Central: "Non può essere copiata da Speculmossa" for each of
        # them but Court Change, Fairy Lock, Magic Room, Wonder Room and
        # Power Shift. Mirror Move copies the last move aimed at its user, so
        # the flag on Victory Dance let a Pokemon copy its own. Retail's Trick
        # Room keeps retail's flag.
        table = import_moves.read_table()
        flagged = {move for move in range(MOVES["MOVE_SHADOW_FORCE"] + 1, len(table))
                   if record_at(table, move)[7] & import_moves.UNREFLECTED_TARGETS
                   and record_at(table, move)[9] & (1 << FLAG["FLAG_MIRROR_MOVE"])}
        self.assertEqual(flagged, {MOVES[f"MOVE_{name}"] for name in
                                   ("COURT_CHANGE", "FAIRY_LOCK", "MAGIC_ROOM", "WONDER_ROOM", "POWER_SHIFT")})

    def test_the_bounce_names_the_pokemon_that_sends_it_back(self):
        # hg-engine's subscript 139 at d0380a487: "{0} bounced the {1} back!"
        # with {0} the defender, the Pokemon with the coat or the ability;
        # retail's line named the move's user, and the port printed the
        # engine's text with retail's names.
        script = (ROOT / "files/battledata/script/subscript/subscript_0139_MagicCoat.s").read_text()
        self.assertIn("PrintMessage msg_0197_00574, TAG_NICKNAME_MOVE, BATTLER_CATEGORY_DEFENDER, BATTLER_CATEGORY_ATTACKER", script)

    def test_snatch_takes_the_ones_pokemon_central_says_it_takes(self):
        # "Può essere rubata da Scippo"; the engine's records left these off.
        for move in ("AURORA_VEIL", "CLANGOROUS_SOUL", "FILLET_AWAY", "GEAR_UP", "LASER_FOCUS", "LIFE_DEW",
                     "LUNAR_BLESSING", "MAGNETIC_FLUX", "MAT_BLOCK", "SHELTER", "SHORE_UP", "STUFF_CHEEKS",
                     "VICTORY_DANCE"):
            self.assertIn("FLAG_SNATCH", flags(move), move)


if __name__ == "__main__":
    unittest.main()
