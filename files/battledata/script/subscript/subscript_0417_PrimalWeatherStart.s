    .include "macros/btlcmd.inc"

    .data

// Desolate Land, Primordial Sea or Delta Stream has raised its weather, which
// the C has already put on the field in place of any other. The reference's
// subscripts 365 to 367, without the ability popup this game has not got and
// without their refusal under the field's own weather. The winds have no
// weather animation here, as the snow has none.
_000:
    CompareVarToValue OPCODE_FLAG_SET, BSCRIPT_VAR_FIELD_CONDITION, FIELD_CONDITION_HEAVY_RAIN, _HeavyRain
    CompareVarToValue OPCODE_FLAG_SET, BSCRIPT_VAR_FIELD_CONDITION, FIELD_CONDITION_STRONG_WINDS, _StrongWinds
    PlayBattleAnimation BATTLER_CATEGORY_PLAYER, BATTLE_ANIMATION_WEATHER_SUN
    Wait
    // The sunlight turned extremely harsh!
    PrintMessage msg_0197_01441, TAG_NONE
    Wait
    WaitButtonABTime 30
    // The sun is out, so Protosynthesis switches on.
    ActivateParadoxAbility ABILITY_PROTOSYNTHESIS
    End

_HeavyRain:
    PlayBattleAnimation BATTLER_CATEGORY_PLAYER, BATTLE_ANIMATION_WEATHER_RAIN
    Wait
    // A heavy rain began to fall!
    PrintMessage msg_0197_01445, TAG_NONE
    GoTo _SunGone

_StrongWinds:
    // Mysterious strong winds are protecting Flying-type Pokémon!
    PrintMessage msg_0197_01449, TAG_NONE

_SunGone:
    Wait
    WaitButtonABTime 30
    // Whatever sun there was has gone, and Protosynthesis with it.
    ResetParadoxAbility ABILITY_PROTOSYNTHESIS
    End
