    .include "macros/btlcmd.inc"

    .data

// Powder

_000:
    PrintAttackMessage 
    Wait 
    PlayMoveAnimation BATTLER_CATEGORY_ATTACKER
    Wait
    SetMoveConditionFlag MOVE_POWDER, BATTLER_CATEGORY_DEFENDER
    // {0} is covered in powder!
    PrintMessage msg_0197_01613, TAG_NICKNAME, BATTLER_CATEGORY_DEFENDER
    Wait 
    WaitButtonABTime 30
    End
