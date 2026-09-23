    .include "macros/btlcmd.inc"

    .data

// Tar Shot, on its hit: a stage less Speed, and the first time Fire moves
// twice as effective on the target (Pokemon Central, Colpocatrame;
// CalcTypeEffectiveness reads the mark). SetMoveConditionFlag leaves in
// CALC_TEMP whether this was the first time.
_000:
    UpdateVarFromVar OPCODE_SET, BSCRIPT_VAR_BATTLER_STAT_CHANGE, BSCRIPT_VAR_BATTLER_TARGET
    UpdateVar OPCODE_SET, BSCRIPT_VAR_SIDE_EFFECT_TYPE, SIDE_EFFECT_TYPE_INDIRECT
    UpdateVar OPCODE_SET, BSCRIPT_VAR_SIDE_EFFECT_PARAM, MOVE_SUBSCRIPT_PTR_SPEED_DOWN_1_STAGE
    Call BATTLE_SUBSCRIPT_UPDATE_STAT_STAGE
    UpdateVar OPCODE_FLAG_OFF, BSCRIPT_VAR_BATTLE_STATUS_2, BATTLE_STATUS2_UPDATE_STAT_STAGES
    SetMoveConditionFlag MOVE_TAR_SHOT, BATTLER_CATEGORY_DEFENDER
    CompareVarToValue OPCODE_EQU, BSCRIPT_VAR_CALC_TEMP, 0, _END
    // {0} became weaker to fire!
    PrintMessage msg_0197_01859, TAG_NICKNAME, BATTLER_CATEGORY_DEFENDER
    Wait
    WaitButtonABTime 30

_END:
    End
