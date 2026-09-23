#ifndef POKEHEARTGOLD_POKEMON_ICON_IDX_H
#define POKEHEARTGOLD_POKEMON_ICON_IDX_H

#include "constants/species.h"

#include "pokemon_types_def.h"

// HGSS reads a species' icon at species + 7, and the entries just past the
// last species are taken by the alternate form icons, so the species New Gold
// adds are given the range after all of them. Their palette numbers follow the
// form entries in the table in pokemon_icon_idx.c for the same reason.
#define FIRST_ADDED_ICON    551
#define FIRST_ADDED_PALETTE 544
// The last icon GetMonIconNaixEx returns.
#define LAST_MON_ICON       (FIRST_ADDED_ICON + NUM_SPECIES - SPECIES_LILLIPUP)

u32 Boxmon_GetIconNaix(BoxPokemon *boxMon);
u32 Pokemon_GetIconNaix(Pokemon *mon);
u32 GetMonIconNaixEx(u32 species, BOOL isEgg, u32 form);
u32 GetBattleMonIconNaixEx(u32 species, BOOL isEgg, u32 form);
const u8 GetMonIconPaletteEx(u32 species, u32 form, u32 isEgg);
const u8 GetBattleMonIconPaletteEx(u32 species, u32 form, BOOL isEgg);
const u8 Boxmon_GetIconPalette(BoxPokemon *boxMon);
const u8 Pokemon_GetIconPalette(Pokemon *mon);
u32 sub_02074490(void);
u32 sub_02074494(void);
u32 sub_02074498(void);
u32 sub_0207449C(void);
u32 sub_020744A0(void);
u32 sub_020744A4(void);
u32 sub_020744A8(void);

#endif // POKEHEARTGOLD_POKEMON_ICON_IDX_H
