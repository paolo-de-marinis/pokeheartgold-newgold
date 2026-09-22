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


if __name__ == "__main__":
    unittest.main()
