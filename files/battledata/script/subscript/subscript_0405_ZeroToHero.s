    .include "macros/btlcmd.inc"

    .data

// A Palafin back in its Hero Form says so, once a battle: the reference's
// subscript 516, without the ability banner this game has not got.
_000:
    // {0} underwent a heroic transformation!
    PrintMessage msg_0197_01780, TAG_NICKNAME, BATTLER_CATEGORY_MSG_TEMP
    Wait 
    WaitButtonABTime 30
    End 
