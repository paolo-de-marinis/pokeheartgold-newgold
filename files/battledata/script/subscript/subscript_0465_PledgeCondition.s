    .include "macros/btlcmd.inc"

    .data

// A combined Pledge's condition, laid as the move hits (the effect script's
// side effect): LeavePledgeCondition, asked with Fire Pledge's number, lays
// it on the side of the Pokemon in MSG_TEMP -- MSG_TEMP 0 the rainbow, 1 the
// sea of fire, 2 the swamp -- or says there was one already.
_000:
    SetMoveConditionFlag MOVE_FIRE_PLEDGE, BATTLER_CATEGORY_ATTACKER
    CompareVarToValue OPCODE_EQU, BSCRIPT_VAR_CALC_TEMP, 0, _END
    CompareVarToValue OPCODE_EQU, BSCRIPT_VAR_MESSAGE, 1, _SEA_OF_FIRE
    CompareVarToValue OPCODE_EQU, BSCRIPT_VAR_MESSAGE, 2, _SWAMP
    // A rainbow appeared in the sky on your team's side!
    PrintMessage msg_0197_01917, TAG_NONE_SIDE, BATTLER_CATEGORY_MSG_TEMP
    GoTo _SAID

_SEA_OF_FIRE:
    // A sea of fire enveloped your team!
    PrintMessage msg_0197_01919, TAG_NONE_SIDE, BATTLER_CATEGORY_MSG_TEMP
    GoTo _SAID

_SWAMP:
    // A swamp enveloped your team!
    PrintMessage msg_0197_01921, TAG_NONE_SIDE, BATTLER_CATEGORY_MSG_TEMP

_SAID:
    Wait
    WaitButtonABTime 30

_END:
    End
