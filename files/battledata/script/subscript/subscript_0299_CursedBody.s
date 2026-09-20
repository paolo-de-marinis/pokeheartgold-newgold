    .include "macros/btlcmd.inc"

    .data

// The move is already disabled by the time this runs, so there is nothing left
// to do but say so. TryDisable could not have done it: it only ever disables
// what the defender last used, and here it is the attacker's move.
_000:
    WaitButtonABTime 15
    // {0}’s {1} was disabled!
    PrintMessage msg_0197_00366, TAG_NICKNAME_MOVE, BATTLER_CATEGORY_ATTACKER, BATTLER_CATEGORY_MSG_TEMP
    Wait 
    WaitButtonABTime 30
    End 
