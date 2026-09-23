    .include "macros/btlcmd.inc"

    .data

// Salt Cure hurts and salts its target, an added effect at a chance of 100
// that Sheer Force trades for power and a Covert Cloak or Shield Dust turns
// away, and that a substitute keeps off (Pokemon Central, Sotto Sale):
// subscript 449, as the rolled side effects run theirs.
_000:
    UpdateVar OPCODE_SET, BSCRIPT_VAR_SIDE_EFFECT_FLAGS_INDIRECT, MOVE_SIDE_EFFECT_TO_DEFENDER|MOVE_SUBSCRIPT_PTR_SALT_CURE
    CalcCrit
    CalcDamage
    End
