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
from test_retreat_abilities import CONTROLLER
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
#include "constants/moves.h"
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
        for ability in ("BERSERK", "ANGER_SHELL", "COLOR_CHANGE"):
            case = hit[hit.index(f"case ABILITY_{ability}:"):]
            case = case[:case.index("break;")]
            self.assertIn("!SheerForceTradedEffect(ctx)", case, ability)
            self.assertNotIn("IsSuppressibleSecondaryEffect", case, ability)
        self.assertIn("|| SheerForceTradedEffect(ctx)\n", function(source, "PickpocketLifts"))
        self.assertIn("|| SheerForceTradedEffect(ctx)) {", function(source, "SwitchItemAnswersHit"))

    def test_the_kee_and_maranga_berries_ask_it(self):
        # Pokemon Central, Forzabruta: Baccalighia and Baccapane.
        hit = function(OVERLAY.read_text(), "CheckItemEffectOnHit")
        self.assertIn("ItemRaisesStatOnHit(ctx, physical && !SheerForceTradedEffect(ctx), STAT_DEF, script)", hit)
        self.assertIn("ItemRaisesStatOnHit(ctx, special && !SheerForceTradedEffect(ctx), STAT_SPDEF, script)", hit)

    def test_the_users_shell_bell_and_life_orb_ask_it_too(self):
        # Pokemon Central, Forzabruta: neither answers a boosted move.
        body = function(CONTROLLER.read_text(), "ov12_0224E1BC")
        for item in ("HOLD_EFFECT_HP_RESTORE_ON_DMG", "HOLD_EFFECT_HP_DRAIN_ON_ATK"):
            condition = body[body.index(f"item == {item}"):]
            self.assertIn("&& !SheerForceTradedEffect(ctx)", condition[:condition.index("{")], item)


MAGICIAN = r"""
#include <assert.h>
#include <stdint.h>
typedef uint8_t u8;
typedef uint16_t u16;
typedef uint32_t u32;
typedef int BOOL;
enum { FALSE = 0, TRUE = 1 };
#include "constants/abilities.h"
#include "constants/battle.h"
#include "constants/battle_subscript.h"
#include "constants/moves.h"
typedef struct { int maxBattlers; } BattleSystem;
typedef struct { u16 category; } MoveTbl;
typedef struct { int physicalDamage, specialDamage; } SelfTurnData;
typedef struct { int ability, hp, item, substitute, cameIn; } Mon;
typedef struct {
    Mon battleMons[4]; SelfTurnData selfTurnData[4]; u8 turnOrder[4];
    int battlerIdAttacker, battlerIdStatChange, battlerIdTemp;
    u32 moveNoCur, battleStatus, battleStatus2; u8 gemBoostingMove;
} BattleContext;
static MoveTbl move;
static const MoveTbl *BattleMoveTbl(BattleContext *ctx, u32 moveNo) { (void)ctx; (void)moveNo; return &move; }
static int GetBattlerAbility(BattleContext *ctx, int battlerId) { return ctx->battleMons[battlerId].ability; }
static int BattleSystem_GetMaxBattlers(BattleSystem *battleSystem) { return battleSystem->maxBattlers; }
static int BattleSystem_GetFieldSide(BattleSystem *battleSystem, int battlerId) { (void)battleSystem; return battlerId & 1; }
static BOOL BattlerCheckSubstitute(BattleContext *ctx, int battlerId) { return ctx->battleMons[battlerId].substitute; }
static BOOL Battler_CameInAfterTheHit(BattleContext *ctx, int battlerId) { return ctx->battleMons[battlerId].cameIn; }
static BOOL wild[4];
static BOOL Battler_IsWild(BattleSystem *battleSystem, int battlerId) { (void)battleSystem; return wild[battlerId]; }
static BOOL CanAbilityTakeHeldItem(BattleSystem *battleSystem, BattleContext *ctx, int taker, int loser) {
    (void)battleSystem;
    return !ctx->battleMons[taker].item && ctx->battleMons[loser].item;
}
@FUNCTIONS@
static BattleSystem bs = { 4 };
static BattleContext ctx;
static void reset(void) {
    // A double battle: the user 0 and its ally 2 against 1 and 3; the ally
    // is the fastest, then 3, the user, 1. Everybody was hit and holds an
    // item but the user.
    static const u8 order[4] = { 2, 3, 0, 1 };
    for (int i = 0; i < 4; i++) {
        ctx.battleMons[i] = (Mon){ ABILITY_NONE, 100, 1, FALSE, FALSE };
        ctx.selfTurnData[i] = (SelfTurnData){ 10, 0 };
        ctx.turnOrder[i] = order[i];
    }
    ctx.battleMons[0] = (Mon){ ABILITY_MAGICIAN, 100, 0, FALSE, FALSE };
    for (int i = 0; i < 4; i++) {
        wild[i] = FALSE;
    }
    ctx.selfTurnData[0] = (SelfTurnData){ 0, 0 };
    ctx.battlerIdAttacker = 0; ctx.battleStatus = 0; ctx.battleStatus2 = 0; ctx.gemBoostingMove = FALSE;
    ctx.battlerIdTemp = ctx.battlerIdStatChange = 0xFF;
    move.category = CATEGORY_PHYSICAL;
}
static int takes(void) {
    int script = 0;
    if (TryMagician(&bs, &ctx, &script) == FALSE) {
        return -1;
    }
    assert(script == BATTLE_SUBSCRIPT_ABILITY_TAKES_ITEM && ctx.battlerIdStatChange == 0);
    return ctx.battlerIdTemp;
}
int main(void) {
    // The fastest foe first, the ally last.
    reset(); assert(takes() == 3);
    reset(); ctx.battleMons[3].ability = ABILITY_STICKY_HOLD; assert(takes() == 1);
    reset(); ctx.battleMons[3].ability = ABILITY_STICKY_HOLD; ctx.battleMons[3].hp = 0; assert(takes() == 3);
    reset(); ctx.battleMons[3].substitute = TRUE; ctx.selfTurnData[1].physicalDamage = 0; assert(takes() == 2);
    reset(); ctx.battleMons[3].cameIn = TRUE; ctx.battleMons[1].item = 0; assert(takes() == 2);
    reset(); ctx.selfTurnData[1].physicalDamage = 0; ctx.selfTurnData[3].physicalDamage = 0;
    ctx.selfTurnData[2].physicalDamage = 0; ctx.selfTurnData[2].specialDamage = 10; assert(takes() == 2);
    // Nothing for a user that fainted, left, holds something, used a status
    // move, is charging, or had a Gem power the move; nor without the ability.
    reset(); ctx.battleMons[0].hp = 0; assert(takes() == -1);
    reset(); ctx.battleStatus2 = BATTLE_STATUS2_UTURN; assert(takes() == -1);
    reset(); ctx.battleMons[0].item = 1; assert(takes() == -1);
    reset(); move.category = CATEGORY_STATUS; assert(takes() == -1);
    reset(); ctx.battleStatus = BATTLE_STATUS_CHARGE_TURN; assert(takes() == -1);
    reset(); ctx.gemBoostingMove = TRUE; assert(takes() == -1);
    reset(); ctx.battleMons[0].ability = ABILITY_PICKPOCKET; assert(takes() == -1);
    // A wild Pokemon's Magician takes nothing; the player's takes from a
    // wild one (Pokemon Central, Prestigiatore).
    reset(); wild[0] = TRUE; assert(takes() == -1);
    reset(); wild[3] = TRUE; assert(takes() == 3);
    return 0;
}
"""


