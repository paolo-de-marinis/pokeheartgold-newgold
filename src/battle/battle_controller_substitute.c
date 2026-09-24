#include "battle/battle_controller.h"
#include "battle/battle_system.h"
#include "battle/overlay_12_0224E4FC.h"

#include "pokemon.h"

// Illusion: a battler made up as another Pokemon is drawn back as it when its
// substitute goes (Pokemon Central, Illusione: the disguise stays until a
// move's damage or the ability's loss drops it). The reference draws every
// battler as itself.
void BattleController_EmitSwapToSubstituteSprite(BattleSystem *battleSystem, BattleContext *ctx, int battlerId) {
    BattlerSpritesCommand data;
    Pokemon *disguise;
    int i;

    data.command = 62;

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

        disguise = Battler_IllusionMon(battleSystem, i);
        if (disguise != NULL) {
            data.battlerSpecies[i] = GetMonData(disguise, MON_DATA_SPECIES, NULL);
            data.battlerShiny[i] = MonIsShiny(disguise);
            data.battlerForm[i] = GetMonData(disguise, MON_DATA_FORM, NULL);
            data.battlerGender[i] = GetMonGender(disguise);
            data.battlerPersonality[i] = GetMonData(disguise, MON_DATA_PERSONALITY, NULL);
        }
    }

    ov12_02262240(battleSystem, 1, battlerId, &data, sizeof(BattlerSpritesCommand));
}
