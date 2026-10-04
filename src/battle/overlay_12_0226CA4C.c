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

// The type Camouflage gives its user, by the ground the battle is fought on
// (BattleSystem_GetTerrainId) and, past TERRAIN_OTHERS, by the terrain laid
// over it, which comes first (BtlCmd_TryCamouflage): the seventh
// generation's, the last the move can be chosen in (Pokemon Central,
// Camuffamento). Normal on plain ground, in buildings and in the League's
// and the Frontier's rooms; Ground on sand and rock; Grass in grass and
// Grassy Terrain; Rock in a cave; Ice on snow and ice; Water on water;
// Electric, Fairy and Psychic in the other three terrains. Puddles and mud,
// which the seventh has not got, keep the sixth's Ground ("pozzanghere e
// palude"), and the unknown ground nothing here uses keeps retail's Flying.
// Retail's table, the fourth generation's, made plain ground Ground, a puddle
// Grass and rock Rock, and knew no terrain.
const u8 sCamouflageTypeTable[TERRAIN_OTHERS + PSYCHIC_TERRAIN + 1] = {
    [TERRAIN_PLAIN] = TYPE_NORMAL,
    [TERRAIN_SAND] = TYPE_GROUND,
    [TERRAIN_GRASS] = TYPE_GRASS,
    [TERRAIN_PUDDLE] = TYPE_GROUND,
    [TERRAIN_MOUNTAIN] = TYPE_GROUND,
    [TERRAIN_CAVE] = TYPE_ROCK,
    [TERRAIN_SNOW] = TYPE_ICE,
    [TERRAIN_WATER] = TYPE_WATER,
    [TERRAIN_ICE] = TYPE_ICE,
    [TERRAIN_BUILDING] = TYPE_NORMAL,
    [TERRAIN_GREAT_MARSH] = TYPE_GROUND,
    [TERRAIN_UNKNOWN] = TYPE_FLYING,
    [TERRAIN_OTHERS] = TYPE_NORMAL,
    [TERRAIN_OTHERS + GRASSY_TERRAIN] = TYPE_GRASS,
    [TERRAIN_OTHERS + MISTY_TERRAIN] = TYPE_FAIRY,
    [TERRAIN_OTHERS + ELECTRIC_TERRAIN] = TYPE_ELECTRIC,
    [TERRAIN_OTHERS + PSYCHIC_TERRAIN] = TYPE_PSYCHIC,
};
