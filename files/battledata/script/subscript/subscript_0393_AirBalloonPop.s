    .include "macros/btlcmd.inc"

    .data

// The blow that lands takes the balloon with it. RemoveItem rather than the
// Pluck check the other held-item scripts end on: this is not a Berry and
// nothing can have plucked it.
_000:
    // {0}’s {1} popped!
    PrintMessage msg_0197_01367, TAG_NICKNAME_ITEM, BATTLER_CATEGORY_MSG_TEMP, BATTLER_CATEGORY_MSG_TEMP
    Wait
    WaitButtonABTime 30
    RemoveItem BATTLER_CATEGORY_MSG_TEMP
    End
