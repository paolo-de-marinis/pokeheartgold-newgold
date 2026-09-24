    .include "macros/btlcmd.inc"

    .data

// Ceaseless Edge. The spikes go down once the move is over (TryAdditionalMoveEffect),
// as the engine lays them; the script is its bare hit.
_000:
    CalcCrit 
    CalcDamage 
    End 
