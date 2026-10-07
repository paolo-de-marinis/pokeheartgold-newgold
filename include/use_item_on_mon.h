#ifndef POKEHEARTGOLD_USE_ITEM_ON_MON_H
#define POKEHEARTGOLD_USE_ITEM_ON_MON_H

#include "item.h"
#include "pokemon_types_def.h"

// An item's EV parameter that sets the stat's EVs to zero, however many it
// has: the Fresh-Start Mochi's, in all six (hg-engine's records give it, and
// left the reset to "code in something").
#define ITEM_EV_PARAM_RESET (-128)

BOOL CanUseItemOnPokemon(Pokemon *mon, u16 itemID, s32 moveIdx, enum HeapID heapID);
BOOL CanUseItemOnMonInParty(Party *party, u16 itemID, s32 partyIdx, s32 moveIdx, enum HeapID heapID);
BOOL UseItemOnPokemon(Pokemon *mon, u16 itemID, u16 moveIdx, u16 location, enum HeapID heapID);
BOOL UseItemOnMonInParty(Party *party, u16 itemID, s32 partyIdx, u8 moveIdx, u16 location, enum HeapID heapID);
BOOL MonMoveCanRestorePP(Pokemon *mon, int moveIdx);
BOOL MonMoveRestorePP(Pokemon *mon, int moveIdx, int ppRestore);
BOOL BoostMonMovePpUpBy(Pokemon *mon, int moveIdx, int nPpUp);
void RestoreMonHPBy(Pokemon *mon, u32 hp, u32 maxHp, u32 restoration);
s32 TryModEV(s32 ev, s32 evSum, s32 by);
BOOL CanItemModFriendship(Pokemon *mon, ItemData *itemData);
BOOL DoItemFriendshipMod(Pokemon *mon, s32 friendship, s32 mod, u16 location, enum HeapID heapID);
void HealParty(Party *party);

#endif // POKEHEARTGOLD_USE_ITEM_ON_MON_H
