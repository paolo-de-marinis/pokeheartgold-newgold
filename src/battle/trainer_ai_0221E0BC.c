#include "battle/battle_system.h"
#include "battle/overlay_12_0224E4FC.h"
#include "battle/trainer_ai.h"

// AI script commands: Fling's power, the current move's PP, and Last Resort.

// Loads the power Fling would have with the battler's held item.
void ov10_0221E0BC(BattleSystem *battleSystem, BattleContext *ctx) {
    ov10_0221EF24(ctx, 1);
    ctx->trainerAIData.unk8 = GetHeldItemFlingPower(ctx, ov10_0221EF34(ctx, ov10_0221EEF0(ctx)));
}

// Loads the PP the current move has left.
void ov10_0221E0EC(BattleSystem *battleSystem, BattleContext *ctx) {
    ov10_0221EF24(ctx, 1);
    ctx->trainerAIData.unk8 = ctx->battleMons[ctx->trainerAIData.battlerIdAttacker].movePPCur[ctx->trainerAIData.unk1];
}

// Jumps if the battler could use Last Resort: it has used each of its other
// moves, and it knows more than one.
void ov10_0221E11C(BattleSystem *battleSystem, BattleContext *ctx) {
    int battler;
    int moveCount;
    u32 adrs;

    ov10_0221EF24(ctx, 1);
    battler = ov10_0221EEF0(ctx);
    adrs = ov10_0221EEF0(ctx);
    battler = ov10_0221EF34(ctx, battler);
    moveCount = GetBattlerLearnedMoveCount(battleSystem, ctx, battler);

    if (ctx->battleMons[battler].unk88.lastResortCount >= moveCount - 1 && moveCount > 1) {
        ov10_0221EF24(ctx, adrs);
    }
}
