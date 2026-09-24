#include "battle/battle_controller.h"
#include "battle/battle_system.h"

// A battler's own sprite back where its substitute's was (RestoreSprite):
// how every battler on the field looks, in the packet the substitute's swap
// sends.
void BattleController_EmitRestoreSprite(BattleSystem *battleSystem, BattleContext *ctx, int battlerId) {
    BattlerSpritesCommand data;
    int i;

    data.command = 56;

    for (i = 0; i < BATTLER_MAX; i++) {
        data.battlerSpecies[i] = ctx->battleMons[i].species;
        data.battlerShiny[i] = ctx->battleMons[i].shiny;
        data.battlerForm[i] = ctx->battleMons[i].form;

        if (ctx->battleMons[i].status2 & STATUS2_TRANSFORM) {
            data.battlerGender[i] = ctx->battleMons[i].unk88.transformGender;
            data.battlerPersonality[i] = ctx->battleMons[i].unk88.transformPersonality;
        } else {
            data.battlerGender[i] = ctx->battleMons[i].gender;
            data.battlerPersonality[i] = ctx->battleMons[i].personality;
        }
    }

    ov12_02262240(battleSystem, 1, battlerId, &data, sizeof(BattlerSpritesCommand));
}
