    .include "macros/btlcmd.inc"

    .data

// Incinerate: damage, and the Berry the target was holding goes up with it.
// Knock Off hands its work to a subscript the same way.
_000:
    UpdateVar OPCODE_SET, BSCRIPT_VAR_SIDE_EFFECT_FLAGS_INDIRECT, MOVE_SIDE_EFFECT_ON_HIT|MOVE_SUBSCRIPT_PTR_INCINERATE
    CalcCrit
    CalcDamage
    End
