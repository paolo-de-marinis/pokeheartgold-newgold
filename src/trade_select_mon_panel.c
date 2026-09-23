#include "global.h"

#include "bg_window.h"
#include "item.h"
#include "msgdata.h"
#include "party.h"
#include "pm_string.h"
#include "pokemon.h"
#include "sprite.h"
#include "text.h"

// One Pokemon of either side's party as the trade screen keeps it.
typedef struct TradeSelectMonSlot {
    u8 unk0[4];
    u8 unk4;
    u8 isEgg; // the level is not shown
    u8 unk6[2];
    u16 unk8;
    u16 flipMode;
    u8 unkC[4];
} TradeSelectMonSlot;

// The parts of overlay 65's state this routine reads; the rest of the
// overlay addresses it by offset.
typedef struct TradeSelectMon {
    u8 unk0[0x190];
    MsgData *msgData;
    u8 unk194[0x19C - 0x194];
    String *unk19C;
    u8 unk1A0[0x40C - 0x1A0];
    Sprite *sprites[6];
    u8 unk424[0x69C - 0x424];
    TradeSelectMonSlot slots[12]; // your six, then theirs
} TradeSelectMon;

typedef struct TradeSelectMonPicturePos {
    int x;
    int y;
    int unk8;
} TradeSelectMonPicturePos;

extern const TradeSelectMonPicturePos ov65_0221FEA4[];

extern void ov65_0221CA64(TradeSelectMon *trade, int which, u8 a2);
extern void ov65_0221D5FC(Window *window, Party *party, int partySlot, int a3, int a4);
extern int ov65_0221D648(TradeSelectMonSlot *slot, Party *party, int partySlot, u16 a3);
extern void ov65_0221F748(Sprite *sprite, int x, int y);
extern void ov65_0221FB4C(Window *window, String *string, int unused, int textSpeed, int x, int y);

void ov65_0221D674(Window *windows, int side, Party *party, int partySlot, TradeSelectMon *trade);

// Show one side's chosen Pokemon: its picture, nickname, level and held item.
void ov65_0221D674(Window *windows, int side, Party *party, int partySlot, TradeSelectMon *trade) {
    int yOffset = sub_0207083C((BoxPokemon *)Party_GetMonByIndex(party, partySlot), 2);
    Sprite **sprites = trade->sprites;
    String *string;
    u16 item;
    u16 level;
    int state;

    Sprite_SetDrawFlag(sprites[side], TRUE);
    ov65_0221F748(sprites[side], ov65_0221FEA4[side].x, yOffset + ov65_0221FEA4[side].y + 0xC0);
    if (side == 0) {
        Sprite_SetFlipMode(sprites[side], trade->slots[partySlot].flipMode);
    }
    ov65_0221CA64(trade, side + 2, trade->slots[partySlot].unk4);
    Sprite_SetDrawFlag(trade->sprites[side + 2], TRUE);
    ov65_0221D5FC(&windows[side + 26], party, partySlot, 9, 6);
    state = ov65_0221D648(&trade->slots[side * 6 + partySlot], party, partySlot, trade->slots[side * 6 + partySlot].unk8);
    if (trade->slots[side * 6 + partySlot].isEgg) {
        state = 2;
    }
    switch (state) {
    case 2:
        Sprite_SetDrawFlag(trade->sprites[side + 4], FALSE);
        break;
    case 0:
        Sprite_SetDrawFlag(trade->sprites[side + 4], TRUE);
        Sprite_SetAnimCtrlSeq(trade->sprites[side + 4], 7);
        break;
    case 1:
        Sprite_SetDrawFlag(trade->sprites[side + 4], TRUE);
        Sprite_SetAnimCtrlSeq(trade->sprites[side + 4], 6);
        break;
    }
    if (!trade->slots[side * 6 + partySlot].isEgg) {
        string = String_New(10, HEAP_ID_26);
        FillWindowPixelBuffer(&windows[side + 28], 0);
        ReadMsgDataIntoString(trade->msgData, 41, string);
        ov65_0221FB4C(&windows[side + 28], string, 9, TEXT_SPEED_NOTRANSFER, 6, 0);
        level = GetMonData(Party_GetMonByIndex(party, partySlot), MON_DATA_LEVEL, NULL);
        String16_FormatInteger(string, level, 3, PRINTING_MODE_LEFT_ALIGN, TRUE);
        ov65_0221FB4C(&windows[side + 28], string, 9, 0, 30, 0);
        String_Delete(string);
    } else {
        ClearWindowTilemapAndCopyToVram(&windows[side + 28]);
    }
    ov65_0221FB4C(&windows[side + 30], trade->unk19C, 7, 0, 3, 0);
    item = GetMonData(Party_GetMonByIndex(party, partySlot), MON_DATA_HELD_ITEM, NULL);
    FillWindowPixelBuffer(&windows[side + 32], 0);
    // HeartGold's 20 left the 16 item names past 19 characters blank, or
    // showing the previous Pokemon's item.
    string = String_New(ITEM_NAME_LENGTH, HEAP_ID_26);
    GetItemNameIntoString(string, item, HEAP_ID_26);
    ov65_0221FB4C(&windows[side + 32], string, 9, 0, 3, 0);
    String_Delete(string);
}
