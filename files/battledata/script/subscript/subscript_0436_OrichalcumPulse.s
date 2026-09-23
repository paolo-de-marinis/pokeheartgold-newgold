    .include "macros/btlcmd.inc"

    .data

// Orichalcum Pulse walking in turns the sunlight harsh for five turns, eight
// with a Heat Rock, and says what the sun does for its pulse; already in the
// sun, it only basks (Pokemon Central, Ritmo d'Oricalco; the reference's
// subscript 487). Under a strong weather the C sends PRIMAL_WEATHER_HOLDS
// instead, as for the other weather abilities. It cannot write over the
// weather the map brought (Pokemon Central), and fails there, as in the
// reference.
_000:
    AbilityPopup BATTLER_CATEGORY_MSG_TEMP, -1
    CompareVarToValue OPCODE_FLAG_SET, BSCRIPT_VAR_FIELD_CONDITION, FIELD_CONDITION_SUN_ALL, _AlreadySunny
    CompareVarToValue OPCODE_FLAG_SET, BSCRIPT_VAR_FIELD_CONDITION, FIELD_CONDITION_OVERWORLD_WEATHER_ANY, _MapWeather
    PlayBattleAnimation BATTLER_CATEGORY_PLAYER, BATTLE_ANIMATION_WEATHER_SUN
    Wait
    // The sunlight turned harsh!
    PrintMessage msg_0197_00698, TAG_NONE
    Wait
    WaitButtonABTime 30
    UpdateVar OPCODE_FLAG_OFF, BSCRIPT_VAR_FIELD_CONDITION, FIELD_CONDITION_WEATHER
    UpdateVar OPCODE_FLAG_ON, BSCRIPT_VAR_FIELD_CONDITION, FIELD_CONDITION_SUN
    UpdateVar OPCODE_SET, BSCRIPT_VAR_WEATHER_TURNS, 5
    CheckItemHoldEffect CHECK_OPCODE_NOT_HAVE, BATTLER_CATEGORY_MSG_TEMP, HOLD_EFFECT_EXTEND_SUN, _Pulse
    GetItemEffectParam BATTLER_CATEGORY_MSG_TEMP, BSCRIPT_VAR_CALC_TEMP
    UpdateVarFromVar OPCODE_ADD, BSCRIPT_VAR_WEATHER_TURNS, BSCRIPT_VAR_CALC_TEMP

_Pulse:
    // {0} turned the sunlight harsh, sending its ancient pulse into a frenzy!
    PrintMessage msg_0197_01695, TAG_NICKNAME, BATTLER_CATEGORY_MSG_TEMP
    Wait
    WaitButtonABTime 30
    // The sun is out, so Protosynthesis switches on.
    ActivateParadoxAbility ABILITY_PROTOSYNTHESIS
    End

_AlreadySunny:
    Wait
    // {0} basked in the sunlight, sending its ancient pulse into a frenzy!
    PrintMessage msg_0197_01698, TAG_NICKNAME, BATTLER_CATEGORY_MSG_TEMP
    Wait
    WaitButtonABTime 30
    End

_MapWeather:
    // But it failed!
    PrintMessage msg_0197_00796, TAG_NONE
    Wait
    WaitButtonABTime 30
    End
