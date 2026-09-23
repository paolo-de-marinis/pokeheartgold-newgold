#ifndef POKEHEARTGOLD_BATTLE_BAG_H
#define POKEHEARTGOLD_BATTLE_BAG_H

#include "battle/battle_system.h"

#include "bg_window.h"
#include "item.h"
#include "message_format.h"
#include "msgdata.h"
#include "pm_string.h"

// The parts of the battle bag's arguments and state that the decompiled
// routines read. The rest of overlay 8 addresses both by offset; nothing may
// allocate or copy these by size.
typedef struct BattleBagArgs {
    BattleSystem *battleSystem;
    PlayerProfile *playerProfile;
    u8 unk8[4];
    enum HeapID heapID; // 0x0C
    int battlerId;      // 0x10
    u8 unk14[4];
    int embargoTurns; // 0x18
    u16 itemId;       // 0x1C
    u8 unk1E[4];
    u8 twoTargets;    // 0x22
    u8 targetHidden;  // 0x23
    u8 targetHidden2; // 0x24
} BattleBagArgs;

typedef struct BattleBag {
    BattleBagArgs *args;
    u8 unk4[0xC];
    MsgData *msgData;         // 0x10, bank 5
    MessageFormat *msgFormat; // 0x14
    String *msgBuffer;        // 0x18
    u8 unk1C[0x2C - 0x1C];
    Window *windows;          // 0x2C
    u8 unk30[0x3C - 0x30];
    ItemSlot pocketItems[4][36]; // 0x3C, the four lists the battle bag shows
    u8 unk27C[0x114B - 0x27C];
    u8 nextState; // 0x114B
    u8 unk114C;
    u8 pocket; // 0x114D
} BattleBag;

void ov08_02223A3C(BattleBag *bag, int index);

#endif // POKEHEARTGOLD_BATTLE_BAG_H
