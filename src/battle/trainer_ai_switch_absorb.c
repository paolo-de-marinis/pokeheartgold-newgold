#include "constants/abilities.h"
#include "constants/species.h"

#include "battle/battle_system.h"
#include "battle/overlay_12_0224E4FC.h"
#include "battle/trainer_ai.h"

#include "pokemon.h"

// Whether the ability swallows a damaging move of the type: retail's Flash
// Fire, Water Absorb and Volt Absorb, and those the port makes absorbing --
// Lightning Rod and Storm Drain from the fifth generation, Well-Baked Body,
// Sap Sipper and Earth Eater (BattleContext_CheckMoveImmunityFromAbility).
static BOOL AbilityAbsorbsMoveType(int ability, int type) {
    switch (ability) {
    case ABILITY_FLASH_FIRE:
    case ABILITY_WELL_BAKED_BODY:
        return type == TYPE_FIRE;
    case ABILITY_WATER_ABSORB:
    case ABILITY_STORM_DRAIN:
        return type == TYPE_WATER;
    case ABILITY_VOLT_ABSORB:
    case ABILITY_LIGHTNINGROD:
        return type == TYPE_ELECTRIC;
    case ABILITY_SAP_SIPPER:
        return type == TYPE_GRASS;
    case ABILITY_EARTH_EATER:
        return type == TYPE_GROUND;
    }
    return FALSE;
}

// Whether the battler, hit by a damaging move, is switched for a party member
// whose ability swallows the move's type (one in two of those found), unless
// it has such an ability itself.
BOOL ov10_0221FE8C(BattleSystem *battleSystem, BattleContext *ctx, int battlerId) {
    int type;
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
    if (BattleMoveTbl(ctx, ctx->moveNoHit[battlerId])->power == 0) {
        return FALSE;
    }

    type = BattleMoveTbl(ctx, ctx->moveNoHit[battlerId])->type;
    if (AbilityAbsorbsMoveType(GetBattlerAbility(ctx, battlerId), type)) {
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

        if (AbilityAbsorbsMoveType(GetMonData(mon, MON_DATA_ABILITY, NULL), type) && (BattleSystem_Random(battleSystem) & 1)) {
            ctx->unk_21A4[battlerId] = i;
            return TRUE;
        }
    }

    return FALSE;
}
