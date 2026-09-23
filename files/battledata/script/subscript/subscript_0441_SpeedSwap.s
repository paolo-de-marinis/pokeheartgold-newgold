    .include "macros/btlcmd.inc"

    .data

// Speed Swap: the user's Speed and the target's change places, the stats and
// not their stages, which stay where they are (Pokemon Central,
// Velociscambio).
_000:
    UpdateMonDataFromVar OPCODE_GET, BATTLER_CATEGORY_ATTACKER, BMON_DATA_SPEED, BSCRIPT_VAR_CALC_TEMP
    UpdateMonDataFromVar OPCODE_GET, BATTLER_CATEGORY_DEFENDER, BMON_DATA_SPEED, BSCRIPT_VAR_TEMP_DATA
    UpdateMonDataFromVar OPCODE_SET, BATTLER_CATEGORY_ATTACKER, BMON_DATA_SPEED, BSCRIPT_VAR_TEMP_DATA
    UpdateMonDataFromVar OPCODE_SET, BATTLER_CATEGORY_DEFENDER, BMON_DATA_SPEED, BSCRIPT_VAR_CALC_TEMP
    // {0} switched Speed with its target!
    PrintMessage msg_0197_01831, TAG_NICKNAME, BATTLER_CATEGORY_ATTACKER
    Wait
    WaitButtonABTime 30
    End
