    .include "macros/btlcmd.inc"

    .data

// Focus Energy fails on a Pokemon pumped already, or cheered by Dragon Cheer
// (Battler_CriticalRisen): SetMoveConditionFlag leaves in CALC_TEMP whether
// it takes.
_000:
    SetMoveConditionFlag MOVE_FOCUS_ENERGY, BATTLER_CATEGORY_ATTACKER
    CompareVarToValue OPCODE_EQU, BSCRIPT_VAR_CALC_TEMP, 0, _010
    UpdateVar OPCODE_FLAG_ON, BSCRIPT_VAR_SIDE_EFFECT_FLAGS_DIRECT, MOVE_SIDE_EFFECT_TO_ATTACKER|MOVE_SUBSCRIPT_PTR_FOCUS_ENERGY
    End 

_010:
    UpdateVar OPCODE_FLAG_ON, BSCRIPT_VAR_MOVE_STATUS_FLAGS, MOVE_STATUS_FAILED
    End 
