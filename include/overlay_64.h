#ifndef POKEHEARTGOLD_OVY_64_H
#define POKEHEARTGOLD_OVY_64_H

#include "overlay_manager.h"

BOOL HallOfFameShowcase_Init(OverlayManager *man, int *state);
BOOL HallOfFameShowcase_Main(OverlayManager *man, int *state);
BOOL HallOfFameShowcase_Exit(OverlayManager *man, int *state);
u32 ov64_021E6E30(int species, int form, int gender);

#endif // POKEHEARTGOLD_OVY_64_H
