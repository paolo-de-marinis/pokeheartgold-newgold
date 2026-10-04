    .include "macros/btlcmd.inc"

    .data

_000:
    PrintAttackMessage 
    Wait 
    WaitButtonABTime 15
    // {0} bounced the {1} back! -- {0} the Pokemon sending it back, as
    // hg-engine's subscript 139 has it (the text is hg-engine's; retail's,
    // "{0}'s {1} was bounced back by Magic Coat!", named the move's user)
    PrintMessage msg_0197_00574, TAG_NICKNAME_MOVE, BATTLER_CATEGORY_DEFENDER, BATTLER_CATEGORY_ATTACKER
    Wait 
    WaitButtonABTime 30
    MagicCoat 
    UpdateVar OPCODE_FLAG_OFF, BSCRIPT_VAR_BATTLE_STATUS, BATTLE_STATUS_MOVE_ANIMATIONS_OFF
    End 
