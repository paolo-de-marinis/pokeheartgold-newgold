#include "global.h"

#include "msgdata/msg/msg_0435.h"

#include "overlay_03.h"
#include "overlay_31_0225DE24.h"
#include "text.h"

// Prints a row's price in the mart's item list: in money, or in points at the
// Battle Frontier and Pokeathlon counters.
void ov31_0225DE24(MessageFormat *msgFmt, MsgData *msgData, Window *window, u32 price, int martType) {
    u32 msgNo = msg_0435_00018;
    if (martType == MART_TYPE_3 || martType == MART_TYPE_4) {
        msgNo = msg_0435_00019;
    }
    BufferIntegerAsString(msgFmt, 0, price, 4, PRINTING_MODE_LEFT_ALIGN, TRUE);
    String *string = ReadMsgData_ExpandPlaceholders(msgFmt, msgData, msgNo, HEAP_ID_8);
    AddTextPrinterParameterizedWithColor(window, 0, string, 36, 16, TEXT_SPEED_NOTRANSFER, MAKE_TEXT_COLOR(1, 2, 0), NULL);
    String_Delete(string);
}
