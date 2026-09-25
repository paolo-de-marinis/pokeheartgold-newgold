#!/usr/bin/env python3
"""Run the added abilities' C on the host.

Each class takes the port's own functions out of the source, compiles them
against a small stubbed battle, and checks what the ability does with worked
numbers. Taking the ability out of the function makes its class fail.
"""

import os
from pathlib import Path
import re
import shlex
import subprocess
import tempfile
import unittest

from test_level_cap import ROOT
from test_repels import function

OVERLAY = (ROOT / "src/battle/overlay_12_0224E4FC.c").read_text()


def run_c(test, program):
    with tempfile.TemporaryDirectory(prefix="newgold-ability-") as directory:
        path = Path(directory)
        (path / "test.c").write_text(program)
        result = subprocess.run(shlex.split(os.environ.get("CC", "cc")) + [
            "-std=c99", "-Wall", "-Werror", "-Wno-unused-function", "-Wno-unused-variable", "-Wno-unused-but-set-variable",
            "-iquote", str(ROOT / "include"), str(path / "test.c"), "-o", str(path / "test")],
            capture_output=True, text=True)
        test.assertEqual(result.returncode, 0, result.stderr)
        result = subprocess.run([str(path / "test")], capture_output=True, text=True)
        test.assertEqual(result.returncode, 0, result.stderr)


HEADER = r"""
#include <assert.h>
#include <stdint.h>
#include <stdio.h>
#include <string.h>
#include "constants/abilities.h"
#include "constants/battle.h"
#include "constants/battle_subscript.h"
#include "constants/items.h"
#include "constants/move_effects.h"
#include "constants/moves.h"
#include "constants/pokemon.h"
#include "constants/species.h"
typedef uint8_t u8; typedef uint16_t u16; typedef uint32_t u32;
typedef int8_t s8; typedef int16_t s16; typedef int32_t s32;
typedef int BOOL;
#define TRUE 1
#define FALSE 0
#define NELEMS(a) (sizeof(a) / sizeof((a)[0]))
#define GF_ASSERT(x) assert(x)
#define EXPECT(what, expected) do { int got_ = (what); if (got_ != (expected)) { \
    fprintf(stderr, "%s:%d: %s is %d, expected %d\n", __FILE__, __LINE__, #what, got_, (expected)); return 1; } } while (0)
"""


# CalcMoveDamage, the tables it reads and the structure it fills, with the
# battle around it stubbed: every battler has 100 in each stat, level 50, no
# item, no stage, and the ability the scenario gives it. A 100-power physical
# move from battler 0 into battler 1 is ((22 * 100 * 100 / 100) / 50) + 2 = 46.
DAMAGE = HEADER + r"""
typedef struct { int unused; } BattleSystem;
typedef struct {
    int hp; u16 species; u32 moveEffectFlags; u8 canStillEvolve; u8 friendship;
    struct { int meFirstFlag, meFirstCount, fakeOutCount; } unk88;
} BattleMon;
typedef struct {
    int unk_2158; u8 terrainOverlayType; int meFirstTotal; int totalTurns;
    u32 effectiveSpeed[4]; u8 paradoxBoostedStat[4]; u8 supremeOverlordFallen[4];
    int totalTimesFainted[4];
    u8 gemBoostingMove; int battlerIdAttacker; u8 multiHitCount; u8 echoedVoiceTurns; u8 roundUsers; u16 moveUsedBefore; u8 wonderRoomTurns;
    BattleMon battleMons[4];
    struct { int helpingHandFlag; int unk3C; int switchedIn; } turnData[4];
    struct { u8 statLoweredThisTurn; } moveConditions[4];
} BattleContext;
typedef struct { int power, type, category, effect; } MoveTbl;

static struct { int maxBattlers; int ability[4]; MoveTbl move; u32 weather; BOOL acted[4]; u32 status[4]; BOOL substitute[4]; u16 def, spDef; u8 rageFist[4];
    u16 atkOf[4], defOf[4]; u8 atkStage[4], defStage[4], spDefStage[4]; } S;

static int GetBattlerVar(BattleContext *ctx, int battlerId, u32 varId, void *data) {
    (void)data;
    switch (varId) {
    case BMON_DATA_DEF: return S.defOf[battlerId] ? S.defOf[battlerId] : S.def ? S.def : 100;
    case BMON_DATA_SPDEF: return S.spDef ? S.spDef : 100;
    case BMON_DATA_ATK: return S.atkOf[battlerId] ? S.atkOf[battlerId] : 100;
    case BMON_DATA_SPATK: return 100;
    case BMON_DATA_STAT_CHANGE_ATK: return S.atkStage[battlerId] ? S.atkStage[battlerId] : 6;
    case BMON_DATA_STAT_CHANGE_DEF: return S.defStage[battlerId] ? S.defStage[battlerId] : 6;
    case BMON_DATA_STAT_CHANGE_SPDEF: return S.spDefStage[battlerId] ? S.spDefStage[battlerId] : 6;
    case BMON_DATA_STAT_CHANGE_SPATK: return 6;
    case BMON_DATA_LEVEL: return 50;
    case BMON_DATA_SPECIES: return ctx->battleMons[battlerId].species;
    case BMON_DATA_HP: return ctx->battleMons[battlerId].hp;
    case BMON_DATA_MAXHP: return 100;
    case BMON_DATA_GENDER: return MON_GENDERLESS;
    case BMON_DATA_TYPE_1: case BMON_DATA_TYPE_2: return TYPE_NORMAL;
    case BMON_DATA_STATUS: return S.status[battlerId];
    default: return 0;
    }
}
static u16 GetBattlerAbility(BattleContext *ctx, int battlerId) { (void)ctx; return S.ability[battlerId]; }
static u16 GetBattlerHeldItem(BattleContext *ctx, int battlerId) { (void)ctx; (void)battlerId; return 0; }
static int GetItemVar(BattleContext *ctx, u16 item, u32 var) { (void)ctx; (void)item; (void)var; return 0; }
static u16 SpeciesToDexSpecies(u16 species) { return species; }
static int BattleSystem_GetMaxBattlers(BattleSystem *bs) { (void)bs; return S.maxBattlers; }
static const MoveTbl *BattleMoveTbl(BattleContext *ctx, u32 moveNo) { (void)ctx; (void)moveNo; return &S.move; }
static u8 BattleMoveTypeForAbility(BattleContext *ctx, int battlerId, int ability, u32 moveNo, int type) { (void)ctx; (void)battlerId; (void)ability; (void)moveNo; return type; }
static BOOL BattlerIsGrounded(BattleContext *ctx, int battlerId) { (void)ctx; (void)battlerId; return TRUE; }
static BOOL BattlerCheckSubstitute(BattleContext *ctx, int battlerId) { (void)ctx; (void)battlerId; return FALSE; }
static BOOL SubstituteTakesHit(BattleContext *ctx, int battlerId) { (void)ctx; return S.substitute[battlerId]; }
static BOOL IsSuppressibleSecondaryEffect(BattleContext *ctx, u32 moveNo) { (void)ctx; (void)moveNo; return FALSE; }
static BOOL BattleMoveMakesContact(BattleContext *ctx, u32 moveNo) { (void)ctx; (void)moveNo; return FALSE; }
static BOOL BattleMoveIsSoundBased(u32 moveNo) { (void)moveNo; return FALSE; }
static BOOL KnockOffCanRemoveItem(BattleContext *ctx, int a, int t) { (void)ctx; (void)a; (void)t; return FALSE; }
static int CheckAbilityActive(BattleSystem *bs, BattleContext *ctx, int flag, int battlerId, int ability) {
    (void)bs; (void)ctx; (void)flag; (void)battlerId; (void)ability; return 0;
}
static BOOL CheckBattlerAbilityIfNotIgnored(BattleContext *ctx, int a, int t, int ability) { (void)ctx; (void)a; (void)t; (void)ability; return FALSE; }
static BOOL SideAbilityNotIgnored(BattleSystem *bs, BattleContext *ctx, int a, int t, int ability) { (void)bs; (void)ctx; (void)a; (void)t; (void)ability; return FALSE; }
static int CheckMoveEffectOnField(BattleSystem *bs, BattleContext *ctx, u32 flag) { (void)bs; (void)ctx; (void)flag; return 0; }
static u32 BattlerMoveWeather(BattleSystem *bs, BattleContext *ctx, int battlerId) { (void)bs; (void)ctx; (void)battlerId; return S.weather; }
static int ov12_022581D4(BattleSystem *bs, BattleContext *ctx, int var, int battlerId) { (void)bs; (void)ctx; (void)var; (void)battlerId; return 0; }
static BOOL ov12_0225561C(BattleContext *ctx, int battlerId) { (void)ctx; return S.acted[battlerId]; }
static u32 MaskOfFlagNo(int flagno) { return 1u << flagno; }
static int BattlerPartyFaintCount(BattleSystem *bs, BattleContext *ctx, int battlerId) { (void)bs; return ctx->totalTimesFainted[battlerId]; }
static u8 *Battler_RageFistHits(BattleSystem *bs, BattleContext *ctx, int battlerId) { (void)bs; (void)ctx; return &S.rageFist[battlerId]; }
static int BattleMoveCategory(BattleContext *ctx, u32 moveNo, int battlerIdAttacker) { (void)ctx; (void)moveNo; (void)battlerIdAttacker; return S.move.category; }
@MOVE_IS_IN_LIST@
@SLICING@
@CALC@

static BattleSystem bs;
static BattleContext ctx;

static void reset(int maxBattlers) {
    memset(&S, 0, sizeof(S));
    memset(&ctx, 0, sizeof(ctx));
    S.maxBattlers = maxBattlers;
    S.move = (MoveTbl){ 100, TYPE_NORMAL, CATEGORY_PHYSICAL };
    ctx.unk_2158 = 10;
    for (int i = 0; i < 4; i++) {
        ctx.battleMons[i].hp = 100;
        ctx.battleMons[i].species = SPECIES_BULBASAUR;
    }
}

static int damage(int attacker, int target) {
    return CalcMoveDamage(&bs, &ctx, MOVE_TACKLE, 0, 0, 0, TYPE_NORMAL, attacker, target, 1);
}

int main(void) {
    reset(4); EXPECT(damage(0, 1), 46);
@CHECKS@
    return 0;
}
"""


