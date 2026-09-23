    .include "macros/btlcmd.inc"

    .data

// Wonder Room swaps the Defense and Sp. Def of every Pokemon on the field for
// five turns, the stats and not their stages; used again while it lasts, it
// ends it (Pokemon Central, Mirabilzona). SetMoveConditionFlag puts it up or
// takes it down and leaves in CALC_TEMP whether it is up now.
_000:
    SetMoveConditionFlag MOVE_WONDER_ROOM, BATTLER_CATEGORY_ATTACKER
    CompareVarToValue OPCODE_EQU, BSCRIPT_VAR_CALC_TEMP, 0, _ENDED
    // It created a bizarre area in which Defense and Sp. Def stats are swapped!
    BufferMessage msg_0197_01827, TAG_NONE
    GoTo _PRINT

_ENDED:
    // Wonder Room wore off, and Defense and Sp. Def stats returned to normal!
    BufferMessage msg_0197_01828, TAG_NONE

_PRINT:
    UpdateVar OPCODE_SET, BSCRIPT_VAR_SIDE_EFFECT_FLAGS_INDIRECT, MOVE_SIDE_EFFECT_ON_HIT|MOVE_SUBSCRIPT_PTR_PRINT_MESSAGE_AND_PLAY_ANIMATION
    End
