    .include "macros/btlcmd.inc"

    .data

// The two abilities trade places. Skill Swap's middle four lines, and a line
// for the one that has just been given something new: the reference prints
// nothing here (its ability popup says it), so the line is this port's own.
_000:
    WaitButtonABTime 15
    UpdateMonDataFromVar OPCODE_GET, BATTLER_CATEGORY_ATTACKER, BMON_DATA_ABILITY, BSCRIPT_VAR_CALC_TEMP
    UpdateMonDataFromVar OPCODE_GET, BATTLER_CATEGORY_DEFENDER, BMON_DATA_ABILITY, BSCRIPT_VAR_TEMP_DATA
    UpdateMonDataFromVar OPCODE_SET, BATTLER_CATEGORY_ATTACKER, BMON_DATA_ABILITY, BSCRIPT_VAR_TEMP_DATA
    UpdateMonDataFromVar OPCODE_SET, BATTLER_CATEGORY_DEFENDER, BMON_DATA_ABILITY, BSCRIPT_VAR_CALC_TEMP
    // {0}’s Ability became {1}!
    PrintMessage msg_0197_01787, TAG_NICKNAME_ABILITY, BATTLER_CATEGORY_ATTACKER, BATTLER_CATEGORY_ATTACKER
    Wait 
    WaitButtonABTime 30
    End 
