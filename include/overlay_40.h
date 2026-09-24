#ifndef POKEHEARTGOLD_OVERLAY_40_H
#define POKEHEARTGOLD_OVERLAY_40_H

#include "msgdata.h"
#include "save.h"

// Overlay 40's state, the Vs. Recorder's. Only what the C reads is
// named; the assembly reaches the rest by offset.
typedef struct Overlay40App {
    u8 unk0[0x830];
    SaveData *saveData;
    u8 unk834[0x860 - 0x834];
    void *screen; // the screen shown
} Overlay40App;

// A row of a species list: the species twice, then what the list sets.
typedef struct Overlay40SpeciesRow {
    u32 unk0;
    u32 unk4;
    u8 unk8[8];
} Overlay40SpeciesRow;

// The species a search can pick from: those of one letter group the player
// has seen, and their names.
typedef struct Overlay40SpeciesList {
    int numSeen;
    int numSpecies;
    u16 *species;
    MsgData *speciesNames; // msg_0237
    int speciesNamesOpen;
    Overlay40SpeciesRow *rows;
} Overlay40SpeciesList;

typedef struct Overlay40SearchScreen {
    u8 unk0[0x1D4];
    Overlay40SpeciesList list;
} Overlay40SearchScreen;

typedef struct Overlay40SearchScreen2 {
    u8 unk0[0x4C8];
    Overlay40SpeciesList list;
} Overlay40SearchScreen2;

void ov40_02235E34(Overlay40App *app, int group);
void ov40_0223EC40(Overlay40App *app, int group);

#endif // POKEHEARTGOLD_OVERLAY_40_H