class MagicianTests(unittest.TestCase):
    """Pokemon Central, Prestigiatore; the engine's Magician step,
    ServerDoPostMoveEffects.c:1556 at d0380a487."""

    def test_what_it_takes_and_from_whom(self):
        run_c(MAGICIAN.replace("@FUNCTIONS@", function(OVERLAY.read_text(), "TryMagician")))

    def test_it_takes_once_the_move_is_over(self):
        # After the move's own taking (Thief, Covet, Knock Off), before a Red
        # Card or an Eject Button answers the hit; no longer one of the answers
        # to each hit.
        body = function(CONTROLLER.read_text(), "ov12_0224E1BC")
        self.assertLess(body.index("TryAdditionalMoveEffect(ctx)"), body.index("TryMagician(battleSystem, ctx, &script)"))
        self.assertLess(body.index("TryMagician(battleSystem, ctx, &script)"), body.index("CheckSwitchItemOnHit"))
        self.assertNotIn("ABILITY_MAGICIAN", function(OVERLAY.read_text(), "CheckAbilityEffectOnHit"))


PICKPOCKET = r"""
#include <assert.h>
#include <stdint.h>
typedef uint8_t u8;
typedef uint16_t u16;
typedef uint32_t u32;
typedef int BOOL;
enum { FALSE = 0, TRUE = 1 };
#include "constants/abilities.h"
#include "constants/battle.h"
#include "constants/battle_subscript.h"
#include "constants/items.h"
typedef struct { int maxBattlers; } BattleSystem;
typedef struct { u16 power; } MoveTbl;
typedef struct { int physicalDamage, specialDamage; } SelfTurnData;
typedef struct { int ability, hp, item, substitute, cameIn; } Mon;
typedef struct {
    Mon battleMons[4]; SelfTurnData selfTurnData[4]; u8 turnOrder[4];
    int battlerIdAttacker, battlerIdStatChange, battlerIdTemp;
    u32 moveNoCur, battleStatus, battleStatus2;
} BattleContext;
static MoveTbl move;
static BOOL contact, sheerForce;
static const MoveTbl *BattleMoveTbl(BattleContext *ctx, u32 moveNo) { (void)ctx; (void)moveNo; return &move; }
static BOOL BattleMoveMakesContact(BattleContext *ctx, u32 moveNo) { (void)ctx; (void)moveNo; return contact; }
static BOOL SheerForceTradedEffect(BattleContext *ctx) { (void)ctx; return sheerForce; }
static int GetBattlerAbility(BattleContext *ctx, int battlerId) { return ctx->battleMons[battlerId].ability; }
static int BattleSystem_GetMaxBattlers(BattleSystem *battleSystem) { return battleSystem->maxBattlers; }
static BOOL BattlerCheckSubstitute(BattleContext *ctx, int battlerId) { return ctx->battleMons[battlerId].substitute; }
static BOOL Battler_CameInAfterTheHit(BattleContext *ctx, int battlerId) { return ctx->battleMons[battlerId].cameIn; }
static BOOL wild[4];
static BOOL Battler_IsWild(BattleSystem *battleSystem, int battlerId) { (void)battleSystem; return wild[battlerId]; }
static BOOL CanStealHeldItem(BattleSystem *battleSystem, BattleContext *ctx, int taker, int loser) {
    (void)battleSystem; (void)taker;
    return ctx->battleMons[loser].item != 0;
}
@FUNCTIONS@
static BattleSystem bs = { 4 };
static BattleContext ctx;
static void reset(void) {
    // The user 0 holds an item and touched 1 and 3, who both have
    // Pickpocket and empty hands; 3 is faster.
    static const u8 order[4] = { 2, 3, 0, 1 };
    for (int i = 0; i < 4; i++) {
        ctx.battleMons[i] = (Mon){ i & 1 ? ABILITY_PICKPOCKET : ABILITY_NONE, 100, 0, FALSE, FALSE };
        ctx.selfTurnData[i] = (SelfTurnData){ i & 1 ? 10 : 0, 0 };
        ctx.turnOrder[i] = order[i];
    }
    ctx.battleMons[0].item = 1;
    for (int i = 0; i < 4; i++) {
        wild[i] = FALSE;
    }
    ctx.battlerIdAttacker = 0; ctx.battleStatus = 0; ctx.battleStatus2 = 0;
    ctx.battlerIdTemp = ctx.battlerIdStatChange = 0xFF;
    move.power = 80; contact = TRUE; sheerForce = FALSE;
}
static int lifts(void) {
    int script = 0;
    if (TryPickpocket(&bs, &ctx, &script) == FALSE) {
        return -1;
    }
    assert(script == BATTLE_SUBSCRIPT_ABILITY_TAKES_ITEM && ctx.battlerIdTemp == 0);
    return ctx.battlerIdStatChange;
}
int main(void) {
    reset(); assert(lifts() == 3);
    reset(); ctx.battleMons[3].hp = 0; assert(lifts() == 1);
    reset(); ctx.battleMons[3].item = 1; assert(lifts() == 1);
    reset(); ctx.battleMons[3].substitute = TRUE; assert(lifts() == 1);
    reset(); ctx.battleMons[3].cameIn = TRUE; assert(lifts() == 1);
    reset(); ctx.selfTurnData[3].physicalDamage = 0; ctx.selfTurnData[1].physicalDamage = 0; assert(lifts() == -1);
    reset(); ctx.battleMons[1].ability = ctx.battleMons[3].ability = ABILITY_NONE; assert(lifts() == -1);
    reset(); ctx.battleMons[0].item = 0; assert(lifts() == -1);
    reset(); contact = FALSE; assert(lifts() == -1);
    reset(); move.power = 0; assert(lifts() == -1);
    reset(); sheerForce = TRUE; assert(lifts() == -1);
    reset(); ctx.battleStatus2 = BATTLE_STATUS2_UTURN; assert(lifts() == -1);
    reset(); ctx.battleStatus = BATTLE_STATUS_CHARGE_TURN; assert(lifts() == -1);
    // The user's own Pickpocket takes nothing from itself.
    reset(); ctx.battleMons[1].ability = ctx.battleMons[3].ability = ABILITY_NONE;
    ctx.battleMons[0].ability = ABILITY_PICKPOCKET; ctx.selfTurnData[0].physicalDamage = 10; assert(lifts() == -1);
    // Nothing from a user that holds on with Sticky Hold, unless it has
    // fainted (Pokemon Central, Arraffalesto).
    reset(); ctx.battleMons[0].ability = ABILITY_STICKY_HOLD; assert(lifts() == -1);
    reset(); ctx.battleMons[0].ability = ABILITY_STICKY_HOLD; ctx.battleMons[0].hp = 0; assert(lifts() == 3);
    // A wild Pokemon's Pickpocket takes nothing (Pokemon Central, Arraffalesto).
    reset(); wild[3] = TRUE; assert(lifts() == 1);
    reset(); wild[1] = wild[3] = TRUE; assert(lifts() == -1);
    // A Red Card's holder is asked whatever it holds: the card is spent as
    // it lifts (CheckSwitchItemOnHit).
    reset(); ctx.battleMons[3].item = 1; assert(PickpocketLifts(&bs, &ctx, 3) && !PickpocketLifts(&bs, &ctx, 2));
    return 0;
}
"""


