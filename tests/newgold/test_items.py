#!/usr/bin/env python3
"""Check that everything indexed by an item id reaches the last item.

An item is a constant, a row of item data, four rows of text, and a line of
sItemNarcIds saying which archive members hold its data and its icon. Nothing
at build time ties those together: sItemNarcIds is sized by ITEMS_COUNT, so a
line nobody wrote is a row of zeroes -- ITEM_NONE's data and the question-mark
icon -- and a message bank that stops short reads whatever the encoder left
after it. Both go quiet rather than wrong, which is why this port has shipped a
table sized to the old range more than once.

The member numbers are checked against the archives' own contents, so an icon
that was never built fails here rather than showing up blank in the bag.
"""

import re
import unittest

from test_level_cap import ROOT

HEADER = ROOT / "include/constants/items.h"
ITEM_DATA = ROOT / "files/itemtool/itemdata/item_data.csv"
ITEM_MK = ROOT / "files/itemtool/itemdata/item_data.mk"
ITEM_C = ROOT / "src/item.c"
# The four banks an item id indexes: its description, its name, its name with
# an indefinite article, and its plural. The last two are easy to forget --
# nine items were added before them without one -- and the party menu reads the
# article bank for whatever a Pokemon is holding.
ITEM_BANKS = [ROOT / f"files/msgdata/msg/msg_{bank}.gmm"
              for bank in ("0221", "0222", "0223", "0224")]
NAMES, ARTICLES = ITEM_BANKS[1], ITEM_BANKS[2]
ICON_DIR = ROOT / "files/itemtool/itemdata/item_icon"


def items_count():
    return int(re.search(r"#define ITEMS_COUNT\s+(\d+)", HEADER.read_text()).group(1))


def item_ids():
    """The item constants, by name. The block runs from ITEM_NONE to the count;
    HOLD_EFFECT_ above it and ITEM_VAR_ below are not item ids."""
    header = HEADER.read_text()
    block = header[header.index("#define ITEM_NONE 0"):header.index("#define ITEMS_COUNT")]
    return {name: int(value)
            for name, value in re.findall(r"#define (ITEM_[A-Z0-9_]+)\s+(\d+)$", block, re.M)}


def narc_rows():
    """The sItemNarcIds lines, as item name -> (data, NCGR, NCLR) member."""
    table = ITEM_C.read_text()
    table = table[table.index("sItemNarcIds[ITEMS_COUNT][4] = {"):]
    table = table[:table.index("\n};")]
    rows = re.findall(r"\[(ITEM_[A-Z0-9_]+)\] = \{ NARC_item_data_(\d+)_bin, "
                      r"NARC_item_icon_item_icon_(\d+)_NCGR, "
                      r"NARC_item_icon_item_icon_(\d+)_NCLR", table)
    return {name: (int(data), int(ncgr), int(nclr)) for name, data, ncgr, nclr in rows}


def icon_members():
    """Every member the item icon archive will hold, by number: the files that
    are committed, plus the ones item_data.mk builds from the PNGs beside them.
    """
    members = {}
    for path in ICON_DIR.iterdir():
        found = re.match(r"item_icon_(\d+)\.(NANR|NCER|NCGR|NCLR)$", path.name)
        if found:
            members[int(found.group(1))] = found.group(2)
    for ncgr, nclr, png in re.findall(r"ITEMICON_FROM_PNG,(\d+),(\d+),(\w+)\)", ITEM_MK.read_text()):
        assert (ICON_DIR / f"{png}.png").exists(), f"{png}.png is missing"
        members[int(ncgr)] = "NCGR"
        members[int(nclr)] = "NCLR"
    return members


def message_rows(path):
    return [int(index) for index in re.findall(r'index="(\d+)"', path.read_text(encoding="utf-8"))]


def message_text(path):
    return re.findall(r'<language name="English">(.*?)</language>',
                      path.read_text(encoding="utf-8"), re.S)


class ItemRangeTests(unittest.TestCase):
    def setUp(self):
        self.count = items_count()
        self.ids = item_ids()
        self.rows = narc_rows()

    def test_the_constants_run_to_the_count_without_a_gap(self):
        self.assertEqual(sorted(set(self.ids.values())), list(range(self.count)),
                         "ITEMS_COUNT and the item constants disagree")

    def test_every_item_says_where_its_data_and_icon_live(self):
        self.assertEqual(set(self.ids) - set(self.rows), set(),
                         "items with no line in sItemNarcIds")

    def test_the_item_data_every_item_points_at_was_written(self):
        """csv2bin makes one archive member per row, in order, so the last row
        is the last member: a line pointing past it reads nothing."""
        written = len(ITEM_DATA.read_text().splitlines()) - 1
        for name, (data, _, _) in self.rows.items():
            self.assertLess(data, written, f"{name} reads item data member {data}")

    def test_the_icons_every_item_points_at_are_in_the_archive(self):
        members = icon_members()
        for name, (_, ncgr, nclr) in self.rows.items():
            self.assertEqual(members.get(ncgr), "NCGR", f"{name} tiles, member {ncgr}")
            self.assertEqual(members.get(nclr), "NCLR", f"{name} palette, member {nclr}")

    def test_every_bank_an_item_id_indexes_reaches_the_last_item(self):
        for path in ITEM_BANKS:
            rows = message_rows(path)
            self.assertEqual(rows, list(range(len(rows))), f"{path.name} is not in index order")
            self.assertGreaterEqual(len(rows), self.count,
                                    f"{path.name} stops before the last item")

    def test_the_article_bank_names_the_item_its_row_belongs_to(self):
        """Three banks say the item's name, and a row added in the wrong place
        is invisible until someone picks the thing up. The plural bank is not
        checked this way: a Cheri Berry pluralises to Cheri Berries."""
        names = message_text(NAMES)
        for item, value in enumerate(message_text(ARTICLES)[:self.count]):
            if item and "???" not in (names[item], value):
                self.assertIn(names[item], value, f"msg_0223 row {item}")


if __name__ == "__main__":
    unittest.main()
