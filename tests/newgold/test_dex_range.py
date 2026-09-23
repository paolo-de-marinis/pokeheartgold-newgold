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


COMPLETE = r'''
#include <assert.h>
#include <stdint.h>
#include "constants/species.h"
typedef uint16_t u16;
typedef int BOOL;
typedef struct Pokedex Pokedex;
#define NELEMS(a) (sizeof(a) / sizeof((a)[0]))

static u16 owned;
static u16 Pokedex_CountNationalOwned_ExcludeMythical(Pokedex *pokedex) { (void)pokedex; return owned; }
@TABLE@
@NATIVE@

int main(void) {
    // Oak calls it complete above @TOP@; so must everything else.
    owned = @TOP@;
    assert(!Pokedex_NationalDexIsComplete(0));
    owned = @TOP@ + 1;
    assert(Pokedex_NationalDexIsComplete(0));
    return 0;
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

    def test_the_dex_is_complete_where_oak_says_it_is(self):
        """Retail's 484, as the engine keeps it. Oak's rating, the diploma, the
        trainer card's star and Oak's phone flag must agree on the number."""
        source = (ROOT / "src/pokedex.c").read_text()
        table = source[source.index("static const u16 sNationalMythicals[]"):]
        table = table[:table.index("};") + 2]
        rating = (ROOT / "asm/unk_0205BB1C.s").read_text()
        rating = rating[rating.index("thumb_func_start GetOakNationalDexRating"):rating.index("thumb_func_end GetOakNationalDexRating")]
        base = int(re.search(r"mov r3, #(0x[0-9a-f]+)\n\tlsl r3, r3, #2", rating).group(1), 16) << 2
        top = base + int(re.search(r"add r3, #(0x[0-9a-f]+)\n\tcmp r0, r3\n\tbhi", rating).group(1), 16)
        program = COMPLETE.replace("@TABLE@", table).replace("@NATIVE@", function(source, "Pokedex_NationalDexIsComplete")).replace("@TOP@", str(top))
        with tempfile.TemporaryDirectory(prefix="newgold-dex-complete-") as temp:
            c, exe = Path(temp) / "check.c", Path(temp) / "check"
            c.write_text(program)
            result = subprocess.run(shlex.split(os.environ.get("CC", "cc")) + ["-std=c11", "-O1", "-g", "-fsanitize=address,undefined", "-fno-omit-frame-pointer", "-iquote", str(ROOT / "include"), str(c), "-o", str(exe)], capture_output=True, text=True)
            self.assertEqual(result.returncode, 0, result.stderr)
            result = subprocess.run([str(exe)], capture_output=True, text=True, env={**os.environ, "ASAN_OPTIONS": "detect_leaks=0", "UBSAN_OPTIONS": "halt_on_error=1"})
            self.assertEqual(result.returncode, 0, result.stderr)
        self.assertEqual(top, 483)

if __name__ == "__main__":
    unittest.main()
