#include "constants/items.h"

#include "bag_app_state.h"
#include "heap.h"

typedef char BagAppStateViewCheck[offsetof(BagAppState, bagView) == 0x234 ? 1 : -1];
typedef char BagAppStateNamesCheck[offsetof(BagAppState, listNames) == 0x350 ? 1 : -1];
typedef char BagAppStateItemsCheck[offsetof(BagAppState, listItems) == 0x6A4 ? 1 : -1];
typedef char BagAppStateSizeCheck[sizeof(BagAppState) == 0x94C ? 1 : -1];

// How many of each pocket's slots the list reads, by pocket.
extern const u8 ov15_022008B0[];

extern void ov15_021F9D8C(MsgData *msgData, String *dest, u16 itemId, enum HeapID heapID);
extern void ov15_021F9D9C(MsgData *msgData, String *dest, u16 itemId, enum HeapID heapID);

// Build the list of the pocket on show: the name of each item it holds, or
// the move a machine teaches, and the item itself, up to the first empty
// slot; then keep the page in the list.
void ov15_021F9F08(BagAppState *bagApp) {
    BagViewPocket *pocket = &bagApp->bagView->pockets[bagApp->bagView->unk64];
    u32 i;
    int lastPage;

    if (pocket->pocketId == POCKET_TMHMS) {
        for (i = 0; i < ov15_022008B0[pocket->pocketId]; i++) {
            if (pocket->slots[i].id == ITEM_NONE || pocket->slots[i].quantity == 0) {
                break;
            }
            ov15_021F9D9C(bagApp->moveNamesMsgData, bagApp->listNames[i], pocket->slots[i].id, HEAP_ID_6);
            bagApp->listItems[i] = pocket->slots[i].id;
        }
        pocket->count = i;
    } else {
        for (i = 0; i < ov15_022008B0[pocket->pocketId]; i++) {
            if (pocket->slots[i].id == ITEM_NONE || pocket->slots[i].quantity == 0) {
                break;
            }
            ov15_021F9D8C(bagApp->itemNamesMsgData, bagApp->listNames[i], pocket->slots[i].id, HEAP_ID_6);
            bagApp->listItems[i] = pocket->slots[i].id;
        }
        pocket->count = i;
    }
    if (pocket->count == 0) {
        lastPage = 0;
    } else {
        lastPage = (pocket->count - 1) / 6 * 6;
    }
    if (pocket->scroll > lastPage) {
        pocket->scroll = lastPage;
    }
}

void ov15_021FA008(BagAppState *bagApp) {
    u32 i;

    for (i = 0; i < BAG_LIST_CAPACITY; i++) {
        bagApp->listNames[i] = String_New(18, HEAP_ID_6);
    }
}

void ov15_021FA028(BagAppState *bagApp) {
    u32 i;

    for (i = 0; i < BAG_LIST_CAPACITY; i++) {
        String_Delete(bagApp->listNames[i]);
    }
}
