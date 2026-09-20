#!/usr/bin/env python3
"""Run the native scaled experience arithmetic with host sanitizers.

BattleScript_ScaleExpToLevel is extracted from src/battle/battle_command.c. The
DS square-root coprocessor is replaced by an integer square root with the same
contract - a whole-numbered root of the value written - so this checks the
fixed-point arithmetic and its agreement with the real formula, not the
hardware.
"""

import os
from pathlib import Path
import shlex
import subprocess
import tempfile
import unittest

from test_level_cap import ROOT, function

PREFIX = r'''
#include <assert.h>
#include <math.h>
#include <stdint.h>
#include <stdio.h>
typedef uint32_t u32;
typedef uint64_t u64;

// Stand-in for the coprocessor: the hardware returns the whole-numbered root.
static u32 sqrtParam;
static void CP_SetSqrt32(u32 param) { sqrtParam = param; }
static u32 CP_GetSqrtResult32(void) {
    u32 root = 0;
    while ((u64)(root + 1) * (root + 1) <= sqrtParam) root++;
    return root;
}
@NATIVE@
'''

MAIN = r'''
static double exact(double exp, double faintedLevel, double gainerLevel) {
    double top = 2.0 * faintedLevel + 10.0;
    double bottom = faintedLevel + gainerLevel + 10.0;
    return exp * pow(top / bottom, 2.5);
}

int main(void) {
    // Beating something at your own level pays what the base yield says.
    for (u32 level = 2; level <= 100; level++) {
        u32 same = BattleScript_ScaleExpToLevel(1000, level, level);
        double want = exact(1000, level, level);
        assert(fabs((double)same - want) <= 1.0);
    }

    // Outranking the gainer pays more, being outranked pays less, and the
    // reward falls as the gainer levels up.
    u32 previous = 0xFFFFFFFF;
    for (u32 gainer = 1; gainer <= 100; gainer++) {
        u32 got = BattleScript_ScaleExpToLevel(5000, 50, gainer);
        assert(got <= previous);
        previous = got;
        if (gainer < 50) assert(got > BattleScript_ScaleExpToLevel(5000, 50, 50));
        if (gainer > 50) assert(got < BattleScript_ScaleExpToLevel(5000, 50, 50));
    }

    // The fixed-point result tracks the real formula across the whole range.
    const u32 yields[] = { 100, 1000, 12000, 65535 };
    double worst = 0.0;
    for (u32 fainted = 1; fainted <= 100; fainted++) {
        for (u32 gainer = 1; gainer <= 100; gainer++) {
            for (unsigned y = 0; y < sizeof(yields) / sizeof(*yields); y++) {
                u32 got = BattleScript_ScaleExpToLevel(yields[y], fainted, gainer);
                double want = exact(yields[y], fainted, gainer);
                if (want < 1.0) {
                    // Below a whole point the floor takes over.
                    assert(got == 1);
                    continue;
                }
                // Eleven fractional bits of root, then one point of truncation.
                assert(fabs((double)got - want) <= 1.0 + want * 0.001);
                // Where truncation is not the dominant term, measure the root.
                if (want >= 1000.0) {
                    double error = fabs((double)got - want) / want;
                    if (error > worst) worst = error;
                }
            }
        }
    }
    assert(worst < 0.001);

    // Nothing overflows at the extremes, zero stays zero, and a reward that
    // survives the battle never rounds away to nothing.
    assert(BattleScript_ScaleExpToLevel(0, 100, 1) == 0);
    assert(BattleScript_ScaleExpToLevel(1, 1, 100) == 1);
    assert(BattleScript_ScaleExpToLevel(65535, 100, 1) > 65535);
    assert(BattleScript_ScaleExpToLevel(65535, 1, 100) < 65535);
    // The ratio itself tops out at (210/111) raised to 2.5, a little under 5.
    assert(BattleScript_ScaleExpToLevel(65535, 100, 1) < 65535 * 5);

    printf("PASS: 40000 level and yield pairs within %.4f%% of the exact formula, ordering, floor and extremes.\n", worst * 100.0);
}
'''


class ScaledExperienceTests(unittest.TestCase):
    def test_native_scaled_experience(self):
        native = function((ROOT / "src/battle/battle_command.c").read_text(), "BattleScript_ScaleExpToLevel")
        program = PREFIX.replace("@NATIVE@", native) + MAIN
        with tempfile.TemporaryDirectory(prefix="newgold-scaled-exp-") as temp:
            c, exe = Path(temp) / "check.c", Path(temp) / "check"
            c.write_text(program)
            result = subprocess.run(shlex.split(os.environ.get("CC", "cc")) + ["-std=c11", "-O1", "-g", "-fsanitize=address,undefined", "-fno-omit-frame-pointer", "-iquote", str(ROOT / "include"), str(c), "-o", str(exe), "-lm"], capture_output=True, text=True)
            self.assertEqual(result.returncode, 0, result.stderr)
            result = subprocess.run([str(exe)], capture_output=True, text=True, env={**os.environ, "ASAN_OPTIONS": "detect_leaks=0", "UBSAN_OPTIONS": "halt_on_error=1"})
            self.assertEqual(result.returncode, 0, result.stderr)
            print(result.stdout.strip())


if __name__ == "__main__":
    unittest.main()
