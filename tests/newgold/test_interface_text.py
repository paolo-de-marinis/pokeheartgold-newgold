#!/usr/bin/env python3
"""Banks 010, 024, 040, 203, 300, 302 and 435 are hg-engine's (d0380a487),
and the code reads each moved row where hg-engine reads it."""

import re
import sys
import unittest
from pathlib import Path

ROOT = Path(__file__).resolve().parents[2]
sys.path.insert(0, str(ROOT / "tools/newgold/import"))
import gmm  # noqa: E402
import import_interface_text as importer  # noqa: E402


def text(bank, index):
    return gmm.read(bank)[index]["text"]


def read(path):
    return (ROOT / path).read_text()


class InterfaceTextTests(unittest.TestCase):
    def test_the_banks_are_what_the_importer_writes_from_the_engine(self):
        if not (gmm.REFERENCE / ".git").exists():
            self.skipTest("no hg-engine-newgold-reference checkout")
        for bank in importer.BANKS:
            rows = gmm.read(bank)
            self.assertEqual(importer.build(bank, gmm.reference_rows(gmm.ENGINE, bank), rows), rows, bank)

    def test_the_moved_rows(self):
        self.assertEqual((text(24, 94), text(24, 95), text(24, 124)), ("", "Box 1", "Box 30"))
        self.assertEqual(text(40, 117), "")
        self.assertTrue(text(40, 118).startswith("The repellent’s effect wore off!"))
        self.assertEqual(text(40, 28), "{STRVAR_1 3, 0, 0} obtained\\n{COLOR 2}{STRVAR_1 8, 1, 0}{COLOR 0}!")
        self.assertEqual(text(300, 192), "")
        self.assertEqual(text(300, 193), "{STRVAR_1 0, 0, 0}’s ability changed!\\r")
        self.assertEqual(text(300, 219), "{STRVAR_1 1, 0, 0} learned\\n{STRVAR_1 6, 1, 0}!{WAIT 4}{WAIT 2}\\r")
        self.assertEqual((text(302, 206), text(302, 207)), ("EV", "IV"))

    def test_the_code_reads_them_where_hg_engine_does(self):
        self.assertIn("msg_0024_00095 + i", read("src/pokemon_storage_system.c"))
        self.assertIn("msg_0302_00206 : mode == SUMMARY_STATS_IVS ? msg_0302_00207", read("src/pokemon_summary_stats.c"))
        party = read("src/party_menu.c")
        self.assertIn("msg_0300_00194 + sMintNatures[itemId - ITEM_LONELY_MINT]", party)
        self.assertIn("Mon_SwapAbilitySlot(mon);\n        string = NewString_ReadMsgData(partyMenu->msgData, msg_0300_00193);", party)
        # A free slot is 219; 62 is 'and it learned X instead!', after a forget.
        tm = read("src/party_menu_items.c")
        free = tm[tm.index("int PartyMenu_HandleUseTMHMonMon("):]
        free = free[free.index("case 3:"):free.index("break;")]
        self.assertIn("msg_0300_00219", free)
        # after a machine's, a level-up's and the Rotom Catalog's forgotten move
        self.assertEqual(tm.count("msg_0300_00062"), 3)
        script = read("files/fielddata/script/scr_seq/scr_seq_0003.s")
        self.assertIn("BufferItemNameIndef 1, VAR_SPECIAL_x8004\n\tNPCMsg msg_0040_00028", script)
        self.assertRegex(script, r"GoToIfGt _08BB\n\tBufferItemNameIndef 0, VAR_SPECIAL_x8004\n")

    def test_each_mint_reads_its_own_nature_line(self):
        natures = dict(re.findall(r"#define (NATURE_\w+)\s+(\d+)", read("include/constants/pokemon.h")))
        table = re.search(r"sMintNatures\[[^\]]*\] = \{(.*?)\};", read("src/party_menu.c"), re.S).group(1)
        for nature in re.findall(r"NATURE_\w+", table):
            line = text(300, 194 + int(natures[nature]))
            self.assertIn(f"the {nature[len('NATURE_'):].title()} Mint!", line)


if __name__ == "__main__":
    unittest.main()
