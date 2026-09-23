    .include "macros/btlcmd.inc"

    .data

// Curious Medicine clearing its ally's stat changes on the way in. The
// reference gives the ability no effect and no script; this is the later
// games' line, about the ally, whose stages are already back at zero by the
// time this runs.

_000:
    WaitButtonABTime 15
    // {0}’s stat changes were removed!
    PrintMessage msg_0197_01814, TAG_NICKNAME, BATTLER_CATEGORY_MSG_BATTLER_TEMP
    Wait
    WaitButtonABTime 30
    End
