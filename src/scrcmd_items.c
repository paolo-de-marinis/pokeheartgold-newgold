#include "constants/items.h"

#include "overlay_2/overlay_02_02248728.h"

#include "bag.h"
#include "field_system.h"
#include "scrcmd.h"

BOOL ScrCmd_GiveItem(ScriptContext *ctx) {
    FieldSystem *sav_ptr = ctx->fieldSystem;
    u16 item_id = ScriptGetVar(ctx);
    u16 quantity = ScriptGetVar(ctx);
    u16 *ret_ptr = ScriptGetVarPointer(ctx);

    Bag *bag = Save_Bag_Get(sav_ptr->saveData);
    *ret_ptr = Bag_AddItem(bag, item_id, quantity, HEAP_ID_FIELD1);

    return FALSE;
}

BOOL ScrCmd_TakeItem(ScriptContext *ctx) {
    FieldSystem *sav_ptr = ctx->fieldSystem;
    u16 item_id = ScriptGetVar(ctx);
    u16 quantity = ScriptGetVar(ctx);
    u16 *ret_ptr = ScriptGetVarPointer(ctx);

    Bag *bag = Save_Bag_Get(sav_ptr->saveData);
    *ret_ptr = Bag_TakeItem(bag, item_id, quantity, HEAP_ID_FIELD1);

    return FALSE;
}

BOOL ScrCmd_HasSpaceForItem(ScriptContext *ctx) {
    FieldSystem *sav_ptr = ctx->fieldSystem;
    u16 item_id = ScriptGetVar(ctx);
    u16 quantity = ScriptGetVar(ctx);
    u16 *ret_ptr = ScriptGetVarPointer(ctx);

    Bag *bag = Save_Bag_Get(sav_ptr->saveData);
    *ret_ptr = Bag_HasSpaceForItem(bag, item_id, quantity, HEAP_ID_FIELD1);

    return FALSE;
}

BOOL ScrCmd_HasItem(ScriptContext *ctx) {
    FieldSystem *sav_ptr = ctx->fieldSystem;
    u16 item_id = ScriptGetVar(ctx);
    u16 quantity = ScriptGetVar(ctx);
    u16 *ret_ptr = ScriptGetVarPointer(ctx);

    Bag *bag = Save_Bag_Get(sav_ptr->saveData);
    *ret_ptr = Bag_HasItem(bag, item_id, quantity, HEAP_ID_FIELD2);

    return FALSE;
}

BOOL ScrCmd_GetItemQuantity(ScriptContext *ctx) {
    FieldSystem *sav_ptr = ctx->fieldSystem;
    u16 item_id = ScriptGetVar(ctx);
    u16 *ret_ptr = ScriptGetVarPointer(ctx);

    Bag *bag = Save_Bag_Get(sav_ptr->saveData);
    *ret_ptr = Bag_GetQuantity(bag, item_id, HEAP_ID_FIELD2);

    return FALSE;
}

// Whether an item ball's or a hidden item's find is a machine, whose message
// names its move: ItemIsMachine, the machine table's, where retail's
// ItemIsTMOrHM (asm/unk_0205BB1C.s, removed once unused) knew TM01 to HM08
// alone.
BOOL ScrCmd_ItemIsTMOrHM(ScriptContext *ctx) {
    u16 item_id = ScriptGetVar(ctx);
    u16 *ret_ptr = ScriptGetVarPointer(ctx);

    *ret_ptr = ItemIsMachine(item_id);

    return FALSE;
}

BOOL ScrCmd_GetItemPocket(ScriptContext *ctx) {
    u16 item_id = ScriptGetVar(ctx);
    u16 *ret_ptr = ScriptGetVarPointer(ctx);

    *ret_ptr = GetItemAttr(item_id, ITEMATTR_FIELD_POCKET, HEAP_ID_FIELD2);

    return FALSE;
}

BOOL ScrCmd_UseNextRepel(ScriptContext *ctx) {
    u16 *itemId = ScriptGetVarPointer(ctx);
    *itemId = FieldSystem_UseNextRepel(ctx->fieldSystem);
    return FALSE;
}
