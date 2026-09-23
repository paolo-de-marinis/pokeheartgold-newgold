    .include "macros/btlcmd.inc"

    .data

// Eerie Spell's added effect: three PP off the move the target used last, if
// it has one with PP left (Pokemon Central, Inquietantesimo). TrySpite takes
// the three and leaves the move and the count for Spite's line.
_000:
    TrySpite _END
    // It reduced the PP of {0}'s {1} by {2}!
    PrintMessage msg_0197_00398, TAG_NICKNAME_MOVE_NUMBER, BATTLER_CATEGORY_DEFENDER, BATTLER_CATEGORY_MSG_TEMP, BATTLER_CATEGORY_MSG_TEMP
    Wait
    WaitButtonABTime 30

_END:
    End
