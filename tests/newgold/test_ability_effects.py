#!/usr/bin/env python3
"""Check that the added abilities do something.

An ability that exists only as a number and a name looks right on the summary
screen and then does nothing in battle, which is the kind of thing nobody
notices until they wonder why a Pokemon keeps fainting. Each one is listed here
as either done or still to do, and a done one has to be read somewhere the
battle actually runs.
"""

import re
import unittest
from pathlib import Path

from test_level_cap import ROOT

HEADER = ROOT / "include/constants/abilities.h"
SUBSCRIPTS = ROOT / "files/battledata/script/subscript"
LAST_VANILLA = 123

IMPLEMENTED = {
    "ARMOR_TAIL",
    "BIG_PECKS",
    "BULLETPROOF",
    "CHEEK_POUCH",
    "COMPETITIVE",
    "CURSED_BODY",
    "EARTH_EATER",
    "EVAPORATE",
    "INFILTRATOR",
    "IRON_BARBS",
    "IRRIGATION",
    "MUMMY",
    "NEUTRALIZING_GAS",
    "POISON_TOUCH",
    "REGENERATOR",
    "RIPEN",
    "SAND_RUSH",
    "SAP_SIPPER",
    "SHARPNESS",
    "SHEER_FORCE",
    "QUICK_DRAW",
    "SUPERSWEET_SYRUP",
    "TELEPATHY",
    "UNNERVE",
    "WEAK_ARMOR",
    "WIND_RIDER",
}

# Cud Chew is a name in New Gold too: the reference declares it and nothing
# reads it, so a Farigiraf there does not bring its berry back up either.
# Giving it an effect here would be a change to the game, not a port of it.
PENDING = {
    "CUD_CHEW",
}


def added():
    return {m.group(1) for m in re.finditer(r"#define ABILITY_([A-Z0-9_]+)\s+(\d+)", HEADER.read_text())
            if int(m.group(2)) > LAST_VANILLA}


def battle_source():
    return "\n".join(path.read_text() for path in sorted((ROOT / "src").rglob("*.c")))


class AbilityEffectTests(unittest.TestCase):
    def test_every_added_ability_is_accounted_for(self):
        self.assertEqual(added(), IMPLEMENTED | PENDING)
        self.assertFalse(IMPLEMENTED & PENDING)

    def test_an_implemented_ability_is_read_by_the_game(self):
        source = battle_source()
        for name in sorted(IMPLEMENTED):
            self.assertIn(f"ABILITY_{name}", source, f"ABILITY_{name} is listed as done but nothing reads it")

    def test_a_pending_ability_is_not_quietly_half_wired(self):
        source = battle_source()
        for name in sorted(PENDING):
            self.assertNotIn(f"ABILITY_{name}", source, f"ABILITY_{name} works now; move it to IMPLEMENTED")

    def test_everything_but_cud_chew_now_does_something(self):
        self.assertEqual(PENDING, {"CUD_CHEW"})


class SubscriptNumberingTests(unittest.TestCase):
    """A subscript is fetched by index into the archive, which is the files in
    name order, so a gap or a stale number runs some other script entirely."""

    def setUp(self):
        self.files = sorted(SUBSCRIPTS.glob("subscript_*.s"))
        self.defines = {m.group(1): int(m.group(2)) for m in
                        re.finditer(r"#define BATTLE_SUBSCRIPT_([A-Z0-9_]+)\s+(\d+)\s*$",
                                    (ROOT / "include/constants/battle_subscript.h").read_text(), re.M)}

    def test_the_files_are_numbered_without_a_gap(self):
        numbers = [int(path.name.split("_")[1]) for path in self.files]
        self.assertEqual(numbers, list(range(len(self.files))))

    def test_no_define_points_past_the_last_script(self):
        self.assertEqual(max(self.defines.values()), len(self.files) - 1)

    def test_each_added_script_is_the_file_it_names(self):
        added = {
            "ABSORB_AND_RAISE_ATTACK": "subscript_0297_AbsorbAndRaiseAttack.s",
            "WEAK_ARMOR": "subscript_0298_WeakArmor.s",
            "CURSED_BODY": "subscript_0299_CursedBody.s",
            "MUMMY": "subscript_0300_Mummy.s",
            "SUPERSWEET_SYRUP": "subscript_0301_SupersweetSyrup.s",
            "CHEEK_POUCH": "subscript_0302_CheekPouch.s",
        }
        for name, filename in added.items():
            self.assertEqual(self.files[self.defines[name]].name, filename)


if __name__ == "__main__":
    unittest.main()


class MoveListTests(unittest.TestCase):
    """Bulletproof and Wind Rider go by a list of moves rather than by type,
    and a name that drifts out of the list simply stops being blocked."""

    SOURCE = ROOT / "src/battle/overlay_12_0224E4FC.c"
    TABLES = ("sBallAndBombMoves", "sSlicingMoves", "sWindMoves")

    def table(self, name):
        body = re.search(r"static const u16 " + name + r"\[\] = \{(.*?)\};",
                         self.SOURCE.read_text(), re.S).group(1)
        return re.findall(r"MOVE_[A-Z0-9_]+", body)

    def test_every_move_named_exists(self):
        defined = set(re.findall(r"#define (MOVE_[A-Z0-9_]+) ",
                                 (ROOT / "include/constants/moves.h").read_text()))
        for table in self.TABLES:
            moves = self.table(table)
            self.assertTrue(moves, table)
            for move in moves:
                self.assertIn(move, defined, f"{table} names {move}")

    def test_the_lists_are_sorted_and_have_no_repeat(self):
        for table in self.TABLES:
            moves = self.table(table)
            self.assertEqual(moves, sorted(moves), table)
            self.assertEqual(len(moves), len(set(moves)), table)


class SheerForceTests(unittest.TestCase):
    """Sheer Force pays for its extra power by losing the effect, so the two
    halves have to agree on which moves that is or it gets the power free."""

    SOURCE = ROOT / "src/battle/overlay_12_0224E4FC.c"

    def test_both_halves_ask_the_same_question(self):
        source = self.SOURCE.read_text()
        self.assertEqual(source.count("IsSuppressibleSecondaryEffect(ctx,"), 2)
        self.assertEqual(source.count("static BOOL IsSuppressibleSecondaryEffect"), 1)

    def test_the_guaranteed_effects_are_left_alone(self):
        body = re.search(r"static BOOL IsSuppressibleSecondaryEffect.*?\n\}", self.SOURCE.read_text(), re.S).group(0)
        for flag in ("MOVE_SIDE_EFFECT_ON_HIT", "MOVE_SIDE_EFFECT_CHECK_SUBSTITUTE",
                     "MOVE_SIDE_EFFECT_CHECK_HP_AND_SUBSTITUTE", "MOVE_SIDE_EFFECT_CHECK_HP"):
            self.assertIn(flag, body)
        self.assertIn("effectChance != 0", body)
