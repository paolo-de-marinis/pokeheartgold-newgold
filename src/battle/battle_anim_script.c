#include "overlay_07.h"

#include "global.h"

// The battle animations' script (asm/macros/btlanim.inc), which overlay 7
// runs a command at a time (ov07_0221BE44): a word for the command, whose
// handler comes from ov07_02234DE8, and its operands after it, which the
// handler reads.
#define BATTLE_ANIM_SCRIPT_COMMANDS 0x58
#define BATTLE_ANIM_SCRIPT_END      4

extern const BattleAnimScriptCommand ov07_02234DE8[BATTLE_ANIM_SCRIPT_COMMANDS];

// A command the table does not hold ends the animation, as End does: End
// leaves the script where it is, so the interpreter asks for the same
// command again each frame and is given End until the effects are over.
// The game's own check let 0x58 through, one past the table (hg-engine's
// changepermanentbg is 0x58, and a script carrying it ran the word after
// the table), and gave the interpreter NULL to call above it. No script
// here has either.
BattleAnimScriptCommand ov07_0221F8B0(u32 command) {
    if (command >= BATTLE_ANIM_SCRIPT_COMMANDS) {
        command = BATTLE_ANIM_SCRIPT_END;
    }
    return ov07_02234DE8[command];
}
