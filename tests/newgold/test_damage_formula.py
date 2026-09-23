#!/usr/bin/env python3
"""Run the damage chain with a worked example for each step.

DamageCalcDefault, its final modifier and the type chart's single verdict are
extracted from the port's C and run on the host around a stubbed base damage.
The order and the rounding are the reference's CalcDamageOverall
(battle_calc_damage.c at d0380a487), Q4.12 throughout, not HeartGold's
integer pipeline. Each expected number below is worked by hand from the
reference's arithmetic, not read back from the code.
"""

import os
from pathlib import Path
import re
import shlex
import subprocess
import tempfile
import unittest

from test_repels import ROOT, function

COMMANDS = (ROOT / "src/battle/battle_command.c").read_text()
OVERLAY = (ROOT / "src/battle/overlay_12_0224E4FC.c").read_text()
HEADER = (ROOT / "include/battle/overlay_12_0224E4FC.h").read_text()
CONTROLLER = (ROOT / "src/battle/battle_controller_player.c").read_text()

FIXTURE = r"""
#include <assert.h>
#include <stdint.h>
#include <stdio.h>
#include <string.h>
#include "constants/abilities.h"
#include "constants/battle.h"
#include "constants/items.h"
#include "constants/move_effects.h"
#include "constants/moves.h"
#include "constants/pokemon.h"
typedef uint8_t u8; typedef uint16_t u16; typedef uint32_t u32; typedef int32_t s32;
typedef int BOOL;
#define TRUE 1
#define FALSE 0
#define NELEMS(a) (sizeof(a) / sizeof(*(a)))
@UQ412@

typedef struct { int unused; } BattleSystem;
typedef struct { u32 speed; } Pokemon;
typedef struct {
    int hp; u32 maxHp; u32 status; u32 status2; u32 moveEffectFlags; u8 type3;
    struct { int meFirstFlag, meFirstCount, metronomeTurns, magnetRiseTurns; } unk88;
} BattleMon;
typedef struct {
    int battlerIdAttacker, battlerIdTarget;
    u32 moveNoCur; int moveType; u16 movePower;
    u32 fieldCondition; u32 fieldSideConditionFlags[2];
    int criticalMultiplier; int damage; int meFirstTotal; u32 battleStatus;
    BattleMon battleMons[4];
    struct { int glaiveRush; } moveConditions[4];
    struct { int protectFlag, roostFlag; } turnData[4];
    u8 teraShellResisting;
    struct { u32 unk14; } selfTurnData[4];
    u8 selectedMonIndex[4];
} BattleContext;
typedef struct { int range, category, effect, power; } MoveTbl;

// The scenario every stub answers from.
static struct {
    u32 base; u32 battleType; int maxBattlers; int hitCount; u16 random; int cloudNine; int secondStrike;
    int ability[4]; int item[4]; int types[4][2];
    MoveTbl move; int contact, sound;
    int adjustedType, substitute, unnerve, ripen;
    u32 speed[4];
} S;

static const MoveTbl *BattleMoveTbl(BattleContext *ctx, u32 moveNo) { (void)ctx; (void)moveNo; return &S.move; }
static int CalcMoveDamage(BattleSystem *bs, BattleContext *ctx, u32 moveNo, u32 side, u32 field, u16 power, u8 type, u8 a, u8 t, u8 crit) {
    (void)bs; (void)ctx; (void)moveNo; (void)side; (void)field; (void)power; (void)type; (void)a; (void)t; (void)crit;
    return S.base;
}
// A type change such as Pixilate's, when the scenario asks for one.
static u8 BattleMoveAdjustedType(BattleContext *ctx, int battlerId, u32 moveNo) { (void)battlerId; (void)moveNo; return S.adjustedType ? S.adjustedType : ctx->moveType; }
static u8 BattleMoveTypeForAbility(BattleContext *ctx, int ability, u32 moveNo, int moveTypeDefault) { (void)ctx; (void)ability; (void)moveNo; return S.adjustedType ? S.adjustedType : moveTypeDefault; }
// Each battler's Speed as its summary shows it.
static Pokemon mons[4];
static Pokemon *BattleSystem_GetPartyMon(BattleSystem *bs, int battlerId, int slot) { (void)bs; (void)slot; mons[battlerId].speed = S.speed[battlerId]; return &mons[battlerId]; }
static u32 GetMonData(Pokemon *mon, int attr, void *out) { (void)out; assert(attr == MON_DATA_SPEED); return mon->speed; }
static BOOL SubstituteTakesHit(BattleContext *ctx, int battlerId) { (void)ctx; (void)battlerId; return S.substitute; }
static BOOL BerryCanBeEaten(BattleSystem *bs, BattleContext *ctx, int battlerId, int *boost) {
    (void)bs; (void)ctx; (void)battlerId;
    if (S.unnerve) return FALSE;
    if (S.ripen) *boost *= 2;
    return TRUE;
}
static int BattleSystem_GetFieldSide(BattleSystem *bs, int battlerId) { (void)bs; return battlerId & 1; }
static u32 BattleSystem_GetBattleType(BattleSystem *bs) { (void)bs; return S.battleType; }
static int BattleSystem_GetMaxBattlers(BattleSystem *bs) { (void)bs; return S.maxBattlers; }
static u8 GetMonsHitCount(BattleSystem *bs, BattleContext *ctx, u32 flag, int battlerId) { (void)bs; (void)ctx; (void)flag; (void)battlerId; return S.hitCount; }
static int CheckAbilityActive(BattleSystem *bs, BattleContext *ctx, int flag, int battlerId, int ability) {
    (void)bs; (void)ctx; (void)flag; (void)battlerId; return S.cloudNine && ability == ABILITY_CLOUD_NINE;
}
static u16 BattleSystem_Random(BattleSystem *bs) { (void)bs; return S.random; }
static u16 GetBattlerAbility(BattleContext *ctx, int battlerId) { (void)ctx; return S.ability[battlerId]; }
static BOOL CheckBattlerAbilityIfNotIgnored(BattleContext *ctx, int attacker, int target, int ability) {
    (void)ctx; return S.ability[attacker] != ABILITY_MOLD_BREAKER && S.ability[target] == ability;
}
static int GetBattlerHeldItemEffect(BattleContext *ctx, int battlerId) { (void)ctx; return S.item[battlerId]; }
static BOOL BattleMoveMakesContact(BattleContext *ctx, u32 moveNo) { (void)ctx; (void)moveNo; return S.contact; }
static BOOL BattleMoveIsSoundBased(u32 moveNo) { (void)moveNo; return S.sound; }
static int GetBattlerVar(BattleContext *ctx, int battlerId, u32 varId, void *data) {
    (void)ctx; (void)data; return S.types[battlerId][varId == BMON_DATA_TYPE_2];
}
static int ov12_02258440(BattleContext *ctx, int moveNo) { (void)ctx; (void)moveNo; return TRUE; }
static BOOL ParentalBond_IsSecondStrike(BattleContext *ctx) { (void)ctx; return S.secondStrike; }
static u32 MaskOfFlagNo(int flagNo) { return 1u << flagNo; }

@OVERLAY@
@COMMANDS@

static BattleContext ctx;
static BattleSystem bs;

static void reset(void) {
    memset(&S, 0, sizeof(S));
    memset(&ctx, 0, sizeof(ctx));
    S.base = 45;
    S.maxBattlers = 2;
    S.move = (MoveTbl){ RANGE_SINGLE_TARGET, CATEGORY_PHYSICAL, MOVE_EFFECT_HIT, 80 };
    for (int i = 0; i < 4; i++) {
        S.types[i][0] = S.types[i][1] = TYPE_NORMAL;
        ctx.battleMons[i].hp = 100;
        ctx.battleMons[i].maxHp = 100;
        ctx.battleMons[i].type3 = TYPE_NONE;
    }
    ctx.battlerIdAttacker = 0;
    ctx.battlerIdTarget = 1;
    ctx.moveType = TYPE_FIRE;
    ctx.criticalMultiplier = 1;
}

static int calc(void) {
    DamageCalcDefault(&bs, &ctx, TRUE);
    return ctx.damage;
}

#define EXPECT(what, expected) do { int got_ = (what); if (got_ != (expected)) { \
    fprintf(stderr, "%s:%d: %s is %d, expected %d\n", __FILE__, __LINE__, #what, got_, (expected)); return 1; } } while (0)

int main(void) {
    // The helpers: (v * q + 0x800) >> 12 and (v * q + 0x7FF) >> 12, and 1.0
    // hands the value back.
    EXPECT(QMul_RoundUp(3, UQ412__0_5), 2);
    EXPECT(QMul_RoundDown(3, UQ412__0_5), 1);
    EXPECT(QMul_RoundDown(0x7FFFF, UQ412__1_0), 0x7FFFF);

    // Nothing but the base: 45.
    reset(); EXPECT(calc(), 45);

    // 6.1 spread, 0.75 rounded: 45 * 3072 = 138240, + 2047 >> 12 = 34.
    // HeartGold's 3/4 truncated to 33.
    reset(); S.battleType = BATTLE_TYPE_DOUBLES; S.hitCount = 2; S.move.range = RANGE_ADJACENT_OPPONENTS;
    EXPECT(calc(), 34);

    // 6.2 Parental Bond's second strike, 0.25 rounded down: 46080 + 2047 >> 12
    // = 11.
    reset(); S.secondStrike = TRUE; EXPECT(calc(), 11);

    // 6.3 weather: a Water move in the rain, 45 * 1.5 = 67.5, down to 67;
    // Cloud Nine takes it away.
    reset(); ctx.moveType = TYPE_WATER; ctx.fieldCondition = FIELD_CONDITION_RAIN_ALL; EXPECT(calc(), 67);
    S.cloudNine = TRUE; EXPECT(calc(), 45);
    // Mega Sol's user sees harsh sunlight whatever the field has, Cloud Nine
    // included: its Fire move 67 and its Water move 22, in the rain too.
    reset(); S.ability[0] = ABILITY_MEGA_SOL; EXPECT(calc(), 67);
    ctx.moveType = TYPE_WATER; ctx.fieldCondition = FIELD_CONDITION_RAIN_ALL; EXPECT(calc(), 22);
    S.cloudNine = TRUE; EXPECT(calc(), 22);

    // 6.3.5 Glaive Rush on the target: 90.
    reset(); ctx.moveConditions[1].glaiveRush = TRUE; EXPECT(calc(), 90);

    // 6.4 a critical hit, * 150 / 100: 67.
    reset(); ctx.criticalMultiplier = 2; EXPECT(calc(), 67);

    // 6.5 the roll at its lowest, * 85 / 100: 38. The raw calculation has none.
    reset(); S.random = 15; EXPECT(calc(), 38);
    DamageCalcDefault(&bs, &ctx, FALSE); EXPECT(ctx.damage, 45);

    // 6.6 STAB, 1.5 rounded down: 67; Adaptability 2.0: 90.
    reset(); S.types[0][0] = TYPE_FIRE; EXPECT(calc(), 67);
    S.ability[0] = ABILITY_ADAPTABILITY; EXPECT(calc(), 90);

    // 6.7 one verdict from the whole chart. Fire into Water/Grass is neutral
    // and stays 45; HeartGold went row by row, 45 -> 22 -> 44.
    reset(); S.types[1][0] = TYPE_WATER; S.types[1][1] = TYPE_GRASS; EXPECT(calc(), 45);
    reset(); S.types[1][0] = S.types[1][1] = TYPE_GRASS; EXPECT(calc(), 90);
    reset(); S.types[1][0] = S.types[1][1] = TYPE_WATER; EXPECT(calc(), 22);
    reset(); S.types[1][0] = TYPE_WATER; S.types[1][1] = TYPE_ROCK; EXPECT(calc(), 11);
    reset(); S.types[1][0] = TYPE_GRASS; S.types[1][1] = TYPE_BUG; EXPECT(calc(), 180);
    // Delta Stream's winds take the Flying weakness out: Rock into Flying 45
    // rather than 90, into Fire/Flying 90 rather than 180; not under Cloud
    // Nine, and they say so only where they did something.
    reset(); ctx.moveType = TYPE_ROCK; S.types[1][0] = S.types[1][1] = TYPE_FLYING; EXPECT(calc(), 90);
    ctx.fieldCondition = FIELD_CONDITION_STRONG_WINDS; EXPECT(calc(), 45);
    EXPECT(StrongWindsWeakenMove(&bs, &ctx, 0, 1, 0, TYPE_ROCK), TRUE);
    EXPECT(StrongWindsWeakenMove(&bs, &ctx, 0, 1, 0, TYPE_NORMAL), FALSE);
    ctx.turnData[1].roostFlag = TRUE; EXPECT(StrongWindsWeakenMove(&bs, &ctx, 0, 1, 0, TYPE_ROCK), FALSE);
    ctx.turnData[1].roostFlag = FALSE;
    S.types[1][0] = TYPE_FIRE; EXPECT(calc(), 90);
    S.cloudNine = TRUE; EXPECT(calc(), 180);
    EXPECT(StrongWindsWeakenMove(&bs, &ctx, 0, 1, 0, TYPE_ROCK), FALSE);
    reset(); ctx.moveType = TYPE_ROCK; ctx.fieldCondition = FIELD_CONDITION_STRONG_WINDS; S.types[1][0] = S.types[1][1] = TYPE_FIRE;
    EXPECT(calc(), 90);
    EXPECT(StrongWindsWeakenMove(&bs, &ctx, 0, 1, 0, TYPE_ROCK), FALSE);
    // Tera Shell at full HP makes it not very effective, whatever the chart
    // said, 22; not with a point of HP gone, 180, nor where the chart says no
    // effect.
    reset(); S.types[1][0] = TYPE_GRASS; S.types[1][1] = TYPE_BUG; S.ability[1] = ABILITY_TERA_SHELL; EXPECT(calc(), 22);
    ctx.battleMons[1].hp = 99; EXPECT(calc(), 180);
    reset(); S.types[1][0] = S.types[1][1] = TYPE_GHOST; S.ability[1] = ABILITY_TERA_SHELL; ctx.moveType = TYPE_NORMAL;
    EXPECT(calc(), 1);

    // The flags the scripts and the AI read still come out of the same walk.
    {
        u32 flags = 0;
        int effectiveness;
        reset(); S.types[1][0] = TYPE_WATER; S.types[1][1] = TYPE_GRASS;
        EXPECT(CalcTypeEffectiveness(&bs, &ctx, 0, TYPE_FIRE, 0, 1, 45, &flags, &effectiveness), 45);
        EXPECT(effectiveness, 8);
        EXPECT((int)(flags & (MOVE_STATUS_SUPER_EFFECTIVE | MOVE_STATUS_NOT_VERY_EFFECTIVE)), 0);
        flags = 0; S.types[1][1] = TYPE_WATER;
        EXPECT(CalcTypeEffectiveness(&bs, &ctx, 0, TYPE_FIRE, 0, 1, 45, &flags, &effectiveness), 22);
        EXPECT(effectiveness, 4);
        EXPECT((int)(flags & MOVE_STATUS_NOT_VERY_EFFECTIVE) != 0, 1);
    }

    // 6.8 a burn halves a physical move: 22. Guts is spared; a special move is
    // not touched.
    reset(); ctx.battleMons[0].status = STATUS_BURN; EXPECT(calc(), 22);
    S.ability[0] = ABILITY_GUTS; EXPECT(calc(), 45);
    S.ability[0] = ABILITY_NONE; S.move.category = CATEGORY_SPECIAL; EXPECT(calc(), 45);
    // Nor is Facade, which the burn powers instead.
    S.move.category = CATEGORY_PHYSICAL; ctx.moveNoCur = MOVE_FACADE; EXPECT(calc(), 45);

    // 6.9.1 the screens, in the final modifier: half in a single battle, 22.
    // A critical hit goes through them: 67.
    reset(); ctx.fieldSideConditionFlags[1] = SIDE_CONDITION_REFLECT; EXPECT(calc(), 22);
    ctx.criticalMultiplier = 2; EXPECT(calc(), 67);
    // A double battle: 2732, 45 * 2732 = 122940, + 2047 >> 12 = 30 -- with
    // two on the target's side or with one, where HeartGold halved, 22.
    reset(); ctx.fieldSideConditionFlags[1] = SIDE_CONDITION_LIGHT_SCREEN; S.move.category = CATEGORY_SPECIAL;
    S.battleType = BATTLE_TYPE_DOUBLES; S.hitCount = 2; EXPECT(calc(), 30);
    S.hitCount = 1; EXPECT(calc(), 30);

    // 6.9.14.1 a stamping move into a Minimized target doubles: 90. Any
    // other move, 45.
    reset(); ctx.battleMons[1].moveEffectFlags = MOVE_EFFECT_FLAG_MINIMIZE; ctx.moveNoCur = MOVE_BODY_SLAM; EXPECT(calc(), 90);
    ctx.moveNoCur = MOVE_HEAVY_SLAM; EXPECT(calc(), 90);
    ctx.moveNoCur = MOVE_TACKLE; EXPECT(calc(), 45);

    // 6.9.14.45 Collision Course and Electro Drift, 5461 on a super-effective
    // hit: 90 * 5461 = 491490, + 2047 >> 12 = 120. Neutral, 45.
    reset(); ctx.moveNoCur = MOVE_COLLISION_COURSE; S.types[1][0] = S.types[1][1] = TYPE_GRASS; EXPECT(calc(), 120);
    reset(); ctx.moveNoCur = MOVE_ELECTRO_DRIFT; EXPECT(calc(), 45);
    // Over Reflect the two are one factor, 5461 * 2048 rounded up = 2731:
    // 90 * 2731 = 245790, + 2047 >> 12 = 60.
    reset(); ctx.moveNoCur = MOVE_COLLISION_COURSE; S.types[1][0] = S.types[1][1] = TYPE_GRASS;
    ctx.fieldSideConditionFlags[1] = SIDE_CONDITION_REFLECT; EXPECT(calc(), 60);

    // 6.9.4 Tinted Lens doubles a resisted hit: Fire into Water, 22 -> 44.
    reset(); S.types[1][0] = S.types[1][1] = TYPE_WATER; S.ability[0] = ABILITY_TINTED_LENS; EXPECT(calc(), 44);
    // 6.9.2 Neuroforce, 1.25 on a super-effective one: 90 -> 112.
    reset(); S.types[1][0] = S.types[1][1] = TYPE_GRASS; S.ability[0] = ABILITY_NEUROFORCE; EXPECT(calc(), 112);
    // 6.9.8 Filter, 0.75 on it: 90 * 3072, + 2047 >> 12 = 67. Mold Breaker
    // gets through Filter and not Prism Armor.
    reset(); S.types[1][0] = S.types[1][1] = TYPE_GRASS; S.ability[1] = ABILITY_FILTER; EXPECT(calc(), 67);
    S.ability[0] = ABILITY_MOLD_BREAKER; EXPECT(calc(), 90);
    S.ability[1] = ABILITY_PRISM_ARMOR; EXPECT(calc(), 67);
    // 6.9.3 Sniper: a critical 67, then 1.5 in the modifier, 67 * 6144 =
    // 411648, + 2047 >> 12 = 100.
    reset(); ctx.criticalMultiplier = 3; EXPECT(calc(), 100);
    // 6.9.6 and 6.9.10 Fluffy: a contact move is halved, 22; a Fire one
    // doubled, 90; a contact Fire one both, 45.
    reset(); S.ability[1] = ABILITY_FLUFFY; ctx.moveType = TYPE_WATER; S.contact = TRUE; EXPECT(calc(), 22);
    S.contact = FALSE; ctx.moveType = TYPE_FIRE; EXPECT(calc(), 90);
    S.contact = TRUE; EXPECT(calc(), 45);
    // 6.9.5 Multiscale at full health: 22; one hit point down, 45.
    reset(); S.ability[1] = ABILITY_MULTISCALE; EXPECT(calc(), 22);
    ctx.battleMons[1].hp = 99; EXPECT(calc(), 45);
    // 6.9.15 Punk Rock on a sound move: 22.
    reset(); S.ability[1] = ABILITY_PUNK_ROCK; S.sound = TRUE; EXPECT(calc(), 22);
    // 6.9.16 Ice Scales halves a special move once, in a double battle too:
    // 22, where the reference's loop would quarter or sixteenth it.
    reset(); S.ability[1] = ABILITY_ICE_SCALES; S.move.category = CATEGORY_SPECIAL; EXPECT(calc(), 22);
    S.battleType = BATTLE_TYPE_DOUBLES; S.maxBattlers = 4; EXPECT(calc(), 22);
    // 6.9.7 Friend Guard on the target's living ally: 34; a fainted one, 45.
    reset(); S.battleType = BATTLE_TYPE_DOUBLES; S.maxBattlers = 4; S.ability[3] = ABILITY_FRIEND_GUARD; EXPECT(calc(), 34);
    ctx.battleMons[3].hp = 0; EXPECT(calc(), 45);
    // 6.9.9 the Metronome item: 1.2 a use in a row. Once, 4915: 45 * 4915 =
    // 221175, + 2047 >> 12 = 54. Three times, 6553: 72. Five and past it,
    // 2.0: 90. HeartGold's tenth a use would be 49, 58 and 67.
    reset(); S.item[0] = HOLD_EFFECT_BOOST_REPEATED; ctx.battleMons[0].unk88.metronomeTurns = 1; EXPECT(calc(), 54);
    ctx.battleMons[0].unk88.metronomeTurns = 3; EXPECT(calc(), 72);
    ctx.battleMons[0].unk88.metronomeTurns = 5; EXPECT(calc(), 90);
    ctx.battleMons[0].unk88.metronomeTurns = 10; EXPECT(calc(), 90);
    // 6.9.11 an Expert Belt on a super-effective hit: 90 * 4915 = 442350,
    // + 2047 >> 12 = 108. Nothing on a neutral one.
    reset(); S.types[1][0] = S.types[1][1] = TYPE_GRASS; S.item[0] = HOLD_EFFECT_POWER_UP_SE; EXPECT(calc(), 108);
    reset(); S.item[0] = HOLD_EFFECT_POWER_UP_SE; EXPECT(calc(), 45);
    // 6.9.13 a type-resist Berry halves a super-effective hit of its type in
    // the chain -- 90 to 45 -- and marks the target for UpdateHp to eat it.
    // A neutral hit leaves it alone.
    reset(); S.types[1][0] = S.types[1][1] = TYPE_GRASS; S.item[1] = HOLD_EFFECT_WEAKEN_SE_FIRE; EXPECT(calc(), 45);
    EXPECT((ctx.selfTurnData[1].unk14 & SELF_TURN_FLAG_RESIST_BERRY) != 0, 1);
    reset(); S.item[1] = HOLD_EFFECT_WEAKEN_SE_FIRE; EXPECT(calc(), 45);
    EXPECT((int)(ctx.selfTurnData[1].unk14 & SELF_TURN_FLAG_RESIST_BERRY), 0);
    // The Chilan Berry takes any Normal hit: a neutral one with STAB, 67,
    // halved to 33.
    reset(); ctx.moveType = TYPE_NORMAL; S.item[1] = HOLD_EFFECT_WEAKEN_NORMAL; EXPECT(calc(), 33);
    // The type is the one the move lands with: a Normal move a Pixilate made
    // Fairy wakes a Roseli Berry on a Dragon, 90 to 45.
    reset(); ctx.moveType = TYPE_NORMAL; S.adjustedType = TYPE_FAIRY; S.types[1][0] = S.types[1][1] = TYPE_DRAGON;
    S.item[1] = HOLD_EFFECT_WEAKEN_SE_FAIRY; EXPECT(calc(), 45);
    // Not behind a substitute that takes the hit, not under Unnerve: 90.
    // Ripen makes it a quarter: 90 * 1024, + 2047 >> 12 = 22.
    reset(); S.types[1][0] = S.types[1][1] = TYPE_GRASS; S.item[1] = HOLD_EFFECT_WEAKEN_SE_FIRE; S.substitute = TRUE; EXPECT(calc(), 90);
    EXPECT((int)(ctx.selfTurnData[1].unk14 & SELF_TURN_FLAG_RESIST_BERRY), 0);
    S.substitute = FALSE; S.unnerve = TRUE; EXPECT(calc(), 90);
    S.unnerve = FALSE; S.ripen = TRUE; EXPECT(calc(), 22);

    // 6.9.12 a Life Orb, 5324: 58.
    reset(); S.item[0] = HOLD_EFFECT_HP_DRAIN_ON_ATK; EXPECT(calc(), 58);
    // The final modifier is one number, rounded up at each link, and touches
    // the damage once. Reflect and Multiscale together are a quarter: 47 ->
    // 12, where halving twice would be 23 -> 11. A Life Orb over Reflect is
    // 2048 * 5324 rounded up, 2662: 44 -> 29, where the Orb and then the
    // halving would be 57 -> 28.
    reset(); ctx.fieldSideConditionFlags[1] = SIDE_CONDITION_REFLECT; S.ability[1] = ABILITY_MULTISCALE; S.base = 47;
    EXPECT(calc(), 12);
    reset(); ctx.fieldSideConditionFlags[1] = SIDE_CONDITION_REFLECT; S.item[0] = HOLD_EFFECT_HP_DRAIN_ON_ATK; S.base = 44;
    EXPECT(calc(), 29);

    // The battlers are taken by raw Speed, and the rounding at each link
    // shows the order. Sniper's 6144, then a Metronome item's first 4915 and
    // a Chilan Berry's 2048: the attacker first, 6144 * 4915 rounds to 7373
    // and * 2048 to 3687; the target first, 6144 * 2048 is 3072 and * 4915
    // rounds to 3686.
    reset(); ctx.criticalMultiplier = 3; S.item[0] = HOLD_EFFECT_BOOST_REPEATED; ctx.battleMons[0].unk88.metronomeTurns = 1;
    S.item[1] = HOLD_EFFECT_WEAKEN_NORMAL;
    S.speed[0] = 100; S.speed[1] = 50; EXPECT((int)FinalDamageModifier(&bs, &ctx, TYPE_NORMAL, 8), 3687);
    S.speed[0] = 50; S.speed[1] = 100; EXPECT((int)FinalDamageModifier(&bs, &ctx, TYPE_NORMAL, 8), 3686);
    // A tie goes to the player's side, whichever is attacking.
    S.speed[0] = S.speed[1] = 80; EXPECT((int)FinalDamageModifier(&bs, &ctx, TYPE_NORMAL, 8), 3687);
    ctx.battlerIdAttacker = 1; ctx.battlerIdTarget = 0; S.item[1] = HOLD_EFFECT_BOOST_REPEATED; S.item[0] = HOLD_EFFECT_WEAKEN_NORMAL;
    ctx.battleMons[1].unk88.metronomeTurns = 1; EXPECT((int)FinalDamageModifier(&bs, &ctx, TYPE_NORMAL, 8), 3686);

    // Four at one Speed: the player's left, its right, the far left, the far
    // right -- 0, 2, 3, 1. Otherwise the fastest first.
    {
        int order[4];
        reset(); S.maxBattlers = 4;
        EXPECT(RawSpeedOrder(&bs, &ctx, order), 4);
        EXPECT(order[0] * 1000 + order[1] * 100 + order[2] * 10 + order[3], 231);
        S.speed[0] = 10; S.speed[1] = 40; S.speed[2] = 30; S.speed[3] = 20;
        RawSpeedOrder(&bs, &ctx, order);
        EXPECT(order[0] * 1000 + order[1] * 100 + order[2] * 10 + order[3], 1230);
    }

    // Step 10.1 Unseen Fist into a Protect: a quarter, 45 * 1024 = 46080,
    // + 2047 >> 12 = 11.
    reset(); S.ability[0] = ABILITY_UNSEEN_FIST; ctx.turnData[1].protectFlag = TRUE; EXPECT(calc(), 11);

    // Step 11: at least 1. A base of 1 in the rain for a Fire move is
    // 1 * 2048 + 2047 >> 12 = 0 there, and 1 at the end.
    reset(); S.base = 1; ctx.fieldCondition = FIELD_CONDITION_RAIN_ALL; EXPECT(calc(), 1);
    // Step 12: 16 bits. 40000 with STAB into a Grass type is 120000, and
    // 120000 - 65536 = 54464.
    reset(); S.base = 40000; S.types[0][0] = TYPE_FIRE; S.types[1][0] = S.types[1][1] = TYPE_GRASS; EXPECT(calc(), 54464);

    return 0;
}
"""


