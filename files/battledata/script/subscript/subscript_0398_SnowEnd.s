    .include "macros/btlcmd.inc"

    .data

// Hail's counterpart, from the reference's subscript 359. The one line of its
// own that is not here is the Call to its switch-in ability check: this game
// has no such subscript, and its own hail end does not call one either.

_000:
    UpdateVar OPCODE_FLAG_OFF, BSCRIPT_VAR_FIELD_CONDITION, FIELD_CONDITION_SNOW_TEMP
    // The snow stopped.
    PrintMessage msg_0197_01370, TAG_NONE
    Wait
    WaitButtonABTime 30
    End
