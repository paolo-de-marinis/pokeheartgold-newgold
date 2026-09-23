    .include "macros/btlcmd.inc"

    .data

// A Disguise or an Ice Face took the hit and gave way, as the reference's
// subscript 332: the form has changed by the time this runs, and this shows
// it. A busted disguise costs an eighth of the maximum HP.
_000:
    CompareMonDataToValue OPCODE_FLAG_NOT, BATTLER_CATEGORY_MSG_TEMP, BMON_DATA_STATUS2, STATUS2_SUBSTITUTE, _016
    PlayBattleAnimation BATTLER_CATEGORY_MSG_TEMP, BATTLE_ANIMATION_SUB_OUT
    Wait 
    RestoreSprite BATTLER_CATEGORY_MSG_TEMP
    Wait 
    PlayBattleAnimation BATTLER_CATEGORY_MSG_TEMP, BATTLE_ANIMATION_SUB_IN
    Wait 

_016:
    CompareMonDataToValue OPCODE_EQU, BATTLER_CATEGORY_MSG_TEMP, BMON_DATA_ABILITY, ABILITY_ICE_FACE, _SKIP_DECOY
    // Its disguise served it as a decoy!
    PrintMessage msg_0197_01131, TAG_NONE
    Wait 
    WaitButtonABTime 30

_SKIP_DECOY:
    PlaySound BATTLER_CATEGORY_MSG_TEMP, SEQ_SE_DP_W100
    SetMosaic BATTLER_CATEGORY_MSG_TEMP, 8, 1
    Wait 
    ChangeForm BATTLER_CATEGORY_MSG_TEMP
    PlaySound BATTLER_CATEGORY_MSG_TEMP, SEQ_SE_DP_W107
    SetMosaic BATTLER_CATEGORY_MSG_TEMP, 0, 1
    Wait 
    CompareMonDataToValue OPCODE_EQU, BATTLER_CATEGORY_MSG_TEMP, BMON_DATA_ABILITY, ABILITY_ICE_FACE, _ICE_FACE
    // {0}’s disguise was busted!
    PrintMessage msg_0197_01351, TAG_NICKNAME, BATTLER_CATEGORY_MSG_TEMP
    Wait 
    WaitButtonABTime 30
    UpdateMonDataFromVar OPCODE_GET, BATTLER_CATEGORY_MSG_TEMP, BMON_DATA_MAXHP, BSCRIPT_VAR_HP_CALC
    DivideVarByValue BSCRIPT_VAR_HP_CALC, 8
    UpdateVar OPCODE_MUL, BSCRIPT_VAR_HP_CALC, -1
    UpdateVar OPCODE_FLAG_ON, BSCRIPT_VAR_BATTLE_STATUS, BATTLE_STATUS_NO_BLINK
    GoToSubscript BATTLE_SUBSCRIPT_UPDATE_HP
    GoTo _END

_ICE_FACE:
    // {0} transformed!
    PrintMessage msg_0197_00721, TAG_NICKNAME, BATTLER_CATEGORY_MSG_TEMP
    Wait 
    WaitButtonABTime 30

_END:
    End 
