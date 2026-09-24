    .include "macros/btlcmd.inc"

    .data

// Fell Stinger, which pays out only if the sting finished the job: three
// stages of Attack from the seventh generation (Pokemon Central,
// Pungiglione), once the move is over (TryAdditionalMoveEffect).
_000:
    CompareMonDataToValue OPCODE_NEQ, BATTLER_CATEGORY_DEFENDER, BMON_DATA_HP, 0, _SURVIVED
    UpdateVarFromVar OPCODE_SET, BSCRIPT_VAR_BATTLER_STAT_CHANGE, BSCRIPT_VAR_BATTLER_ATTACKER
    UpdateVar OPCODE_SET, BSCRIPT_VAR_SIDE_EFFECT_PARAM, MOVE_SUBSCRIPT_PTR_ATTACK_UP_3_STAGES
    Call BATTLE_SUBSCRIPT_UPDATE_STAT_STAGE

_SURVIVED:
    End 
