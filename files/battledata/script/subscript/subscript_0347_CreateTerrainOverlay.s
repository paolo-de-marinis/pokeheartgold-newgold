    .include "macros/btlcmd.inc"

    .data

// Imported from the reference. Each terrain draws its own background, with no
// platforms, before its line: the reference draws it with
// PlayBattleAnimation BATTLE_ANIMATION_*_TERRAIN, entries it added to the
// status-effect animation table whose one command is its background change,
// and which the Battle Scene option turns off with the rest. The background is
// the field's state as long as the terrain lasts, not an effect, as the
// substitute's sprite is (PlayBattleAnimation's statuses 15, 16, 25 and 26),
// and it goes with the terrain whatever the option says in the reference
// too (HandleTerrainEnd): so it is drawn here by the command itself.

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
    ChangePermanentBackground BATTLE_BG_ELECTRIC_TERRAIN, TERRAIN_ELECTRIC_TERRAIN
    Wait
    // {0} turned the ground into Electric Terrain, energizing its futuristic engine!
    PrintMessage msg_0197_01701, TAG_NICKNAME, BATTLER_CATEGORY_MSG_TEMP
    Wait
    WaitButtonABTime 30
    GoTo _ActivateParadoxTerrainAbility

_019:
    ChangePermanentBackground BATTLE_BG_GRASSY_TERRAIN, TERRAIN_GRASSY_TERRAIN
    Wait
    // Grass grew to cover the battlefield!
    PrintMessage msg_0197_01388, TAG_NONE
    GoTo _ResetParadoxTerrainAbility

_024:
    ChangePermanentBackground BATTLE_BG_MISTY_TERRAIN, TERRAIN_MISTY_TERRAIN
    Wait
    // Mist swirled about the battlefield!
    PrintMessage msg_0197_01390, TAG_NONE
    GoTo _ResetParadoxTerrainAbility

_029:
    ChangePermanentBackground BATTLE_BG_ELECTRIC_TERRAIN, TERRAIN_ELECTRIC_TERRAIN
    Wait
    // An electric current ran across the battlefield!
    PrintMessage msg_0197_01392, TAG_NONE
    Wait
    WaitButtonABTime 30
    GoTo _ActivateParadoxTerrainAbility

_034:
    ChangePermanentBackground BATTLE_BG_PSYCHIC_TERRAIN, TERRAIN_PSYCHIC_TERRAIN
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
