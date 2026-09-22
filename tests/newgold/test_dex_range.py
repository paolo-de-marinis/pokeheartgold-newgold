#!/usr/bin/env python3
"""Run the Pokedex species check with host sanitizers.

A failed GF_ASSERT resets the game. The species New Gold adds now have Dex
entries of their own, so what this tests is that the Dex covers them, still
passes silently over the fourteen identifiers between them and Arceus — the
egg and the alternate forms, which are not Dex numbers — and still trips the
assertion on a species that cannot exist.
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
    // Everything the Dex covers is valid and silent: HeartGold's own species
    // and the ones New Gold adds after the gap.
    for (u16 species = SPECIES_BULBASAUR; species <= SPECIES_ARCEUS; species++) {
        assertions = 0;
        assert(DexSpeciesIsInvalid(species) == FALSE);
        assert(assertions == 0);
    }
    for (u16 species = LAST_DEX_GAP + 1; species <= NATIONAL_DEX_COUNT; species++) {
        assertions = 0;
        assert(DexSpeciesIsInvalid(species) == FALSE);
        assert(assertions == 0);
    }

    // The forms after the last Dex species have no entry either, and are met
    // in battle all the time, so they are silent too.
    for (u16 species = NATIONAL_DEX_COUNT + 1; species <= NUM_SPECIES; species++) {
        assertions = 0;
        assert(DexSpeciesIsInvalid(species) == TRUE);
        assert(assertions == 0);
    }

    // The egg, the bad egg and the alternate forms have no Dex entry. Meeting
    // one is not an error either, so none of them may reset the game.
    for (u16 species = FIRST_DEX_GAP; species <= LAST_DEX_GAP; species++) {
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

    printf("PASS: %d Dex species, %d without an entry silently, impossible species still assert.\n",
        NATIONAL_DEX_COUNT - NUM_DEX_GAP, NUM_DEX_GAP + NUM_SPECIES - NATIONAL_DEX_COUNT);
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

    def test_the_dex_reaches_the_end_of_the_species(self):
        source = (ROOT / "src/pokedex.c").read_text()
        self.assertGreater(source.count("i <= NATIONAL_DEX_COUNT"), 0)
        header = (ROOT / "include/constants/species.h").read_text()
        self.assertIn("#define NATIONAL_DEX_COUNT LAST_DEX_SPECIES", header)
        self.assertIn("#define LAST_DEX_SPECIES   SPECIES_PECHARUNT", header)
        self.assertEqual(re.search(r"#define SPECIES_ARCEUS\s+(\d+)", header).group(1), "493")

    def test_completing_the_dex_does_not_ask_for_the_gap(self):
        """The fourteen without an entry can never be caught, so a target that
        counted them would put completion out of reach."""
        source = (ROOT / "src/pokedex.c").read_text()
        line = next(l for l in source.splitlines() if "Pokedex_NationalDexIsComplete" in source and "NUM_DEX_GAP" in l)
        self.assertIn("NATIONAL_DEX_COUNT - NUM_DEX_GAP", line)


if __name__ == "__main__":
    unittest.main()
