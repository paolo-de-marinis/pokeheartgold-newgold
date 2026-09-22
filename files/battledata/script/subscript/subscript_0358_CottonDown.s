    .include "macros/btlcmd.inc"

    .data

// Everything else on the field slows down, allies included, in speed order.
// The holder stands in as the attacker the way Intimidate's walk does, so the
// drop is credited to it and asks its Mist and Clear Body rather than the
// real attacker's.
_000:
    WaitButtonABTime 15
    UpdateVarFromVar OPCODE_SET, BSCRIPT_VAR_LAST_BATTLER_ID, BSCRIPT_VAR_BATTLER_ATTACKER
    UpdateVarFromVar OPCODE_SET, BSCRIPT_VAR_BATTLER_ATTACKER, BSCRIPT_VAR_BATTLER_TARGET

_015:
    GetMonByCottonDownOrder _040
    UpdateVar OPCODE_SET, BSCRIPT_VAR_SIDE_EFFECT_PARAM, MOVE_SUBSCRIPT_PTR_SPEED_DOWN_1_STAGE
    UpdateVar OPCODE_SET, BSCRIPT_VAR_SIDE_EFFECT_TYPE, SIDE_EFFECT_TYPE_ABILITY
    Call BATTLE_SUBSCRIPT_UPDATE_STAT_STAGE
    GoTo _015

_040:
    UpdateVarFromVar OPCODE_SET, BSCRIPT_VAR_BATTLER_ATTACKER, BSCRIPT_VAR_LAST_BATTLER_ID
    End 
