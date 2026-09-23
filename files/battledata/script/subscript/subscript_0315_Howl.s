    .include "macros/btlcmd.inc"

    .data

// Howl raises the Attack of its user and of its allies (Generation VIII on).
// The reference raises the user alone and leaves the partner as a TODO
// (BattleController_BeforeMove.c); the ally is walked here the way Perish
// Song and Room Service walk the field. Howl is a sound move, so an ally's
// Soundproof keeps it out unless Mold Breaker is shouting; a fainted ally is
// passed over. The ally's rise is an indirect one: no second attack message
// or Howl animation, and nothing said if its Attack is already at the top.
_Start:
    UpdateVar OPCODE_SET, BSCRIPT_VAR_SIDE_EFFECT_PARAM, MOVE_SUBSCRIPT_PTR_ATTACK_UP_1_STAGE
    Call BATTLE_SUBSCRIPT_UPDATE_STAT_STAGE
    UpdateVar OPCODE_FLAG_OFF, BSCRIPT_VAR_BATTLE_STATUS_2, BATTLE_STATUS2_UPDATE_STAT_STAGES
    UpdateVar OPCODE_SET, BSCRIPT_VAR_BATTLER_SPEED_TEMP, 0

_loop:
    GetMonBySpeedOrder BSCRIPT_VAR_BATTLER_STAT_CHANGE
    CompareVarToVar OPCODE_EQU, BSCRIPT_VAR_BATTLER_STAT_CHANGE, BSCRIPT_VAR_BATTLER_ATTACKER, _next
    IfSameSide BATTLER_CATEGORY_ATTACKER, BATTLER_CATEGORY_SIDE_EFFECT_MON, _ally
    GoTo _next

_ally:
    CompareMonDataToValue OPCODE_EQU, BATTLER_CATEGORY_SIDE_EFFECT_MON, BMON_DATA_HP, 0, _next
    CheckIgnorableAbility CHECK_OPCODE_HAVE, BATTLER_CATEGORY_SIDE_EFFECT_MON, ABILITY_SOUNDPROOF, _next
    UpdateVar OPCODE_SET, BSCRIPT_VAR_SIDE_EFFECT_TYPE, SIDE_EFFECT_TYPE_INDIRECT
    UpdateVar OPCODE_SET, BSCRIPT_VAR_SIDE_EFFECT_PARAM, MOVE_SUBSCRIPT_PTR_ATTACK_UP_1_STAGE
    Call BATTLE_SUBSCRIPT_UPDATE_STAT_STAGE
    UpdateVar OPCODE_FLAG_OFF, BSCRIPT_VAR_BATTLE_STATUS_2, BATTLE_STATUS2_UPDATE_STAT_STAGES

_next:
    UpdateVar OPCODE_ADD, BSCRIPT_VAR_BATTLER_SPEED_TEMP, 1
    GoToIfValidMon BSCRIPT_VAR_BATTLER_SPEED_TEMP, _loop
    End
