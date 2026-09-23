    .include "macros/btlcmd.inc"

    .data

_000:
    PrintAttackMessage 
    Wait 
    WaitButtonABTime 30
    ChangeExecutionOrderPriority BATTLER_CATEGORY_DEFENDER, EXECUTION_ORDER_AFTER_YOU, _018
    PlayMoveAnimation BATTLER_CATEGORY_ATTACKER
    Wait 
    // {0} took the kind offer!
    PrintMessage msg_0197_01430, TAG_NICKNAME, BATTLER_CATEGORY_DEFENDER
    Wait 
    WaitButtonABTime 30
    End 

_018:
    UpdateVar OPCODE_FLAG_ON, BSCRIPT_VAR_MOVE_STATUS_FLAGS, MOVE_STATUS_FAILED
    End 
