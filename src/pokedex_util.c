#include "pokedex_util.h"

#include "global.h"

#include "pokemon.h"

BOOL SaveArray_IsNatDexEnabled(SaveData *saveData) {
    return Pokedex_IsNatDexEnabled(Save_Pokedex_Get(saveData));
}

BOOL Pokedex_IsNatDexEnabled(const Pokedex *pokedex) {
    return Pokedex_GetNatDexFlag(pokedex) == TRUE;
}

// A form prints its base species' number: a female Pyroar is 1312, and
// printed with three digits that came out as ?12. A species New Gold adds
// prints its National Dex number, not its identifier: Lillipup, species 508,
// is No. 506, and Pecharunt, 1041, is No. 1025, as in the reference.
u32 Pokedex_ConvertToCurrentDexNo(BOOL natDexFlag, u32 species) {
    species = SpeciesToDexSpecies((u16)species);
    if (natDexFlag == FALSE) {
        return SpeciesToJohtoDexNo((u16)species);
    }
    return SpeciesToNationalDexNo((u16)species);
}
