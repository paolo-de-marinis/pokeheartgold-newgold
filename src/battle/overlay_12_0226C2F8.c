#include "global.h"

#include "constants/items.h"

#include "battle/battle_command.h"

// Three of battle_command.c's read-only tables. The compiler gives each table a
// section of its own, which the linker starts on a word boundary and drops when
// nothing reads it, so the tables around these that nothing reads, or that
// start off a word boundary, stay in the assembly with a neighbour:
// asm/overlay_12_battle_command.s before these, asm/overlay_12_0226C324.s
// after them. The rest are overlay_12_0226C3E8.c and overlay_12_0226CA4C.c.

// One try in this many at Protect or one of its family works, by how many have
// worked in a row before it: hg-engine's 1/3^n (d0380a487,
// BattleController_BeforeMove.c), where Generation IV halved the odds against a
// 16-bit roll and stopped at 1/8.
const u16 sProtectSuccessChance[7] = { 1, 3, 9, 27, 81, 243, 729 };

// HP threshold as 64ths of max, then the power.
const u8 sFlailDamageTable[6][2] = {
    { 1,  200 },
    { 5,  150 },
    { 12, 100 },
    { 21, 80  },
    { 42, 40  },
    { 64, 20  },
};

const u16 sPickupTable2[11] = {
    ITEM_HYPER_POTION,
    ITEM_NUGGET,
    ITEM_KINGS_ROCK,
    ITEM_FULL_RESTORE,
    ITEM_ETHER,
    ITEM_IRON_BALL,
    ITEM_TM56,
    ITEM_ELIXIR,
    ITEM_TM86,
    ITEM_LEFTOVERS,
    ITEM_TM26,
};
