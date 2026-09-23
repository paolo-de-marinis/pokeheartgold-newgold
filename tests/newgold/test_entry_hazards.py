#!/usr/bin/env python3
"""The hazards a Pokemon meets as it comes out.

Subscript 99 is where a Pokemon switching in meets the spikes, the poison
spikes, the web and the pointed stones laid on its side.
"""

import os
import re
from pathlib import Path
import shlex
import subprocess
import tempfile
import unittest

from test_repels import ROOT, function, read

HAZARDS = "files/battledata/script/subscript/subscript_0099_HazardsCheck.s"


def block(text, label):
    """The lines under a label, up to the blank line that ends them."""
    start = re.search(rf"^{label}\n", text, re.M).end()
    return (text[start:] + "\n\n").split("\n\n")[0]


class GroundedTests(unittest.TestCase):
    def test_the_ground_hazards_ask_the_battle_s_own_test(self):
        # Retail asked Gravity, the Iron Ball, Levitate, the two types and
        # Magnet Rise by hand, so an Air Balloon or Eelevate still took the
        # spikes. BattlerIsGrounded knows both.
        text = read(HAZARDS)
        self.assertIn("GotoIfGrounded BATTLER_CATEGORY_SWITCHED_MON", text)
        for asked in ("ABILITY_LEVITATE", "TYPE_FLYING", "MOVE_EFFECT_FLAG_MAGNET_RISE", "FIELD_CONDITION_GRAVITY"):
            self.assertNotIn(asked, text)
        grounded = read("src/battle/overlay_12_0224E4FC.c")
        grounded = grounded[grounded.index("BOOL BattlerIsGrounded("):]
        grounded = grounded[:grounded.index("\n}\n")]
        for lifted in ("ABILITY_LEVITATE", "ABILITY_EELEVATE", "HOLD_EFFECT_UNGROUND_DESTROYED_ON_HIT"):
            self.assertIn(lifted, grounded)



QUEUE_FIXTURE = r"""
#include <assert.h>
#include <stdint.h>
#include <string.h>
#include "constants/battle.h"
typedef uint8_t u8;
typedef uint16_t u16;
typedef uint32_t u32;
typedef int BOOL;
#define TRUE 1
#define FALSE 0

typedef struct {
    u8 entryHazardQueue[2][NUM_HAZARD_IDX];
    u8 hazardQueueTracker;
} BattleContext;
typedef struct BattleSystem BattleSystem;

// A command's operands, and where it jumped.
static int sWords[8], sRead, sJump;
static void BattleScriptIncrementPointer(BattleContext *ctx, int n) { (void)ctx; if (n != 1) sJump = n; }
static int BattleScriptReadWord(BattleContext *ctx) { (void)ctx; return sWords[sRead++]; }
// The side operand is the battler; battlers 0 and 2 are side 0.
static int BattleSystem_GetBattlerIDBySide(BattleSystem *bs, BattleContext *ctx, int side) { (void)bs; (void)ctx; return side; }
static int BattleSystem_GetFieldSide(BattleSystem *bs, int battlerId) { (void)bs; return battlerId & 1; }

@REMOVE@
@ADD@
@TAKE_OFF@
@JUMP@

static void add(BattleContext *ctx, int battler, int hazard) {
    sRead = 0; sWords[0] = battler; sWords[1] = hazard;
    BtlCmd_AddEntryHazardToQueue(0, ctx);
}

static void takeOff(BattleContext *ctx, int battler, int hazard) {
    sRead = 0; sWords[0] = battler; sWords[1] = hazard;
    BtlCmd_RemoveEntryHazardFromQueue(0, ctx);
}

// One step of the walk: the hazard it jumps to, or 0 when the queue is spent.
static int step(BattleContext *ctx, int battler) {
    sRead = 0; sJump = 0; sWords[0] = battler;
    for (int i = 0; i < NUM_HAZARD_IDX; i++) sWords[1 + i] = 100 * (i + 1);
    BtlCmd_JumpToCurrentEntryHazard(0, ctx);
    return sJump / 100;
}

int main(void) {
    BattleContext ctx;
    memset(&ctx, 0, sizeof(ctx));

    // Stealth Rock, then Spikes, then a second layer of Spikes: the layer
    // keeps the Spikes' place.
    add(&ctx, 1, HAZARD_IDX_STEALTH_ROCK);
    add(&ctx, 3, HAZARD_IDX_SPIKES);
    add(&ctx, 1, HAZARD_IDX_SPIKES);
    add(&ctx, 0, HAZARD_IDX_STICKY_WEB);
    assert(step(&ctx, 1) == HAZARD_IDX_STEALTH_ROCK);
    assert(step(&ctx, 1) == HAZARD_IDX_SPIKES);
    assert(step(&ctx, 1) == 0 && ctx.hazardQueueTracker == 0);
    // The other side's queue is its own.
    assert(step(&ctx, 2) == HAZARD_IDX_STICKY_WEB);
    assert(step(&ctx, 2) == 0);

    // Cleared and laid again, a hazard joins the back.
    takeOff(&ctx, 1, HAZARD_IDX_STEALTH_ROCK);
    add(&ctx, 1, HAZARD_IDX_TOXIC_SPIKES);
    add(&ctx, 1, HAZARD_IDX_STEALTH_ROCK);
    assert(step(&ctx, 1) == HAZARD_IDX_SPIKES);

    // Soaked up by the walk itself, the poison spikes' place goes to what
    // came after them, which the walk still meets.
    assert(step(&ctx, 1) == HAZARD_IDX_TOXIC_SPIKES);
    takeOff(&ctx, 1, HAZARD_IDX_TOXIC_SPIKES);
    assert(step(&ctx, 1) == HAZARD_IDX_STEALTH_ROCK);
    assert(step(&ctx, 1) == 0 && ctx.hazardQueueTracker == 0);
    assert(step(&ctx, 1) == HAZARD_IDX_SPIKES);
    return 0;
}
"""

