#ifndef POKEHEARTGOLD_TRAINER_AI_H
#define POKEHEARTGOLD_TRAINER_AI_H

#include "battle.h"

void ov10_0221BE20(BattleSystem *battleSystem, BattleContext *ctx, u8 battlerId, u8 a3);
u8 ov10_0221BEF4(BattleSystem *battleSystem, u8 battlerId);

// the following functions are in reality static but need to be decompiled still or are used by non-decompiled functions
u8 ov10_0221BF44(BattleSystem *battleSystem, BattleContext *ctx);
u8 ov10_0221C038(BattleSystem *battleSystem, BattleContext *ctx);

void ov10_0221D0A8(BattleSystem *battleSystem, BattleContext *ctx);
void ov10_0221D188(BattleSystem *battleSystem, BattleContext *ctx);
u32 ov10_0221EEF0(BattleContext *ctx);
void ov10_0221EF24(BattleContext *ctx, int offset);
u8 ov10_0221EF34(BattleContext *ctx, u8 battler);

int ov10_0221F47C(BattleSystem *battleSystem, BattleContext *ctx, int battlerId, int move);
BOOL ov10_0221F62C(BattleSystem *battleSystem, BattleContext *ctx, int battlerId);
BOOL ov10_0221FD34(BattleSystem *battleSystem, BattleContext *ctx, int battlerId, BOOL noRandom);
BOOL ov10_0221FE8C(BattleSystem *battleSystem, BattleContext *ctx, int battlerId);

#endif
