#include "global.h"

#include "newgold/diag.h"

#include "item_name_cell.h"
#include "overlay_03.h"
#include "overlay_31_0225D60C.h"
#include "overlay_31_0225DD14.h"
#include "overlay_31_0225DE24.h"
#include "overlay_31_0225E12C.h"
#include "text.h"

void ov31_0225E0E4(MartBottomScreen *screen, int count);

// Paints the mart's list: the six rows from the one at the top of the page
// (MartData.unk271) on, each the item's name and, below it, its price, or
// "Owned" for a TM in the bag, which the mart does not sell again.
void ov31_0225DD14(MartBottomScreen *screen) {
    int i;
    int index;
    MartData *mart;
    int count;
    String *name;
    int item;

    for (i = 0; i < 6; i++) {
        FillWindowPixelBuffer(&screen->rows[i], 0);
    }
#ifdef NEWGOLD_DIAG
    gDiagMartOwnedRows = 0;
#endif
    count = screen->mart->unk270 - screen->mart->unk271;
    if (count > 6) {
        count = 6;
    } else if (count < 0) {
        count = 0;
    }
    for (i = 0; i < count; i++) {
        index = i + screen->mart->unk271;
        item = screen->mart->unk268[index];
        name = NewString_ReadMsgData(screen->itemNames, item);
        ov31_0225DE00(screen, &screen->rows[i], name, i);
        String_Delete(name);
        if (Mart_HasAlready(screen->mart, item)) {
            MartList_PrintOwned(screen->msgData, &screen->rows[i]);
#ifdef NEWGOLD_DIAG
            gDiagMartOwnedRows |= 1 << i;
#endif
        } else if (ov31_0225E12C(screen->mart, index, item)) {
            mart = screen->mart;
            ov31_0225DE24(screen->msgFormat, screen->msgData, &screen->rows[i], ov03_02258120(mart, item), mart->martType);
        }
    }
    for (i = 0; i < 6; i++) {
        ScheduleWindowCopyToVram(&screen->rows[i]);
    }
    ov31_0225E0E4(screen, count);
}

// A row's item name, at its top left.
void ov31_0225DE00(MartBottomScreen *screen, Window *window, String *string, int row) {
    PrintItemNameInCell(window, string, 0, HEAP_ID_8);
}
