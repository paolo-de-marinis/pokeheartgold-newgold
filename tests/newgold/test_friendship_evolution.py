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
from test_repels import REFERENCE, REFERENCE_COMMIT, revision

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


    def test_sylveon_wants_the_friendship_too(self):
        # A Fairy move alone is not enough; Eevee has to like you as much as
        # Espeon and Umbreon ask for.
        source = function((ROOT / "src/pokemon.c").read_text(), "GetMonEvolution")
        case = source[source.index("case EVO_HAS_MOVE_TYPE:"):]
        case = case[:case.index("break;")]
        self.assertIn("friendship >= FRIENDSHIP_EVOLUTION_THRESHOLD", case)
        # Its neighbour asks for the move alone, in the reference as here.
        plain = source[source.index("case EVO_HAS_MOVE:"):source.index("case EVO_HAS_MOVE_TYPE:")]
        self.assertNotIn("friendship", plain)

    def test_sylveon_gate_matches_the_reference(self):
        if REFERENCE is None:
            self.skipTest("no reference checkout")
        source = revision(REFERENCE, REFERENCE_COMMIT, "src/individual/GetMonEvolutionInternal.c")
        source = source[source.index("case EVOCTX_LEVELUP:"):]
        case = source[source.index("case EVO_HAS_MOVE_TYPE:"):]
        case = case[:case.index("case EVO_LEVEL_DARK_TYPE_MON_IN_PARTY:")]
        self.assertIn("friendship >= FRIENDSHIP_EVOLUTION_THRESHOLD", case)

    def test_eevee_reaches_sylveon_before_the_other_two(self):
        # The level-up loop stops at the first row that matches, so a Fairy-move
        # Eevee that is fond enough for Espeon or Umbreon has to meet Sylveon
        # first or it never becomes one. The reference lists it there too.
        import json
        table = json.loads((ROOT / "files/poketool/personal/evo.json").read_text())["evoTable"]
        eevee = next(e for e in table if e["baseSpecies"] == "SPECIES_EEVEE")
        methods = [evo["method"] for evo in eevee["evos"]]
        self.assertLess(methods.index("EVO_HAS_MOVE_TYPE"), methods.index("EVO_FRIENDSHIP_DAY"))
        self.assertLess(methods.index("EVO_HAS_MOVE_TYPE"), methods.index("EVO_FRIENDSHIP_NIGHT"))
        levelup = function((ROOT / "src/pokemon.c").read_text(), "GetMonEvolution")
        levelup = levelup[levelup.index("case EVOCTX_LEVELUP:"):levelup.index("case EVOCTX_TRADE:")]
        self.assertIn("if (target != SPECIES_NONE)", levelup)

    def test_eevee_order_matches_the_reference(self):
        if REFERENCE is None:
            self.skipTest("no reference checkout")
        source = revision(REFERENCE, REFERENCE_COMMIT, "data/Evolutions.c")
        entry = source[source.index("[SPECIES_EEVEE] = {"):]
        entry = entry[:entry.index("},\n\n")]
        targets = re.findall(r"SPECIES_(ESPEON|UMBREON|SYLVEON)", entry)
        self.assertEqual(targets, ["SYLVEON", "ESPEON", "UMBREON"])


if __name__ == "__main__":
    unittest.main()
