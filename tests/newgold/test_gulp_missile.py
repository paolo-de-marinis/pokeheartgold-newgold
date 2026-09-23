#!/usr/bin/env python3
"""Gulp Missile (Pokemon Central, Inghiottimissile).

A Cramorant catches an Arrokuda above half its HP, a Pikachu at half or below,
when its Surf reaches a target or it goes under with Dive, and shows the form
once the action is over; hit by a damaging move, it spits the prey back. The
catch and the form run natively; where they are asked is read from the source.
"""

import os
import shlex
import subprocess
import tempfile
import unittest
from pathlib import Path

from test_level_cap import ROOT
from test_repels import function

OVERLAY = (ROOT / "src/battle/overlay_12_0224E4FC.c").read_text()
CONTROLLER = (ROOT / "src/battle/battle_controller_player.c").read_text()

PROGRAM = r"""
#include <assert.h>
#include <stdint.h>
#include <string.h>
#include "constants/abilities.h"
#include "constants/battle.h"
#include "constants/species.h"
typedef uint8_t u8; typedef uint16_t u16; typedef int32_t s32; typedef uint32_t u32;
typedef int BOOL;
#define TRUE 1
#define FALSE 0
typedef struct { u16 species; u16 ability; s32 hp; u32 maxHp; u32 status2; } BattleMon;
typedef struct { u32 gulpMissilePrey : 2; } SelfTurnData;
typedef struct { BattleMon battleMons[4]; SelfTurnData selfTurnData[4]; } BattleContext;
static u16 GetBattlerAbility(BattleContext *ctx, int battlerId) { return ctx->battleMons[battlerId].ability; }
@FUNCTIONS@
static BattleContext ctx;

static u16 caught(u16 species, u16 ability, s32 hp, u32 status2) {
    memset(&ctx, 0, sizeof(ctx));
    ctx.battleMons[0] = (BattleMon){ species, ability, hp, 100, status2 };
    Battler_GulpMissileCatch(&ctx, 0);
    return Battler_GulpMissileForm(&ctx, 0);
}

int main(void) {
    assert(caught(SPECIES_CRAMORANT, ABILITY_GULP_MISSILE, 51, 0) == SPECIES_CRAMORANT_GULPING);
    assert(caught(SPECIES_CRAMORANT, ABILITY_GULP_MISSILE, 50, 0) == SPECIES_CRAMORANT_GORGING);
    assert(caught(SPECIES_CRAMORANT, ABILITY_GULP_MISSILE, 1, 0) == SPECIES_CRAMORANT_GORGING);
    // Not without the ability, not transformed, not fainted, not another
    // species, and not a Cramorant already holding its prey.
    assert(caught(SPECIES_CRAMORANT, ABILITY_NONE, 90, 0) == SPECIES_NONE);
    assert(caught(SPECIES_CRAMORANT, ABILITY_GULP_MISSILE, 90, STATUS2_TRANSFORM) == SPECIES_NONE);
    assert(caught(SPECIES_CRAMORANT, ABILITY_GULP_MISSILE, 0, 0) == SPECIES_NONE);
    assert(caught(SPECIES_PELIPPER, ABILITY_GULP_MISSILE, 90, 0) == SPECIES_NONE);
    assert(caught(SPECIES_CRAMORANT_GULPING, ABILITY_GULP_MISSILE, 90, 0) == SPECIES_NONE);
    // The first catch of the action is the one kept: a spread Surf's second
    // target does not change it.
    caught(SPECIES_CRAMORANT, ABILITY_GULP_MISSILE, 90, 0);
    ctx.battleMons[0].hp = 10;
    Battler_GulpMissileCatch(&ctx, 0);
    assert(Battler_GulpMissileForm(&ctx, 0) == SPECIES_CRAMORANT_GULPING);
    return 0;
}
"""