def damage_program(checks):
    start = OVERLAY.index("typedef struct MoveDamageCalc {")
    calc = OVERLAY[start:OVERLAY.index(function(OVERLAY, "CalcMoveDamage")) + len(function(OVERLAY, "CalcMoveDamage"))]
    slicing = re.search(r"static const u16 sSlicingMoves\[\] = \{.*?\};", OVERLAY, re.S).group(0)
    return (DAMAGE.replace("@MOVE_IS_IN_LIST@", function(OVERLAY, "MoveIsInList"))
            .replace("@SLICING@", slicing).replace("@CALC@", calc).replace("@CHECKS@", checks))


class PowerSpotTests(unittest.TestCase):
    def test_the_ally_s_moves_take_three_tenths(self):
        # Power 130: (22 * 100 * 130 / 100) / 50 + 2 = 59.
        run_c(self, damage_program(r"""
    reset(4); S.ability[2] = ABILITY_POWER_SPOT; EXPECT(damage(0, 1), 59);
    // Never the holder's own moves.
    reset(4); S.ability[0] = ABILITY_POWER_SPOT; EXPECT(damage(0, 1), 46);
    // Nor from a fainted holder, which the reference still counts.
    reset(4); S.ability[2] = ABILITY_POWER_SPOT; ctx.battleMons[2].hp = 0; EXPECT(damage(0, 1), 46);
    // Nor from the stale slot of a single battle.
    reset(2); S.ability[2] = ABILITY_POWER_SPOT; EXPECT(damage(0, 1), 46);
"""))

class StakeoutTests(unittest.TestCase):
    def test_the_attacking_stat_doubles_against_a_pokemon_that_came_in_this_turn(self):
        # Attack 200: (22 * 200 * 100 / 100) / 50 + 2 = 90.
        run_c(self, damage_program(r"""
    reset(4); S.ability[0] = ABILITY_STAKEOUT; ctx.totalTurns = 3;
    ctx.battleMons[1].unk88.fakeOutCount = 4; EXPECT(damage(0, 1), 90);
    // A special move, the same.
    S.move.category = CATEGORY_SPECIAL; EXPECT(damage(0, 1), 90);
    // One that came in at the end of last turn, and a lead on the first turn.
    S.move.category = CATEGORY_PHYSICAL;
    ctx.battleMons[1].unk88.fakeOutCount = 3; EXPECT(damage(0, 1), 46);
    ctx.totalTurns = 0; ctx.battleMons[1].unk88.fakeOutCount = 0; EXPECT(damage(0, 1), 46);
    // It is the attacker's ability.
    reset(4); S.ability[1] = ABILITY_STAKEOUT; ctx.battleMons[1].unk88.fakeOutCount = 1; EXPECT(damage(0, 1), 46);
"""))


