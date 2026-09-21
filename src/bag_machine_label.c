#include "bag_machine_label.h"

#include "graphic/bag_gra.naix"

#include "heap.h"

typedef char BagAppLabelGraphicsCheck[offsetof(BagAppLabelState, graphics) == 0x244 ? 1 : -1];
typedef char BagAppLabelPrinterCheck[offsetof(BagAppLabelState, msgPrinter) == 0x2EC ? 1 : -1];
typedef char BagAppLabelFormatCheck[offsetof(BagAppLabelState, messageFormat) == 0x2F4 ? 1 : -1];
typedef char BagAppLabelStringCheck[offsetof(BagAppLabelState, unk5EC) == 0x5EC ? 1 : -1];

#define BAG_LABEL_HEAP HEAP_ID_6

// The badge sheet is one row of cells; only the first is drawn.
#define BADGE_SHEET_WIDTH  104
#define BADGE_SHEET_HEIGHT 16
#define BADGE_WIDTH        24
#define BADGE_HEIGHT       16

void *ov15_021FE990(BagAppLabelState *state, NNSG2dCharacterData **charData) {
    void *data = NARC_AllocAndReadWholeMember(state->graphics, NARC_bag_gra_bag_gra_00000037_NCGR, BAG_LABEL_HEAP);
    NNS_G2dGetUnpackedBGCharacterData(data, charData);
    return data;
}

void ov15_021FE9B0(BagAppLabelState *state, Window *window, u32 y) {
    NNSG2dCharacterData *charData;
    void *data = ov15_021FE990(state, &charData);

    BlitBitmapRectToWindow(window, charData->pRawData, 0, 0, BADGE_SHEET_WIDTH, BADGE_SHEET_HEIGHT, 0, y, BADGE_WIDTH, BADGE_HEIGHT);

    Heap_FreeExplicit(BAG_LABEL_HEAP, data);
}
