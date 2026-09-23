#include "application/pokedex/ov18_021F967C.h"

#include "global.h"

// The Pokedex's type icons: for each type, a member of zukan_gra and one of
// its palettes.
static const u8 ov18_021FBDFC[] = { 0, 2, 0, 3, 1, 1, 3, 2, 0, 0, 2, 2, 1, 1, 1, 0, 2, 3 };

static const u32 ov18_021FBE10[] = {
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
};

u32 ov18_021F967C(int type) {
    return ov18_021FBE10[type];
}

u8 ov18_021F9688(int type) {
    return ov18_021FBDFC[type];
}
