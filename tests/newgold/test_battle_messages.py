#!/usr/bin/env python3
"""Check that every line a battle script prints is a line the bank holds.

ReadMsgData_ExistingTable_ExistingArray asserts and leaves the string
untouched when the row is past the end of the bank, and a failed assertion in
this build says nothing, so a move whose script points at a row that is not
there simply prints nothing and carries on. That is how a Fairy move printed
an empty type for weeks.

The scripts imported from the reference carry the reference's own row
numbers, and its bank is longer than this one: twenty-four of them pointed
past the end. They are rows here now, at this bank's own indices. This test
is the thing that would have said so.
"""

import re
import unittest
from pathlib import Path

from test_level_cap import ROOT

BANK = ROOT / "files/msgdata/msg/msg_0197.gmm"
SCRIPTS = ROOT / "files/battledata"


def rows():
    return {int(i) for i in re.findall(r'<row id="[^"]*" index="(\d+)"', BANK.read_text())}


def printed():
    """Every row a battle script asks the bank for, named or numbered."""
    out = []
    for path in sorted(SCRIPTS.rglob("*.s")):
        text = path.read_text(errors="replace")
        for line, content in enumerate(text.splitlines(), 1):
            match = re.search(r"PrintMessage\s+(?:msg_0197_0*(\d+)|(\d+))", content)
            if match:
                out.append((path.name, line, int(match.group(1) or match.group(2))))
    return out


class BattleMessageTests(unittest.TestCase):
    def test_the_bank_has_no_holes(self):
        have = rows()
        self.assertEqual(have, set(range(max(have) + 1)),
                         "the bank is read as an array, so a missing index is a hole")

    def test_every_line_a_script_prints_is_in_the_bank(self):
        have = rows()
        for name, line, index in printed():
            self.assertIn(index, have, f"{name}:{line} prints row {index}, and the bank "
                                       f"stops at {max(have)}")

    def test_the_scripts_name_rows_rather_than_number_them(self):
        for path in sorted(SCRIPTS.rglob("*.s")):
            for line, content in enumerate(path.read_text(errors="replace").splitlines(), 1):
                self.assertIsNone(re.search(r"PrintMessage\s+\d", content),
                                  f"{path.name}:{line} prints a bare number; use its "
                                  f"msg_0197_NNNNN name so the reference's numbering "
                                  f"cannot be mistaken for this bank's")


if __name__ == "__main__":
    unittest.main()
