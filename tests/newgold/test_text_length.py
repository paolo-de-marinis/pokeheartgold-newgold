#!/usr/bin/env python3
"""Every name fits the buffer the game reads it into.

ReadMsgDataIntoString ends in CopyU16ArrayToStringN (src/pm_string.c), which
copies a row only when its length -- in u16, control codes and terminator
included -- is at most the String's capacity. A longer row trips GF_ASSERT,
which does nothing in this build, and the String keeps what it held before: a
blank or somebody else's text, and nothing at build time says so. The lengths
are read from the banks msgenc built, which store them.

Names, plurals and descriptions are checked for every item; the plurals
against MessageFormat_New, which the bag reads them into, and the descriptions
against the strings the bag, the battle bag and the shop read them into.
The bag's list strings (ov15_021FA008, BAG_LIST_NAME_LENGTH) are sized for
the longest name hg-engine has, which run to 22 with the terminator where
HeartGold's fitted 18.

Needs the build: run after make.
"""

import re
import struct
import unittest

from test_level_cap import ROOT

MESSAGES = ROOT / "files/msgdata/msg"

# Capacities in u16, terminator included, of the smallest String each bank is read into.
MOVE_NAME_CAPACITY = 16         # GetMoveName's String_New(16) (src/msgdata.c), the move tutor's String_New(0x10)
SPECIES_NAME_CAPACITY = 11      # POKEMON_NAME_LENGTH + 1: GetSpeciesNameIntoArray copies the row into a nickname array unbounded
MESSAGE_FORMAT_CAPACITY = 32    # MessageFormat_New_Custom(_, 32) callers: ability names, items with article
ITEM_NAME_CAPACITY = int(re.search(r"#define BAG_LIST_NAME_LENGTH (\d+)",
                                    (ROOT / "include/bag_app_state.h").read_text()).group(1))  # ov15_021FA008
ITEM_DESCRIPTION_CAPACITY = int(re.search(r"#define ITEM_DESCRIPTION_LENGTH (\d+)",
                                           (ROOT / "include/item.h").read_text()).group(1))  # bag, battle bag, shop
DESCRIPTION_READERS = ["src/bag_item_description.c", "src/battle_bag_description.c", "src/overlay_03/shop_menu.c"]

MOVE_NAMES, ITEM_DESCRIPTIONS, ITEM_NAMES, ITEM_ARTICLES, ITEM_PLURALS, SPECIES_NAMES, ABILITY_NAMES = (
    750, 221, 222, 223, 224, 237, 720)


def item_plural_capacity():
    """The bag reads plurals into the MessageFormat_New buffer (ov15, asm); the other plural
    readers have 64 (scripts, overlay 31) or read Apricorns only (overlay 59's 32)."""
    source = (ROOT / "src/message_format.c").read_text()
    return int(re.search(r"MessageFormat_New\(enum HeapID heapID\) \{\s*return MessageFormat_New_Custom\(8, (\d+),",
                         source).group(1))


def row_lengths(bank):
    """The length msgenc stored for each row of a bank (MessagesConverter.h's MsgAlloc)."""
    path = MESSAGES / f"msg_{bank:04d}.bin"
    if not path.exists():
        raise unittest.SkipTest("the message banks have not been built")
    assert path.stat().st_mtime >= path.with_suffix(".gmm").stat().st_mtime, f"{path.name} is older than its gmm: run make"
    data = path.read_bytes()
    count, key = struct.unpack_from("<HH", data)
    lengths = []
    for i in range(1, count + 1):
        k = 765 * i * key & 0xFFFF
        lengths.append(struct.unpack_from("<I", data, 8 * i)[0] ^ (k | k << 16))
    return lengths


def items():
    text = (ROOT / "include/constants/items.h").read_text()
    return {name: int(value) for name, value in re.findall(r"#define (ITEM_\w+)\s+(\d+)\b", text)}


def over(bank, capacity):
    return {row: n for row, n in enumerate(row_lengths(bank)) if n > capacity}


class TextLengthTests(unittest.TestCase):
    def test_move_names_fit(self):
        self.assertEqual(over(MOVE_NAMES, MOVE_NAME_CAPACITY), {}, "move rows longer than 16")

    def test_species_names_fit(self):
        self.assertEqual(over(SPECIES_NAMES, SPECIES_NAME_CAPACITY), {}, "species rows longer than 11")

    def test_ability_names_fit(self):
        self.assertEqual(over(ABILITY_NAMES, MESSAGE_FORMAT_CAPACITY), {}, "ability rows longer than 32")

    def test_item_names_with_article_fit(self):
        self.assertEqual(over(ITEM_ARTICLES, MESSAGE_FORMAT_CAPACITY), {}, "article rows longer than 32")

    def test_every_item_name_fits_the_bags_list(self):
        self.assertEqual(over(ITEM_NAMES, ITEM_NAME_CAPACITY), {}, "item names the bag's list cannot hold")

    def test_the_bags_list_strings_are_that_long(self):
        source = (ROOT / "src/bag_pocket_list.c").read_text()
        self.assertIn("String_New(BAG_LIST_NAME_LENGTH, HEAP_ID_6)", source)

    def test_every_item_plural_fits(self):
        # hg-engine's plurals run to 40 (Twice-Spiced Radish, Bitter Herba Mystica).
        self.assertEqual(over(ITEM_PLURALS, item_plural_capacity()), {})

    def test_every_item_description_fits(self):
        self.assertEqual(over(ITEM_DESCRIPTIONS, ITEM_DESCRIPTION_CAPACITY), {},
                         "item descriptions longer than the screens' strings")

    def test_the_screens_read_descriptions_at_that_length(self):
        for path in DESCRIPTION_READERS:
            source = (ROOT / path).read_text()
            self.assertIn("String_New(ITEM_DESCRIPTION_LENGTH", source, path)
            self.assertNotIn("String_New(130", source, path)

    def test_lengths_are_read_as_msgenc_writes_them(self):
        """Characters, 4 u16 per {COLOR n}, 1 for the terminator."""
        self.assertEqual(row_lengths(MOVE_NAMES)[588], len("ParabolicCharge") + 1)
        self.assertEqual(row_lengths(ITEM_ARTICLES)[items()["ITEM_SUPER_LUMIOSE_GALETTE"]],
                         len("a Super Lumiose Galette") + 2 * 4 + 1)


if __name__ == "__main__":
    unittest.main()
