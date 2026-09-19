#ifndef POKEHEARTGOLD_OVY_15_H
#define POKEHEARTGOLD_OVY_15_H

#include "overlay_manager.h"

struct BagApp;

BOOL Bag_Init(OverlayManager *man, int *state);
BOOL Bag_Main(OverlayManager *man, int *state);
BOOL Bag_Exit(OverlayManager *man, int *state);

void BagApp_GetRepelStepCountAddr(struct BagApp *bagApp, u8 repelSteps);

#endif // POKEHEARTGOLD_OVY_15_H
