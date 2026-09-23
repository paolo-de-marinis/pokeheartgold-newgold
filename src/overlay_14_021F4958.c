#include "constants/pokemon.h"

#include "filesystem.h"
#include "heap.h"
#include "overlay_14.h"

#include <nnsys/g2d/load/g2d_NCG_load.h>

// The box list's pictures: a background, with the box's Pokemon drawn on it.
void ov14_021F4958(PCBoxApp *app, u32 box) {
    NNSG2dCharacterData *charData;
    void *ncgrFile = AllocAtEndAndReadWholeNarcMemberByIdPair(NARC_a_0_1_9, 0x46, HEAP_ID_10);
    NNS_G2dGetUnpackedCharacterData(ncgrFile, &charData);
    MI_CpuCopy8(charData->pRawData, app->graphics->boxThumbnails[box], PC_BOX_THUMBNAIL_SIZE);
    Heap_Free(ncgrFile);
    ov14_021F46B0(app, app->graphics->boxThumbnails[box], ov14_021E7930(app, box), 8, PC_BOX_THUMBNAIL_SIZE);
    ov14_021F4A64(app, box, app->graphics->boxThumbnails[box]);
}

void ov14_021F49C8(PCBoxApp *app) {
    u32 box;
    for (box = 0; box < NUM_BOXES; box++) {
        ov14_021F4958(app, box);
    }
}

// The six pictures of the row the list cursor is on.
void ov14_021F49E0(PCBoxApp *app) {
    u32 i;
    int box = app->listBox / 6 * 6;
    int window = 15;
    for (i = 0; i < 6; i++) {
        ov14_021F2C1C(app->graphics, window, app->graphics->boxThumbnails[box], PC_BOX_THUMBNAIL_SIZE);
        window++;
        box++;
    }
}

// One box's picture, when its row is the one showing.
void ov14_021F4A20(PCBoxApp *app, u32 box) {
    if (app->listBox / 6 == box / 6) {
        ov14_021F2C1C(app->graphics, box % 6 + 15, app->graphics->boxThumbnails[box], PC_BOX_THUMBNAIL_SIZE);
    }
}
