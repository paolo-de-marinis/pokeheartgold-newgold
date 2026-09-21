#include "bag_app_state.h"

#include "constants/items.h"
#include "graphic/bag_gra.naix"

#include "heap.h"

typedef char BagAppStateGraphicsCheck[offsetof(BagAppStatePrefix, graphics) == 0x244 ? 1 : -1];
typedef char BagAppStatePrinterCheck[offsetof(BagAppStatePrefix, msgPrinter) == 0x2EC ? 1 : -1];
typedef char BagAppStateFormatCheck[offsetof(BagAppStatePrefix, messageFormat) == 0x2F4 ? 1 : -1];
typedef char BagAppStateStringCheck[offsetof(BagAppStatePrefix, unk5EC) == 0x5EC ? 1 : -1];

#define BAG_LABEL_HEAP HEAP_ID_6

// The badge sheet is one row of cells; only the first is drawn.
#define BADGE_SHEET_WIDTH  104
#define BADGE_SHEET_HEIGHT 16
#define BADGE_WIDTH        24
#define BADGE_HEIGHT       16

// HeartGold has a badge only for HMs, and marks a TM with a "No." glyph and
// two digits instead. New Gold gives TMs a badge of their own and room for
// three digits, which is what a machine list has looked like since.
#define BAG_HM_BADGE NARC_bag_gra_bag_gra_00000037_NCGR
#define BAG_TM_BADGE NARC_bag_gra_bag_gra_00000095_NCGR
#define HM_DIGITS    2
#define TM_DIGITS    3

// The number sits immediately right of the badge.
#define NUMBER_X 24
#define NUMBER_Y 5

void ov15_021FE914(BagAppStatePrefix *state, Window *window, ItemSlot *slot, u32 y) {
    u32 badge = BAG_HM_BADGE;
    u32 digits = HM_DIGITS;
    u16 number = slot->id - (ITEM_HM01 - 1);

    if (slot->id < ITEM_HM01) {
        badge = BAG_TM_BADGE;
        digits = TM_DIGITS;
        number = slot->id - (ITEM_TM01 - 1);
    }

    PrintUIntOnWindow(state->msgPrinter, number, digits, PRINTING_MODE_LEADING_ZEROS, window, NUMBER_X, y + NUMBER_Y);
    ov15_021FE9B0(state, window, badge, y);
}

static void *ReadBadgeSheet(BagAppStatePrefix *state, u32 badge, NNSG2dCharacterData **charData) {
    void *data = NARC_AllocAndReadWholeMember(state->graphics, badge, BAG_LABEL_HEAP);
    NNS_G2dGetUnpackedBGCharacterData(data, charData);
    return data;
}

// The remaining bag assembly reads the HM sheet through this one.
void *ov15_021FE990(BagAppStatePrefix *state, NNSG2dCharacterData **charData) {
    return ReadBadgeSheet(state, BAG_HM_BADGE, charData);
}

void ov15_021FE9B0(BagAppStatePrefix *state, Window *window, u32 badge, u32 y) {
    NNSG2dCharacterData *charData;
    void *data = ReadBadgeSheet(state, badge, &charData);

    BlitBitmapRectToWindow(window, charData->pRawData, 0, 0, BADGE_SHEET_WIDTH, BADGE_SHEET_HEIGHT, 0, y, BADGE_WIDTH, BADGE_HEIGHT);

    Heap_FreeExplicit(BAG_LABEL_HEAP, data);
}