class SupremeOverlordTests(unittest.TestCase):
    def test_a_tenth_more_power_for_each_of_the_fallen(self):
        # Power 130: 59; power 150: (22 * 100 * 150 / 100) / 50 + 2 = 68.
        run_c(self, damage_program(r"""
    reset(4); S.ability[0] = ABILITY_SUPREME_OVERLORD; EXPECT(damage(0, 1), 46);
    ctx.supremeOverlordFallen[0] = 3; EXPECT(damage(0, 1), 59);
    ctx.supremeOverlordFallen[0] = 5; EXPECT(damage(0, 1), 68);
    // The count is the holder's, read only while it has the ability.
    S.ability[0] = ABILITY_NONE; EXPECT(damage(0, 1), 46);
"""))

    def test_the_fallen_are_its_own_party_s_counted_on_the_way_in(self):
        program = HEADER + r"""
typedef struct { int unused; } Party;
typedef struct { int maxBattlers; Party *party[4]; } BattleSystem;
typedef struct { int totalTimesFainted[4]; } BattleContext;
static int BattleSystem_GetMaxBattlers(BattleSystem *bs) { return bs->maxBattlers; }
static Party *BattleSystem_GetParty(BattleSystem *bs, int battlerId) { return bs->party[battlerId]; }
""" + function(OVERLAY, "BattlerPartyFaintCount") + r"""
int main(void) {
    Party mine, partner, foe;
    BattleContext ctx = { { 2, 4, 1, 8 } };
    // A double battle: both slots on a side are one party.
    BattleSystem doubles = { 4, { &mine, &foe, &mine, &foe } };
    EXPECT(BattlerPartyFaintCount(&doubles, &ctx, 0), 3);
    EXPECT(BattlerPartyFaintCount(&doubles, &ctx, 3), 12);
    // A multi battle: the partner's faints are not the player's.
    BattleSystem multi = { 4, { &mine, &foe, &partner, &foe } };
    EXPECT(BattlerPartyFaintCount(&multi, &ctx, 0), 2);
    EXPECT(BattlerPartyFaintCount(&multi, &ctx, 2), 1);
    return 0;
}
"""
        run_c(self, program)
        entry = function(OVERLAY, "TryAbilityOnEntry")
        state = entry[entry.index("// Supreme Overlord"):]
        state = state[:state.index("case ", 10)]
        self.assertIn("!ctx->battleMons[battlerId].sendOutFlag && ctx->battleMons[battlerId].hp && GetBattlerAbility(ctx, battlerId) == ABILITY_SUPREME_OVERLORD", state)
        self.assertIn("j = BattlerPartyFaintCount(battleSystem, ctx, battlerId);", state)
        self.assertIn("ctx->supremeOverlordFallen[battlerId] = j < 5 ? j : 5;", state)
        self.assertIn("script = BATTLE_SUBSCRIPT_SUPREME_OVERLORD;", state)
        self.assertIn("ctx->supremeOverlordFallen[battlerId] = 0;", function(OVERLAY, "BattleSystem_GetBattleMon"))


class ToxicChainTests(unittest.TestCase):
    def test_three_in_ten_of_any_damaging_hit_badly_poison(self):
        program = HEADER + r"""
typedef struct { u16 random; int draws; } BattleSystem;
typedef struct { int hp; u32 status; } BattleMon;
typedef struct { int physicalDamage, specialDamage; } SelfTurnData;
typedef struct {
    int battlerIdAttacker, battlerIdTarget; u32 moveStatusFlag, battleStatus, battleStatus2;
    BattleMon battleMons[4]; SelfTurnData selfTurnData[4];
} BattleContext;
static int ability[4], item[4];
static u16 GetBattlerAbility(BattleContext *ctx, int battlerId) { (void)ctx; return ability[battlerId]; }
static int GetBattlerHeldItemEffect(BattleContext *ctx, int battlerId) { (void)ctx; return item[battlerId]; }
static u16 BattleSystem_Random(BattleSystem *bs) { bs->draws++; return bs->random; }
""" + function(OVERLAY, "ToxicChainTakesHold") + r"""
int main(void) {
    BattleSystem bs = { 0, 0 };
    BattleContext ctx = { 0, 1 };
    ctx.battleMons[1].hp = 50;
    ctx.selfTurnData[1].specialDamage = 20;
    ability[0] = ABILITY_TOXIC_CHAIN;
    // A special hit, no contact asked: rolls of 0 to 2 poison, 3 to 9 do not.
    bs.random = 12; EXPECT(ToxicChainTakesHold(&bs, &ctx), 1);
    bs.random = 13; EXPECT(ToxicChainTakesHold(&bs, &ctx), 0);
    bs.random = 2;
    // Not through a Covert Cloak, not onto a status, not with a miss.
    item[1] = HOLD_EFFECT_PREVENT_SECONDARY_EFFECTS; EXPECT(ToxicChainTakesHold(&bs, &ctx), 0); item[1] = 0;
    ctx.battleMons[1].status = STATUS_BURN; EXPECT(ToxicChainTakesHold(&bs, &ctx), 0); ctx.battleMons[1].status = 0;
    ctx.moveStatusFlag = MOVE_STATUS_MISSED; EXPECT(ToxicChainTakesHold(&bs, &ctx), 0); ctx.moveStatusFlag = 0;
    // Nothing without damage, and nothing drawn for a hit that could not poison.
    ctx.selfTurnData[1].specialDamage = 0; bs.draws = 0;
    EXPECT(ToxicChainTakesHold(&bs, &ctx), 0); EXPECT(bs.draws, 0);
    ctx.selfTurnData[1].physicalDamage = 20; EXPECT(ToxicChainTakesHold(&bs, &ctx), 1);
    // It is the attacker's ability, not the target's.
    ability[0] = 0; ability[1] = ABILITY_TOXIC_CHAIN; EXPECT(ToxicChainTakesHold(&bs, &ctx), 0);
    return 0;
}
"""
        run_c(self, program)
        hit = function(OVERLAY, "CheckAbilityEffectOnHit")
        branch = hit[hit.index("if (ToxicChainTakesHold(battleSystem, ctx) == TRUE) {"):]
        branch = branch[:branch.index("return TRUE;")]
        self.assertIn("ctx->statChangeType = SIDE_EFFECT_TYPE_INDIRECT;", branch)
        self.assertIn("ctx->battlerIdStatChange = ctx->battlerIdTarget;", branch)
        self.assertIn("*script = BATTLE_SUBSCRIPT_BADLY_POISON;", branch)



CONTROLLER = (ROOT / "src/battle/battle_controller_player.c").read_text()

