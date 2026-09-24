#include "global.h"

#include "msgdata/msg.naix"

#include "overlay_31_0225D60C.h"

// The mart's bottom screen opens its text: the placeholders, the mart's own
// lines, the names of the items it lists and a line to print them into.
void ov31_0225D60C(MartBottomScreen *screen) {
    screen->msgFormat = MessageFormat_New_Custom(8, 64, HEAP_ID_8);
    screen->msgData = NewMsgDataFromNarc(MSGDATA_LOAD_DIRECT, NARC_msgdata_msg, NARC_msg_msg_0435_bin, HEAP_ID_8);
    screen->itemNames = NewMsgDataFromNarc(MSGDATA_LOAD_DIRECT, NARC_msgdata_msg, NARC_msg_msg_0222_bin, HEAP_ID_8);
    screen->string = String_New(144, HEAP_ID_8);
}
