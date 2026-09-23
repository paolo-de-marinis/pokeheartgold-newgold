    .include "macros/btlcmd.inc"

    .data

// Neutralizing Gas coming out. The reference gives the ability no effect and
// no script; this is the later games' line, about the field and not the
// Pokemon, since this game has no ability popup to name it.

_000:
    WaitButtonABTime 15
    // Neutralizing gas filled the area!
    PrintMessage msg_0197_01800, TAG_NONE
    Wait
    WaitButtonABTime 30
    End
