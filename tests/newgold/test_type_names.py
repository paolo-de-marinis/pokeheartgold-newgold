#!/usr/bin/env python3
"""Check that every type the game has can be named.

BufferTypeName reads msg_0735 by type id, and ReadMsgData_ExistingTable_
ExistingArray asserts and leaves the string untouched when the id is past the
end of the bank. The Fairy type was given a number of its own -- 18, rather
than overwriting the unused TYPE_MYSTERY the reference takes -- which is the
better choice for everything except the three places that were keyed by the
old count: the name here, the icon, and the Pokedex's search list.

A battle message with a type placeholder is the visible one: it printed
nothing at all for a Fairy move.
"""

import re
import unittest
from pathlib import Path

from test_level_cap import ROOT

TYPES = ROOT / "include/constants/pokemon.h"
NAMES = ROOT / "files/msgdata/msg/msg_0735.gmm"


def type_numbers():
    """The real types. TYPE_NONE is 255, a sentinel rather than a type, and
    TYPE_MUL_* are the effectiveness multipliers sharing the prefix."""
    text = TYPES.read_text()
    return {name: int(value) for name, value in
            re.findall(r"^#define TYPE_([A-Z_]+)\s+(\d+)\s*$", text, re.M)
            if name != "NONE" and not name.startswith("MUL_")}


def rows():
    return {int(index): value for index, value in re.findall(
        r'<row id="[^"]+" index="(\d+)">\s*<attribute[^>]*>[^<]*</attribute>\s*'
        r'<language name="English">(.*?)</language>', NAMES.read_text(), re.S)}


class TypeNameTests(unittest.TestCase):
    def test_every_type_has_a_name(self):
        have = rows()
        for name, number in type_numbers().items():
            self.assertIn(number, have, f"TYPE_{name} ({number}) has no row in msg_0735")

    def test_the_fairy_type_is_named(self):
        self.assertEqual(rows()[type_numbers()["FAIRY"]], "FAIRY")

    def test_the_count_is_one_past_the_last_type(self):
        text = TYPES.read_text()
        count = int(re.search(r"#define NUMBER_OF_MON_TYPES\s+(\d+)", text).group(1))
        self.assertEqual(count, max(type_numbers().values()) + 1)
