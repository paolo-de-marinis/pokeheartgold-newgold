    .include "macros/btlcmd.inc"

    .data

// Smack Down and Thousand Arrows. Both reach a target in the middle of Fly,
// so the move says so before it asks for the damage; the knocking-down itself
// is subscript 388, after the damage and not through a substitute.
_000:
    UpdateVar OPCODE_SET, BSCRIPT_VAR_SIDE_EFFECT_FLAGS_INDIRECT, MOVE_SIDE_EFFECT_CHECK_SUBSTITUTE|MOVE_SIDE_EFFECT_TO_DEFENDER|MOVE_SUBSCRIPT_PTR_FELL_STRAIGHT_DOWN
    UpdateVar OPCODE_FLAG_ON, BSCRIPT_VAR_BATTLE_STATUS, BATTLE_STATUS_HIT_FLY
    CalcCrit 
    CalcDamage 
    End 
