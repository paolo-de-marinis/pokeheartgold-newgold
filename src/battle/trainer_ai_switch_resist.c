#include "constants/abilities.h"
#include "constants/items.h"
#include "constants/species.h"

#include "battle/battle_controller_opponent.h"
#include "battle/battle_system.h"
#include "battle/overlay_12_0224E4FC.h"
#include "battle/trainer_ai.h"

#include "pokemon.h"

// Whether the party has a member that takes the last move to hit this battler
// in a way checkEffectiveness names, and itself has a move super effective
// against whoever used it; if so, that member is left in unk_21A4, one time
// in randomDenominator.
BOOL ov10_02220010(BattleSystem *battleSystem, BattleContext *ctx, int battlerId, u32 checkEffectiveness, u8 randomDenominator) {
    int i;
    int j;
    u8 battler;
    u8 partner;
    u16 move;
    int moveType;
    int partySize;
    u32 moveStatus;
    Pokemon *mon;

    if (ctx->moveNoHit[battlerId] == MOVE_NONE || ctx->moveNoHitBattler[battlerId] == 0xFF) {
        return FALSE;
    }
    if (ctx->trainerAIData.moveData[ctx->moveNoHit[battlerId]].power == 0) {
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
            moveStatus = 0;
            ov12_02252054(ctx,
                ctx->moveNoHit[battlerId],
                ov10_0221F47C(battleSystem, ctx, ctx->moveNoHitBattler[battlerId], ctx->moveNoHit[battlerId]),
                GetBattlerAbility(ctx, ctx->moveNoHitBattler[battlerId]),
                GetMonData(mon, MON_DATA_ABILITY, NULL),
                GetItemVar(ctx, GetMonData(mon, MON_DATA_HELD_ITEM, NULL), ITEM_VAR_HOLD_EFFECT),
                GetMonData(mon, MON_DATA_TYPE_1, NULL),
                GetMonData(mon, MON_DATA_TYPE_2, NULL),
                &moveStatus);

            if (moveStatus & checkEffectiveness) {
                for (j = 0; j < MAX_MON_MOVES; j++) {
                    move = GetMonData(mon, MON_DATA_MOVE1 + j, NULL);
                    moveType = ov12_02258BB4(battleSystem, ctx, mon, move);
                    if (move != MOVE_NONE) {
                        moveStatus = 0;
                        ov12_02252054(ctx,
                            move,
                            moveType,
                            GetMonData(mon, MON_DATA_ABILITY, NULL),
                            GetBattlerAbility(ctx, ctx->moveNoHitBattler[battlerId]),
                            GetBattlerHeldItemEffect(ctx, ctx->moveNoHitBattler[battlerId]),
                            GetBattlerVar(ctx, ctx->moveNoHitBattler[battlerId], BMON_DATA_TYPE_1, NULL),
                            GetBattlerVar(ctx, ctx->moveNoHitBattler[battlerId], BMON_DATA_TYPE_2, NULL),
                            &moveStatus);
                        if ((moveStatus & MOVE_STATUS_SUPER_EFFECTIVE) && BattleSystem_Random(battleSystem) % randomDenominator == 0) {
                            ctx->unk_21A4[battlerId] = i;
                            return TRUE;
                        }
                    }
                }
            }
        }
    }

    return FALSE;
}

// A sleeping Pokemon with Natural Cure and at least half its HP switches out
// to wake: to a member found as above, or to whoever comes next.
BOOL ov10_02220270(BattleSystem *battleSystem, BattleContext *ctx, int battlerId) {
    if (!(ctx->battleMons[battlerId].status & STATUS_SLEEP)
        || GetBattlerAbility(ctx, battlerId) != ABILITY_NATURAL_CURE
        || ctx->battleMons[battlerId].hp < ctx->battleMons[battlerId].maxHp / 2) {
        return FALSE;
    }

    if (ctx->moveNoHit[battlerId] == MOVE_NONE && (BattleSystem_Random(battleSystem) & 1)) {
        ctx->unk_21A4[battlerId] = 6;
        return TRUE;
    }

    if (ctx->trainerAIData.moveData[ctx->moveNoHit[battlerId]].power == 0 && (BattleSystem_Random(battleSystem) & 1)) {
        ctx->unk_21A4[battlerId] = 6;
        return TRUE;
    }

    if (ov10_02220010(battleSystem, ctx, battlerId, MOVE_STATUS_NO_EFFECT, 1)) {
        return TRUE;
    }

    if (ov10_02220010(battleSystem, ctx, battlerId, MOVE_STATUS_NOT_VERY_EFFECTIVE, 1)) {
        return TRUE;
    }

    if (BattleSystem_Random(battleSystem) & 1) {
        ctx->unk_21A4[battlerId] = 6;
        return TRUE;
    }

    return FALSE;
}