class PickpocketTests(unittest.TestCase):
    """Pokemon Central, Arraffalesto; the engine's Activate_Pickpocket,
    ServerDoPostMoveEffects.c:1993 at d0380a487."""

    def test_who_lifts_what(self):
        source = OVERLAY.read_text()
        run_c(PICKPOCKET.replace("@FUNCTIONS@", function(source, "PickpocketLifts") + function(source, "TryPickpocket")))

    def test_it_lifts_once_the_move_is_over(self):
        # After Magician, the Red Card and the Eject Button and the user's
        # switch, before the user's Throat Spray and Eject Pack; no longer one
        # of the answers to each hit.
        body = function(CONTROLLER.read_text(), "ov12_0224E1BC")
        pickpocket = body.index("TryPickpocket(battleSystem, ctx, &script)")
        for before in ("TryMagician(battleSystem, ctx, &script)", "CheckSwitchItemOnHit", "BATTLE_SUBSCRIPT_HANDLE_PARTING_SHOT"):
            self.assertLess(body.index(before), pickpocket, before)
        for after in ("HOLD_EFFECT_BOOST_SPATK_ON_SOUND_MOVE", "CheckEjectPack"):
            self.assertLess(pickpocket, body.index(after), after)
        self.assertNotIn("ABILITY_PICKPOCKET", function(OVERLAY.read_text(), "CheckAbilityEffectOnHit"))


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

    def test_rattled_answers_a_drop_that_happened(self):
        script = subscript("Intimidate")
        change = label_body(script, "_CHANGE")
        self.assertIn("BMON_DATA_STAT_CHANGE_ATK, BSCRIPT_VAR_CALC_TEMP", change)
        self.assertIn("GoTo _RATTLED", change)
        rattled = label_body(script, "_RATTLED")
        self.assertIn("CheckAbility CHECK_OPCODE_NOT_HAVE, BATTLER_CATEGORY_SIDE_EFFECT_MON, ABILITY_RATTLED, _038", rattled)
        self.assertIn("CompareMonDataToVar OPCODE_EQU, BATTLER_CATEGORY_SIDE_EFFECT_MON, BMON_DATA_STAT_CHANGE_ATK, BSCRIPT_VAR_CALC_TEMP, _038", rattled)
        self.assertIn("MOVE_SUBSCRIPT_PTR_SPEED_UP_1_STAGE", rattled)
        # The Adrenaline Orb's path falls into it.
        self.assertLess(script.index("Call BATTLE_SUBSCRIPT_ADRENALINE_ORB"), script.index("\n_RATTLED:"))


