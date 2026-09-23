#include "global.h"

#include "application/pokedex/pokedex_internal.h"

// The species of the grid entry under the cursor.
u16 ov18_021F8838(PokedexAppData *pokedexApp) {
    return pokedexApp->unk_1030[ov18_021F8824(pokedexApp)].unk_0;
}
