    .include "macros/btlcmd.inc"

    .data

_000:
    PrintAttackMessage 
    Wait 
    WaitButtonABTime 30
    // Nothing but another strong weather replaces one.
    CompareVarToValue OPCODE_FLAG_SET, BSCRIPT_VAR_FIELD_CONDITION, FIELD_CONDITION_PRIMAL_WEATHER, _PrimalWeather
    Call BATTLE_SUBSCRIPT_HANDLE_SNOW_TEMPORARY
    End 

_PrimalWeather:
    Call BATTLE_SUBSCRIPT_PRIMAL_WEATHER_HOLDS
    UpdateVar OPCODE_FLAG_ON, BSCRIPT_VAR_MOVE_STATUS_FLAGS, MOVE_STATUS_NO_MORE_WORK
    End
