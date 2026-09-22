    .include "macros/btlcmd.inc"

    .data

// The same, for a stat taken off somebody else. The drop message names the
// attacker's ability, and the Mist and Clear Body guards ask the attacker
// too, so the holder stands in as the attacker for the length of the call.
_000:
    WaitButtonABTime 15
    UpdateVarFromVar OPCODE_SET, BSCRIPT_VAR_LAST_BATTLER_ID, BSCRIPT_VAR_BATTLER_ATTACKER
    UpdateVarFromVar OPCODE_SET, BSCRIPT_VAR_BATTLER_ATTACKER, BSCRIPT_VAR_BATTLER_TARGET
    Call BATTLE_SUBSCRIPT_UPDATE_STAT_STAGE
    UpdateVarFromVar OPCODE_SET, BSCRIPT_VAR_BATTLER_ATTACKER, BSCRIPT_VAR_LAST_BATTLER_ID
    End 
