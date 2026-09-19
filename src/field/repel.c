#include "constants/items.h"
#include "constants/std_script.h"

#include "overlay_2/overlay_02_02248728.h"

#include "bag.h"
#include "item.h"
#include "roamer.h"
#include "script.h"

static u16 GetPreferredRepel(Bag *bag) {
    if (Bag_HasItem(bag, ITEM_MAX_REPEL, 1, HEAP_ID_3)) {
        return ITEM_MAX_REPEL;
    }
    if (Bag_HasItem(bag, ITEM_SUPER_REPEL, 1, HEAP_ID_3)) {
        return ITEM_SUPER_REPEL;
    }
    return ITEM_REPEL;
}

BOOL PlayerStepEvent_RepelCounterDecrement(SaveData *saveData, FieldSystem *fieldSystem) {
    u8 *repelSteps = RoamerSave_GetRepelAddr(Save_Roamers_Get(saveData));

    if (*repelSteps != 0) {
        (*repelSteps)--;
        if (*repelSteps == 0) {
            Bag *bag = Save_Bag_Get(saveData);
            u16 itemId = GetPreferredRepel(bag);
            if (Bag_HasItem(bag, itemId, 1, HEAP_ID_FIELD2)) {
                StartMapSceneScript(fieldSystem, std_reuse_repel, NULL);
            } else {
                StartMapSceneScript(fieldSystem, std_repel_wore_off, NULL);
            }
            return TRUE;
        }
    }
    return FALSE;
}

u16 FieldSystem_UseNextRepel(FieldSystem *fieldSystem) {
    SaveData *saveData = fieldSystem->saveData;
    Bag *bag = Save_Bag_Get(saveData);
    u16 itemId = GetPreferredRepel(bag);
    u8 *repelSteps = RoamerSave_GetRepelAddr(Save_Roamers_Get(saveData));

    if (Bag_TakeItem(bag, itemId, 1, HEAP_ID_3)) {
        *repelSteps = GetItemAttr(itemId, ITEMATTR_HOLD_EFFECT_PARAM, HEAP_ID_3);
    }
    return itemId;
}
