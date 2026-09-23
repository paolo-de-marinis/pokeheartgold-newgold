    .include "macros/btlcmd.inc"

    .data

// SNOW_WARNING_GENERATION is GEN_LATEST in the reference's config, so Snow
// Warning summons snow rather than hail, for five turns, eight with an Icy
// Rock held by the Pokemon with the ability (Pokemon Central, Scendineve).
// The reference calls HANDLE_SNOW_TEMPORARY here, which reads the rock from
// the attacker -- whoever moved last, not the Pokemon coming in -- so the
// snow is laid here as that subscript lays it, with the rock read from the
// Pokemon with the ability; Snowscape keeps the subscript.
//
// PlayBattleAnimation BATTLE_ANIMATION_WEATHER_SNOW is not here: that is entry
// 54 of the animation table the reference added to; this game's table stops
// earlier, and asking for it reads past the end. The snow is announced by its
// message alone, the way the terrains are. The C sends PRIMAL_WEATHER_HOLDS
// instead of this under a strong weather, as for the other weather abilities.
//
// The weather the map brought is not written over: the ability acts and
// fails, as in the ninth generation (Pokemon Central, Scendineve) and in the
// reference. Only the map sets a permanent weather bit now that Drizzle,
// Drought and Sand Stream lay theirs for five turns.

_000:
    CompareVarToValue OPCODE_FLAG_SET, BSCRIPT_VAR_FIELD_CONDITION, FIELD_CONDITION_SNOW_ALL, _025
    AbilityPopup BATTLER_CATEGORY_MSG_BATTLER_TEMP, -1
    CompareVarToValue OPCODE_FLAG_SET, BSCRIPT_VAR_FIELD_CONDITION, FIELD_CONDITION_OVERWORLD_WEATHER_ANY, _MapWeather
    // It started to snow!
    PrintMessage msg_0197_01439, TAG_NONE
    Wait
    WaitButtonABTime 30
    UpdateVar OPCODE_FLAG_OFF, BSCRIPT_VAR_FIELD_CONDITION, FIELD_CONDITION_WEATHER
    UpdateVar OPCODE_FLAG_ON, BSCRIPT_VAR_FIELD_CONDITION, FIELD_CONDITION_SNOW_TEMP
    UpdateVar OPCODE_SET, BSCRIPT_VAR_WEATHER_TURNS, 5
    CheckItemHoldEffect CHECK_OPCODE_NOT_HAVE, BATTLER_CATEGORY_MSG_BATTLER_TEMP, HOLD_EFFECT_EXTEND_HAIL, _Paradox
    GetItemEffectParam BATTLER_CATEGORY_MSG_BATTLER_TEMP, BSCRIPT_VAR_CALC_TEMP
    UpdateVarFromVar OPCODE_ADD, BSCRIPT_VAR_WEATHER_TURNS, BSCRIPT_VAR_CALC_TEMP

_Paradox:
    // The sun is gone, if it was out.
    ResetParadoxAbility ABILITY_PROTOSYNTHESIS
    ActivateParadoxAbility ABILITY_PROTOSYNTHESIS

_025:
    End

_MapWeather:
    // But it failed!
    PrintMessage msg_0197_00796, TAG_NONE
    Wait
    WaitButtonABTime 30
    End
