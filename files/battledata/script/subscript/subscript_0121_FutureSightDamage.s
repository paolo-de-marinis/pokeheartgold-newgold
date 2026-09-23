    .include "macros/btlcmd.inc"

    .data

// Future Sight or Doom Desire lands on the MSG_TEMP battler, from the
// MSG_ATTACKER one. BattleContext_LandFutureSight has just worked the hit out
// with the two of them as attacker and defender: the damage in hpCalc, the
// type chart's verdict and whether it hit in the move status flags, and the
// critical hit.
_000:
    PrintBufferedMessage
    Wait
    WaitButtonABTime 30
    CompareVarToValue OPCODE_FLAG_SET, BSCRIPT_VAR_MOVE_STATUS_FLAGS, MOVE_STATUS_NO_EFFECT, _NoEffect
    CompareVarToValue OPCODE_FLAG_SET, BSCRIPT_VAR_MOVE_STATUS_FLAGS, MOVE_STATUS_WONDER_GUARD_IMMUNE, _WonderGuard
    CompareVarToValue OPCODE_FLAG_SET, BSCRIPT_VAR_MOVE_STATUS_FLAGS, MOVE_STATUS_DID_NOT_HIT, _117
    UpdateVar OPCODE_SET, BSCRIPT_VAR_MOVE_EFFECT_CHANCE, 1
    PlayMoveAnimationOnMons BATTLER_CATEGORY_MSG_TEMP, BATTLER_CATEGORY_MSG_ATTACKER, BATTLER_CATEGORY_MSG_TEMP
    Wait
    UpdateVar OPCODE_FLAG_OFF, BSCRIPT_VAR_BATTLE_STATUS, BATTLE_STATUS_MOVE_ANIMATIONS_OFF
    CompareMonDataToValue OPCODE_FLAG_NOT, BATTLER_CATEGORY_MSG_TEMP, BMON_DATA_STATUS2, STATUS2_SUBSTITUTE, _058
    UpdateVar OPCODE_MUL, BSCRIPT_VAR_HP_CALC, -1
    CompareMonDataToVar OPCODE_LTE, BATTLER_CATEGORY_MSG_TEMP, BMON_DATA_SUBSTITUTE_HP, BSCRIPT_VAR_HP_CALC, _044
    UpdateMonDataFromVar OPCODE_SUB, BATTLER_CATEGORY_MSG_TEMP, BMON_DATA_SUBSTITUTE_HP, BSCRIPT_VAR_HP_CALC
    GoTo _054

_044:
    UpdateMonData OPCODE_SET, BATTLER_CATEGORY_MSG_TEMP, BMON_DATA_SUBSTITUTE_HP, 0
    UpdateMonData OPCODE_FLAG_OFF, BATTLER_CATEGORY_MSG_TEMP, BMON_DATA_STATUS2, STATUS2_SUBSTITUTE

_054:
    Call BATTLE_SUBSCRIPT_HIT_SUBSTITUTE
    Call BATTLE_SUBSCRIPT_CRITICAL_HIT
    Call BATTLE_SUBSCRIPT_MOVE_FOLLOWUP_MESSAGE
    GoTo _116

_058:
    CheckHoldOnWith1HP BATTLER_CATEGORY_MSG_TEMP
    Call BATTLE_SUBSCRIPT_UPDATE_HP
    // A critical hit, how well it landed and an item that held on, as for any
    // hit; the defender is the target.
    Call BATTLE_SUBSCRIPT_CRITICAL_HIT
    Call BATTLE_SUBSCRIPT_MOVE_FOLLOWUP_MESSAGE
    CompareMonDataToValue OPCODE_FLAG_NOT, BATTLER_CATEGORY_MSG_TEMP, BMON_DATA_STATUS2, STATUS2_RAGE, _116
    CompareMonDataToValue OPCODE_EQU, BATTLER_CATEGORY_MSG_TEMP, BMON_DATA_HP, 0, _116
    CompareMonDataToValue OPCODE_EQU, BATTLER_CATEGORY_MSG_TEMP, BMON_DATA_STAT_CHANGE_ATK, 12, _116
    UpdateMonData OPCODE_ADD, BATTLER_CATEGORY_MSG_TEMP, BMON_DATA_STAT_CHANGE_ATK, 1
    // {0}’s rage is building!
    PrintMessage msg_0197_00363, TAG_NICKNAME, BATTLER_CATEGORY_MSG_TEMP
    Wait
    WaitButtonABTime 30

_116:
    End

_117:
    WaitButtonABTime 30
    // But it failed!
    PrintMessage msg_0197_00796, TAG_NONE
    Wait
    WaitButtonABTime 30
    End

_NoEffect:
    // It doesn’t affect {0}...
    PrintMessage msg_0197_00027, TAG_NICKNAME, BATTLER_CATEGORY_MSG_TEMP
    Wait
    WaitButtonABTime 30
    End

_WonderGuard:
    // {0} avoided damage by using {1}!
    PrintMessage msg_0197_00018, TAG_NICKNAME_ABILITY, BATTLER_CATEGORY_MSG_TEMP, BATTLER_CATEGORY_MSG_TEMP
    Wait
    WaitButtonABTime 30
    End
