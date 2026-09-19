#include "constants/std_script.h"

#include "overlay_2/overlay_02_02248728.h"

#include "roamer.h"
#include "script.h"

BOOL PlayerStepEvent_RepelCounterDecrement(SaveData *saveData, FieldSystem *fieldSystem) {
    u8 *repelSteps = RoamerSave_GetRepelAddr(Save_Roamers_Get(saveData));

    if (*repelSteps != 0) {
        (*repelSteps)--;
        if (*repelSteps == 0) {
            StartMapSceneScript(fieldSystem, std_repel_wore_off, NULL);
            return TRUE;
        }
    }
    return FALSE;
}
