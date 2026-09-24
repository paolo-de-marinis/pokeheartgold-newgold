#include "constants/abilities.h"
#include "constants/battle.h"
#include "constants/pokemon.h"
#include "constants/species.h"

#include "battle/battle_system.h"
#include "battle/overlay_12_0224E4FC.h"
#include "battle/trainer_ai.h"

#include "pokemon.h"

// Whether the battler has four or more stages raised in all, counting every
// stat above neutral: the trainer AI keeps such a Pokemon in.
BOOL ov10_0222036C(BattleSystem *battleSystem, BattleContext *ctx, int battlerId) {
    int i;
    u8 raised = 0;

    for (i = 0; i < 8; i++) {
        if (ctx->battleMons[battlerId].statChanges[i] > 6) {
            raised += ctx->battleMons[battlerId].statChanges[i] - 6;
        }
    }

    if (raised >= 4) {
        return TRUE;
    }
    return FALSE;
}

// Whether the trainer AI switches the battler out this turn: never when it is
// trapped -- Commander's pair included (Pokemon Central, Torre di Comando),
// a Ghost-type never (Battler_HasGhostType) -- or has no one to send in; otherwise when Perish Song is about to
// take it, when it can do nothing to the foe, when an ability of the party's
// would absorb the foe's move, and so on, unless it is doing well enough
// where it is.
BOOL ov10_022203A4(BattleSystem *battleSystem, BattleContext *ctx, int battlerId) {
    u8 battlerIdSelf;
    u8 battlerIdPartner;
    int cnt;
    int i;
    int partySize;
    Pokemon *mon;

    if (Battler_HeldByCommander(ctx, battlerId)
        || (!Battler_HasGhostType(ctx, battlerId)
            && ((ctx->battleMons[battlerId].status2 & (STATUS2_BIND | STATUS2_MEAN_LOOK))
                || (ctx->battleMons[battlerId].moveEffectFlags & MOVE_EFFECT_FLAG_INGRAIN)
                || CheckAbilityActive(battleSystem, ctx, CHECK_ABILITY_OPPOSING_SIDE, battlerId, ABILITY_SHADOW_TAG)
                || CheckAbilityActive(battleSystem, ctx, CHECK_ABILITY_OPPOSING_SIDE, battlerId, ABILITY_ARENA_TRAP)
                || (CheckAbilityActive(battleSystem, ctx, CHECK_ABILITY_ALL_NOT_USER, battlerId, ABILITY_MAGNET_PULL)
                    && (GetBattlerVar(ctx, battlerId, BMON_DATA_TYPE_1, NULL) == TYPE_STEEL || GetBattlerVar(ctx, battlerId, BMON_DATA_TYPE_2, NULL) == TYPE_STEEL))))) {
        return FALSE;
    }

    cnt = 0;
    battlerIdSelf = battlerId;
    if ((BattleSystem_GetBattleType(battleSystem) & BATTLE_TYPE_TAG) || (BattleSystem_GetBattleType(battleSystem) & BATTLE_TYPE_MULTI)) {
        battlerIdPartner = battlerIdSelf;
    } else {
        battlerIdPartner = BattleSystem_GetBattlerIdPartner(battleSystem, battlerId);
    }

    partySize = BattleSystem_GetPartySize(battleSystem, battlerId);
    for (i = 0; i < partySize; i++) {
        mon = BattleSystem_GetPartyMon(battleSystem, battlerId, i);
        if (GetMonData(mon, MON_DATA_HP, NULL) != 0
            && GetMonData(mon, MON_DATA_SPECIES_OR_EGG, NULL) != SPECIES_NONE
            && GetMonData(mon, MON_DATA_SPECIES_OR_EGG, NULL) != SPECIES_EGG
            && i != ctx->selectedMonIndex[battlerIdSelf]
            && i != ctx->selectedMonIndex[battlerIdPartner]
            && i != ctx->unk_21A4[battlerIdSelf]
            && i != ctx->unk_21A4[battlerIdPartner]) {
            cnt++;
        }
    }

    if (cnt) {
        if (ov10_0221F5F4(ctx, battlerId)) {
            return TRUE;
        }
        if (ov10_0221F62C(battleSystem, ctx, battlerId)) {
            return TRUE;
        }
        if (ov10_0221F7F0(battleSystem, ctx, battlerId)) {
            return TRUE;
        }
        if (ov10_0221FE8C(battleSystem, ctx, battlerId)) {
            return TRUE;
        }
        if (ov10_02220270(battleSystem, ctx, battlerId)) {
            return TRUE;
        }
        if (ov10_0221FD34(battleSystem, ctx, battlerId, FALSE)) {
            return FALSE;
        }
        if (ov10_0222036C(battleSystem, ctx, battlerId)) {
            return FALSE;
        }
        if (ov10_02220010(battleSystem, ctx, battlerId, 8, 2)) {
            return TRUE;
        }
        if (ov10_02220010(battleSystem, ctx, battlerId, 4, 3)) {
            return TRUE;
        }
    }

    return FALSE;
}
