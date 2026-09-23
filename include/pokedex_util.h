#ifndef POKEHEARTGOLD_POKEDEX_UTIL_H
#define POKEHEARTGOLD_POKEDEX_UTIL_H

#include "pokedex.h"
#include "save.h"

BOOL Pokedex_IsNatDexEnabled(const Pokedex *pokedex);
BOOL SaveArray_IsNatDexEnabled(SaveData *saveData);
u32 Pokedex_ConvertToCurrentDexNo(BOOL natDexFlag, u32 species);

// The digits a Dex number is printed with. Retail's three stop at 999 and the
// National Dex here reaches 1041 (Pecharunt); hg-engine prints four in every
// place retail printed three, and so does this tree: "No. 0025".
#define DEX_NUMBER_DIGITS 4

#endif // POKEHEARTGOLD_POKEDEX_UTIL_H
