    .include "macros/btlcmd.inc"

    .data

// Sand Spit kicks up a sandstorm for five turns, eight with a Smooth Rock held
// by the Pokemon that was hit (Pokemon Central, Sputasabbia, Roccialiscia). The
// reference calls Sand Stream's subscript, whose rock is read from the
// attacker -- here the Pokemon that hit it, not the holder -- which is not
// copied; nor is Sand Stream's refusal of the map's weather, which Pokemon
// Central does not give Sand Spit.
_000:
    WaitButtonABTime 15
    PlayBattleAnimation BATTLER_CATEGORY_PLAYER, BATTLE_ANIMATION_WEATHER_SAND
    Wait 
    UpdateVar OPCODE_FLAG_OFF, BSCRIPT_VAR_FIELD_CONDITION, FIELD_CONDITION_WEATHER
    UpdateVar OPCODE_FLAG_ON, BSCRIPT_VAR_FIELD_CONDITION, FIELD_CONDITION_SANDSTORM
    UpdateVar OPCODE_SET, BSCRIPT_VAR_WEATHER_TURNS, 5
    CheckItemHoldEffect CHECK_OPCODE_NOT_HAVE, BATTLER_CATEGORY_DEFENDER, HOLD_EFFECT_EXTEND_SANDSTORM, _Message
    GetItemEffectParam BATTLER_CATEGORY_DEFENDER, BSCRIPT_VAR_CALC_TEMP
    UpdateVarFromVar OPCODE_ADD, BSCRIPT_VAR_WEATHER_TURNS, BSCRIPT_VAR_CALC_TEMP

_Message:
    // A sandstorm kicked up!
    PrintMessage msg_0197_00695, TAG_NONE
    Wait 
    WaitButtonABTime 30
    End 
