    .include "macros/btlcmd.inc"

    .data

// Entrainment gives the target the user's ability. It fails, as the
// reference's move-failure check has it, when the user's is one that cannot
// be passed on, the target's one nothing writes over or Truant, or the two
// are the same (the table's, BMON_DATA_ABILITY_FLAGS). Like Role Play's
// subscript, this one says what the move was once it has worked.
_000:
    // An Ability Shield keeps the target's ability (Pokemon Central, Scudo abilita).
    CompareMonDataToValue OPCODE_EQU, BATTLER_CATEGORY_DEFENDER, BMON_DATA_HELD_ITEM, ITEM_ABILITY_SHIELD, _FAILED
    CompareVarToValue OPCODE_FLAG_SET, BSCRIPT_VAR_MOVE_STATUS_FLAGS, MOVE_STATUS_MISSED|MOVE_STATUS_SEMI_INVULNERABLE, _FAILED
    CompareMonDataToValue OPCODE_FLAG_SET, BATTLER_CATEGORY_ATTACKER, BMON_DATA_ABILITY_FLAGS, ABILITY_FLAG_FAILS_ENTRAINMENT, _FAILED
    CompareMonDataToValue OPCODE_FLAG_SET, BATTLER_CATEGORY_DEFENDER, BMON_DATA_ABILITY_FLAGS, ABILITY_FLAG_FAILS_SUPPRESS, _FAILED
    CompareMonDataToValue OPCODE_EQU, BATTLER_CATEGORY_DEFENDER, BMON_DATA_ABILITY, ABILITY_TRUANT, _FAILED
    UpdateMonDataFromVar OPCODE_GET, BATTLER_CATEGORY_ATTACKER, BMON_DATA_ABILITY, BSCRIPT_VAR_CALC_TEMP
    CompareMonDataToVar OPCODE_EQU, BATTLER_CATEGORY_DEFENDER, BMON_DATA_ABILITY, BSCRIPT_VAR_CALC_TEMP, _FAILED
    Call BATTLE_SUBSCRIPT_ATTACK_MESSAGE_AND_ANIMATION
    UpdateMonDataFromVar OPCODE_SET, BATTLER_CATEGORY_DEFENDER, BMON_DATA_ABILITY, BSCRIPT_VAR_CALC_TEMP
    // {0} acquired {1}!
    PrintMessage msg_0197_01021, TAG_NICKNAME_ABILITY, BATTLER_CATEGORY_DEFENDER, BATTLER_CATEGORY_DEFENDER
    Wait
    WaitButtonABTime 30
    End 

_FAILED:
    UpdateVar OPCODE_FLAG_ON, BSCRIPT_VAR_MOVE_STATUS_FLAGS, MOVE_STATUS_FAILED
    End
