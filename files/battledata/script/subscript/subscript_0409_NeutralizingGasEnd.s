    .include "macros/btlcmd.inc"

    .data

// The last Pokemon giving off Neutralizing Gas has gone, or lost the ability.
// What it held back speaks after this, from the switch-in check that ran it.

_000:
    // The effects of the neutralizing gas wore off!
    PrintMessage msg_0197_01801, TAG_NONE
    Wait
    WaitButtonABTime 30
    End
