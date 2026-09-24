#!/usr/bin/env python3
"""Mold Breaker and its kind, run on the host.

CheckBattlerAbilityIfNotIgnored answers whether a target's ability counts
against the attacker's move; the redirection by Lightning Rod and Storm Drain
(ov12_02250A18) and the target's side's Flower Gift (SideAbilityNotIgnored)
ask it, so that Teravolt and Turboblaze pass them by as Mold Breaker does
(the reference's CLIENT_HAS_MOLD_BREAKER_VARIATION and MoldBreakerAbilityCheck).
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

OVERLAY = (ROOT / "src/battle/overlay_12_0224E4FC.c").read_text()
REFERENCE = Path(os.environ.get(
    "NEWGOLD_REFERENCE", "/home/paolo/Porting HGSS/hg-engine-newgold-reference"))

PROGRAM = r"""
#include <assert.h>
#include <stdint.h>
#include <string.h>
#include "constants/abilities.h"
#include "constants/battle.h"
#include "constants/items.h"
#include "constants/moves.h"
#include "constants/pokemon.h"
typedef uint8_t u8; typedef uint16_t u16; typedef uint32_t u32;
typedef int BOOL;
#define TRUE 1
#define FALSE 0
typedef struct { int unused; } BattleSystem;
typedef struct { int hp; u16 item; } BattleMon;
typedef struct { u32 lightningRodFlag : 1, stormDrainFlag : 1, moldBreakerFlag : 1; } SelfTurnData;
typedef struct { u32 followMeFlag : 1; u8 battlerIdFollowMe; } FieldSideConditionData;
typedef struct {
    int battlerIdAttacker; int battlerIdTarget; u32 battleStatus; u32 moveNoCur; u32 moveNoTemp;
    BattleMon battleMons[4]; SelfTurnData selfTurnData[4];
    FieldSideConditionData fieldSideConditionData[2]; u8 turnOrder[4];
} BattleContext;
typedef struct { u8 range; u8 category; u8 type; } MoveTbl;
static struct { u16 ability[4]; int type; MoveTbl move; } S;
static u16 GetBattlerAbility(BattleContext *ctx, int battlerId) { (void)ctx; return S.ability[battlerId]; }
static const MoveTbl *BattleMoveTbl(BattleContext *ctx, u32 moveNo) { (void)ctx; (void)moveNo; return &S.move; }
static int GetDynamicMoveType(BattleSystem *bs, BattleContext *ctx, int battlerId, u32 moveNo) { (void)bs; (void)ctx; (void)battlerId; (void)moveNo; return S.type; }
static int BattleSystem_GetMaxBattlers(BattleSystem *bs) { (void)bs; return 4; }
static int BattleSystem_GetFieldSide(BattleSystem *bs, int battlerId) { (void)bs; return battlerId & 1; }
// Any standing Pokemon but the user with the ability.
static int CheckAbilityActive(BattleSystem *bs, BattleContext *ctx, int flag, int battlerId, int ability) {
    (void)bs; assert(flag == CHECK_ABILITY_ALL_HP_NOT_USER);
    int n = 0;
    for (int i = 0; i < 4; i++) {
        n += i != battlerId && ctx->battleMons[i].hp && S.ability[i] == ability;
    }
    return n;
}
// The item stands for its hold effect.
static int GetItemVar(BattleContext *ctx, u16 item, u32 var) { (void)ctx; (void)var; return item; }
@FUNCTIONS@
static BattleSystem bs;
static BattleContext ctx;

static void reset(void) {
    memset(&S, 0, sizeof(S));
    memset(&ctx, 0, sizeof(ctx));
    for (int i = 0; i < 4; i++) {
        ctx.battleMons[i].hp = 100;
        ctx.turnOrder[i] = i;
    }
    S.move = (MoveTbl){ RANGE_SINGLE_TARGET, CATEGORY_SPECIAL };
}

// Battler 0 aims at 1; battler 3, on 1's side, has the rod or the drain.
static int redirected(int attacker, int type, int ability) {
    reset();
    S.ability[0] = attacker;
    S.ability[3] = ability;
    S.type = type;
    ctx.battlerIdTarget = 1;
    ov12_02250A18(&bs, &ctx, 0, MOVE_THUNDERBOLT);
    return ctx.battlerIdTarget == 3;
}

