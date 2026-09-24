    .include "macros/btlcmd.inc"

    .data

// Mortal Spin. Each target it hits is poisoned as by Poison Sting, an
// additional effect; the user's side is cleared once the move is over
// (TryAdditionalMoveEffect), as the engine does both.
_000:
    UpdateVar OPCODE_SET, BSCRIPT_VAR_SIDE_EFFECT_FLAGS_INDIRECT, MOVE_SIDE_EFFECT_TO_DEFENDER|MOVE_SUBSCRIPT_PTR_POISON
    CalcCrit 
    CalcDamage 
    End 
