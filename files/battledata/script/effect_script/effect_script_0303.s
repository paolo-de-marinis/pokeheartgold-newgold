    .include "macros/btlcmd.inc"

    .data

_000:
    SetMultiHit 3, MULTIHIT_TRIPLE_KICK
    UpdateVar OPCODE_SET, BSCRIPT_VAR_AFTER_MOVE_MESSAGE_TYPE, AFTER_MOVE_MESSAGE_MULTI_HIT
    // Each hit is twenty more than the last: 20, 40, 60. The reference works
    // it out in CalcBaseDamage as 20 * (4 - hits left); this game's Triple
    // Kick adds its ten a hit here, and so does this.
    UpdateVar OPCODE_ADD, BSCRIPT_VAR_MOVE_POWER, 20
    CalcCrit
    CalcDamage
    End
