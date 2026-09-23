#include "bag_app_state.h"
#include "heap.h"
#include "text.h"

typedef char BagAppStateDescriptionCheck[offsetof(BagAppState, descriptionWindow) == 0x4 ? 1 : -1];

#define BAG_NO_ITEM 0xFFFF

// The description of the item the cursor is on, or row 97 of the bag's
// messages when it is on the row that closes the bag.
void ov15_021FE5C4(BagAppState *bagApp, u16 itemId) {
    String *string;

    if (itemId != BAG_NO_ITEM) {
        string = String_New(ITEM_DESCRIPTION_LENGTH, HEAP_ID_6);
        GetItemDescIntoString(string, itemId, HEAP_ID_6);
    } else {
        string = NewString_ReadMsgData(bagApp->msgData, 97);
    }
    AddTextPrinterParameterizedWithColor(&bagApp->descriptionWindow, 0, string, 20, 0, TEXT_SPEED_NOTRANSFER, MAKE_TEXT_COLOR(15, 14, 0), NULL);
    String_Delete(string);
}
