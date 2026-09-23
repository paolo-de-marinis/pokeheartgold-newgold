#include "global.h"

#include "application/pokedex/pokedex_internal.h"

#include "dex_mon_measures.h"
#include "gf_gfx_loader.h"

u16 *ov18_021F8168(u32 member, u32 *count);

// One of the Dex's sort lists, counted from the first (the National order,
// zukan_data's member 11), and its length in species.
u16 *ov18_021F8168(u32 member, u32 *count) {
    u32 size;
    void *ret;

    GF_ASSERT(member < 82);
    ret = GfGfxLoader_LoadFromNarc_GetSizeOut(GetPokedexDataNarcID(), member + 11, FALSE, HEAP_ID_POKEDEX_APP, FALSE, &size);
    *count = size / 2;
    return ret;
}
