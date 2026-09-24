    .include "macros/btlcmd.inc"

    .data

// Natural Gift. The Berry gives the move its power and type, on both of
// Parental Bond's strikes (Pokemon Central, Amorefiliale), and is spent once
// the move is over (ov12_0224E1BC).
_000:
    CalcNaturalGiftParams _006
    CalcCrit 
    CalcDamage 
    End 

_006:
    UpdateVar OPCODE_FLAG_ON, BSCRIPT_VAR_MOVE_STATUS_FLAGS, MOVE_STATUS_FAILED
    End 
