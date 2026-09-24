#ifndef POKEHEARTGOLD_OVERLAY_31_0225D60C_H
#define POKEHEARTGOLD_OVERLAY_31_0225D60C_H

#include "message_format.h"
#include "msgdata.h"
#include "pm_string.h"

// Overlay 31's state, the mart's bottom screen: 0x190 bytes from HEAP_ID_8.
// Only what the C reads is named; the assembly reaches the rest by offset.
typedef struct MartBottomScreen {
    u8 unk0[0x154];
    MessageFormat *msgFormat;
    MsgData *msgData;   // msg_0435, the mart's own lines
    MsgData *itemNames; // msg_0222
    u8 unk160[0x188 - 0x160];
    String *string;
    u8 unk18C[0x190 - 0x18C];
} MartBottomScreen;

void ov31_0225D60C(MartBottomScreen *screen);

#endif // POKEHEARTGOLD_OVERLAY_31_0225D60C_H
