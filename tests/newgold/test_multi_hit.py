#!/usr/bin/env python3
"""The hit count of the moves that hit more than once.

SetMultiHit's first operand is the count, and 0 asks BtlCmd_SetMultiHit to
roll two to five. Only a rolled count lets Skill Link and Loaded Dice in, so a
script that names its count outright is a move those two never touch.
"""

import os
from pathlib import Path
import re
import shlex
import subprocess
import tempfile
import unittest

from test_level_cap import ROOT, function
from test_move_effects import EFFECT_SCRIPTS, moves, records

COMMAND = ROOT / "src/battle/battle_command.c"

PREFIX = r'''
#include <assert.h>
#include <stdint.h>
#include "constants/abilities.h"
#include "constants/battle.h"
#include "constants/items.h"
#include "constants/moves.h"
#include "constants/species.h"
typedef uint8_t u8; typedef uint16_t u16; typedef uint32_t u32;
typedef int BOOL;
#define TRUE 1
#define FALSE 0

typedef struct { int unused; } BattleSystem;
typedef struct {
    int battlerIdAttacker;
    int moveNoCur;
    struct { u16 species; } battleMons[4];
    u8 multiHitCount;
    u8 multiHitCountTemp;
    u32 checkMultiHit;
} BattleContext;

static int script[2], scriptPos;
static u16 rolls[2];
static int rollCount, ability, heldEffect;

static void BattleScriptIncrementPointer(BattleContext *ctx, int n) { (void)ctx; (void)n; }
static int BattleScriptReadWord(BattleContext *ctx) { (void)ctx; return script[scriptPos++]; }
static int GetBattlerAbility(BattleContext *ctx, int b) { (void)ctx; (void)b; return ability; }
static int GetBattlerHeldItemEffect(BattleContext *ctx, int b) { (void)ctx; (void)b; return heldEffect; }
static u16 BattleSystem_Random(BattleSystem *bs) { (void)bs; assert(rollCount < 2); return rolls[rollCount++]; }
@NATIVE@

// The count a rolled multi-hit move lands, when the first random number is
// `roll` and any second one is `again`.
static u16 species, move;

static int hits(u16 roll, u16 again) {
    BattleSystem bs = {0};
    BattleContext ctx = {0};
    ctx.battleMons[0].species = species;
    ctx.moveNoCur = move;
    script[0] = 0;
    script[1] = MULTIHIT_MULTI_HIT_MOVE;
    scriptPos = 0;
    rolls[0] = roll;
    rolls[1] = again;
    rollCount = 0;
    BtlCmd_SetMultiHit(&bs, &ctx);
    assert(ctx.multiHitCountTemp == ctx.multiHitCount);
    return ctx.multiHitCount;
}

int main(void) {
    // Over one hundred first rolls, whatever the second: 35/35/15/15.
    int counts[6] = {0};
    for (u16 again = 0; again < 4; again++) {
        for (u16 roll = 0; roll < 100; roll++) {
            counts[hits(roll, again)]++;
        }
    }
    assert(counts[0] == 0 && counts[1] == 0);
    assert(counts[2] == 4 * 35 && counts[3] == 4 * 35);
    assert(counts[4] == 4 * 15 && counts[5] == 4 * 15);

    // The roll is taken modulo a hundred, not masked.
    assert(hits(100 + 34, 0) == 2 && hits(100 + 35, 0) == 3);
    assert(hits(100 + 84, 0) == 4 && hits(100 + 85, 0) == 5);

    // Skill Link always lands five.
    ability = ABILITY_SKILL_LINK;
    assert(hits(0, 0) == 5);
    ability = 0;

    // Loaded Dice turns a two or a three into a four or a five, and leaves a
    // four alone.
    heldEffect = HOLD_EFFECT_INCREASE_MULTI_STRIKE_MINIMUM;
    assert(hits(0, 0) == 5 && hits(0, 1) == 4 && hits(69, 1) == 4);
    assert(hits(70, 0) == 4);
    heldEffect = 0;

    // Ash-Greninja's Water Shuriken lands three, dice or no dice; a Greninja
    // in its Battle Bond form rolls like anyone.
    species = SPECIES_GRENINJA_ASH;
    move = MOVE_WATER_SHURIKEN;
    assert(hits(0, 0) == 3 && hits(99, 0) == 3);
    heldEffect = HOLD_EFFECT_INCREASE_MULTI_STRIKE_MINIMUM;
    assert(hits(0, 0) == 3);
    heldEffect = 0;
    species = SPECIES_GRENINJA_BATTLE_BOND;
    assert(hits(0, 0) == 2 && hits(99, 0) == 5);
    species = SPECIES_GRENINJA_ASH;
    move = MOVE_BUBBLE;
    assert(hits(0, 0) == 2);
    species = move = 0;
    return 0;
}
'''


