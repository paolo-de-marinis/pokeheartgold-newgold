#include "overlay_15.h"
#include "roamer.h"

extern RoamerSaveData *BagApp_GetSaveRoamers(struct BagApp *bagApp);

void BagApp_GetRepelStepCountAddr(struct BagApp *bagApp, u8 repelSteps) {
    *RoamerSave_GetRepelAddr(BagApp_GetSaveRoamers(bagApp)) = repelSteps;
}
