#include "constants/abilities.h"
#include "constants/species.h"

#include "battle/battle_system.h"
#include "battle/overlay_12_0224E4FC.h"
#include "battle/trainer_ai.h"

#include "pokemon.h"

BOOL ov10_0221FE8C(BattleSystem *battleSystem, BattleContext *ctx, int battlerId) {
    int ability;
    u8 battlerIdSelf;
    u8 battlerIdPartner;
    int partyCount;
    int i;
    Pokemon *mon;

    if (ov10_0221FD34(battleSystem, ctx, battlerId, TRUE) && BattleSystem_Random(battleSystem) % 3 != 0) {
        return FALSE;
    }
    if (ctx->moveNoHit[battlerId] == MOVE_NONE) {
        return FALSE;
    }
    if (ctx->trainerAIData.moveData[ctx->moveNoHit[battlerId]].power == 0) {
        return FALSE;
    }

    if (ctx->trainerAIData.moveData[ctx->moveNoHit[battlerId]].type == TYPE_FIRE) {
        ability = ABILITY_FLASH_FIRE;
    } else if (ctx->trainerAIData.moveData[ctx->moveNoHit[battlerId]].type == TYPE_WATER) {
        ability = ABILITY_WATER_ABSORB;
    } else if (ctx->trainerAIData.moveData[ctx->moveNoHit[battlerId]].type == TYPE_ELECTRIC) {
        ability = ABILITY_VOLT_ABSORB;
    } else {
        return FALSE;
    }

    if (ability == GetBattlerAbility(ctx, battlerId)) {
        return FALSE;
    }

    battlerIdSelf = battlerId;
    if ((BattleSystem_GetBattleType(battleSystem) & BATTLE_TYPE_TAG)
        || (BattleSystem_GetBattleType(battleSystem) & BATTLE_TYPE_MULTI)) {
        battlerIdPartner = battlerIdSelf;
    } else {
        battlerIdPartner = BattleSystem_GetBattlerIdPartner(battleSystem, battlerId);
    }

    partyCount = BattleSystem_GetPartySize(battleSystem, battlerId);
    for (i = 0; i < partyCount; i++) {
        mon = BattleSystem_GetPartyMon(battleSystem, battlerId, i);
        if (GetMonData(mon, MON_DATA_HP, NULL) == 0
            || GetMonData(mon, MON_DATA_SPECIES_OR_EGG, NULL) == SPECIES_NONE
            || GetMonData(mon, MON_DATA_SPECIES_OR_EGG, NULL) == SPECIES_EGG
            || i == ctx->selectedMonIndex[battlerIdSelf]
            || i == ctx->selectedMonIndex[battlerIdPartner]
            || i == ctx->unk_21A4[battlerIdSelf]
            || i == ctx->unk_21A4[battlerIdPartner]) {
            continue;
        }

        // Retain the vanilla narrowing until the expanded-ability contract is ported.
        if (ability == (u8)GetMonData(mon, MON_DATA_ABILITY, NULL) && (BattleSystem_Random(battleSystem) & 1)) {
            ctx->unk_21A4[battlerId] = i;
            return TRUE;
        }
    }

    return FALSE;
}
