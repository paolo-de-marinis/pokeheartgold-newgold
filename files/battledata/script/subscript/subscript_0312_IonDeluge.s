    .include "macros/btlcmd.inc"

    .data

_Start:
    // A deluge of ions showers the battlefield!
    PrintMessage msg_0197_01324, TAG_NONE
    Wait
    WaitButtonABTime 30
    UpdateVar OPCODE_FLAG_ON, BSCRIPT_VAR_FIELD_CONDITION, FIELD_CONDITION_ION_DELUGE
    End
