    .include "macros/btlcmd.inc"

    .data

// Triple Arrows: a high critical-hit ratio, and two added effects that
// subscript 453 rolls apart, the Defense and the flinch (Pokemon Central,
// Triplodardo).
_000:
    UpdateVar OPCODE_ADD, BSCRIPT_VAR_CRITICAL_BOOSTS, 1
    UpdateVar OPCODE_SET, BSCRIPT_VAR_SIDE_EFFECT_FLAGS_INDIRECT, MOVE_SIDE_EFFECT_TO_DEFENDER|MOVE_SUBSCRIPT_PTR_TRIPLE_ARROWS
    CalcCrit
    CalcDamage
    End
