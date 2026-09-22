    .include "macros/btlcmd.inc"

    .data

// The Stealth Rock half of Stone Axe: the same two lines effect script 266
// uses, moved into a subscript so the damage can land first and the stones
// only go down on a hit. Nothing here is a second copy of the switch-in
// check -- subscript 99 finds these stones the same way it finds the ones
// Stealth Rock itself lays.
_000:
    CompareVarToValue OPCODE_FLAG_SET, BSCRIPT_VAR_SIDE_CONDITION_TARGET, SIDE_CONDITION_STEALTH_ROCKS, _END
    UpdateVar OPCODE_FLAG_ON, BSCRIPT_VAR_SIDE_CONDITION_TARGET, SIDE_CONDITION_STEALTH_ROCKS
    // Pointed stones float in the air around your team!
    PrintMessage msg_0197_01077, TAG_NONE_SIDE, BATTLER_CATEGORY_ATTACKER_ENEMY
    Wait
    WaitButtonABTime 30

_END:
    End
