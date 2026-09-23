    .include "macros/btlcmd.inc"

    .data

// Chilly Reception brings snow for five turns, eight with an Icy Rock, and
// then its user goes back and another comes in; already snowing, it still
// goes back, and with nobody to come in it only brings the snow (Pokemon
// Central, Freddura). The snow is Snowscape's (effect script 324), a strong
// weather holding as it holds against Snowscape; the going back is
// Teleport's in a trainer battle (effect script 153).
_000:
    // {0} is preparing to tell a chillingly bad joke!
    PrintMessage msg_0197_01870, TAG_NICKNAME, BATTLER_CATEGORY_ATTACKER
    Wait
    WaitButtonABTime 30
    Call BATTLE_SUBSCRIPT_ATTACK_MESSAGE_AND_ANIMATION
    CompareVarToValue OPCODE_FLAG_SET, BSCRIPT_VAR_FIELD_CONDITION, FIELD_CONDITION_PRIMAL_WEATHER, _PRIMAL_WEATHER
    CompareVarToValue OPCODE_FLAG_SET, BSCRIPT_VAR_FIELD_CONDITION, FIELD_CONDITION_SNOW_TEMP, _SWITCH
    Call BATTLE_SUBSCRIPT_HANDLE_SNOW_TEMPORARY
    GoTo _SWITCH

_PRIMAL_WEATHER:
    Call BATTLE_SUBSCRIPT_PRIMAL_WEATHER_HOLDS

_SWITCH:
    TryReplaceFaintedMon BATTLER_CATEGORY_ATTACKER, TRUE, _END
    TryRestoreStatusOnSwitch BATTLER_CATEGORY_ATTACKER, _SWITCH_OUT
    UpdateMonData OPCODE_SET, BATTLER_CATEGORY_ATTACKER, BMON_DATA_STATUS, STATUS_NONE

_SWITCH_OUT:
    DeletePokemon BATTLER_CATEGORY_ATTACKER
    Wait
    HealthbarSlideOut BATTLER_CATEGORY_ATTACKER
    Wait
    UpdateVar OPCODE_FLAG_ON, BSCRIPT_VAR_BATTLE_STATUS_2, BATTLE_STATUS2_UTURN
    UpdateVar OPCODE_FLAG_OFF, BSCRIPT_VAR_BATTLE_STATUS, BATTLE_STATUS_SYNCRONIZE
    UpdateVar OPCODE_SET, BSCRIPT_VAR_ATTACKER_SELF_TURN_STATUS_FLAGS, SELF_TURN_FLAG_CLEAR
    GoToSubscript BATTLE_SUBSCRIPT_SHOW_PARTY_LIST

_END:
    End
