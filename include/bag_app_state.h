#ifndef POKEHEARTGOLD_BAG_APP_STATE_H
#define POKEHEARTGOLD_BAG_APP_STATE_H

#include "bag.h"
#include "bag_view.h"
#include "bg_window.h"
#include "filesystem.h"
#include "item.h"
#include "message_format.h"
#include "msgdata.h"
#include "message_printer.h"
#include "nnsys.h"
#include "player_data.h"
#include "pm_string.h"
#include "sprite_system.h"

// HeartGold sizes the bag's list for its biggest pocket, 165 items.
#define BAG_LIST_CAPACITY 165

// A list string holds an item's name, terminator included. HeartGold's 18 fit
// its own names; hg-engine's run to 22 (Super Lumiose Galette), and a name that
// does not fit is not copied, so the row showed whatever the string held last.
#define BAG_LIST_NAME_LENGTH 22

// The bag's state, as Bag_Init allocates it. Only the fields the C reads are
// named; the rest belong to the bag assembly.
typedef struct BagAppState {
    BgConfig *bgConfig;
    u8 unk004[0x64 - 0x4];
    Window unk064;
    u8 unk074[0xB4 - 0x74];
    Window listWindows[12]; // two sets of six rows, drawn in turn
    Window unk174;
    u8 unk184[0x234 - 0x184];
    BagView *bagView;
    Bag *bag;
    PlayerProfile *profile;
    u8 unk240[0x244 - 0x240];
    NARC *graphics;
    SpriteSystem *spriteSystem;
    SpriteManager *spriteManager;
    ManagedSprite *sprites[39];
    MessagePrinter *msgPrinter;
    MsgData *msgData;
    MessageFormat *messageFormat;
    MsgData *itemNamesMsgData;
    MsgData *moveNamesMsgData;
    u8 unk300[0x350 - 0x300];
    String *listNames[BAG_LIST_CAPACITY]; // the name each row of the list shows
    u8 unk5E4[0x5EC - 0x5E4];
    String *unk5EC;
    u8 unk5F0[0x6A4 - 0x5F0];
    u16 listItems[BAG_LIST_CAPACITY]; // the item each row of the list is
    u8 unk7EE[0x94C - 0x7EE];
} BagAppState; // size: 0x94C

struct BagItemListPrefix;

void ov15_021FE914(BagAppState *state, Window *window, ItemSlot *slot, u32 y);
void ov15_021FF570(BagAppState *state, Window *window, String *name, struct BagItemListPrefix *list, u32 index);
void *ov15_021FE990(BagAppState *state, NNSG2dCharacterData **charData);
void ov15_021FE9B0(BagAppState *state, Window *window, u32 badge, u32 y);
void ov15_021F9F08(BagAppState *bagApp);
void ov15_021FA008(BagAppState *bagApp);
void ov15_021FA028(BagAppState *bagApp);

#endif // POKEHEARTGOLD_BAG_APP_STATE_H
