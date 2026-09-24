    .include "macros/btlcmd.inc"

    .data

// Stuff Cheeks: the user eats its Berry, which has its effect whatever its
// own condition, and then its Defense rises by two stages (Pokemon Central,
// Riempiguance).

_000:
    // At +6 Defense the reference refuses the move before it runs, with the
    // stat's line (BattleController_BeforeMove.c:3228), and the berry stays.
    CompareMonDataToValue OPCODE_EQU, BATTLER_CATEGORY_ATTACKER, BMON_DATA_STAT_CHANGE_DEF, 12, _DEFENSE_MAXED
    PrintAttackMessage 
    Wait 
    PlayMoveAnimation BATTLER_CATEGORY_ATTACKER
    Wait
    UpdateVarFromVar OPCODE_SET, BSCRIPT_VAR_MSG_BATTLER_TEMP, BSCRIPT_VAR_BATTLER_ATTACKER
    // The Berry goes here, once; the eating marks it as Bug Bite's, so its
    // own script, if it has one, does not remove it again.
    StuffCheeks _RAISE
    RemoveItem BATTLER_CATEGORY_ATTACKER
    CompareVarToValue OPCODE_EQU, BSCRIPT_VAR_TEMP_DATA, 0, _RAISE
    CallFromVar BSCRIPT_VAR_TEMP_DATA

_RAISE:
    UpdateVar OPCODE_FLAG_OFF, BSCRIPT_VAR_ATTACKER_SELF_TURN_STATUS_FLAGS, SELF_TURN_FLAG_PLUCK_BERRY
    UpdateVarFromVar OPCODE_SET, BSCRIPT_VAR_MSG_BATTLER_TEMP, BSCRIPT_VAR_BATTLER_ATTACKER
    UpdateVar OPCODE_FLAG_ON, BSCRIPT_VAR_BATTLE_STATUS_2, BATTLE_STATUS2_STAT_STAGE_CHANGE_SHOWN
    UpdateVar OPCODE_SET, BSCRIPT_VAR_SIDE_EFFECT_PARAM, MOVE_SUBSCRIPT_PTR_DEFENSE_UP_2_STAGES
    Call BATTLE_SUBSCRIPT_UPDATE_STAT_STAGE
    UpdateVar OPCODE_FLAG_OFF, BSCRIPT_VAR_BATTLE_STATUS_2, BATTLE_STATUS2_STAT_STAGE_CHANGE_SHOWN
    End

_DEFENSE_MAXED:
    UpdateVarFromVar OPCODE_SET, BSCRIPT_VAR_MSG_BATTLER_TEMP, BSCRIPT_VAR_BATTLER_ATTACKER
    UpdateVar OPCODE_SET, BSCRIPT_VAR_SIDE_EFFECT_PARAM, MOVE_SUBSCRIPT_PTR_DEFENSE_UP_2_STAGES
    Call BATTLE_SUBSCRIPT_UPDATE_STAT_STAGE
    End
