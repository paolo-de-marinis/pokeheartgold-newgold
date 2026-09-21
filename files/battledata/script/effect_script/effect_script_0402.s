    .include "macros/btlcmd.inc"

    .data

_000:
    SetMoveConditionFlag MOVE_THROAT_CHOP, BATTLER_CATEGORY_DEFENDER
    CalcCrit 
    CalcDamage 
    End 
    
