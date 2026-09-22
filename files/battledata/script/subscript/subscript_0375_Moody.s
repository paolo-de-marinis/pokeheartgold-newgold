    .include "macros/btlcmd.inc"

    .data

// Two stat changes in one script, because the end-of-turn block runs one
// script per battler and then moves on. Each var holds a stat counted from
// Attack, so it is added to the first pointer of its group; 8 means there
// was nothing left to move that way and the half is skipped.
//
// Both changes are the holder's own doing, so the holder stands in as the
// attacker for the length of them -- otherwise the drop is offered to
// whoever attacked last in the turn, and the Mist and Clear Body guards
// would turn a Pokemon's own Moody away. Subscript 357 does the same swap
// the other way round, for the same reason.
_000:
    AbilityPopup BATTLER_CATEGORY_MSG_BATTLER_TEMP, -1
    UpdateVarFromVar OPCODE_SET, BSCRIPT_VAR_LAST_BATTLER_ID, BSCRIPT_VAR_BATTLER_ATTACKER
    UpdateVarFromVar OPCODE_SET, BSCRIPT_VAR_BATTLER_ATTACKER, BSCRIPT_VAR_BATTLER_STAT_CHANGE
    UpdateVar OPCODE_FLAG_OFF, BSCRIPT_VAR_BATTLE_STATUS_2, BATTLE_STATUS2_UPDATE_STAT_STAGES
    CompareVarToValue OPCODE_EQU, BSCRIPT_VAR_CALC_TEMP, 8, _skipRaise
    UpdateVarFromVar OPCODE_SET, BSCRIPT_VAR_SIDE_EFFECT_PARAM, BSCRIPT_VAR_CALC_TEMP
    UpdateVar OPCODE_ADD, BSCRIPT_VAR_SIDE_EFFECT_PARAM, MOVE_SUBSCRIPT_PTR_ATTACK_UP_2_STAGES
    Call BATTLE_SUBSCRIPT_UPDATE_STAT_STAGE

// The two changes are different animations, so neither borrows the other's:
// the flag that would have the second one skip it is cleared between them.
_skipRaise:
    UpdateVar OPCODE_FLAG_OFF, BSCRIPT_VAR_BATTLE_STATUS_2, BATTLE_STATUS2_UPDATE_STAT_STAGES
    CompareVarToValue OPCODE_EQU, BSCRIPT_VAR_MSG_ABILITY_TEMP, 8, _skipDrop
    UpdateVarFromVar OPCODE_SET, BSCRIPT_VAR_SIDE_EFFECT_PARAM, BSCRIPT_VAR_MSG_ABILITY_TEMP
    UpdateVar OPCODE_ADD, BSCRIPT_VAR_SIDE_EFFECT_PARAM, MOVE_SUBSCRIPT_PTR_ATTACK_DOWN_1_STAGE
    Call BATTLE_SUBSCRIPT_UPDATE_STAT_STAGE

_skipDrop:
    UpdateVarFromVar OPCODE_SET, BSCRIPT_VAR_BATTLER_ATTACKER, BSCRIPT_VAR_LAST_BATTLER_ID
    UpdateVar OPCODE_FLAG_OFF, BSCRIPT_VAR_BATTLE_STATUS_2, BATTLE_STATUS2_UPDATE_STAT_STAGES
    End
