    .include "macros/btlcmd.inc"

    .data

// Natural Gift, the engine's script. The Berry's power and type, and the
// failure without a Berry the move can use, come before the move
// (TryNaturalGift in ov12_0224C38C), which is why nothing jumps to _008 any
// more; the Berry goes once the move is over (ov12_0224E1BC).
_000:
    CalcCrit 
    CalcDamage 
    End 

_008:
    UpdateVar OPCODE_FLAG_ON, BSCRIPT_VAR_MOVE_STATUS_FLAGS, MOVE_STATUS_FAILED
    End 
