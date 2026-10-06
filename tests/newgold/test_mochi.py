#!/usr/bin/env python3
"""The Mochi, as the ninth generation has them (Pokemon Central, Mochi):
Health, Muscle, Resist, Genius, Clever and Swift Mochi each add 10 EVs to
one stat when used from the bag. hg-engine's records (d0380a487) carry the
10 but no party use, no field routine and no flag for the stat, so the bag
offered them nothing to do.
"""

import csv
import unittest

from test_level_cap import ROOT

STATS = {
    "ITEM_HEALTH_MOCHI": "hp",
    "ITEM_MUSCLE_MOCHI": "atk",
    "ITEM_RESIST_MOCHI": "def",
    "ITEM_GENIUS_MOCHI": "spatk",
    "ITEM_CLEVER_MOCHI": "spdef",
    "ITEM_SWIFT_MOCHI": "speed",
}
EV_FIELDS = ("hp", "atk", "def", "speed", "spatk", "spdef")


def records():
    rows = csv.DictReader((ROOT / "files/itemtool/itemdata/item_data.csv").read_text().splitlines())
    return {row["item"]: row for row in rows}


class MochiTests(unittest.TestCase):
    def test_each_mochi_adds_ten_to_its_stat_from_the_bag(self):
        rows = records()
        hp_up = rows["ITEM_HP_UP"]
        for item, stat in STATS.items():
            row = rows[item]
            # Opened on the party menu as a vitamin is (field routine 1), and
            # the party menu's to use.
            self.assertEqual((row["fieldUseFunc"], row["partyUse"]), (hp_up["fieldUseFunc"], hp_up["partyUse"]), item)
            for other in EV_FIELDS:
                self.assertEqual(row[f"{other}_ev_up"], "true" if other == stat else "false", (item, other))
                self.assertEqual(row[f"{other}_ev_up_param"], "10" if other == stat else "0", (item, other))
            # No friendship change: the reference gives none, and neither
            # Pokemon Central nor the ninth generation's descriptions name
            # one; the vitamins' is not copied.
            for level in ("lo", "med", "hi"):
                self.assertEqual(row[f"friendship_mod_{level}"], "false", item)


if __name__ == "__main__":
    unittest.main()