class GulpMissileTests(unittest.TestCase):
    def test_the_prey_is_caught_by_the_hp_left(self):
        functions = function(OVERLAY, "Battler_GulpMissileCatch") + "\n" + function(OVERLAY, "Battler_GulpMissileForm")
        with tempfile.TemporaryDirectory(prefix="newgold-gulp-missile-") as directory:
            path = Path(directory)
            (path / "test.c").write_text(PROGRAM.replace("@FUNCTIONS@", functions))
            result = subprocess.run(shlex.split(os.environ.get("CC", "cc")) + [
                "-std=c99", "-Wall", "-Werror", "-Wno-unused-function", "-fsanitize=address,undefined",
                "-iquote", str(ROOT / "include"), str(path / "test.c"), "-o", str(path / "test")],
                capture_output=True, text=True)
            self.assertEqual(result.returncode, 0, result.stderr)
            result = subprocess.run([str(path / "test")], capture_output=True, text=True,
                                    env={**os.environ, "ASAN_OPTIONS": "detect_leaks=0"})
        self.assertEqual(result.returncode, 0, result.stderr)

    def test_surf_and_dive_catch_and_the_action_s_end_shows_it(self):
        immunity = function(CONTROLLER, "ov12_0224BC2C")
        self.assertIn("if (script == BATTLE_SUBSCRIPT_NONE && !(ctx->moveStatusFlag & MOVE_STATUS_DID_NOT_HIT) && ctx->moveNoCur == MOVE_SURF) {\n"
                      "                Battler_GulpMissileCatch(ctx, ctx->battlerIdAttacker);", immunity)
        before = function(CONTROLLER, "ov12_0224C38C")
        dive = before.index("if (ctx->moveNoCur == MOVE_DIVE && !(ctx->battleMons[ctx->battlerIdAttacker].status2 & STATUS2_LOCKED_INTO_MOVE)) {")
        self.assertLess(before.index("ctx->battleStatus2 |= BATTLE_STATUS2_MOVE_SUCCEEDED;"), dive)
        self.assertLess(dive, before.index("ReadBattleScriptFromNarc(ctx, NARC_a_0_0_0, ctx->moveNoCur);"))
        forms = function(OVERLAY, "Battler_CheckWeatherFormChange")
        self.assertIn("form = Battler_GulpMissileForm(ctx, ctx->battlerIdTemp);", forms)
        self.assertIn("ctx->selfTurnData[ctx->battlerIdTemp].gulpMissilePrey = 0;", forms)

    def test_a_hit_is_answered_with_the_prey(self):
        hit = function(OVERLAY, "CheckAbilityEffectOnHit")
        case = hit[hit.index("    case ABILITY_GULP_MISSILE:"):]
        case = case[:case.index("break;")]
        for condition in ("SPECIES_CRAMORANT_GULPING", "SPECIES_CRAMORANT_GORGING", "!(ctx->battleMons[ctx->battlerIdTarget].status2 & STATUS2_TRANSFORM)",
                          "ctx->battleMons[ctx->battlerIdAttacker].hp", "ctx->selfTurnData[ctx->battlerIdTarget].physicalDamage || ctx->selfTurnData[ctx->battlerIdTarget].specialDamage"):
            self.assertIn(condition, case)
        # Magic Guard does not keep the prey off.
        self.assertNotIn("ABILITY_MAGIC_GUARD", case)
        self.assertIn("? MOVE_SUBSCRIPT_PTR_DEFENSE_DOWN_1_STAGE : 0;", case)
        self.assertIn("BattleSystem_ChangeBattlerForm(battleSystem, ctx, ctx->battlerIdTarget, SPECIES_CRAMORANT, FALSE);", case)
        self.assertIn("ctx->hpCalc = DamageDivide(ctx->battleMons[ctx->battlerIdAttacker].maxHp * -1, 4);", case)
        self.assertIn("*script = BATTLE_SUBSCRIPT_GULP_MISSILE;", case)
        script = next((ROOT / "files/battledata/script/subscript").glob("subscript_*_GulpMissile.s")).read_text()
        order = [script.index(line) for line in ("ChangeForm BATTLER_CATEGORY_DEFENDER", "Call BATTLE_SUBSCRIPT_UPDATE_HP",
                                                 "BMON_DATA_HP, 0, _END", "BSCRIPT_VAR_SIDE_EFFECT_PARAM, 0, _PIKACHU",
                                                 "Call BATTLE_SUBSCRIPT_ABILITY_CUTS_STAT", "Call BATTLE_SUBSCRIPT_PARALYZE")]
        self.assertEqual(order, sorted(order))


if __name__ == "__main__":
    unittest.main()
