    .include "macros/btlcmd.inc"

    .data

// Syrup Bomb's added effect: the target is covered, to lose a stage of Speed
// at each of the next three turns' ends while the thrower stays in (Pokemon
// Central, Bomba Sciroppata; the controller's UMC_STATE_SYRUP_BOMB). A target
// still covered takes nothing and nothing is said; SetMoveConditionFlag
// leaves in CALC_TEMP whether this one took.
_000:
    SetMoveConditionFlag MOVE_SYRUP_BOMB, BATTLER_CATEGORY_DEFENDER
    CompareVarToValue OPCODE_EQU, BSCRIPT_VAR_CALC_TEMP, 0, _END
    // {0} got covered in sticky candy syrup!
    PrintMessage msg_0197_01856, TAG_NICKNAME, BATTLER_CATEGORY_DEFENDER
    Wait
    WaitButtonABTime 30

_END:
    End
