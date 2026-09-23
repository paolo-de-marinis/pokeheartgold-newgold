#!/usr/bin/env python3
"""Check every place that prints a Dex number prints four digits.

Retail formats a Dex number with three, and BufferIntegerAsString keeps the
last three of a longer one, so species 1000 to 1041 (Pecharunt) printed as
'?xx'. hg-engine widens the six places to four with a byte patch
(bytereplacement, "expand dex digits from 3 to 4"); here the five routines
that print it in text are C, and each must take DEX_NUMBER_DIGITS.
"""

import re
import unittest

from test_dex_range import c_function
from test_level_cap import ROOT

# Every routine that turns Pokedex_ConvertToCurrentDexNo's answer into text.
PRINTERS = {
    "src/pokemon_summary_info.c": "sub_0208CC88",          # the summary's first page
    "src/pc_box_display_ability.c": "ov14_021F5190",       # the PC
    "src/application/pokedex/ov18_021EE75C.c": "ov18_021EE75C",  # the Dex list
    "src/application/pokedex/ov18_021EEC34.c": "ov18_021EEC34",  # an entry's pages
    "src/application/pokedex/ov18_021F8CCC.c": "ov18_021F8CCC",  # a new catch's page
}


class DexDigitTests(unittest.TestCase):
    def test_four_digits_hold_the_last_dex_number(self):
        header = (ROOT / "include/pokedex_util.h").read_text()
        digits = int(re.search(r"#define DEX_NUMBER_DIGITS (\d+)", header).group(1))
        species = (ROOT / "include/constants/species.h").read_text()
        last = int(re.search(r"#define SPECIES_PECHARUNT\s+(\d+)", species).group(1))
        self.assertEqual(digits, 4)
        self.assertLess(last, 10 ** digits)

    def test_every_printer_takes_the_width(self):
        for path, name in PRINTERS.items():
            body = c_function((ROOT / path).read_text(), name)
            calls = re.findall(r"(?:BufferIntegerAsString|sub_0208C87C)\((.*?)\);", body, re.S)
            dex = [c for c in calls if "ConvertToCurrentDexNo" in c or "dexNo" in c]
            self.assertEqual(len(dex), 1, f"{name}: {calls}")
            self.assertIn(", DEX_NUMBER_DIGITS,", dex[0], name)

    def test_no_other_c_prints_a_dex_number(self):
        """A new printer has to be added above, and made to take the width."""
        found = set()
        for path in (ROOT / "src").rglob("*.c"):
            text = path.read_text(errors="replace")
            for m in re.finditer(r"(?:BufferIntegerAsString|sub_0208C87C)\([^;]*ConvertToCurrentDexNo", text):
                found.add(str(path.relative_to(ROOT)))
            if re.search(r"dexNo = Pokedex_ConvertToCurrentDexNo", text):
                found.add(str(path.relative_to(ROOT)))
        self.assertEqual(found, set(PRINTERS))


if __name__ == "__main__":
    unittest.main()
