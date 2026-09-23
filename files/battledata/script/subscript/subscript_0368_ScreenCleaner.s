    .include "macros/btlcmd.inc"

    .data

// The screens are already down by the time this runs, on both sides at once,
// so the line names neither Pokemon nor side.
_000:
    // All screens on the field were cleansed!
    PrintMessage msg_0197_01783, TAG_NONE
    Wait
    WaitButtonABTime 30
    End
