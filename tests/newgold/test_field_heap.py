#!/usr/bin/env python3
"""A script command loads no message bank whole that its field heap cannot hold.

HEAP_ID_FIELD3 is retail's 0x4000 bytes (FieldSystem_New). Retail's move
names (msg_0750, 467 moves) and species names (msg_0237, 496 rows) fitted
in it whole; with every move and species this game has they are 28 and 36
KB, so the move tutor's menu (MoveTutorChooseMove, in the shared script
scr_seq_0002) failed its allocation. Such a bank is opened lazily
(MSGDATA_LOAD_LAZY): a header, the archive handle and the line it reads.
"""

import re
import unittest

from test_level_cap import ROOT

MSG = ROOT / "files/msgdata/msg"
LOAD = re.compile(r"NewMsgDataFromNarc\(MSGDATA_LOAD_DIRECT,\s*NARC_msgdata_msg,\s*(?:NARC_msg_msg_)?(\d+)(?:_bin)?,\s*HEAP_ID_FIELD3\)")


def field3_size():
    text = (ROOT / "src/field_system.c").read_text()
    return int(re.search(r"Heap_Create\(HEAP_ID_3, HEAP_ID_FIELD3, (0x[0-9A-Fa-f]+|\d+)\)", text).group(1), 0)


class FieldHeapTests(unittest.TestCase):
    def test_no_bank_loaded_whole_outgrows_field3(self):
        size = field3_size()
        loads = [(path.relative_to(ROOT), int(bank)) for path in sorted((ROOT / "src").rglob("*.c"))
                 for bank in LOAD.findall(path.read_text())]
        self.assertTrue(loads, "no bank is loaded whole into HEAP_ID_FIELD3 any more: the pattern is stale")
        for path, bank in loads:
            built = MSG / f"msg_{bank:04d}.bin"
            if not built.exists():
                self.skipTest(f"{built.name} is not built")
            with self.subTest(file=str(path), bank=bank):
                # half the heap at most: the menu, its strings and the window share it
                self.assertLess(built.stat().st_size, size // 2, f"{path} loads msg_{bank:04d} whole into HEAP_ID_FIELD3")

    def test_the_move_tutor_reads_its_move_names_lazily(self):
        text = (ROOT / "src/field/scrcmd_move_tutor.c").read_text()
        self.assertIn("NewMsgDataFromNarc(MSGDATA_LOAD_LAZY, NARC_msgdata_msg, NARC_msg_msg_0750_bin, HEAP_ID_FIELD3)", text)


if __name__ == "__main__":
    unittest.main()
