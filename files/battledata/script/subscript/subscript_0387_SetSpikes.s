    .include "macros/btlcmd.inc"

    .data

// The Spikes half of Ceaseless Edge. TrySpikes is the same command effect
// script 112 uses, so the third layer refuses here too; it just refuses
// quietly, because the move has already done its damage and has nothing left
// to fail at.
_000:
    TrySpikes _END
    AddEntryHazardToQueue BATTLER_CATEGORY_DEFENDER, HAZARD_IDX_SPIKES
    // Spikes were scattered all around your team’s feet!
    PrintMessage msg_0197_00427, TAG_NONE_SIDE, BATTLER_CATEGORY_ATTACKER_ENEMY
    Wait
    WaitButtonABTime 30

_END:
    End
