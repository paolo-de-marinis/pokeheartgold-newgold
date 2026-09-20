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
    "BIG_PECKS",
    "EARTH_EATER",
    "EVAPORATE",
    "IRON_BARBS",
    "IRRIGATION",
    "SAND_RUSH",
    "SAP_SIPPER",
}

# Still only names. Each moves up as its effect lands.
PENDING = {
    "ARMOR_TAIL",
    "BULLETPROOF",
    "CHEEK_POUCH",
    "COMPETITIVE",
    "CUD_CHEW",
    "CURSED_BODY",
    "INFILTRATOR",
    "MUMMY",
    "NEUTRALIZING_GAS",
    "POISON_TOUCH",
    "REGENERATOR",
    "RIPEN",
    "SHARPNESS",
    "SHEER_FORCE",
    "SUPERSWEET_SYRUP",
    "TELEPATHY",
    "UNNERVE",
    "WEAK_ARMOR",
    "WIND_RIDER",
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

    def test_the_absorb_script_is_the_one_that_was_added(self):
        index = self.defines["ABSORB_AND_RAISE_ATTACK"]
        self.assertEqual(self.files[index].name, "subscript_0297_AbsorbAndRaiseAttack.s")
        body = self.files[index].read_text()
        self.assertIn("Call BATTLE_SUBSCRIPT_UPDATE_STAT_STAGE", body)


if __name__ == "__main__":
    unittest.main()
