#!/usr/bin/env python3
"""Check that the PC's box list has room for every box's picture.

Each box has a 0x400-byte picture in the PC box application's graphics
state. Retail's state was 0x88E0 bytes, and its eighteen pictures filled it
from 0x40C8 to 0x88C8. Thirty from there run 12 KB past the allocation. As
in hg-engine, the pictures move to the end of the state, at 0x88E0, and the
state grows by thirty of them. This reads the built routines' constants:
what the setup allocates, and where the three routines that read the
pictures look for them.
"""

import re
import struct
import sys
import unittest

from test_level_cap import ROOT

sys.path[:0] = [str(ROOT / "tools/newgold/devkit/harness")]
import where  # noqa: E402

BUILD = ROOT / "build/heartgold.us"
PICTURES = 0x88E0
PICTURE_SIZE = 0x400


def words(name, table, overlay):
    value, size, _, _ = table[name]
    base = table["SDK_OVERLAY.OVY_14.START"][0]
    code = overlay[value - base:value - base + size]
    return {struct.unpack_from("<I", code, i)[0] for i in range(0, len(code) - 3, 2)}


class PCBoxPictureTests(unittest.TestCase):
    def setUp(self):
        if not (BUILD / "main.elf").exists():
            self.skipTest("the ROM has not been built")
        self.table = where._elf(BUILD / "main.elf")
        self.overlay = (BUILD / "OVY_14.sbin").read_bytes()
        self.boxes = int(re.search(r"#define NUM_BOXES\s+(\d+)",
                                   (ROOT / "include/constants/pokemon.h").read_text()).group(1))

    def test_the_state_holds_every_box_s_picture(self):
        size = PICTURES + self.boxes * PICTURE_SIZE
        self.assertTrue(size in words("ov14_021EAFAC", self.table, self.overlay),
                        f"the setup does not allocate {size:#x} bytes")

    def test_the_pictures_are_read_where_they_now_are(self):
        for name in ("ov14_021F4958", "ov14_021F49E0", "ov14_021F4A20"):
            found = words(name, self.table, self.overlay)
            self.assertTrue(PICTURES in found and 0x40C8 not in found,
                            f"{name} does not read the pictures at {PICTURES:#x}")


if __name__ == "__main__":
    unittest.main()
