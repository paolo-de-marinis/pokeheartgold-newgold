    .include "macros/btlcmd.inc"

    .data

// Storm Throw, Frost Breath, Wicked Blow, Flower Trick. The reference has no
// script for this at all: it reads the effect inside its critical hit roll
// and skips the roll. Here the script asks for a critical stage no ladder
// reaches, which CalcCrit reads as the same thing -- the armours and Lucky
// Chant still refuse it.
_000:
    UpdateVar OPCODE_SET, BSCRIPT_VAR_CRITICAL_BOOSTS, CRITICAL_STAGE_ALWAYS
    CalcCrit 
    CalcDamage 
    End 
