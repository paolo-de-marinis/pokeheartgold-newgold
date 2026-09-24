#include "global.h"

#include "application/pokedex/dex_entry_pages.h"
#include "application/pokedex/pokedex_internal.h"

#include "bg_window.h"
#include "font.h"
#include "text.h"

// The window shows three lines of font 0, a line every 16 px in 48. A page
// stays five seconds: the fullest page holds 22 words (Lokix's first), five
// seconds at an adult's reading pace of about four words a second, and half
// the pages hold 12 or fewer. The Dex and the capture page's task run 30
// frames a second (main.c waits two vblanks a frame).
#define DEX_ENTRY_PAGE_LINES  3
#define DEX_ENTRY_PAGE_FRAMES 150

// The entry's lines, but for empty ones at its end: retail's Italian Mareep
// ends in a break, and shows as one page as it always has.
static int DexEntryPages_CountLines(String *entry) {
    const u16 *text = String_cstr(entry);
    int end = String_GetLength(entry);
    int lines = 1;
    int i;

    while (end > 0 && text[end - 1] == CHAR_LF) {
        end--;
    }
    for (i = 0; i < end; i++) {
        if (text[i] == CHAR_LF) {
            lines++;
        }
    }
    return lines;
}

// Centred as a block by its widest line, as the Dex has always centred an
// entry. A line wider than the window starts at its left edge, cut on the
// right: retail's (width - widest) / 2 in u32 wrapped past the window, and
// showed a piece of the first line and nothing else.
static void DexEntryPages_Draw(Window *window, String *text) {
    u32 width = GetWindowWidth(window) * 8;
    u32 widest = FontID_String_GetWidthMultiline(0, text, 0);

    FillWindowPixelBuffer(window, 0);
    ov18_021F95FC(window, text, widest < width ? (width - widest) / 2 : 0, 0, 0, MAKE_TEXT_COLOR(2, 1, 0), 0);
}

// The page's lines, as the entry breaks them.
static void DexEntryPages_DrawPage(DexEntryPages *pages) {
    String *page = String_New(String_GetLength(pages->entry) + 1, pages->heapId);
    String *line = String_New(String_GetLength(pages->entry) + 1, pages->heapId);
    int first = pages->page * DEX_ENTRY_PAGE_LINES;
    int i;

    for (i = first; i < first + DEX_ENTRY_PAGE_LINES && i < pages->numLines; i++) {
        if (i != first) {
            String_AddChar(page, CHAR_LF);
        }
        String_GetLineN(line, pages->entry, i);
        String_Cat(page, line);
    }
    DexEntryPages_Draw(pages->window, page);
    String_Delete(line);
    String_Delete(page);
}

// The entry is on screen while the tilemap still puts the window's first tile
// in the window's first cell. A page that takes the entry away clears that
// cell -- ov18_021F014C clears the Info windows for an empty search result --
// or puts its own tiles there; the Dex stops the pages before it removes the
// window (ov18_021EE388). The Dex's cover hides the Info page without
// clearing it: the pages turn under the cover, and start again from the
// first as it opens (DexEntryPages_Restart). ponytail: both entry windows are
// on text backgrounds 32 tiles wide; a wider one needs
// GetTileMapIndexFromCoords.
static BOOL DexEntryPages_IsShown(Window *window) {
    u16 *tilemap = GetBgTilemapBuffer(window->bgConfig, window->bgId);

    return tilemap != NULL && tilemap[window->tilemapTop * 32 + window->tilemapLeft] == (window->baseTile | (window->paletteNum << 12));
}

// Draws the entry in the window, which the caller then copies to VRAM, and
// keeps it to turn its pages if it has more than one. The entry is the
// pages' to free.
void DexEntryPages_Print(DexEntryPages *pages, Window *window, String *entry, enum HeapID heapId) {
    int numLines = DexEntryPages_CountLines(entry);

    DexEntryPages_Stop(pages);
    if (numLines <= DEX_ENTRY_PAGE_LINES) {
        DexEntryPages_Draw(window, entry);
        String_Delete(entry);
        return;
    }
    pages->window = window;
    pages->entry = entry;
    pages->heapId = heapId;
    pages->timer = DEX_ENTRY_PAGE_FRAMES;
    pages->page = 0;
    pages->numLines = numLines;
    DexEntryPages_DrawPage(pages);
}

void DexEntryPages_Update(DexEntryPages *pages) {
    if (pages->window == NULL) {
        return;
    }
    if (!DexEntryPages_IsShown(pages->window)) {
        DexEntryPages_Stop(pages);
        return;
    }
    if (--pages->timer != 0) {
        return;
    }
    pages->timer = DEX_ENTRY_PAGE_FRAMES;
    pages->page = (pages->page + 1) % ((pages->numLines + DEX_ENTRY_PAGE_LINES - 1) / DEX_ENTRY_PAGE_LINES);
    DexEntryPages_DrawPage(pages);
    ScheduleWindowCopyToVram(pages->window);
}

void DexEntryPages_Stop(DexEntryPages *pages) {
    if (pages->window != NULL) {
        String_Delete(pages->entry);
        pages->window = NULL;
    }
}

// The first page again, for all its time, when the entry comes into view
// without being printed again.
void DexEntryPages_Restart(DexEntryPages *pages) {
    if (pages->window != NULL) {
        pages->timer = DEX_ENTRY_PAGE_FRAMES;
        pages->page = 0;
        DexEntryPages_DrawPage(pages);
        ScheduleWindowCopyToVram(pages->window);
    }
}

// A species' Dex entry, centred in its window, for a species that has been
// caught; the Dex turns its pages (PokedexApp_RunMainSeq).
void ov18_021EE984(PokedexAppData *pokedexApp, u16 species, u32 idx, int windowId) {
    if (pokedexApp->unk_1030[idx].unk_2 == 2) {
        DexEntryPages_Print(&pokedexApp->entryPages, &pokedexApp->windows[windowId], ov18_021E59A8(species, pokedexApp->unk_185C, 0, HEAP_ID_POKEDEX_APP), HEAP_ID_POKEDEX_APP);
        ScheduleWindowCopyToVram(&pokedexApp->windows[windowId]);
    }
}
