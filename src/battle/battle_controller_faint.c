#include "battle/battle_controller.h"
#include "battle/battle_system.h"

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

void BattleController_EmitPlayFaintAnimation(BattleSystem *battleSystem, BattleContext *ctx, int battlerId) {
    FaintCommand data;
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

    ov12_02262240(battleSystem, 1, battlerId, &data, sizeof(FaintCommand));
}
