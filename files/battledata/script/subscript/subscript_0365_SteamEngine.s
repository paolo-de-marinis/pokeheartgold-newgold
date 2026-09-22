    .include "macros/btlcmd.inc"

    .data

// Six stages at once, which the stat-change command cannot express: it decodes
// one and two only. Motor Drive raises its one stage the same way, and the add
// clamps at the ceiling, so the C only has to refuse when there is no room at
// all.
_000:
    WaitButtonABTime 15
    PlayBattleAnimation BATTLER_CATEGORY_DEFENDER, BATTLE_ANIMATION_STAT_BOOST
    Wait 
    UpdateMonData OPCODE_ADD, BATTLER_CATEGORY_DEFENDER, BMON_DATA_STAT_CHANGE_SPEED, 6
    UpdateVar OPCODE_SET, BSCRIPT_VAR_MESSAGE, STAT_SPEED
    // {0}’s {1} raised its {2}!
    PrintMessage msg_0197_00622, TAG_NICKNAME_ABILITY_STAT, BATTLER_CATEGORY_DEFENDER, BATTLER_CATEGORY_DEFENDER, BATTLER_CATEGORY_MSG_TEMP
    Wait 
    WaitButtonABTime 30
    End 
