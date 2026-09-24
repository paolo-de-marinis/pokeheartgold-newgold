#ifndef POKEHEARTGOLD_TRAINER_AI_H
#define POKEHEARTGOLD_TRAINER_AI_H

#include "battle.h"

// AI script battlers are relative to the attacker selecting a move.
enum {
    AI_BATTLER_TARGET,
    AI_BATTLER_ATTACKER,
    AI_BATTLER_TARGET_PARTNER,
    AI_BATTLER_ATTACKER_PARTNER
};

void ov10_0221BE20(BattleSystem *battleSystem, BattleContext *ctx, u8 battlerId, u8 a3);
u8 ov10_0221BEF4(BattleSystem *battleSystem, u8 battlerId);

// Low Kick's and Grass Knot's power by the target's weight, in tenths of a
// kilogram, up to a weight of 0xFFFF; past the last the power is 120.
extern const u16 ov10_0222B068[][2];

// Effect lists in the AI's read-only data, each ended by 0xFFFF: the effects
// whose damage the AI estimates whatever their listed power (0222B080), and
// the ones it never compares by damage (0222B098).
extern const u16 ov10_0222B080[];
extern const u16 ov10_0222B098[];

// The AI script commands, by opcode.
typedef void (*AICommandFunc)(BattleSystem *battleSystem, BattleContext *ctx);
extern const AICommandFunc ov10_0222B0B4[];

// the following functions are in reality static but need to be decompiled still or are used by non-decompiled functions
u8 ov10_0221BF44(BattleSystem *battleSystem, BattleContext *ctx);
u8 ov10_0221C038(BattleSystem *battleSystem, BattleContext *ctx);
void ov10_0221C278(BattleSystem *battleSystem, BattleContext *ctx);
void ov10_0221EE88(BattleSystem *battleSystem, BattleContext *ctx);

