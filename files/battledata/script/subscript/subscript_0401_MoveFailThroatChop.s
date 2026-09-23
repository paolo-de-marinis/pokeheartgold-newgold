    .include "macros/btlcmd.inc"
    .data
// Throat Chop: the sound move is refused.
_000:
    // The effects of Throat Chop prevent {0} from using certain moves!
    PrintMessage msg_0197_01619, TAG_NICKNAME, BATTLER_CATEGORY_ATTACKER
    Wait
    WaitButtonABTime 30
    End