# BattleSystem_CheckMoveHit with the battle stubbed: no stages, no weather, no
# item, and a random number the scenario picks, so that whether the move
# missed says which side of it the hit chance fell.
ACCURACY = HEADER + r"""
typedef struct { int unused; } BattleSystem;
typedef struct {
    s8 statChanges[8]; int hp; u8 friendship; u32 status2; u32 moveEffectFlags;
    struct { int micleBerryFlag; } unk88;
} BattleMon;
typedef struct {
    u32 battleStatus; u32 fieldCondition; u32 moveStatusFlag; BattleMon battleMons[4];
    struct { int telekinesisTurns; } moveConditions[4];
} BattleContext;
typedef struct { int accuracy, category, effect; } MoveTbl;

static struct { int maxBattlers; int ability[4]; MoveTbl move; u16 random; } S;

static u32 BattleSystem_GetBattleType(BattleSystem *bs) { (void)bs; return S.maxBattlers == 4 ? BATTLE_TYPE_DOUBLES : 0; }
static int BattleSystem_GetMaxBattlers(BattleSystem *bs) { (void)bs; return S.maxBattlers; }
static int BattleSystem_GetFieldSide(BattleSystem *bs, int battlerId) { (void)bs; return battlerId & 1; }
static u16 BattleSystem_Random(BattleSystem *bs) { (void)bs; return S.random; }
static u8 BattleMoveAdjustedType(BattleContext *ctx, int battlerId, u32 moveNo) { (void)ctx; (void)battlerId; (void)moveNo; return TYPE_NORMAL; }
static u32 BattlerMoveWeather(BattleSystem *bs, BattleContext *ctx, int battlerId) { (void)bs; (void)battlerId; return ctx->fieldCondition & FIELD_CONDITION_WEATHER; }
static u32 WeatherUnderUmbrella(BattleContext *ctx, u32 weather, int battlerId) { (void)ctx; (void)battlerId; return weather; }
static u32 BattlerMoveWeatherAt(BattleSystem *bs, BattleContext *ctx, int battlerIdAttacker, int battlerId) { return WeatherUnderUmbrella(ctx, BattlerMoveWeather(bs, ctx, battlerIdAttacker), battlerId); }
static const MoveTbl *BattleMoveTbl(BattleContext *ctx, u32 moveNo) { (void)ctx; (void)moveNo; return &S.move; }
static int CheckAbilityActive(BattleSystem *bs, BattleContext *ctx, int flag, int battlerId, int ability) {
    (void)bs; (void)ctx; (void)flag; (void)battlerId; (void)ability; return 0;
}
static BOOL CheckBattlerAbilityIfNotIgnored(BattleContext *ctx, int a, int t, int ability) { (void)ctx; (void)a; return S.ability[t] == ability; }
static u16 GetBattlerAbility(BattleContext *ctx, int battlerId) { (void)ctx; return S.ability[battlerId]; }
static int GetBattlerHeldItemEffect(BattleContext *ctx, int battlerId) { (void)ctx; (void)battlerId; return 0; }
static int GetHeldItemModifier(BattleContext *ctx, int battlerId, int a) { (void)ctx; (void)battlerId; (void)a; return 0; }
static BOOL ov12_0225561C(BattleContext *ctx, int battlerId) { (void)ctx; (void)battlerId; return FALSE; }
@TABLE@
@CHECK@

static BattleSystem bs;
static BattleContext ctx;

static void reset(int maxBattlers) {
    memset(&S, 0, sizeof(S));
    memset(&ctx, 0, sizeof(ctx));
    S.maxBattlers = maxBattlers;
    S.move = (MoveTbl){ 50, CATEGORY_SPECIAL, 0 };
    for (int i = 0; i < 4; i++) {
        ctx.battleMons[i].hp = 100;
        memset(ctx.battleMons[i].statChanges, 6, 8);
    }
}

// Whether a move from battler 0 at battler 1 lands when the roll is `roll`,
// which it does when roll + 1 is no more than the hit chance.
static int lands(u16 roll) {
    S.random = roll;
    ctx.moveStatusFlag = 0;
    BattleSystem_CheckMoveHit(&bs, &ctx, 0, 1, MOVE_TACKLE);
    return !(ctx.moveStatusFlag & MOVE_STATUS_MISSED);
}

int main(void) {
    // A 50% move: roll 49 lands, 50 does not.
    reset(4); EXPECT(lands(49), 1); EXPECT(lands(50), 0);
@CHECKS@
    return 0;
}
"""


def accuracy_program(checks):
    table = re.search(r"static const u8 sHitChanceTable\[13\]\[2\] = \{.*?\};", CONTROLLER, re.S).group(0)
    return (ACCURACY.replace("@TABLE@", table)
            .replace("@CHECK@", function(CONTROLLER, "BattleSystem_CheckMoveHit")).replace("@CHECKS@", checks))


class VictoryStarTests(unittest.TestCase):
    def test_the_holder_and_its_ally_are_a_tenth_surer(self):
        run_c(self, accuracy_program(r"""
    // 50 * 110 / 100 = 55: roll 54 lands, 55 does not.
    reset(4); S.ability[0] = ABILITY_VICTORY_STAR; EXPECT(lands(54), 1); EXPECT(lands(55), 0);
    reset(4); S.ability[2] = ABILITY_VICTORY_STAR; EXPECT(lands(54), 1); EXPECT(lands(55), 0);
    // Two holders: 55 * 110 / 100 = 60.
    reset(4); S.ability[0] = S.ability[2] = ABILITY_VICTORY_STAR; EXPECT(lands(59), 1); EXPECT(lands(60), 0);
    // Not a foe's, not a fainted ally's, not the stale slot of a single battle.
    reset(4); S.ability[1] = S.ability[3] = ABILITY_VICTORY_STAR; EXPECT(lands(50), 0);
    reset(4); S.ability[2] = ABILITY_VICTORY_STAR; ctx.battleMons[2].hp = 0; EXPECT(lands(50), 0);
    reset(2); S.ability[2] = ABILITY_VICTORY_STAR; EXPECT(lands(50), 0);
"""))


SUBSCRIPTS = ROOT / "files/battledata/script/subscript"


def subscript(name):
    matches = sorted(SUBSCRIPTS.glob(f"subscript_*_{name}.s"))
    assert len(matches) == 1, f"{name}: {matches}"
    return matches[0].read_text()


def label(script, name):
    """The lines of a script from `name:` to the next label."""
    body = script[script.index(f"\n{name}:\n") + len(name) + 3:]
    following = re.search(r"^\w+:$", body, re.M)
    return body[:following.start()] if following else body


class GuardDogTests(unittest.TestCase):
    def test_intimidate_raises_its_attack_instead(self):
        script = subscript("Intimidate")
        loop = label(script, "_013")
        # Asked after the substitute and the faint, before the drop is set up.
        self.assertLess(loop.index("CheckSubstitute"), loop.index("ABILITY_GUARD_DOG, _GUARD_DOG"))
        self.assertLess(loop.index("ABILITY_GUARD_DOG, _GUARD_DOG"), loop.index("MOVE_SUBSCRIPT_PTR_ATTACK_DOWN_1_STAGE"))
        guard = label(script, "_GUARD_DOG")
        # Not in Mist, nor at -6, where the Intimidate would have failed anyway.
        self.assertIn("BSCRIPT_VAR_SIDE_CONDITION_STAT_CHANGE, SIDE_CONDITION_MIST, _038", guard)
        self.assertIn("BMON_DATA_STAT_CHANGE_ATK, 0, _038", guard)
        self.assertIn("BSCRIPT_VAR_SIDE_EFFECT_PARAM, MOVE_SUBSCRIPT_PTR_ATTACK_UP_1_STAGE", guard)
        self.assertIn("GoTo _CHANGE", guard)
        self.assertIn("SIDE_EFFECT_TYPE_ABILITY", label(script, "_CHANGE"))

    def test_it_is_not_dragged_out(self):
        # Roar, Whirlwind, Dragon Tail and Circle Throw all run this subscript.
        script = subscript("ForceSwitchOrFlee")
        self.assertIn("CheckIgnorableAbility CHECK_OPCODE_HAVE, BATTLER_CATEGORY_DEFENDER, ABILITY_GUARD_DOG, _079", script)
        self.assertLess(script.index("ABILITY_GUARD_DOG"), script.index("TryWhirlwind"))