void ov10_0221C384(BattleSystem *battleSystem, BattleContext *ctx);
void ov10_0221C3C4(BattleSystem *battleSystem, BattleContext *ctx);
void ov10_0221C404(BattleSystem *battleSystem, BattleContext *ctx);
void ov10_0221C444(BattleSystem *battleSystem, BattleContext *ctx);
void ov10_0221C484(BattleSystem *battleSystem, BattleContext *ctx);
void ov10_0221C4B8(BattleSystem *battleSystem, BattleContext *ctx);
void ov10_0221C510(BattleSystem *battleSystem, BattleContext *ctx);
void ov10_0221C568(BattleSystem *battleSystem, BattleContext *ctx);
void ov10_0221C5C0(BattleSystem *battleSystem, BattleContext *ctx);
void ov10_0221C618(BattleSystem *battleSystem, BattleContext *ctx);
void ov10_0221C664(BattleSystem *battleSystem, BattleContext *ctx);
void ov10_0221C6B0(BattleSystem *battleSystem, BattleContext *ctx);
void ov10_0221C6FC(BattleSystem *battleSystem, BattleContext *ctx);
void ov10_0221C748(BattleSystem *battleSystem, BattleContext *ctx);
void ov10_0221C790(BattleSystem *battleSystem, BattleContext *ctx);
void ov10_0221C7D8(BattleSystem *battleSystem, BattleContext *ctx);
void ov10_0221C828(BattleSystem *battleSystem, BattleContext *ctx);
void ov10_0221C878(BattleSystem *battleSystem, BattleContext *ctx);
void ov10_0221C8A8(BattleSystem *battleSystem, BattleContext *ctx);
void ov10_0221C8D8(BattleSystem *battleSystem, BattleContext *ctx);
void ov10_0221C908(BattleSystem *battleSystem, BattleContext *ctx);
void ov10_0221C938(BattleSystem *battleSystem, BattleContext *ctx);
void ov10_0221C968(BattleSystem *battleSystem, BattleContext *ctx);
void ov10_0221C998(BattleSystem *battleSystem, BattleContext *ctx);
void ov10_0221C9C8(BattleSystem *battleSystem, BattleContext *ctx);
void ov10_0221C9F8(BattleSystem *battleSystem, BattleContext *ctx);
void ov10_0221CA4C(BattleSystem *battleSystem, BattleContext *ctx);
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
void ov10_0221D60C(BattleSystem *battleSystem, BattleContext *ctx);
void ov10_0221D644(BattleSystem *battleSystem, BattleContext *ctx);
void ov10_0221D67C(BattleSystem *battleSystem, BattleContext *ctx);
void ov10_0221D6D0(BattleSystem *battleSystem, BattleContext *ctx);
void ov10_0221D724(BattleSystem *battleSystem, BattleContext *ctx);
void ov10_0221D778(BattleSystem *battleSystem, BattleContext *ctx);
void ov10_0221D7CC(BattleSystem *battleSystem, BattleContext *ctx);
void ov10_0221D8F8(BattleSystem *battleSystem, BattleContext *ctx);
void ov10_0221DA24(BattleSystem *battleSystem, BattleContext *ctx);
void ov10_0221DAE4(BattleSystem *battleSystem, BattleContext *ctx);
void ov10_0221DBA4(BattleSystem *battleSystem, BattleContext *ctx);
void ov10_0221DC48(BattleSystem *battleSystem, BattleContext *ctx);
void ov10_0221E178(BattleSystem *battleSystem, BattleContext *ctx);
void ov10_0221E19C(BattleSystem *battleSystem, BattleContext *ctx);
void ov10_0221E848(BattleSystem *battleSystem, BattleContext *ctx);
void ov10_0221EB4C(BattleSystem *battleSystem, BattleContext *ctx);
void ov10_0221EB6C(BattleSystem *battleSystem, BattleContext *ctx);
void ov10_0221EB8C(BattleSystem *battleSystem, BattleContext *ctx);
void ov10_0221EBAC(BattleSystem *battleSystem, BattleContext *ctx);
u32 ov10_0221EEF0(BattleContext *ctx);
u32 ov10_0221EF10(BattleContext *ctx, int offset);
void ov10_0221EF24(BattleContext *ctx, int offset);
u8 ov10_0221EF34(BattleContext *ctx, u8 battler);

s32 ov10_0221EF7C(BattleSystem *battleSystem, BattleContext *ctx, int battlerId, u16 *moves, s32 *damages, u16 heldItem, u8 *ivs, int ability, int embargoTurns, int varyDamage);
u32 ov10_0221F084(BattleSystem *battleSystem, BattleContext *ctx, u16 move, u16 heldItem, u8 *ivs, int battlerId, int ability, int embargoTurns, u8 roll);
int ov10_0221F47C(BattleSystem *battleSystem, BattleContext *ctx, int battlerId, int move);
BOOL ov10_0221F5F4(BattleContext *ctx, int battlerId);
BOOL ov10_0221F7F0(BattleSystem *battleSystem, BattleContext *ctx, int battlerId);
BOOL ov10_0221F62C(BattleSystem *battleSystem, BattleContext *ctx, int battlerId);
BOOL ov10_0221FD34(BattleSystem *battleSystem, BattleContext *ctx, int battlerId, BOOL noRandom);
BOOL ov10_0221FE8C(BattleSystem *battleSystem, BattleContext *ctx, int battlerId);
BOOL ov10_02220010(BattleSystem *battleSystem, BattleContext *ctx, int battlerId, u32 checkEffectiveness, u8 randomDenominator);
BOOL ov10_02220270(BattleSystem *battleSystem, BattleContext *ctx, int battlerId);
BOOL ov10_0222036C(BattleSystem *battleSystem, BattleContext *ctx, int battlerId);
BOOL ov10_022203A4(BattleSystem *battleSystem, BattleContext *ctx, int battlerId);

#endif
