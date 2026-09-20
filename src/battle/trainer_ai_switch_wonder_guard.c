#include "constants/abilities.h"
#include "constants/species.h"

#include "battle/battle_controller_opponent.h"
#include "battle/battle_system.h"
#include "battle/overlay_12_0224E4FC.h"
#include "battle/trainer_ai.h"

#include "pokemon.h"

BOOL ov10_0221F62C(BattleSystem *battleSystem, BattleContext *ctx, int battlerId) {
    int battlerIdTarget;
    int i;
    int j;
    u16 move;
    int moveType;
    u32 moveStatus;
    Pokemon *mon;

    if (BattleSystem_GetBattleType(battleSystem) & BATTLE_TYPE_DOUBLES) {
        return FALSE;
    }

    battlerIdTarget = battlerId ^ 1;
    if (ctx->battleMons[battlerIdTarget].ability == ABILITY_WONDER_GUARD) {
        for (i = 0; i < MAX_MON_MOVES; i++) {
            move = ctx->battleMons[battlerId].moves[i];
            moveType = ov10_0221F47C(battleSystem, ctx, battlerId, move);
            if (move != MOVE_NONE) {
                moveStatus = 0;
                ov12_02251D28(battleSystem, ctx, move, moveType, battlerId, battlerIdTarget, 0, &moveStatus);
                if (moveStatus & MOVE_STATUS_SUPER_EFFECTIVE) {
                    return FALSE;
                }
            }
        }

        for (i = 0; i < BattleSystem_GetPartySize(battleSystem, battlerId); i++) {
            mon = BattleSystem_GetPartyMon(battleSystem, battlerId, i);
            if (GetMonData(mon, MON_DATA_HP, NULL) == 0
                || GetMonData(mon, MON_DATA_SPECIES_OR_EGG, NULL) == SPECIES_NONE
                || GetMonData(mon, MON_DATA_SPECIES_OR_EGG, NULL) == SPECIES_EGG
                || i == ctx->selectedMonIndex[battlerId]) {
                continue;
            }

            for (j = 0; j < MAX_MON_MOVES; j++) {
                move = GetMonData(mon, MON_DATA_MOVE1 + j, NULL);
                moveType = ov12_02258BB4(battleSystem, ctx, mon, move);
                if (move != MOVE_NONE) {
                    moveStatus = 0;
                    ov12_02252054(ctx, move, moveType, GetMonData(mon, MON_DATA_ABILITY, NULL), GetBattlerAbility(ctx, battlerIdTarget), GetBattlerHeldItemEffect(ctx, battlerIdTarget), GetBattlerVar(ctx, battlerIdTarget, BMON_DATA_TYPE_1, NULL), GetBattlerVar(ctx, battlerIdTarget, BMON_DATA_TYPE_2, NULL), &moveStatus);
                    if ((moveStatus & MOVE_STATUS_SUPER_EFFECTIVE) && BattleSystem_Random(battleSystem) % 3 < 2) {
                        ctx->unk_21A4[battlerId] = i;
                        return TRUE;
                    }
                }
            }
        }
    }

    return FALSE;
}