class AromaVeilTests(unittest.TestCase):
    def test_what_it_keeps_off_and_whom(self):
        program = HEADER + r"""
typedef struct { int hp; } BattleMon;
typedef struct { BattleMon battleMons[4]; } BattleContext;
static int ability[4];
static u16 GetBattlerAbility(BattleContext *ctx, int battlerId) { (void)ctx; return ability[battlerId]; }
""" + function(OVERLAY, "MoveIsInList") + re.search(r"static const u16 sMoveLimitingEffects\[\] = \{.*?\};", OVERLAY, re.S).group(0) + \
            function(OVERLAY, "MoveEffectLimitsMoves") + function(OVERLAY, "AromaVeilShelters") + r"""
int main(void) {
    BattleContext ctx = { { { 50 }, { 50 }, { 50 }, { 50 } } };
    int limiting[] = { MOVE_EFFECT_TAUNT, MOVE_EFFECT_TORMENT, MOVE_EFFECT_ENCORE, MOVE_EFFECT_DISABLE,
                       MOVE_EFFECT_PREVENT_HEALING, MOVE_EFFECT_INFATUATE };
    for (unsigned i = 0; i < NELEMS(limiting); i++) {
        EXPECT(MoveEffectLimitsMoves(limiting[i]), 1);
    }
    // Not the status conditions, nor Psychic Noise's hit, whose heal block is
    // refused in its subscript rather than the move being turned away.
    EXPECT(MoveEffectLimitsMoves(MOVE_EFFECT_STATUS_SLEEP), 0);
    EXPECT(MoveEffectLimitsMoves(MOVE_EFFECT_PREVENT_HEALING_HIT), 0);
    EXPECT(MoveEffectLimitsMoves(MOVE_EFFECT_HIT), 0);
    // Its holder and a standing ally, not a fainted one, not a foe.
    ability[0] = ABILITY_AROMA_VEIL;
    EXPECT(AromaVeilShelters(&ctx, 0), 1); EXPECT(AromaVeilShelters(&ctx, 2), 1);
    EXPECT(AromaVeilShelters(&ctx, 1), 0); EXPECT(AromaVeilShelters(&ctx, 3), 0);
    ctx.battleMons[0].hp = 0; EXPECT(AromaVeilShelters(&ctx, 2), 0);
    return 0;
}
"""
        run_c(self, program)
        immunity = function(OVERLAY, "BattleContext_CheckMoveImmunityFromAbility")
        veil = immunity[immunity.index("if (MoveEffectLimitsMoves(moveEffect) == TRUE) {"):]
        veil = veil[:veil.index("\n    }\n")]
        self.assertIn("BattlerOrAllyWithAbility(ctx, battlerIdAttacker, battlerIdTarget, ABILITY_AROMA_VEIL)", veil)
        self.assertIn("script = BATTLE_SUBSCRIPT_BLOCKED_BY_ABILITY;", veil)
        hit = function(OVERLAY, "CheckAbilityEffectOnHit")
        cursed = hit[hit.index("case ABILITY_CURSED_BODY:"):]
        cursed = cursed[:cursed.index("break;")]
        self.assertIn("AromaVeilShelters(ctx, ctx->battlerIdAttacker) == FALSE", cursed)

    def test_the_other_ways_in_are_shut_too(self):
        for name, battler, done in (("Infatuate", "BATTLER_CATEGORY_SIDE_EFFECT_MON", "_117"),
                                    ("HealBlockStart", "BATTLER_CATEGORY_DEFENDER", "_AROMA_VEIL")):
            script = subscript(name)
            start = label(script, "_000")
            self.assertIn(f"CheckIgnorableAbility CHECK_OPCODE_HAVE, {battler}, ABILITY_AROMA_VEIL, {done}", start, name)
            self.assertIn(f"BATTLER_RELATIVE_ALLY|{battler}, BMON_DATA_HP, 0, _NO_AROMA_VEIL", start, name)
            self.assertIn(f"CheckIgnorableAbility CHECK_OPCODE_HAVE, BATTLER_RELATIVE_ALLY|{battler}, ABILITY_AROMA_VEIL, {done}", start, name)
            self.assertEqual(label(script, done).strip(), "End", name)


class CuriousMedicineTests(unittest.TestCase):
    def test_the_ally_s_stat_changes_are_cleared_on_the_way_in(self):
        program = HEADER + r"""
typedef struct { s8 statChanges[NUM_BATTLE_STATS]; } BattleMon;
typedef struct { BattleMon battleMons[4]; } BattleContext;
""" + function(OVERLAY, "BattlerClearStatChanges") + r"""
int main(void) {
    BattleContext ctx;
    memset(ctx.battleMons[2].statChanges, 6, NUM_BATTLE_STATS);
    EXPECT(BattlerClearStatChanges(&ctx, 2), 0);
    // A raise and a drop both go, and every stage ends at zero.
    ctx.battleMons[2].statChanges[STAT_ATK] = 8;
    ctx.battleMons[2].statChanges[STAT_EVASION] = 4;
    EXPECT(BattlerClearStatChanges(&ctx, 2), 1);
    for (int stat = STAT_ATK; stat < NUM_BATTLE_STATS; stat++) {
        EXPECT(ctx.battleMons[2].statChanges[stat], 6);
    }
    return 0;
}
"""
        run_c(self, program)
        entry = function(OVERLAY, "TryAbilityOnEntry")
        state = entry[entry.index("// Curious Medicine"):]
        state = state[:state.index("case ", 10)]
        self.assertIn("!ctx->battleMons[battlerId].sendOutFlag && ctx->battleMons[battlerId].hp && GetBattlerAbility(ctx, battlerId) == ABILITY_CURIOUS_MEDICINE", state)
        self.assertIn("j = BattleSystem_GetBattlerIdPartner(battleSystem, battlerId);", state)
        self.assertIn("j != battlerId && ctx->battleMons[j].hp && BattlerClearStatChanges(ctx, j) == TRUE", state)
        self.assertIn("script = BATTLE_SUBSCRIPT_CURIOUS_MEDICINE;", state)


