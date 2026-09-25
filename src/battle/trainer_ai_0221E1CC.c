#include "battle/battle_system.h"
#include "battle/overlay_12_0224E4FC.h"
#include "battle/trainer_ai.h"

// AI script commands: the turn order, and how long a battler has been out.

// Loads the battler's place in the turn order by speed, 0 for the first.
void ov10_0221E1CC(BattleSystem *battleSystem, BattleContext *ctx) {
    int i;
    int j;
    int battler1;
    int maxBattlers;
    int battler;
    int battler2;
    int order[BATTLER_MAX];

    ov10_0221EF24(ctx, 1);
    battler = ov10_0221EF34(ctx, ov10_0221EEF0(ctx));
    maxBattlers = BattleSystem_GetMaxBattlers(battleSystem);

    for (i = 0; i < maxBattlers; i++) {
        order[i] = i;
    }

    for (i = 0; i < maxBattlers - 1; i++) {
        for (j = i + 1; j < maxBattlers; j++) {
            battler1 = order[i];
            battler2 = order[j];
            if (CheckSortSpeed(battleSystem, ctx, battler1, battler2, 1)) {
                order[i] = battler2;
                order[j] = battler1;
            }
        }
    }

    for (i = 0; i < maxBattlers; i++) {
        if (order[i] == battler) {
            ctx->trainerAIData.unk8 = i;
            return;
        }
    }
}

// Loads how many turns the battler has been out, counted from the turn Fake
// Out counts from.
void ov10_0221E290(BattleSystem *battleSystem, BattleContext *ctx) {
    u8 battler;

    ov10_0221EF24(ctx, 1);
    battler = ov10_0221EF34(ctx, ov10_0221EEF0(ctx));
    ctx->trainerAIData.unk8 = ctx->totalTurns - ctx->battleMons[battler].unk88.fakeOutCount;
}
