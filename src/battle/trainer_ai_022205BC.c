#include "constants/items.h"
#include "constants/species.h"

#include "battle/battle_controller_opponent.h"
#include "battle/battle_system.h"
#include "battle/overlay_12_0224E4FC.h"
#include "battle/trainer_ai.h"

#include "party.h"
#include "pokemon.h"

static BOOL ov10_022206B0(BattleSystem *battleSystem, int battlerId);

// What the AI's Pokemon does this turn: switches (3), when the switch checks
// say so, to the Pokemon they chose or else the pick's, or the first one able
// that is not already on the field or chosen; uses an item (2); or fights (1).
// Only a trainer's Pokemon, or in a wild battle the player's side's, decides.
int ov10_022205BC(BattleSystem *battleSystem, int battlerId) {
    int i;
    u8 battlerIdSelf;
    u8 battlerIdPartner;
    int partySize;
    BattleContext *ctx = battleSystem->ctx;
    u32 battleType = BattleSystem_GetBattleType(battleSystem);

    if ((battleType & BATTLE_TYPE_TRAINER) || BattleSystem_GetFieldSide(battleSystem, battlerId) == 0) {
        if (ov10_022203A4(battleSystem, ctx, battlerId)) {
            if (ctx->unk_21A4[battlerId] == 6) {
                if ((i = ov12_02258800(battleSystem, battlerId)) == 6) {
                    battlerIdSelf = battlerId;
                    if ((battleType & BATTLE_TYPE_TAG) || (battleType & BATTLE_TYPE_MULTI)) {
                        battlerIdPartner = battlerIdSelf;
                    } else {
                        battlerIdPartner = BattleSystem_GetBattlerIdPartner(battleSystem, battlerId);
                    }
                    partySize = BattleSystem_GetPartySize(battleSystem, battlerId);
                    for (i = 0; i < partySize; i++) {
                        if (GetMonData(BattleSystem_GetPartyMon(battleSystem, battlerId, i), MON_DATA_HP, NULL) != 0
                            && i != ctx->selectedMonIndex[battlerIdSelf]
                            && i != ctx->selectedMonIndex[battlerIdPartner]
                            && i != ctx->unk_21A4[battlerIdSelf]
                            && i != ctx->unk_21A4[battlerIdPartner]) {
                            break;
                        }
                    }
                }
                ctx->unk_21A4[battlerId] = i;
            }
            return 3;
        } else if (ov10_022206B0(battleSystem, battlerId)) {
            return 2;
        }
    }
    return 1;
}

