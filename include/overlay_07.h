#ifndef POKEHEARTGOLD_OVERLAY_07_H
#define POKEHEARTGOLD_OVERLAY_07_H

#include "battle/battle.h"

void UnkBallData_SetBallAnimation(UnkBallData *data, s32 ballAnim);
BOOL ov07_02232F60(UnkBallData *data, s32 ballAnim_Unused); // IsBallAnimationPlaying?
UnkBallData *ov07_02233DB8(UnkStruct_134 *unkStruct_134);   // unkBallData_Init?
void ov07_02233ECC(UnkBallData *data);                      // unkBallData_Destroy?
s32 ov07_02233F20(UnkBallData *data);

// A command of the battle animations' script: its handler (ov07_0221F8B0).
typedef void (*BattleAnimScriptCommand)(void *animSystem);
BattleAnimScriptCommand ov07_0221F8B0(u32 command);

#endif // POKEHEARTGOLD_OVERLAY_07_H
