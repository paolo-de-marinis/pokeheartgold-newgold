    .include "macros/btlcmd.inc"

    .data

// A combined Pledge's condition laid on the side of the Pokemon in MSG_TEMP:
// MSG_TEMP 0 the rainbow, 1 the sea of fire, 2 the swamp (the post-move step,
// TryAdditionalMoveEffect).
_000:
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
    End