// Whether the AI uses one of its trainer's items this turn, and which: the
// first of the four that would help the battler now -- a Full Restore below a
// quarter of its HP, a potion below a quarter or when the HP missing is more
// than it heals, a status cure it needs, or on its first turn out an X item or
// a Guard Spec -- where item slot i (from 0) waits until at most (the number
// of items less i) of the party still stand: a trainer with two items and six
// Pokemon uses the second once five have fainted. Not for the AI partner in a
// multi battle, nor under Embargo.
static BOOL ov10_022206B0(BattleSystem *battleSystem, int battlerId) {
    int i;
    u16 item;
    u8 hpRestore;
    u8 numAlive;
    BOOL result;
    Party *party;
    Pokemon *mon;
    BattleContext *ctx;

    numAlive = 0;
    ctx = battleSystem->ctx;
    ctx->trainerAIData.unk9F[battlerId >> 1] = 0;
    result = FALSE;

    if ((battleSystem->battleType & (BATTLE_TYPE_TRAINER | BATTLE_TYPE_DOUBLES | BATTLE_TYPE_MULTI | BATTLE_TYPE_AI)) == (BATTLE_TYPE_TRAINER | BATTLE_TYPE_DOUBLES | BATTLE_TYPE_MULTI | BATTLE_TYPE_AI)
        && ov12_0223AB0C(battleSystem, battlerId) == BATTLER_TYPE_PLAYER_SIDE_SLOT_2) {
        return FALSE;
    }
    if (ctx->battleMons[battlerId].moveEffectFlags & MOVE_EFFECT_FLAG_EMBARGO) {
        return FALSE;
    }

    party = BattleSystem_GetParty(battleSystem, battlerId);
    for (i = 0; i < Party_GetCount(party); i++) {
        mon = Party_GetMonByIndex(party, i);
        if (GetMonData(mon, MON_DATA_HP, NULL) != 0
            && GetMonData(mon, MON_DATA_SPECIES_OR_EGG, NULL) != SPECIES_NONE
            && GetMonData(mon, MON_DATA_SPECIES_OR_EGG, NULL) != SPECIES_EGG) {
            numAlive++;
        }
    }

    for (i = 0; i < 4; i++) {
        if (i != 0 && numAlive > ctx->trainerAIData.unk99[battlerId >> 1] - i) {
            continue;
        }
        item = ctx->trainerAIData.unk68[battlerId >> 1][i];
        if (item == ITEM_NONE) {
            continue;
        }

        if (item == ITEM_FULL_RESTORE) {
            if (ctx->battleMons[battlerId].hp < ctx->battleMons[battlerId].maxHp / 4 && ctx->battleMons[battlerId].hp != 0) {
                ctx->trainerAIData.useItem[battlerId >> 1] = 0;
                result = TRUE;
            }
        } else if (GetItemVar(ctx, item, ITEMATTR_HP_RESTORE)) {
            hpRestore = GetItemVar(ctx, item, ITEMATTR_HP_RESTORE_PARAM);
            if (hpRestore && ctx->battleMons[battlerId].hp) {
                if (ctx->battleMons[battlerId].hp < ctx->battleMons[battlerId].maxHp / 4 || ctx->battleMons[battlerId].maxHp - ctx->battleMons[battlerId].hp > hpRestore) {
                    ctx->trainerAIData.useItem[battlerId >> 1] = 1;
                    result = TRUE;
                }
            }
        } else if (GetItemVar(ctx, item, ITEMATTR_SLP_HEAL)) {
            if (ctx->battleMons[battlerId].status & STATUS_SLEEP) {
                ctx->trainerAIData.unk9F[battlerId >> 1] |= MaskOfFlagNo(5);
                ctx->trainerAIData.useItem[battlerId >> 1] = 2;
                result = TRUE;
            }
        } else if (GetItemVar(ctx, item, ITEMATTR_PSN_HEAL)) {
            if ((ctx->battleMons[battlerId].status & STATUS_POISON) || (ctx->battleMons[battlerId].status & STATUS_BAD_POISON)) {
                ctx->trainerAIData.unk9F[battlerId >> 1] |= MaskOfFlagNo(4);
                ctx->trainerAIData.useItem[battlerId >> 1] = 2;
                result = TRUE;
            }
        } else if (GetItemVar(ctx, item, ITEMATTR_BRN_HEAL)) {
            if (ctx->battleMons[battlerId].status & STATUS_BURN) {
                ctx->trainerAIData.unk9F[battlerId >> 1] |= MaskOfFlagNo(3);
                ctx->trainerAIData.useItem[battlerId >> 1] = 2;
                result = TRUE;
            }
        } else if (GetItemVar(ctx, item, ITEMATTR_FRZ_HEAL)) {
            if (ctx->battleMons[battlerId].status & STATUS_FREEZE) {
                ctx->trainerAIData.unk9F[battlerId >> 1] |= MaskOfFlagNo(2);
                ctx->trainerAIData.useItem[battlerId >> 1] = 2;
                result = TRUE;
            }
        } else if (GetItemVar(ctx, item, ITEMATTR_PRZ_HEAL)) {
            if (ctx->battleMons[battlerId].status & STATUS_PARALYSIS) {
                ctx->trainerAIData.unk9F[battlerId >> 1] |= MaskOfFlagNo(1);
                ctx->trainerAIData.useItem[battlerId >> 1] = 2;
                result = TRUE;
            }
        } else if (GetItemVar(ctx, item, ITEMATTR_CFS_HEAL)) {
            if (ctx->battleMons[battlerId].status2 & STATUS2_CONFUSION) {
                ctx->trainerAIData.unk9F[battlerId >> 1] |= MaskOfFlagNo(0);
                ctx->trainerAIData.useItem[battlerId >> 1] = 2;
                result = TRUE;
            }
        } else if (ctx->battleMons[battlerId].unk88.fakeOutCount - ctx->totalTurns >= 0) {
            if (GetItemVar(ctx, item, ITEMATTR_ATK_STAGES)) {
                ctx->trainerAIData.unk9F[battlerId >> 1] = 1;
                ctx->trainerAIData.useItem[battlerId >> 1] = 3;
                result = TRUE;
            } else if (GetItemVar(ctx, item, ITEMATTR_DEF_STAGES)) {
                ctx->trainerAIData.unk9F[battlerId >> 1] = 2;
                ctx->trainerAIData.useItem[battlerId >> 1] = 3;
                result = TRUE;
            } else if (GetItemVar(ctx, item, ITEMATTR_SPATK_STAGES)) {
                ctx->trainerAIData.unk9F[battlerId >> 1] = 4;
                ctx->trainerAIData.useItem[battlerId >> 1] = 3;
                result = TRUE;
            } else if (GetItemVar(ctx, item, ITEMATTR_SPDEF_STAGES)) {
                ctx->trainerAIData.unk9F[battlerId >> 1] = 5;
                ctx->trainerAIData.useItem[battlerId >> 1] = 3;
                result = TRUE;
            } else if (GetItemVar(ctx, item, ITEMATTR_SPEED_STAGES)) {
                ctx->trainerAIData.unk9F[battlerId >> 1] = 3;
                ctx->trainerAIData.useItem[battlerId >> 1] = 3;
                result = TRUE;
            } else if (GetItemVar(ctx, item, ITEMATTR_ACCURACY_STAGES)) {
                ctx->trainerAIData.unk9F[battlerId >> 1] = 6;
                ctx->trainerAIData.useItem[battlerId >> 1] = 3;
                result = TRUE;
            } else if (GetItemVar(ctx, item, ITEMATTR_GUARD_SPEC)) {
                if (!(ctx->fieldSideConditionFlags[1] & SIDE_CONDITION_MIST)) {
                    ctx->trainerAIData.useItem[battlerId >> 1] = 4;
                    result = TRUE;
                }
            }
        } else {
            ctx->trainerAIData.useItem[battlerId >> 1] = 5;
        }

        if (result == TRUE) {
            ctx->trainerAIData.unkA0[battlerId >> 1] = item;
            ctx->trainerAIData.unk68[battlerId >> 1][i] = ITEM_NONE;
            break;
        }
    }

    return result;
}
