#include "global.h"

#include "constants/items.h"

// How many slots of each pocket the bag's redraw looks through for a page's
// items (ov15_021FF320, ov15_021FF364), by pocket; the same sizes as
// ov15_022008B0 in src/bag_pocket_sizes.c.
const u8 ov15_022008C8[POCKETS_COUNT] = {
    [POCKET_ITEMS]        = 165,
    [POCKET_MEDICINE]     = 40,
    [POCKET_BALLS]        = 24,
    [POCKET_TMHMS]        = 101,
    [POCKET_BERRIES]      = 64,
    [POCKET_MAIL]         = 12,
    [POCKET_BATTLE_ITEMS] = 30,
    [POCKET_KEY_ITEMS]    = 50,
};