SETTERS = {
    "effect_script/effect_script_0112.s": "AddEntryHazardToQueue BATTLER_CATEGORY_DEFENDER, HAZARD_IDX_SPIKES",
    "effect_script/effect_script_0249.s": "AddEntryHazardToQueue BATTLER_CATEGORY_DEFENDER, HAZARD_IDX_TOXIC_SPIKES",
    "effect_script/effect_script_0266.s": "AddEntryHazardToQueue BATTLER_CATEGORY_DEFENDER, HAZARD_IDX_STEALTH_ROCK",
    "effect_script/effect_script_0281.s": "AddEntryHazardToQueue BATTLER_CATEGORY_DEFENDER, HAZARD_IDX_STICKY_WEB",
    "subscript/subscript_0386_SetStealthRock.s": "AddEntryHazardToQueue BATTLER_CATEGORY_DEFENDER, HAZARD_IDX_STEALTH_ROCK",
    "subscript/subscript_0387_SetSpikes.s": "AddEntryHazardToQueue BATTLER_CATEGORY_DEFENDER, HAZARD_IDX_SPIKES",
    "subscript/subscript_0362_ToxicDebris.s": "AddEntryHazardToQueue BATTLER_CATEGORY_ATTACKER, HAZARD_IDX_TOXIC_SPIKES",
}


