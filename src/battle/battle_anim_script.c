#include "overlay_07.h"

#include "global.h"

// The battle animations' script (asm/macros/btlanim.inc), which overlay 7
// runs a command at a time (ov07_0221BE44): a word for the command, whose
// handler comes from ov07_02234DE8, and its operands after it, which the
// handler reads.
extern const BattleAnimScriptCommand ov07_02234DE8[];

BattleAnimScriptCommand ov07_0221F8B0(u32 command) {
    if (command > 0x58) {
        return NULL;
    }
    return ov07_02234DE8[command];
}
