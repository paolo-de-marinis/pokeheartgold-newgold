#ifndef POKEHEARTGOLD_BAG_APP_STATE_H
#define POKEHEARTGOLD_BAG_APP_STATE_H

#include "bag.h"
#include "bg_window.h"
#include "filesystem.h"
#include "item.h"
#include "message_format.h"
#include "msgdata.h"
#include "message_printer.h"
#include "nnsys.h"
#include "pm_string.h"

// Only the fields the machine labels read are identified here. Do not
// allocate or copy the bag's state using this type's size; the remaining bag
// assembly owns the rest of it.
typedef struct BagAppStatePrefix {
    u8 unk000[0x238];
    Bag *bag;
    u8 unk23C[0x244 - 0x23C];
    NARC *graphics;
    u8 unk248[0x2EC - 0x248];
    MessagePrinter *msgPrinter;
    MsgData *msgData;
    MessageFormat *messageFormat;
    u8 unk2F8[0x5EC - 0x2F8];
    String *unk5EC;
} BagAppStatePrefix;

struct BagItemListPrefix;

void ov15_021FE914(BagAppStatePrefix *state, Window *window, ItemSlot *slot, u32 y);
void ov15_021FF570(BagAppStatePrefix *state, Window *window, String *name, struct BagItemListPrefix *list, u32 index);
void *ov15_021FE990(BagAppStatePrefix *state, NNSG2dCharacterData **charData);
void ov15_021FE9B0(BagAppStatePrefix *state, Window *window, u32 badge, u32 y);

#endif // POKEHEARTGOLD_BAG_APP_STATE_H
