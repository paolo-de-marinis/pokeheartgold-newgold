    .include "macros/btlcmd.inc"

    .data

_000:
    SetMultiHit 3, MULTIHIT_TRIPLE_KICK
    UpdateVar OPCODE_SET, BSCRIPT_VAR_AFTER_MOVE_MESSAGE_TYPE, AFTER_MOVE_MESSAGE_MULTI_HIT
    // Each hit is twenty more than the last, 20, 40, 60: CalcMoveDamage, as
    // Triple Kick's ten.
    CalcCrit
    CalcDamage
    End
