#!/usr/bin/env python3
"""Goldenrod's TM shop and the price of TM93 to TM148.

Paolo (2026-10-04, .rounds/round15/tm/PROPOSTA-NEGOZIO-MT.md and shop.json):
the Department Store's 5F TM clerk (special mart list 7) sells HeartGold's
twelve TMs, then the 56 TMs past TM92, unlocked seven at a time at 2, 4, ...
16 badges (Johto's and Kanto's both count), each step dearer than the one
before, as the Poke Mart adds wares as badges come in.
"""

import csv
import unittest

from test_level_cap import ROOT

# (badges, price, TMs) for each step.
STEPS = [
    (2, 1500, [94, 104, 106, 107, 120, 121, 122]),
    (4, 2000, [95, 98, 100, 101, 105, 116, 119]),
    (6, 3000, [96, 109, 110, 112, 113, 118, 127]),
    (8, 4000, [99, 111, 115, 117, 129, 143, 148]),
    (10, 5000, [123, 128, 132, 135, 139, 141, 147]),
    (12, 6000, [97, 102, 108, 114, 125, 130, 146]),
    (14, 8000, [93, 103, 124, 133, 138, 140, 144]),
    (16, 10000, [126, 131, 134, 136, 137, 142, 145]),
]
RETAIL_LIST = [70, 17, 54, 83, 16, 33, 22, 52, 38, 25, 14, 15]


def item(tm):
    return f"ITEM_TM{tm:02d}" if tm <= 92 else f"ITEM_TM{tm:03d}"


class TMPriceTests(unittest.TestCase):
    def test_each_new_tm_costs_its_step(self):
        rows = {row["item"]: row for row in csv.DictReader((ROOT / "files/itemtool/itemdata/item_data.csv")
                                                           .read_text().splitlines())}
        self.assertEqual(sorted(tm for _, _, tms in STEPS for tm in tms), list(range(93, 149)))
        for _, price, tms in STEPS:
            for tm in tms:
                self.assertEqual((int(rows[item(tm)]["price"]), rows[item(tm)]["price_high"]), (price, "0"), tm)


if __name__ == "__main__":
    unittest.main()
