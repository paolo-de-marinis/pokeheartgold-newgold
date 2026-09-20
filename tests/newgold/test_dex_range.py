#!/usr/bin/env python3
"""Run the Pokedex species check with host sanitizers.

A failed GF_ASSERT resets the game, so what this really tests is that meeting
one of the species New Gold adds records nothing instead of resetting, while a
genuinely impossible species still trips the assertion.
"""

import os
from pathlib import Path
import re
import shlex
import subprocess
import tempfile
import unittest

from test_level_cap import ROOT, function

PREFIX = r'''
#include <assert.h>
#include <stdint.h>
#include <stdio.h>
#include "constants/species.h"
typedef uint16_t u16;
typedef int BOOL;
#define TRUE 1
#define FALSE 0

// A failed assertion resets the console; here it is only counted.
static int assertions;
#define GF_ASSERT(expr) ((expr) ? (void)0 : (void)assertions++)
@NATIVE@
'''

MAIN = r'''
int main(void) {
    // Everything the Dex covers is valid and silent.
    for (u16 species = SPECIES_BULBASAUR; species <= SPECIES_ARCEUS; species++) {
        assertions = 0;
        assert(DexSpeciesIsInvalid(species) == FALSE);
        assert(assertions == 0);
    }

    // The egg, the bad egg, the alternate forms and the species New Gold adds
    // are all outside the Dex. None of them may reset the game.
    for (u16 species = SPECIES_ARCEUS + 1; species <= NUM_SPECIES; species++) {
        assertions = 0;
        assert(DexSpeciesIsInvalid(species) == TRUE);
        assert(assertions == 0);
    }

    // Nothing is still an error, and so is a species that cannot exist.
    assertions = 0;
    assert(DexSpeciesIsInvalid(SPECIES_NONE) == TRUE);
    assert(assertions == 1);
    assertions = 0;
    assert(DexSpeciesIsInvalid(NUM_SPECIES + 1) == TRUE);
    assert(assertions == 1);

    printf("PASS: %d Dex species, %d outside it silently, impossible species still assert.\n",
        SPECIES_ARCEUS, NUM_SPECIES - SPECIES_ARCEUS);
}
'''


class DexRangeTests(unittest.TestCase):
    def test_new_species_do_not_reset_the_game(self):
        native = function((ROOT / "src/pokedex.c").read_text(), "DexSpeciesIsInvalid")
        program = PREFIX.replace("@NATIVE@", native) + MAIN
        with tempfile.TemporaryDirectory(prefix="newgold-dex-range-") as temp:
            c, exe = Path(temp) / "check.c", Path(temp) / "check"
            c.write_text(program)
            result = subprocess.run(shlex.split(os.environ.get("CC", "cc")) + ["-std=c11", "-O1", "-g", "-fsanitize=address,undefined", "-fno-omit-frame-pointer", "-iquote", str(ROOT / "include"), str(c), "-o", str(exe)], capture_output=True, text=True)
            self.assertEqual(result.returncode, 0, result.stderr)
            result = subprocess.run([str(exe)], capture_output=True, text=True, env={**os.environ, "ASAN_OPTIONS": "detect_leaks=0", "UBSAN_OPTIONS": "halt_on_error=1"})
            self.assertEqual(result.returncode, 0, result.stderr)
            print(result.stdout.strip())

    def test_the_dex_still_counts_only_its_own_species(self):
        source = (ROOT / "src/pokedex.c").read_text()
        # The counting loops must not have been widened along with the check.
        self.assertGreater(source.count("i <= NATIONAL_DEX_COUNT"), 0)
        self.assertNotIn("i <= NUM_SPECIES", source)
        header = (ROOT / "include/constants/species.h").read_text()
        self.assertIn("#define NATIONAL_DEX_COUNT SPECIES_ARCEUS", header)
        self.assertEqual(re.search(r"#define SPECIES_ARCEUS\s+(\d+)", header).group(1), "493")


if __name__ == "__main__":
    unittest.main()
