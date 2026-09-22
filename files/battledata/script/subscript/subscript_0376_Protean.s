    .include "macros/btlcmd.inc"

    .data

// Protean and Libero. The three type slots are already written by the time
// this runs -- a script cannot reach the third one -- so all that is left is
// to say so. Color Change prints the same line at the defender.
_000:
    // {0}'s {1} made it the {2} type!
    PrintMessage msg_0197_00641, TAG_NICKNAME_ABILITY_TYPE, BATTLER_CATEGORY_ATTACKER, BATTLER_CATEGORY_ATTACKER, BATTLER_CATEGORY_MSG_TEMP
    Wait
    WaitButtonABTime 30
    End
