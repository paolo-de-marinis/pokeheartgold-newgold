    .include "macros/btlcmd.inc"

    .data

// Cud Chew bringing a Berry back up at the end of the turn after it was eaten,
// and eating it again. The reference declares the ability and nothing reads
// it; this is the later games' ability. Pluck's routine has already worked out
// what the Berry does for this Pokemon, whatever the moment, and left that
// script in TEMP_DATA, or 0 for a Berry with nothing to do; it has also made
// this Pokemon the attacker and raised its pluck flag, so the Berry's script
// does not take whatever it holds now.

_000:
    // {0} ate its {1} again!
    PrintMessage msg_0197_01802, TAG_NICKNAME_ITEM, BATTLER_CATEGORY_MSG_BATTLER_TEMP, BATTLER_CATEGORY_MSG_TEMP
    Wait
    WaitButtonABTime 30
    CompareVarToValue OPCODE_EQU, BSCRIPT_VAR_TEMP_DATA, 0, _done
    CallFromVar BSCRIPT_VAR_TEMP_DATA

_done:
    UpdateVar OPCODE_FLAG_OFF, BSCRIPT_VAR_ATTACKER_SELF_TURN_STATUS_FLAGS, SELF_TURN_FLAG_PLUCK_BERRY
    End
