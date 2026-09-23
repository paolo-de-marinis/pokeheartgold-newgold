#!/usr/bin/env python3
"""The bag lists every slot of a pocket the save keeps.

Overlay 15 builds a pocket's list (ov15_021F9F08) and finds a page's items
(ov15_021FF320, ov15_021FF364) up to a size per pocket that it keeps in two
tables of its own. They were HeartGold's 165 items, 24 balls and 50 key items
while the save's pockets grew to NUM_BAG_*, so the slots past them were kept
and never shown. hg-engine points both at the save's sizes (sPocketCountBytes);
the list's strings are sized for the biggest (BAG_LIST_CAPACITY, checked
against every pocket when bag_pocket_list.c compiles).
"""

import re
import unittest

from test_level_cap import ROOT

POCKETS = {
    "POCKET_ITEMS": "NUM_BAG_ITEMS",
    "POCKET_MEDICINE": "NUM_BAG_MEDICINE",
    "POCKET_BALLS": "NUM_BAG_BALLS",
    "POCKET_TMHMS": "NUM_BAG_TMS_HMS",
    "POCKET_BERRIES": "NUM_BAG_BERRIES",
    "POCKET_MAIL": "NUM_BAG_MAIL",
    "POCKET_BATTLE_ITEMS": "NUM_BAG_BATTLE_ITEMS",
    "POCKET_KEY_ITEMS": "NUM_BAG_KEY_ITEMS",
}


def table(path, name):
    text = (ROOT / path).read_text()
    body = text[text.index(f"{name}[POCKETS_COUNT] = {{"):]
    return dict(re.findall(r"\[(POCKET_\w+)\]\s*=\s*(\w+),", body[:body.index("};")]))


class BagListTests(unittest.TestCase):
    def test_the_list_reads_every_slot_of_each_pocket(self):
        self.assertEqual(table("src/bag_pocket_sizes.c", "ov15_022008B0"), POCKETS)

    def test_the_redraw_reads_every_slot_of_each_pocket(self):
        self.assertEqual(table("src/bag_page_sizes.c", "ov15_022008C8"), POCKETS)


if __name__ == "__main__":
    unittest.main()
