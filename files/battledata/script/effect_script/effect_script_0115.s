    .include "macros/btlcmd.inc"

    .data

_000:
    // Nothing but another strong weather replaces one: under Desolate Land,
    // Primordial Sea or Delta Stream the move is spent saying so.
    CompareVarToValue OPCODE_FLAG_SET, BSCRIPT_VAR_FIELD_CONDITION, FIELD_CONDITION_PRIMAL_WEATHER, _PrimalWeather
    // Nor is the weather the map brought written over: the move fails, as
    // from the ninth generation (Pokemon Central, Terrempesta, Pioggiadanza).
    CompareVarToValue OPCODE_FLAG_SET, BSCRIPT_VAR_FIELD_CONDITION, FIELD_CONDITION_OVERWORLD_WEATHER_ANY, _036
    CompareVarToValue OPCODE_FLAG_SET, BSCRIPT_VAR_FIELD_CONDITION, FIELD_CONDITION_SANDSTORM_ALL, _036
    // A sandstorm kicked up!
    BufferMessage msg_0197_00695, TAG_NONE
    UpdateVar OPCODE_FLAG_OFF, BSCRIPT_VAR_FIELD_CONDITION, FIELD_CONDITION_WEATHER
    UpdateVar OPCODE_FLAG_ON, BSCRIPT_VAR_FIELD_CONDITION, FIELD_CONDITION_SANDSTORM
    UpdateVar OPCODE_SET, BSCRIPT_VAR_WEATHER_TURNS, 5
    UpdateVar OPCODE_SET, BSCRIPT_VAR_SIDE_EFFECT_FLAGS_INDIRECT, MOVE_SIDE_EFFECT_ON_HIT|MOVE_SUBSCRIPT_PTR_WEATHER_START
    CheckItemHoldEffect CHECK_OPCODE_NOT_HAVE, BATTLER_CATEGORY_ATTACKER, HOLD_EFFECT_EXTEND_SANDSTORM, _035
    GetItemEffectParam BATTLER_CATEGORY_ATTACKER, BSCRIPT_VAR_CALC_TEMP
    UpdateVarFromVar OPCODE_ADD, BSCRIPT_VAR_WEATHER_TURNS, BSCRIPT_VAR_CALC_TEMP

_035:
    End 

_036:
    UpdateVar OPCODE_FLAG_ON, BSCRIPT_VAR_MOVE_STATUS_FLAGS, MOVE_STATUS_FAILED
    End 

_PrimalWeather:
    PrintAttackMessage
    Wait
    WaitButtonABTime 30
    Call BATTLE_SUBSCRIPT_PRIMAL_WEATHER_HOLDS
    UpdateVar OPCODE_FLAG_ON, BSCRIPT_VAR_MOVE_STATUS_FLAGS, MOVE_STATUS_NO_MORE_WORK
    End
