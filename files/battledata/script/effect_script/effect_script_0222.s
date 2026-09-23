    .include "macros/btlcmd.inc"

    .data

// Natural Gift. With Parental Bond the Berry is spent on the second strike,
// so both strike with its power and type (Pokemon Central, Amorefiliale).
_000:
    CalcNaturalGiftParams _006
    CalcCrit 
    CalcDamage 
    GotoIfFirstHitOfParentalBond _KEEP_BERRY
    RemoveItem BATTLER_CATEGORY_ATTACKER

_KEEP_BERRY:
    End 

_006:
    UpdateVar OPCODE_FLAG_ON, BSCRIPT_VAR_MOVE_STATUS_FLAGS, MOVE_STATUS_FAILED
    End 
