#include "global.h"

#include "application/pokedex/pokedex_internal.h"
#include "application/pokedex/pokedex_internal_constants.h"

#include "heap.h"
#include "pokedex.h"

u16 *ov18_021F8168(u32 member, u32 *count);
void ov18_021F8764(u16 *dest, u32 *destCount, u16 *list, u32 listCount, u16 *src, u32 srcCount, int a6, Pokedex *pokedex);
u32 ov18_021F8970(u32 type);
void ov18_021F831C(u32 type, u16 *dest, u32 *destCount, u16 *src, int srcCount, Pokedex *pokedex);

// The search by type: the species of src that the type's sort list holds, or
// all of them for DEX_SEARCH_TYPE_ALL.
void ov18_021F831C(u32 type, u16 *dest, u32 *destCount, u16 *src, int srcCount, Pokedex *pokedex) {
    u16 *list;
    u32 count;

    switch (ov18_021F8970(type)) {
    case DEX_SEARCH_TYPE_ALL:
        memcpy(dest, src, srcCount * sizeof(u16));
        *destCount = srcCount;
        return;
    case DEX_SEARCH_TYPE_NORMAL:
        list = ov18_021F8168(51, &count);
        break;
    case DEX_SEARCH_TYPE_FIGHTING:
        list = ov18_021F8168(52, &count);
        break;
    case DEX_SEARCH_TYPE_FLYING:
        list = ov18_021F8168(53, &count);
        break;
    case DEX_SEARCH_TYPE_POISON:
        list = ov18_021F8168(54, &count);
        break;
    case DEX_SEARCH_TYPE_GROUND:
        list = ov18_021F8168(55, &count);
        break;
    case DEX_SEARCH_TYPE_ROCK:
        list = ov18_021F8168(56, &count);
        break;
    case DEX_SEARCH_TYPE_BUG:
        list = ov18_021F8168(57, &count);
        break;
    case DEX_SEARCH_TYPE_GHOST:
        list = ov18_021F8168(58, &count);
        break;
    case DEX_SEARCH_TYPE_STEEL:
        list = ov18_021F8168(59, &count);
        break;
    case DEX_SEARCH_TYPE_FIRE:
        list = ov18_021F8168(60, &count);
        break;
    case DEX_SEARCH_TYPE_WATER:
        list = ov18_021F8168(61, &count);
        break;
    case DEX_SEARCH_TYPE_GRASS:
        list = ov18_021F8168(62, &count);
        break;
    case DEX_SEARCH_TYPE_ELECTRIC:
        list = ov18_021F8168(63, &count);
        break;
    case DEX_SEARCH_TYPE_PSYCHIC:
        list = ov18_021F8168(64, &count);
        break;
    case DEX_SEARCH_TYPE_ICE:
        list = ov18_021F8168(65, &count);
        break;
    case DEX_SEARCH_TYPE_DRAGON:
        list = ov18_021F8168(66, &count);
        break;
    case DEX_SEARCH_TYPE_DARK:
        list = ov18_021F8168(67, &count);
        break;
    default:
        GF_ASSERT(FALSE);
        break;
    }
    ov18_021F8764(dest, destCount, list, count, src, srcCount, 0, pokedex);
    Heap_Free(list);
}
