#!/usr/bin/env python3
"""How abilities meet the moves, items and field effects around them, where
the later games' rule differs from the reference's (Paolo, 2026-09-23: the
rule is Pokemon Central's page, latest generation)."""

import os
import re
import shlex
import subprocess
import tempfile
import unittest
from pathlib import Path

from test_battle_mechanics import COMMANDS, OVERLAY, subscript
from test_level_cap import ROOT
from test_repels import function


def run_c(program):
    """Build a host program against the port's headers and run it."""
    with tempfile.TemporaryDirectory(prefix="newgold-abilities-") as directory:
        path = Path(directory)
        (path / "test.c").write_text(program)
        subprocess.run(shlex.split(os.environ.get("CC", "cc")) + [
            "-std=c99", "-Wall", "-Werror", "-Wno-unused-function", "-iquote", str(ROOT / "include"),
            str(path / "test.c"), "-o", str(path / "test")], check=True)
        subprocess.run([str(path / "test")], check=True)


def label_body(script, label):
    """The lines of a label up to the next label."""
    start = script.index(f"\n{label}:\n") + len(label) + 3
    end = re.search(r"\n_\w+:\n", script[start:])
    return script[start:start + end.start()] if end else script[start:]


class AbilityStatusSafeguardTests(unittest.TestCase):
    def test_safeguard_stops_what_an_ability_gives(self):
        # Pokemon Central, Salvaguardia: from the fifth generation Safeguard
        # stops Static, Flame Body, Poison Point and Effect Spore, and
        # Synchronize; Poison Touch is the same kind of contact ability.
        for name in ("FallAsleep", "Poison", "Burn", "Paralyze"):
            script = subscript(name)
            jump = re.search(r"SIDE_EFFECT_TYPE_ABILITY, (_\w+)\n    CompareVarToValue OPCODE_FLAG_SET, BSCRIPT_VAR_MOVE_STATUS_FLAGS", script)
            self.assertIsNotNone(jump, name)
            self.assertIn("SIDE_CONDITION_SAFEGUARD", label_body(script, jump.group(1)), name)


class ObliviousTests(unittest.TestCase):
    def test_oblivious_turns_taunt_away(self):
        # Pokemon Central, Indifferenza: from the sixth generation.
        body = function(OVERLAY.read_text(), "BattleContext_CheckMoveImmunityFromAbility")
        self.assertRegex(body, r"moveEffect == MOVE_EFFECT_TAUNT && CheckBattlerAbilityIfNotIgnored\(ctx, battlerIdAttacker, battlerIdTarget, ABILITY_OBLIVIOUS\) == TRUE\) \{\n\s+ctx->battlerIdTemp = battlerIdTarget;\n\s+script = BATTLE_SUBSCRIPT_BLOCKED_BY_ABILITY;")


AS_ONE = r"""
#include <assert.h>
#include <stdint.h>
typedef uint16_t u16;
typedef int BOOL;
enum { FALSE = 0, TRUE = 1 };
#include "constants/abilities.h"
#include "constants/items.h"
typedef struct { int hp, ability, item; } Mon;
typedef struct { Mon battleMons[4]; } BattleContext;
typedef struct { int unused; } BattleSystem;
static int GetBattlerAbility(BattleContext *ctx, int battlerId) { return ctx->battleMons[battlerId].ability; }
static int BattleSystem_GetMaxBattlers(BattleSystem *bs) { (void)bs; return 2; }
static int BattleSystem_GetFieldSide(BattleSystem *bs, int battlerId) { (void)bs; return battlerId & 1; }
@FUNCTIONS@
int main(void) {
    BattleSystem bs = { 0 };
    BattleContext ctx = { { { 10, ABILITY_NONE, ITEM_SITRUS_BERRY }, { 10, ABILITY_NONE, ITEM_NONE } } };
    int boost = 1;
    assert(BerryCanBeEaten(&bs, &ctx, 0, &boost) == TRUE);
    ctx.battleMons[1].ability = ABILITY_UNNERVE;
    assert(BerryCanBeEaten(&bs, &ctx, 0, &boost) == FALSE);
    ctx.battleMons[1].ability = ABILITY_AS_ONE_GLASTRIER;
    assert(BerryCanBeEaten(&bs, &ctx, 0, &boost) == FALSE);
    ctx.battleMons[1].ability = ABILITY_AS_ONE_SPECTRIER;
    assert(BerryCanBeEaten(&bs, &ctx, 0, &boost) == FALSE);
    // Not its own side's, and not once it has fainted.
    assert(BerryCanBeEaten(&bs, &ctx, 1, &boost) == TRUE);
    ctx.battleMons[1].hp = 0;
    assert(BerryCanBeEaten(&bs, &ctx, 0, &boost) == TRUE);
    return 0;
}
"""


