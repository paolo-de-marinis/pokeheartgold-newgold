#ifndef POKEHEARTGOLD_OVY_18_H
#define POKEHEARTGOLD_OVY_18_H

#include "battle/battle.h"

#include "menu_input_state.h"
#include "overlay_manager.h"
#include "player_data.h"
#include "pokedex.h"
#include "unk_02092BB8.h"

typedef struct PokedexArgs {
    Pokedex *pokedex;
    PlayerProfile *playerProfile;
    UnkStruct_02092BB8 *unk_08;
    MenuInputStateMgr *menuInputStatePtr;
    int x;
    int y;
    u16 mapId;
    u16 mapMatrixId;
} PokedexArgs;

BOOL Pokedex_Init(OverlayManager *man, int *state);
BOOL Pokedex_Main(OverlayManager *man, int *state);
BOOL Pokedex_Exit(OverlayManager *man, int *state);

// The page a species the player catches gets over the battle (its Dex
// number, name, category, entry, height and weight): battle_command.c's
// "get Pokemon" states make it, wait on it and end it.
typedef struct PokedexCapturePage PokedexCapturePage;

PokedexCapturePage *ov18_021F8974(UnkStruct_50C *unkStruct);
BOOL ov18_021F89C8(PokedexCapturePage *page);
void ov18_021F89D0(PokedexCapturePage *page);
Pokepic *ov18_021F95F8(PokedexCapturePage *page);
void ov18_021F95AC(PokedexCapturePage *page);

#endif // POKEHEARTGOLD_OVY_18_H
