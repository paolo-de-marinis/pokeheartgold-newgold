#include "battle/battle_controller.h"
#include "battle/battle_system.h"
#include "battle/overlay_12_0224E4FC.h"

#include "pokemon.h"

// What the opponent controller plays a faint from: the fainting battler's
// species, form, sex and personality, whether a substitute or a transformation
// stands in for it, and how every battler on the field looks.
typedef struct FaintCommand {
    u8 command;
    u8 gender;
    u16 species;
    u32 personality;
    u8 form;
    u8 substitute;
    u8 transformed;
    u16 battlerSpecies[BATTLER_MAX];
    u8 battlerGender[BATTLER_MAX];
    u8 battlerShiny[BATTLER_MAX];
    u8 battlerForm[BATTLER_MAX];
    u32 battlerPersonality[BATTLER_MAX];
} FaintCommand;

// The opponent controller reads this packet by offset.
typedef char FaintCommandSizeCheck[sizeof(FaintCommand) == 0x30 ? 1 : -1];

// Illusion: a battler made up as another Pokemon is drawn as it. A move's
// damage drops the disguise before its blow faints anyone, so the one that
// faints in it fell without a hit -- to poison, the weather, recoil, Destiny
// Bond -- and falls as the Pokemon it seems, with that one's cry (Pokemon
// Central, Illusione). The reference plays retail's faint, from the battler.
void BattleController_EmitPlayFaintAnimation(BattleSystem *battleSystem, BattleContext *ctx, int battlerId) {
    FaintCommand data;
    Pokemon *disguise;
    int i;

    data.command = 26;
    data.species = ctx->battleMons[battlerId].species;
    data.form = ctx->battleMons[battlerId].form;
    data.substitute = (ctx->battleMons[battlerId].status2 & STATUS2_SUBSTITUTE) ? TRUE : FALSE;
    data.transformed = (ctx->battleMons[battlerId].status2 & STATUS2_TRANSFORM) ? TRUE : FALSE;

    if (ctx->battleMons[battlerId].status2 & STATUS2_TRANSFORM) {
        data.gender = ctx->battleMons[battlerId].unk88.transformGender;
        data.personality = ctx->battleMons[battlerId].unk88.transformPersonality;
    } else {
        data.gender = ctx->battleMons[battlerId].gender;
        data.personality = ctx->battleMons[battlerId].personality;
    }

    disguise = Battler_IllusionMon(battleSystem, battlerId);
    if (disguise != NULL) {
        data.species = GetMonData(disguise, MON_DATA_SPECIES, NULL);
        data.form = GetMonData(disguise, MON_DATA_FORM, NULL);
        data.gender = GetMonGender(disguise);
        data.personality = GetMonData(disguise, MON_DATA_PERSONALITY, NULL);
    }

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

    ov12_02262240(battleSystem, 1, battlerId, &data, sizeof(FaintCommand));
}
