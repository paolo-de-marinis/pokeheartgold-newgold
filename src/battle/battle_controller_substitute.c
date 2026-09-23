#include "battle/battle_controller.h"
#include "battle/battle_system.h"

// What the opponent controller swaps a battler's sprite for its substitute's
// from, or back: how every battler on the field looks. The packet is the
// move animation's, whose other fields this leaves unset.
typedef struct SubstituteSpriteCommand {
    u8 command;
    u8 unused1[0x17];
    u16 battlerSpecies[BATTLER_MAX];
    u8 battlerGender[BATTLER_MAX];
    u8 battlerShiny[BATTLER_MAX];
    u8 battlerForm[BATTLER_MAX];
    u32 battlerPersonality[BATTLER_MAX];
    u8 unused2[0x1C];
} SubstituteSpriteCommand;

// The opponent controller reads this packet by offset.
typedef char SubstituteSpriteCommandSizeCheck[sizeof(SubstituteSpriteCommand) == 0x58 ? 1 : -1];

void BattleController_EmitSwapToSubstituteSprite(BattleSystem *battleSystem, BattleContext *ctx, int battlerId) {
    SubstituteSpriteCommand data;
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
    }

    ov12_02262240(battleSystem, 1, battlerId, &data, sizeof(SubstituteSpriteCommand));
}
