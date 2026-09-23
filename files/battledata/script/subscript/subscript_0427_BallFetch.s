    .include "macros/btlcmd.inc"

    .data

// Ball Fetch picking up the first ball that failed. The reference gives the
// ability no effect and no script; the line is Pickup's, and the ball is
// already in the Pokemon's hands by the time this runs.

_000:
    WaitButtonABTime 15
    // {0} found one {1}!
    PrintMessage msg_0197_00589, TAG_NICKNAME_ITEM, BATTLER_CATEGORY_MSG_BATTLER_TEMP, BATTLER_CATEGORY_MSG_TEMP
    Wait
    WaitButtonABTime 30
    End
