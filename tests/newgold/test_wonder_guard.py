#!/usr/bin/env python3
"""Exercise the actual Wonder Guard helper and both callers' immunity predicates.

The pinned vanilla helper is the reference for effects other than Fire Fang and
Shadow Force. This host check covers C semantics, not DS ABI or ROM execution.
"""

import os
from pathlib import Path
import re
import shlex
import subprocess
import tempfile
import unittest

from test_battle_regressions import ROOT, function


BASELINE = "e97c7fc975a7447f288c42acc2e155f5a673e30f"
SOURCE = "src/battle/overlay_12_0224E4FC.c"
HELPER = "ov12_02258440"

FIXTURE = r"""
#include <assert.h>
#include <stdint.h>
#include "constants/abilities.h"
#include "constants/battle.h"
#include "constants/move_effects.h"

enum { TRUE = 1 };
typedef uint32_t u32;
typedef struct {
    struct { struct { int effect; } moveData[1]; } trainerAIData;
    u32 battleStatus;
    int abilityAttacker, abilityTarget;
} BattleContext;

static int CheckBattlerAbilityIfNotIgnored(BattleContext *ctx, int attacker, int target, int ability) {
    (void)attacker;
    (void)target;
    return ctx->abilityAttacker != ABILITY_MOLD_BREAKER && ctx->abilityTarget == ability;
}

@VANILLA_HELPER@
@HELPER@

static int live_immunity(BattleContext *ctx, u32 flags, u32 movePower) {
    int moveNo = 0, battlerIdAttacker = 0, battlerIdTarget = 1;
    u32 *moveStatusFlag = &flags;
    return @LIVE_PREDICATE@;
}

static int ai_immunity(BattleContext *ctx, u32 flags) {
    int moveNo = 0;
    int abilityAttacker = ctx->abilityAttacker, abilityTarget = ctx->abilityTarget;
    u32 *moveStatusFlag = &flags;
    return @AI_PREDICATE@;
}

int main(void) {
    const u32 phases[] = {0, BATTLE_STATUS_CHARGE_MOVE_HIT,
        ~(u32)BATTLE_STATUS_CHARGE_MOVE_HIT, ~(u32)0};
    const u32 flags[] = {0, MOVE_STATUS_SUPER_EFFECTIVE,
        MOVE_STATUS_NOT_VERY_EFFECTIVE, MOVE_STATUS_ANY_EFFECTIVE};
    BattleContext ctx = {0};

    for (int effect = MOVE_EFFECT_HIT; effect <= MOVE_EFFECT_RAISE_SP_ATK_HIT; effect++) {
        ctx.trainerAIData.moveData[0].effect = effect;
        for (unsigned phase = 0; phase < sizeof(phases) / sizeof(phases[0]); phase++) {
            ctx.battleStatus = phases[phase];
            int active = !!vanilla_ov12_02258440(&ctx, 0);
            if (effect == MOVE_EFFECT_FLINCH_BURN_HIT) {
                active = TRUE;
            } else if (effect == MOVE_EFFECT_SHADOW_FORCE) {
                active = !!(ctx.battleStatus & BATTLE_STATUS_CHARGE_MOVE_HIT);
            }
            assert(!!ov12_02258440(&ctx, 0) == active);

            for (unsigned kind = 0; kind < sizeof(flags) / sizeof(flags[0]); kind++) {
                int blockedType = kind != 1; /* Only a net super-effective move bypasses Wonder Guard. */
                for (int wonderGuard = 0; wonderGuard <= 1; wonderGuard++) {
                    ctx.abilityTarget = wonderGuard ? ABILITY_WONDER_GUARD : ABILITY_NONE;
                    for (int moldBreaker = 0; moldBreaker <= 1; moldBreaker++) {
                        ctx.abilityAttacker = moldBreaker ? ABILITY_MOLD_BREAKER : ABILITY_NONE;
                        int immune = active && blockedType && wonderGuard && !moldBreaker;
                        assert(ai_immunity(&ctx, flags[kind]) == immune);
                        for (u32 power = 0; power <= 1; power++) {
                            assert(live_immunity(&ctx, flags[kind], power) == (immune && power));
                        }
                    }
                }
            }
        }
    }
    return 0;
}
"""


def program(source, vanilla):
    predicates = re.findall(r"    if \(([^\n]*ABILITY_WONDER_GUARD[^\n]*ov12_02258440[^\n]*)\) \{", source)
    if len(predicates) != 2 or not predicates[0].startswith("CheckBattlerAbilityIfNotIgnored") or not predicates[1].startswith("abilityAttacker"):
        raise ValueError("Expected the live and AI Wonder Guard predicates")
    return (FIXTURE.replace("@VANILLA_HELPER@", function(vanilla, HELPER).replace(HELPER, "vanilla_" + HELPER))
            .replace("@HELPER@", function(source, HELPER))
            .replace("@LIVE_PREDICATE@", predicates[0])
            .replace("@AI_PREDICATE@", predicates[1]))


def run_check(source, vanilla):
    with tempfile.TemporaryDirectory(prefix="newgold-wonder-guard-") as directory:
        path = Path(directory)
        (path / "test.c").write_text(program(source, vanilla))
        subprocess.run(shlex.split(os.environ.get("CC", "cc")) + [
            "-std=c99", "-Wall", "-Wextra", "-Werror", "-iquote", str(ROOT / "include"),
            str(path / "test.c"), "-o", str(path / "test"),
        ], check=True)
        return subprocess.run([str(path / "test")], cwd=directory, capture_output=True, text=True)


class WonderGuardRegression(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.vanilla = subprocess.check_output(["git", "show", f"{BASELINE}:{SOURCE}"], cwd=ROOT, text=True)

    def test_all_effects_phases_and_both_immunity_predicates(self):
        result = run_check((ROOT / SOURCE).read_text(), self.vanilla)
        self.assertEqual(result.returncode, 0, result.stderr)

    def test_original_fire_fang_shadow_force_regression_is_detected(self):
        result = run_check(self.vanilla, self.vanilla)
        self.assertNotEqual(result.returncode, 0)
        self.assertIn("ov12_02258440", result.stderr)


if __name__ == "__main__":
    unittest.main()
