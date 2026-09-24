#include "global.h"

#include "battle/battle_system.h"
#include "msgdata/msg/msg_0006.h"

#include "message_format.h"
#include "msgdata.h"
#include "pm_string.h"
#include "pokemon.h"

#include "battle_party_menu.h"

BOOL ov08_0221DB24(BattlePartyMenu *menu, u8 pos);
u8 ov08_0221DAC4(BattlePartyMenu *menu);
BOOL ov08_0221D91C(BattlePartyMenu *menu);

// Whether the Pokemon picked in the battle party menu can be sent in, with
// the reason in the message buffer when it cannot: one of the multi-battle
// partner's, one with no HP left, one already on the field, an Egg, one the
// ally has already chosen, or none at all while the battler is trapped.
BOOL ov08_0221D91C(BattlePartyMenu *menu) {
    BattlePartyMenuMon *entry = &menu->mons[menu->args->selectedPos];
    String *str;
    int pos;

    if (ov08_0221DB24(menu, menu->args->selectedPos) == TRUE) {
        str = NewString_ReadMsgData(menu->msgData, msg_0006_00080);
        BufferTrainerNameFromDataStruct(menu->msgFormat, 0, BattleSystem_GetTrainer(menu->args->battleSystem, BattleSystem_GetBattlerIdPartner(menu->args->battleSystem, menu->args->battlerId)));
        StringExpandPlaceholders(menu->msgFormat, menu->msgBuffer, str);
        String_Delete(str);
        return FALSE;
    }
    if (entry->hp == 0) {
        str = NewString_ReadMsgData(menu->msgData, msg_0006_00077);
        BufferBoxMonNickname(menu->msgFormat, 0, Mon_GetBoxMon(entry->mon));
        StringExpandPlaceholders(menu->msgFormat, menu->msgBuffer, str);
        String_Delete(str);
        return FALSE;
    }
    if (menu->args->activeSlots[0] == menu->args->partySlots[menu->args->selectedPos] || menu->args->activeSlots[1] == menu->args->partySlots[menu->args->selectedPos]) {
        str = NewString_ReadMsgData(menu->msgData, msg_0006_00076);
        BufferBoxMonNickname(menu->msgFormat, 0, Mon_GetBoxMon(entry->mon));
        StringExpandPlaceholders(menu->msgFormat, menu->msgBuffer, str);
        String_Delete(str);
        return FALSE;
    }
    if (ov08_0221DAC4(menu) == TRUE) {
        ReadMsgDataIntoString(menu->msgData, msg_0006_00079, menu->msgBuffer);
        return FALSE;
    }
    if (menu->args->partnerPick != 6 && menu->args->partnerPick == menu->args->partySlots[pos = menu->args->selectedPos]) {
        str = NewString_ReadMsgData(menu->msgData, msg_0006_00093);
        BufferBoxMonNickname(menu->msgFormat, 0, Mon_GetBoxMon(menu->mons[pos].mon));
        StringExpandPlaceholders(menu->msgFormat, menu->msgBuffer, str);
        String_Delete(str);
        return FALSE;
    }
    if (menu->args->cannotSwitch) {
        entry = &menu->mons[menu->unk2076];
        str = NewString_ReadMsgData(menu->msgData, msg_0006_00078);
        BufferBoxMonNickname(menu->msgFormat, 0, Mon_GetBoxMon(entry->mon));
        StringExpandPlaceholders(menu->msgFormat, menu->msgBuffer, str);
        String_Delete(str);
        return FALSE;
    }
    return TRUE;
}
