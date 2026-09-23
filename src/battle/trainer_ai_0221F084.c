#include "constants/abilities.h"
#include "constants/battle.h"
#include "constants/items.h"
#include "constants/moves.h"

#include "battle/battle_command.h"
#include "battle/battle_system.h"
#include "battle/overlay_12_0224E4FC.h"
#include "battle/trainer_ai.h"

// The damage the AI expects the battler to deal to its target with a move, as
// a percentage roll of the calculation: the power and type of the moves whose
// own are worked out when used, a fixed damage for the ones that deal one, and
// nothing against a target the move cannot touch.
u32 ov10_0221F084(BattleSystem *battleSystem, BattleContext *ctx, u16 move, u16 heldItem, u8 *ivs, int battlerId, int ability, int embargoTurns, u8 roll) {
    int i;
    int side;
    int power;
    int type;
    u32 moveStatusFlag;
    int rnd;
    int damage;

    side = BattleSystem_GetFieldSide(battleSystem, ctx->trainerAIData.battlerIdTarget);
    damage = 0;
    power = 0;
    type = 0;
    moveStatusFlag = 0;

    switch (move) {
    case MOVE_NATURAL_GIFT:
        if (ability != ABILITY_KLUTZ && embargoTurns == 0) {
            power = GetItemVar(ctx, heldItem, ITEMATTR_NATURAL_GIFT_POWER);
            if (power) {
                type = GetItemVar(ctx, heldItem, ITEMATTR_NATURAL_GIFT_TYPE);
            }
        }
        break;
    case MOVE_JUDGMENT:
        if (ability != ABILITY_KLUTZ && embargoTurns == 0) {
            switch (GetItemVar(ctx, heldItem, ITEMATTR_HOLD_EFFECT)) {
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
            // Judgment with the Pixie Plate is Fairy, as in GetDynamicMoveType;
            // hg-engine sends this site through its plate-to-type routine.
            case HOLD_EFFECT_ARCEUS_FAIRY:
                type = TYPE_FAIRY;
                break;
            default:
                type = TYPE_NORMAL;
                break;
            }
        }
        break;
    // Techno Blast with a Drive and Multi-Attack with a Memory take its type,
    // as in GetDynamicMoveType, and as Judgment's plate above.
    case MOVE_TECHNO_BLAST:
    case MOVE_MULTI_ATTACK:
        if (ability != ABILITY_KLUTZ && embargoTurns == 0) {
            type = GetDriveOrMemoryType(move, GetItemVar(ctx, heldItem, ITEMATTR_HOLD_EFFECT));
        }
        break;
    case MOVE_HIDDEN_POWER:
        type = (ivs[STAT_HP] & 1) | ((ivs[STAT_ATK] & 1) << 1) | ((ivs[STAT_DEF] & 1) << 2) | ((ivs[STAT_SPEED] & 1) << 3) | ((ivs[STAT_SPATK] & 1) << 4) | ((ivs[STAT_SPDEF] & 1) << 5);
        power = ((ivs[STAT_HP] & 2) >> 1) | (ivs[STAT_ATK] & 2) | ((ivs[STAT_DEF] & 2) << 1) | ((ivs[STAT_SPEED] & 2) << 2) | ((ivs[STAT_SPATK] & 2) << 3) | ((ivs[STAT_SPDEF] & 2) << 4);
        power = power * 40 / 63 + 30;
        type = type * 15 / 63 + 1;
        if (type >= TYPE_MYSTERY) {
            type++;
        }
        break;
    case MOVE_GYRO_BALL:
        power = 25 * ctx->effectiveSpeed[ctx->trainerAIData.battlerIdTarget] / ctx->effectiveSpeed[battlerId] + 1;
        if (power > 150) {
            power = 150;
        }
        type = TYPE_NORMAL;
        break;
    case MOVE_DRAGON_RAGE:
        damage = 40;
        break;
    case MOVE_SEISMIC_TOSS:
    case MOVE_NIGHT_SHADE:
        damage = ctx->battleMons[battlerId].level;
        break;
    case MOVE_PSYWAVE:
        damage = ctx->battleMons[battlerId].level * (BattleSystem_Random(battleSystem) % 11 + 5) / 10;
        break;
    case MOVE_RETURN:
        power = ctx->battleMons[battlerId].friendship * 10 / 25;
        break;
    case MOVE_FRUSTRATION:
        power = (255 - ctx->battleMons[battlerId].friendship) * 10 / 25;
        break;
    case MOVE_MAGNITUDE:
        rnd = BattleSystem_Random(battleSystem) % 100;
        if (rnd < 5) {
            power = 10;
        } else if (rnd < 15) {
            power = 30;
        } else if (rnd < 35) {
            power = 50;
        } else if (rnd < 65) {
            power = 70;
        } else if (rnd < 85) {
            power = 90;
        } else if (rnd < 95) {
            power = 110;
        } else {
            power = 150;
        }
        type = TYPE_NORMAL;
        break;
    case MOVE_SONIC_BOOM:
        damage = 20;
        break;
    case MOVE_BEAT_UP:
        power = BeatUp_TotalPower(battleSystem, ctx, battlerId);
        break;
    case MOVE_LOW_KICK:
    case MOVE_GRASS_KNOT:
        i = 0;
        do {
            if (ov10_0222B068[i][0] >= ctx->battleMons[ctx->trainerAIData.battlerIdTarget].weight) {
                break;
            }
            i++;
        } while (ov10_0222B068[i][0] != 0xFFFF);
        if (ov10_0222B068[i][0] != 0xFFFF) {
            power = ov10_0222B068[i][1];
        } else {
            power = 120;
        }
        break;
    default:
        power = 0;
        type = 0;
        break;
    }

    if (damage == 0) {
        damage = CalcMoveDamage(battleSystem, ctx, move, ctx->fieldSideConditionFlags[side], ctx->fieldCondition, power, type, battlerId, ctx->trainerAIData.battlerIdTarget, 1);
    } else {
        ctx->battleStatus |= BATTLE_STATUS_IGNORE_TYPE_EFFECTIVENESS;
    }

    damage = ov12_02251D28(battleSystem, ctx, move, type, battlerId, ctx->trainerAIData.battlerIdTarget, damage, &moveStatusFlag);
    ctx->battleStatus &= ~BATTLE_STATUS_IGNORE_TYPE_EFFECTIVENESS;

    if (moveStatusFlag & (MOVE_STATUS_NO_EFFECT | MOVE_STATUS_LEVITATE_IMMUNE | MOVE_STATUS_WONDER_GUARD_IMMUNE | MOVE_STATUS_MAGNET_RISE_IMMUNE)) {
        return 0;
    }

    return DamageDivide(damage * roll, 100);
}

