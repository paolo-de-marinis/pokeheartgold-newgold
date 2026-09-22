    .include "macros/btlcmd.inc"

    .data

// Ceaseless Edge. Stone Axe with spikes instead of stones.
_000:
    UpdateVar OPCODE_SET, BSCRIPT_VAR_SIDE_EFFECT_FLAGS_INDIRECT, MOVE_SIDE_EFFECT_ON_HIT|MOVE_SUBSCRIPT_PTR_SET_SPIKES
    CalcCrit 
    CalcDamage 
    End 
