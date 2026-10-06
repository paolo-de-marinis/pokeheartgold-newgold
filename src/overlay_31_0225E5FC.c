#include "global.h"

#include "msgdata/msg/msg_0435.h"

#include "newgold/diag.h"

#include "overlay_03.h"
#include "overlay_31_0225D60C.h"
#include "overlay_31_0225E5FC.h"
#include "render_window.h"
#include "text.h"

void ov31_0225E4BC(int martType, MessageFormat *msgFmt, u16 item, u32 slot);
void ov31_0225E51C(int martType, MessageFormat *msgFmt, u16 item, u32 slot);

// The line that asks to confirm a purchase: "Would you like" and the item at
// the counters that sell one at a time (MART_TYPE_3 and 4), "OK, 3. That'll
// be $900." at a mart, and for a TM, which a mart sells one at a time with no
// quantity to choose (Mart_SellsOneAtATime), the TM by name: "TM094?
// Certainly. That'll be $1500.", as "How many would you like?" names it.
void ov31_0225E5FC(MartBottomScreen *screen) {
    String *string;

    FillWindowPixelBuffer(&screen->confirmWindow, 15);
    if (screen->mart->martType == MART_TYPE_3 || screen->mart->martType == MART_TYPE_4) {
        ov31_0225E51C(screen->mart->martType, screen->msgFormat, screen->mart->item, 0);
        string = NewString_ReadMsgData(screen->msgData, msg_0435_00046);
    } else if (Mart_SellsOneAtATime(screen->mart, screen->mart->item)) {
        ov31_0225E4BC(screen->mart->martType, screen->msgFormat, screen->mart->item, 0);
        BufferIntegerAsString(screen->msgFormat, 1, screen->mart->cost, 6, PRINTING_MODE_LEFT_ALIGN, TRUE);
        string = NewString_ReadMsgData(screen->msgData, msg_0435_00051);
#ifdef NEWGOLD_DIAG
        gDiagMartConfirmLine = msg_0435_00051;
#endif
    } else {
        BufferIntegerAsString(screen->msgFormat, 0, screen->mart->quantity, 2, PRINTING_MODE_LEFT_ALIGN, TRUE);
        BufferIntegerAsString(screen->msgFormat, 1, screen->mart->cost * screen->mart->quantity, 6, PRINTING_MODE_LEFT_ALIGN, TRUE);
        string = NewString_ReadMsgData(screen->msgData, msg_0435_00014);
#ifdef NEWGOLD_DIAG
        gDiagMartConfirmLine = msg_0435_00014;
#endif
    }
    StringExpandPlaceholders(screen->msgFormat, screen->string, string);
    String_Delete(string);
    LoadUserFrameGfx2(screen->bgConfig, GF_BG_LYR_SUB_0, 0x1B5, 5, Options_GetFrame(screen->options), HEAP_ID_FIELD1);
    DrawFrameAndWindow2(&screen->confirmWindow, TRUE, 0x1B5, 5);
    screen->confirmPrinterId = AddTextPrinterParameterized(&screen->confirmWindow, 1, screen->string, 0, 0, Options_GetTextFrameDelay(screen->options), NULL);
}
