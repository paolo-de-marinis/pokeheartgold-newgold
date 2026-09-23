    .include "macros/btlcmd.inc"

    .data

// Salt Cure's added effect: the target is salted for as long as it stays in
// (Pokemon Central, Sotto Sale). A second cure takes nothing and says
// nothing; SetMoveConditionFlag leaves in CALC_TEMP whether this one took.
_000:
    SetMoveConditionFlag MOVE_SALT_CURE, BATTLER_CATEGORY_DEFENDER
    CompareVarToValue OPCODE_EQU, BSCRIPT_VAR_CALC_TEMP, 0, _END
    // {0} is being salt cured!
    PrintMessage msg_0197_01850, TAG_NICKNAME, BATTLER_CATEGORY_DEFENDER
    Wait
    WaitButtonABTime 30

_END:
    End
