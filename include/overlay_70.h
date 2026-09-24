#ifndef POKEHEARTGOLD_OVY_70_H
#define POKEHEARTGOLD_OVY_70_H

#include "bag_types_def.h"
#include "bg_window.h"
#include "game_stats.h"
#include "message_format.h"
#include "msgdata.h"
#include "options.h"
#include "overlay_manager.h"
#include "pokedex.h"
#include "pokemon_types_def.h"
#include "unk_020755E8.h"

// The Global Trade Station's shared data, as far as the C reads it.
typedef struct GtsArgs {
    void *gtsSave; // the save's GTS block: the Pokemon on deposit
    u8 unk04[0xC];
    Pokedex *pokedex;
    u8 unk14[0x10];
    Options *options;
    GameStats *gameStats;
    Bag *bag;
    u8 unk30[0x8];
    u32 unk38;
} GtsArgs;

// The Global Trade Station's state: 0x1608 bytes from heap 61. Only what
// the C reads is named; the assembly reaches the rest by offset.
typedef struct GtsWork {
    GtsArgs *args;
    BgConfig *bgConfig;
    u8 unk008[0x1C];
    int tradeType; // 9 trades for an offer found; 8 and 10 collect the deposit, or what it was traded for
    u8 unk028[0x4];
    int subState;
    u8 unk030[0x1C];
    void *dwcHeapMemory; // 0x20020 bytes, for the 0x20000 of the DWC heap aligned to 32
    NNSFndHeapHandle dwcHeap;
    u8 unk054[0x64];
    OverlayManager *tradeSequence;
    u8 unk0BC[0x54];
    EvolutionTaskData *evolutionTask;
    u8 unk114[0xB9C - 0x114];
    MessageFormat *msgFormat;
    MsgData *msgData; // msg_0775
    MsgData *speciesNames; // msg_0237
    MsgData *unkBA8; // msg_0778
    MsgData *unkBAC; // msg_0800
    MsgData *unkBB0; // msg_0798
    u8 unkBB4[0x11F0 - 0xBB4];
    Pokemon *given; // what the trade animation sends: the Pokemon given
    u8 unk11F4[0x1608 - 0x11F4];
} GtsWork;

BOOL ov70_02238430(OverlayManager *man, int *state);
BOOL ov70_022385C0(OverlayManager *man, int *state);
BOOL ov70_022386F4(OverlayManager *man, int *state);

#endif // POKEHEARTGOLD_OVY_70_H
