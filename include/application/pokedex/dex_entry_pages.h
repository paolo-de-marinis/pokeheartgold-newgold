#ifndef POKEHEARTGOLD_APPLICATION_POKEDEX_DEX_ENTRY_PAGES_H
#define POKEHEARTGOLD_APPLICATION_POKEDEX_DEX_ENTRY_PAGES_H

#include "global.h"

#include "bg_window.h"
#include "heap.h"
#include "pm_string.h"

// A Dex entry's window shows three lines. An entry of more is shown three
// lines at a time, a page, and the pages turn by themselves while the entry
// is on screen: its owner prints it with DexEntryPages_Print, calls
// DexEntryPages_Update once a frame and DexEntryPages_Stop before it removes
// the window.
typedef struct DexEntryPages {
    Window *window; // NULL while no entry is turning pages
    String *entry;
    enum HeapID heapId;
    u16 timer;
    u8 page;
    u8 numLines;
} DexEntryPages;

void DexEntryPages_Print(DexEntryPages *pages, Window *window, String *entry, enum HeapID heapId);
void DexEntryPages_Update(DexEntryPages *pages);
void DexEntryPages_Stop(DexEntryPages *pages);

#endif // POKEHEARTGOLD_APPLICATION_POKEDEX_DEX_ENTRY_PAGES_H
