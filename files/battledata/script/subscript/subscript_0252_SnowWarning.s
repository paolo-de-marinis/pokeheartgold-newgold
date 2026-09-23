    .include "macros/btlcmd.inc"

    .data

// SNOW_WARNING_GENERATION is GEN_LATEST in the reference's config, so Snow
// Warning summons snow rather than hail, and for five turns rather than for
// ever. The weather itself is HANDLE_SNOW_TEMPORARY, which is the subscript
// the reference calls here too.
//
// Two things the reference's version has that are not here:
//
//  - PlayBattleAnimation BATTLE_ANIMATION_WEATHER_SNOW. That is entry 54 of
//    the animation table the reference added to; this game's table stops
//    earlier, and asking for it reads past the end. The snow is announced by
//    its message alone, the way the terrains are.
//  - The three primal-weather checks and the PREVENT_CHANGING_WEATHER they
//    lead to. This game has no extremely harsh sunlight, heavy rain or strong
//    winds for them to be prevented by.
//
// The weather the map brought is not written over: the ability acts and
// fails, as in the ninth generation (Pokemon Central, Scendineve) and in the
// reference. Only the map sets a permanent weather bit now that Drizzle,
// Drought and Sand Stream lay theirs for five turns.

_000:
    CompareVarToValue OPCODE_FLAG_SET, BSCRIPT_VAR_FIELD_CONDITION, FIELD_CONDITION_SNOW_ALL, _025
    AbilityPopup BATTLER_CATEGORY_MSG_BATTLER_TEMP, -1
    CompareVarToValue OPCODE_FLAG_SET, BSCRIPT_VAR_FIELD_CONDITION, FIELD_CONDITION_OVERWORLD_WEATHER_ANY, _MapWeather
    Call BATTLE_SUBSCRIPT_HANDLE_SNOW_TEMPORARY

_025:
    End

_MapWeather:
    // But it failed!
    PrintMessage msg_0197_00796, TAG_NONE
    Wait
    WaitButtonABTime 30
    End
