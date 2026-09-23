    .include "macros/btlcmd.inc"

    .data

// Magic Room takes the effect out of every held item on the field for five
// turns; used again while it lasts, it ends it (Pokemon Central, Magicozona).
// SetMoveConditionFlag puts it up or takes it down and leaves in CALC_TEMP
// whether it is up now.
_000:
    SetMoveConditionFlag MOVE_MAGIC_ROOM, BATTLER_CATEGORY_ATTACKER
    CompareVarToValue OPCODE_EQU, BSCRIPT_VAR_CALC_TEMP, 0, _ENDED
    // It created a bizarre area in which Pokémon's held items lose their effects!
    BufferMessage msg_0197_01829, TAG_NONE
    GoTo _PRINT

_ENDED:
    // Magic Room wore off, and held items' effects returned to normal!
    BufferMessage msg_0197_01830, TAG_NONE

_PRINT:
    UpdateVar OPCODE_SET, BSCRIPT_VAR_SIDE_EFFECT_FLAGS_INDIRECT, MOVE_SIDE_EFFECT_ON_HIT|MOVE_SUBSCRIPT_PTR_PRINT_MESSAGE_AND_PLAY_ANIMATION
    End
