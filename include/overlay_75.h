#ifndef POKEHEARTGOLD_OVERLAY_75_H
#define POKEHEARTGOLD_OVERLAY_75_H

#include "bg_window.h"
#include "message_format.h"
#include "msgdata.h"
#include "overlay_manager.h"
#include "save.h"

// Overlay 75's first application's state (heap 115), as far as the second
// reads it: it is the second's arguments.
typedef struct Overlay75Parent {
    u8 unk0[4];
    SaveData *saveData;
} Overlay75Parent;

// Overlay 75's second application's state: 0x41C bytes from heap 116. Only
// what the C reads is named; the assembly reaches the rest by offset.
typedef struct Overlay75App {
    Overlay75Parent *parent;
    BgConfig *bgConfig;
    int state;
    u8 unkC[0x20 - 0xC];
    MessageFormat *msgFormat;
    MsgData *msgData; // msg_0775
    MsgData *speciesNames; // msg_0237
    MsgData *unk2C; // msg_0778
    MsgData *unk30; // msg_0800
    MsgData *unk34; // msg_0188
    String *unk38;
    String *unk3C;
    String *unk40;
    u8 unk44[0xE8 - 0x44];
    int unkE8;
    u8 unkEC[0x41C - 0xEC];
} Overlay75App;

BOOL ov75_02246F0C(OverlayManager *man, int *state);

#endif // POKEHEARTGOLD_OVERLAY_75_H
