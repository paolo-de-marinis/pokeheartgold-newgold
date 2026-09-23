    .include "macros/btlcmd.inc"

    .data

// Syrup Bomb hurts and covers its target in syrup, an added effect at the
// record's chance of 100 that Sheer Force trades for power and Shield Dust or
// a Covert Cloak turns away (Pokemon Central, Bomba Sciroppata): subscript
// 451, as the rolled side effects run theirs. Bulletproof keeps the whole
// bomb off (sBallAndBombMoves).
_000:
    UpdateVar OPCODE_SET, BSCRIPT_VAR_SIDE_EFFECT_FLAGS_INDIRECT, MOVE_SIDE_EFFECT_TO_DEFENDER|MOVE_SUBSCRIPT_PTR_SYRUP_BOMB
    CalcCrit
    CalcDamage
    End