FLAG_NAMES = {"failsTrace": "ABILITY_FLAG_FAILS_TRACE", "failsSwap": "ABILITY_FLAG_FAILS_SWAP",
              "failsSuppress": "ABILITY_FLAG_FAILS_SUPPRESS", "failsReceiver": "ABILITY_FLAG_FAILS_RECEIVER",
              "failsEntrainment": "ABILITY_FLAG_FAILS_ENTRAINMENT", "failsRolePlay": "ABILITY_FLAG_FAILS_ROLE_PLAY"}

# What this port adds to the reference's flags, from Pokemon Central: the
# three Saltamicizia names on the user's side.
ADDED_FLAGS = {ability: {"ABILITY_FLAG_FAILS_ENTRAINMENT"}
               for ability in ("ABILITY_GULP_MISSILE", "ABILITY_ORICHALCUM_PULSE", "ABILITY_HADRON_ENGINE")}


def ability_flag_table():
    """The port's sAbilityFlags as {ability: {flag, ...}}."""
    source = OVERLAY.read_text()
    table = source[source.index("static const u8 sAbilityFlags[] = {"):]
    table = table[:table.index("};")]
    return {m.group(1): set(m.group(2).split(" | ")) for m in re.finditer(r"\[(ABILITY_\w+)\] = ([^,]+),", table)}


