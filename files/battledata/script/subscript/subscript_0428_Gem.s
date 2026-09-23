    .include "macros/btlcmd.inc"

    .data

// A Gem spent on the move it powers, as the move connects: the attack
// message, the item's flash, the line, and the Gem is gone. The reference's
// subscript_0469_HANDLE_GEM_ACTIVATION_MESSAGE at d0380a487 is these commands;
// its message is the same row, and the item and the move are read off the
// attacker here rather than buffered.

_000:
    PrintAttackMessage 
    Wait 
    WaitButtonABTime 30
    PlayBattleAnimation BATTLER_CATEGORY_ATTACKER, BATTLE_ANIMATION_HELD_ITEM
    Wait 
    // The {0} strengthened {1}’s power!
    PrintMessage msg_0197_01570, TAG_ITEM_MOVE, BATTLER_CATEGORY_ATTACKER, BATTLER_CATEGORY_ATTACKER
    Wait 
    WaitButtonABTime 30
    RemoveItem BATTLER_CATEGORY_ATTACKER
    UpdateVar OPCODE_FLAG_OFF, BSCRIPT_VAR_BATTLE_STATUS, BATTLE_STATUS_MOVE_ANIMATIONS_OFF
    End 
