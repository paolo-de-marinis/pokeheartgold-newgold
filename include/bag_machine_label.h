#ifndef POKEHEARTGOLD_BAG_MACHINE_LABEL_H
#define POKEHEARTGOLD_BAG_MACHINE_LABEL_H

#include "bg_window.h"
#include "filesystem.h"
#include "item.h"
#include "message_format.h"
#include "message_printer.h"
#include "nnsys.h"
#include "pm_string.h"

// Only the fields the machine labels read are identified here. Do not
// allocate or copy the bag's state using this type's size; the remaining bag
// assembly owns the rest of it.
typedef struct BagAppLabelState {
    u8 unk000[0x244];
    NARC *graphics;
    u8 unk248[0x2EC - 0x248];
    MessagePrinter *msgPrinter;
    u8 unk2F0[0x2F4 - 0x2F0];
    MessageFormat *messageFormat;
    u8 unk2F8[0x5EC - 0x2F8];
    String *unk5EC;
} BagAppLabelState;

void *ov15_021FE990(BagAppLabelState *state, NNSG2dCharacterData **charData);
void ov15_021FE9B0(BagAppLabelState *state, Window *window, u32 y);

#endif // POKEHEARTGOLD_BAG_MACHINE_LABEL_H