int main(void) {
    assert(redirected(ABILITY_NONE, TYPE_ELECTRIC, ABILITY_LIGHTNINGROD));
    assert(redirected(ABILITY_NONE, TYPE_WATER, ABILITY_STORM_DRAIN));
    static const u16 breakers[] = { ABILITY_MOLD_BREAKER, ABILITY_TERAVOLT, ABILITY_TURBOBLAZE };
    for (int i = 0; i < 3; i++) {
        assert(!redirected(breakers[i], TYPE_ELECTRIC, ABILITY_LIGHTNINGROD));
        assert(ctx.battlerIdTarget == 1);
        assert(!redirected(breakers[i], TYPE_WATER, ABILITY_STORM_DRAIN));
        assert(ctx.battlerIdTarget == 1);
        // The target's side's Flower Gift is ignored too; the attacker's own
        // side's is not the question.
        reset();
        S.ability[0] = breakers[i];
        S.ability[3] = ABILITY_FLOWER_GIFT;
        assert(!SideAbilityNotIgnored(&bs, &ctx, 0, 1, ABILITY_FLOWER_GIFT));
        S.ability[0] = ABILITY_NONE;
        assert(SideAbilityNotIgnored(&bs, &ctx, 0, 1, ABILITY_FLOWER_GIFT));
        ctx.battleMons[3].hp = 0;
        assert(!SideAbilityNotIgnored(&bs, &ctx, 0, 1, ABILITY_FLOWER_GIFT));
    }
    // A move never passes its own user's ability by: Sunsteel Strike's user
    // keeps its Contrary for itself, while the target's is passed.
    reset();
    ctx.moveNoCur = ctx.moveNoTemp = MOVE_SUNSTEEL_STRIKE;
    S.ability[0] = S.ability[1] = ABILITY_CONTRARY;
    assert(CheckBattlerAbilityIfNotIgnored(&ctx, 0, 0, ABILITY_CONTRARY));
    assert(!CheckBattlerAbilityIfNotIgnored(&ctx, 0, 1, ABILITY_CONTRARY));
    // Mycelium Might passes the rod by with a status move alone.
    reset();
    S.move.category = CATEGORY_STATUS;
    S.ability[0] = ABILITY_MYCELIUM_MIGHT;
    S.ability[3] = ABILITY_LIGHTNINGROD;
    S.type = TYPE_ELECTRIC;
    ctx.battlerIdTarget = 1;
    ov12_02250A18(&bs, &ctx, 0, MOVE_THUNDER_WAVE);
    assert(ctx.battlerIdTarget == 1);
    assert(redirected(ABILITY_MYCELIUM_MIGHT, TYPE_ELECTRIC, ABILITY_LIGHTNINGROD));
    // The AI's question about a party Pokemon's ability.
    for (int i = 0; i < 3; i++) {
        assert(AbilityBreaksMolds(breakers[i]));
    }
    assert(!AbilityBreaksMolds(ABILITY_MYCELIUM_MIGHT) && !AbilityBreaksMolds(ABILITY_NONE));
    // An Ability Shield keeps the holder's ability heard (Pokemon Central,
    // Scudo abilita): the rod draws the move, the flowers bloom, and the
    // shield on another Pokemon does nothing for this one.
    for (int i = 0; i < 3; i++) {
        reset();
        S.ability[0] = breakers[i];
        S.ability[1] = ABILITY_STURDY;
        ctx.battleMons[1].item = HOLD_EFFECT_PREVENT_ABILITY_CHANGES;
        assert(CheckBattlerAbilityIfNotIgnored(&ctx, 0, 1, ABILITY_STURDY));
        ctx.battleMons[1].item = 0;
        ctx.battleMons[0].item = HOLD_EFFECT_PREVENT_ABILITY_CHANGES;
        assert(!CheckBattlerAbilityIfNotIgnored(&ctx, 0, 1, ABILITY_STURDY));
        reset();
        S.ability[0] = breakers[i];
        S.ability[3] = ABILITY_LIGHTNINGROD;
        S.type = TYPE_ELECTRIC;
        ctx.battleMons[3].item = HOLD_EFFECT_PREVENT_ABILITY_CHANGES;
        ctx.battlerIdTarget = 1;
        ov12_02250A18(&bs, &ctx, 0, MOVE_THUNDERBOLT);
        assert(ctx.battlerIdTarget == 3);
        reset();
        S.ability[0] = breakers[i];
        S.ability[3] = ABILITY_FLOWER_GIFT;
        ctx.battleMons[3].item = HOLD_EFFECT_PREVENT_ABILITY_CHANGES;
        assert(SideAbilityNotIgnored(&bs, &ctx, 0, 1, ABILITY_FLOWER_GIFT));
    }
    return 0;
}
"""


def run(test):
    names = ["AbilityBreaksMolds", "BattlerIgnoresRedirection", "BattlerHasAbilityShield", "BattlerIgnoresAbilities",
             "CheckBattlerAbilityIfNotIgnored", "SideAbilityNotIgnored", "ov12_02250A18"]
    functions = "\n".join(function(OVERLAY, name) for name in names)
    program = PROGRAM.replace("@FUNCTIONS@", functions)
    with tempfile.TemporaryDirectory(prefix="newgold-mold-breaker-") as directory:
        path = Path(directory)
        (path / "test.c").write_text(program)
        result = subprocess.run(shlex.split(os.environ.get("CC", "cc")) + [
            "-std=c99", "-Wall", "-Werror", "-Wno-unused-function", "-fsanitize=address,undefined",
            "-iquote", str(ROOT / "include"), str(path / "test.c"), "-o", str(path / "test")],
            capture_output=True, text=True)
        test.assertEqual(result.returncode, 0, result.stderr)
        result = subprocess.run([str(path / "test")], capture_output=True, text=True,
                                env={**os.environ, "ASAN_OPTIONS": "detect_leaks=0"})
    test.assertEqual(result.returncode, 0, result.stderr)


class MoldBreakerTests(unittest.TestCase):
    def test_they_pass_the_rod_and_the_flowers_by_unless_shielded(self):
        run(self)

    @unittest.skipUnless(REFERENCE.exists(), "the reference is not here")
    def test_only_an_ability_mold_breaker_can_pass_is_asked_so(self):
        # The reference's second guard (MoldBreakerAbilityCheckInternal) is
        # its AbilityFlags table; here the callers choose, and every ability
        # they ask as one a move can pass by must be one the table marks.
        flags = subprocess.run(["git", "-C", str(REFERENCE), "show", "1fa3c9366:data/AbilityFlags.c"],
                               capture_output=True, text=True, check=True).stdout
        breakable = {name.replace("LIGHTNING_ROD", "LIGHTNINGROD") for name in re.findall(
            r"\[(ABILITY_\w+)\] = \{[^}]*ignoredByMoldBreaker = TRUE", flags)}
        asked = set()
        for path in (ROOT / "src/battle").glob("*.c"):
            text = path.read_text()
            asked |= set(re.findall(r"(?:CheckBattlerAbilityIfNotIgnored|SideAbilityNotIgnored)\([^;]*?, (ABILITY_\w+)\)", text))
        for path in (ROOT / "files/battledata/script").glob("*/*.s"):
            asked |= set(re.findall(r"CheckIgnorableAbility \w+, \w+, (ABILITY_\w+)", path.read_text()))
        self.assertGreater(len(asked), 50)
        self.assertEqual(asked - breakable, set())

    def test_the_ai_asks_it_of_levitate_and_wonder_guard(self):
        body = function(OVERLAY, "ov12_02252054")
        for ability in ("LEVITATE", "WONDER_GUARD"):
            self.assertIn("if ((!AbilityBreaksMolds(abilityAttacker) || item == HOLD_EFFECT_PREVENT_ABILITY_CHANGES) && abilityTarget == ABILITY_" + ability, body)

    def test_the_damage_asks_the_side_s_flower_gift_so(self):
        self.assertIn("(weather & FIELD_CONDITION_SUN_ALL) && SideAbilityNotIgnored(battleSystem, ctx, battlerIdAttacker, battlerIdTarget, ABILITY_FLOWER_GIFT)",
                      function(OVERLAY, "CalcMoveDamage"))


if __name__ == "__main__":
    unittest.main()
