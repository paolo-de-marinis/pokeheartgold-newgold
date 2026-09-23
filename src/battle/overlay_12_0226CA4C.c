#include "global.h"

#include "constants/pokemon.h"

#include "battle/battle_command.h"

// The last of battle_command.c's read-only tables. Retail has them after the
// command table, but as the smallest they would come first in
// overlay_12_0226C3E8.c, so they are an object of their own linked after it.

// Pickup's roll out of 100 finds the first of the nine items from the Pokemon's
// level band whose number here is above it.
const u8 sPickupWeightTable[9] = { 30, 40, 50, 60, 70, 80, 90, 94, 98 };

// By level, in bands of ten, the chance in 100 that Honey Gather finds Honey.
const u8 sHoneyGatherChanceTable[10] = { 5, 10, 15, 20, 25, 30, 35, 40, 45, 50 };

// By terrain.
const u8 sCamouflageTypeTable[13] = {
    TYPE_GROUND,
    TYPE_GROUND,
    TYPE_GRASS,
    TYPE_GRASS,
    TYPE_ROCK,
    TYPE_ROCK,
    TYPE_ICE,
    TYPE_WATER,
    TYPE_ICE,
    TYPE_NORMAL,
    TYPE_GROUND,
    TYPE_FLYING,
    TYPE_NORMAL,
};
