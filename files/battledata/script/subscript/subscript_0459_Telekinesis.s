    .include "macros/btlcmd.inc"

    .data

// Telekinesis, once it has got through Protect: the target is lifted for
// three turns (SetMoveConditionFlag), in which it cannot be reached from the
// ground and nothing but a one-hit KO move misses it; one already up fails
// (Pokemon Central, Telecinesi).
_000:
    SetMoveConditionFlag MOVE_TELEKINESIS, BATTLER_CATEGORY_DEFENDER
    CompareVarToValue OPCODE_EQU, BSCRIPT_VAR_CALC_TEMP, 0, _FAILED
    // {0} was hurled into the air!
    PrintMessage msg_0197_01879, TAG_NICKNAME, BATTLER_CATEGORY_DEFENDER
    Wait
    WaitButtonABTime 30
    End

_FAILED:
    Call BATTLE_SUBSCRIPT_BUT_IT_FAILED
    End
