    .include "macros/btlcmd.inc"

    .data

// Chloroblast. Half the user's own maximum HP, not a share of the damage,
// once the move is over (TryRecoil); Reckless pays for it in the damage
// calculation, as for the other recoil moves.
_000:
    CalcCrit 
    CalcDamage 
    End 
