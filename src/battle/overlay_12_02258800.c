#include "constants/abilities.h"
#include "constants/battle.h"
#include "constants/items.h"
#include "constants/moves.h"
#include "constants/species.h"

#include "battle/battle_controller_opponent.h"
#include "battle/battle_system.h"
#include "battle/overlay_12_0224E4FC.h"

#include "pokemon.h"

// The party slot a trainer sends out after one of its Pokemon faints. The
// first choice is the Pokemon whose types do best against a random opponent,
// if it also knows a move that is super effective against it; failing that,
// the Pokemon with the move that deals the most damage. 6 means no choice.
int ov12_02258800(BattleSystem *battleSystem, int battlerId) {
    int i;
    int j;
    u8 defender;
    u8 defenderType1;
    u8 defenderType2;
    u8 monType1;
    u8 monType2;
    u16 move;
    int moveType;
    u8 picked = 6;
    u8 invalidMons;
    u8 score;
    u8 maxScore;
    u8 battler;
    u8 partner;
    int partySize;
    u32 moveStatus;
    Pokemon *mon;
    u16 species;
    BattleContext *ctx = BattleSystem_GetBattleContext(battleSystem);

    battler = battlerId;
    if ((BattleSystem_GetBattleType(battleSystem) & BATTLE_TYPE_TAG) || (BattleSystem_GetBattleType(battleSystem) & BATTLE_TYPE_MULTI)) {
        partner = battler;
    } else {
        partner = BattleSystem_GetBattlerIdPartner(battleSystem, battlerId);
    }

    defender = Battler_GetRandomOpposingBattlerId(battleSystem, ctx, battlerId);
    partySize = BattleSystem_GetPartySize(battleSystem, battlerId);
    invalidMons = 0;

    while (invalidMons != 0x3F) {
        maxScore = 0;
        picked = 6;
        for (i = 0; i < partySize; i++) {
            mon = BattleSystem_GetPartyMon(battleSystem, battlerId, i);
            species = GetMonData(mon, MON_DATA_SPECIES_OR_EGG, NULL);
            if (species != SPECIES_NONE
                && species != SPECIES_EGG
                && GetMonData(mon, MON_DATA_HP, NULL)
                && !(MaskOfFlagNo(i) & invalidMons)
                && i != ctx->selectedMonIndex[battler]
                && i != ctx->selectedMonIndex[partner]
                && i != ctx->unk_21A4[battler]
                && i != ctx->unk_21A4[partner]) {
                defenderType1 = GetBattlerVar(ctx, defender, BMON_DATA_TYPE_1, NULL);
                defenderType2 = GetBattlerVar(ctx, defender, BMON_DATA_TYPE_2, NULL);
                monType1 = GetMonData(mon, MON_DATA_TYPE_1, NULL);
                monType2 = GetMonData(mon, MON_DATA_TYPE_2, NULL);
                score = CalculateTypeEffectiveness(monType1, defenderType1, defenderType2);
                score += CalculateTypeEffectiveness(monType2, defenderType1, defenderType2);
                if (maxScore < score) {
                    maxScore = score;
                    picked = i;
                }
            } else {
                invalidMons |= MaskOfFlagNo(i);
            }
        }

        if (picked != 6) {
            mon = BattleSystem_GetPartyMon(battleSystem, battlerId, picked);
            for (i = 0; i < MAX_MON_MOVES; i++) {
                move = GetMonData(mon, MON_DATA_MOVE1 + i, NULL);
                moveType = ov12_02258BB4(battleSystem, ctx, mon, move);
                if (move != MOVE_NONE) {
                    moveStatus = 0;
                    ov12_02252054(ctx, move, moveType, GetMonData(mon, MON_DATA_ABILITY, NULL), GetBattlerAbility(ctx, defender), GetBattlerHeldItemEffect(ctx, defender), GetBattlerVar(ctx, defender, BMON_DATA_TYPE_1, NULL), GetBattlerVar(ctx, defender, BMON_DATA_TYPE_2, NULL), &moveStatus);
                    if (moveStatus & MOVE_STATUS_SUPER_EFFECTIVE) {
                        break;
                    }
                }
            }
            if (i == MAX_MON_MOVES) {
                invalidMons |= MaskOfFlagNo(picked);
            } else {
                return picked;
            }
        } else {
            invalidMons = 0x3F;
        }
    }

    maxScore = 0;
    picked = 6;
    for (i = 0; i < partySize; i++) {
        mon = BattleSystem_GetPartyMon(battleSystem, battlerId, i);
        species = GetMonData(mon, MON_DATA_SPECIES_OR_EGG, NULL);
        if (species != SPECIES_NONE
            && species != SPECIES_EGG
            && GetMonData(mon, MON_DATA_HP, NULL)
            && i != ctx->selectedMonIndex[battler]
            && i != ctx->selectedMonIndex[partner]
            && i != ctx->unk_21A4[battler]
            && i != ctx->unk_21A4[partner]) {
            for (j = 0; j < MAX_MON_MOVES; j++) {
                move = GetMonData(mon, MON_DATA_MOVE1 + j, NULL);
                moveType = ov12_02258BB4(battleSystem, ctx, mon, move);
                if (move != MOVE_NONE && BattleMoveTbl(ctx, move)->power != 1) {
                    score = CalcMoveDamage(battleSystem, ctx, move, ctx->fieldSideConditionFlags[BattleSystem_GetFieldSide(battleSystem, defender)], ctx->fieldCondition, 0, 0, battlerId, defender, 1);
                    moveStatus = 0;
                    score = ov12_02251D28(battleSystem, ctx, move, moveType, battlerId, defender, score, &moveStatus);
                    if (moveStatus & (MOVE_STATUS_NO_EFFECT | MOVE_STATUS_LEVITATE_IMMUNE | MOVE_STATUS_WONDER_GUARD_IMMUNE | MOVE_STATUS_MAGNET_RISE_IMMUNE)) {
                        score = 0;
                    }
                }
                if (maxScore < score) {
                    maxScore = score;
                    picked = i;
                }
            }
        }
    }

    return picked;
}

