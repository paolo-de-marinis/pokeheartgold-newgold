#include "global.h"

#include "constants/battle.h"
#include "constants/pokemon.h"

#include "battle/battle.h"
#include "battle/battle_system.h"

#include "pokemon.h"
#include "pokepic.h"
#include "unk_02013FDC.h"

// The packet BattleController_EmitChangeForm sends
// (battle_controller_change_form.c).
typedef struct ChangeFormCommand {
    u8 command;
    u8 form;
    u16 species;
    u8 gender;
    u8 shiny;
    u32 personality;
} ChangeFormCommand;

s16 ov07_02234B5C(int battlerType, int coord);
void ov12_02259928(OpponentData *opponentData);
void ov12_0226430C(BattleSystem *battleSystem, int battlerId, int a2);
void ov12_022593FC(BattleSystem *battleSystem, OpponentData *opponentData);

// ChangeForm: the battler's sprite redrawn in place from the packet's species,
// form, colours, sex and personality, stood on the ground by its picture's
// height.
void ov12_022593FC(BattleSystem *battleSystem, OpponentData *opponentData) {
    ChangeFormCommand *data = (ChangeFormCommand *)opponentData->command;
    PokepicTemplate template;
    PokepicTemplate *pokepicTemplate;
    int facing;
    int height;

    facing = (opponentData->battlerType & BATTLER_TYPE_IS_ENEMY) ? MON_PIC_FACING_FRONT : MON_PIC_FACING_BACK;
    GetMonSpriteCharAndPlttNarcIdsEx(&template, data->species, data->gender, facing, data->shiny, data->form, data->personality);
    pokepicTemplate = Pokepic_GetTemplate(opponentData->pokepic);
    *pokepicTemplate = template;
    Pokepic_ScheduleReloadFromNarc(opponentData->pokepic);
    sub_02014540((NarcId)pokepicTemplate->narcID, pokepicTemplate->charDataID, HEAP_ID_BATTLE, ov12_0223BB94(ov12_0223A99C(battleSystem), opponentData->unk194), data->personality, FALSE, facing, pokepicTemplate->species);
    ov12_0223BBA8(ov12_0223A99C(battleSystem), opponentData->unk194, pokepicTemplate->narcID);
    ov12_0223BBC0(ov12_0223A99C(battleSystem), opponentData->unk194, pokepicTemplate->palDataID);
    height = GetMonPicHeightBySpeciesGenderForm(data->species, data->gender, facing, data->form, data->personality);
    ov12_0223BBD8(ov12_0223A99C(battleSystem), opponentData->unk194, height);
    Pokepic_SetAttr(opponentData->pokepic, POKEPIC_Y, height + ov07_02234B5C(opponentData->battlerType, 1));
    ov12_0226430C(battleSystem, opponentData->unk194, data->command);
    ov12_02259928(opponentData);
}
