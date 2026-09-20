#!/usr/bin/env python3
"""Check the type chart the ROM compiles with.

The chart is a sparse list of attacker, defender and multiplier triples, so the
change is data rather than logic: this reads the table out of
src/battle/overlay_12_0224E4FC.c and checks the Fairy matchups, Steel's lost
resistances and the invariants the lookup relies on.
"""

import re
import unittest

from test_level_cap import ROOT

NOT_EFFECTIVE = "TYPE_MUL_NOT_EFFECTIVE"
NORMAL = "TYPE_MUL_NORMAL"
SUPER = "TYPE_MUL_SUPER_EFFECTIVE"
NO_EFFECT = "TYPE_MUL_NO_EFFECT"

FAIRY_ATTACKING = {
    "TYPE_FIGHTING": SUPER,
    "TYPE_DRAGON": SUPER,
    "TYPE_DARK": SUPER,
    "TYPE_FIRE": NOT_EFFECTIVE,
    "TYPE_POISON": NOT_EFFECTIVE,
    "TYPE_STEEL": NOT_EFFECTIVE,
}

ATTACKING_FAIRY = {
    "TYPE_POISON": SUPER,
    "TYPE_STEEL": SUPER,
    "TYPE_FIGHTING": NOT_EFFECTIVE,
    "TYPE_BUG": NOT_EFFECTIVE,
    "TYPE_DARK": NOT_EFFECTIVE,
    "TYPE_DRAGON": NO_EFFECT,
}


def chart():
    source = (ROOT / "src/battle/overlay_12_0224E4FC.c").read_text()
    table = source[source.index("static const u8 sTypeEffectiveness[][3] = {"):]
    table = table[:table.index("};")]
    return re.findall(r"\{\s*(\w+),\s*(\w+),\s*(\w+)\s*\}", table)


class FairyTypeTests(unittest.TestCase):
    def setUp(self):
        self.rows = chart()
        # Everything past the Foresight marker is the set those moves ignore.
        marker = self.rows.index(("TYPE_FORESIGHT", "TYPE_FORESIGHT", NO_EFFECT))
        self.ordinary = self.rows[:marker]
        self.matchups = {(a, d): m for a, d, m in self.ordinary}

    def test_fairy_attacks(self):
        for defender, multiplier in FAIRY_ATTACKING.items():
            self.assertEqual(self.matchups.get(("TYPE_FAIRY", defender)), multiplier, defender)

    def test_attacks_on_fairy(self):
        for attacker, multiplier in ATTACKING_FAIRY.items():
            self.assertEqual(self.matchups.get((attacker, "TYPE_FAIRY")), multiplier, attacker)

    def test_fairy_has_no_other_entries(self):
        listed = {(a, d) for a, d, _ in self.ordinary if "TYPE_FAIRY" in (a, d)}
        expected = {("TYPE_FAIRY", d) for d in FAIRY_ATTACKING}
        expected |= {(a, "TYPE_FAIRY") for a in ATTACKING_FAIRY}
        self.assertEqual(listed, expected)

    def test_steel_no_longer_resists_ghost_and_dark(self):
        # Removed in the generation the reference targets.
        self.assertNotIn(("TYPE_GHOST", "TYPE_STEEL"), self.matchups)
        self.assertNotIn(("TYPE_DARK", "TYPE_STEEL"), self.matchups)
        # The rest of Steel's defence is untouched.
        self.assertEqual(self.matchups[("TYPE_NORMAL", "TYPE_STEEL")], NOT_EFFECTIVE)
        self.assertEqual(self.matchups[("TYPE_FIRE", "TYPE_STEEL")], SUPER)

    def test_each_matchup_appears_once(self):
        pairs = [(a, d) for a, d, _ in self.ordinary]
        self.assertEqual(len(pairs), len(set(pairs)), "the lookup takes the first match")

    def test_table_is_terminated(self):
        self.assertEqual(self.rows[-1], ("TYPE_ENDTABLE", "TYPE_ENDTABLE", NO_EFFECT))


if __name__ == "__main__":
    unittest.main()
