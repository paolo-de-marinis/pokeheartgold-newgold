    .include "macros/btlcmd.inc"

    .data

// Mimicry taking the type of the terrain. The C has already changed the
// types and left the new one in MSG_TEMP; the line is Color Change's. The
// reference runs Color Change's subscript for it, and going back to its own
// types when the terrain ends says nothing, there as here.

_000:
    WaitButtonABTime 15
    // {0}’s type changed to {2}!
    PrintMessage msg_0197_00641, TAG_NICKNAME_ABILITY_TYPE, BATTLER_CATEGORY_MSG_BATTLER_TEMP, BATTLER_CATEGORY_MSG_BATTLER_TEMP, BATTLER_CATEGORY_MSG_TEMP
    Wait
    WaitButtonABTime 30
    End
