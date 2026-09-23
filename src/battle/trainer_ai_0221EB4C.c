#include "battle/battle_system.h"
#include "battle/overlay_12_0224E4FC.h"
#include "battle/trainer_ai.h"

// AI script commands: the type, power and effect of the move in the result.

void ov10_0221EB4C(BattleSystem *battleSystem, BattleContext *ctx) {
    ov10_0221EF24(ctx, 1);
    ctx->trainerAIData.unk8 = BattleMoveTbl(ctx, ctx->trainerAIData.unk8)->type;
}

void ov10_0221EB6C(BattleSystem *battleSystem, BattleContext *ctx) {
    ov10_0221EF24(ctx, 1);
    ctx->trainerAIData.unk8 = BattleMoveTbl(ctx, ctx->trainerAIData.unk8)->power;
}

void ov10_0221EB8C(BattleSystem *battleSystem, BattleContext *ctx) {
    ov10_0221EF24(ctx, 1);
    ctx->trainerAIData.unk8 = BattleMoveTbl(ctx, ctx->trainerAIData.unk8)->effect;
}