class AsOneTests(unittest.TestCase):
    def test_as_one_puts_the_other_side_off_its_berries(self):
        # Pokemon Central, Unisono: Unnerve and a Rider's ability in one.
        source = OVERLAY.read_text()
        functions = "\n".join(function(source, name) for name in ("BattlerHoldsBerry", "BerryCanBeEaten"))
        run_c(AS_ONE.replace("@FUNCTIONS@", functions))


class AnticipationTests(unittest.TestCase):
    def test_anticipation_asks_the_chart_without_the_strong_winds(self):
        # The winds shelter a Flying type from the hit, not from the chart the
        # later games have Anticipation read.
        body = function(OVERLAY.read_text(), "TryAbilityOnEntry")
        start = body.index("case 5: // Anticipation")
        case = body[start:body.index("case 6:", start)]
        ask = case.index("ov12_02251D28(")
        self.assertLess(case.index("ctx->fieldCondition &= ~FIELD_CONDITION_STRONG_WINDS;"), ask)
        self.assertGreater(case.index("ctx->fieldCondition = fieldCondition;"), ask)


SHEER_FORCE = r"""
#include <assert.h>
#include <stdint.h>
typedef uint16_t u16;
typedef uint32_t u32;
typedef int BOOL;
enum { FALSE = 0, TRUE = 1 };
#include "constants/abilities.h"
#include "constants/battle.h"
#include "constants/move_effects.h"
typedef struct { u16 effect; u16 effectChance; } MoveTbl;
typedef struct { u32 sheerForceTraded : 1; } SelfTurnData;
typedef struct { int ability; } Mon;
typedef struct { Mon battleMons[4]; SelfTurnData selfTurnData[4]; int battlerIdAttacker; u32 moveNoCur, unk_2174; } BattleContext;
static MoveTbl move = { 0, 30 };
static const MoveTbl *BattleMoveTbl(BattleContext *ctx, u32 moveNo) { (void)ctx; (void)moveNo; return &move; }
static int GetBattlerAbility(BattleContext *ctx, int battlerId) { return ctx->battleMons[battlerId].ability; }
@FUNCTIONS@
int main(void) {
    BattleContext ctx = { { { ABILITY_SHEER_FORCE } } };
    // A 30% flinch, before the roll: Sheer Force has it.
    ctx.unk_2174 = MOVE_SIDE_EFFECT_TO_DEFENDER;
    assert(SheerForceTradedEffect(&ctx) == TRUE);
    // After the roll the flags are gone; what the roll found is kept.
    ctx.unk_2174 = 0;
    assert(SheerForceTradedEffect(&ctx) == FALSE);
    ctx.selfTurnData[0].sheerForceTraded = TRUE;
    assert(SheerForceTradedEffect(&ctx) == TRUE);
    // Only for Sheer Force.
    ctx.battleMons[0].ability = ABILITY_NONE;
    assert(SheerForceTradedEffect(&ctx) == FALSE);
    return 0;
}
"""


