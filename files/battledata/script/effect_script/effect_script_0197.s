    .include "macros/btlcmd.inc"

    .data

// Secret Power. Its effect waits for Parental Bond's second strike, as the
// reference's script and Pokemon Central (Amorefiliale) have it.
_000:
    GotoIfFirstHitOfParentalBond _FIRST_STRIKE
    CalcCrit 
    CalcDamage 
    GetTerrainSecondaryEffect 
    End 

_FIRST_STRIKE:
    CalcCrit 
    CalcDamage 
    End 
