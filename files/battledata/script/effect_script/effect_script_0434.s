    .include "macros/btlcmd.inc"

    .data

// Fairy Lock holds every Pokemon on the field, Ghost-types aside, until the
// end of the next turn, and fails while it already does (Pokemon Central,
// Blocco Fatato). SetMoveConditionFlag locks the field and leaves in
// CALC_TEMP whether it did; CantEscape and BattlerCanSwitch ask the lock.
_000:
    SetMoveConditionFlag MOVE_FAIRY_LOCK, BATTLER_CATEGORY_ATTACKER
    CompareVarToValue OPCODE_EQU, BSCRIPT_VAR_CALC_TEMP, 0, _FAILED
    // No one will be able to run away during the next turn!
    BufferMessage msg_0197_01862, TAG_NONE
    UpdateVar OPCODE_SET, BSCRIPT_VAR_SIDE_EFFECT_FLAGS_INDIRECT, MOVE_SIDE_EFFECT_ON_HIT|MOVE_SUBSCRIPT_PTR_PRINT_MESSAGE_AND_PLAY_ANIMATION
    End

_FAILED:
    UpdateVar OPCODE_FLAG_ON, BSCRIPT_VAR_MOVE_STATUS_FLAGS, MOVE_STATUS_FAILED
    End
