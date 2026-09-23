#include "application/pokedex/ov18_021F967C.h"

#include "global.h"

#include "constants/pokemon.h"

// The Pokedex's type icons: for each type, a member of zukan_gra and one of
// its palettes. Retail stops at Dark and the lookups take the type unchecked,
// so a Fairy species read the word after each table: palette 0, and member 0
// of zukan_gra, a screen file, loaded as the icon's graphics -- a NULL
// character block on the capture page's first Dex entry, a read of address
// 0x14 on the Dex page. The Fairy icon is hg-engine's (d0380a487,
// rawdata/dex_gfx/8_123, member 123 with palette 3), which it wires to its own
// Fairy, type 9; here Fairy is 18.
static const u8 ov18_021FBDFC[NUMBER_OF_MON_TYPES] = { 0, 2, 0, 3, 1, 1, 3, 2, 0, 0, 2, 2, 1, 1, 1, 0, 2, 3, [TYPE_FAIRY] = 3 };

static const u32 ov18_021FBE10[NUMBER_OF_MON_TYPES] = {
    0x24,
    0x2A,
    0x32,
    0x2E,
    0x2C,
    0x29,
    0x2F,
    0x2B,
    0x2D,
    0x24,
    0x25,
    0x27,
    0x26,
    0x28,
    0x33,
    0x31,
    0x34,
    0x30,
    [TYPE_FAIRY] = 123,
};

u32 ov18_021F967C(int type) {
    return ov18_021FBE10[type];
}

u8 ov18_021F9688(int type) {
    return ov18_021FBDFC[type];
}