class AbilityCopyTableTests(unittest.TestCase):
    """The effects that copy, give or swap an ability ask one table, the
    reference's data/AbilityFlags.c."""

    def test_the_table_is_the_reference_s(self):
        from test_repels import REFERENCE, revision
        if REFERENCE is None:
            self.skipTest("no reference checkout")
        theirs = {}
        for m in re.finditer(r"\[(ABILITY_\w+)\] = \{([^}]*)\}", revision(REFERENCE, "d0380a487", "data/AbilityFlags.c")):
            flags = {name for field, name in FLAG_NAMES.items() if f"{field} = TRUE" in m.group(2)}
            if flags:
                theirs[m.group(1)] = flags
        for ability, flags in ADDED_FLAGS.items():
            theirs[ability] = theirs.get(ability, set()) | flags
        self.assertEqual(ability_flag_table(), theirs)

    def test_every_copier_asks_it(self):
        source = OVERLAY.read_text()
        self.assertIn("case BMON_DATA_ABILITY_FLAGS:\n        return AbilityFlags(mon->ability);", function(source, "GetBattlerVar"))
        self.assertIn("ABILITY_FLAG_FAILS_TRACE", function(source, "Battler_Traceable"))
        self.assertEqual(function(source, "ov12_022585B8").count("Battler_Traceable("), 4)
        hit = function(source, "CheckAbilityEffectOnHit")
        wandering = hit[hit.index("case ABILITY_WANDERING_SPIRIT:"):]
        self.assertIn("AbilityFlags(ctx->battleMons[ctx->battlerIdAttacker].ability) & ABILITY_FLAG_FAILS_SWAP", wandering[:wandering.index("break;")])
        mummy = hit[hit.index("case ABILITY_MUMMY:"):]
        self.assertIn("AbilityFlags(ctx->battleMons[ctx->battlerIdAttacker].ability) & ABILITY_FLAG_FAILS_SUPPRESS", mummy[:mummy.index("break;")])
        self.assertIn("WrappingRefuses(GetBattlerAbility(ctx, ctx->battlerIdTarget), ctx->battleMons[ctx->battlerIdAttacker].ability) == FALSE", mummy[:mummy.index("break;")])
        scripts = ROOT / "files/battledata/script"
        asked = {
            "effect_script/effect_script_0178.s": [("ATTACKER", "FAILS_SUPPRESS")],
            "subscript/subscript_0135_CopyAbility.s": [("DEFENDER", "FAILS_ROLE_PLAY")],
            "subscript/subscript_0143_SwapAbility.s": [("ATTACKER", "FAILS_SWAP"), ("DEFENDER", "FAILS_SWAP")],
            "subscript/subscript_0316_Entrainment.s": [("ATTACKER", "FAILS_ENTRAINMENT"), ("DEFENDER", "FAILS_SUPPRESS")],
        }
        for name, questions in asked.items():
            text = (scripts / name).read_text()
            for battler, flag in questions:
                self.assertIn(f"CompareMonDataToValue OPCODE_FLAG_SET, BATTLER_CATEGORY_{battler}, BMON_DATA_ABILITY_FLAGS, ABILITY_FLAG_{flag}, _", text, name)
            # No list of its own beside it.
            self.assertNotRegex(text, r"BMON_DATA_ABILITY, ABILITY_(?!NONE|TRUANT)\w+, _", name)
        entrainment = (scripts / "subscript/subscript_0316_Entrainment.s").read_text()
        self.assertIn("CompareMonDataToValue OPCODE_EQU, BATTLER_CATEGORY_DEFENDER, BMON_DATA_ABILITY, ABILITY_TRUANT, _FAILED", entrainment)
        self.assertIn("CompareMonDataToVar OPCODE_EQU, BATTLER_CATEGORY_DEFENDER, BMON_DATA_ABILITY, BSCRIPT_VAR_CALC_TEMP, _FAILED", entrainment)
        self.assertLess(entrainment.index("_FAILED\n    Call BATTLE_SUBSCRIPT_ATTACK_MESSAGE_AND_ANIMATION"), entrainment.index("BMON_DATA_ABILITY, BSCRIPT_VAR_CALC_TEMP\n    // {0} acquired"))


