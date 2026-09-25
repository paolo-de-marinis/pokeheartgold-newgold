#include "battle/battle_system.h"
#include "battle/overlay_12_0224E4FC.h"
#include "battle/trainer_ai.h"

// AI script commands: a super effective move, the damage a foe's last move
// would do, and stats and stat stages compared.

static void ov10_0221E74C(BattleContext *ctx, int battler, int *attackerStat, int *battlerStat, int stat);

// Jumps if the attacker has a move super effective on a foe.
void ov10_0221E460(BattleSystem *battleSystem, BattleContext *ctx) {
    u32 adrs;

    ov10_0221EF24(ctx, 1);
    adrs = ov10_0221EEF0(ctx);

    if (ov10_0221FD34(battleSystem, ctx, ctx->trainerAIData.battlerIdAttacker, TRUE) == TRUE) {
        ov10_0221EF24(ctx, adrs);
    }
}

// Jumps if the last move the battler used would do more damage to the target
// than the attacker's best move. A Hidden Power there takes its type and power
// from the attacker's IVs, not the battler's.
void ov10_0221E498(BattleSystem *battleSystem, BattleContext *ctx) {
    int i;
    int battler;
    u32 varyDamage;
    int roll;
    int attacker;
    u32 adrs;
    s32 maxDamage;
    u8 ivs[NUM_STATS];
    s32 damages[MAX_MON_MOVES];

    ov10_0221EF24(ctx, 1);
    battler = ov10_0221EEF0(ctx);
    varyDamage = ov10_0221EEF0(ctx);
    adrs = ov10_0221EEF0(ctx);

    for (i = 0; i < NUM_STATS; i++) {
        ivs[i] = GetBattlerVar(ctx, ctx->trainerAIData.battlerIdAttacker, BMON_DATA_HP_IV + i, NULL);
    }

    attacker = ctx->trainerAIData.battlerIdAttacker;
    maxDamage = ov10_0221EF7C(battleSystem, ctx, attacker, ctx->battleMons[ctx->trainerAIData.battlerIdAttacker].moves, damages, ctx->battleMons[ctx->trainerAIData.battlerIdAttacker].item, ivs, GetBattlerAbility(ctx, attacker), ctx->battleMons[ctx->trainerAIData.battlerIdAttacker].unk88.embargoFlag, varyDamage);
    battler = ov10_0221EF34(ctx, battler);

    if (varyDamage == 1) {
        roll = ctx->trainerAIData.unk18[ctx->trainerAIData.unk1];
    } else {
        roll = 100;
    }

    if ((s32)ov10_0221F084(battleSystem, ctx, ctx->moveNoBattlerPrev[battler], ctx->battleMons[battler].item, ivs, battler, GetBattlerAbility(ctx, battler), ctx->battleMons[battler].unk88.embargoFlag, roll) > maxDamage) {
        ov10_0221EF24(ctx, adrs);
    }
}

// Loads the sum of the battler's stat stages above neutral.
void ov10_0221E5B0(BattleSystem *battleSystem, BattleContext *ctx) {
    int i;
    u8 battler;

    ov10_0221EF24(ctx, 1);
    battler = ov10_0221EF34(ctx, ov10_0221EEF0(ctx));
    ctx->trainerAIData.unk8 = 0;

    for (i = 0; i < NUM_BATTLE_STATS; i++) {
        if (ctx->battleMons[battler].statChanges[i] > 6) {
            ctx->trainerAIData.unk8 += ctx->battleMons[battler].statChanges[i] - 6;
        }
    }
}

// Loads how many stages higher the battler's given stat stands than the
// attacker's.
void ov10_0221E600(BattleSystem *battleSystem, BattleContext *ctx) {
    int battler;
    u32 stat;

    ov10_0221EF24(ctx, 1);
    battler = ov10_0221EEF0(ctx);
    stat = ov10_0221EEF0(ctx);
    battler = ov10_0221EF34(ctx, battler);

    ctx->trainerAIData.unk8 = ctx->battleMons[battler].statChanges[stat] - ctx->battleMons[ctx->trainerAIData.battlerIdAttacker].statChanges[stat];
}

// Jumps if the attacker's given stat is lower than the battler's.
void ov10_0221E650(BattleSystem *battleSystem, BattleContext *ctx) {
    int battler;
    int stat;
    u32 adrs;
    int attackerStat;
    int battlerStat;

    ov10_0221EF24(ctx, 1);
    battler = ov10_0221EEF0(ctx);
    stat = ov10_0221EEF0(ctx);
    adrs = ov10_0221EEF0(ctx);
    ov10_0221E74C(ctx, ov10_0221EF34(ctx, battler), &attackerStat, &battlerStat, stat);

    if (attackerStat < battlerStat) {
        ov10_0221EF24(ctx, adrs);
    }
}

// Jumps if the attacker's given stat is higher than the battler's.
void ov10_0221E6A4(BattleSystem *battleSystem, BattleContext *ctx) {
    int battler;
    int stat;
    u32 adrs;
    int attackerStat;
    int battlerStat;

    ov10_0221EF24(ctx, 1);
    battler = ov10_0221EEF0(ctx);
    stat = ov10_0221EEF0(ctx);
    adrs = ov10_0221EEF0(ctx);
    ov10_0221E74C(ctx, ov10_0221EF34(ctx, battler), &attackerStat, &battlerStat, stat);

    if (attackerStat > battlerStat) {
        ov10_0221EF24(ctx, adrs);
    }
}

// Jumps if the attacker's given stat equals the battler's.
void ov10_0221E6F8(BattleSystem *battleSystem, BattleContext *ctx) {
    int battler;
    int stat;
    u32 adrs;
    int attackerStat;
    int battlerStat;

    ov10_0221EF24(ctx, 1);
    battler = ov10_0221EEF0(ctx);
    stat = ov10_0221EEF0(ctx);
    adrs = ov10_0221EEF0(ctx);
    ov10_0221E74C(ctx, ov10_0221EF34(ctx, battler), &attackerStat, &battlerStat, stat);

    if (attackerStat == battlerStat) {
        ov10_0221EF24(ctx, adrs);
    }
}

// Reads one stat, HP included, of the attacker and of the battler, for the
// three commands above.
static void ov10_0221E74C(BattleContext *ctx, int battler, int *attackerStat, int *battlerStat, int stat) {
    switch (stat) {
    case STAT_HP:
        *attackerStat = ctx->battleMons[ctx->trainerAIData.battlerIdAttacker].hp;
        *battlerStat = ctx->battleMons[battler].hp;
        break;
    case STAT_ATK:
        *attackerStat = ctx->battleMons[ctx->trainerAIData.battlerIdAttacker].atk;
        *battlerStat = ctx->battleMons[battler].atk;
        break;
    case STAT_DEF:
        *attackerStat = ctx->battleMons[ctx->trainerAIData.battlerIdAttacker].def;
        *battlerStat = ctx->battleMons[battler].def;
        break;
    case STAT_SPATK:
        *attackerStat = ctx->battleMons[ctx->trainerAIData.battlerIdAttacker].spAtk;
        *battlerStat = ctx->battleMons[battler].spAtk;
        break;
    case STAT_SPDEF:
        *attackerStat = ctx->battleMons[ctx->trainerAIData.battlerIdAttacker].spDef;
        *battlerStat = ctx->battleMons[battler].spDef;
        break;
    case STAT_SPEED:
        *attackerStat = ctx->battleMons[ctx->trainerAIData.battlerIdAttacker].speed;
        *battlerStat = ctx->battleMons[battler].speed;
        break;
    default:
        GF_AssertFail();
        break;
    }
}
