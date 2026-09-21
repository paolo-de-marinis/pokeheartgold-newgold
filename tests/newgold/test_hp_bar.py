#!/usr/bin/env python3
"""Check the HP bar drains at a fixed rate.

Retail moves the bar by a number of HP each frame, so a Pokemon with a large
maximum empties visibly faster than a small one. New Gold moves it by a pixel
a frame whatever the maximum. pokeheartgold already had the switch; what this
checks is that it is on and that it does what it says.
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

SOURCE = ROOT / "src/battle/battle_hp_bar.c"

FIXTURE = r"""
#include <assert.h>
#include <stdint.h>
#include <stdio.h>
typedef int32_t s32;
typedef uint8_t u8;
typedef uint16_t u16;
#define TRUE 1
#define FAST_HP_BARS
@NATIVE@

// How many frames the bar takes to go from full to empty.
static int frames(s32 maxHp, u8 tilesWide) {
    s32 calc = (s32)0x80000000u;
    int count = 0;
    while (BattleHpBar_CalculatePixelsChangeFrame(maxHp, maxHp, maxHp, &calc, tilesWide, 1) != -1) {
        if (++count > 10000) {
            return count;
        }
    }
    return count;
}

int main(void) {
    // However much HP a Pokemon has, the bar takes about as many frames to
    // empty as it has pixels. Integer division can cost a frame either way,
    // which is the only thing the maximum is allowed to change.
    for (u8 tiles = 1; tiles <= 6; tiles++) {
        int pixels = tiles * 8;
        for (s32 maxHp = 20; maxHp <= 700; maxHp += 20) {
            int taken = frames(maxHp, tiles);
            assert(taken >= pixels - 1 && taken <= pixels + 1);
        }
    }
    puts("PASS: the bar empties in a pixel's time a frame at every maximum HP.");
    return 0;
}
"""


class HpBarTests(unittest.TestCase):
    def test_the_switch_is_on(self):
        config = (ROOT / "include/config.h").read_text()
        self.assertRegex(config, r"(?m)^#define FAST_HP_BARS\s*$")
        self.assertIn('#include "config.h"', (ROOT / "include/global.h").read_text())

    def test_the_rate_does_not_depend_on_maximum_hp(self):
        source = FIXTURE.replace(
            "@NATIVE@", function(SOURCE.read_text(), "BattleHpBar_CalculatePixelsChangeFrame")
            .replace("USE_SUBPIXELS_TEST", "TRUE")
            .replace("== 0x80000000", "== (s32)0x80000000u"))
        with tempfile.TemporaryDirectory(prefix="newgold-hp-bar-") as directory:
            path = Path(directory)
            (path / "test.c").write_text(source)
            subprocess.run(shlex.split(os.environ.get("CC", "cc")) + [
                "-std=c99", "-Wall", "-Wextra", "-Werror",
                str(path / "test.c"), "-o", str(path / "test")], check=True)
            print(subprocess.run([str(path / "test")], capture_output=True, text=True,
                                 check=True).stdout.strip())


if __name__ == "__main__":
    unittest.main()
