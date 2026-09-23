    .include "macros/btlcmd.inc"

    .data

// Mortal Spin. Subscript 403 poisons the target and clears the user's side.
_000:
    UpdateVar OPCODE_SET, BSCRIPT_VAR_SIDE_EFFECT_FLAGS_INDIRECT, MOVE_SIDE_EFFECT_ON_HIT|MOVE_SIDE_EFFECT_TO_DEFENDER|MOVE_SUBSCRIPT_PTR_MORTAL_SPIN
    CalcCrit 
    CalcDamage 
    End 
