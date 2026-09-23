#include "battle/battle_system.h"
#include "battle/overlay_12_0224E4FC.h"
#include "battle/trainer_ai.h"

// AI script command: whether the current move does the most damage of the
// attacker's and its partner's moves.

void ov10_0221E848(BattleSystem *battleSystem, BattleContext *ctx) {
    int i;
    s32 moveDamage;
    int varyDamage;
    int j;
    int riskyIdx;
    int altPowerIdx;
    int battlerId;
    u8 ivs[NUM_STATS];
    s32 damages[MAX_MON_MOVES];

    ov10_0221EF24(ctx, 1);
    varyDamage = ov10_0221EEF0(ctx);

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
        battlerId = ctx->trainerAIData.battlerIdAttacker;

        for (j = 0; j < 2; j++) {
            for (i = 0; i < NUM_STATS; i++) {
                ivs[i] = GetBattlerVar(ctx, battlerId, BMON_DATA_HP_IV + i, NULL);
            }

            ov10_0221EF7C(battleSystem,
                ctx,
                battlerId,
                ctx->battleMons[battlerId].moves,
                damages,
                ctx->battleMons[battlerId].item,
                ivs,
                GetBattlerAbility(ctx, battlerId),
                ctx->battleMons[battlerId].unk88.embargoFlag,
                varyDamage);

            battlerId = BattleSystem_GetBattlerIdPartner(battleSystem, ctx->trainerAIData.battlerIdAttacker);

            if (j == 0) {
                moveDamage = damages[ctx->trainerAIData.unk1];
            }

            for (i = 0; i < MAX_MON_MOVES; i++) {
                if (damages[i] > moveDamage) {
                    break;
                }
            }

            if (i == MAX_MON_MOVES) {
                ctx->trainerAIData.unk8 = 2;
            } else {
                ctx->trainerAIData.unk8 = 1;
                break;
            }
        }
    } else {
        ctx->trainerAIData.unk8 = 0;
    }
}
