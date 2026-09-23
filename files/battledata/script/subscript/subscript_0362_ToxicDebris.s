    .include "macros/btlcmd.inc"

    .data

// The layer itself is laid in C, where the two-layer cap lives; this only
// says so. There is no toxic spikes animation to play outside the move.
_000:
    WaitButtonABTime 15
    AddEntryHazardToQueue BATTLER_CATEGORY_ATTACKER, HAZARD_IDX_TOXIC_SPIKES
    // Poison spikes were scattered all around your team’s feet!
    PrintMessage msg_0197_01063, TAG_NONE_SIDE, BATTLER_CATEGORY_ATTACKER
    Wait 
    WaitButtonABTime 30
    End 
