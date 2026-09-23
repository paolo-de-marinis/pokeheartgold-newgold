#!/usr/bin/env python3
"""Knock Off hits half again as hard when there is an item it could take.

hg-engine (d0380a487, CalcBaseDamage.c) multiplies Knock Off's base power by
1.5 when CanKnockOffApply says the target's item can come off, and leaves
Sticky Hold and a substitute out of that question: they keep the item, not
the power. KnockOffCanRemoveItem is compiled here with the context it reads.
"""

import os
import re
import shlex
import subprocess
import tempfile
import unittest
from pathlib import Path

from test_repels import ROOT, function, read

FIXTURE = r"""
#include <assert.h>
#include <stdint.h>
#include <string.h>
#include "constants/abilities.h"
#include "constants/items.h"
#include "constants/species.h"
typedef uint8_t u8;
typedef uint16_t u16;
typedef uint32_t u32;
typedef int BOOL;
#define TRUE 1
#define FALSE 0

typedef struct { u16 species, item, ability; } BattleMon;
typedef struct { BattleMon battleMons[4]; } BattleContext;

@WELDED@

@CAN_REMOVE@

int main(void) {
    BattleContext ctx;
    memset(&ctx, 0, sizeof(ctx));
    ctx.battleMons[1].species = SPECIES_SNORLAX;
    assert(!KnockOffCanRemoveItem(&ctx, 1));             // nothing to take
    ctx.battleMons[1].item = ITEM_LEFTOVERS;
    assert(KnockOffCanRemoveItem(&ctx, 1));
    ctx.battleMons[1].ability = ABILITY_STICKY_HOLD;     // keeps it, still hit harder
    assert(KnockOffCanRemoveItem(&ctx, 1));
    ctx.battleMons[1].ability = ABILITY_MULTITYPE;       // subscript 142 leaves it
    assert(!KnockOffCanRemoveItem(&ctx, 1));
    ctx.battleMons[1].ability = 0;
    ctx.battleMons[1].item = ITEM_GRISEOUS_ORB;
    assert(!KnockOffCanRemoveItem(&ctx, 1));
    ctx.battleMons[1].species = SPECIES_IRON_VALIANT;    // welded to its species
    ctx.battleMons[1].item = ITEM_BOOSTER_ENERGY;
    assert(!KnockOffCanRemoveItem(&ctx, 1));
    return 0;
}
"""


class KnockOffTests(unittest.TestCase):
    def test_what_knock_off_could_take(self):
        overlay = read("src/battle/overlay_12_0224E4FC.c")
        source = (FIXTURE.replace("@WELDED@", function(overlay, "ItemIsWeldedToTheSpecies"))
                  .replace("@CAN_REMOVE@", function(overlay, "KnockOffCanRemoveItem")))
        with tempfile.TemporaryDirectory(prefix="newgold-knock-off-") as directory:
            path = Path(directory)
            (path / "check.c").write_text(source)
            result = subprocess.run(shlex.split(os.environ.get("CC", "cc")) + [
                "-std=c99", "-Wall", "-Werror", "-Wno-unused-function", "-iquote", str(ROOT / "include"),
                str(path / "check.c"), "-o", str(path / "check")], capture_output=True, text=True)
            self.assertEqual(result.returncode, 0, result.stderr)
            result = subprocess.run([str(path / "check")], capture_output=True, text=True)
            self.assertEqual(result.returncode, 0, result.stderr)

    def test_the_damage_maths_boosts_it(self):
        body = function(read("src/battle/overlay_12_0224E4FC.c"), "CalcMoveDamage")
        self.assertRegex(body, r"moveNo == MOVE_KNOCK_OFF && KnockOffCanRemoveItem\(ctx, battlerIdTarget\)\)"
                               r"\s*\{\s*movePower = movePower \* 15 / 10;")

    def test_the_script_command_asks_the_same_question(self):
        body = function(read("src/battle/battle_command.c"), "BtlCmd_GotoIfCanApplyKnockOffBoost")
        self.assertIn("KnockOffCanRemoveItem(ctx, ctx->battlerIdTarget)", body)


if __name__ == "__main__":
    unittest.main()
