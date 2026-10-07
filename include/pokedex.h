#ifndef POKEHEARTGOLD_POKEDEX_H
#define POKEHEARTGOLD_POKEDEX_H

#include "constants/pokemon.h"
#include "constants/species.h"

#include "heap.h"
#include "pokemon_types_def.h"
#include "save.h"

#define ROUND_UP(x, n) (((x) + (n) - 1) & ~((n) - 1))
#define CEILDIV(x, n)  (((x) + (n) - 1) / (n))

// Deoxys form history is split between the
// seen and caught flags because of space efficiency.
// For some reason, 4 bits are reserved for each form,
// even though 2 would suffice. This negates any
// benefits this split would have provided.
// Of the flags between the last Dex species' and that byte, the two that
// also have a byte of caughtLanguages (ROUND_UP's padding),
// NATIONAL_DEX_COUNT + 1 and + 2, are New Gold's own species' (DexFlagNo in
// src/pokedex.c): Baby Lugia's is the first, and the second is free.
#define NUM_DEX_FLAG_WORDS (CEILDIV(NATIONAL_DEX_COUNT + 8, 32))

// The forms the Dex records on their own. Each is a species here that the Dex
// credits to its base species (SpeciesToDexSpecies): the Galarian Slowpoke
// and Slowbro, kept inside the Dex's range, and every species past the last
// Dex species but New Gold's own. One bit a species from the first of them
// on, as the species' flags are one a species from 1; a species that is no
// form keeps its bit clear.
#define DEX_FIRST_FORM     SPECIES_SLOWPOKE_GALARIAN
#define NUM_DEX_FORM_WORDS (CEILDIV(NUM_SPECIES - DEX_FIRST_FORM + 1, 32))

// The look the Dex shows a species in. caughtLanguages keeps a language a bit
// in its six low bits (LanguageToDexFlag; its 6, no language of the Dex, is
// never kept), and the port two flags in the two above them, clear in every
// save from before them: DEX_SEEN_AS_FORM_ONLY in a species' byte while the
// Dex has seen it only as its forms (DEX_FIRST_FORM on), and
// DEX_FORM_SEEN_FIRST in the byte at a form's place in formsSeen (form -
// DEX_FIRST_FORM) for the form its species was seen as the first time. The
// Dex shows the species as that form until it sees the species itself.
#define DEX_SEEN_AS_FORM_ONLY 0x80
#define DEX_FORM_SEEN_FIRST   0x40

typedef struct Pokedex {
    u32 magic;
    u32 caughtSpecies[NUM_DEX_FLAG_WORDS];
    u32 seenSpecies[NUM_DEX_FLAG_WORDS];
    u32 seenGenders[2][NUM_DEX_FLAG_WORDS];
    u32 spindaPersonality;
    u8 shellosFormOrder;
    u8 gastrodonFormOrder;
    u8 burmyFormOrder;
    u8 wormadamFormOrder;
    u8 unownSeenOrder[28];
    u8 unownCaughtOrder[28];
    u8 caughtLanguages[ROUND_UP(NATIONAL_DEX_COUNT, 4)];
    u8 canDetectForms;
    u8 enabledInternational;
    u8 dexEnabled;
    u8 nationalDex;
    u32 rotomFormOrder;
    u8 shayminFormOrder;
    u8 giratinaFormOrder;
    u8 pichuFormOrder;
    u8 dummy;
    // The port's, past HeartGold's record (docs/newgold/SAVE-LAYOUT.md): the
    // forms seen, and those caught, which count as seen as well.
    u32 formsSeen[NUM_DEX_FORM_WORDS];
    u32 formsCaught[NUM_DEX_FORM_WORDS];
} Pokedex;

u32 Save_Pokedex_sizeof(void);
Pokedex *Pokedex_New(enum HeapID heapID);
void Save_Pokedex_Init(Pokedex *pokedex);
Pokedex *Save_Pokedex_Get(SaveData *saveData);
BOOL Pokedex_GetNatDexFlag(const Pokedex *pokedex);
BOOL Pokedex_CheckMonCaughtFlag(const Pokedex *pokedex, u16 species);
BOOL Pokedex_CheckMonSeenFlag(const Pokedex *pokedex, u16 species);
u16 Pokedex_CountNationalDexOwned(Pokedex *pokedex);
u16 Pokedex_CountNationalOwned_ExcludeMythical(Pokedex *pokedex);
u16 Pokedex_CountNationalDexSeen(Pokedex *pokedex);
u16 Pokedex_CountJohtoDexOwned(Pokedex *pokedex);
u16 Pokedex_CountJohtoOwned_ExcludeMythical(Pokedex *pokedex);
u16 Pokedex_CountJohtoDexSeen(Pokedex *pokedex);
void Pokedex_Copy(const Pokedex *src, Pokedex *dest);
BOOL DexSpeciesIsInvalid(u16 species);
u16 SpeciesToDexSpecies(u16 species);
u16 SpeciesToNationalDexNo(u16 species);
u16 Pokedex_CountDexOwned(Pokedex *pokedex);
BOOL Pokedex_NationalDexIsComplete(Pokedex *pokedex);
BOOL Pokedex_JohtoDexIsComplete(Pokedex *pokedex);
u32 Pokedex_GetSeenSpindaPersonality(Pokedex *pokedex, u32 arg);
int Pokedex_SpeciesGetLastSeenGender(Pokedex *pokedex, u16 species, u32 idx);
int Pokedex_GetSeenFormByIdx_Unown(Pokedex *pokedex, int idx, u32 caught);
u32 Pokedex_GetSeenFormNum_Unown(Pokedex *pokedex, BOOL caught);
int Pokedex_GetSeenFormByIdx_Shellos(Pokedex *pokedex, int a1);
void Pokedex_SetMonSeenFlag(Pokedex *pokedex, Pokemon *mon);
void Pokedex_SetMonCaughtFlag(Pokedex *pokedex, Pokemon *mon);
void Pokedex_SetNatDexFlag(Pokedex *pokedex);
void Pokedex_EnableFormDetection(Pokedex *pokedex);
BOOL Pokedex_HasCaughtMonWithLanguage(Pokedex *pokedex, u32 species, u32 language);
void Pokedex_SetInternationalViewFlag(Pokedex *pokedex);
BOOL Pokedex_GetInternationalViewFlag(const Pokedex *pokedex);
BOOL Pokedex_IsEnabled(const Pokedex *pokedex);
void Pokedex_Enable(Pokedex *pokedex);
int Pokedex_GetSeenFormByIdx(Pokedex *pokedex, int species, int idx);
int Pokedex_GetSeenFormNum(Pokedex *pokedex, int species);
void UpdatePokedexWithReceivedSpecies(SaveData *saveData, Pokemon *pokemon);

#endif // POKEHEARTGOLD_POKEDEX_H
