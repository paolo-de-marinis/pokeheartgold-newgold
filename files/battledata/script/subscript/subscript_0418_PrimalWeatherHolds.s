    .include "macros/btlcmd.inc"

    .data

// A move or an ability tried to change the weather under a strong one, which
// nothing but another strong weather replaces. The reference's subscript 373:
// the strong weather's own animation, the winds having none here, and line.
_000:
    CompareVarToValue OPCODE_FLAG_SET, BSCRIPT_VAR_FIELD_CONDITION, FIELD_CONDITION_HEAVY_RAIN, _HeavyRain
    CompareVarToValue OPCODE_FLAG_SET, BSCRIPT_VAR_FIELD_CONDITION, FIELD_CONDITION_STRONG_WINDS, _StrongWinds
    PlayBattleAnimation BATTLER_CATEGORY_PLAYER, BATTLE_ANIMATION_WEATHER_SUN
    Wait
    // The extremely harsh sunlight was not lessened at all!
    PrintMessage msg_0197_01442, TAG_NONE
    GoTo _End

_HeavyRain:
    PlayBattleAnimation BATTLER_CATEGORY_PLAYER, BATTLE_ANIMATION_WEATHER_RAIN
    Wait
    // There is no relief from this heavy rain!
    PrintMessage msg_0197_01446, TAG_NONE
    GoTo _End

_StrongWinds:
    // The mysterious strong winds blow on regardless!
    PrintMessage msg_0197_01450, TAG_NONE

_End:
    Wait
    WaitButtonABTime 30
    End
