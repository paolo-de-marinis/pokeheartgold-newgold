    .include "macros/btlcmd.inc"

    .data

// Supreme Overlord coming in with fallen to count. The reference gives the
// ability no effect and no script; this is the later games' line, and the
// count it stands for is already kept by the time this runs.

_000:
    WaitButtonABTime 15
    // {0} gained strength from the fallen!
    PrintMessage msg_0197_01811, TAG_NICKNAME, BATTLER_CATEGORY_MSG_BATTLER_TEMP
    Wait
    WaitButtonABTime 30
    End
