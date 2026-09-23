#include "constants/species.h"

#include "battle/battle_controller_opponent.h"
#include "battle/battle_system.h"
#include "battle/overlay_12_0224E4FC.h"
#include "battle/trainer_ai.h"

#include "pokemon.h"

// Whether a trainer's Pokemon should switch out because none of its damaging
// moves -- it needs at least two -- can touch either opponent. If so, it looks
// through the party for a move super effective against an opponent, taking
// each it finds two times in three, then for any move that works at all, one
// time in two, and leaves the member picked in unk_21A4.
BOOL ov10_0221F7F0(BattleSystem *battleSystem, BattleContext *ctx, int battlerId) {
    int i;
    int j;
    int defender1;
    int defender2;
    u16 move;
    u8 battler;
    u8 partner;
    int moveType;
    int partySize;
    int numDamagingMoves;
    u32 moveStatus;
    Pokemon *mon;

    if (BattleSystem_GetBattleType(battleSystem) & BATTLE_TYPE_DOUBLES) {
        defender1 = 0;
        defender2 = 2;
    } else {
        defender1 = 0;
        defender2 = 0;
    }

    numDamagingMoves = 0;
    for (i = 0; i < MAX_MON_MOVES; i++) {
        move = ctx->battleMons[battlerId].moves[i];
        moveType = ov10_0221F47C(battleSystem, ctx, battlerId, move);
        if (move != MOVE_NONE && ctx->trainerAIData.moveData[move].power) {
            numDamagingMoves++;

            moveStatus = 0;
            if (ctx->battleMons[defender1].hp) {
                ov12_02251D28(battleSystem, ctx, move, moveType, battlerId, defender1, 0, &moveStatus);
            }
            if (!(moveStatus & MOVE_STATUS_NO_EFFECT)) {
                return FALSE;
            }

            moveStatus = 0;
            if (ctx->battleMons[defender2].hp) {
                ov12_02251D28(battleSystem, ctx, move, moveType, battlerId, defender2, 0, &moveStatus);
            }
            if (!(moveStatus & MOVE_STATUS_NO_EFFECT)) {
                return FALSE;
            }
        }
    }

    if (numDamagingMoves < 2) {
        return FALSE;
    }

    battler = battlerId;
    if ((BattleSystem_GetBattleType(battleSystem) & BATTLE_TYPE_TAG) || (BattleSystem_GetBattleType(battleSystem) & BATTLE_TYPE_MULTI)) {
        partner = battler;
    } else {
        partner = BattleSystem_GetBattlerIdPartner(battleSystem, battlerId);
    }

    partySize = BattleSystem_GetPartySize(battleSystem, battlerId);

    for (i = 0; i < partySize; i++) {
        mon = BattleSystem_GetPartyMon(battleSystem, battlerId, i);
        if (GetMonData(mon, MON_DATA_HP, NULL) != 0
            && GetMonData(mon, MON_DATA_SPECIES_OR_EGG, NULL) != SPECIES_NONE
            && GetMonData(mon, MON_DATA_SPECIES_OR_EGG, NULL) != SPECIES_EGG
            && i != ctx->selectedMonIndex[battler]
            && i != ctx->selectedMonIndex[partner]
            && i != ctx->unk_21A4[battler]
            && i != ctx->unk_21A4[partner]) {
            for (j = 0; j < MAX_MON_MOVES; j++) {
                move = GetMonData(mon, MON_DATA_MOVE1 + j, NULL);
                moveType = ov12_02258BB4(battleSystem, ctx, mon, move);
                if (move != MOVE_NONE && ctx->trainerAIData.moveData[move].power) {
                    moveStatus = 0;
                    if (ctx->battleMons[defender1].hp) {
                        ov12_02252054(ctx, move, moveType, GetMonData(mon, MON_DATA_ABILITY, NULL), GetBattlerAbility(ctx, defender1), GetBattlerHeldItemEffect(ctx, defender1), GetBattlerVar(ctx, defender1, BMON_DATA_TYPE_1, NULL), GetBattlerVar(ctx, defender1, BMON_DATA_TYPE_2, NULL), &moveStatus);
                    }
                    if ((moveStatus & MOVE_STATUS_SUPER_EFFECTIVE) && BattleSystem_Random(battleSystem) % 3 < 2) {
                        ctx->unk_21A4[battlerId] = i;
                        return TRUE;
                    }

                    moveStatus = 0;
                    if (ctx->battleMons[defender2].hp) {
                        ov12_02252054(ctx, move, moveType, GetMonData(mon, MON_DATA_ABILITY, NULL), GetBattlerAbility(ctx, defender2), GetBattlerHeldItemEffect(ctx, defender2), GetBattlerVar(ctx, defender2, BMON_DATA_TYPE_1, NULL), GetBattlerVar(ctx, defender2, BMON_DATA_TYPE_2, NULL), &moveStatus);
                    }
                    if ((moveStatus & MOVE_STATUS_SUPER_EFFECTIVE) && BattleSystem_Random(battleSystem) % 3 < 2) {
                        ctx->unk_21A4[battlerId] = i;
                        return TRUE;
                    }
                }
            }
        }
    }

    for (i = 0; i < partySize; i++) {
        mon = BattleSystem_GetPartyMon(battleSystem, battlerId, i);
        if (GetMonData(mon, MON_DATA_HP, NULL) != 0
            && GetMonData(mon, MON_DATA_SPECIES_OR_EGG, NULL) != SPECIES_NONE
            && GetMonData(mon, MON_DATA_SPECIES_OR_EGG, NULL) != SPECIES_EGG
            && i != ctx->selectedMonIndex[battler]
            && i != ctx->selectedMonIndex[partner]
            && i != ctx->unk_21A4[battler]
            && i != ctx->unk_21A4[partner]) {
            for (j = 0; j < MAX_MON_MOVES; j++) {
                move = GetMonData(mon, MON_DATA_MOVE1 + j, NULL);
                moveType = ov12_02258BB4(battleSystem, ctx, mon, move);
                if (move != MOVE_NONE && ctx->trainerAIData.moveData[move].power) {
                    moveStatus = 0;
                    if (ctx->battleMons[defender1].hp) {
                        ov12_02252054(ctx, move, moveType, GetMonData(mon, MON_DATA_ABILITY, NULL), GetBattlerAbility(ctx, defender1), GetBattlerHeldItemEffect(ctx, defender1), GetBattlerVar(ctx, defender1, BMON_DATA_TYPE_1, NULL), GetBattlerVar(ctx, defender1, BMON_DATA_TYPE_2, NULL), &moveStatus);
                    }
                    if (moveStatus == 0 && BattleSystem_Random(battleSystem) % 2 == 0) {
                        ctx->unk_21A4[battlerId] = i;
                        return TRUE;
                    }

                    moveStatus = 0;
                    if (ctx->battleMons[defender2].hp) {
                        ov12_02252054(ctx, move, moveType, GetMonData(mon, MON_DATA_ABILITY, NULL), GetBattlerAbility(ctx, defender2), GetBattlerHeldItemEffect(ctx, defender2), GetBattlerVar(ctx, defender2, BMON_DATA_TYPE_1, NULL), GetBattlerVar(ctx, defender2, BMON_DATA_TYPE_2, NULL), &moveStatus);
                    }
                    if (moveStatus == 0 && BattleSystem_Random(battleSystem) % 2 == 0) {
                        ctx->unk_21A4[battlerId] = i;
                        return TRUE;
                    }
                }
            }
        }
    }

    return FALSE;
}
