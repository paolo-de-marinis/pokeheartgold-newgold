    .include "macros/btlcmd.inc"

    .data

_000:
    PrintAttackMessage
    Wait
    WaitButtonABTime 30
    // {0} surrounds itself with a protective mist!
    PrintMessage msg_0197_01496, TAG_NICKNAME, BATTLER_CATEGORY_DEFENDER
    Wait
    WaitButtonABTime 30
    End
