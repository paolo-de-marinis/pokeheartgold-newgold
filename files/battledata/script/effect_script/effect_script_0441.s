    .include "macros/btlcmd.inc"

    .data

// Teatime: every Pokemon on the field eats its held Berry and has its effect,
// Unnerve, Magic Room, Sticky Hold and a substitute notwithstanding; one in
// the air or underground does not; with no Berry to eat, nothing happens
// (Pokemon Central, Ora del Te). Each takes its turn at the table as both
// attacker and target, which TryPluck answers for this move by eating the
// Berry as Bug Bite's eater does; the move's own two are put back after.
_000:
    SetMoveConditionFlag MOVE_TEATIME, BATTLER_CATEGORY_ATTACKER
    CompareVarToValue OPCODE_EQU, BSCRIPT_VAR_CALC_TEMP, 0, _NOTHING
    Call BATTLE_SUBSCRIPT_ATTACK_MESSAGE_AND_ANIMATION
    // It's teatime! Everyone dug in to their Berries!
    PrintMessage msg_0197_01894, TAG_NONE
    Wait
    WaitButtonABTime 30
    UpdateVarFromVar OPCODE_SET, BSCRIPT_VAR_BATTLER_ATTACKER_TEMP, BSCRIPT_VAR_BATTLER_ATTACKER
    UpdateVarFromVar OPCODE_SET, BSCRIPT_VAR_BATTLER_TARGET_TEMP, BSCRIPT_VAR_BATTLER_TARGET
    UpdateVar OPCODE_SET, BSCRIPT_VAR_BATTLER_SPEED_TEMP, 0

_LOOP:
    GetMonBySpeedOrder BSCRIPT_VAR_BATTLER_STAT_CHANGE
    CompareMonDataToValue OPCODE_EQU, BATTLER_CATEGORY_SIDE_EFFECT_MON, BMON_DATA_HP, 0, _NEXT
    CompareMonDataToValue OPCODE_FLAG_SET, BATTLER_CATEGORY_SIDE_EFFECT_MON, BMON_DATA_MOVE_EFFECT, MOVE_EFFECT_FLAG_SEMI_INVULNERABLE, _NEXT
    UpdateVarFromVar OPCODE_SET, BSCRIPT_VAR_BATTLER_ATTACKER, BSCRIPT_VAR_BATTLER_STAT_CHANGE
    UpdateVarFromVar OPCODE_SET, BSCRIPT_VAR_BATTLER_TARGET, BSCRIPT_VAR_BATTLER_STAT_CHANGE
    TryPluck _NEXT, _NEXT
    RemoveItem BATTLER_CATEGORY_DEFENDER
    UpdateVarFromVar OPCODE_SET, BSCRIPT_VAR_MSG_BATTLER_TEMP, BSCRIPT_VAR_BATTLER_ATTACKER
    CompareVarToValue OPCODE_EQU, BSCRIPT_VAR_TEMP_DATA, 0, _NEXT
    CallFromVar BSCRIPT_VAR_TEMP_DATA

_NEXT:
    UpdateVar OPCODE_ADD, BSCRIPT_VAR_BATTLER_SPEED_TEMP, 1
    GoToIfValidMon BSCRIPT_VAR_BATTLER_SPEED_TEMP, _LOOP
    UpdateVarFromVar OPCODE_SET, BSCRIPT_VAR_BATTLER_ATTACKER, BSCRIPT_VAR_BATTLER_ATTACKER_TEMP
    UpdateVarFromVar OPCODE_SET, BSCRIPT_VAR_BATTLER_TARGET, BSCRIPT_VAR_BATTLER_TARGET_TEMP
    End

_NOTHING:
    PrintAttackMessage
    Wait
    WaitButtonABTime 30
    // But nothing happened!
    PrintMessage msg_0197_00795, TAG_NONE
    Wait
    WaitButtonABTime 30
    UpdateVar OPCODE_FLAG_ON, BSCRIPT_VAR_MOVE_STATUS_FLAGS, MOVE_STATUS_NO_MORE_WORK
    End
