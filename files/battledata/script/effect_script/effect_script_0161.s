    .include "macros/btlcmd.inc"

    .data

// With Parental Bond both strikes have the stockpile's power, and it wears
// off once. The reference's script leaves it to the second strike, so a first
// strike that ended the move kept it; here the first strike spends it and the
// second keeps the power the first worked out (ctx->movePower lasts the whole
// move).
_000:
    GotoIfSecondHitOfParentalBond _STRIKE
    CompareMonDataToValue OPCODE_EQU, BATTLER_CATEGORY_ATTACKER, BMON_DATA_STOCKPILE_COUNT, 0, _064
    UpdateMonDataFromVar OPCODE_GET, BATTLER_CATEGORY_ATTACKER, BMON_DATA_STOCKPILE_COUNT, BSCRIPT_VAR_MOVE_POWER
    UpdateVar OPCODE_MUL, BSCRIPT_VAR_MOVE_POWER, 100
    UpdateVar OPCODE_FLAG_ON, BSCRIPT_VAR_BATTLE_STATUS, BATTLE_STATUS_MISS_MESSAGE
    UpdateMonData OPCODE_SET, BATTLER_CATEGORY_ATTACKER, BMON_DATA_STOCKPILE_COUNT, 0
    UpdateMonDataFromVar OPCODE_GET, BATTLER_CATEGORY_ATTACKER, BMON_DATA_STOCKPILE_DEF_BOOSTS, BSCRIPT_VAR_CALC_TEMP
    UpdateMonDataFromVar OPCODE_SUB_TO_ZERO, BATTLER_CATEGORY_ATTACKER, BMON_DATA_STAT_CHANGE_DEF, BSCRIPT_VAR_CALC_TEMP
    UpdateMonDataFromVar OPCODE_GET, BATTLER_CATEGORY_ATTACKER, BMON_DATA_STOCKPILE_SPDEF_BOOSTS, BSCRIPT_VAR_CALC_TEMP
    UpdateMonDataFromVar OPCODE_SUB_TO_ZERO, BATTLER_CATEGORY_ATTACKER, BMON_DATA_STAT_CHANGE_SPDEF, BSCRIPT_VAR_CALC_TEMP
    UpdateMonData OPCODE_SET, BATTLER_CATEGORY_ATTACKER, BMON_DATA_STOCKPILE_DEF_BOOSTS, 0
    UpdateMonData OPCODE_SET, BATTLER_CATEGORY_ATTACKER, BMON_DATA_STOCKPILE_SPDEF_BOOSTS, 0
    // {0}’s stockpiled effect wore off!
    BufferMessage msg_0197_00994, TAG_NICKNAME, BATTLER_CATEGORY_ATTACKER
    UpdateVar OPCODE_SET, BSCRIPT_VAR_SIDE_EFFECT_FLAGS_INDIRECT, MOVE_SIDE_EFFECT_ON_HIT|MOVE_SUBSCRIPT_PTR_PRINT_MESSAGE_AND_PLAY_ANIMATION

_STRIKE:
    CalcCrit 
    // Rolled like any other hit from Generation V on, as the reference's
    // script has it; HeartGold's CalcMaxDamage left the roll out.
    CalcDamage 
    End 

_064:
    PrintAttackMessage 
    Wait 
    WaitButtonABTime 30
    // But it failed to spit up a thing!
    PrintMessage msg_0197_00814, TAG_NONE
    Wait 
    WaitButtonABTime 30
    UpdateVar OPCODE_FLAG_ON, BSCRIPT_VAR_MOVE_STATUS_FLAGS, MOVE_STATUS_NO_MORE_WORK
    End 
