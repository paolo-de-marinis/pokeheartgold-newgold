#include "battle/battle_system.h"
#include "battle/overlay_12_0224E4FC.h"
#include "battle/trainer_ai.h"

// AI script commands: the current move's effect, stat stages, whether the
// current move would knock the target out, and which moves and move effects a
// battler is known to have.

void ov10_0221D60C(BattleSystem *battleSystem, BattleContext *ctx) {
    u32 effect;
    u32 adrs;

    ov10_0221EF24(ctx, 1);
    effect = ov10_0221EEF0(ctx);
    adrs = ov10_0221EEF0(ctx);

    if (effect == ctx->trainerAIData.moveData[ctx->trainerAIData.unk2].effect) {
        ov10_0221EF24(ctx, adrs);
    }
}

void ov10_0221D644(BattleSystem *battleSystem, BattleContext *ctx) {
    u32 effect;
    u32 adrs;

    ov10_0221EF24(ctx, 1);
    effect = ov10_0221EEF0(ctx);
    adrs = ov10_0221EEF0(ctx);

    if (effect != ctx->trainerAIData.moveData[ctx->trainerAIData.unk2].effect) {
        ov10_0221EF24(ctx, adrs);
    }
}

void ov10_0221D67C(BattleSystem *battleSystem, BattleContext *ctx) {
    int battler;
    int stat;
    int value;
    u32 adrs;

    ov10_0221EF24(ctx, 1);
    battler = ov10_0221EEF0(ctx);
    stat = ov10_0221EEF0(ctx);
    value = ov10_0221EEF0(ctx);
    adrs = ov10_0221EEF0(ctx);

    if (ctx->battleMons[ov10_0221EF34(ctx, battler)].statChanges[stat] < value) {
        ov10_0221EF24(ctx, adrs);
    }
}

void ov10_0221D6D0(BattleSystem *battleSystem, BattleContext *ctx) {
    int battler;
    int stat;
    int value;
    u32 adrs;

    ov10_0221EF24(ctx, 1);
    battler = ov10_0221EEF0(ctx);
    stat = ov10_0221EEF0(ctx);
    value = ov10_0221EEF0(ctx);
    adrs = ov10_0221EEF0(ctx);

    if (ctx->battleMons[ov10_0221EF34(ctx, battler)].statChanges[stat] > value) {
        ov10_0221EF24(ctx, adrs);
    }
}

void ov10_0221D724(BattleSystem *battleSystem, BattleContext *ctx) {
    int battler;
    int stat;
    int value;
    u32 adrs;

    ov10_0221EF24(ctx, 1);
    battler = ov10_0221EEF0(ctx);
    stat = ov10_0221EEF0(ctx);
    value = ov10_0221EEF0(ctx);
    adrs = ov10_0221EEF0(ctx);

    if (ctx->battleMons[ov10_0221EF34(ctx, battler)].statChanges[stat] == value) {
        ov10_0221EF24(ctx, adrs);
    }
}

void ov10_0221D778(BattleSystem *battleSystem, BattleContext *ctx) {
    int battler;
    int stat;
    int value;
    u32 adrs;

    ov10_0221EF24(ctx, 1);
    battler = ov10_0221EEF0(ctx);
    stat = ov10_0221EEF0(ctx);
    value = ov10_0221EEF0(ctx);
    adrs = ov10_0221EEF0(ctx);

    if (ctx->battleMons[ov10_0221EF34(ctx, battler)].statChanges[stat] != value) {
        ov10_0221EF24(ctx, adrs);
    }
}

