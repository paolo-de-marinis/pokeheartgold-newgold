#ifndef POKEHEARTGOLD_TRAINER_AI_H
#define POKEHEARTGOLD_TRAINER_AI_H

#include "battle.h"

void ov10_0221BE20(BattleSystem *battleSystem, BattleContext *ctx, u8 battlerId, u8 a3);
u8 ov10_0221BEF4(BattleSystem *battleSystem, u8 battlerId);

// Effect lists in the AI's read-only data, each ended by 0xFFFF: the effects
// whose damage the AI estimates whatever their listed power (0222B080), and
// the ones it never compares by damage (0222B098).
extern const u16 ov10_0222B080[];
extern const u16 ov10_0222B098[];

// the following functions are in reality static but need to be decompiled still or are used by non-decompiled functions
u8 ov10_0221BF44(BattleSystem *battleSystem, BattleContext *ctx);
u8 ov10_0221C038(BattleSystem *battleSystem, BattleContext *ctx);
void ov10_0221C278(BattleSystem *battleSystem, BattleContext *ctx);
void ov10_0221EE88(BattleSystem *battleSystem, BattleContext *ctx);

void ov10_0221CA9C(BattleSystem *battleSystem, BattleContext *ctx);
void ov10_0221CB00(BattleSystem *battleSystem, BattleContext *ctx);
void ov10_0221CB64(BattleSystem *battleSystem, BattleContext *ctx);
void ov10_0221CB80(BattleSystem *battleSystem, BattleContext *ctx);
void ov10_0221CCB4(BattleSystem *battleSystem, BattleContext *ctx);
void ov10_0221CD10(BattleSystem *battleSystem, BattleContext *ctx);
void ov10_0221CD34(BattleSystem *battleSystem, BattleContext *ctx);
void ov10_0221CE70(BattleSystem *battleSystem, BattleContext *ctx);
void ov10_0221CEA4(BattleSystem *battleSystem, BattleContext *ctx);
void ov10_0221CED4(BattleSystem *battleSystem, BattleContext *ctx);
void ov10_0221CF04(BattleSystem *battleSystem, BattleContext *ctx);
void ov10_0221CF48(BattleSystem *battleSystem, BattleContext *ctx);
void ov10_0221CF8C(BattleSystem *battleSystem, BattleContext *ctx);
void ov10_0221D068(BattleSystem *battleSystem, BattleContext *ctx);
void ov10_0221D084(BattleSystem *battleSystem, BattleContext *ctx);
void ov10_0221D0A8(BattleSystem *battleSystem, BattleContext *ctx);
void ov10_0221D188(BattleSystem *battleSystem, BattleContext *ctx);
u32 ov10_0221EEF0(BattleContext *ctx);
void ov10_0221EF24(BattleContext *ctx, int offset);
u8 ov10_0221EF34(BattleContext *ctx, u8 battler);

s32 ov10_0221EF7C(BattleSystem *battleSystem, BattleContext *ctx, int battlerId, u16 *moves, s32 *damages, u16 heldItem, u8 *ivs, int ability, int embargoTurns, int varyDamage);
int ov10_0221F47C(BattleSystem *battleSystem, BattleContext *ctx, int battlerId, int move);
BOOL ov10_0221F62C(BattleSystem *battleSystem, BattleContext *ctx, int battlerId);
BOOL ov10_0221FD34(BattleSystem *battleSystem, BattleContext *ctx, int battlerId, BOOL noRandom);
BOOL ov10_0221FE8C(BattleSystem *battleSystem, BattleContext *ctx, int battlerId);

#endif
