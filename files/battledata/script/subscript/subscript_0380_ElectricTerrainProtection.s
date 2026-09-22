    .include "macros/btlcmd.inc"

    .data

_000:
    PrintAttackMessage
    Wait
    WaitButtonABTime 30
    // {0} is protected by the Electric Terrain!
    PrintMessage msg_0197_01298, TAG_NICKNAME, BATTLER_CATEGORY_DEFENDER
    Wait
    WaitButtonABTime 30
    End
