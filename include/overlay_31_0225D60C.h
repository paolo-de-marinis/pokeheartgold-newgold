#ifndef POKEHEARTGOLD_OVERLAY_31_0225D60C_H
#define POKEHEARTGOLD_OVERLAY_31_0225D60C_H

#include "bg_window.h"
#include "message_format.h"
#include "msgdata.h"
#include "options.h"
#include "overlay_03.h"
#include "pm_string.h"

// Overlay 31's state, the mart's bottom screen: 0x190 bytes from HEAP_ID_8.
// Only what the C reads is named; the assembly reaches the rest by offset.
typedef struct MartBottomScreen {
    u8 unk0[4];
    BgConfig *bgConfig;
    u8 unk8[0x14 - 0x8];
    MartData *mart;
    u8 unk18[0x84 - 0x18];
    Window rows[6]; // the list's six rows: a name, and the price below it
    u8 unkE4[0x144 - 0xE4];
    Window confirmWindow; // the line that asks to confirm a purchase
    MessageFormat *msgFormat;
    MsgData *msgData;   // msg_0435, the mart's own lines
    MsgData *itemNames; // msg_0222
    u8 unk160[0x164 - 0x160];
    Options *options;
    u8 unk168[0x184 - 0x168];
    int confirmPrinterId;
    String *string;
    u8 unk18C[0x190 - 0x18C];
} MartBottomScreen;

void ov31_0225D60C(MartBottomScreen *screen);

#endif // POKEHEARTGOLD_OVERLAY_31_0225D60C_H
