    .include "macros/btlcmd.inc"

    .data

// The berry has already been eaten; this is the cheek emptying afterwards.
// It heals whoever BSCRIPT_VAR_MSG_BATTLER_TEMP names rather than the
// defender, because a berry can go down at moments when nobody is defending.
_000:
    WaitButtonABTime 15
    UpdateVar OPCODE_FLAG_ON, BSCRIPT_VAR_BATTLE_STATUS, BATTLE_STATUS_NO_BLINK
    Call BATTLE_SUBSCRIPT_UPDATE_HP
    // {0} restored HP using its {1}!
    PrintMessage msg_0197_00635, TAG_NICKNAME_ABILITY, BATTLER_CATEGORY_MSG_TEMP, BATTLER_CATEGORY_MSG_TEMP
    Wait 
    WaitButtonABTime 30
    End 
