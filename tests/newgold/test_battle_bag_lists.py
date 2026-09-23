#!/usr/bin/env python3
"""The battle bag's four lists hold every item the bag can hand them.

ov08_02223BF4 walks every pocket of the bag and appends each item to the
battle bag's list for each bit of its battlePocket field -- bits 2 and 4 (HP
and PP) to the first list, 3 (status) to the second, 0 (balls) to the third,
1 (battle items) to the fourth, by the byte table ov08_02225CE0 -- with no
bound on how many. A list is ItemSlot pocketItems[4][36] in the battle bag's
state (include/battle_bag.h), so a 37th item would be written over the next
list, and the fourth list's over the state after it.

The bag keeps one slot per item, so the most a list can be handed is, for
each pocket, the fewer of the pocket's slots and the items that pocket holds
that go to the list. With the widened pockets and every item hg-engine
defines, that is 23, 35, 26 and 10.
"""

import csv
import re
import unittest

from test_level_cap import ROOT

ASM = ROOT / "asm/overlay_08_02223AA0.s"


def list_of_bit():
    text = ASM.read_text()
    table = text[text.index("ov08_02225CE0:"):]
    return [int(b, 0) for b in re.search(r"\.byte ([^\n]+)", table).group(1).split(",")]


def pocket_sizes():
    header = (ROOT / "include/constants/items.h").read_text()
    names = {"POCKET_ITEMS": "NUM_BAG_ITEMS", "POCKET_MEDICINE": "NUM_BAG_MEDICINE", "POCKET_BALLS": "NUM_BAG_BALLS",
             "POCKET_TMHMS": "NUM_BAG_TMS_HMS", "POCKET_BERRIES": "NUM_BAG_BERRIES", "POCKET_MAIL": "NUM_BAG_MAIL",
             "POCKET_BATTLE_ITEMS": "NUM_BAG_BATTLE_ITEMS", "POCKET_KEY_ITEMS": "NUM_BAG_KEY_ITEMS"}
    return {pocket: eval(re.search(rf"#define {name}\s+(.+)", header).group(1)) for pocket, name in names.items()}


class BattleBagListTests(unittest.TestCase):
    def test_no_list_can_be_handed_more_than_it_holds(self):
        capacity = int(re.search(r"pocketItems\[4\]\[(\d+)\]", (ROOT / "include/battle_bag.h").read_text()).group(1))
        lists = list_of_bit()
        self.assertEqual(lists, [2, 3, 0, 1, 0])
        per_pocket = [{} for _ in range(4)]
        with (ROOT / "files/itemtool/itemdata/item_data.csv").open() as stream:
            for row in csv.DictReader(stream):
                flags = int(row["battlePocket"], 0)
                for target in {lists[bit] for bit in range(len(lists)) if flags >> bit & 1}:
                    per_pocket[target][row["fieldPocket"]] = per_pocket[target].get(row["fieldPocket"], 0) + 1
        sizes = pocket_sizes()
        worst = [sum(min(count, sizes[pocket]) for pocket, count in pockets.items()) for pockets in per_pocket]
        for target, most in enumerate(worst):
            self.assertLessEqual(most, capacity, f"the battle bag's list {target} can be handed {most} items")
        print(f"PASS: the battle bag's lists can be handed at most {worst} of {capacity} each.")


if __name__ == "__main__":
    unittest.main()
