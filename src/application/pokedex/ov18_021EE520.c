#include "global.h"

#include "application/pokedex/pokedex_internal.h"

#include "bg_window.h"
#include "gf_gfx_loader.h"
#include "message_printer.h"
#include "pokedex_util.h"
#include "string_util.h"

// One of the Dex's two counts on its front page (seen, caught): the tiles of
// the digit box drawn from the Dex's graphics, and the number over them.
// Retail's three digits showed only the last three of a count past 999; the
// window (ov18_021F9F3C) and the digits are DEX_NUMBER_DIGITS wide, as a Dex
// number is.
void ov18_021EE520(PokedexAppData *pokedexApp, int windowId, u32 num) {
    NNSG2dCharacterData *charData;
    void *charRaw;
    u8 *top;
    u8 *bottom;
    MessagePrinter *printer;
    u32 i;
    u32 x;

    charRaw = GfGfxLoader_GetCharDataFromOpenNarc(pokedexApp->gfxNarc, 1, TRUE, &charData, HEAP_ID_POKEDEX_APP);
    top = charData->pRawData;
    bottom = top;
    bottom += 0x20;
    for (i = 0, x = 0; i < DEX_NUMBER_DIGITS; i++, x += 8) {
        BlitBitmapRect(&pokedexApp->windows[windowId], top + 0x300, 0, 0, 8, 8, x, 0, 8, 8, 0xFF);
        BlitBitmapRect(&pokedexApp->windows[windowId], bottom, 0, 0, 8, 8, x, 8, 8, 8, 0xFF);
    }
    Heap_Free(charRaw);
    printer = MessagePrinter_New(15, 8, 7, HEAP_ID_POKEDEX_APP);
    PrintUIntOnWindow(printer, num, DEX_NUMBER_DIGITS, PRINTING_MODE_LEADING_ZEROS, &pokedexApp->windows[windowId], 0, 4);
    MessagePrinter_Delete(printer);
}
