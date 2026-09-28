    .include "macros/btlcmd.inc"

    .data

// Run when the five turns are up, and by anything that sweeps the field clear.
// The terrain is cleared first and announced afterwards, so the message names
// what has just gone rather than what is still there.
// The battle's own background, and its platforms, come back as it goes.
_000:
    GotoIfTerrainOverlayIsType GRASSY_TERRAIN, _GrassyTerrain
    GotoIfTerrainOverlayIsType MISTY_TERRAIN, _MistyTerrain
    GotoIfTerrainOverlayIsType ELECTRIC_TERRAIN, _ElectricTerrain
    GotoIfTerrainOverlayIsType PSYCHIC_TERRAIN, _PsychicTerrain
    GoTo _End

_GrassyTerrain:
    UpdateTerrainOverlay TRUE, _End
    ChangePermanentBackground BATTLE_BG_CURRENT, TERRAIN_CURRENT
    Wait
    // The grass disappeared from the battlefield.
    PrintMessage msg_0197_01389, TAG_NONE
    GoTo _AfterMessage

_MistyTerrain:
    UpdateTerrainOverlay TRUE, _End
    ChangePermanentBackground BATTLE_BG_CURRENT, TERRAIN_CURRENT
    Wait
    // The mist disappeared from the battlefield.
    PrintMessage msg_0197_01391, TAG_NONE
    GoTo _AfterMessage

_ElectricTerrain:
    UpdateTerrainOverlay TRUE, _End
    ChangePermanentBackground BATTLE_BG_CURRENT, TERRAIN_CURRENT
    Wait
    // The electricity disappeared from the battlefield.
    PrintMessage msg_0197_01393, TAG_NONE
    ResetParadoxAbility ABILITY_QUARK_DRIVE
    GoTo _AfterMessage

_PsychicTerrain:
    UpdateTerrainOverlay TRUE, _End
    ChangePermanentBackground BATTLE_BG_CURRENT, TERRAIN_CURRENT
    Wait
    // The weirdness disappeared from the battlefield.
    PrintMessage msg_0197_01395, TAG_NONE

_AfterMessage:
    Wait
    WaitButtonABTime 30

_End:
    End