def table(source, name):
    match = re.search(r"^static const u8 " + name + r"\[\]\[3\] = \{.*?^\};", source, re.M | re.S)
    if match is None:
        raise ValueError(f"table not found: {name}")
    return match.group(0)


def move_list(source, name):
    return re.search(r"^static const u16 " + name + r"\[\] = \{.*?^\};", source, re.M | re.S).group(0)


def program():
    uq412 = "\n".join(re.findall(r"^#define UQ412__\w+\s+\d+$", HEADER, re.M))
    enum = re.search(r"^enum \{\n    TYPETABLE_ATTACKER,.*?^\};", OVERLAY, re.M | re.S).group(0)
    overlay = "\n".join([enum, table(OVERLAY, "sTypeEffectiveness"), move_list(OVERLAY, "sMinimizeVulnerableMoves")] + [
        function(OVERLAY, name) for name in (
            "QMul_RoundUp", "QMul_RoundDown", "ov12_02251C74", "ov12_022583B4", "TeraShellResists",
            "BattlerMoveWeather", "StrongWindsShelterRow", "StrongWindsFor", "StrongWindsWeakenMove",
            "CalcTypeEffectiveness", "MoveIsInList", "BattleMoveStampsOnMinimize")])
    commands = "\n".join(function(COMMANDS, name) for name in (
        "ScreenModifier", "ResistBerryType", "ResistBerryModifier", "RawSpeedGoesFirst", "RawSpeedOrder",
        "FinalDamageModifier", "DamageCalcDefault"))
    return (FIXTURE.replace("@UQ412@", uq412)
            .replace("@OVERLAY@", overlay.replace("BOOL ov12_02251C74", "static BOOL ov12_02251C74")
                     .replace("int CalcTypeEffectiveness", "static int CalcTypeEffectiveness")
                     .replace("BOOL TeraShellResists", "static BOOL TeraShellResists")
                     .replace("u32 BattlerMoveWeather", "static u32 BattlerMoveWeather")
                     .replace("BOOL StrongWindsWeakenMove", "static BOOL StrongWindsWeakenMove")
                     .replace("u32 QMul_", "static u32 QMul_")
                     .replace("BOOL BattleMoveStampsOnMinimize", "static BOOL BattleMoveStampsOnMinimize"))
            .replace("@COMMANDS@", commands))


