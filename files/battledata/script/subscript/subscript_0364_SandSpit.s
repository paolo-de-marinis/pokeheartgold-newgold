    .include "macros/btlcmd.inc"

    .data

// Sand Stream's sandstorm never runs out; this one does, so the turns are set
// the way the Sandstorm move sets them rather than by calling Sand Stream.
_000:
    WaitButtonABTime 15
    PlayBattleAnimation BATTLER_CATEGORY_PLAYER, BATTLE_ANIMATION_WEATHER_SAND
    Wait 
    UpdateVar OPCODE_FLAG_OFF, BSCRIPT_VAR_FIELD_CONDITION, FIELD_CONDITION_WEATHER
    UpdateVar OPCODE_FLAG_ON, BSCRIPT_VAR_FIELD_CONDITION, FIELD_CONDITION_SANDSTORM
    UpdateVar OPCODE_SET, BSCRIPT_VAR_WEATHER_TURNS, 5
    // A sandstorm kicked up!
    PrintMessage msg_0197_00695, TAG_NONE
    Wait 
    WaitButtonABTime 30
    End 
