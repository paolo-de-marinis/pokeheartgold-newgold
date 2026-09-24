#include "battle/battle_system.h"
#include "battle/trainer_ai.h"

#include "error_handling.h"

// AI script commands: whether a partner or target is being replaced this turn,
// and a battler's gender, first turn out, Stockpile count, the battle's type
// and the item Recycle would bring back.

// The asserts call GF_AssertFail itself, as the retail routine did: GF_ASSERT
// would call the diagnostics build's own assert there and change that build.

// Jumps when the battler, the target's or the attacker's partner, fainted and
// is being replaced this turn.
void ov10_0221E9A4(BattleSystem *battleSystem, BattleContext *ctx) {
    int battler;
    int adrs;

    ov10_0221EF24(ctx, 1);
    battler = ov10_0221EEF0(ctx);
    adrs = ov10_0221EEF0(ctx);

    if (battler == AI_BATTLER_ATTACKER) {
        GF_AssertFail();
    }
    if (battler == AI_BATTLER_TARGET) {
        GF_AssertFail();
    }

    if (MaskOfFlagNo(ov10_0221EF34(ctx, battler)) & ctx->switchInFlag) {
        ov10_0221EF24(ctx, adrs);
    }
}

// Jumps when the battler, the target's or the attacker's partner, is not being
// replaced this turn.
void ov10_0221E9F4(BattleSystem *battleSystem, BattleContext *ctx) {
    int battler;
    int adrs;

    ov10_0221EF24(ctx, 1);
    battler = ov10_0221EEF0(ctx);
    adrs = ov10_0221EEF0(ctx);

    if (battler == AI_BATTLER_ATTACKER) {
        GF_AssertFail();
    }
    if (battler == AI_BATTLER_TARGET) {
        GF_AssertFail();
    }

    if (!(MaskOfFlagNo(ov10_0221EF34(ctx, battler)) & ctx->switchInFlag)) {
        ov10_0221EF24(ctx, adrs);
    }
}

// Loads the battler's gender.
void ov10_0221EA44(BattleSystem *battleSystem, BattleContext *ctx) {
    ov10_0221EF24(ctx, 1);
    ctx->trainerAIData.unk8 = ctx->battleMons[ov10_0221EF34(ctx, ov10_0221EEF0(ctx))].gender;
}

// Loads whether this is the battler's first turn out: Fake Out still works.
void ov10_0221EA7C(BattleSystem *battleSystem, BattleContext *ctx) {
    ov10_0221EF24(ctx, 1);
    if (ctx->battleMons[ov10_0221EF34(ctx, ov10_0221EEF0(ctx))].unk88.fakeOutCount < ctx->totalTurns) {
        ctx->trainerAIData.unk8 = 0;
    } else {
        ctx->trainerAIData.unk8 = 1;
    }
}

// Loads how many times the battler has Stockpiled.
void ov10_0221EAC8(BattleSystem *battleSystem, BattleContext *ctx) {
    ov10_0221EF24(ctx, 1);
    ctx->trainerAIData.unk8 = ctx->battleMons[ov10_0221EF34(ctx, ov10_0221EEF0(ctx))].unk88.stockpileCount;
}

// Loads the battle's type flags.
void ov10_0221EB00(BattleSystem *battleSystem, BattleContext *ctx) {
    ov10_0221EF24(ctx, 1);
    ctx->trainerAIData.unk8 = battleSystem->battleType;
}

// Loads the item the battler's Recycle would bring back.
void ov10_0221EB18(BattleSystem *battleSystem, BattleContext *ctx) {
    ov10_0221EF24(ctx, 1);
    ctx->trainerAIData.unk8 = ctx->recycleItem[ov10_0221EF34(ctx, ov10_0221EEF0(ctx))];
}
