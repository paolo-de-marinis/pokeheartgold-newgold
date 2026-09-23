    .include "macros/btlcmd.inc"

    .data

// Rapid Spin. What it does besides its damage is an additional effect, rolled
// against its chance of 100 (Pokemon Central, Rapigiro: the Speed rise from
// Generation VIII, the clearing too from Generation IX), so Sheer Force boosts
// the move and gives up both. A Covert Cloak on the target stops the clearing,
// which subscript 115 asks it for, and not the user's own rise. Subscript 115
// raises and then clears.
_000:
    UpdateVar OPCODE_SET, BSCRIPT_VAR_SIDE_EFFECT_FLAGS_INDIRECT, MOVE_SIDE_EFFECT_TO_ATTACKER|MOVE_SUBSCRIPT_PTR_RAPID_SPIN
    CalcCrit 
    CalcDamage 
    End 
