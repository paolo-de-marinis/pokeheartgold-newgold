    .include "macros/btlcmd.inc"

    .data

// Teraform Zero clearing the field, which the reference has no script for.
// Each weather goes with its own closing line, as the later games show it;
// fog, which they have not got, with the line for weather whose effects are
// gone. The sun takes Protosynthesis with it, and the ground's own subscript
// ends whatever terrain is down, Quark Drive with the electricity.
_000:
    CompareVarToValue OPCODE_FLAG_SET, BSCRIPT_VAR_FIELD_CONDITION, FIELD_CONDITION_RAIN_ALL, _Rain
    CompareVarToValue OPCODE_FLAG_SET, BSCRIPT_VAR_FIELD_CONDITION, FIELD_CONDITION_SANDSTORM_ALL, _Sandstorm
    CompareVarToValue OPCODE_FLAG_SET, BSCRIPT_VAR_FIELD_CONDITION, FIELD_CONDITION_SUN_ALL, _Sun
    CompareVarToValue OPCODE_FLAG_SET, BSCRIPT_VAR_FIELD_CONDITION, FIELD_CONDITION_HAIL_ALL, _Hail
    CompareVarToValue OPCODE_FLAG_SET, BSCRIPT_VAR_FIELD_CONDITION, FIELD_CONDITION_SNOW_ALL, _Snow
    CompareVarToValue OPCODE_FLAG_SET, BSCRIPT_VAR_FIELD_CONDITION, FIELD_CONDITION_FOG, _Fog
    GoTo _Terrain

_Rain:
    // The rain stopped.
    PrintMessage msg_0197_00803, TAG_NONE
    GoTo _WeatherGone

_Sandstorm:
    // The sandstorm subsided.
    PrintMessage msg_0197_00806, TAG_NONE
    GoTo _WeatherGone

_Sun:
    // The harsh sunlight faded.
    PrintMessage msg_0197_00809, TAG_NONE
    GoTo _WeatherGone

_Hail:
    // The hail stopped.
    PrintMessage msg_0197_00812, TAG_NONE
    GoTo _WeatherGone

_Snow:
    // The snow stopped.
    PrintMessage msg_0197_01440, TAG_NONE
    GoTo _WeatherGone

_Fog:
    // The effects of the weather disappeared.
    PrintMessage msg_0197_01470, TAG_NONE

_WeatherGone:
    Wait
    WaitButtonABTime 30
    UpdateVar OPCODE_FLAG_OFF, BSCRIPT_VAR_FIELD_CONDITION, FIELD_CONDITION_WEATHER
    ResetParadoxAbility ABILITY_PROTOSYNTHESIS

_Terrain:
    Call BATTLE_SUBSCRIPT_HANDLE_TERRAIN_END
    End
