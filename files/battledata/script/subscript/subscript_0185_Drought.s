    .include "macros/btlcmd.inc"

    .data

// Drought brings harsh sunlight for five turns, eight with a Heat Rock held
// by the Pokemon with the ability (Pokemon Central, Siccita), where
// HeartGold's lasted for ever; the C sends nothing when that weather is
// already up. The weather the map brought is not written over: the ability
// acts and fails, as in the ninth generation and in the reference's
// subscript. The reference reads the rock from the attacker -- whoever moved
// last, not the Pokemon coming in -- which is not copied.
_000:
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
    CheckItemHoldEffect CHECK_OPCODE_NOT_HAVE, BATTLER_CATEGORY_MSG_BATTLER_TEMP, HOLD_EFFECT_EXTEND_SUN, _Paradox
    GetItemEffectParam BATTLER_CATEGORY_MSG_BATTLER_TEMP, BSCRIPT_VAR_CALC_TEMP
    UpdateVarFromVar OPCODE_ADD, BSCRIPT_VAR_WEATHER_TURNS, BSCRIPT_VAR_CALC_TEMP

_Paradox:
    // The sun is out, so Protosynthesis switches on.
    ActivateParadoxAbility ABILITY_PROTOSYNTHESIS
    End

_MapWeather:
    // But it failed!
    PrintMessage msg_0197_00796, TAG_NONE
    Wait
    WaitButtonABTime 30
    End
