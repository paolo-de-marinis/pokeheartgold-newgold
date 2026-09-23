    .include "macros/btlcmd.inc"

    .data

// Growth raises Attack and Sp. Atk by one each, and by two each in the sun
// (Generation V on). The engine's subscript (331 there) asks only whether the
// field is sunny; for Growth the sun is also no sun under Cloud Nine or Air
// Lock, or to a user holding a Utility Umbrella (Crescita, Pokemon Central),
// and those are asked here too. One stage each is Work Up's subscript, which
// is where the shade sends it. The two-stage half is that subscript's shape --
// the move's message and animation once, then both rises, or the line for
// stats that will go no higher -- where the engine's raised twice with the
// animation each time. Its branch for Mega Sol, which only prints the attack
// message, is left for that ability.
_000:
    CheckIgnoreWeather _one
    CompareVarToValue OPCODE_FLAG_NOT, BSCRIPT_VAR_FIELD_CONDITION, FIELD_CONDITION_SUN_ALL, _one
    CheckItemHoldEffect CHECK_OPCODE_HAVE, BATTLER_CATEGORY_SIDE_EFFECT_MON, HOLD_EFFECT_UNAFFECTED_BY_RAIN_OR_SUN, _one
    CompareMonDataToValue OPCODE_NEQ, BATTLER_CATEGORY_SIDE_EFFECT_MON, BMON_DATA_STAT_CHANGE_ATK, 12, _two
    CompareMonDataToValue OPCODE_NEQ, BATTLER_CATEGORY_SIDE_EFFECT_MON, BMON_DATA_STAT_CHANGE_SPATK, 12, _two

_one:
    GoToSubscript BATTLE_SUBSCRIPT_ATK_SP_ATK_UP

_two:
    Call BATTLE_SUBSCRIPT_ATTACK_MESSAGE_AND_ANIMATION
    UpdateVar OPCODE_FLAG_ON, BSCRIPT_VAR_BATTLE_STATUS, BATTLE_STATUS_MESSAGES_OFF
    UpdateVar OPCODE_FLAG_ON, BSCRIPT_VAR_BATTLE_STATUS, BATTLE_STATUS_MOVE_ANIMATIONS_OFF|BATTLE_STATUS_NO_ATTACK_MESSAGE
    UpdateVar OPCODE_FLAG_ON, BSCRIPT_VAR_BATTLE_STATUS_2, BATTLE_STATUS2_STAT_STAGE_CHANGE_SHOWN
    UpdateVar OPCODE_SET, BSCRIPT_VAR_SIDE_EFFECT_PARAM, MOVE_SUBSCRIPT_PTR_ATTACK_UP_2_STAGES
    Call BATTLE_SUBSCRIPT_UPDATE_STAT_STAGE
    UpdateVar OPCODE_SET, BSCRIPT_VAR_SIDE_EFFECT_PARAM, MOVE_SUBSCRIPT_PTR_SP_ATTACK_UP_2_STAGES
    Call BATTLE_SUBSCRIPT_UPDATE_STAT_STAGE
    UpdateVar OPCODE_FLAG_OFF, BSCRIPT_VAR_BATTLE_STATUS_2, BATTLE_STATUS2_UPDATE_STAT_STAGES
    UpdateVar OPCODE_FLAG_OFF, BSCRIPT_VAR_BATTLE_STATUS_2, BATTLE_STATUS2_STAT_STAGE_CHANGE_SHOWN
    End
