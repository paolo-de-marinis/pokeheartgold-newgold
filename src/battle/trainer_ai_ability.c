#include "constants/abilities.h"

#include "battle/battle_system.h"
#include "battle/trainer_ai.h"

#include "pokemon.h"

// AI script battlers are relative to the attacker selecting a move.
enum {
    AI_BATTLER_TARGET,
    AI_BATTLER_ATTACKER,
    AI_BATTLER_TARGET_PARTNER,
    AI_BATTLER_ATTACKER_PARTNER
};

void ov10_0221D0A8(BattleSystem *battleSystem, BattleContext *ctx) {
    int battler;
    int battlerId;
    int ability1;
    int ability2;

    ov10_0221EF24(ctx, 1);
    battler = ov10_0221EEF0(ctx);
    battlerId = ov10_0221EF34(ctx, battler);

    if (ctx->battleMons[battlerId].moveEffectFlags & MOVE_EFFECT_FLAG_ABILITY_SUPPRESSED) {
        ctx->trainerAIData.unk8 = ABILITY_NONE;
    } else if (ctx->trainerAIData.battlerIdAttacker != battlerId && battler != AI_BATTLER_ATTACKER_PARTNER) {
        if (ctx->trainerAIData.abilities[battlerId] != ABILITY_NONE) {
            ctx->trainerAIData.unk8 = ctx->trainerAIData.abilities[battlerId];
        } else if (ctx->battleMons[battlerId].ability == ABILITY_SHADOW_TAG
            || ctx->battleMons[battlerId].ability == ABILITY_MAGNET_PULL
            || ctx->battleMons[battlerId].ability == ABILITY_ARENA_TRAP) {
            ctx->trainerAIData.unk8 = ctx->battleMons[battlerId].ability;
        } else {
            ability1 = GetMonBaseStat(ctx->battleMons[battlerId].species, BASE_ABILITY_1);
            ability2 = GetMonBaseStat(ctx->battleMons[battlerId].species, BASE_ABILITY_2);

            if (ability1 && ability2) {
                if (BattleSystem_Random(battleSystem) & 1) {
                    ctx->trainerAIData.unk8 = ability1;
                } else {
                    ctx->trainerAIData.unk8 = ability2;
                }
            } else if (ability1) {
                ctx->trainerAIData.unk8 = ability1;
            } else {
                ctx->trainerAIData.unk8 = ability2;
            }
        }
    } else {
        ctx->trainerAIData.unk8 = ctx->battleMons[battlerId].ability;
    }
}

void ov10_0221D188(BattleSystem *battleSystem, BattleContext *ctx) {
    int battler;
    int ability;
    int battlerId;
    int ability1;
    int ability2;

    ov10_0221EF24(ctx, 1);
    battler = ov10_0221EEF0(ctx);
    ability = ov10_0221EEF0(ctx);
    battlerId = ov10_0221EF34(ctx, battler);

    if (ctx->battleMons[battlerId].moveEffectFlags & MOVE_EFFECT_FLAG_ABILITY_SUPPRESSED) {
        ability1 = ABILITY_NONE;
    } else if (battler == AI_BATTLER_TARGET || battler == AI_BATTLER_TARGET_PARTNER) {
        ability1 = ctx->trainerAIData.abilities[battlerId];
        if (ability1 != ABILITY_NONE) {
            ctx->trainerAIData.unk8 = ability1;
        } else {
            ability1 = ctx->battleMons[battlerId].ability;
            if (ability1 != ABILITY_SHADOW_TAG && ability1 != ABILITY_MAGNET_PULL && ability1 != ABILITY_ARENA_TRAP) {
                ability1 = GetMonBaseStat(ctx->battleMons[battlerId].species, BASE_ABILITY_1);
                ability2 = GetMonBaseStat(ctx->battleMons[battlerId].species, BASE_ABILITY_2);

                if (ability1 && ability2) {
                    if (ability1 == ability || ability2 == ability) {
                        ability1 = ABILITY_NONE;
                    }
                } else if (ability1 == ABILITY_NONE) {
                    ability1 = ability2;
                }
            }
        }
    } else {
        ability1 = ctx->battleMons[battlerId].ability;
    }

    if (ability1 == ABILITY_NONE) {
        ctx->trainerAIData.unk8 = 2;
    } else if (ability1 == ability) {
        ctx->trainerAIData.unk8 = 1;
    } else {
        ctx->trainerAIData.unk8 = 0;
    }
}