void ov10_0221D7CC(BattleSystem *battleSystem, BattleContext *ctx) {
    int i;
    int riskyIdx;
    int altPowerIdx;
    int roll;
    u32 damage;
    u32 varyDamage;
    u32 adrs;
    u8 ivs[NUM_STATS];

    ov10_0221EF24(ctx, 1);
    varyDamage = ov10_0221EEF0(ctx);
    adrs = ov10_0221EEF0(ctx);

    if (varyDamage == 1) {
        roll = ctx->trainerAIData.unk18[ctx->trainerAIData.unk1];
    } else {
        roll = 100;
    }

    riskyIdx = 0;
    do {
        if (ctx->trainerAIData.moveData[ctx->trainerAIData.unk2].effect == ov10_0222B098[riskyIdx]) {
            break;
        }
        riskyIdx++;
    } while (ov10_0222B098[riskyIdx] != 0xFFFF);

    altPowerIdx = 0;
    do {
        if (ctx->trainerAIData.moveData[ctx->trainerAIData.unk2].effect == ov10_0222B080[altPowerIdx]) {
            break;
        }
        altPowerIdx++;
    } while (ov10_0222B080[altPowerIdx] != 0xFFFF);

    if (ov10_0222B080[altPowerIdx] != 0xFFFF || (ctx->trainerAIData.moveData[ctx->trainerAIData.unk2].power > 1 && ov10_0222B098[riskyIdx] == 0xFFFF)) {
        for (i = 0; i < NUM_STATS; i++) {
            ivs[i] = GetBattlerVar(ctx, ctx->trainerAIData.battlerIdAttacker, BMON_DATA_HP_IV + i, NULL);
        }

        damage = ov10_0221F084(battleSystem,
            ctx,
            ctx->trainerAIData.unk2,
            ctx->battleMons[ctx->trainerAIData.battlerIdAttacker].item,
            ivs,
            ctx->trainerAIData.battlerIdAttacker,
            GetBattlerAbility(ctx, ctx->trainerAIData.battlerIdAttacker),
            ctx->battleMons[ctx->trainerAIData.battlerIdAttacker].unk88.embargoFlag,
            roll);

        if (ctx->battleMons[ctx->trainerAIData.battlerIdTarget].hp <= damage) {
            ov10_0221EF24(ctx, adrs);
        }
    }
}

void ov10_0221D8F8(BattleSystem *battleSystem, BattleContext *ctx) {
    int i;
    int riskyIdx;
    int altPowerIdx;
    int roll;
    u32 damage;
    u32 varyDamage;
    u32 adrs;
    u8 ivs[NUM_STATS];

    ov10_0221EF24(ctx, 1);
    varyDamage = ov10_0221EEF0(ctx);
    adrs = ov10_0221EEF0(ctx);

    if (varyDamage == 1) {
        roll = ctx->trainerAIData.unk18[ctx->trainerAIData.unk1];
    } else {
        roll = 100;
    }

    riskyIdx = 0;
    do {
        if (ctx->trainerAIData.moveData[ctx->trainerAIData.unk2].effect == ov10_0222B098[riskyIdx]) {
            break;
        }
        riskyIdx++;
    } while (ov10_0222B098[riskyIdx] != 0xFFFF);

    altPowerIdx = 0;
    do {
        if (ctx->trainerAIData.moveData[ctx->trainerAIData.unk2].effect == ov10_0222B080[altPowerIdx]) {
            break;
        }
        altPowerIdx++;
    } while (ov10_0222B080[altPowerIdx] != 0xFFFF);

    if (ov10_0222B080[altPowerIdx] != 0xFFFF || (ctx->trainerAIData.moveData[ctx->trainerAIData.unk2].power > 1 && ov10_0222B098[riskyIdx] == 0xFFFF)) {
        for (i = 0; i < NUM_STATS; i++) {
            ivs[i] = GetBattlerVar(ctx, ctx->trainerAIData.battlerIdAttacker, BMON_DATA_HP_IV + i, NULL);
        }

        damage = ov10_0221F084(battleSystem,
            ctx,
            ctx->trainerAIData.unk2,
            ctx->battleMons[ctx->trainerAIData.battlerIdAttacker].item,
            ivs,
            ctx->trainerAIData.battlerIdAttacker,
            GetBattlerAbility(ctx, ctx->trainerAIData.battlerIdAttacker),
            ctx->battleMons[ctx->trainerAIData.battlerIdAttacker].unk88.embargoFlag,
            roll);

        if (ctx->battleMons[ctx->trainerAIData.battlerIdTarget].hp > damage) {
            ov10_0221EF24(ctx, adrs);
        }
    }
}

void ov10_0221DA24(BattleSystem *battleSystem, BattleContext *ctx) {
    int i;
    int battler;
    u32 move;
    u32 adrs;
    u8 battlerId;

    ov10_0221EF24(ctx, 1);
    battler = ov10_0221EEF0(ctx);
    move = ov10_0221EEF0(ctx);
    adrs = ov10_0221EEF0(ctx);
    battlerId = ov10_0221EF34(ctx, battler);

    switch (battler) {
    case AI_BATTLER_ATTACKER:
        for (i = 0; i < MAX_MON_MOVES; i++) {
            if (move == ctx->battleMons[battlerId].moves[i]) {
                break;
            }
        }
        if (i < MAX_MON_MOVES) {
            ov10_0221EF24(ctx, adrs);
        }
        break;
    case AI_BATTLER_ATTACKER_PARTNER:
        if (ctx->battleMons[battlerId].hp == 0) {
            break;
        }
        for (i = 0; i < MAX_MON_MOVES; i++) {
            if (move == ctx->battleMons[battlerId].moves[i]) {
                break;
            }
        }
        if (i < MAX_MON_MOVES) {
            ov10_0221EF24(ctx, adrs);
        }
        break;
    case AI_BATTLER_TARGET:
        for (i = 0; i < MAX_MON_MOVES; i++) {
            if (move == ctx->trainerAIData.moves[battlerId][i]) {
                break;
            }
        }
        if (i < MAX_MON_MOVES) {
            ov10_0221EF24(ctx, adrs);
        }
        break;
    }
}

