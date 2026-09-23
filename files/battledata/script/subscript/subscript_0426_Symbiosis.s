    .include "macros/btlcmd.inc"

    .data

// Symbiosis handing the holder's item to the partner that used its own up.
// The reference gives the ability no effect and no script; this is the later
// games' line, and the item has already changed hands by the time this runs.

_000:
    WaitButtonABTime 15
    // {0} shared its {1} with {2}!
    PrintMessage msg_0197_01817, TAG_NICKNAME_ITEM_NICKNAME, BATTLER_CATEGORY_MSG_BATTLER_TEMP, BATTLER_CATEGORY_MSG_TEMP, BATTLER_RELATIVE_ALLY|BATTLER_CATEGORY_MSG_BATTLER_TEMP
    Wait
    WaitButtonABTime 30
    End
