    .include "macros/btlcmd.inc"

    .data

// Delta Stream's winds have taken a Flying-type weakness out of the move
// against this target. The reference's subscript 372, which runs before the
// move and prints the attack message first; here the move has announced
// itself already.
_000:
    // The mysterious strong winds weakened the attack!
    PrintMessage msg_0197_01451, TAG_NONE
    Wait
    WaitButtonABTime 30
    End
