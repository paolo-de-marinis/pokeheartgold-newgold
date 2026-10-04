#!/usr/bin/env python3
"""konefr's developer vendor lives only in the diagnostics build.

His password (0-2-5-1) and his Rare Candies at 1 each are a page of the
EV/IV trainer in a NEWGOLD_DIAG=1 build; the ordinary build is byte for
byte the build without them, which holds as long as every line of the
vendor sits under #ifdef NEWGOLD_DIAG. That is what this reads the app for;
the ROM was compared when the page came in, and the scenario
ev_iv_trainer_developer_vendor plays it on the diagnostics ROM.
"""

import re
import unittest

from test_repels import ROOT, read

VENDOR = re.compile(r"\b(PAGE_DEV|devMsg|devDigits|devCursor|devOpen|devLine|sDevPassword|sDevQuantities|"
                    r"DrawDevPage|Trainer_DevInput|DevLine|ITEM_RARE_CANDY|msg_0550_T21_000(2[5-9]|3\d|4[0-8]))\b")


def unguarded(text):
    stack, found = [], []
    for number, line in enumerate(text.splitlines(), 1):
        directive = line.strip()
        if directive.startswith("#"):
            words = directive[1:].split()
            if words[0] in ("if", "ifdef", "ifndef"):
                stack.append(words[0] == "ifdef" and words[1] == "NEWGOLD_DIAG")
            elif words[0] in ("else", "elif"):
                stack[-1] = False
            elif words[0] == "endif":
                stack.pop()
            continue
        if not any(stack) and VENDOR.search(line.split("//")[0]):
            found.append(f"{number}: {line.strip()}")
    return found


class DeveloperVendorTests(unittest.TestCase):
    def test_every_line_of_it_is_under_the_define(self):
        app = read("src/ev_iv_trainer_app.c")
        self.assertIn("sDevPassword[4] = { 0, 2, 5, 1 }", app)
        self.assertEqual(unguarded(app), [])

    def test_it_is_his_password_and_his_prices(self):
        """b23dc7360's script: the digits 0, 2, 5, 1, and 1 a Candy in fours of 1, 10, 50 and 99."""
        app = read("src/ev_iv_trainer_app.c")
        self.assertIn("sDevQuantities[4] = { 1, 10, 50, 99 }", app)
        self.assertIn("PlayerProfile_SubMoney(app->profile, i);", app)
        names = (ROOT / "files/msgdata/msg/msg_0550_T21.gmm").read_text(encoding="utf-8")
        for line in ("Rare Candy x1 - $1", "Rare Candy x99 - $99", "Password?", "Wrong password."):
            self.assertIn(line, names)


if __name__ == "__main__":
    unittest.main()
