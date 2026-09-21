    .include "macros/btlcmd.inc"

    .data

// Toxic Thread: poisons and slows in one move.
_000:
    Call BATTLE_SUBSCRIPT_POISON
    UpdateVar OPCODE_SET, BSCRIPT_VAR_SIDE_EFFECT_PARAM, MOVE_SUBSCRIPT_PTR_SPEED_DOWN_1_STAGE
    Call BATTLE_SUBSCRIPT_UPDATE_STAT_STAGE
    End 
