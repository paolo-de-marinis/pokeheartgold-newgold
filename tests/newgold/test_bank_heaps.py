#!/usr/bin/env python3
"""A bank with a line per item or move is not loaded whole where it
no longer fits.

Each of these grew with the port -- the item names (msg_0222) from 14,866
bytes to 80,202, the move names (msg_0750) from 13,154 to 28,214 -- and each
row below is a heap that, measured with the bank loaded whole in the
diagnostics build, had too little left for it. There the bank is opened
lazily (MSGDATA_LOAD_LAZY): a header, the archive handle and the line read.
"""

import re
import unittest

from test_level_cap import ROOT

LOAD = re.compile(r"NewMsgDataFromNarc\(MSGDATA_LOAD_(DIRECT|LAZY),\s*NARC_msgdata_msg,\s*NARC_msg_msg_(\d+)_bin,\s*(HEAP_ID_\w+)\)")

# (source, bank, heap, what the heap had left in one piece with the bank whole)
LAZY = [
    ("src/overlay_31_0225D60C.c", 222, "HEAP_ID_8", "every mart's list: 10,572 bytes of 0x18000"),
    ("src/overlay_68_021E6820.c", 750, "HEAP_ID_66", "the move relearner: 9,496 bytes, and the load failed"),
    ("src/overlay_68_021E6320.c", 750, "HEAP_ID_66", "the move relearner, as its list"),
    ("src/pokemon_summary_text.c", 750, "HEAP_ID_19", "the summary's moves page: 7,076 bytes of 0x45000"),
]


class BankHeapTests(unittest.TestCase):
    def test_grown_banks_are_read_a_line_at_a_time(self):
        for source, bank, heap, why in LAZY:
            with self.subTest(source=source, bank=bank):
                loads = [kind for kind, number, into in LOAD.findall((ROOT / source).read_text())
                         if int(number) == bank and into == heap]
                self.assertTrue(loads, f"{source} no longer loads msg_{bank:04d} into {heap}: the table is stale")
                self.assertNotIn("DIRECT", loads, f"{source} loads msg_{bank:04d} whole into {heap} ({why})")


if __name__ == "__main__":
    unittest.main()