class EndOfTurnEntryAbilityTests(unittest.TestCase):
    """Opportunist and Symbiosis act from the entry abilities' check after a
    move or an entry, and from each of the turn's end steps between one effect
    and the next; the end of a turn also reaches the entry check before the
    next turn's choices: TurnEnd sets the trainer's message, which sets the
    send-out, which is PokemonAppear."""

    def test_the_turn_s_end_asks_the_entry_abilities(self):
        controller = CONTROLLER.read_text()
        self.assertIn("[CONTROLLER_COMMAND_TRAINER_MESSAGE] = BattleControllerPlayer_TrainerMessage,", controller)
        self.assertIn("[CONTROLLER_COMMAND_SEND_OUT] = BattleControllerPlayer_PokemonAppear,", controller)
        turn_end = function(controller, "BattleControllerPlayer_TurnEnd")
        self.assertTrue(turn_end.rstrip("}\n ").endswith("ctx->command = CONTROLLER_COMMAND_TRAINER_MESSAGE;"))
        message = function(controller, "BattleControllerPlayer_TrainerMessage")
        self.assertEqual(message.count("CONTROLLER_COMMAND_SEND_OUT;"), 2)
        appear = function(controller, "BattleControllerPlayer_PokemonAppear")
        self.assertLess(appear.index("TryAbilityOnEntry(battleSystem, ctx)"), appear.index("CONTROLLER_COMMAND_SELECTION_SCREEN_INIT"))
        # What they act on is kept across the turn's end, and cleared only
        # when a Pokemon is loaded into the slot.
        overlay = OVERLAY.read_text()
        for name in ("BattleContext_Init", "ov12_02251710"):
            body = function(overlay, name)
            self.assertNotIn("opportunistStages", body, name)
            self.assertNotIn("symbiosisPending", body, name)
        entry = function(overlay, "TryAbilityOnEntry")
        self.assertIn("case 33: // Opportunist", entry)
        self.assertIn("case 34: // Symbiosis", entry)

    def test_the_turn_s_end_steps_ask_them_at_once(self):
        # Between one end-of-turn effect and the next, not after the turn's
        # end: each step asks, when it is entered again after a script,
        # before it goes on to its next effect.
        controller = CONTROLLER.read_text()
        answers = function(controller, "TryEndOfTurnAnswers")
        self.assertIn("int script = TryOpportunistOrSymbiosis(battleSystem, ctx);", answers)
        self.assertIn("ctx->commandNext = ctx->command;\n    ctx->command = CONTROLLER_COMMAND_RUN_SCRIPT;", answers)
        for name, before in (("BattleControllerPlayer_UpdateFieldCondition", "switch (ctx->stateFieldConditionUpdate) {"),
                             ("BattleControllerPlayer_UpdateMonCondition", "while (ctx->updateMonConditionData < maxBattlers) {"),
                             ("BattleControllerPlayer_UpdateFieldConditionExtra", "switch (ctx->stateUpdateFieldConditionExtra) {")):
            body = function(controller, name)
            self.assertLess(body.index("if (TryEndOfTurnAnswers(battleSystem, ctx) == TRUE) {\n"), body.index(before), name)
            self.assertLess(body.index("TryFaintMon("), body.index("TryEndOfTurnAnswers("), name)
        both = function(OVERLAY.read_text(), "TryOpportunistOrSymbiosis")
        self.assertLess(both.index("TryOpportunistCopy(battleSystem, ctx, &script)"), both.index("TrySymbiosisHandOver(battleSystem, ctx, &script)"))


class PivotRetreatTests(unittest.TestCase):
    """U-turn does not take its user out when its target leaves by Emergency
    Exit or Wimp Out; a Berry that heals the target back above half keeps the
    target in, and so the user goes (Pokemon Central, Passoindietro)."""

    def test_the_switch_waits_for_the_retreat(self):
        # The target's Berry comes with the hit's other held items
        # (ov12_0224CC88), the retreat once the move is over, and the switch
        # last, for a target still the one it hit.
        body = function(CONTROLLER.read_text(), "ov12_0224E1BC")
        self.assertLess(body.index("TryRetreatAbility(battleSystem, ctx, &script)"), body.index("TryPivotSwitch(ctx)"))
        self.assertIn("Battler_CameInAfterTheHit(ctx, target)", function(CONTROLLER.read_text(), "PivotSwitchPending"))
        self.assertIn("TryUseHeldItem(battleSystem, ctx, ctx->battlerIdTarget)", function(CONTROLLER.read_text(), "ov12_0224CC88"))


