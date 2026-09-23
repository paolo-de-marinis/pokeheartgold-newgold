#include "global.h"

#include "constants/items.h"

#include "overlay_15.h"

// How many slots of each pocket the bag's list is built from
// (ov15_021F9F08), by pocket: HeartGold's pocket sizes. The redraw reads a
// copy of the table, ov15_022008C8, which is in src/bag_page_sizes.c because
// the compiler lays a file's tables out smallest first and retail has the
// overlay's template between the two.
const u8 ov15_022008B0[POCKETS_COUNT] = {
    [POCKET_ITEMS]        = 165,
    [POCKET_MEDICINE]     = 40,
    [POCKET_BALLS]        = 24,
    [POCKET_TMHMS]        = 101,
    [POCKET_BERRIES]      = 64,
    [POCKET_MAIL]         = 12,
    [POCKET_BATTLE_ITEMS] = 30,
    [POCKET_KEY_ITEMS]    = 50,
};

const OverlayManagerTemplate ov15_022008B8 = {
    .init = Bag_Init,
    .exec = Bag_Main,
    .exit = Bag_Exit,
    .ovy_id = FS_OVERLAY_ID_NONE,
};
