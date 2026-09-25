#include "battle/battle_controller.h"
#include "battle/battle_system.h"
#include "battle/overlay_12_0224E4FC.h"
#include "constants/abilities.h"

// The move animation's packet: the move and its two battlers, the damage,
// the power, the weather, and how every battler on the field looks, a
// transformation's where there is one. Sent for the move (BattleController_SetMoveAnimation)
// and built by the opponent controller for its own animations; without a
// BattleContext only the move, the battlers and the terrain.
void ov12_022643C8(BattleSystem *battleSystem, BattleContext *ctx, MoveAnimationCommand *data, int a3, int a4, int attacker, int defender, u16 move) {
    int i;

    data->command = 22;
    data->move = move;
    data->attacker = attacker;
    data->defender = defender;
    data->unk4C = a3;
    data->unk50 = a4;
    data->terrain = BattleSystem_GetTerrainId(battleSystem);
    data->unkE_2 = FALSE;
    data->unkE_3 = FALSE;

    if (ctx == NULL) {
        return;
    }

    data->damage = ctx->damage;
    if (ctx->movePower != 0) {
        data->power = ctx->movePower;
    } else {
        data->power = ctx->trainerAIData.moveData[move].power;
    }
    data->friendship = ctx->battleMons[attacker].friendship;
    if (!CheckAbilityActive(battleSystem, ctx, 8, 0, ABILITY_CLOUD_NINE) && !CheckAbilityActive(battleSystem, ctx, 8, 0, ABILITY_AIR_LOCK)) {
        data->fieldCondition = ctx->fieldCondition;
    } else {
        data->fieldCondition = 0;
    }
    data->unkA = ctx->unk_2164;
    data->substitute = (ctx->battleMons[attacker].status2 & STATUS2_SUBSTITUTE) != 0;
    data->transformed = (ctx->battleMons[attacker].status2 & STATUS2_TRANSFORM) != 0;

    for (i = 0; i < BATTLER_MAX; i++) {
        data->battlerSpecies[i] = ctx->battleMons[i].species;
        data->battlerShiny[i] = ctx->battleMons[i].shiny;
        data->battlerForm[i] = ctx->battleMons[i].form;
        data->battlerMoveEffectFlags[i] = ctx->battleMons[i].moveEffectFlags;
        if (ctx->battleMons[i].status2 & STATUS2_TRANSFORM) {
            data->battlerGender[i] = ctx->battleMons[i].unk88.transformGender;
            data->battlerPersonality[i] = ctx->battleMons[i].unk88.transformPersonality;
        } else {
            data->battlerGender[i] = ctx->battleMons[i].gender;
            data->battlerPersonality[i] = ctx->battleMons[i].personality;
        }
    }

    if (attacker != BATTLER_NONE) {
        u8 index = ov12_0223C140(battleSystem, attacker);
        if (index != 0xFF && index == ctx->selectedMonIndex[attacker]) {
            data->unkE_2 = TRUE;
        }
    }
    if (defender != BATTLER_NONE) {
        u8 index = ov12_0223C140(battleSystem, defender);
        if (index != 0xFF && index == ctx->selectedMonIndex[defender]) {
            data->unkE_3 = TRUE;
        }
    }
}
