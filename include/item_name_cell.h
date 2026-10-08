#ifndef POKEHEARTGOLD_ITEM_NAME_CELL_H
#define POKEHEARTGOLD_ITEM_NAME_CELL_H

#include "global.h"

#include "bg_window.h"
#include "font.h"
#include "heap.h"
#include "pm_string.h"
#include "text.h"

// graphic/font member 10, the narrow one.
#define FONT_NARROW 5

// An item's name in a cell of the bag's list or a mart's. The cell's window
// is 88 pixels wide, and every name HeartGold has fits it in the system font,
// Power-Up Pocket's to the pixel; the later games' longer names -- Fresh-Start
// Mochi, Heavy-Duty Boots -- were cut at its edge, where those games print
// them whole. Such a name is printed in the narrow font, loaded for the one
// print, which is done when the printer returns.
static inline void PrintItemNameInCell(Window *window, String *name, u32 y, enum HeapID heapID) {
    u32 room = GetWindowWidth(window) * 8;
    FontID fontId = FontID_String_GetWidth(0, name, 0) <= room ? 0 : FONT_NARROW;

    if (fontId == FONT_NARROW) {
        FontID_Alloc(FONT_NARROW, heapID);
    }
#ifdef NEWGOLD_DIAG
    if (FontID_String_GetWidth(fontId, name, 0) > room + gDiagItemNameCut) {
        gDiagItemNameCut = FontID_String_GetWidth(fontId, name, 0) - room;
    }
#endif
    AddTextPrinterParameterizedWithColor(window, fontId, name, 0, y, TEXT_SPEED_NOTRANSFER, MAKE_TEXT_COLOR(1, 2, 0), NULL);
    if (fontId == FONT_NARROW) {
        FontID_Release(FONT_NARROW);
    }
}

#endif // POKEHEARTGOLD_ITEM_NAME_CELL_H
