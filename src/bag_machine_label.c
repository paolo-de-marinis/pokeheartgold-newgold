#include "bag_app_state.h"

#include "constants/items.h"
#include "graphic/bag_gra.naix"

#include "heap.h"

typedef char BagAppStateGraphicsCheck[offsetof(BagAppState, graphics) == 0x244 ? 1 : -1];
typedef char BagAppStatePrinterCheck[offsetof(BagAppState, msgPrinter) == 0x2EC ? 1 : -1];
typedef char BagAppStateFormatCheck[offsetof(BagAppState, messageFormat) == 0x2F4 ? 1 : -1];
typedef char BagAppStateStringCheck[offsetof(BagAppState, unk5EC) == 0x5EC ? 1 : -1];

#define BAG_LABEL_HEAP HEAP_ID_6

// The badge sheet is one row of cells; only the first is drawn.
#define BADGE_SHEET_WIDTH  104
#define BADGE_SHEET_HEIGHT 16
#define BADGE_WIDTH        24
#define BADGE_HEIGHT       16

// HeartGold has a badge only for HMs, and marks a TM with a "No." glyph and
// two digits instead. New Gold gives TMs a badge of their own and room for
// three digits, which is what a machine list has looked like since, and the
// TRs hg-engine adds a TR badge and two digits, as its bag draws them.
#define BAG_HM_BADGE NARC_bag_gra_bag_gra_00000037_NCGR
#define BAG_TM_BADGE NARC_bag_gra_bag_gra_00000095_NCGR
#define BAG_TR_BADGE NARC_bag_gra_bag_gra_00000096_NCGR
#define HM_DIGITS    2
#define TM_DIGITS    3
#define TR_DIGITS    2

// The number sits immediately right of the badge.
#define NUMBER_X 24
#define NUMBER_Y 5

// The number a machine goes by, hg-engine's GetMachineMoveNumber: the games
// that added machines numbered them on from TM92, started the TRs at 00, and
// Scarlet and Violet began again at TM100, so the number is not the place.
static u16 MachineNumber(u16 itemId) {
    if (itemId == ITEM_HM07_ORAS) {
        return 7;
    }
    if (itemId >= ITEM_HM01 && itemId <= ITEM_HM08) {
        return itemId - ITEM_HM01 + 1;
    }
    if (itemId >= ITEM_TM01 && itemId <= ITEM_TM92) {
        return itemId - ITEM_TM01 + 1;
    }
    if (itemId >= ITEM_TM093 && itemId <= ITEM_TM095) {
        return itemId - ITEM_TM093 + 93;
    }
    if (itemId >= ITEM_TM096 && itemId <= ITEM_TM100) {
        return itemId - ITEM_TM096 + 96;
    }
    if (itemId >= ITEM_TM100_SV && itemId <= ITEM_TM229) {
        return itemId - ITEM_TM100_SV + 100;
    }
    if (itemId >= ITEM_TR00 && itemId <= ITEM_TR99) {
        return itemId - ITEM_TR00;
    }
    return 0; // TM00
}

void ov15_021FE914(BagAppState *state, Window *window, ItemSlot *slot, u32 y) {
    u32 badge = BAG_HM_BADGE;
    u32 digits = HM_DIGITS;

    if (ItemIsTM(slot->id)) {
        badge = BAG_TM_BADGE;
        digits = TM_DIGITS;
    } else if (ItemIsTR(slot->id)) {
        badge = BAG_TR_BADGE;
        digits = TR_DIGITS;
    }

    PrintUIntOnWindow(state->msgPrinter, MachineNumber(slot->id), digits, PRINTING_MODE_LEADING_ZEROS, window, NUMBER_X, y + NUMBER_Y);
    ov15_021FE9B0(state, window, badge, y);
}

static void *ReadBadgeSheet(BagAppState *state, u32 badge, NNSG2dCharacterData **charData) {
    void *data = NARC_AllocAndReadWholeMember(state->graphics, badge, BAG_LABEL_HEAP);
    NNS_G2dGetUnpackedBGCharacterData(data, charData);
    return data;
}

// The remaining bag assembly reads the HM sheet through this one.
void *ov15_021FE990(BagAppState *state, NNSG2dCharacterData **charData) {
    return ReadBadgeSheet(state, BAG_HM_BADGE, charData);
}

void ov15_021FE9B0(BagAppState *state, Window *window, u32 badge, u32 y) {
    NNSG2dCharacterData *charData;
    void *data = ReadBadgeSheet(state, badge, &charData);

    BlitBitmapRectToWindow(window, charData->pRawData, 0, 0, BADGE_SHEET_WIDTH, BADGE_SHEET_HEIGHT, 0, y, BADGE_WIDTH, BADGE_HEIGHT);

    Heap_FreeExplicit(BAG_LABEL_HEAP, data);
}
