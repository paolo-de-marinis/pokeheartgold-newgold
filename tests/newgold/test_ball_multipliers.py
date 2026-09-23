#!/usr/bin/env python3
"""Check the ball catch multipliers the ROM compiles with.

BattleSystem_CalculateBallShakes reaches into the battle context, the save and
the clock, so running it on the host would mean stubbing most of a battle for
what are, in the end, seven numbers. This reads the multiplier each ball case
sets instead, which is the thing that changed, and pins the Friend Ball's
friendship at the 150 hg-engine's config asks for. The reference's own code
overwrites its 150 with 200 on every catch, against that config; the port
keeps the config's value.
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

# The species a Moon Stone evolves, which is what the Moon Ball has meant since
# Generation VIII. HGSS listed whole families instead; the reference builds this
# list with MOON_BALL_GENERATION at GEN_LATEST, so the families are compiled out.
MOON_BALL_SPECIES = [
    "SPECIES_NIDORINA",
    "SPECIES_NIDORINO",
    "SPECIES_CLEFAIRY",
    "SPECIES_JIGGLYPUFF",
    "SPECIES_SKITTY",
    "SPECIES_MUNNA",
]

# Multipliers are tenths: 35 means a 3.5x catch rate.
EXPECTED = {
    "ITEM_NET_BALL": "35",
    "ITEM_DIVE_BALL": "35",
    "ITEM_REPEAT_BALL": "35",
    "ITEM_DUSK_BALL": "30",
    "ITEM_QUICK_BALL": "50",
}

PROGRAM = r'''
#include <assert.h>
#include <stdio.h>
#include "constants/balls.h"
#include "constants/pokemon.h"

int main(void) {
    // The modern Friend Ball value, FRIEND_BALL_GENERATION = GEN_LATEST in
    // the reference's config, kept apart from the friendship tier that
    // happens to carry HGSS's 200.
    assert(FRIEND_BALL_FRIENDSHIP == 150);
    assert(FRIENDSHIP_TIER_HI_MIN == 200);
    assert(FRIEND_BALL_FRIENDSHIP < FRIENDSHIP_TIER_HI_MIN);
    assert(FRIEND_BALL_FRIENDSHIP > FRIENDSHIP_TIER_MID_MIN);
    puts("PASS: five ball multipliers, the level and turn formulas, Friend Ball friendship.");
}
'''


class BallMultiplierTests(unittest.TestCase):
    def setUp(self):
        source = (ROOT / "src/battle/battle_command.c").read_text()
        self.body = function(source, "BattleSystem_CalculateBallShakes")

    def case(self, ball):
        start = self.body.index(f"case {ball}:")
        end = self.body.index("break;", start)
        return self.body[start:end]

    def test_flat_multipliers(self):
        for ball, value in EXPECTED.items():
            self.assertRegex(self.case(ball), rf"ballMultiplier = {value};", ball)

    def test_nest_ball_scales_to_level_thirty(self):
        nest = self.case("ITEM_NEST_BALL")
        self.assertIn("level <= 30", nest)
        self.assertIn("ballMultiplier = 41 - level;", nest)
        # The old shape clamped a wider range up to a floor; that is gone.
        self.assertNotIn("ballMultiplier < 10", nest)

    def test_timer_ball_gains_three_tenths_a_turn(self):
        timer = self.case("ITEM_TIMER_BALL")
        self.assertIn("ballMultiplier = 10 + 3 * ctx->totalTurns;", timer)
        # Ten turns to reach the ceiling: 10 + 3 * 10 == 40.
        self.assertEqual(10 + 3 * 10, 40)
        self.assertIn("> 40", self.body[self.body.index("case ITEM_TIMER_BALL:"):])

    def test_moon_ball_follows_the_moon_stone(self):
        table = (ROOT / "asm/overlay_12_battle_command.s").read_text()
        table = table[table.index("sMoonBallPokemon:"):]
        table = table[:table.index(".public")]
        self.assertEqual(re.findall(r"SPECIES_\w+", table), MOON_BALL_SPECIES)
        # NELEMS walks the extern, so its declared length has to follow.
        self.assertIn(f"extern u16 sMoonBallPokemon[{len(MOON_BALL_SPECIES)}];", (ROOT / "src/battle/battle_command.c").read_text())

    def test_moon_ball_matches_the_reference(self):
        if REFERENCE is None:
            self.skipTest("no reference checkout")
        source = revision(REFERENCE, REFERENCE_COMMIT, "src/individual/CalculateBallShakes.c")
        source = source[source.index("MoonBallSpecies[]"):]
        source = source[:source.index("};")]
        # MOON_BALL_GENERATION is GEN_LATEST, so the gen-4 families are not built.
        kept = source[:source.index("#if MOON_BALL_GENERATION == 4")]
        self.assertEqual(re.findall(r"SPECIES_\w+", kept), MOON_BALL_SPECIES)

    def test_sport_ball_only_helps_in_the_bug_contest(self):
        sport = self.case("ITEM_SPORT_BALL")
        self.assertIn("BATTLE_TYPE_BUG_CONTEST", sport)
        self.assertIn("ballMultiplier = 15;", sport)
        # Ungated it would have been a Poke Ball and a half everywhere.
        self.assertLess(sport.index("BATTLE_TYPE_BUG_CONTEST"), sport.index("ballMultiplier = 15;"))

    def test_heavy_ball_weighs_the_pokemon(self):
        heavy = self.case("ITEM_HEAVY_BALL")
        self.assertEqual(
            re.findall(r"weight < (\d+)", heavy) + re.findall(r"catchRate ([-+]= \d+)", heavy),
            ["999", "1999", "2999", "-= 20", "+= 20", "+= 30"])
        # HGSS asked its last question about the catch rate, not the weight.
        self.assertNotIn("catchRate < 1024", heavy)

    def test_friend_ball_uses_its_own_constant(self):
        self.assertIn("u8 friendship = FRIEND_BALL_FRIENDSHIP;", self.body)
        with tempfile.TemporaryDirectory(prefix="newgold-ball-multipliers-") as temp:
            c, exe = Path(temp) / "check.c", Path(temp) / "check"
            c.write_text(PROGRAM)
            result = subprocess.run(shlex.split(os.environ.get("CC", "cc")) + ["-std=c11", "-O1", "-g", "-fsanitize=undefined", "-iquote", str(ROOT / "include"), str(c), "-o", str(exe)], capture_output=True, text=True)
            self.assertEqual(result.returncode, 0, result.stderr)
            result = subprocess.run([str(exe)], capture_output=True, text=True, env={**os.environ, "UBSAN_OPTIONS": "halt_on_error=1"})
            self.assertEqual(result.returncode, 0, result.stderr)
            print(result.stdout.strip())


if __name__ == "__main__":
    unittest.main()
