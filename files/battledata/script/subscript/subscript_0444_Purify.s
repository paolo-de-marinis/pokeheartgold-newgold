    .include "macros/btlcmd.inc"

    .data

// Purify: the target's status is cured, and then the user gets back half its
// maximum HP, rounded down, if it is short of it (Pokemon Central,
// Purificazione).
_000:
    UpdateMonData OPCODE_SET, BATTLER_CATEGORY_DEFENDER, BMON_DATA_STATUS, STATUS_NONE
    UpdateMonData OPCODE_FLAG_OFF, BATTLER_CATEGORY_DEFENDER, BMON_DATA_STATUS2, STATUS2_NIGHTMARE
    // {0}'s status returned to normal!
    PrintMessage msg_0197_00491, TAG_NICKNAME, BATTLER_CATEGORY_DEFENDER
    Wait
    SetHealthbarStatus BATTLER_CATEGORY_DEFENDER, BATTLE_ANIMATION_NONE
    WaitButtonABTime 30
    UpdateMonDataFromVar OPCODE_GET, BATTLER_CATEGORY_ATTACKER, BMON_DATA_MAXHP, BSCRIPT_VAR_CALC_TEMP
    CompareMonDataToVar OPCODE_EQU, BATTLER_CATEGORY_ATTACKER, BMON_DATA_HP, BSCRIPT_VAR_CALC_TEMP, _END
    UpdateVarFromVar OPCODE_SET, BSCRIPT_VAR_MSG_BATTLER_TEMP, BSCRIPT_VAR_BATTLER_ATTACKER
    UpdateVar OPCODE_FLAG_ON, BSCRIPT_VAR_BATTLE_STATUS, BATTLE_STATUS_NO_BLINK
    UpdateMonDataFromVar OPCODE_GET, BATTLER_CATEGORY_ATTACKER, BMON_DATA_MAXHP, BSCRIPT_VAR_HP_CALC
    DivideVarByValue BSCRIPT_VAR_HP_CALC, 2
    Call BATTLE_SUBSCRIPT_UPDATE_HP
    // {0} had its HP restored.
    PrintMessage msg_0197_01396, TAG_NICKNAME, BATTLER_CATEGORY_ATTACKER
    Wait
    WaitButtonABTime 30

_END:
    End
