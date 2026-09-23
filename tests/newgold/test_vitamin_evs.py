#!/usr/bin/env python3
"""Run the native effort-value modifier with host sanitizers.

TryModEV is extracted from src/use_item_on_mon.c and compiled against the
repository's own limits, so the ceilings it checks are the ones the ROM uses.
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
#include <stdint.h>
#include <stdio.h>
#include "constants/pokemon.h"
typedef int32_t s32;
@NATIVE@
'''

MAIN = r'''
int main(void) {
    // A vitamin now trains a stat to the competitive maximum, not to 100.
    assert(MAX_EV_VITAMINS == 252);
    // Battles stop at the same 252 now, so a vitamin and a battle agree.
    assert(MAX_EV_VITAMINS == MAX_EV_PER_STAT);

    // Ten at a time, from nothing, with room to spare in the total.
    s32 ev = 0;
    int steps = 0;
    while (ev != -1) {
        s32 next = TryModEV(ev, 0, 10);
        if (next == -1) break;
        assert(next > ev);
        ev = next;
        steps++;
        assert(steps < 64);
    }
    assert(ev == MAX_EV_VITAMINS);
    assert(TryModEV(MAX_EV_VITAMINS, 0, 10) == -1);

    // The 510 total still wins over the per-stat ceiling.
    assert(TryModEV(0, MAX_EV_SUM, 10) == -1);
    assert(TryModEV(0, MAX_EV_SUM - 4, 10) == 4);
    assert(TryModEV(100, MAX_EV_SUM - 104, 10) == 104);

    // Berries still remove effort values and stop at nothing.
    assert(TryModEV(10, 0, -10) == 0);
    assert(TryModEV(5, 0, -10) == 0);
    assert(TryModEV(0, 0, -10) == -1);

    // A stat at 255 from before battles stopped at 252 -- an old save or a
    // trade -- is pulled back to the ceiling by a berry, not pushed further.
    assert(TryModEV(255, 0, -1) == MAX_EV_VITAMINS);

    puts("PASS: vitamin ceiling 252, 510 total, berry decrements and overshoot.");
}
'''


class VitaminEVTests(unittest.TestCase):
    def test_native_vitamin_ceiling(self):
        native = function((ROOT / "src/use_item_on_mon.c").read_text(), "TryModEV")
        program = PREFIX.replace("@NATIVE@", native) + MAIN
        with tempfile.TemporaryDirectory(prefix="newgold-vitamin-evs-") as temp:
            c, exe = Path(temp) / "check.c", Path(temp) / "check"
            c.write_text(program)
            result = subprocess.run(shlex.split(os.environ.get("CC", "cc")) + ["-std=c11", "-O1", "-g", "-fsanitize=address,undefined", "-fno-omit-frame-pointer", "-iquote", str(ROOT / "include"), str(c), "-o", str(exe)], capture_output=True, text=True)
            self.assertEqual(result.returncode, 0, result.stderr)
            result = subprocess.run([str(exe)], capture_output=True, text=True, env={**os.environ, "ASAN_OPTIONS": "detect_leaks=0", "UBSAN_OPTIONS": "halt_on_error=1"})
            self.assertEqual(result.returncode, 0, result.stderr)
            print(result.stdout.strip())


if __name__ == "__main__":
    unittest.main()
