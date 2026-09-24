    .include "macros/btlcmd.inc"

    .data

// Matcha Gotcha drains half the damage on every hit and burns one time in
// five (Pokemon Central, Spruzzate): an effect on hit, subscript 330, which
// rolls the burn itself -- without ON_HIT the side-effect roll came first,
// and the drain waited on it.
_000:
    UpdateVar OPCODE_SET, BSCRIPT_VAR_SIDE_EFFECT_FLAGS_INDIRECT, MOVE_SIDE_EFFECT_ON_HIT|MOVE_SIDE_EFFECT_TO_DEFENDER|MOVE_SUBSCRIPT_PTR_BURN_AND_DRAIN_HEALTH
    CalcCrit 
    CalcDamage 
    End
