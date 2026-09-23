    .include "macros/btlcmd.inc"

    .data

_000:
    PlayBattleAnimation BATTLER_CATEGORY_PLAYER, BATTLE_ANIMATION_WEATHER_SUN
    Wait 
    // The sunlight turned harsh!
    PrintMessage msg_0197_00698, TAG_NONE
    Wait 
    WaitButtonABTime 30
    UpdateVar OPCODE_FLAG_OFF, BSCRIPT_VAR_FIELD_CONDITION, FIELD_CONDITION_WEATHER
    UpdateVar OPCODE_FLAG_ON, BSCRIPT_VAR_FIELD_CONDITION, FIELD_CONDITION_SUN_PERMANENT
    // The sun is out, so Protosynthesis switches on.
    ActivateParadoxAbility ABILITY_PROTOSYNTHESIS
    End
