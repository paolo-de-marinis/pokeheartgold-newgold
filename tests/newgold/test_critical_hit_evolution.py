#!/usr/bin/env python3
"""Run TryCriticalHit on the host for the critical hits it counts.

hg-engine counts the critical hits a Pokemon lands while it is out and, at
the third, marks its party record for Galarian Farfetch'd's evolution. The
function is the real one from overlay_12_0224E4FC.c, compiled against a
BattleContext holding only the fields it reads.
"""

import os
import re
import shlex
import subprocess
import tempfile
import unittest
from pathlib import Path

from test_level_cap import ROOT
from test_repels import function, read

FIXTURE = r"""
#include <assert.h>
#include <stddef.h>
#include <stdint.h>
#include "constants/abilities.h"
#include "constants/battle.h"
#include "constants/items.h"
#include "constants/pokemon.h"
#include "constants/species.h"

typedef uint8_t u8;
typedef uint16_t u16;
typedef uint32_t u32;
typedef int BOOL;
#define TRUE 1
#define FALSE 0

typedef struct { u8 bits113; int writes; } Pokemon;
typedef struct { Pokemon mons[6]; } Party;
typedef struct BattleSystem BattleSystem;
typedef struct {
    u16 species, ability;
    u32 status, status2, moveEffectFlags;
    u8 criticalHits : 2;
} BattleMon;
typedef struct { u8 laserFocusTimer : 2; } MoveConditions;
typedef struct {
    BattleMon battleMons[4];
    MoveConditions moveConditions[4];
    u8 selectedMonIndex[4];
    u8 levelUpMons;
} BattleContext;

static Party parties[2];
static int critical;
static u32 GetMonData(Pokemon *mon, int field, void *dest) {
    assert(field == MON_DATA_UNUSED_113 && dest == NULL);
    return mon->bits113;
}
static void SetMonData(Pokemon *mon, int field, void *value) {
    assert(field == MON_DATA_UNUSED_113);
    mon->bits113 = *(u8 *)value;
    mon->writes++;
}
static inline u32 MaskOfFlagNo(int flag) { return 1u << flag; }
// Battlers 0 and 2 are the player's, 1 and 3 the opponent's.
static Party *BattleSystem_GetParty(BattleSystem *battleSystem, int battlerId) { (void)battleSystem; return &parties[battlerId & 1]; }
static Pokemon *BattleSystem_GetPartyMon(BattleSystem *battleSystem, int battlerId, int index) { return &BattleSystem_GetParty(battleSystem, battlerId)->mons[index]; }
static u16 BattleSystem_Random(BattleSystem *battleSystem) { (void)battleSystem; return critical ? 0 : 1; }
static u16 GetBattlerHeldItem(BattleContext *ctx, int battlerId) { (void)ctx; (void)battlerId; return ITEM_NONE; }
static int GetItemVar(BattleContext *ctx, u16 item, int var) { (void)ctx; (void)item; assert(var == ITEM_VAR_HOLD_EFFECT); return 0; }
static BOOL CheckBattlerAbilityIfNotIgnored(BattleContext *ctx, int attacker, int target, int ability) { (void)attacker; return ctx->battleMons[target].ability == ability; }
static int GetBattlerAbility(BattleContext *ctx, int battlerId) { return ctx->battleMons[battlerId].ability; }
@TABLE@
@FUNCTION@

static void hit(BattleContext *ctx, int attacker, int target, int isCritical) {
    critical = isCritical;
    TryCriticalHit(NULL, ctx, attacker, target, 0, 0);
}

int main(void) {
    BattleContext ctx = { .selectedMonIndex = { 2, 0, 4, 1 } };
    // Two critical hits, a normal one, nothing marked; the third marks the
    // Pokemon's record and puts it with the ones that levelled up.
    hit(&ctx, 0, 1, 1);
    hit(&ctx, 0, 1, 0);
    hit(&ctx, 0, 1, 1);
    assert(parties[0].mons[2].writes == 0 && ctx.levelUpMons == 0);
    hit(&ctx, 0, 1, 1);
    assert(parties[0].mons[2].bits113 == MON_CRITICAL_HITS_EVOLUTION_BIT && ctx.levelUpMons == 1 << 2);
    // The hidden ability bit beside it is kept.
    parties[0].mons[4].bits113 = MON_HIDDEN_ABILITY_BIT;
    for (int i = 0; i < 3; i++) {
        hit(&ctx, 2, 3, 1);
    }
    assert(parties[0].mons[4].bits113 == (MON_HIDDEN_ABILITY_BIT | MON_CRITICAL_HITS_EVOLUTION_BIT));
    assert(ctx.levelUpMons == ((1 << 2) | (1 << 4)));
    // A hit the armour turns away is not a critical hit and is not counted.
    ctx.battleMons[0].criticalHits = 0;
    parties[0].mons[2] = (Pokemon){ 0 };
    ctx.battleMons[1].ability = ABILITY_SHELL_ARMOR;
    for (int i = 0; i < 3; i++) {
        hit(&ctx, 0, 1, 1);
    }
    assert(parties[0].mons[2].writes == 0);
    // The opponent's critical hits mark nothing.
    ctx.battleMons[0].ability = ABILITY_NONE;
    for (int i = 0; i < 3; i++) {
        hit(&ctx, 1, 0, 1);
    }
    assert(parties[1].mons[0].writes == 0 && ctx.battleMons[1].criticalHits == 0);
    return 0;
}
"""


class CriticalHitEvolution(unittest.TestCase):
    def test_the_third_critical_hit_marks_the_player_pokemon(self):
        source = read("src/battle/overlay_12_0224E4FC.c")
        table = re.search(r"static const u8 sCritChance\[\] = \{.*?\};", source, re.S).group()
        program = FIXTURE.replace("@TABLE@", table).replace("@FUNCTION@", function(source, "TryCriticalHit"))
        with tempfile.TemporaryDirectory(prefix="newgold-critical-hits-") as directory:
            path = Path(directory)
            (path / "test.c").write_text(program)
            build = subprocess.run(shlex.split(os.environ.get("CC", "cc")) + [
                "-std=c99", "-Wall", "-Wextra", "-Werror", "-Wno-unused-parameter", "-iquote", str(ROOT / "include"),
                str(path / "test.c"), "-o", str(path / "test"),
            ], capture_output=True, text=True)
            self.assertEqual(build.returncode, 0, build.stderr)
            run = subprocess.run([str(path / "test")], capture_output=True, text=True)
            self.assertEqual(run.returncode, 0, run.stderr)

    def test_the_count_starts_again_with_each_appearance(self):
        # The engine clears critical_hits in ClearBattleMonFlags; here that is
        # where a Pokemon is loaded into its battler.
        body = function(read("src/battle/overlay_12_0224E4FC.c"), "BattleSystem_GetBattleMon")
        self.assertIn("ctx->battleMons[battlerId].criticalHits = 0;", body)


if __name__ == "__main__":
    unittest.main()
