    .include "macros/btlcmd.inc"

    .data

// Natural Gift. With Parental Bond both strikes have the Berry's power and
// type (Pokemon Central, Amorefiliale), and the Berry is spent with the first,
// which may be the last: the second keeps the power and type the first worked
// out (ctx->movePower and ctx->moveType last the whole move).
_000:
    GotoIfSecondHitOfParentalBond _SECOND_STRIKE
    CalcNaturalGiftParams _006
    CalcCrit 
    CalcDamage 
    RemoveItem BATTLER_CATEGORY_ATTACKER
    End 

_SECOND_STRIKE:
    CalcCrit 
    CalcDamage 
    End 

_006:
    UpdateVar OPCODE_FLAG_ON, BSCRIPT_VAR_MOVE_STATUS_FLAGS, MOVE_STATUS_FAILED
    End 
