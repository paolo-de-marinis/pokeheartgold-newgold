    .include "macros/btlcmd.inc"

    .data

// Steel Roller and Ice Spinner: hit, then sweep the terrain away. The sweep is
// queued as a side effect rather than done here, because an effect script runs
// before the damage does and the terrain has to go afterwards. CHECK_HP on the
// attacker is the reference's own guard -- a user that died to the hit does not
// get to finish tearing up the ground.
//
// Steel Roller alone fails when there is nothing to tear up. The two moves
// share this effect, so the move has to be named to tell them apart.
_000:
    CompareVarToValue OPCODE_NEQ, BSCRIPT_VAR_MOVE_NO_CUR, MOVE_STEEL_ROLLER, _Hit
    GotoIfTerrainOverlayIsType TERRAIN_NONE, _NoTerrain

_Hit:
    UpdateVar OPCODE_SET, BSCRIPT_VAR_SIDE_EFFECT_FLAGS_INDIRECT, MOVE_SIDE_EFFECT_CHECK_HP|MOVE_SIDE_EFFECT_TO_ATTACKER|MOVE_SUBSCRIPT_PTR_END_TERRAIN
    CalcCrit
    CalcDamage
    End

_NoTerrain:
    PrintAttackMessage
    Wait
    WaitButtonABTime 30
    Call BATTLE_SUBSCRIPT_BUT_IT_FAILED
    End
