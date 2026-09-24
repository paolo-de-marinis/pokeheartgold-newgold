#include "battle/trainer_ai.h"

// The commands still in the assembly (asm/overlay_10_trainer_ai_*.s), until
// their files come to C and declare them in trainer_ai.h.
void ov10_0221D260(BattleSystem *battleSystem, BattleContext *ctx);
void ov10_0221D314(BattleSystem *battleSystem, BattleContext *ctx);
void ov10_0221D3AC(BattleSystem *battleSystem, BattleContext *ctx);
void ov10_0221D4A0(BattleSystem *battleSystem, BattleContext *ctx);
void ov10_0221D594(BattleSystem *battleSystem, BattleContext *ctx);
void ov10_0221DCEC(BattleSystem *battleSystem, BattleContext *ctx);
void ov10_0221DD5C(BattleSystem *battleSystem, BattleContext *ctx);
void ov10_0221DDCC(BattleSystem *battleSystem, BattleContext *ctx);
void ov10_0221DDE8(BattleSystem *battleSystem, BattleContext *ctx);
void ov10_0221DDEC(BattleSystem *battleSystem, BattleContext *ctx);
void ov10_0221DDF0(BattleSystem *battleSystem, BattleContext *ctx);
void ov10_0221DE24(BattleSystem *battleSystem, BattleContext *ctx);
void ov10_0221EA44(BattleSystem *battleSystem, BattleContext *ctx);
void ov10_0221EA7C(BattleSystem *battleSystem, BattleContext *ctx);
void ov10_0221EAC8(BattleSystem *battleSystem, BattleContext *ctx);
void ov10_0221EB00(BattleSystem *battleSystem, BattleContext *ctx);
void ov10_0221EB18(BattleSystem *battleSystem, BattleContext *ctx);
void ov10_0221EC08(BattleSystem *battleSystem, BattleContext *ctx);
void ov10_0221EC28(BattleSystem *battleSystem, BattleContext *ctx);
void ov10_0221EC44(BattleSystem *battleSystem, BattleContext *ctx);
void ov10_0221EC6C(BattleSystem *battleSystem, BattleContext *ctx);
void ov10_0221ED10(BattleSystem *battleSystem, BattleContext *ctx);
void ov10_0221ED48(BattleSystem *battleSystem, BattleContext *ctx);
void ov10_0221ED80(BattleSystem *battleSystem, BattleContext *ctx);
void ov10_0221EDB4(BattleSystem *battleSystem, BattleContext *ctx);
void ov10_0221DE88(BattleSystem *battleSystem, BattleContext *ctx);
void ov10_0221DEF0(BattleSystem *battleSystem, BattleContext *ctx);
void ov10_0221DF20(BattleSystem *battleSystem, BattleContext *ctx);
void ov10_0221DF88(BattleSystem *battleSystem, BattleContext *ctx);
void ov10_0221E018(BattleSystem *battleSystem, BattleContext *ctx);
void ov10_0221E0BC(BattleSystem *battleSystem, BattleContext *ctx);
void ov10_0221E0EC(BattleSystem *battleSystem, BattleContext *ctx);
void ov10_0221E11C(BattleSystem *battleSystem, BattleContext *ctx);
void ov10_0221E1CC(BattleSystem *battleSystem, BattleContext *ctx);
void ov10_0221E290(BattleSystem *battleSystem, BattleContext *ctx);
void ov10_0221E2CC(BattleSystem *battleSystem, BattleContext *ctx);
void ov10_0221E460(BattleSystem *battleSystem, BattleContext *ctx);
void ov10_0221E498(BattleSystem *battleSystem, BattleContext *ctx);
void ov10_0221E5B0(BattleSystem *battleSystem, BattleContext *ctx);
void ov10_0221E600(BattleSystem *battleSystem, BattleContext *ctx);
void ov10_0221E650(BattleSystem *battleSystem, BattleContext *ctx);
void ov10_0221E6A4(BattleSystem *battleSystem, BattleContext *ctx);
void ov10_0221E6F8(BattleSystem *battleSystem, BattleContext *ctx);
void ov10_0221E9A4(BattleSystem *battleSystem, BattleContext *ctx);
void ov10_0221E9F4(BattleSystem *battleSystem, BattleContext *ctx);
void ov10_0221EDF8(BattleSystem *battleSystem, BattleContext *ctx);

