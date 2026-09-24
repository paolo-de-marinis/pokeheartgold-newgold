#include "battle/battle_controller.h"
#include "battle/battle_system.h"
#include "battle/overlay_12_0224E4FC.h"

#include "pokemon.h"

// What the opponent controller redraws a battler's sprite from in place: its
// species, form, colours, sex and personality -- a transformed battler's are
// the ones it copied.
typedef struct ChangeFormCommand {
    u8 command;
    u8 form;
    u16 species;
    u8 gender;
    u8 shiny;
    u32 personality;
} ChangeFormCommand;

// The opponent controller reads this packet by offset.
typedef char ChangeFormCommandSizeCheck[sizeof(ChangeFormCommand) == 0xC ? 1 : -1];

// Illusion: a battler made up as another Pokemon is redrawn as that Pokemon,
// as its send-out and its substitute's swap draw it (Pokemon Central,
// Illusione: the make-up lasts until a move's damage or the ability's loss
// drops it, and the script that drops it forgets it first). Ally Switch
// redraws both places this way.
void BattleController_EmitChangeForm(BattleSystem *battleSystem, int battlerId) {
    ChangeFormCommand data;
    Pokemon *disguise;

    data.command = 45;
    data.species = battleSystem->ctx->battleMons[battlerId].species;
    data.shiny = battleSystem->ctx->battleMons[battlerId].shiny;
    if (battleSystem->ctx->battleMons[battlerId].status2 & STATUS2_TRANSFORM) {
        data.gender = battleSystem->ctx->battleMons[battlerId].unk88.transformGender;
        data.personality = battleSystem->ctx->battleMons[battlerId].unk88.transformPersonality;
    } else {
        data.gender = battleSystem->ctx->battleMons[battlerId].gender;
        data.personality = battleSystem->ctx->battleMons[battlerId].personality;
    }
    data.form = battleSystem->ctx->battleMons[battlerId].form;
    disguise = Battler_IllusionMon(battleSystem, battlerId);
    if (disguise != NULL) {
        data.species = GetMonData(disguise, MON_DATA_SPECIES, NULL);
        data.shiny = MonIsShiny(disguise);
        data.form = GetMonData(disguise, MON_DATA_FORM, NULL);
        data.gender = GetMonGender(disguise);
        data.personality = GetMonData(disguise, MON_DATA_PERSONALITY, NULL);
    }
    ov12_02262240(battleSystem, 1, battlerId, &data, sizeof(ChangeFormCommand));
}
