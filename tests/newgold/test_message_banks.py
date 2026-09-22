#!/usr/bin/env python3
"""Every message bank row exists once.

A bank is read by row index, and a row written twice is read as the first
copy: the Dex text importer once appended its rows on every run, and the two
Galarian lines showed an empty entry because their first copies were blank.
"""

import collections
import re
import unittest

from test_level_cap import ROOT


class MessageBankTests(unittest.TestCase):
    def test_no_bank_has_a_row_twice(self):
        twice = {}
        for bank in sorted((ROOT / "files/msgdata/msg").glob("*.gmm")):
            counts = collections.Counter(re.findall(r'<row id="[^"]*" index="(\d+)">', bank.read_text()))
            again = sorted(int(index) for index, n in counts.items() if n > 1)
            if again:
                twice[bank.name] = again[:5]
        self.assertEqual(twice, {}, "rows written more than once, by bank")

    def test_every_move_has_its_used_lines(self):
        """"X used Y!" is row 3 * move + side of bank 3, read by the battle
        without a bound: a move with no row there asserts the moment anyone
        uses it, and the battle stops. The bank stopped at Shadow Force until
        Morty's Hex found it."""
        moves = (ROOT / "include/constants/moves.h").read_text()
        last = re.search(r"#define NUM_MOVES_TOTAL MOVE_(\w+)", moves).group(1)
        last = int(re.search(rf"#define MOVE_{last}\s+(\d+)", moves).group(1))
        bank = (ROOT / "files/msgdata/msg/msg_0003_EVERYWHERE.gmm").read_text(encoding="utf-8")
        rows = [int(index) for index in re.findall(r'<row id="[^"]*" index="(\d+)">', bank)]
        self.assertEqual(rows, list(range(3 * (last + 1))), "bank 3 is not three rows for every move")
        hex_ = re.search(r"#define MOVE_HEX\s+(\d+)", moves).group(1)
        self.assertIn(f'index="{3 * int(hex_) + 2}">\n\t\t<attribute name="window_context_name">used</attribute>\n'
                      '\t\t<language name="English">The opposing {STRVAR_1 1, 0, 0} used\\nHex!</language>', bank)


if __name__ == "__main__":
    unittest.main()