RETREAT_OUTSIDE_MOVE = r"""
#include <assert.h>
#include <stdint.h>
typedef uint32_t u32;
typedef int BOOL;
enum { FALSE = 0, TRUE = 1 };
#include "constants/abilities.h"
#include "constants/battle.h"
#include "constants/battle_subscript.h"
typedef struct { u32 battleType; BOOL canSwitch[4]; } BattleSystem;
typedef struct { int hp; u32 maxHp; int ability; } Mon;
typedef struct { u32 retreatArmedOutsideMove : 1; } SelfTurnData;
typedef struct { Mon battleMons[4]; SelfTurnData selfTurnData[4]; int battlerIdTemp, tempData; int turnOrder[4]; } BattleContext;
static int GetBattlerAbility(BattleContext *ctx, int battlerId) { return ctx->battleMons[battlerId].ability; }
static u32 BattleSystem_GetBattleType(BattleSystem *bs) { return bs->battleType; }
static int BattleSystem_GetFieldSide(BattleSystem *bs, int battlerId) { (void)bs; return battlerId & 1; }
static int BattleSystem_GetMaxBattlers(BattleSystem *bs) { (void)bs; return 2; }
static BOOL CanSwitchMon(BattleSystem *bs, BattleContext *ctx, int battlerId) { (void)ctx; return bs->canSwitch[battlerId]; }
@FUNCTIONS@
static BattleSystem bs;
static BattleContext ctx;
static void setup(int ability, int hp) {
    BattleContext blank = { 0 };
    ctx = blank;
    bs.battleType = BATTLE_TYPE_TRAINER;
    bs.canSwitch[0] = bs.canSwitch[1] = TRUE;
    ctx.turnOrder[0] = 0;
    ctx.turnOrder[1] = 1;
    ctx.battleMons[0].hp = ctx.battleMons[0].maxHp = 100;
    ctx.battleMons[1].maxHp = 100;
    ctx.battleMons[1].hp = hp;
    ctx.battleMons[1].ability = ability;
}
static void hurt(int damage) {
    Battler_ArmRetreatOutsideMove(&ctx, 1);
    ctx.battleMons[1].hp -= damage;
}
static int leaves(void) {
    int script = -1;
    if (!TryRetreatAbilityOutsideMove(&bs, &ctx, &script)) {
        return -1;
    }
    assert(script == BATTLE_SUBSCRIPT_EMERGENCY_EXIT && ctx.battlerIdTemp == 1);
    return ctx.tempData;
}
int main(void) {
    // Stealth Rock from above half to half: it leaves, once.
    setup(ABILITY_EMERGENCY_EXIT, 60);
    hurt(10);
    assert(leaves() == 0);
    assert(leaves() == -1);
    setup(ABILITY_WIMP_OUT, 60);
    hurt(12);
    assert(leaves() == 0);
    // Not past half; already at half; another ability; nobody to send.
    setup(ABILITY_EMERGENCY_EXIT, 80);
    hurt(12);
    assert(leaves() == -1);
    setup(ABILITY_EMERGENCY_EXIT, 50);
    hurt(6);
    assert(leaves() == -1);
    setup(ABILITY_BERSERK, 60);
    hurt(12);
    assert(leaves() == -1);
    setup(ABILITY_EMERGENCY_EXIT, 60);
    bs.canSwitch[1] = FALSE;
    hurt(12);
    assert(leaves() == -1);
    // A mark that does not send it off is kept for a later ask.
    setup(ABILITY_EMERGENCY_EXIT, 80);
    hurt(12);
    assert(leaves() == -1);
    ctx.battleMons[1].hp -= 20;
    assert(leaves() == 0);
    return 0;
}
"""


class RetreatOutsideMoveTests(unittest.TestCase):
    """Emergency Exit and Wimp Out answer damage from outside a move too
    (Pokemon Central, Passoindietro)."""

    def test_the_mark_and_the_ask(self):
        source = OVERLAY.read_text()
        functions = "\n".join(function(source, name) for name in (
            "Battler_IsWild", "Battler_ArmRetreatOutsideMove", "TryRetreatAbilityOutsideMove"))
        run_c(RETREAT_OUTSIDE_MOVE.replace("@FUNCTIONS@", functions))

    def test_the_entry_hazards_mark_it(self):
        source = COMMANDS.read_text()
        for name in ("BtlCmd_CheckSpikes", "BtlCmd_CheckStealthRock"):
            body = function(source, name)
            self.assertLess(body.index("DamageDivide(ctx->battleMons[battlerId].maxHp * -1"), body.index("Battler_ArmRetreatOutsideMove(ctx, battlerId);"), name)

    def test_the_end_of_an_action_and_of_a_turn_ask(self):
        controller = CONTROLLER.read_text()
        action = function(controller, "ov12_0224D368")
        self.assertLess(action.index("TryAbilityOnEntry(battleSystem, ctx)"), action.index("TryRetreatAbilityOutsideMove(battleSystem, ctx, &script)"))
        self.assertLess(action.index("TryRetreatAbilityOutsideMove"), action.index("BattleContext_Init(ctx);"))
        turn_end = function(controller, "BattleControllerPlayer_TurnEnd")
        self.assertLess(turn_end.index("ov12_0224D540(battleSystem, ctx)"), turn_end.index("TryRetreatAbilityOutsideMove(battleSystem, ctx, &script)"))
        self.assertLess(turn_end.index("TryRetreatAbilityOutsideMove"), turn_end.index("BattleContext_Init(ctx);"))

    def test_the_user_is_armed_with_its_hit(self):
        # Its recoil, its Life Orb and the other side's Rocky Helmet come
        # before the ask at the end of the move.
        hp_calc = function(CONTROLLER.read_text(), "BattleControllerPlayer_HpCalc")
        target = hp_calc.index("Battler_ArmRetreat(ctx, ctx->battlerIdTarget);")
        self.assertLess(target, hp_calc.index("Battler_ArmRetreat(ctx, ctx->battlerIdAttacker);"))
        self.assertLess(hp_calc.index("Battler_ArmRetreat(ctx, ctx->battlerIdAttacker);"), hp_calc.index("BATTLE_SUBSCRIPT_UPDATE_HP"))

    def test_the_turn_s_end_arms_every_holder(self):
        # Before the first of the turn's end effects, and what comes in to a
        # slot does not keep the mark.
        order = function(CONTROLLER.read_text(), "ov12_02249460")
        arm = order.index("Battler_ArmRetreatOutsideMove(ctx, battlerId);")
        self.assertLess(order.rindex("if (ctx->executionIndex == maxBattlers) {", 0, arm), arm)
        self.assertLess(arm, order.index("ctx->command = CONTROLLER_COMMAND_UPDATE_FIELD_CONDITION;"))
        self.assertIn("ctx->selfTurnData[battlerId].retreatArmedOutsideMove = FALSE;", function(OVERLAY.read_text(), "InitSwitchWork"))


