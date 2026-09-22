    .include "macros/btlcmd.inc"

    .data

// Clear Smog. ClearSmog puts the target's stages back to where they started
// and leaves everybody else's alone, which is what separates this from Haze.
_000:
    ClearSmog 
    // All stat changes were eliminated!
    PrintMessage msg_0197_00817, TAG_NONE
    Wait 
    WaitButtonABTime 30
    End 