class DamageFormulaTests(unittest.TestCase):
    def test_each_step_of_the_chain_has_its_worked_example(self):
        with tempfile.TemporaryDirectory(prefix="newgold-damage-") as directory:
            path = Path(directory)
            (path / "test.c").write_text(program())
            subprocess.run(shlex.split(os.environ.get("CC", "cc")) + [
                "-std=c99", "-Wall", "-Werror", "-Wno-unused-function", "-fsanitize=undefined",
                "-fno-sanitize-recover", "-iquote", str(ROOT / "include"),
                str(path / "test.c"), "-o", str(path / "test")], check=True)
            result = subprocess.run([str(path / "test")], capture_output=True, text=True)
            self.assertEqual(result.returncode, 0, result.stderr)

    def test_the_base_damage_ends_at_plus_two(self):
        # CalcMoveDamage is the reference's CalcBaseDamage: the burn, the
        # screens, the spread, the weather, Flash Fire, Unseen Fist and Glaive
        # Rush are all DamageCalcDefault's now, and the two asm callers (the AI)
        # get the base alone, as the reference's AI does.
        body = function(OVERLAY, "CalcMoveDamage")
        tail = body[body.rindex("dmg /= 50;"):]
        self.assertNotIn("dmg =", tail)
        self.assertNotIn("dmg *=", tail)
        self.assertNotIn("dmg /=", tail[len("dmg /= 50;"):])
        for gone in ("STATUS_BURN) && calcAttacker.ability != ABILITY_GUTS", "SIDE_CONDITION_REFLECT",
                     "SIDE_CONDITION_LIGHT_SCREEN", "glaiveRush", "protectFlag"):
            self.assertNotIn(gone, body)
        # What moved into the base is where the reference has it: Me First and
        # Solar Beam on the power, Flash Fire on the attacking stat.
        self.assertRegex(body, r"meFirstFlag[^\n]*\) \{\n\s*movePower = movePower \* 15 / 10;")
        self.assertRegex(body, r"MOVE_SOLAR_BEAM\) \{\n\s*movePower /= 2;")
        self.assertRegex(body, r"BMON_DATA_FLASH_FIRE[^\n]*\) \{\n\s*monAtk = monAtk \* 150 / 100;\n\s*monSpAtk = monSpAtk \* 150 / 100;")

    def test_the_controller_takes_only_the_flags(self):
        # The damage of a hit is final when the controller walks the chart
        # again; applying it a second time would square the type multiplier.
        for body in (function(CONTROLLER, "ov12_0224B498"), function(COMMANDS, "BtlCmd_ApplyTypeEffectiveness")):
            self.assertIn("ov12_02251D28(", body)
            self.assertNotIn("ctx->damage = ov12_02251D28(", body)

    def test_a_stamping_move_never_misses_a_minimized_target(self):
        # other_battle_calculators.c:2892: sure to hit, and doubled only in the
        # final modifier, so Stomp's script no longer doubles its power too.
        body = function(CONTROLLER, "BattleSystem_CheckMoveEffect")
        self.assertRegex(body, r"MOVE_EFFECT_FLAG_MINIMIZE\) && BattleMoveStampsOnMinimize\(move\)\) \{\n\s*ctx->moveStatusFlag &= ~MOVE_STATUS_MISSED;")
        stomp = (ROOT / "files/battledata/script/effect_script/effect_script_0150.s").read_text()
        self.assertNotIn("BSCRIPT_VAR_POWER_MULTI, 20", stomp)

    def test_the_berry_is_eaten_before_the_bar_moves_and_halves_nothing_more(self):
        # The half is the chain's (6.9.13); subscript 264, called from UpdateHp
        # before the health bar, only eats the Berry the chain marked.
        script = (ROOT / "files/battledata/script/subscript/subscript_0264_SuperEffectiveBerries.s").read_text()
        commands = [line.strip() for line in script.splitlines() if line.strip() and not line.strip().startswith("//")]
        self.assertFalse([c for c in commands if c.startswith("DivideVar")])
        self.assertIn("CompareVarToValue OPCODE_FLAG_NOT, BSCRIPT_VAR_DEFENDER_SELF_TURN_STATUS_FLAGS, SELF_TURN_FLAG_RESIST_BERRY, _END", commands)
        self.assertIn("RemoveItem BATTLER_CATEGORY_MSG_TEMP", commands)
        update = (ROOT / "files/battledata/script/subscript/subscript_0002_UpdateHp.s").read_text()
        self.assertLess(update.index("Call BATTLE_SUBSCRIPT_TYPE_RESIST_BERRY"), update.index("UpdateHealthBar "))

    def test_future_sight_keeps_the_screens(self):
        # Its damage is still worked out whole on the turn it is used, as
        # HeartGold's was, and the screens left the base damage.
        body = function(COMMANDS, "BtlCmd_TryFutureSight")
        self.assertIn("ScreenModifier(", body)


if __name__ == "__main__":
    unittest.main()
