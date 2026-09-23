    .include "macros/btlcmd.inc"

    .data

// Imported from the reference. Two things it asks for that this game has not
// got, and why the lines are not here:
//
//  - PlayBattleAnimation BATTLE_ANIMATION_*_TERRAIN. Those four are entries
//    the reference added to the status-effect animation table; this game's
//    table stops at BATTLE_ANIMATION_DAMAGE_INGRAIN, so asking for one reads
//    past the end of it. The terrain is announced by its message alone until
//    the animations exist.
//  - ChangePermanentBackground, which is a no-op in this game and was already
//    absent from this file.

_000:
    CompareVarToValue OPCODE_NEQ, BSCRIPT_VAR_SIDE_EFFECT_TYPE, SIDE_EFFECT_TYPE_ABILITY, _skipAbilityPopup
    AbilityPopup BATTLER_CATEGORY_MSG_TEMP, -1
    CheckAbility CHECK_OPCODE_HAVE, BATTLER_CATEGORY_MSG_TEMP, ABILITY_HADRON_ENGINE, _HadronEngineTerrain
_skipAbilityPopup:
    GotoIfTerrainOverlayIsType GRASSY_TERRAIN, _019
    GotoIfTerrainOverlayIsType MISTY_TERRAIN, _024
    GotoIfTerrainOverlayIsType ELECTRIC_TERRAIN, _029
    GotoIfTerrainOverlayIsType PSYCHIC_TERRAIN, _034
    GoTo _049

_HadronEngineTerrain:
    Wait
    // {0} turned the ground into Electric Terrain, energizing its futuristic engine!
    PrintMessage msg_0197_01701, TAG_NICKNAME, BATTLER_CATEGORY_MSG_TEMP
    Wait
    WaitButtonABTime 30
    GoTo _ActivateParadoxTerrainAbility

_019:
    Wait
    // Grass grew to cover the battlefield!
    PrintMessage msg_0197_01388, TAG_NONE
    GoTo _ResetParadoxTerrainAbility

_024:
    Wait
    // Mist swirled about the battlefield!
    PrintMessage msg_0197_01390, TAG_NONE
    GoTo _ResetParadoxTerrainAbility

_029:
    Wait
    // An electric current ran across the battlefield!
    PrintMessage msg_0197_01392, TAG_NONE
    Wait
    WaitButtonABTime 30
    GoTo _ActivateParadoxTerrainAbility

_034:
    Wait
    // The battlefield got weird!
    PrintMessage msg_0197_01394, TAG_NONE

// TODO: something weird is happening after using Terrain move rather than Surge ability

_ResetParadoxTerrainAbility:
    Wait
    WaitButtonABTime 30
    ResetParadoxAbility ABILITY_QUARK_DRIVE

// Other Terrains reach this command to activate through Booster Energy
_ActivateParadoxTerrainAbility:
    ActivateParadoxAbility ABILITY_QUARK_DRIVE

_037:
    UpdateVar OPCODE_FLAG_OFF, BSCRIPT_VAR_BATTLE_STATUS, BATTLE_STATUS_MOVE_ANIMATIONS_OFF
    End

_049:
    End
