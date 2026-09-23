#include "constants/items.h"

#include "bag_app_state.h"
#include "text.h"

// Only the head of the list the bag is drawing is identified here: where its
// items are and which pocket they came from.
typedef struct BagItemListPrefix {
    ItemSlot *slots;
    u32 unk04;
    u8 pocket;
} BagItemListPrefix;

extern void ov15_021FE9F0(BagAppState *state, Window *window, u32 y, u32 which);
extern void ov15_021FF66C(MessageFormat *messageFormat, MsgData *msgData, Window *window, u32 quantity);

#define ROW_Y 0x10

void ov15_021FF570(BagAppState *state, Window *window, String *name, BagItemListPrefix *list, u32 index) {
    switch (list->pocket) {
    case POCKET_TMHMS:
        AddTextPrinterParameterizedWithColor(window, 0, name, 0, 0, TEXT_SPEED_NOTRANSFER, MAKE_TEXT_COLOR(1, 2, 0), NULL);
        ov15_021FE914(state, window, &list->slots[index], ROW_Y);
        // HeartGold counts TMs beside the name. New Gold's are never spent, so
        // the count is always the one the player bought and says nothing; HMs
        // never had one for the same reason. A TR is spent, so its count is
        // shown, as hg-engine's Bag_RenderMachineMoveSlot shows it.
        if (ItemIsTR(list->slots[index].id)) {
            ov15_021FF66C(state->messageFormat, state->msgData, window, list->slots[index].quantity);
        }
        break;
    case POCKET_KEY_ITEMS:
        AddTextPrinterParameterizedWithColor(window, 0, name, 0, 0, TEXT_SPEED_NOTRANSFER, MAKE_TEXT_COLOR(1, 2, 0), NULL);
        if (list->slots[index].id == Bag_GetRegisteredItem1(state->bag)) {
            ov15_021FE9F0(state, window, ROW_Y, 0);
        }
        if (list->slots[index].id == Bag_GetRegisteredItem2(state->bag)) {
            ov15_021FE9F0(state, window, ROW_Y, 1);
        }
        break;
    default:
        AddTextPrinterParameterizedWithColor(window, 0, name, 0, 0, TEXT_SPEED_NOTRANSFER, MAKE_TEXT_COLOR(1, 2, 0), NULL);
        ov15_021FF66C(state->messageFormat, state->msgData, window, list->slots[index].quantity);
        break;
    }
}
