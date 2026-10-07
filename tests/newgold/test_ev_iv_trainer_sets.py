#!/usr/bin/env python3
"""New Gold's EV sets: konefr's twelve developer presets, with his names.

His debug vendor (b23dc7360, 564419b1a, 725944f6d) set the first party
Pokemon's EVs from twelve presets, DEV_EV_PRESET_RESET to _FAST_BULK (2000
to 2011) in ScrCmd_GiveEgg, offered in his menu in an order of his own, with
names in Cherrygrove City's bank. The EV/IV trainer's Sets page offers the
same twelve in that order, by those rows; each fits 252 a stat and 510.

Read against his code when the reference checkout is there, and against
the values written out here in any case.
"""

import re
import subprocess
import unittest

from test_repels import REFERENCE, ROOT, read

# His menu's order, his names, and the EVs as HP, Atk, Def, Spe, SpA, SpD.
KONEFR = [
    ("Physical", 2001, (4, 252, 0, 252, 0, 0)),
    ("Special", 2002, (4, 0, 0, 252, 252, 0)),
    ("Physical Tank", 2003, (252, 0, 252, 0, 0, 4)),
    ("Special Tank", 2004, (252, 0, 4, 0, 0, 252)),
    ("Balanced", 2005, (84, 84, 84, 84, 84, 84)),
    ("Bulk Physical", 2006, (252, 252, 0, 4, 0, 0)),
    ("Bulk Special", 2007, (252, 0, 0, 4, 252, 0)),
    ("Mixed Tank", 2008, (252, 0, 128, 0, 0, 128)),
    ("Fast Bulk Physical", 2009, (128, 0, 128, 252, 0, 0)),
    ("Fast Bulk Special", 2010, (128, 0, 0, 252, 0, 128)),
    ("Fast Bulk", 2011, (252, 0, 0, 252, 0, 0)),
    ("Reset EVs", 2000, (0, 0, 0, 0, 0, 0)),
]
TIP = "8fe483d5a"


def sets():
    text = read("src/data/ev_iv_trainer_sets.h")
    return [(int(row), tuple(int(v) for v in evs.split(",")))
            for row, evs in re.findall(r"\{ msg_0550_T21_(\d+), \{([^}]*)\} \}", text)]


def bank_550():
    text = (ROOT / "files/msgdata/msg/msg_0550_T21.gmm").read_text(encoding="utf-8")
    return {int(i): body for i, body in re.findall(r'index="(\d+)">.*?<language name="English">(.*?)</language>', text, re.S)}


class EvSetTests(unittest.TestCase):
    def test_konefrs_twelve_in_his_order_with_his_names(self):
        names = bank_550()
        got = [(names[row], evs) for row, evs in sets()]
        self.assertEqual(got, [(name, evs) for name, _, evs in KONEFR])
        self.assertIn("NARC_msg_msg_0550_T21_bin", read("src/data/ev_iv_trainer_sets.h"))

    def test_each_fits_252_and_510(self):
        for row, evs in sets():
            self.assertLessEqual(max(evs), 252, row)
            self.assertLessEqual(sum(evs), 510, row)

    def test_they_are_his_presets(self):
        """His ScrCmd_GiveEgg, case by case: evs[] in MON_DATA order."""
        if REFERENCE is None:
            self.skipTest("the reference checkout is not here")
        code = subprocess.check_output(["git", "show", f"{TIP}:src/field/script_commands.c"], cwd=REFERENCE, text=True)
        numbers = {name: int(n) for name, n in re.findall(r"#define (DEV_EV_PRESET_\w+)\s+(\d+)", code)}
        cases = {}
        for name, body in re.findall(r"case (DEV_EV_PRESET_\w+):(.*?)break;", code, re.S):
            evs = [0] * 6
            for i, v in re.findall(r"evs\[(\d)\] = (\d+);", body):
                evs[int(i)] = int(v)
            cases[numbers[name]] = tuple(evs)
        cases.setdefault(numbers["DEV_EV_PRESET_RESET"], (0,) * 6)
        for name, number, evs in KONEFR:
            self.assertEqual(cases[number], evs, name)


if __name__ == "__main__":
    unittest.main()
