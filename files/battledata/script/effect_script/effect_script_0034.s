    .include "macros/btlcmd.inc"

    .data

// Pay Day. Parental Bond's second strike scatters no coins (Pokemon Central,
// Amorefiliale). The reference's script branches the other way round and so
// scatters them only on a first strike of Parental Bond, never without it.
_000:
    GotoIfSecondHitOfParentalBond _NO_COINS
    UpdateVar OPCODE_SET, BSCRIPT_VAR_SIDE_EFFECT_FLAGS_INDIRECT, MOVE_SIDE_EFFECT_CHECK_SUBSTITUTE|MOVE_SIDE_EFFECT_TO_DEFENDER|MOVE_SUBSCRIPT_PTR_PAY_DAY

_NO_COINS:
    CalcCrit 
    CalcDamage 
    End 
