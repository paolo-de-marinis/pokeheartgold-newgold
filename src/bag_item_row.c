#include "constants/items.h"

#include "bag_app_state.h"
#include "text.h"

// How many of each pocket's slots the redraw reads, by pocket.
extern const u8 ov15_022008C8[];

extern void ov15_021FE9F0(BagAppState *state, Window *window, u32 y, u32 which);
extern void ov15_021FF66C(MessageFormat *messageFormat, MsgData *msgData, Window *window, u32 quantity);
extern void ov15_021FE17C(BagAppState *bagApp);
extern void ov15_021FE1D0(BagAppState *bagApp);
extern void ov15_021FE204(BagAppState *bagApp);

#define ROW_Y 0x10

// The slot of the pocket's nth item, counting only the slots that hold one.
static int ov15_021FF320(BagViewPocket *pocket, u8 pocketId, int n) {
    int i;
    int found = 0;

    for (i = 0; i < ov15_022008C8[pocketId]; i++) {
        if (pocket->slots[i].id != ITEM_NONE && pocket->slots[i].quantity != 0) {
            found++;
            if (found == n + 1) {
                break;
            }
        }
    }
    return i;
}

static inline Window *ListRowWindow(BagAppState *bagApp, u32 row) {
    return &bagApp->listWindows[row];
}

// Draw a page of the list from its scroll'th item into the set of rows not on
// show, then swap the two sets. While an item is being moved, only that item
// is drawn with its quantity or badge.
void ov15_021FF364(BagAppState *bagApp, int scroll, int unused, BOOL movingOnly) {
    int i, j, drawn;
    int first, other, window;
    BagViewPocket *pocket = &bagApp->bagView->pockets[bagApp->bagView->unk64];
    int rows = pocket->count - pocket->scroll;

    if (rows > 6) {
        rows = 6;
    }
    if (bagApp->unk68A == 0) {
        first = 0;
        other = 6;
    } else {
        first = 6;
        other = 0;
    }
    bagApp->unk68A ^= 1;
    ov15_021FE17C(bagApp);
    window = first;
    for (j = 0; j < 6; j++) {
        FillWindowPixelBuffer(ListRowWindow(bagApp, window), 0);
        ClearWindowTilemapAndScheduleTransfer(ListRowWindow(bagApp, other));
        window++;
        other++;
    }
    drawn = 0;
    i = ov15_021FF320(pocket, bagApp->bagView->unk64, scroll);
    if (i < ov15_022008C8[bagApp->bagView->unk64]) {
        window = first;
        do {
            if (pocket->slots[i].id == ITEM_NONE || pocket->slots[i].quantity == 0) {
                continue;
            }
            if (movingOnly == FALSE) {
                ov15_021FF570(bagApp, ListRowWindow(bagApp, window), bagApp->listNames[i], pocket, i);
            } else if (i == bagApp->unk672) {
                ov15_021FF570(bagApp, ListRowWindow(bagApp, window), bagApp->listNames[i], pocket, i);
            } else {
                AddTextPrinterParameterizedWithColor(ListRowWindow(bagApp, window), 0, bagApp->listNames[i], 0, ROW_Y, TEXT_SPEED_NOTRANSFER, MAKE_TEXT_COLOR(1, 2, 0), NULL);
            }
            window++;
            if (++drawn >= rows) {
                break;
            }
        } while (++i < ov15_022008C8[bagApp->bagView->unk64]);
    }
    window = first;
    for (i = 0; i < 6; i++) {
        ScheduleWindowCopyToVram(ListRowWindow(bagApp, window));
        window++;
    }
}

// Clear the list's rows and draw the item at scroll + position alone, in the
// window at 0x174.
void ov15_021FF4EC(BagAppState *bagApp, int scroll, int position) {
    BagViewPocket *pocket = &bagApp->bagView->pockets[bagApp->bagView->unk64];
    int i;

    position += scroll;
    for (i = 0; i < 6; i++) {
        ClearWindowTilemapAndScheduleTransfer(&bagApp->listWindows[i]);
    }
    ov15_021FE1D0(bagApp);
    ClearWindowTilemapAndScheduleTransfer(&bagApp->unk064);
    ov15_021FE204(bagApp);
    ov15_021FF570(bagApp, &bagApp->unk174, bagApp->listNames[position], pocket, position);
    ScheduleWindowCopyToVram(&bagApp->unk174);
}

void ov15_021FF560(BagAppState *bagApp) {
    ClearWindowTilemapAndScheduleTransfer(&bagApp->unk174);
}

void ov15_021FF570(BagAppState *state, Window *window, String *name, BagViewPocket *list, u32 index) {
    switch (list->pocketId) {
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