u8 ov12_02258BA0(BattleSystem *battleSystem, int battlerId) {
    return BattleSystem_GetBattleContext(battleSystem)->unk_21A4[battlerId];
}

// The type of a party Pokemon's move, for the trainer AI: GetDynamicMoveType's
// cases, worked out from the Pokemon rather than a battler.
int ov12_02258BB4(BattleSystem *battleSystem, BattleContext *ctx, Pokemon *mon, int moveNo) {
    int type;

    switch (moveNo) {
    case MOVE_NATURAL_GIFT:
        type = GetItemVar(ctx, GetMonData(mon, MON_DATA_HELD_ITEM, NULL), ITEMATTR_NATURAL_GIFT_TYPE);
        break;
    case MOVE_JUDGMENT:
        switch (GetItemVar(ctx, GetMonData(mon, MON_DATA_HELD_ITEM, NULL), ITEMATTR_HOLD_EFFECT)) {
        case HOLD_EFFECT_ARCEUS_FIGHTING:
            type = TYPE_FIGHTING;
            break;
        case HOLD_EFFECT_ARCEUS_FLYING:
            type = TYPE_FLYING;
            break;
        case HOLD_EFFECT_ARCEUS_POISON:
            type = TYPE_POISON;
            break;
        case HOLD_EFFECT_ARCEUS_GROUND:
            type = TYPE_GROUND;
            break;
        case HOLD_EFFECT_ARCEUS_ROCK:
            type = TYPE_ROCK;
            break;
        case HOLD_EFFECT_ARCEUS_BUG:
            type = TYPE_BUG;
            break;
        case HOLD_EFFECT_ARCEUS_GHOST:
            type = TYPE_GHOST;
            break;
        case HOLD_EFFECT_ARCEUS_STEEL:
            type = TYPE_STEEL;
            break;
        case HOLD_EFFECT_ARCEUS_FIRE:
            type = TYPE_FIRE;
            break;
        case HOLD_EFFECT_ARCEUS_WATER:
            type = TYPE_WATER;
            break;
        case HOLD_EFFECT_ARCEUS_GRASS:
            type = TYPE_GRASS;
            break;
        case HOLD_EFFECT_ARCEUS_ELECTRIC:
            type = TYPE_ELECTRIC;
            break;
        case HOLD_EFFECT_ARCEUS_PSYCHIC:
            type = TYPE_PSYCHIC;
            break;
        case HOLD_EFFECT_ARCEUS_ICE:
            type = TYPE_ICE;
            break;
        case HOLD_EFFECT_ARCEUS_DRAGON:
            type = TYPE_DRAGON;
            break;
        case HOLD_EFFECT_ARCEUS_DARK:
            type = TYPE_DARK;
            break;
        default:
            type = TYPE_NORMAL;
            break;
        }
        break;
    case MOVE_HIDDEN_POWER:
        type = (GetMonData(mon, MON_DATA_HP_IV, NULL) & 1) | ((GetMonData(mon, MON_DATA_ATK_IV, NULL) & 1) << 1) | ((GetMonData(mon, MON_DATA_DEF_IV, NULL) & 1) << 2) | ((GetMonData(mon, MON_DATA_SPEED_IV, NULL) & 1) << 3) | ((GetMonData(mon, MON_DATA_SPATK_IV, NULL) & 1) << 4) | ((GetMonData(mon, MON_DATA_SPDEF_IV, NULL) & 1) << 5);

        type = (type * 15 / 63) + 1;

        if (type >= TYPE_MYSTERY) {
            type++;
        }
        break;
    case MOVE_WEATHER_BALL:
        if (!CheckAbilityActive(battleSystem, ctx, CHECK_ABILITY_ALL_HP, 0, ABILITY_CLOUD_NINE) && !CheckAbilityActive(battleSystem, ctx, CHECK_ABILITY_ALL_HP, 0, ABILITY_AIR_LOCK)) {
            // Retail's weather: snow, which FIELD_CONDITION_WEATHER takes in
            // now, is not asked after here.
            if (ctx->fieldCondition & (FIELD_CONDITION_WEATHER & ~FIELD_CONDITION_SNOW_ALL)) {
                if (ctx->fieldCondition & FIELD_CONDITION_RAIN_ALL) {
                    type = TYPE_WATER;
                }
                if (ctx->fieldCondition & FIELD_CONDITION_SANDSTORM_ALL) {
                    type = TYPE_ROCK;
                }
                if (ctx->fieldCondition & FIELD_CONDITION_SUN_ALL) {
                    type = TYPE_FIRE;
                }
                if (ctx->fieldCondition & FIELD_CONDITION_HAIL_ALL) {
                    type = TYPE_ICE;
                }
                // BUG: as in GetDynamicMoveType, fog leaves type unset, and so
                // does Cloud Nine or Air Lock above.
            }
        }
        break;
    default:
        type = TYPE_NORMAL;
        break;
    }

    return type;
}
