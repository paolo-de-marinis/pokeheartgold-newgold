#include "constants/move_effects.h"

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

// How many times in a row the battler's guards have worked, or zero when the
// last move it used was not one of Protect's family. Retail asked after
// Protect, Detect and Endure by number; the family is the three effects the
// battle counts the run by (BtlCmd_TryProtection, as hg-engine's
// battle_script_commands.c), so the shields and the team guards keep it going
// too.
void ov10_0221EBAC(BattleSystem *battleSystem, BattleContext *ctx) {
    u8 battlerId;
    u16 effect;

    ov10_0221EF24(ctx, 1);
    battlerId = ov10_0221EF34(ctx, ov10_0221EEF0(ctx));
    effect = BattleMoveTbl(ctx, ctx->moveNoProtect[battlerId])->effect;

    if (effect != MOVE_EFFECT_PROTECT && effect != MOVE_EFFECT_PROTECT_USER_SIDE && effect != MOVE_EFFECT_SURVIVE_WITH_1_HP) {
        ctx->trainerAIData.unk8 = 0;
    } else {
        ctx->trainerAIData.unk8 = ctx->protectSuccessTurns[battlerId];
    }
}
