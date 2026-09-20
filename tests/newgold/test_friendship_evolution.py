#!/usr/bin/env python3
"""Check the friendship evolution threshold the ROM actually compiles with.

GetMonEvolution is too entangled with the evolution tables, the clock and the
party to run on the host cheaply, and the change is a threshold rather than
logic. So this compiles the repository's own constant and verifies that every
friendship branch reads it instead of carrying its own number.
"""

import os
from pathlib import Path
import re
import shlex
import subprocess
import tempfile
import unittest

from test_level_cap import ROOT, function

PROGRAM = r'''
#include <assert.h>
#include <stdio.h>
#include "constants/pokemon.h"

int main(void) {
    // Modern generations evolve at 160; HGSS shipped with 220.
    assert(FRIENDSHIP_EVOLUTION_THRESHOLD == 160);
    assert(FRIENDSHIP_EVOLUTION_THRESHOLD < FRIENDSHIP_MAX);
    // Above the middle tier, so a Pokemon reaching it is already well treated.
    assert(FRIENDSHIP_EVOLUTION_THRESHOLD > FRIENDSHIP_TIER_MID_MIN);
    assert(FRIENDSHIP_EVOLUTION_THRESHOLD < FRIENDSHIP_TIER_HI_MIN);
    puts("PASS: threshold 160 and all three friendship branches read it.");
}
'''


class FriendshipEvolutionTests(unittest.TestCase):
    def test_every_friendship_branch_uses_the_constant(self):
        source = function((ROOT / "src/pokemon.c").read_text(), "GetMonEvolution")
        branches = re.findall(r"case (EVO_FRIENDSHIP[A-Z_]*):\s*\n\s*if \((.*)\) \{", source)
        self.assertEqual(
            [name for name, _ in branches],
            ["EVO_FRIENDSHIP", "EVO_FRIENDSHIP_DAY", "EVO_FRIENDSHIP_NIGHT"],
        )
        for name, condition in branches:
            self.assertIn("friendship >= FRIENDSHIP_EVOLUTION_THRESHOLD", condition, name)
        # No friendship comparison anywhere in the function keeps its own number.
        self.assertNotIn("friendship >= 2", source)

    def test_threshold_value(self):
        with tempfile.TemporaryDirectory(prefix="newgold-friendship-") as temp:
            c, exe = Path(temp) / "check.c", Path(temp) / "check"
            c.write_text(PROGRAM)
            result = subprocess.run(shlex.split(os.environ.get("CC", "cc")) + ["-std=c11", "-O1", "-g", "-fsanitize=undefined", "-iquote", str(ROOT / "include"), str(c), "-o", str(exe)], capture_output=True, text=True)
            self.assertEqual(result.returncode, 0, result.stderr)
            result = subprocess.run([str(exe)], capture_output=True, text=True, env={**os.environ, "UBSAN_OPTIONS": "halt_on_error=1"})
            self.assertEqual(result.returncode, 0, result.stderr)
            print(result.stdout.strip())


if __name__ == "__main__":
    unittest.main()
