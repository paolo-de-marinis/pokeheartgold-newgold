#!/usr/bin/env python3
"""The summary screen's cry asks for the Pokemon's form.

The record's form and ability swapped places (82722b7ba) so a full ability ID
fits in the old form halfword; the summary's cry went on reading that
halfword, so Sky Shaymin's summary asked for form 32 (Serene Grace) and
played the Land Forme's cry. This runs the real sub_02089C50 against
stand-ins and checks the form it hands on.
"""

import os
from pathlib import Path
import shlex
import subprocess
import tempfile
import unittest

from test_repels import ROOT, function, without_includes

PROGRAM = r'''
#include <assert.h>
#include <stdint.h>
#include <stdio.h>
#include <string.h>
#include "constants/pokemon.h"
#include "constants/species.h"
typedef uint8_t u8; typedef uint16_t u16; typedef uint32_t u32; typedef int32_t s32;
typedef int BOOL;
typedef struct NARC NARC;
typedef struct SOUND_CHATOT SOUND_CHATOT;
typedef struct String String;
typedef struct PokemonSummaryArgs { u8 unk0[0x28]; intptr_t unk28; } PokemonSummaryArgs;
@RECORD@
typedef struct PokemonSummaryAppPrefix {
    PokemonSummaryArgs *args;
    PokemonSummaryMon mon;
    NARC *unk7B8;
} PokemonSummaryAppPrefix;

static int cries, form = -1;
static void sub_020729A4(NARC *narc, u8 *delay, u16 species, u16 a3) { (void)narc; (void)species; (void)a3; *delay = 0; }
static BOOL sub_02006EA0(SOUND_CHATOT *c, u32 a1, u32 a2, s32 a3, u8 a4) { (void)c; (void)a1; (void)a2; (void)a3; (void)a4; return 1; }
static void sub_020062E0(u16 species, u8 delay, u8 asked) { (void)species; (void)delay; cries++; form = asked; }

@NATIVE@

int main(void) {
    PokemonSummaryAppPrefix summary;
    memset(&summary, 0, sizeof(summary));
    summary.mon.species = SPECIES_SHAYMIN;
    summary.mon.form = 1;       // Sky Forme: sub_02006A0C gives it its own cry
    summary.mon.ability = 32;   // Serene Grace, in the halfword that was the form
    sub_02089C50(&summary);
    assert(cries == 1 && form == 1);
    puts("PASS: the summary's cry asks for the form, not the ability");
    return 0;
}
'''


class SummaryCryTests(unittest.TestCase):
    def test_summary_cry_asks_for_the_form(self):
        header = (ROOT / "include/pokemon_summary_app.h").read_text()
        record = header[header.index("typedef struct PokemonSummaryMon {"):
                        header.index("} PokemonSummaryMon;") + len("} PokemonSummaryMon;")]
        native = function((ROOT / "src/pokemon_summary_cry.c").read_text(), "sub_02089C50")
        source = PROGRAM.replace("@RECORD@", without_includes(record)).replace("@NATIVE@", native)
        with tempfile.TemporaryDirectory(prefix="newgold-summary-cry-") as temp:
            c, exe = Path(temp) / "check.c", Path(temp) / "check"
            c.write_text(source)
            result = subprocess.run(shlex.split(os.environ.get("CC", "cc")) + [
                "-std=c11", "-O1", "-g", "-fsanitize=address,undefined", "-iquote", str(ROOT / "include"),
                str(c), "-o", str(exe)], capture_output=True, text=True)
            self.assertEqual(result.returncode, 0, result.stderr)
            result = subprocess.run([str(exe)], capture_output=True, text=True,
                                    env={**os.environ, "ASAN_OPTIONS": "detect_leaks=0"})
            self.assertEqual(result.returncode, 0, result.stderr + result.stdout)
            print(result.stdout.strip())


if __name__ == "__main__":
    unittest.main()