// The AI script commands by opcode, the number each command's first word
// holds: ov10_0221C278 calls the one under the script's cursor.
const AICommandFunc ov10_0222B0B4[] = {
    ov10_0221C384, // 0x00
    ov10_0221C3C4, // 0x01
    ov10_0221C404, // 0x02
    ov10_0221C444, // 0x03
    ov10_0221C484, // 0x04
    ov10_0221C4B8, // 0x05
    ov10_0221C510, // 0x06
    ov10_0221C568, // 0x07
    ov10_0221C5C0, // 0x08
    ov10_0221C618, // 0x09
    ov10_0221C664, // 0x0A
    ov10_0221C6B0, // 0x0B
    ov10_0221C6FC, // 0x0C
    ov10_0221C748, // 0x0D
    ov10_0221C790, // 0x0E
    ov10_0221C7D8, // 0x0F
    ov10_0221C828, // 0x10
    ov10_0221C878, // 0x11
    ov10_0221C8A8, // 0x12
    ov10_0221C8D8, // 0x13
    ov10_0221C908, // 0x14
    ov10_0221C938, // 0x15
    ov10_0221C968, // 0x16
    ov10_0221C998, // 0x17
    ov10_0221C9C8, // 0x18
    ov10_0221C9F8, // 0x19
    ov10_0221CA4C, // 0x1A
    ov10_0221CA9C, // 0x1B
    ov10_0221CB00, // 0x1C
    ov10_0221CB64, // 0x1D
    ov10_0221CB80, // 0x1E
    ov10_0221CD10, // 0x1F
    ov10_0221CD34, // 0x20
    ov10_0221CE70, // 0x21
    ov10_0221CEA4, // 0x22
    ov10_0221CED4, // 0x23
    ov10_0221CF04, // 0x24
    ov10_0221CF48, // 0x25
    ov10_0221CF8C, // 0x26
    ov10_0221D068, // 0x27
    ov10_0221D084, // 0x28
    ov10_0221D0A8, // 0x29
    ov10_0221D260, // 0x2A
    ov10_0221D314, // 0x2B
    ov10_0221D3AC, // 0x2C
    ov10_0221D4A0, // 0x2D
    ov10_0221D594, // 0x2E
    ov10_0221D60C, // 0x2F
    ov10_0221D644, // 0x30
    ov10_0221D67C, // 0x31
    ov10_0221D6D0, // 0x32
    ov10_0221D724, // 0x33
    ov10_0221D778, // 0x34
    ov10_0221D7CC, // 0x35
    ov10_0221D8F8, // 0x36
    ov10_0221DA24, // 0x37
    ov10_0221DAE4, // 0x38
    ov10_0221DBA4, // 0x39
    ov10_0221DC48, // 0x3A
    ov10_0221DCEC, // 0x3B
    ov10_0221DD5C, // 0x3C
    ov10_0221DDCC, // 0x3D
    ov10_0221DDE8, // 0x3E
    ov10_0221DDEC, // 0x3F
    ov10_0221DDF0, // 0x40
    ov10_0221DE24, // 0x41
    ov10_0221EA44, // 0x42
    ov10_0221EA7C, // 0x43
    ov10_0221EAC8, // 0x44
    ov10_0221EB00, // 0x45
    ov10_0221EB18, // 0x46
    ov10_0221EB4C, // 0x47
    ov10_0221EB6C, // 0x48
    ov10_0221EB8C, // 0x49
    ov10_0221EBAC, // 0x4A
    ov10_0221EC08, // 0x4B
    ov10_0221EC28, // 0x4C
    ov10_0221EC44, // 0x4D
    ov10_0221EC6C, // 0x4E
    ov10_0221ED10, // 0x4F
    ov10_0221ED48, // 0x50
    ov10_0221ED80, // 0x51
    ov10_0221CCB4, // 0x52
    ov10_0221D188, // 0x53
    ov10_0221EDB4, // 0x54
    ov10_0221DE88, // 0x55
    ov10_0221DEF0, // 0x56
    ov10_0221DF20, // 0x57
    ov10_0221DF88, // 0x58
    ov10_0221E018, // 0x59
    ov10_0221E0BC, // 0x5A
    ov10_0221E0EC, // 0x5B
    ov10_0221E11C, // 0x5C
    ov10_0221E178, // 0x5D
    ov10_0221E19C, // 0x5E
    ov10_0221E1CC, // 0x5F
    ov10_0221E290, // 0x60
    ov10_0221E2CC, // 0x61
    ov10_0221E460, // 0x62
    ov10_0221E498, // 0x63
    ov10_0221E5B0, // 0x64
    ov10_0221E600, // 0x65
    ov10_0221E650, // 0x66
    ov10_0221E6A4, // 0x67
    ov10_0221E6F8, // 0x68
    ov10_0221E848, // 0x69
    ov10_0221E9A4, // 0x6A
    ov10_0221E9F4, // 0x6B
    ov10_0221EDF8, // 0x6C
};