class CostarTests(unittest.TestCase):
    def test_the_ally_s_stages_and_critical_odds_become_its_own(self):
        program = HEADER + r"""
typedef struct { s8 statChanges[NUM_BATTLE_STATS]; u32 status2; } BattleMon;
typedef struct { u8 laserFocusTimer; } MoveConditions;
typedef struct { BattleMon battleMons[4]; MoveConditions moveConditions[4]; } BattleContext;
""" + function(OVERLAY, "CostarCopiesAlly") + r"""
int main(void) {
    BattleContext ctx;
    memset(&ctx, 0, sizeof(ctx));
    memset(ctx.battleMons[0].statChanges, 6, NUM_BATTLE_STATS);
    memset(ctx.battleMons[2].statChanges, 6, NUM_BATTLE_STATS);
    // The holder's own +2 Speed goes; the ally's +2 Attack and -1 Defense come.
    ctx.battleMons[0].statChanges[STAT_SPEED] = 8;
    ctx.battleMons[0].status2 = STATUS2_FOCUS_ENERGY | STATUS2_CONFUSION;
    ctx.battleMons[2].statChanges[STAT_ATK] = 8;
    ctx.battleMons[2].statChanges[STAT_DEF] = 5;
    ctx.moveConditions[2].laserFocusTimer = 2;
    CostarCopiesAlly(&ctx, 0, 2);
    EXPECT(ctx.battleMons[0].statChanges[STAT_ATK], 8);
    EXPECT(ctx.battleMons[0].statChanges[STAT_DEF], 5);
    EXPECT(ctx.battleMons[0].statChanges[STAT_SPEED], 6);
    // An ally without Focus Energy takes the holder's away; the rest of the
    // holder's conditions stay.
    EXPECT(ctx.battleMons[0].status2, STATUS2_CONFUSION);
    EXPECT(ctx.moveConditions[0].laserFocusTimer, 2);
    ctx.battleMons[2].status2 = STATUS2_FOCUS_ENERGY;
    CostarCopiesAlly(&ctx, 0, 2);
    EXPECT(ctx.battleMons[0].status2, STATUS2_CONFUSION | STATUS2_FOCUS_ENERGY);
    // The ally is not touched.
    EXPECT(ctx.battleMons[2].statChanges[STAT_ATK], 8);
    return 0;
}
"""
        run_c(self, program)
        entry = function(OVERLAY, "TryAbilityOnEntry")
        state = entry[entry.index("// Costar"):]
        state = state[:state.index("case ", 10)]
        self.assertIn("!ctx->battleMons[battlerId].sendOutFlag && ctx->battleMons[battlerId].hp && GetBattlerAbility(ctx, battlerId) == ABILITY_COSTAR", state)
        self.assertIn("if (j != battlerId && ctx->battleMons[j].hp) {\n                        CostarCopiesAlly(ctx, battlerId, j);", state)
        self.assertIn("script = BATTLE_SUBSCRIPT_COSTAR;", state)
        self.assertIn("msg_0197_00452, TAG_NICKNAME_NICKNAME, BATTLER_CATEGORY_MSG_BATTLER_TEMP, BATTLER_RELATIVE_ALLY|BATTLER_CATEGORY_MSG_BATTLER_TEMP",
                      subscript("Costar"))


class MimicryTests(unittest.TestCase):
    def test_the_terrain_s_type_and_back(self):
        program = HEADER + r"""
typedef struct { int types[2]; } Pokemon;
typedef struct { Pokemon party[4]; } BattleSystem;
typedef struct { u8 type1, type2, type3; } BattleMon;
typedef struct { BattleMon battleMons[4]; u8 mimicryTerrain[4]; u8 selectedMonIndex[4]; u8 switchInFlag; } BattleContext;
static u32 MaskOfFlagNo(int flagno) { return 1u << flagno; }
// Slot 6 is past any party: Party_GetMonByIndex asserts it.
static Pokemon *BattleSystem_GetPartyMon(BattleSystem *bs, int battlerId, int index) { assert(index < 6); return &bs->party[battlerId]; }
static int GetMonData(Pokemon *mon, int attr, void *out) { (void)out; return mon->types[attr == MON_DATA_TYPE_2]; }
""" + function(OVERLAY, "TerrainMimicryType") + function(OVERLAY, "Battler_MimicryRestoreTypes") + r"""
int main(void) {
    BattleSystem bs = { { { { TYPE_GROUND, TYPE_STEEL } } } };
    BattleContext ctx;
    memset(&ctx, 0, sizeof(ctx));
    EXPECT(TerrainMimicryType(ELECTRIC_TERRAIN), TYPE_ELECTRIC);
    EXPECT(TerrainMimicryType(GRASSY_TERRAIN), TYPE_GRASS);
    EXPECT(TerrainMimicryType(MISTY_TERRAIN), TYPE_FAIRY);
    EXPECT(TerrainMimicryType(PSYCHIC_TERRAIN), TYPE_PSYCHIC);
    // A Galarian Stunfisk made Electric, with a Forest's Curse on it, goes
    // back to Ground and Steel and keeps the Grass.
    ctx.battleMons[0] = (BattleMon){ TYPE_ELECTRIC, TYPE_ELECTRIC, TYPE_GRASS };
    ctx.mimicryTerrain[0] = ELECTRIC_TERRAIN;
    Battler_MimicryRestoreTypes(&bs, &ctx, 0);
    EXPECT(ctx.battleMons[0].type1, TYPE_GROUND);
    EXPECT(ctx.battleMons[0].type2, TYPE_STEEL);
    EXPECT(ctx.battleMons[0].type3, TYPE_GRASS);
    EXPECT(ctx.mimicryTerrain[0], TERRAIN_NONE);
    // One that never took a terrain's type, a Soaked one say, is left alone.
    ctx.battleMons[0].type1 = ctx.battleMons[0].type2 = TYPE_WATER;
    Battler_MimicryRestoreTypes(&bs, &ctx, 0);
    EXPECT(ctx.battleMons[0].type1, TYPE_WATER);
    // One that fainted Electric in a double battle with nothing to follow it
    // leaves its place empty, and the terrain ending there reads nothing.
    ctx.battleMons[1] = (BattleMon){ TYPE_ELECTRIC, TYPE_ELECTRIC, TYPE_NONE };
    ctx.mimicryTerrain[1] = ELECTRIC_TERRAIN;
    ctx.switchInFlag |= MaskOfFlagNo(1);
    ctx.selectedMonIndex[1] = 6;
    Battler_MimicryRestoreTypes(&bs, &ctx, 1);
    EXPECT(ctx.mimicryTerrain[1], TERRAIN_NONE);
    EXPECT(ctx.battleMons[1].type1, TYPE_ELECTRIC);
    return 0;
}
"""
        run_c(self, program)
        entry = function(OVERLAY, "TryAbilityOnEntry")
        state = entry[entry.index("// Mimicry"):]
        state = state[:state.index("case ", 10)]
        # It answers a change of terrain, not every difference of type.
        self.assertIn("GetBattlerAbility(ctx, battlerId) != ABILITY_MIMICRY || ctx->mimicryTerrain[battlerId] == ctx->terrainOverlayType", state)
        self.assertIn("ctx->mimicryTerrain[battlerId] = ctx->terrainOverlayType;", state)
        self.assertIn("ctx->battleMons[battlerId].type1 = ctx->msgTemp;", state)
        self.assertIn("ctx->battleMons[battlerId].type2 = ctx->msgTemp;", state)
        self.assertNotIn("type3", state)
        self.assertIn("script = BATTLE_SUBSCRIPT_MIMICRY;", state)
        self.assertIn("ctx->mimicryTerrain[battlerId] = TERRAIN_NONE;", function(OVERLAY, "BattleSystem_GetBattleMon"))
        # The terrain ending puts the types back there and then.
        command = function((ROOT / "src/battle/battle_command.c").read_text(), "BtlCmd_UpdateTerrainOverlay")
        ending = command[command.index("if (endTerrain == TRUE) {"):command.index("return FALSE;")]
        self.assertIn("Battler_MimicryRestoreTypes(battleSystem, ctx, battlerId);", ending)