// The type of the battler's move, for the trainer AI: GetDynamicMoveType's
// cases, with retail's weather.
int ov10_0221F47C(BattleSystem *battleSystem, BattleContext *ctx, int battlerId, int moveNo) {
    int type;

    switch (moveNo) {
    case MOVE_NATURAL_GIFT:
        type = GetNaturalGiftType(ctx, battlerId);
        break;
    case MOVE_JUDGMENT:
        switch (GetBattlerHeldItemEffect(ctx, battlerId)) {
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
        // Judgment with the Pixie Plate is Fairy, as in GetDynamicMoveType;
        // hg-engine sends this site through its plate-to-type routine.
        case HOLD_EFFECT_ARCEUS_FAIRY:
            type = TYPE_FAIRY;
            break;
        default:
            type = TYPE_NORMAL;
            break;
        }
        break;
    case MOVE_TECHNO_BLAST:
    case MOVE_MULTI_ATTACK:
        type = GetDriveOrMemoryType(moveNo, GetBattlerHeldItemEffect(ctx, battlerId));
        break;
    case MOVE_HIDDEN_POWER:
        type = (ctx->battleMons[battlerId].hpIV & 1) | ((ctx->battleMons[battlerId].atkIV & 1) << 1) | ((ctx->battleMons[battlerId].defIV & 1) << 2) | ((ctx->battleMons[battlerId].speedIV & 1) << 3) | ((ctx->battleMons[battlerId].spAtkIV & 1) << 4) | ((ctx->battleMons[battlerId].spDefIV & 1) << 5);

        type = (type * 15 / 63) + 1;

        if (type >= TYPE_MYSTERY) {
            type++;
        }
        break;
    case MOVE_WEATHER_BALL:
        // Normal unless a weather below makes it something else, as in
        // GetDynamicMoveType.
        type = TYPE_NORMAL;
        if (!CheckAbilityActive(battleSystem, ctx, CHECK_ABILITY_ALL_HP, 0, ABILITY_CLOUD_NINE) && !CheckAbilityActive(battleSystem, ctx, CHECK_ABILITY_ALL_HP, 0, ABILITY_AIR_LOCK)) {
            if (ctx->fieldCondition & FIELD_CONDITION_WEATHER) {
                if (ctx->fieldCondition & FIELD_CONDITION_RAIN_ALL) {
                    type = TYPE_WATER;
                }
                if (ctx->fieldCondition & FIELD_CONDITION_SANDSTORM_ALL) {
                    type = TYPE_ROCK;
                }
                if (ctx->fieldCondition & FIELD_CONDITION_SUN_ALL) {
                    type = TYPE_FIRE;
                }
                if (ctx->fieldCondition & (FIELD_CONDITION_HAIL_ALL | FIELD_CONDITION_SNOW_ALL)) {
                    type = TYPE_ICE;
                }
            }
        }
        break;
    default:
        type = TYPE_NORMAL;
        break;
    }

    return type;
}
