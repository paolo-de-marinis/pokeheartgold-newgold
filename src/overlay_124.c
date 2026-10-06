#include "overlay_124.h"

#include "global.h"

#include "field_system.h"
#include "follow_mon.h"
#include "main.h"
#include "map_events.h"
#include "save_local_field_data.h"
#include "unk_02092BB8.h"
#include "unk_02092BE8.h"

// Retail asks DSProt here, as the field map and a few screens do, whether
// it runs on a flashcart or an emulator, and on a yes takes heap 3 away.
// New Gold does not run DSProt (see FieldMap_Init).
void FieldSystem_Init(OverlayManager *man, FieldSystem *fieldSystem) {
    UnkStruct_02111868_sub *args = OverlayManager_GetArgs(man);
    fieldSystem->saveData = args->saveData;
    fieldSystem->taskman = NULL;
    fieldSystem->location = LocalFieldData_GetCurrentPosition(Save_LocalFieldData_Get(fieldSystem->saveData));
    fieldSystem->mapMatrix = MapMatrix_New();
    Field_AllocateMapEvents(fieldSystem, HEAP_ID_FIELD2);
    fieldSystem->bagCursor = BagCursor_New(HEAP_ID_FIELD2);
    fieldSystem->unkA8 = UnkStruct_02092BB8_New(HEAP_ID_FIELD2);
    fieldSystem->unk108 = FieldSystem_UnkSub108_Alloc(HEAP_ID_FIELD2);
    fieldSystem->phoneRingManager = GearPhoneRingManager_New(HEAP_ID_FIELD2, fieldSystem);
    fieldSystem->judgeStatPosition = 0;
}