class QueueTests(unittest.TestCase):
    """From the fifth generation a Pokemon meets the hazards in the order they
    were laid; retail's subscript 99 always went poison spikes, web, spikes,
    stones. The queue the reference keeps is walked here too."""

    def test_the_queue_commands(self):
        commands = read("src/battle/battle_command.c")
        source = QUEUE_FIXTURE
        for token, name in (("@REMOVE@", "EntryHazardQueueRemove"), ("@ADD@", "BtlCmd_AddEntryHazardToQueue"),
                            ("@TAKE_OFF@", "BtlCmd_RemoveEntryHazardFromQueue"),
                            ("@JUMP@", "BtlCmd_JumpToCurrentEntryHazard")):
            source = source.replace(token, function(commands, name))
        with tempfile.TemporaryDirectory(prefix="newgold-hazards-") as directory:
            path = Path(directory)
            (path / "check.c").write_text(source)
            result = subprocess.run(shlex.split(os.environ.get("CC", "cc")) + [
                "-std=c99", "-Wall", "-Werror", "-Wno-unused-function", "-iquote", str(ROOT / "include"),
                str(path / "check.c"), "-o", str(path / "check")], capture_output=True, text=True)
            self.assertEqual(result.returncode, 0, result.stderr)
            result = subprocess.run([str(path / "check")], capture_output=True, text=True)
            self.assertEqual(result.returncode, 0, result.stderr)

    def test_every_hazard_laid_joins_the_queue(self):
        for path, line in SETTERS.items():
            self.assertIn(line, read("files/battledata/script/" + path), path)

    def test_the_switch_in_walks_the_queue(self):
        text = read(HAZARDS)
        self.assertIn("JumpToCurrentEntryHazard BATTLER_CATEGORY_SWITCHED_MON, _SPIKES, _TOXIC_SPIKES, "
                      "_STEALTH_ROCK, _STICKY_WEB, _NEXT", text)
        # Every hazard's block goes back for the next, and a fainted Pokemon
        # drains the walk rather than leaving it half done.
        for label in ("_SPIKES_GROUNDED:", "_TOXIC_SPIKES_GROUNDED:", "_STEALTH_ROCK:", "_STICKY_WEB_GROUNDED:"):
            self.assertTrue(block(text, label).rstrip().endswith("GoTo _NEXT"), label)
        self.assertIn("BMON_DATA_HP, 0, _DRAIN", text)
        self.assertIn("RemoveEntryHazardFromQueue BATTLER_CATEGORY_SWITCHED_MON, HAZARD_IDX_TOXIC_SPIKES", text)

    def test_magic_guard_turns_away_the_damage_only(self):
        # Pokemon Central (Magicscudo): the fourth generation's Magic Guard
        # kept the poison spikes off, the fifth's on only stops the damage.
        text = read(HAZARDS)
        guarded = [label for label in ("_SPIKES_GROUNDED:", "_TOXIC_SPIKES_GROUNDED:", "_STEALTH_ROCK:",
                                       "_STICKY_WEB_GROUNDED:", "_000:")
                   if "ABILITY_MAGIC_GUARD" in block(text, label)]
        self.assertEqual(guarded, ["_SPIKES_GROUNDED:", "_STEALTH_ROCK:"])

    def test_the_web_says_it_caught_the_pokemon(self):
        # "{0} was caught in a sticky web!", before the Speed drop and before
        # Mirror Armor keeps it, as the reference's subscript 99 prints it.
        web = block(read(HAZARDS), "_STICKY_WEB_GROUNDED:")
        caught = web.index("PrintMessage msg_0197_01516, TAG_NICKNAME, BATTLER_CATEGORY_SWITCHED_MON")
        self.assertLess(web.index("SIDE_CONDITION_STICKY_WEB, _NEXT"), caught)
        self.assertLess(caught, web.index("ABILITY_MIRROR_ARMOR"))
        self.assertLess(caught, web.index("Call BATTLE_SUBSCRIPT_UPDATE_STAT_STAGE"))

    def test_what_clears_a_hazard_takes_it_off(self):
        defog = read("files/battledata/script/subscript/subscript_0171_Defog.s")
        for hazard in ("SPIKES", "TOXIC_SPIKES", "STEALTH_ROCK"):
            self.assertIn(f"RemoveEntryHazardFromQueue BATTLER_CATEGORY_DEFENDER, HAZARD_IDX_{hazard}", defog)
        spin = function(read("src/battle/battle_command.c"), "BtlCmd_RapidSpin")
        for hazard in ("SPIKES", "TOXIC_SPIKES", "STEALTH_ROCK"):
            self.assertIn(f"EntryHazardQueueRemove(ctx, side, HAZARD_IDX_{hazard});", spin)
        tidy = read("files/battledata/script/subscript/subscript_0326_TidyUp.s")
        for side in ("ENEMY", "PLAYER"):
            for hazard in ("SPIKES", "TOXIC_SPIKES"):
                self.assertIn(f"RemoveEntryHazardFromQueue BATTLER_CATEGORY_{side}, HAZARD_IDX_{hazard}", tidy)


if __name__ == "__main__":
    unittest.main()