def script_for(move):
    effect = records()[moves()[move]][0]
    return (EFFECT_SCRIPTS / f"effect_script_{effect:04d}.s").read_text()


def set_multi_hit(script):
    return re.search(r"^\s*SetMultiHit (\d+), (\w+)", script, re.M).groups()


class MultiHitScripts(unittest.TestCase):
    def test_solar_seeds_rolls_two_to_five(self):
        """konefr's own move, Bullet Seed with a burn: SetMultiHit 0 in
        effect_script_0407_BURN_MULTI_HIT at ccf2c9f5."""
        self.assertEqual(set_multi_hit(script_for("SOLAR_SEEDS")), ("0", "MULTIHIT_MULTI_HIT_MOVE"))

    def test_triple_axel_climbs_twenty_a_hit(self):
        """20, 40, 60, as the reference's CalcBaseDamage has it at d0380a487
        (20 * (4 - multiHitCount)): CalcMoveDamage works it out from the
        strikes left, for Triple Kick's 10, 20, 30 too (test_move_power), so
        neither script adds to the power."""
        steps = lambda move: re.findall(r"UpdateVar OPCODE_ADD, BSCRIPT_VAR_MOVE_POWER, (\d+)", script_for(move))
        self.assertEqual(steps("TRIPLE_KICK"), [])
        self.assertEqual(steps("TRIPLE_AXEL"), [])
        self.assertEqual(set_multi_hit(script_for("TRIPLE_AXEL")), ("3", "MULTIHIT_TRIPLE_KICK"))

    def test_surging_strikes_is_a_critical_hit_three_times(self):
        """The reference's critical roll gives up for
        MOVE_EFFECT_HIT_THREE_TIMES_ALWAYS_CRITICAL (other_battle_calculators.c:1769
        at d0380a487). The script runs once a hit, so it asks each time."""
        script = script_for("SURGING_STRIKES")
        self.assertEqual(set_multi_hit(script), ("3", "MULTIHIT_MULTI_HIT_MOVE"))
        self.assertIn("BSCRIPT_VAR_CRITICAL_BOOSTS, CRITICAL_STAGE_ALWAYS", script)
        self.assertLess(script.index("BSCRIPT_VAR_CRITICAL_BOOSTS, CRITICAL_STAGE_ALWAYS"), script.index("\n    CalcCrit"))


class WaterShuriken(unittest.TestCase):
    def test_ash_greninja_throws_it_at_twenty(self):
        """CalcBaseDamage.c:316-320 at d0380a487, for the Ash form here."""
        body = function((ROOT / "src/battle/overlay_12_0224E4FC.c").read_text(), "CalcMoveDamage")
        self.assertRegex(body, r"moveNo == MOVE_WATER_SHURIKEN && ctx->battleMons\[battlerIdAttacker\]\.species == "
                               r"SPECIES_GRENINJA_ASH\) \{\n\s*movePower = 20;")


class RolledCount(unittest.TestCase):
    def test_the_odds_are_the_references(self):
        """BtlCmd_SetMultiHit, extracted and run against every first roll: the
        reference's Random % 100 with cut-offs at 35, 70 and 85
        (battle_script_commands.c at d0380a487), with Skill Link and Loaded
        Dice where they were."""
        native = function(COMMAND.read_text(), "BtlCmd_SetMultiHit")
        with tempfile.TemporaryDirectory(prefix="newgold-multi-hit-") as temp:
            c, exe = Path(temp) / "check.c", Path(temp) / "check"
            c.write_text(PREFIX.replace("@NATIVE@", native))
            result = subprocess.run(shlex.split(os.environ.get("CC", "cc")) + [
                "-std=c11", "-O1", "-g", "-fsanitize=address,undefined", "-fno-omit-frame-pointer",
                "-iquote", str(ROOT / "include"), str(c), "-o", str(exe)], capture_output=True, text=True)
            self.assertEqual(result.returncode, 0, result.stderr)
            result = subprocess.run([str(exe)], capture_output=True, text=True,
                                    env={**os.environ, "ASAN_OPTIONS": "detect_leaks=0", "UBSAN_OPTIONS": "halt_on_error=1"})
            self.assertEqual(result.returncode, 0, result.stderr)


if __name__ == "__main__":
    unittest.main()
