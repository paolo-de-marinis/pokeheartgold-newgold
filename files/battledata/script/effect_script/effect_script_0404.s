    .include "macros/btlcmd.inc"

    .data

// Chloroblast. Half the user's own maximum HP, not a share of the damage,
// once the move is over and only if it hit (TryRecoil); Rock Head and Magic
// Guard spare the user, and Reckless does not boost it (Pokemon Central,
// Clorofillaser).
_000:
    CalcCrit 
    CalcDamage 
    End 
