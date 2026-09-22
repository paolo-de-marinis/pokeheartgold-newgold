    .include "macros/btlcmd.inc"

    .data

// Hadron Engine walking in onto an Electric Terrain that is already down. The
// terrain-laying case is CreateTerrainOverlay's, which has a branch of its own
// for this ability -- and an Ability popup, which this one has not got, because
// the reference's version of this script has not got one either.
//
// The reference also names the Pokemon with BATTLER_CATEGORY_ABILITY_MON, which
// the switch-in check it is called from never sets: only Orichalcum Pulse, its
// twin, writes that one down. The temporary battler is what is actually set
// here, so that is what this reads.

_000:
    // {0} used the Electric Terrain to energize its futuristic engine!
    PrintMessage msg_0197_01304, TAG_NICKNAME, BATTLER_CATEGORY_MSG_TEMP
    Wait
    WaitButtonABTime 30
    End
