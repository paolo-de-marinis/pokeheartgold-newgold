    .include "macros/btlcmd.inc"

    .data

// Flame Charge: the charge leaves the user faster than it was.
_000:
    UpdateVar OPCODE_SET, BSCRIPT_VAR_SIDE_EFFECT_FLAGS_INDIRECT, MOVE_SIDE_EFFECT_TO_ATTACKER|MOVE_SUBSCRIPT_PTR_SPEED_UP_1_STAGE
    CalcCrit 
    CalcDamage 
    End 
