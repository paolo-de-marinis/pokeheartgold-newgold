#include "battle/battle_system.h"
#include "battle/overlay_12_0224E4FC.h"
#include "battle/trainer_ai.h"

// The damage the AI expects from each of a battler's four moves, and the
// most of them. Moves whose damage is not estimated count as none.

s32 ov10_0221EF7C(BattleSystem *battleSystem, BattleContext *ctx, int battlerId, u16 *moves, s32 *damages, u16 heldItem, u8 *ivs, int ability, int embargoTurns, int varyDamage) {
    int i;
    int riskyIdx;
    int altPowerIdx;
    s32 maxDamage;
    u8 roll;

    maxDamage = 0;

    for (i = 0; i < MAX_MON_MOVES; i++) {
        riskyIdx = 0;
        do {
            if (BattleMoveTbl(ctx, moves[i])->effect == ov10_0222B098[riskyIdx]) {
                break;
            }
            riskyIdx++;
        } while (ov10_0222B098[riskyIdx] != 0xFFFF);

        altPowerIdx = 0;
        do {
            if (BattleMoveTbl(ctx, moves[i])->effect == ov10_0222B080[altPowerIdx]) {
                break;
            }
            altPowerIdx++;
        } while (ov10_0222B080[altPowerIdx] != 0xFFFF);

        if (ov10_0222B080[altPowerIdx] != 0xFFFF || (moves[i] != MOVE_NONE && ov10_0222B098[riskyIdx] == 0xFFFF && BattleMoveTbl(ctx, moves[i])->power > 1)) {
            if (varyDamage == 1) {
                roll = ctx->trainerAIData.unk18[i];
            } else {
                roll = 100;
            }
            damages[i] = ov10_0221F084(battleSystem, ctx, moves[i], heldItem, ivs, battlerId, ability, embargoTurns, roll);
        } else {
            damages[i] = 0;
        }
    }

    for (i = 0; i < MAX_MON_MOVES; i++) {
        if (maxDamage < damages[i]) {
            maxDamage = damages[i];
        }
    }

    return maxDamage;
}
