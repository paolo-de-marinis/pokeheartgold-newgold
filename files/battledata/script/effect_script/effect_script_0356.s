    .include "macros/btlcmd.inc"

    .data

// Jaw Lock. As above, but the subscript traps both sides rather than one.
_000:
    UpdateVar OPCODE_SET, BSCRIPT_VAR_SIDE_EFFECT_FLAGS_INDIRECT, MOVE_SIDE_EFFECT_CHECK_HP|MOVE_SIDE_EFFECT_TO_DEFENDER|MOVE_SUBSCRIPT_PTR_JAW_LOCK
    CalcCrit 
    CalcDamage 
    End 