class OpportunistTests(unittest.TestCase):
    def test_what_the_other_side_gains_is_kept_for_the_holder(self):
        """Opportunist is told every rise a Mirror Herb is (RecordMirrorHerbStages):
        the stat command's and those a script writes itself -- Belly Drum, a
        Starf Berry, Anger Point, Spectral Thief, Rage (Pokemon Central,
        Scrocco)."""
        program = HEADER + r"""
typedef struct { int maxBattlers; } BattleSystem;
typedef struct { int hp; } BattleMon;
typedef struct {
    BattleMon battleMons[4];
    u8 mirrorHerbStages[4][NUM_BATTLE_STATS];
    u8 opportunistStages[4][NUM_BATTLE_STATS];
} BattleContext;
static int ability[4];
static int BattleSystem_GetMaxBattlers(BattleSystem *bs) { return bs->maxBattlers; }
static int BattleSystem_GetFieldSide(BattleSystem *bs, int battlerId) { (void)bs; return battlerId & 1; }
static u16 GetBattlerAbility(BattleContext *ctx, int battlerId) { (void)ctx; return ability[battlerId]; }
static int GetBattlerHeldItemEffect(BattleContext *ctx, int battlerId) { (void)ctx; (void)battlerId; return 0; }
""" + function(OVERLAY, "RecordMirrorHerbStages") + r"""
int main(void) {
    BattleSystem bs = { 4 };
    BattleContext ctx;
    memset(&ctx, 0, sizeof(ctx));
    for (int i = 0; i < 4; i++) ctx.battleMons[i].hp = 50;
    ability[1] = ABILITY_OPPORTUNIST;
    // A Swords Dance on the other side: two stages of Attack kept for it.
    RecordMirrorHerbStages(&bs, &ctx, 0, STAT_ATK, 2);
    EXPECT(ctx.opportunistStages[1][STAT_ATK], 2);
    // Its own side's raises are not its to copy, nor a fainted holder's.
    RecordMirrorHerbStages(&bs, &ctx, 3, STAT_SPEED, 1);
    EXPECT(ctx.opportunistStages[1][STAT_SPEED], 0);
    ctx.battleMons[1].hp = 0;
    RecordMirrorHerbStages(&bs, &ctx, 0, STAT_SPEED, 1);
    EXPECT(ctx.opportunistStages[1][STAT_SPEED], 0);
    ctx.battleMons[1].hp = 50;
    // What is kept stops at six stages.
    for (int i = 0; i < 4; i++) RecordMirrorHerbStages(&bs, &ctx, 2, STAT_ATK, 6);
    EXPECT(ctx.opportunistStages[1][STAT_ATK], 12);
    return 0;
}
"""
        run_c(self, program)
        commands = (ROOT / "src/battle/battle_command.c").read_text()
        change = function(commands, "BtlCmd_ChangeStatStage")
        # Two Opportunists do not copy each other's copying for ever: the
        # stat command tells nobody of an Opportunist's own copy.
        self.assertIn("if (!(ctx->statChangeType == SIDE_EFFECT_TYPE_ABILITY && GetBattlerAbility(ctx, ctx->battlerIdStatChange) == ABILITY_OPPORTUNIST)) {\n"
                      "                RecordMirrorHerbStages(battleSystem, ctx, ctx->battlerIdStatChange, stat + 1, mon->statChanges[stat + 1] - stagesBefore);", change)
        # And the rises a script writes itself are told too.
        self.assertIn("RecordMirrorHerbStages(battleSystem, ctx, battlerId, stage - BMON_DATA_STAT_CHANGE_HP, var - before);", function(commands, "BtlCmd_UpdateMonData"))
        self.assertLess(change.index("int stagesBefore = mon->statChanges[stat + 1];"), change.index("mon->statChanges[stat + 1] += change;"))
        entry = function(OVERLAY, "TryAbilityOnEntry")
        self.assertIn("case 33: // Opportunist\n            flag = TryOpportunistCopy(battleSystem, ctx, &script);", entry)
        state = function(OVERLAY, "TryOpportunistCopy")
        # A foe's Dragon Cheer first, from the HP slot, with the move's line
        # (Pokemon Central, Scrocco and Grido del Drago).
        self.assertIn("for (j = STAT_HP; j < NUM_BATTLE_STATS; j++) {", state)
        self.assertIn("if (CopyDragonCheer(ctx, battlerId, cheer) == FALSE) {", state)
        self.assertIn("ctx->buffMsg.id = msg_0197_00276;", state)
        self.assertIn("*script = BATTLE_SUBSCRIPT_SHOW_PREPARED_MESSAGE;", state)
        self.assertIn("GetBattlerAbility(ctx, battlerId) != ABILITY_OPPORTUNIST", state)
        self.assertIn("ctx->statChangeParam = MOVE_SUBSCRIPT_PTR_ATTACK_UP_2_STAGES + j - STAT_ATK;", state)
        self.assertIn("ctx->statChangeParam = MOVE_SUBSCRIPT_PTR_ATTACK_UP_1_STAGE + j - STAT_ATK;", state)
        self.assertIn("ctx->statChangeType = SIDE_EFFECT_TYPE_ABILITY;", state)
        self.assertIn("*script = BATTLE_SUBSCRIPT_UPDATE_STAT_STAGE;", state)
        self.assertIn("MI_CpuClear8(ctx->opportunistStages[battlerId], NUM_BATTLE_STATS);", function(OVERLAY, "BattleSystem_GetBattleMon"))


class SymbiosisTests(unittest.TestCase):
    def test_a_used_up_item_is_replaced_from_the_partner_s_hands(self):
        commands = (ROOT / "src/battle/battle_command.c").read_text()
        remove = function(commands, "BtlCmd_RemoveItem")
        self.assertIn("ctx->symbiosisPending[battlerId] = TRUE;", remove)
        # Knocked off, stolen or burnt is not used up.
        for other in ("BtlCmd_TryKnockOff", "BtlCmd_TryStealItem", "BtlCmd_TrySwapItems"):
            if re.search(r"\nBOOL " + other + r"\(", commands):
                self.assertNotIn("symbiosisPending", function(commands, other), other)
        entry = function(OVERLAY, "TryAbilityOnEntry")
        self.assertIn("case 34: // Symbiosis\n            flag = TrySymbiosisHandOver(battleSystem, ctx, &script);", entry)
        state = function(OVERLAY, "TrySymbiosisHandOver")
        self.assertIn("ctx->symbiosisPending[battlerId] = FALSE;", state)
        self.assertIn("j = BattleSystem_GetBattlerIdPartner(battleSystem, battlerId);", state)
        for condition in ("j != battlerId", "ctx->battleMons[battlerId].hp", "ctx->battleMons[battlerId].item == ITEM_NONE",
                          "ctx->battleMons[j].hp", "GetBattlerAbility(ctx, j) == ABILITY_SYMBIOSIS",
                          "CanStealHeldItem(battleSystem, ctx, battlerId, j) == TRUE"):
            self.assertIn(condition, state)
        self.assertIn("ctx->battleMons[battlerId].item = ctx->battleMons[j].item;\n            ctx->battleMons[j].item = ITEM_NONE;", state)
        self.assertIn("*script = BATTLE_SUBSCRIPT_SYMBIOSIS;", state)
        self.assertIn("ctx->symbiosisPending[battlerId] = FALSE;", function(OVERLAY, "BattleSystem_GetBattleMon"))
        self.assertIn("TAG_NICKNAME_ITEM_NICKNAME, BATTLER_CATEGORY_MSG_BATTLER_TEMP, BATTLER_CATEGORY_MSG_TEMP, BATTLER_RELATIVE_ALLY|BATTLER_CATEGORY_MSG_BATTLER_TEMP",
                      subscript("Symbiosis"))


