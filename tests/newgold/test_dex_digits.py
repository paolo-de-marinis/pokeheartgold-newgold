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

from test_dex_range import c_function, run_native
from test_level_cap import ROOT

# Every routine that turns Pokedex_ConvertToCurrentDexNo's answer into text.
PRINTERS = {
    "src/pokemon_summary_info.c": "sub_0208CC88",          # the summary's first page
    "src/pc_box_display_ability.c": "ov14_021F5190",       # the PC
    "src/application/pokedex/ov18_021EE75C.c": "ov18_021EE75C",  # the Dex list
    "src/application/pokedex/ov18_021EEC34.c": "ov18_021EEC34",  # an entry's pages
    "src/application/pokedex/ov18_021F8CCC.c": "ov18_021F8CCC",  # a new catch's page
}


NATIONAL = r"""
#include <assert.h>
#include <stdio.h>
#include "constants/species.h"
typedef unsigned short u16;
typedef unsigned int u32;
typedef int BOOL;
#define FALSE 0
#define TRUE 1
u16 SpeciesToJohtoDexNo(u16 species) { return species; }
@NATIVE@
int main(void) {
    static int seen[1026];
    /* Every Dex species outside the gap is one National Dex number, 1..1025,
       apart from the two Galarian forms kept as species, which share
       Slowpoke's and Slowbro's. */
    for (u32 species = 1; species <= NATIONAL_DEX_COUNT; species++) {
        if (species >= FIRST_DEX_GAP && species <= LAST_DEX_GAP) {
            continue;
        }
        u32 number = Pokedex_ConvertToCurrentDexNo(TRUE, species);
        assert(number >= 1 && number <= 1025);
        if (species == SPECIES_SLOWPOKE_GALARIAN || species == SPECIES_SLOWBRO_GALARIAN) {
            continue;
        }
        assert(!seen[number]);
        seen[number] = 1;
    }
    for (u32 number = 1; number <= 1025; number++) {
        assert(seen[number]);
    }
    assert(Pokedex_ConvertToCurrentDexNo(TRUE, SPECIES_ARCEUS) == 493);
    assert(Pokedex_ConvertToCurrentDexNo(TRUE, SPECIES_VICTINI) == 494);
    assert(Pokedex_ConvertToCurrentDexNo(TRUE, SPECIES_LILLIPUP) == 506);
    assert(Pokedex_ConvertToCurrentDexNo(TRUE, SPECIES_PECHARUNT) == 1025);
    assert(Pokedex_ConvertToCurrentDexNo(TRUE, SPECIES_SLOWPOKE_GALARIAN) == 79);
    assert(Pokedex_ConvertToCurrentDexNo(TRUE, SPECIES_MEGA_VENUSAUR) == 3);
    assert(Pokedex_ConvertToCurrentDexNo(FALSE, SPECIES_CHIKORITA) == SPECIES_CHIKORITA);
    printf("PASS: the Dex prints National Dex numbers 1..1025: Lillipup 506, Pecharunt 1025.\n");
    return 0;
}
"""


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

    def test_an_added_species_prints_its_national_number(self):
        """The species New Gold adds were appended after the gap, so their
        identifier is not their number: Lillipup is species 508 and No. 506.
        The reference prints National Dex numbers."""
        pokedex = (ROOT / "src/pokedex.c").read_text()
        tables = "\n".join(pokedex[pokedex.index(f"static const u16 {name}["):][:pokedex[pokedex.index(f"static const u16 {name}["):].index("};") + 2]
                           for name in ("sFormBaseSpecies", "sNationalDexNumbers"))
        util = (ROOT / "src/pokedex_util.c").read_text()
        native = "\n".join([tables, c_function(pokedex, "SpeciesToDexSpecies"), c_function(pokedex, "SpeciesToNationalDexNo"),
                            c_function(util, "Pokedex_ConvertToCurrentDexNo")])
        run_native(self, NATIONAL.replace("@NATIVE@", native), "newgold-dex-national-")


if __name__ == "__main__":
    unittest.main()
