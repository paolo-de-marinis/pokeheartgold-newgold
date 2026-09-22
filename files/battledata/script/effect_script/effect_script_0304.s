    .include "macros/btlcmd.inc"

    .data

// Psyblade. The reference sets the power to a flat 120 rather than scaling the
// 80 in the move table, so the value is written out here. Nothing asks whether
// the user is standing on the current: that is the reference's version of the
// move, not an omission.
_000:
    GotoIfTerrainOverlayIsType ELECTRIC_TERRAIN, _Charged
    GoTo _Hit

_Charged:
    UpdateVar OPCODE_SET, BSCRIPT_VAR_MOVE_POWER, 120

_Hit:
    CalcCrit
    CalcDamage
    End