class ReceiverTests(unittest.TestCase):
    """Receiver and Power of Alchemy take over a fallen ally's ability, but not
    one the ability table keeps from them (Pokemon Central, Ricezione)."""

    def test_a_faint_hands_the_ability_to_the_ally(self):
        header = (ROOT / "include/constants/battle_subscript.h").read_text()
        number = int(re.search(r"#define BATTLE_SUBSCRIPT_RECEIVER\s+(\d+)", header).group(1))
        self.assertTrue((ROOT / f"files/battledata/script/subscript/subscript_{number:04d}_Receiver.s").exists())
        faint = subscript("FaintMon")
        self.assertLess(faint.index("Call BATTLE_SUBSCRIPT_SOUL_HEART"), faint.index("Call BATTLE_SUBSCRIPT_RECEIVER"))
        script = subscript("Receiver")
        ally = "BATTLER_RELATIVE_ALLY|BATTLER_CATEGORY_FAINTED_MON"
        self.assertIn(f"CompareMonDataToValue OPCODE_EQU, {ally}, BMON_DATA_HP, 0, _END", script)
        for ability in ("RECEIVER", "POWER_OF_ALCHEMY"):
            self.assertIn(f"CheckAbility CHECK_OPCODE_HAVE, {ally}, ABILITY_{ability}, _TAKE_OVER", script)
        take = label_body(script, "_TAKE_OVER")
        refusal = take.index("BMON_DATA_ABILITY_FLAGS, ABILITY_FLAG_FAILS_RECEIVER, _END")
        self.assertLess(refusal, take.index(f"UpdateMonDataFromVar OPCODE_SET, {ally}, BMON_DATA_ABILITY, BSCRIPT_VAR_CALC_TEMP"))


WRAPPING = r"""
#include <assert.h>
#include <stdint.h>
typedef uint16_t u16;
typedef int BOOL;
enum { FALSE = 0, TRUE = 1 };
#include "constants/abilities.h"
@FUNCTION@
int main(void) {
    // Pokemon Central's Mummia and Odore Tenace.
    assert(WrappingRefuses(ABILITY_MUMMY, ABILITY_COMMANDER) && WrappingRefuses(ABILITY_LINGERING_AROMA, ABILITY_COMMANDER));
    assert(WrappingRefuses(ABILITY_MUMMY, ABILITY_LINGERING_AROMA) && WrappingRefuses(ABILITY_LINGERING_AROMA, ABILITY_MUMMY));
    assert(WrappingRefuses(ABILITY_LINGERING_AROMA, ABILITY_PROTOSYNTHESIS) && !WrappingRefuses(ABILITY_MUMMY, ABILITY_PROTOSYNTHESIS));
    assert(WrappingRefuses(ABILITY_LINGERING_AROMA, ABILITY_HADRON_ENGINE) && !WrappingRefuses(ABILITY_MUMMY, ABILITY_ORICHALCUM_PULSE));
    assert(!WrappingRefuses(ABILITY_MUMMY, ABILITY_INTIMIDATE) && !WrappingRefuses(ABILITY_LINGERING_AROMA, ABILITY_INTIMIDATE));
    return 0;
}
"""


class WrappingTests(unittest.TestCase):
    def test_what_the_pages_add(self):
        run_c(WRAPPING.replace("@FUNCTION@", function(OVERLAY.read_text(), "WrappingRefuses")))


if __name__ == "__main__":
    unittest.main()
