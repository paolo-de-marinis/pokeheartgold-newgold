#include "battle/battle_system.h"
#include "battle/overlay_12_0224E4FC.h"
#include "battle/trainer_ai.h"

// Whether the battler has a move that is super effective against the foe
// facing it, or in a double battle against that foe's partner, leaving out a
// foe on its way out. Unless noRandom, a move found counts nine times in ten.
BOOL ov10_0221FD34(BattleSystem *battleSystem, BattleContext *ctx, int battlerId, BOOL noRandom) {
    int i;
    u8 battlerIdTarget;
    u8 side;
    u16 move;
    int moveType;
    u32 moveStatusFlag;

    side = ov12_0223AB0C(battleSystem, battlerId) ^ 1;
    battlerIdTarget = BattleSystem_GetBattlerFromBattlerType(battleSystem, side);

    if (!(MaskOfFlagNo(battlerIdTarget) & ctx->switchInFlag)) {
        for (i = 0; i < MAX_MON_MOVES; i++) {
            move = ctx->battleMons[battlerId].moves[i];
            moveType = ov10_0221F47C(battleSystem, ctx, battlerId, move);
            if (move) {
                moveStatusFlag = 0;
                ov12_02251D28(battleSystem, ctx, move, moveType, battlerId, battlerIdTarget, 0, &moveStatusFlag);
                if (moveStatusFlag & MOVE_STATUS_SUPER_EFFECTIVE) {
                    if (noRandom) {
                        return TRUE;
                    }
                    if (BattleSystem_Random(battleSystem) % 10 != 0) {
                        return TRUE;
                    }
                }
            }
        }
    }

    if (!(BattleSystem_GetBattleType(battleSystem) & BATTLE_TYPE_DOUBLES)) {
        return FALSE;
    }

    battlerIdTarget = BattleSystem_GetBattlerIdPartner(battleSystem, battlerIdTarget);

    if (!(MaskOfFlagNo(battlerIdTarget) & ctx->switchInFlag)) {
        for (i = 0; i < MAX_MON_MOVES; i++) {
            move = ctx->battleMons[battlerId].moves[i];
            moveType = ov10_0221F47C(battleSystem, ctx, battlerId, move);
            if (move) {
                moveStatusFlag = 0;
                ov12_02251D28(battleSystem, ctx, move, moveType, battlerId, battlerIdTarget, 0, &moveStatusFlag);
                if (moveStatusFlag & MOVE_STATUS_SUPER_EFFECTIVE) {
                    if (noRandom) {
                        return TRUE;
                    }
                    if (BattleSystem_Random(battleSystem) % 10 != 0) {
                        return TRUE;
                    }
                }
            }
        }
    }

    return FALSE;
}
