#!/usr/bin/env python3
"""Check the Bug-Catching Contest prizes.

New Gold replaces what the contest hands out. The reference does it by
patching the built script's bytes, because hg-engine has no source for that
script; this game does, so it is written there. The hazard is the same either
way: a prize table whose branches do not cover every roll leaves a placing
with whatever the original judging put in the variable.
"""

import re
import unittest
from pathlib import Path

from test_level_cap import ROOT

SCRIPT = ROOT / "files/fielddata/script/scr_seq/scr_seq_0151.s"


class BugContestTests(unittest.TestCase):
    def setUp(self):
        self.source = SCRIPT.read_text()
        self.items = set(re.findall(r"#define (ITEM_[A-Z0-9_]+)",
                                    (ROOT / "include/constants/items.h").read_text()))

    def test_the_prize_routine_is_called_where_the_judging_ends(self):
        self.assertIn("JudgeBugContest VAR_TEMP_x4000, VAR_TEMP_x4001, VAR_TEMP_x4002\n"
                      "\tCall _NEWGOLD_BUG_CONTEST_PRIZE\n", self.source)

    def test_every_prize_is_an_item_this_game_has(self):
        prizes = re.findall(r"SetVar VAR_TEMP_x4001, (ITEM_[A-Z0-9_]+)", self.source)
        self.assertGreater(len(prizes), 20)
        for item in prizes:
            self.assertIn(item, self.items, item)

    def test_every_roll_lands_on_a_prize(self):
        """Random N gives 0..N-1; N-1 of those branch and the last falls
        through, so a table has to have exactly one fewer branch than its
        range or a roll ends up somewhere else."""
        for block in re.finditer(r"Random VAR_SPECIAL_RESULT, (\d+)\n(.*?)\n\n", self.source, re.S):
            size = int(block.group(1))
            branches = re.findall(r"Compare VAR_SPECIAL_RESULT, (\d+)\n\tGoToIfEq", block.group(2))
            self.assertEqual([int(n) for n in branches], list(range(size - 1)))
            self.assertIn("GoTo _NEWGOLD_PRIZE_", block.group(2))

    def test_every_branch_has_somewhere_to_land(self):
        targets = set(re.findall(r"^(_NEWGOLD_[A-Z_]+):", self.source, re.M))
        for name in re.findall(r"(?:GoToIfEq|GoTo|Call) (_NEWGOLD_[A-Z_]+)", self.source):
            self.assertIn(name, targets, name)

    def test_the_routine_returns_rather_than_falling_into_the_next(self):
        body = self.source[self.source.index("_NEWGOLD_BUG_CONTEST_PRIZE:"):]
        for block in re.finditer(r"SetVar VAR_TEMP_x4001, ITEM_[A-Z0-9_]+\n(\t\w+)", body):
            self.assertEqual(block.group(1).strip(), "Return")


if __name__ == "__main__":
    unittest.main()
