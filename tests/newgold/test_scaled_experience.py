#!/usr/bin/env python3
"""Run the native scaled experience arithmetic with host sanitizers.

BattleScript_ScaleExpToLevel and BattleScript_GainerExp are extracted from
src/battle/battle_command.c. The DS square-root coprocessor is replaced by an
integer square root with the same contract - a whole-numbered root of the
value written. The native results are checked against reference() below, a
transcription of hg-engine's Task_DistributeExp_Extend (d0380a487,
src/battle/battle_script_commands.c, the EXPERIENCE_FORMULA_GEN > 6 branch):
the whole award scaled with the truncated root in 32 bits, then split.
"""

from math import isqrt
import os
from pathlib import Path
import shlex
import subprocess
import tempfile
import unittest

from test_level_cap import ROOT, function

PREFIX = r'''
#include <stdint.h>
#include <stdio.h>
typedef uint32_t u32;
typedef uint64_t u64;
typedef int BOOL;

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
int main(void) {
    const u32 yields[] = { 36, 50, 142, 255, 608 };
    const int counts[][4] = {
        // participants, Exp. Share holders, this one participated, holds one
        { 1, 0, 1, 0 }, { 1, 1, 1, 1 }, { 2, 1, 1, 0 }, { 2, 1, 0, 1 }, { 3, 2, 1, 1 },
    };
    for (unsigned y = 0; y < sizeof(yields) / sizeof(*yields); y++)
        for (u32 fainted = 1; fainted <= 100; fainted++)
            for (u32 gainer = 1; gainer <= 100; gainer++)
                for (unsigned c = 0; c < sizeof(counts) / sizeof(*counts); c++)
                    printf("%u\n", BattleScript_GainerExp(yields[y] * fainted / 5, fainted, gainer, counts[c][0], counts[c][1], counts[c][2], counts[c][3]));
}
'''

YIELDS = (36, 50, 142, 255, 608)
COUNTS = ((1, 0, True, False), (1, 1, True, True), (2, 1, True, False), (2, 1, False, True), (3, 2, True, True))
M = 0xFFFFFFFF


def reference(base, fainted, gainer, mon_count=1, share_count=0, participated=True, holds=False):
    total = base * fainted // 5
    top = ((2 * fainted + 10) ** 2 * isqrt(2 * fainted + 10)) & M
    bottom = ((fainted + gainer + 10) ** 2 * isqrt(fainted + gainer + 10)) & M
    result = (top * total) & M
    if result // top != total:
        total = (((result + 1) & M) // bottom + M // bottom + 1) & M
    else:
        total = result // bottom
    if share_count:
        part, share = max(total // 2 // mon_count, 1), max(total // 2 // share_count, 1)
    else:
        part, share = max(total // mon_count, 1), 0
    return (part if participated else 0) + (share if holds else 0)


class ScaledExperienceTests(unittest.TestCase):
    def test_reference_figures(self):
        # The audit's figures, one participant: the whole-numbered roots move
        # them away from the exact ratio, and that is what the game pays.
        self.assertEqual(reference(50, 5, 10), 25)
        self.assertEqual(reference(64, 12, 19), 87)
        self.assertEqual(reference(608, 100, 50), 24439)
        # Scaled before the split: one participant holding the Exp. Share.
        self.assertEqual(reference(50, 3, 23, 1, 1, True, True), 2)

    def test_native_matches_the_reference(self):
        source = (ROOT / "src/battle/battle_command.c").read_text()
        native = "\n".join(function(source, name) for name in ("BattleScript_ScaleExpToLevel", "BattleScript_GainerExp"))
        program = PREFIX.replace("@NATIVE@", native) + MAIN
        with tempfile.TemporaryDirectory(prefix="newgold-scaled-exp-") as temp:
            c, exe = Path(temp) / "check.c", Path(temp) / "check"
            c.write_text(program)
            result = subprocess.run(shlex.split(os.environ.get("CC", "cc")) + ["-std=c11", "-O1", "-g", "-fsanitize=address,undefined", "-fno-omit-frame-pointer", "-iquote", str(ROOT / "include"), str(c), "-o", str(exe)], capture_output=True, text=True)
            self.assertEqual(result.returncode, 0, result.stderr)
            result = subprocess.run([str(exe)], capture_output=True, text=True, env={**os.environ, "ASAN_OPTIONS": "detect_leaks=0", "UBSAN_OPTIONS": "halt_on_error=1"})
            self.assertEqual(result.returncode, 0, result.stderr)
        got = iter(int(line) for line in result.stdout.split())
        wrapped = 0
        for base in YIELDS:
            for fainted in range(1, 101):
                top = (2 * fainted + 10) ** 2 * isqrt(2 * fainted + 10)
                for gainer in range(1, 101):
                    wrapped += top * (base * fainted // 5) > M
                    for counts in COUNTS:
                        want, value = reference(base, fainted, gainer, *counts), next(got)
                        self.assertEqual(value, want, f"yield {base}, level {fainted} beaten at {gainer}, counts {counts}")
        self.assertIsNone(next(got, None))
        # The wrapped branch is reached, by the large yields at high levels.
        self.assertGreater(wrapped, 0)
        print(f"PASS: {len(YIELDS) * 100 * 100 * len(COUNTS)} awards equal the reference's, {wrapped} level pairs through its wrap.")


if __name__ == "__main__":
    unittest.main()
