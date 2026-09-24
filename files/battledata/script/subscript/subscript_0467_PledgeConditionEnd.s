    .include "macros/btlcmd.inc"

    .data

// A Pledge's condition gone from the side of the Pokemon in MSG_TEMP: MSG_TEMP
// 0 the rainbow, 1 the sea of fire, 2 the swamp (UFC_STATE_PLEDGES).
_000:
    CompareVarToValue OPCODE_EQU, BSCRIPT_VAR_MESSAGE, 1, _SEA_OF_FIRE
    CompareVarToValue OPCODE_EQU, BSCRIPT_VAR_MESSAGE, 2, _SWAMP
    // The rainbow on your team's side disappeared!
    PrintMessage msg_0197_01923, TAG_NONE_SIDE, BATTLER_CATEGORY_MSG_TEMP
    GoTo _SAID

_SEA_OF_FIRE:
    // The sea of fire around your team disappeared!
    PrintMessage msg_0197_01925, TAG_NONE_SIDE, BATTLER_CATEGORY_MSG_TEMP
    GoTo _SAID

_SWAMP:
    // The swamp around your team disappeared!
    PrintMessage msg_0197_01927, TAG_NONE_SIDE, BATTLER_CATEGORY_MSG_TEMP

_SAID:
    Wait
    WaitButtonABTime 30
    End
