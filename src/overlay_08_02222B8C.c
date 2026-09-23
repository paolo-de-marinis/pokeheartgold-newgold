#include "constants/battle.h"
#include "constants/items.h"
#include "constants/moves.h"
#include "constants/pokemon.h"

#include "battle/battle_system.h"
#include "msgdata/msg.naix"
#include "msgdata/msg/msg_0005.h"
#include "msgdata/msg/msg_0040.h"

#include "item.h"
#include "message_format.h"
#include "msgdata.h"
#include "party.h"
#include "pm_string.h"
#include "pokemon.h"
#include "pokemon_storage_system.h"

#include "battle_bag.h"

int ov08_02223374(BattleBag *bag);
void ov08_02223390(BattleSystem *battleSystem, int itemId, int pocket, enum HeapID heapID);
void ov08_02223B20(BattleBag *bag);
int ov08_02222B8C(BattleBag *bag);

// Whether the item chosen in battle can be used: on the Pokemon picked from
// the party (pocket 3), or as a ball (pocket 2). When it cannot, the reason
// is printed and the bag waits in state 8.
int ov08_02222B8C(BattleBag *bag) {
    BattleBagArgs *args = bag->args;

    if (bag->pocket == 3) {
        int slot = ov08_02223374(bag);
        int useFunc = GetItemAttr(args->itemId, ITEMATTR_BATTLEUSEFUNC, args->heapID);

        if (args->embargoTurns != 0 && args->itemId != ITEM_GUARD_SPEC_ && useFunc != 3) {
            Pokemon *mon = BattleSystem_GetPartyMon(args->battleSystem, args->battlerId, slot);
            String *str = NewString_ReadMsgData(bag->msgData, msg_0005_00046);
            BufferBoxMonNickname(bag->msgFormat, 0, Mon_GetBoxMon(mon));
            BufferMoveName(bag->msgFormat, 1, MOVE_EMBARGO);
            StringExpandPlaceholders(bag->msgFormat, bag->msgBuffer, str);
            String_Delete(str);
            ov08_02223B20(bag);
            bag->nextState = 8;
            return 9;
        }
        if (BattleSystem_RecoverStatus(args->battleSystem, args->battlerId, slot, 0, args->itemId) == TRUE) {
            ov08_02223390(args->battleSystem, args->itemId, bag->pocket, args->heapID);
            return 13;
        }
        if (useFunc == 3) {
            if (!(BattleSystem_GetBattleType(args->battleSystem) & BATTLE_TYPE_TRAINER)) {
                ov08_02223390(args->battleSystem, args->itemId, bag->pocket, args->heapID);
                return 13;
            }
            MsgData *msgData = NewMsgDataFromNarc(MSGDATA_LOAD_LAZY, NARC_msgdata_msg, NARC_msg_msg_0040_bin, args->heapID);
            String *str = NewString_ReadMsgData(msgData, msg_0040_00037);
            BufferPlayersName(bag->msgFormat, 0, args->playerProfile);
            StringExpandPlaceholders(bag->msgFormat, bag->msgBuffer, str);
            String_Delete(str);
            DestroyMsgData(msgData);
            ov08_02223B20(bag);
            bag->nextState = 8;
            return 9;
        }
        ReadMsgDataIntoString(bag->msgData, msg_0005_00034, bag->msgBuffer);
        ov08_02223B20(bag);
        bag->nextState = 8;
        return 9;
    }

    if (bag->pocket == 2) {
        if (args->twoTargets == TRUE) {
            ReadMsgDataIntoString(bag->msgData, msg_0005_00044, bag->msgBuffer);
            ov08_02223B20(bag);
            bag->nextState = 8;
            return 9;
        }
        if (args->targetHidden == TRUE) {
            ReadMsgDataIntoString(bag->msgData, msg_0005_00047, bag->msgBuffer);
            ov08_02223B20(bag);
            bag->nextState = 8;
            return 9;
        }
        if (args->targetHidden2 == TRUE) {
            ReadMsgDataIntoString(bag->msgData, msg_0005_00048, bag->msgBuffer);
            ov08_02223B20(bag);
            bag->nextState = 8;
            return 9;
        }
        Party *party = BattleSystem_GetParty(args->battleSystem, args->battlerId);
        PCStorage *pcStorage = BattleSystem_GetPcStorage(args->battleSystem);
        if (Party_GetCount(party) == PARTY_SIZE && PCStorage_FindFirstBoxWithEmptySlot(pcStorage) == NUM_BOXES) {
            ReadMsgDataIntoString(bag->msgData, msg_0005_00045, bag->msgBuffer);
            ov08_02223B20(bag);
            bag->nextState = 8;
            return 9;
        }
    }

    return 13;
}
