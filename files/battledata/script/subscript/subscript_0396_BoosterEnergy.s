    .include "macros/btlcmd.inc"

    .data

// A Booster Energy switching a Paradox ability on where the sun or the
// Electric Terrain would have. Which stat it raised was picked out in
// BattleContext_ActivateParadoxAbility and left in the temporary message
// variable, the same way the weather's script reads it.
//
// The "was used up" line is skipped in a link battle, which is the reference's
// own condition and the one the other consumable scripts here use.

_000:
    PlayBattleAnimation BATTLER_CATEGORY_MSG_BATTLER_TEMP, BATTLE_ANIMATION_HELD_ITEM
    Wait
    CompareVarToValue OPCODE_FLAG_SET, BSCRIPT_VAR_BATTLE_TYPE, BATTLE_TYPE_LINK, _Activated
    // The {0} was used up...
    PrintMessage msg_0197_01679, TAG_ITEM, BATTLER_CATEGORY_MSG_BATTLER_TEMP
    Wait
    WaitButtonABTime 30

_Activated:
    // {0} used the {2} to activate {1}!
    PrintMessage msg_0197_01680, TAG_NICKNAME_ABILITY_ITEM, BATTLER_CATEGORY_MSG_BATTLER_TEMP, BATTLER_CATEGORY_MSG_BATTLER_TEMP, BATTLER_CATEGORY_MSG_BATTLER_TEMP
    RemoveItem BATTLER_CATEGORY_MSG_BATTLER_TEMP
    Wait
    WaitButtonABTime 30
    // {0}'s {1} was heightened!
    PrintMessage msg_0197_01689, TAG_NICKNAME_STAT, BATTLER_CATEGORY_MSG_BATTLER_TEMP, BATTLER_CATEGORY_MSG_TEMP
    Wait
    WaitButtonABTime 30
    End
