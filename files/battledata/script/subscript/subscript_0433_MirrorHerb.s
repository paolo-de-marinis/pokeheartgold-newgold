    .include "macros/btlcmd.inc"

    .data

// A Mirror Herb copying the stat stages the other side has just gained.
// CheckUseHeldItem has already written them onto the holder, who is in
// MSG_TEMP with the herb in ITEM_TEMP, and put the rise's animation in
// TEMP_DATA -- a drop's for a Contrary holder; this shows it, says it and spends the
// herb, as the White Herb's subscript 211 does for the stages it puts back --
// but removed outright, not through the Pluck check, which asks the attacker's
// flag and the holder need not be the attacker.

_000:
    PlayBattleAnimation BATTLER_CATEGORY_MSG_TEMP, BATTLE_ANIMATION_HELD_ITEM
    Wait 
    PlayBattleAnimationFromVar BATTLER_CATEGORY_MSG_TEMP, BSCRIPT_VAR_TEMP_DATA
    Wait 
    // {0} used its {1} to mirror its opponent’s stat changes!
    PrintMessage msg_0197_01824, TAG_NICKNAME_ITEM, BATTLER_CATEGORY_MSG_TEMP, BATTLER_CATEGORY_MSG_TEMP
    Wait 
    WaitButtonABTime 30
    RemoveItem BATTLER_CATEGORY_MSG_TEMP
    End 
