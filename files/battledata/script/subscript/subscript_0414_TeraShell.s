    .include "macros/btlcmd.inc"

    .data

// Tera Shell taking a move at full HP, which the reference has no script for:
// the later games' line, before the damage lands.
_000:
    // {0} made its shell gleam! It’s distorting type matchups!
    PrintMessage msg_0197_01805, TAG_NICKNAME, BATTLER_CATEGORY_MSG_TEMP
    Wait
    WaitButtonABTime 30
    End
