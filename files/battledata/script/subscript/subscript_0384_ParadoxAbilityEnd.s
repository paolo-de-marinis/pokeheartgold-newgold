    .include "macros/btlcmd.inc"

    .data

// The sun faded or the current went out, and the stat the ability had raised
// goes back down. ResetParadoxAbility has already cleared it and named the
// Pokemon.

_000:
    // The effects of {0}'s {1} wore off!
    PrintMessage msg_0197_01316, TAG_NICKNAME_ABILITY, BATTLER_CATEGORY_MSG_BATTLER_TEMP, BATTLER_CATEGORY_MSG_BATTLER_TEMP
    Wait
    WaitButtonABTime 30
    End
