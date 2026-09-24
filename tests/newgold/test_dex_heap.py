#!/usr/bin/env python3
"""The Dex heap loads no message bank whole that has a line per species.

HEAP_ID_POKEDEX_APP keeps retail's margin, no more: on the search results
page about 20 KB are left in one piece (20,012 bytes measured, retail
20,096). A bank with a line per species and form is three times retail's --
the height bank 34,516 bytes, the weight bank 46,020 -- and loading one whole
there fails the allocation, which shows the communication error and resets.
Such a bank is opened lazily (MSGDATA_LOAD_LAZY): a header, the archive
handle and the one line it reads.
"""

import re
import unittest

from test_level_cap import ROOT

DEX = ROOT / "src/application/pokedex"
MSG = ROOT / "files/msgdata/msg"
MEASURES = ROOT / "src/dex_mon_measures.c"
LOAD = re.compile(r"NewMsgDataFromNarc\(MSGDATA_LOAD_DIRECT,\s*NARC_msgdata_msg,\s*([^,]+?),\s*HEAP_ID_POKEDEX_APP\)")


def rows(bank):
    return (MSG / f"msg_{bank}.gmm").read_text().count("<row")


def banks(argument):
    """The banks a load's argument can name: a constant, or a getter's banks
    in every language (dex_mon_measures.c switches them)."""
    match = re.fullmatch(r"NARC_msg_msg_(\d+)_bin", argument)
    if match:
        return [match.group(1)]
    match = re.fullmatch(r"GetDex(\w+)MsgBank\(\)", argument)
    if match:
        found = sorted(set(re.findall(rf"s{match.group(1)}MsgBank = NARC_msg_msg_(\d+)_bin", MEASURES.read_text())))
        if found:
            return found
    raise AssertionError(f"cannot tell which bank {argument} loads")


class DexHeapTests(unittest.TestCase):
    def test_no_species_bank_is_loaded_whole(self):
        species = rows("0237")   # the species names, a line per species and form
        loads = [(path.name, argument) for path in sorted(DEX.glob("*.c")) for argument in LOAD.findall(path.read_text())]
        self.assertTrue(loads, "the Dex loads no bank whole any more: the pattern is stale")
        for name, argument in loads:
            for bank in banks(argument):
                with self.subTest(file=name, bank=bank):
                    self.assertLess(rows(bank), species, f"{name} loads msg_{bank} whole into the Dex heap")


if __name__ == "__main__":
    unittest.main()
