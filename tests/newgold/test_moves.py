#!/usr/bin/env python3
"""Check the move table and the moves added to it.

Move data is read by index out of one archive, so a record in the wrong place
gives some other move's power and type. The names and descriptions are read
the same way out of their own archives, and nothing checks that the three
agree with each other.
"""

import os
import re
import struct
import sys
import unittest
from pathlib import Path

from test_level_cap import ROOT

sys.path.insert(0, str(ROOT / "tools/newgold"))
import import_moves  # noqa: E402

LAST_RETAIL = 467

REFERENCE = Path(os.environ.get(
    "NEWGOLD_REFERENCE", "/home/paolo/Porting HGSS/hg-engine-newgold-reference"))


def constants(path, prefix):
    text = (ROOT / path).read_text()
    return {m[1]: int(m[2]) for m in
            re.finditer(r"#define (" + prefix + r"[A-Z0-9_]+)\s+(\d+)\s*$", text, re.M)}


def rows(name):
    text = (ROOT / "files/msgdata/msg" / name).read_text()
    return re.findall(r'<row id="[^"]+" index="(\d+)">', text)


class MoveTests(unittest.TestCase):
    def setUp(self):
        self.moves = constants("include/constants/moves.h", "MOVE_")
        self.table = import_moves.read_table()
        # Everything numbered past retail: the reference's moves, brought in
        # by tools/newgold/import_moves.py.
        self.added = {name[len("MOVE_"):]: number for name, number in self.moves.items()
                      if number > LAST_RETAIL}

    def test_the_archive_regenerates_byte_for_byte(self):
        """The importer rebuilds the whole archive, so it has to rebuild the
        part it did not touch exactly as it found it."""
        self.assertEqual(import_moves.write_table(self.table),
                         import_moves.TABLE.read_bytes())

    def test_every_move_has_a_record(self):
        highest = max(self.moves.values())
        self.assertEqual(len(self.table), highest + 1)
        for record in self.table:
            self.assertEqual(len(record), import_moves.RECORD_SIZE)

    def test_the_added_moves_are_numbered_after_retail(self):
        self.assertEqual(sorted(self.added.values()),
                         list(range(LAST_RETAIL + 1, LAST_RETAIL + 1 + len(self.added))))

    def test_retail_moves_are_untouched(self):
        # A few whose numbers anything shifted by one record would spoil.
        types = constants("include/constants/pokemon.h", "TYPE_")
        for name, power, type_, pp in (("POUND", 40, "TYPE_NORMAL", 35),
                                       ("THUNDERBOLT", 95, "TYPE_ELECTRIC", 15),
                                       ("SHADOW_FORCE", 120, "TYPE_GHOST", 5)):
            _, _, gotPower, gotType, _, gotPP = struct.unpack(
                import_moves.RECORD, self.table[self.moves[f"MOVE_{name}"]])[:6]
            self.assertEqual((gotPower, gotType, gotPP), (power, types[type_], pp), name)

    def test_every_added_move_is_usable(self):
        effects = constants("include/constants/move_effects.h", "MOVE_EFFECT_")
        scripts = {int(re.match(r"effect_script_(\d+)", p.stem).group(1)) for p in
                   (ROOT / "files/battledata/script/effect_script").glob("effect_script_*.s")}
        for name, index in sorted(self.added.items(), key=lambda pair: pair[1]):
            effect, split, power, type_, accuracy, pp = struct.unpack(
                import_moves.RECORD, self.table[index])[:6]
            self.assertIn(effect, effects.values(), name)
            self.assertIn(effect, scripts, f"{name} has no effect script")
            self.assertLess(split, 3, name)
            self.assertLessEqual(power, 250, name)
            self.assertLessEqual(accuracy, 100, name)
            self.assertTrue(1 <= pp <= 40, name)

    def test_the_settings_the_reference_runs_under_are_the_ones_read(self):
        """Three of the added moves have a value written as a choice, and the
        reference's own configuration settles it. Reading the other branch
        would give a weaker Hyper Drill and a Moonblast that lowers Sp. Atk
        three times as often."""
        expected = {"HYPER_DRILL": ("power", 120), "PSYSHIELD_BASH": ("power", 90),
                    "MOONBLAST": ("effectChance", 10)}
        field = {"power": 2, "effectChance": 6}
        for name, (key, value) in expected.items():
            record = struct.unpack(import_moves.RECORD, self.table[self.added[name]])
            self.assertEqual(record[field[key]], value, f"{name} {key}")

    # Four retail moves the same settings move off their HeartGold values, and
    # the three the settings leave alone. Pinned here; checked against the
    # reference itself below when the checkout is there.
    CHAMPIONS_RETAIL = {"GROWTH": dict(type=12, pp=20),
                        "CRABHAMMER": dict(power=100, accuracy=95),
                        "BONE_RUSH": dict(power=30, accuracy=90),
                        "IRON_HEAD": dict(effectChance=20)}
    CHAMPIONS_UNMOVED = {"PROTECT": dict(pp=10), "SANDSTORM": dict(pp=10),
                         "NIGHT_SLASH": dict(pp=15)}
    FIELD = {"power": 2, "type": 3, "accuracy": 4, "pp": 5, "effectChance": 6}

    def test_the_four_retail_moves_the_settings_move(self):
        """CHAMPIONS_PP_CHANGES is off and the other four are on, so of the
        seven retail moves the reference writes as a choice, four take a value
        this game did not have: a Grass-type Growth, a 95-accuracy Crabhammer,
        a 30-power Bone Rush and an Iron Head that flinches one time in five."""
        for name, wanted in {**self.CHAMPIONS_RETAIL, **self.CHAMPIONS_UNMOVED}.items():
            record = struct.unpack(import_moves.RECORD, self.table[self.moves[f"MOVE_{name}"]])
            for key, value in wanted.items():
                self.assertEqual(record[self.FIELD[key]], value, f"{name} {key}")

    @unittest.skipUnless(REFERENCE.exists(), "the reference checkout is not here")
    def test_those_four_records_are_the_reference_s_own(self):
        """Not only the field the setting decides: half of konefr's Crabhammer
        would be neither game's move."""
        import_moves.read_conditions(REFERENCE)
        blocks = import_moves.reference_records(REFERENCE)
        types = constants("include/constants/pokemon.h", "TYPE_")
        for name in import_moves.CHAMPIONS_RETAIL:
            block = blocks[name]
            record = struct.unpack(import_moves.RECORD, self.table[self.moves[f"MOVE_{name}"]])
            self.assertEqual(record[2], import_moves.number(block, "power"), name)
            self.assertEqual(record[3], types[import_moves.field(block, "type")], name)
            self.assertEqual(record[4], import_moves.number(block, "accuracy"), name)
            self.assertEqual(record[5], import_moves.number(block, "pp"), name)
            self.assertEqual(record[6], import_moves.number(block, "effectChance"), name)

    # Forty-one damaging moves carry no power, and the reference carries them
    # the same way, because the battle works the damage out instead: a Z-move
    # takes the power of the move it was made from, and five more take the
    # user's friendship or the target's health.
    POWER_AT_RUNTIME = {"GUARDIAN_OF_ALOLA", "NATURES_MADNESS", "PIKA_PAPOW",
                        "VEEVEE_VOLLEY", "HARD_PRESS"}

    def test_a_status_move_has_no_power_and_a_damaging_one_has_some(self):
        for name, index in self.added.items():
            if name.endswith(("_PHYSICAL", "_SPECIAL")) or name in self.POWER_AT_RUNTIME:
                continue
            _, split, power = struct.unpack(import_moves.RECORD, self.table[index])[:3]
            self.assertEqual(power == 0, split == 2, name)

    def test_the_three_message_banks_agree_with_the_table(self):
        last = str(len(self.table) - 1)
        for bank in ("msg_0749.gmm", "msg_0750.gmm", "msg_0751.gmm"):
            indices = rows(bank)
            self.assertEqual(len(indices), len(self.table), bank)
            self.assertEqual(indices[-1], last, bank)

    def test_every_added_move_borrows_an_animation_that_exists(self):
        """The animation archive stops where retail's moves stopped."""
        source = (ROOT / "src/battle/battle_command.c").read_text()
        body = re.search(r"static const u16 borrowed\[NUM_ADDED_MOVES\] = \{(.*?)\};", source, re.S).group(1)
        borrowed = re.findall(r"MOVE_[A-Z0-9_]+", body)
        self.assertEqual(len(borrowed), len(self.added))
        for move in borrowed:
            self.assertIn(move, self.moves, move)
            self.assertLessEqual(self.moves[move], LAST_RETAIL, move)


if __name__ == "__main__":
    unittest.main()
