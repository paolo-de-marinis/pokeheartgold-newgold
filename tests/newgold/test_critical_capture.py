#!/usr/bin/env python3
"""Check the critical capture rate.

A critical throw shakes once instead of three and is no more likely to catch
than an ordinary one. How often it happens depends on how much of the Pokedex
the player has filled in, and the thing that would go wrong quietly is a
boundary in the wrong place: a player with exactly thirty species owned should
never get one, and the bands should not overlap or leave a gap.
"""

import os
import re
import shlex
import subprocess
import tempfile
import unittest
from pathlib import Path

from test_level_cap import ROOT
from test_repels import function

SOURCE = ROOT / "src/battle/battle_command.c"

FIXTURE = r"""
#include <assert.h>
#include <stdint.h>
#include <stdio.h>
typedef uint8_t u8;
typedef uint16_t u16;
typedef uint32_t u32;
typedef int BOOL;
typedef struct BattleSystem BattleSystem;
static u16 owned;
static u16 BattleSystem_CountRegionalDexOwned(BattleSystem *bsys) { (void)bsys; return owned; }
@NATIVE@

int main(void) {
    // Nobody at the start of the game gets one.
    for (owned = 0; owned <= 30; owned++) {
        assert(CriticalCaptureRate(0, 255) == 0);
    }
    // The bands, at the edges where they change.
    const struct { u16 owned; u32 tenths; } bands[] = {
        { 31, 5 }, { 150, 5 }, { 151, 10 }, { 300, 10 },
        { 301, 15 }, { 450, 15 }, { 451, 20 }, { 600, 20 }, { 601, 25 },
    };
    for (unsigned i = 0; i < sizeof(bands) / sizeof(*bands); i++) {
        owned = bands[i].owned;
        assert(CriticalCaptureRate(0, 255) == 255 * bands[i].tenths / 10 / 6);
    }
    // It never rises above a quarter of the chance to catch, whatever the
    // catch rate, and never above the roll's own range.
    owned = 700;
    for (u32 rate = 0; rate <= 255; rate++) {
        u32 critical = CriticalCaptureRate(0, rate);
        assert(critical <= rate);
        assert(critical < 256);
    }
    puts("PASS: critical capture bands, their edges and the ceiling.");
    return 0;
}
"""


class CriticalCaptureTests(unittest.TestCase):
    def test_the_rate_bands(self):
        source = FIXTURE.replace("@NATIVE@", function(SOURCE.read_text(), "CriticalCaptureRate"))
        with tempfile.TemporaryDirectory(prefix="newgold-critical-capture-") as directory:
            path = Path(directory)
            (path / "test.c").write_text(source)
            subprocess.run(shlex.split(os.environ.get("CC", "cc")) + [
                "-std=c99", "-Wall", "-Wextra", "-Werror",
                str(path / "test.c"), "-o", str(path / "test")], check=True)
            result = subprocess.run([str(path / "test")], capture_output=True, text=True, check=True)
            print(result.stdout.strip())

    def test_a_critical_throw_shakes_once(self):
        source = SOURCE.read_text()
        self.assertIn("if (data->ctx->criticalCapture) {", source)
        self.assertIn("ctx->criticalCapture = BattleSystem_Random(bsys) % 256 < CriticalCaptureRate(", source)

    def test_the_count_is_the_regional_dex(self):
        # The reference counts the Johto dex, not the national one, so filling
        # in the national dex does not make every throw a critical one.
        system = (ROOT / "src/battle/battle_system.c").read_text()
        self.assertIn("return Pokedex_CountJohtoDexOwned(battleSystem->pokedex);",
                      function(system, "BattleSystem_CountRegionalDexOwned"))
        self.assertNotIn("BattleSystem_CountDexOwned", SOURCE.read_text())

    # That a caught registered species is shown as a critical throw, the
    # Master Ball's single shake included, is run in test_ball_multipliers.py.


if __name__ == "__main__":
    unittest.main()
