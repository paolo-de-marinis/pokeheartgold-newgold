#!/usr/bin/env python3
"""A drain move heals its user its share of the damage, rounded to the
nearest with a half going up (Pokemon Central, Spruzzate; Showdown's gen-9
spreadDamage, Math.round for every drain from the fifth generation): 15
damage drains 8 at a half, 7 damage drains 5 at three quarters.

The scripts' arithmetic on HP_CALC is played out here for each damage, the
damage negative as HIT_DAMAGE holds it, the divisions as DamageDivide does
them (towards zero, never to 0)."""

import re
import unittest
from fractions import Fraction

from test_level_cap import ROOT

SUBSCRIPTS = ROOT / "files/battledata/script/subscript"


def drained(script, damage):
    hp = -damage
    for op, value in re.findall(r"^\s+(UpdateVar OPCODE_(?:MUL|ADD),|DivideVarByValue) BSCRIPT_VAR_HP_CALC, (-?\d+)",
                                script.split("CheckItemHoldEffect")[0], re.M):
        value = int(value)
        if "MUL" in op:
            hp *= value
        elif "ADD" in op:
            hp += value
        else:
            hp = int(hp / value) or (-1 if hp < 0 else 1)
    return -hp


class DrainTests(unittest.TestCase):
    def check(self, name, share):
        script = next(SUBSCRIPTS.glob(f"subscript_*_{name}.s")).read_text()
        for damage in range(1, 200):
            exact = damage * share
            self.assertEqual(drained(script, damage), int(exact + Fraction(1, 2)), (name, damage))

    def test_half_rounds_up(self):
        self.check("DrainHalfDamageDealt", Fraction(1, 2))
        self.check("DreamEater", Fraction(1, 2))

    def test_three_quarters_round_to_the_nearest(self):
        self.check("DrainThreeQuarters", Fraction(3, 4))


if __name__ == "__main__":
    unittest.main()
