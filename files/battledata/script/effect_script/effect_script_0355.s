    .include "macros/btlcmd.inc"

    .data

// Thousand Waves, Spirit Shackle, Anchor Shot. The hold comes once the move
// is over (TryHoldAfterHit), as the engine gives it; the script is its bare
// hit.
_000:
    CalcCrit 
    CalcDamage 
    End 
