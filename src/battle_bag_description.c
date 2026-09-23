#include "battle_bag.h"
#include "text.h"

typedef char BattleBagWindowsCheck[offsetof(BattleBag, windows) == 0x2C ? 1 : -1];
typedef char BattleBagItemsCheck[offsetof(BattleBag, pocketItems) == 0x3C ? 1 : -1];
typedef char BattleBagPocketCheck[offsetof(BattleBag, pocket) == 0x114D ? 1 : -1];

// The description of the item at a place in the battle bag's list on show.
void ov08_02223A3C(BattleBag *bag, int index) {
    Window *window = &bag->windows[2];
    String *string = String_New(130, bag->args->heapID);

    GetItemDescIntoString(string, bag->pocketItems[bag->pocket][index].id, (enum HeapID)(u16)bag->args->heapID);
    AddTextPrinterParameterizedWithColor(window, 0, string, 4, 0, TEXT_SPEED_NOTRANSFER, MAKE_TEXT_COLOR(1, 2, 0), NULL);
    String_Delete(string);
    ScheduleWindowCopyToVram(window);
}
