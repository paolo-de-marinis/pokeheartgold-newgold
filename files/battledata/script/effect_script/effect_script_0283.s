    .include "macros/btlcmd.inc"

    .data

// Fell Stinger. The Attack rises once the move is over, if the sting felled
// the target (TryAdditionalMoveEffect), as the engine raises it; the script
// is its bare hit.
_000:
    CalcCrit 
    CalcDamage 
    End 
