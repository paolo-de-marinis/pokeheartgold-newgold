#include "global.h"

#include "constants/items.h"

#include "overlay_15.h"

// How many slots of each pocket the bag's list is built from
// (ov15_021F9F08), by pocket: the save's pocket sizes, as hg-engine's
// sPocketCountBytes. HeartGold listed its own sizes here, 165 items, 24 balls
// and 50 key items, which left the rest of the widened pockets out of the
// list. The redraw reads a copy of the table, ov15_022008C8, which is in
// src/bag_page_sizes.c because the compiler lays a file's tables out smallest
// first and retail has the overlay's template between the two.
const u8 ov15_022008B0[POCKETS_COUNT] = {
    [POCKET_ITEMS]        = NUM_BAG_ITEMS,
    [POCKET_MEDICINE]     = NUM_BAG_MEDICINE,
    [POCKET_BALLS]        = NUM_BAG_BALLS,
    [POCKET_TMHMS]        = NUM_BAG_TMS_HMS,
    [POCKET_BERRIES]      = NUM_BAG_BERRIES,
    [POCKET_MAIL]         = NUM_BAG_MAIL,
    [POCKET_BATTLE_ITEMS] = NUM_BAG_BATTLE_ITEMS,
    [POCKET_KEY_ITEMS]    = NUM_BAG_KEY_ITEMS,
};

const OverlayManagerTemplate ov15_022008B8 = {
    .init = Bag_Init,
    .exec = Bag_Main,
    .exit = Bag_Exit,
    .ovy_id = FS_OVERLAY_ID_NONE,
};
