#ifndef POKEHEARTGOLD_OVERLAY_68_021E7028_H
#define POKEHEARTGOLD_OVERLAY_68_021E7028_H

#include "bg_window.h"
#include "list_menu_items.h"
#include "message_format.h"
#include "move_relearner.h"
#include "msgdata.h"
#include "pm_string.h"
#include "sprite_system.h"

typedef struct MoveRelearnerApp {
    MoveRelearnerArgs *args;
    BgConfig *bgConfig;
    Window windows[15];
    MsgData *msgData;
    MessageFormat *msgFormat;
    String *string;
    String *ppLabel;
    String *ppTemplate;
    u8 filler_10C[4];
    ListMenuItem *listItems;
    u8 filler_114[8];
    SpriteSystem *spriteSystem;
    SpriteManager *spriteManager;
    ManagedSprite *sprites[12];
    u8 filler_154[0x1B8 - 0x154];
    u8 listCount;
    u8 filler_1B9[2];
    u8 unk_1BB;
    u8 unk_1BC;
} MoveRelearnerApp;

void ov68_021E7028(MoveRelearnerApp *app, u16 move, u16 idx);

#endif // POKEHEARTGOLD_OVERLAY_68_021E7028_H
