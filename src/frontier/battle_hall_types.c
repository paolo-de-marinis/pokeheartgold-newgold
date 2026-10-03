#include "frontier/battle_hall.h"

#include "global.h"

#include "constants/pokemon.h"

// The type board's cells, read across, and the type each offers.
static const u8 sCellTypes[] = {
    TYPE_NORMAL,
    TYPE_FIRE,
    TYPE_WATER,
    TYPE_ELECTRIC,
    TYPE_GRASS,
    TYPE_ICE,
    TYPE_FIGHTING,
    TYPE_POISON,
    TYPE_GROUND,
    TYPE_FLYING,
    TYPE_PSYCHIC,
    TYPE_BUG,
    TYPE_ROCK,
    TYPE_GHOST,
    TYPE_DRAGON,
    TYPE_DARK,
    TYPE_STEEL,
    TYPE_FAIRY,
    BATTLE_HALL_CELL_SUMMARY, // the Pokemon's summary
    TYPE_MYSTERY, // the Hall Matron's cell
};

u8 ov80_02237920(u8 cell) {
    return sCellTypes[cell];
}
