    .include "macros/btlcmd.inc"

    .data

// SNOW_WARNING_GENERATION is GEN_LATEST in the reference's config, so Snow
// Warning summons snow rather than hail, and for five turns rather than for
// ever. The weather itself is HANDLE_SNOW_TEMPORARY, which is the subscript
// the reference calls here too.
//
// Three things the reference's version has that are not here:
//
//  - PlayBattleAnimation BATTLE_ANIMATION_WEATHER_SNOW. That is entry 54 of
//    the animation table the reference added to; this game's table stops
//    earlier, and asking for it reads past the end. The snow is announced by
//    its message alone, the way the terrains are.
//  - The three primal-weather checks and the PREVENT_CHANGING_WEATHER they
//    lead to. This game has no extremely harsh sunlight, heavy rain or strong
//    winds for them to be prevented by.
//  - The FIELD_CONDITION_OVERWORLD_WEATHER_ANY check, which in the reference
//    means "the map brought this weather, leave it alone". It reads the four
//    permanent weather bits, and in this game those bits do not mean that:
//    Drizzle, Drought and Sand Stream still set them themselves, the way
//    HeartGold's weather abilities always have. Keeping the check would make
//    Snow Warning fail after any of those three had acted. It belongs here
//    again when the other three abilities take the temporary bits as well.

_000:
    CompareVarToValue OPCODE_FLAG_SET, BSCRIPT_VAR_FIELD_CONDITION, FIELD_CONDITION_SNOW_ALL, _025
    AbilityPopup BATTLER_CATEGORY_MSG_BATTLER_TEMP, -1
    Call BATTLE_SUBSCRIPT_HANDLE_SNOW_TEMPORARY

_025:
    End
