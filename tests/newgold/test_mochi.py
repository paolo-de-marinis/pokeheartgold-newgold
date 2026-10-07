#!/usr/bin/env python3
"""The Mochi, as the ninth generation has them (Pokemon Central, Mochi):
Health, Muscle, Resist, Genius, Clever and Swift Mochi each add 10 EVs to
one stat when used from the bag, and the Fresh-Start Mochi sets all six to
zero. hg-engine's records (d0380a487) carry the 10, and -128 in all six for
the Fresh-Start ("code in something that makes this reset to 0"), but no
party use, no field routine and no flag for the stat, so the bag offered
them nothing to do.
"""

import csv
import re
import unittest

from test_form_dex import run
from test_level_cap import ROOT, function

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

    def test_the_fresh_start_mochi_is_used_on_all_six_stats(self):
        row = records()["ITEM_FRESH_START_MOCHI"]
        self.assertEqual((row["fieldUseFunc"], row["partyUse"]), ("1", "1"))
        for stat in EV_FIELDS:
            self.assertEqual((row[f"{stat}_ev_up"], row[f"{stat}_ev_up_param"]), ("true", "-128"), stat)

    def test_the_fresh_start_mochi_takes_any_number_of_evs_to_zero(self):
        # TryModEV gave -128 as a Berry's -10 is given, so a stat with more
        # than 128 kept the rest: 252 Sp. Atk went to 124.
        header = (ROOT / "include/use_item_on_mon.h").read_text()
        native = "\n".join(line for line in header.splitlines() if line.startswith("#define ITEM_EV_PARAM_RESET"))
        native += "\n" + function((ROOT / "src/use_item_on_mon.c").read_text(), "TryModEV")
        program = """
#include <stdio.h>
#include <stdint.h>
#include "constants/pokemon.h"
typedef int32_t s32;
""" + native + """
int main(void) {
    printf("%d %d %d %d %d\\n", TryModEV(252, 258, ITEM_EV_PARAM_RESET), TryModEV(129, 0, ITEM_EV_PARAM_RESET),
           TryModEV(0, 100, ITEM_EV_PARAM_RESET), TryModEV(100, 0, -10), TryModEV(250, 0, 10));
    return 0;
}
"""
        # Reset from 252 and 129; nothing to do at 0; a Berry's -10 and a
        # vitamin's +10 as before (the latter to 252).
        self.assertEqual(run(program, "newgold-mochi-reset-"), "0 0 -1 90 252")

    def test_each_mochi_draws_its_own_icon(self):
        """konefr's PNG for every Mochi is a copy of none.png, so all seven drew
        ITEM_NONE's "?" in the EV/IV trainer's shop and in the bag. Paolo had
        them drawn (ChatGPT, 2026-10-08); the importer knows they are his art."""
        from PIL import Image
        from test_items import ICON_DIR, ITEM_MK, import_items, narc_rows
        built = {int(tiles): png for tiles, png in
                 re.findall(r"ITEMICON_FROM_PNG,(\d+),\d+,(\w+)\)", ITEM_MK.read_text())}
        rows = narc_rows()
        mochi = [*STATS, "ITEM_FRESH_START_MOCHI"]
        tiles = [rows[item][1] for item in mochi]
        self.assertEqual(len(set(tiles) - {rows["ITEM_NONE"][1]}), len(mochi), tiles)
        for item, member in zip(mochi, tiles):
            png = built.get(member)
            self.assertEqual(png, import_items.OWN_ICONS[item], item)
            icon = Image.open(ICON_DIR / f"{png}.png")
            # 4bpp with a palette of exactly 16 (DEVKIT-PROMPTS.md's trap), and
            # inside the top-left 24x24, where HeartGold draws every item icon.
            self.assertEqual((icon.size, icon.mode, len(icon.getpalette())), ((32, 32), "P", 48), png)
            box = Image.frombytes("L", icon.size, icon.tobytes()).getbbox()
            self.assertTrue(box[2] <= 24 and box[3] <= 24, (png, box))


if __name__ == "__main__":
    unittest.main()
