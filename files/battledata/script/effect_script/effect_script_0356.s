    .include "macros/btlcmd.inc"

    .data

// Jaw Lock. Both Pokemon are held once the move is over
// (TryAdditionalMoveEffect), as the engine holds them; the script is its
// bare hit.
_000:
    CalcCrit 
    CalcDamage 
    End 