class PoisonPuppeteerTests(unittest.TestCase):
    """A Pokemon that Poison Puppeteer's Pokemon poisons with a move is
    confused as well (Pokemon Central, Malia Tossica)."""

    def test_a_move_s_poison_confuses(self):
        script = subscript("PoisonPuppeteer")
        body = script[script.index("_000:"):]
        confused = body.index("UpdateMonDataFromVar OPCODE_FLAG_ON, BATTLER_CATEGORY_SIDE_EFFECT_MON, BMON_DATA_STATUS2, BSCRIPT_VAR_CALC_TEMP")
        for check in ("SIDE_EFFECT_TYPE_ABILITY, _END", "SIDE_EFFECT_TYPE_HELD_ITEM, _END", "SIDE_EFFECT_TYPE_TOXIC_SPIKES, _END",
                      "CheckAbility CHECK_OPCODE_NOT_HAVE, BATTLER_CATEGORY_ATTACKER, ABILITY_POISON_PUPPETEER, _END",
                      "BMON_DATA_STATUS2, STATUS2_CONFUSION, _END", "ABILITY_OWN_TEMPO, _END", "SIDE_CONDITION_SAFEGUARD, _END"):
            self.assertLess(body.index(check), confused, check)
        self.assertIn("Random 3, 2", body)
        self.assertIn("PrintMessage msg_0197_00156, TAG_NICKNAME, BATTLER_CATEGORY_SIDE_EFFECT_MON", body)
        # After the poison has taken, in both poison subscripts.
        for name, status in (("Poison", "STATUS_POISON"), ("BadPoison", "STATUS_BAD_POISON")):
            text = subscript(name)
            self.assertLess(text.index(f"UpdateMonData OPCODE_FLAG_ON, BATTLER_CATEGORY_SIDE_EFFECT_MON, BMON_DATA_STATUS, {status}"),
                            text.index("Call BATTLE_SUBSCRIPT_POISON_PUPPETEER"), name)
            self.assertEqual(text.count("Call BATTLE_SUBSCRIPT_POISON_PUPPETEER"), 1, name)


class BallFetchTests(unittest.TestCase):
    def test_the_first_ball_that_failed_is_picked_up_once(self):
        commands = (ROOT / "src/battle/battle_command.c").read_text()
        task = function(commands, "Task_GetPokemon")
        kept = task[task.index("BattleSystem_CalculateBallShakes"):]
        kept = kept[:kept.index("data->ctx->ballFetchBall = data->ctx->itemTemp;")]
        self.assertIn("data->tempData[DATA_GET_POKEMON_BALL_SHAKES_TOTAL] < BALL_SHAKE_MAX", kept)
        self.assertIn("data->ctx->ballFetchBall == ITEM_NONE && !data->ctx->ballFetched", kept)
        self.assertIn("BATTLE_TYPE_BUG_CONTEST | BATTLE_TYPE_SAFARI | BATTLE_TYPE_PAL_PARK", kept)
        entry = function(OVERLAY, "TryAbilityOnEntry")
        state = entry[entry.index("// Ball Fetch"):]
        state = state[:state.index("case ", 10)]
        self.assertIn("BattleSystem_GetFieldSide(battleSystem, battlerId) == 0 && ctx->battleMons[battlerId].hp && ctx->battleMons[battlerId].item == ITEM_NONE && GetBattlerAbility(ctx, battlerId) == ABILITY_BALL_FETCH", state)
        self.assertIn("ctx->battleMons[battlerId].item = ctx->ballFetchBall;", state)
        self.assertIn("ctx->ballFetched = TRUE;", state)
        self.assertIn("script = BATTLE_SUBSCRIPT_BALL_FETCH;", state)
        self.assertIn("msg_0197_00589, TAG_NICKNAME_ITEM, BATTLER_CATEGORY_MSG_BATTLER_TEMP, BATTLER_CATEGORY_MSG_TEMP", subscript("BallFetch"))
        # Asked straight after a ball that did not catch.
        throw = sorted(SUBSCRIPTS.glob("subscript_0011_*.s"))[0].read_text()
        after = label(throw, "_060")
        self.assertIn("BATTLE_RESULT_CAPTURED_MON, _END", after)
        self.assertIn("SwitchInAbilityCheck _END", after)
        self.assertIn("CallFromVar BSCRIPT_VAR_TEMP_DATA", after)


class AbilityShieldTests(unittest.TestCase):
    """An Ability Shield keeps its holder's ability from being changed,
    removed or suppressed by any effect (Pokemon Central, Scudo abilita):
    the moves that change or suppress the target's or the user's, and the
    abilities that change their own or the attacker's."""

    SHIELD = "BMON_DATA_HELD_ITEM, ITEM_ABILITY_SHIELD"

    def test_every_ability_changing_move_asks_it(self):
        for name, holders in (("CopyAbility", ["ATTACKER"]), ("SwapAbility", ["ATTACKER", "DEFENDER"]),
                              ("GastroAcid", ["DEFENDER"]), ("WorrySeed", ["DEFENDER"]),
                              ("GiveTargetSimple", ["DEFENDER"]), ("Entrainment", ["DEFENDER"])):
            script = subscript(name)
            for holder in holders:
                line = f"CompareMonDataToValue OPCODE_EQU, BATTLER_CATEGORY_{holder}, {self.SHIELD}"
                self.assertIn(line, script, (name, holder))
                # Asked before the ability is written or suppressed.
                change = re.search(r"UpdateMonData(FromVar)? OPCODE_(SET|FLAG_ON), BATTLER_CATEGORY_\w+, "
                                   r"BMON_DATA_(ABILITY|MOVE_EFFECT, MOVE_EFFECT_FLAG_ABILITY_SUPPRESSED)", script)
                self.assertLess(script.index(line), change.start(), (name, holder))
        failed = label(subscript("Entrainment"), "_FAILED")
        self.assertIn("UpdateVar OPCODE_FLAG_ON, BSCRIPT_VAR_MOVE_STATUS_FLAGS, MOVE_STATUS_FAILED", failed)

    def test_the_abilities_that_change_an_ability_ask_it(self):
        hit = function(OVERLAY, "CheckAbilityEffectOnHit")
        mummy = hit[hit.index("    case ABILITY_MUMMY:\n    case ABILITY_LINGERING_AROMA:"):]
        mummy = mummy[:mummy.index("break;")]
        self.assertIn("!BattlerHasAbilityShield(ctx, ctx->battlerIdAttacker)", mummy)
        entry = function(OVERLAY, "TryAbilityOnEntry")
        trace = [line for line in entry.splitlines() if "== ABILITY_TRACE) {" in line]
        self.assertEqual(len(trace), 1)
        self.assertIn("!BattlerHasAbilityShield(ctx, battlerId)", trace[0])


if __name__ == "__main__":
    unittest.main()
