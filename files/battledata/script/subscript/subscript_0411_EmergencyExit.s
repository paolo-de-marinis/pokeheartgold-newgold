    .include "macros/btlcmd.inc"

    .data

// Emergency Exit and Wimp Out taking the Pokemon in MSG_BATTLER_TEMP off the
// field once the move that brought it to half its health is over: the
// reference's subscript 498. This game has no ability banner to show, so the
// Pokemon goes back with U-turn's line, and Natural Cure cures it on the way,
// as any switch does. TEMP_DATA is set for a wild Pokemon, which flees
// instead, as in the games: the reference has no Pokemon to send in for it
// and keeps it on the field.

_000:
    CompareVarToValue OPCODE_NEQ, BSCRIPT_VAR_TEMP_DATA, 0, _FLEE
    TryReplaceFaintedMon BATTLER_CATEGORY_MSG_BATTLER_TEMP, TRUE, _END
    UpdateVarFromVar OPCODE_SET, BSCRIPT_VAR_BATTLER_SWITCH, BSCRIPT_VAR_MSG_BATTLER_TEMP
    // {0} went back to {1}!
    PrintMessage msg_0197_01067, TAG_NICKNAME_TRNAME, BATTLER_CATEGORY_SWITCHED_MON, BATTLER_CATEGORY_SWITCHED_MON
    Wait
    WaitButtonABTime 30
    TryRestoreStatusOnSwitch BATTLER_CATEGORY_MSG_BATTLER_TEMP, _SWITCH_OUT
    UpdateMonData OPCODE_SET, BATTLER_CATEGORY_MSG_BATTLER_TEMP, BMON_DATA_STATUS, STATUS_NONE

_SWITCH_OUT:
    DeletePokemon BATTLER_CATEGORY_MSG_BATTLER_TEMP
    Wait
    HealthbarSlideOut BATTLER_CATEGORY_MSG_BATTLER_TEMP
    Wait
    GoToSubscript BATTLE_SUBSCRIPT_SHOW_PARTY_LIST

_FLEE:
    PlaySound BATTLER_CATEGORY_MSG_BATTLER_TEMP, SEQ_SE_DP_NIGERU2
    // The wild {0} fled!
    PrintGlobalMessage msg_0197_00784, TAG_NICKNAME, BATTLER_CATEGORY_MSG_BATTLER_TEMP
    Wait
    WaitButtonABTime 30
    FadeOutBattle
    Wait
    UpdateVar OPCODE_FLAG_ON, BSCRIPT_VAR_BATTLE_OUTCOME, BATTLE_RESULT_PLAYER_FLED
    IncrementGameStat BATTLER_CATEGORY_MSG_BATTLER_TEMP, BATTLER_TYPE_SOLO_ENEMY, GAME_STAT_WILD_MON_FLED

_END:
    End
