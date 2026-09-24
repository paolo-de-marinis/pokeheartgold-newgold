#!/usr/bin/env python3
"""Check the Battle Factory's hint of the next trainer's most common type.

FrtCmd_103's case 18 counts the types of the next opponent's Pokemon and
answers the one most of them share. Retail counted in eighteen slots, which
ended at Dark: a Fairy type wrote one past the array, into the saved registers
of the caller, and was never the answer. The case runs here on the host, with
the Pokemon's types standing in for the Factory's records.
"""

import os
import shlex
import subprocess
import tempfile
import unittest
from pathlib import Path

from test_level_cap import ROOT

SOURCE = ROOT / "src/frontier/overlay_80_0222F830.c"

FIXTURE = r"""
#include <stdint.h>
#include <stdio.h>
#include "constants/heap.h"
#include "constants/pokemon.h"
typedef uint8_t u8;
typedef uint16_t u16;
typedef uint32_t u32;
typedef struct { int types[2]; } FrontierMon;
typedef struct { int types[2]; } Pokemon;
typedef struct { u8 type; FrontierMon opponentMons[4]; } FactoryData;
static Pokemon sMon;
static int ov80_02236DF8(u8 type, int a1) { (void)type; (void)a1; return 3; }
static int ov80_02237120(FactoryData *data) { (void)data; return 50; }
static Pokemon *AllocMonZeroed(int heapID) { (void)heapID; return &sMon; }
static void Heap_Free(void *ptr) { (void)ptr; }
static void ov80_0222A140(FrontierMon *frontierMon, Pokemon *mon, int level) {
    (void)level;
    mon->types[0] = frontierMon->types[0];
    mon->types[1] = frontierMon->types[1];
}
static u32 GetMonData(Pokemon *mon, int attr, void *ptr) {
    (void)ptr;
    return mon->types[attr == MON_DATA_TYPE_2];
}
static u16 MostCommonType(FactoryData *data) {
    int i, type1, type2;
    Pokemon *mon;
    u16 result = 0;
    u16 *out = &result;
    switch (18) {
    @CASE@
    }
    return result;
}
int main(void) {
    // Togekiss, Clefable and Gardevoir: three Fairies.
    FactoryData fairies = { 0, { { { TYPE_FAIRY, TYPE_FLYING } }, { { TYPE_FAIRY, TYPE_FAIRY } }, { { TYPE_PSYCHIC, TYPE_FAIRY } } } };
    // Gengar, Haunter and Umbreon: two Ghosts tie two Poisons, and the lower type wins as in retail.
    FactoryData ghosts = { 0, { { { TYPE_GHOST, TYPE_POISON } }, { { TYPE_GHOST, TYPE_POISON } }, { { TYPE_DARK, TYPE_DARK } } } };
    // Three types once each: no hint.
    FactoryData mixed = { 0, { { { TYPE_FIRE, TYPE_FIRE } }, { { TYPE_WATER, TYPE_WATER } }, { { TYPE_FAIRY, TYPE_FAIRY } } } };
    int failed = 0;
    if (MostCommonType(&fairies) != TYPE_FAIRY) { printf("three Fairies gave %d\n", MostCommonType(&fairies)); failed = 1; }
    if (MostCommonType(&ghosts) != TYPE_POISON) { printf("Ghost/Poison twice gave %d\n", MostCommonType(&ghosts)); failed = 1; }
    if (MostCommonType(&mixed) != TYPE_NONE) { printf("one of each gave %d\n", MostCommonType(&mixed)); failed = 1; }
    return failed;
}
"""


class FactoryTypeHintTests(unittest.TestCase):
    def test_a_fairy_team_is_hinted_fairy(self):
        source = SOURCE.read_text()
        case = source[source.index("    case 18:"):source.index("    case 19:")]
        with tempfile.TemporaryDirectory(prefix="newgold-factory-") as directory:
            path = Path(directory)
            (path / "test.c").write_text(FIXTURE.replace("@CASE@", case))
            subprocess.run(shlex.split(os.environ.get("CC", "cc")) + [
                "-std=c99", "-Wall", "-Werror", "-Wno-unused-function", "-fsanitize=address", "-iquote", str(ROOT / "include"),
                str(path / "test.c"), "-o", str(path / "test")], check=True)
            result = subprocess.run([str(path / "test")], capture_output=True, text=True, timeout=30)
        self.assertEqual(result.returncode, 0, result.stdout + result.stderr)


if __name__ == "__main__":
    unittest.main()
