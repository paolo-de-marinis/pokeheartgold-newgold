    .include "macros/btlcmd.inc"

    .data

// Run when the five turns are up, and by anything that sweeps the field clear.
// The terrain is cleared first and announced afterwards, so the message names
// what has just gone rather than what is still there.
//
// The reference also repaints the battle background here. That command is a
// no-op in this game -- the background is chosen when the battle starts and
// cannot be changed partway through -- so the line is left out.
_000:
    GotoIfTerrainOverlayIsType GRASSY_TERRAIN, _GrassyTerrain
    GotoIfTerrainOverlayIsType MISTY_TERRAIN, _MistyTerrain
    GotoIfTerrainOverlayIsType ELECTRIC_TERRAIN, _ElectricTerrain
    GotoIfTerrainOverlayIsType PSYCHIC_TERRAIN, _PsychicTerrain
    GoTo _End

_GrassyTerrain:
    UpdateTerrainOverlay TRUE, _End
    // The grass disappeared from the battlefield.
    PrintMessage msg_0197_01285, TAG_NONE
    GoTo _AfterMessage

_MistyTerrain:
    UpdateTerrainOverlay TRUE, _End
    // The mist disappeared from the battlefield.
    PrintMessage msg_0197_01287, TAG_NONE
    GoTo _AfterMessage

_ElectricTerrain:
    UpdateTerrainOverlay TRUE, _End
    // The electricity disappeared from the battlefield.
    PrintMessage msg_0197_01289, TAG_NONE
    ResetParadoxAbility ABILITY_QUARK_DRIVE
    GoTo _AfterMessage

_PsychicTerrain:
    UpdateTerrainOverlay TRUE, _End
    // The weirdness disappeared from the battlefield.
    PrintMessage msg_0197_01291, TAG_NONE

_AfterMessage:
    Wait
    WaitButtonABTime 30

_End:
    End
