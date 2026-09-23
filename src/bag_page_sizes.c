#include "global.h"

#include "constants/items.h"

// How many slots of each pocket the bag's redraw looks through for a page's
// items (ov15_021FF320, ov15_021FF364), by pocket; the save's pocket sizes,
// as ov15_022008B0 in src/bag_pocket_sizes.c.
const u8 ov15_022008C8[POCKETS_COUNT] = {
    [POCKET_ITEMS]        = NUM_BAG_ITEMS,
    [POCKET_MEDICINE]     = NUM_BAG_MEDICINE,
    [POCKET_BALLS]        = NUM_BAG_BALLS,
    [POCKET_TMHMS]        = NUM_BAG_TMS_HMS,
    [POCKET_BERRIES]      = NUM_BAG_BERRIES,
    [POCKET_MAIL]         = NUM_BAG_MAIL,
    [POCKET_BATTLE_ITEMS] = NUM_BAG_BATTLE_ITEMS,
    [POCKET_KEY_ITEMS]    = NUM_BAG_KEY_ITEMS,
};
