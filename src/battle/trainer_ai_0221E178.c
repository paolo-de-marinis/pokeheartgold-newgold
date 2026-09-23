#include "battle/battle_system.h"
#include "battle/overlay_12_0224E4FC.h"
#include "battle/trainer_ai.h"

// AI script commands: the category of the current move and of the target's
// last move.

void ov10_0221E178(BattleSystem *battleSystem, BattleContext *ctx) {
    ov10_0221EF24(ctx, 1);
    ctx->trainerAIData.unk8 = BattleMoveTbl(ctx, ctx->trainerAIData.unk2)->category;
}

void ov10_0221E19C(BattleSystem *battleSystem, BattleContext *ctx) {
    ov10_0221EF24(ctx, 1);
    ctx->trainerAIData.unk8 = BattleMoveTbl(ctx, ctx->moveNoBattlerPrev[ctx->trainerAIData.battlerIdTarget])->category;
}
