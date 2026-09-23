    .include "macros/btlcmd.inc"

    .data

// Reflect Type: the user takes the target's types, all three, as the target
// has them now -- an Arceus's plate type, a type Forest's Curse or
// Trick-or-Treat added (Pokemon Central, Riflettipo).
_000:
    UpdateMonDataFromVar OPCODE_GET, BATTLER_CATEGORY_DEFENDER, BMON_DATA_TYPE_1, BSCRIPT_VAR_CALC_TEMP
    UpdateMonDataFromVar OPCODE_SET, BATTLER_CATEGORY_ATTACKER, BMON_DATA_TYPE_1, BSCRIPT_VAR_CALC_TEMP
    UpdateMonDataFromVar OPCODE_GET, BATTLER_CATEGORY_DEFENDER, BMON_DATA_TYPE_2, BSCRIPT_VAR_CALC_TEMP
    UpdateMonDataFromVar OPCODE_SET, BATTLER_CATEGORY_ATTACKER, BMON_DATA_TYPE_2, BSCRIPT_VAR_CALC_TEMP
    UpdateMonDataFromVar OPCODE_GET, BATTLER_CATEGORY_DEFENDER, BMON_DATA_TYPE_3, BSCRIPT_VAR_CALC_TEMP
    UpdateMonDataFromVar OPCODE_SET, BATTLER_CATEGORY_ATTACKER, BMON_DATA_TYPE_3, BSCRIPT_VAR_CALC_TEMP
    // {0}'s type became the same as {1}'s type!
    PrintMessage msg_0197_01837, TAG_NICKNAME_NICKNAME, BATTLER_CATEGORY_ATTACKER, BATTLER_CATEGORY_DEFENDER
    Wait
    WaitButtonABTime 30
    End
