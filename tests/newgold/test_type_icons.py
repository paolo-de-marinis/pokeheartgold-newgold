#!/usr/bin/env python3
"""Check that every type has an icon, and that the contest block moved with it.

sub_02077678 is asked for an icon by an index that is a type for every caller
but one: the move relearner asks it for a contest condition, and does that by
adding the number of types to the condition. So the table is types first and
the five conditions after, and the two have to agree on where the boundary is
or a Fairy move shows the word COOL.

The Fairy icon itself is a member added to the end of the battle graphics
archive, which is why its file id is past every id the game shipped with.
"""

import re
import struct
import unittest

from test_level_cap import ROOT

SOURCE = ROOT / "src/unk_02077678.c"
RELEARNER = ROOT / "src/overlay_68_021E7028.c"
TYPES = ROOT / "include/constants/pokemon.h"
ARCHIVE = ROOT / "files/a/0/0/8"
CONTEST_CONDITIONS = 5


def table(name, pattern=r"0x[0-9A-Fa-f]+|\d+"):
    body = re.search(rf"{name}\[\] = \{{(.*?)\n\}};", SOURCE.read_text(), re.S).group(1)
    body = re.sub(r"//[^\n]*", "", body)
    return [int(v, 0) for v in re.findall(pattern, body)]


def number_of_types():
    return int(re.search(r"#define NUMBER_OF_MON_TYPES\s+(\d+)", TYPES.read_text()).group(1))


def archive_members():
    data = ARCHIVE.read_bytes()
    assert data[:4] == b"NARC"
    # FATB follows the 16-byte NARC header: its own 8-byte header, then the count.
    return struct.unpack_from("<I", data, 0x18)[0]


class TypeIconTests(unittest.TestCase):
    def test_the_table_holds_every_type_and_the_five_conditions(self):
        want = number_of_types() + CONTEST_CONDITIONS
        self.assertEqual(len(table("sTypeIconFiles")), want)
        self.assertEqual(len(table("sTypeIconPalettes")), want)

    def test_the_relearner_adds_the_same_boundary(self):
        self.assertIn("GetMoveAttr(move, MOVEATTR_CONTEST_TYPE) + NUMBER_OF_MON_TYPES", RELEARNER.read_text(),
                      "the move relearner does not start the contest icons at NUMBER_OF_MON_TYPES")

    def test_the_fairy_icon_is_in_the_archive(self):
        fairy = table("sTypeIconFiles")[int(re.search(r"#define TYPE_FAIRY\s+(\d+)",
                                                      TYPES.read_text()).group(1))]
        self.assertLess(fairy, archive_members(),
                        f"the Fairy icon is file {fairy} and the archive holds "
                        f"{archive_members()} members")

    def test_no_two_types_share_an_icon(self):
        files = table("sTypeIconFiles")[:number_of_types()]
        self.assertEqual(len(set(files)), len(files))


if __name__ == "__main__":
    unittest.main()
