    .include "macros/btlcmd.inc"

    .data

// Stone Axe. ON_HIT is what makes the stones wait for the damage: the side
// effect only runs when the move actually connected, so a miss scatters
// nothing.
_000:
    UpdateVar OPCODE_SET, BSCRIPT_VAR_SIDE_EFFECT_FLAGS_INDIRECT, MOVE_SIDE_EFFECT_ON_HIT|MOVE_SUBSCRIPT_PTR_SET_STEALTH_ROCK
    CalcCrit 
    CalcDamage 
    End 