void ov10_0221DAE4(BattleSystem *battleSystem, BattleContext *ctx) {
    int i;
    int battler;
    u32 move;
    u32 adrs;
    u8 battlerId;

    ov10_0221EF24(ctx, 1);
    battler = ov10_0221EEF0(ctx);
    move = ov10_0221EEF0(ctx);
    adrs = ov10_0221EEF0(ctx);
    battlerId = ov10_0221EF34(ctx, battler);

    switch (battler) {
    case AI_BATTLER_ATTACKER:
        for (i = 0; i < MAX_MON_MOVES; i++) {
            if (move == ctx->battleMons[battlerId].moves[i]) {
                break;
            }
        }
        if (i == MAX_MON_MOVES) {
            ov10_0221EF24(ctx, adrs);
        }
        break;
    case AI_BATTLER_ATTACKER_PARTNER:
        if (ctx->battleMons[battlerId].hp == 0) {
            break;
        }
        for (i = 0; i < MAX_MON_MOVES; i++) {
            if (move == ctx->battleMons[battlerId].moves[i]) {
                break;
            }
        }
        if (i == MAX_MON_MOVES) {
            ov10_0221EF24(ctx, adrs);
        }
        break;
    case AI_BATTLER_TARGET:
        for (i = 0; i < MAX_MON_MOVES; i++) {
            if (move == ctx->trainerAIData.moves[battlerId][i]) {
                break;
            }
        }
        if (i == MAX_MON_MOVES) {
            ov10_0221EF24(ctx, adrs);
        }
        break;
    }
}

void ov10_0221DBA4(BattleSystem *battleSystem, BattleContext *ctx) {
    int i;
    int battler;
    u32 effect;
    u32 adrs;
    u8 battlerId;

    ov10_0221EF24(ctx, 1);
    battler = ov10_0221EEF0(ctx);
    effect = ov10_0221EEF0(ctx);
    adrs = ov10_0221EEF0(ctx);
    battlerId = ov10_0221EF34(ctx, battler);

    switch (battler) {
    case AI_BATTLER_ATTACKER:
        for (i = 0; i < MAX_MON_MOVES; i++) {
            if (ctx->battleMons[battlerId].moves[i] != MOVE_NONE && effect == ctx->trainerAIData.moveData[ctx->battleMons[battlerId].moves[i]].effect) {
                break;
            }
        }
        if (i < MAX_MON_MOVES) {
            ov10_0221EF24(ctx, adrs);
        }
        break;
    case AI_BATTLER_TARGET:
        for (i = 0; i < MAX_MON_MOVES; i++) {
            if (ctx->trainerAIData.moves[battlerId][i] != MOVE_NONE && effect == ctx->trainerAIData.moveData[ctx->trainerAIData.moves[battlerId][i]].effect) {
                break;
            }
        }
        if (i < MAX_MON_MOVES) {
            ov10_0221EF24(ctx, adrs);
        }
        break;
    }
}

void ov10_0221DC48(BattleSystem *battleSystem, BattleContext *ctx) {
    int i;
    int battler;
    u32 effect;
    u32 adrs;
    u8 battlerId;

    ov10_0221EF24(ctx, 1);
    battler = ov10_0221EEF0(ctx);
    effect = ov10_0221EEF0(ctx);
    adrs = ov10_0221EEF0(ctx);
    battlerId = ov10_0221EF34(ctx, battler);

    switch (battler) {
    case AI_BATTLER_ATTACKER:
        for (i = 0; i < MAX_MON_MOVES; i++) {
            if (ctx->battleMons[battlerId].moves[i] != MOVE_NONE && effect == ctx->trainerAIData.moveData[ctx->battleMons[battlerId].moves[i]].effect) {
                break;
            }
        }
        if (i == MAX_MON_MOVES) {
            ov10_0221EF24(ctx, adrs);
        }
        break;
    case AI_BATTLER_TARGET:
        for (i = 0; i < MAX_MON_MOVES; i++) {
            if (ctx->trainerAIData.moves[battlerId][i] != MOVE_NONE && effect == ctx->trainerAIData.moveData[ctx->trainerAIData.moves[battlerId][i]].effect) {
                break;
            }
        }
        if (i == MAX_MON_MOVES) {
            ov10_0221EF24(ctx, adrs);
        }
        break;
    }
}
