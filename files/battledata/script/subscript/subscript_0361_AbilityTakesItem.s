    .include "macros/btlcmd.inc"

    .data

// One held item changes hands. Pickpocket and Magician differ only in which
// way round, so the C names the loser and the taker rather than the script
// naming the attacker and the target: the loser is the message battler,
// because that is one of the three slots an item can be read out of, and the
// taker is the side-effect one. The message goes first, while the item is
// still on the Pokemon losing it.
_000:
    WaitButtonABTime 15
    // {0} stole {1}’s {2}!
    PrintMessage msg_0197_00401, TAG_NICKNAME_NICKNAME_ITEM, BATTLER_CATEGORY_SIDE_EFFECT_MON, BATTLER_CATEGORY_MSG_BATTLER_TEMP, BATTLER_CATEGORY_MSG_BATTLER_TEMP
    Wait 
    WaitButtonABTime 30
    UpdateMonDataFromVar OPCODE_GET, BATTLER_CATEGORY_MSG_BATTLER_TEMP, BMON_DATA_HELD_ITEM, BSCRIPT_VAR_TEMP_DATA
    UpdateMonDataFromVar OPCODE_SET, BATTLER_CATEGORY_SIDE_EFFECT_MON, BMON_DATA_HELD_ITEM, BSCRIPT_VAR_TEMP_DATA
    UpdateMonData OPCODE_SET, BATTLER_CATEGORY_MSG_BATTLER_TEMP, BMON_DATA_HELD_ITEM, ITEM_NONE
    End 
