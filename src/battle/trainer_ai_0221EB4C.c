#include "constants/moves.h"

#include "battle/battle_system.h"
#include "battle/overlay_12_0224E4FC.h"
#include "battle/trainer_ai.h"

// AI script commands: the type, power and effect of the move in the result, and
// a battler's run of guards.

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

// How many times in a row the battler's Protect, Detect or Endure has worked, or
// zero when the last move it used was none of the three.
void ov10_0221EBAC(BattleSystem *battleSystem, BattleContext *ctx) {
    u8 battlerId;

    ov10_0221EF24(ctx, 1);
    battlerId = ov10_0221EF34(ctx, ov10_0221EEF0(ctx));

    if (ctx->moveNoProtect[battlerId] != MOVE_PROTECT && ctx->moveNoProtect[battlerId] != MOVE_DETECT && ctx->moveNoProtect[battlerId] != MOVE_ENDURE) {
        ctx->trainerAIData.unk8 = 0;
    } else {
        ctx->trainerAIData.unk8 = ctx->battleMons[battlerId].unk88.protectSuccessTurns;
    }
}
