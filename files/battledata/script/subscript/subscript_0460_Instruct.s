    .include "macros/btlcmd.inc"

    .data

// Instruct, once it has got through Protect: the target is to use its last
// move again as soon as the Instruct is over (the controller's TryInstruct),
// or, when that move cannot be repeated or is gone or out of PP, the move
// fails (Pokemon Central, Imposizione). SetMoveConditionFlag decides, and
// leaves the answer in CALC_TEMP.
_000:
    SetMoveConditionFlag MOVE_INSTRUCT, BATTLER_CATEGORY_DEFENDER
    CompareVarToValue OPCODE_EQU, BSCRIPT_VAR_CALC_TEMP, 0, _FAILED
    End

_FAILED:
    Call BATTLE_SUBSCRIPT_BUT_IT_FAILED
    End