class SheerForceAftermathTests(unittest.TestCase):
    """What answers a hit -- Berserk, Anger Shell, Pickpocket, the Red Card and
    the Eject Button, Emergency Exit -- is asked after the effect roll, which
    clears the flags Sheer Force is read from."""

    def test_what_the_roll_found_is_kept(self):
        source = OVERLAY.read_text()
        functions = "\n".join(function(source, name) for name in ("IsSuppressibleSecondaryEffect", "SheerForceTradedEffect"))
        run_c(SHEER_FORCE.replace("@FUNCTIONS@", functions))
        roll = function(source, "ov12_02250490")
        self.assertLess(roll.index("ctx->selfTurnData[ctx->battlerIdAttacker].sheerForceTraded = TRUE;"), roll.index("ctx->unk_2174 = 0;"))

    def test_the_answers_to_the_hit_ask_what_was_kept(self):
        source = OVERLAY.read_text()
        hit = function(source, "CheckAbilityEffectOnHit")
        for ability in ("BERSERK", "ANGER_SHELL", "PICKPOCKET"):
            case = hit[hit.index(f"case ABILITY_{ability}:"):]
            case = case[:case.index("break;")]
            self.assertIn("!SheerForceTradedEffect(ctx)", case, ability)
            self.assertNotIn("IsSuppressibleSecondaryEffect", case, ability)
        self.assertIn("|| SheerForceTradedEffect(ctx)) {", function(source, "CheckSwitchItemOnHit"))


class OrichalcumPulseTests(unittest.TestCase):
    """Pokemon Central, Ritmo d'Oricalco: the sun on entry, five turns, eight
    with a Heat Rock; the reference's switch-in step and subscript 487."""

    def test_the_entry_brings_the_sun(self):
        header = (ROOT / "include/constants/battle_subscript.h").read_text()
        number = int(re.search(r"#define BATTLE_SUBSCRIPT_ORICHALCUM_PULSE\s+(\d+)", header).group(1))
        script = subscript("OrichalcumPulse")
        self.assertTrue((ROOT / f"files/battledata/script/subscript/subscript_{number:04d}_OrichalcumPulse.s").exists())
        sun = script[:script.index("\n_AlreadySunny:")]
        self.assertIn("UpdateVar OPCODE_FLAG_ON, BSCRIPT_VAR_FIELD_CONDITION, FIELD_CONDITION_SUN\n", sun)
        self.assertIn("UpdateVar OPCODE_SET, BSCRIPT_VAR_WEATHER_TURNS, 5", sun)
        self.assertIn("HOLD_EFFECT_EXTEND_SUN", sun)
        self.assertIn("msg_0197_01695", sun)
        self.assertIn("msg_0197_01698", label_body(script, "_AlreadySunny"))
        entry = function(OVERLAY.read_text(), "TryAbilityOnEntry")
        case = entry[entry.index("case ABILITY_ORICHALCUM_PULSE:"):]
        self.assertIn("script = BATTLE_SUBSCRIPT_ORICHALCUM_PULSE;", case[:case.index("break;")])


class IntimidateTests(unittest.TestCase):
    """Pokemon Central, Prepotenza: from the eighth generation Inner Focus,
    Oblivious, Own Tempo and Scrappy keep it off, and Rattled answers it."""

    def test_the_four_abilities_keep_it_off(self):
        source = COMMANDS.read_text()
        helper = function(source, "AbilityShrugsOffIntimidate")
        for ability in ("INNER_FOCUS", "OBLIVIOUS", "OWN_TEMPO", "SCRAPPY"):
            self.assertIn(f"ABILITY_{ability}) == TRUE", helper)
        change = function(source, "BtlCmd_ChangeStatStage")
        branch = change[change.index("ABILITY_HYPER_CUTTER"):]
        branch = branch[:branch.index("{")]
        self.assertIn("(ctx->statChangeType == SIDE_EFFECT_TYPE_ABILITY && (1 + stat) == STAT_ATK && AbilityShrugsOffIntimidate(ctx) == TRUE)", branch)


if __name__ == "__main__":
    unittest.main()
