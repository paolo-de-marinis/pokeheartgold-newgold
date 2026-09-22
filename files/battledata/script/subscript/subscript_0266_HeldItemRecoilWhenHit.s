    .include "macros/btlcmd.inc"

    .data

_000:
    CompareMonDataToValue OPCODE_EQU, BATTLER_CATEGORY_DEFENDER, BMON_DATA_HP, 0, _009
    PlayBattleAnimation BATTLER_CATEGORY_DEFENDER, BATTLE_ANIMATION_HELD_ITEM
    Wait 

_009:
    UpdateVar OPCODE_FLAG_ON, BSCRIPT_VAR_BATTLE_STATUS, BATTLE_STATUS_NO_BLINK
    UpdateVarFromVar OPCODE_SET, BSCRIPT_VAR_MSG_BATTLER_TEMP, BSCRIPT_VAR_BATTLER_ATTACKER
    Call BATTLE_SUBSCRIPT_UPDATE_HP
    // {0} is hurt by {1}’s {2}!
    PrintMessage msg_0197_01160, TAG_NICKNAME_NICKNAME_ITEM, BATTLER_CATEGORY_ATTACKER, BATTLER_CATEGORY_DEFENDER, BATTLER_CATEGORY_DEFENDER
    Wait 
    WaitButtonABTime 30
    // A Jaboca or a Rowap Berry is eaten doing this; a Rocky Helmet is worn
    // and stays on. The reference spends the same script on all three and
    // names the helmet here rather than write a second copy of it.
    CompareMonDataToValue OPCODE_EQU, BATTLER_CATEGORY_DEFENDER, BMON_DATA_HELD_ITEM, ITEM_ROCKY_HELMET, _END
    RemoveItem BATTLER_CATEGORY_DEFENDER

_END:
    End 
