    .include "macros/btlcmd.inc"

    .data

// No Retreat raises the user's five stats and holds it in, and fails for a
// user its own No Retreat already holds -- Mean Look's flag with the user as
// the trapper, which nothing else sets (Pokemon Central, Spalle al Muro).
// Subscript 447 does the rest.
_000:
    CompareMonDataToValue OPCODE_FLAG_NOT, BATTLER_CATEGORY_ATTACKER, BMON_DATA_STATUS2, STATUS2_MEAN_LOOK, _NO_RETREAT
    CompareMonDataToVar OPCODE_EQU, BATTLER_CATEGORY_ATTACKER, BMON_DATA_MEAN_LOOK_TARGET, BSCRIPT_VAR_BATTLER_ATTACKER, _FAILED

_NO_RETREAT:
    UpdateVar OPCODE_SET, BSCRIPT_VAR_SIDE_EFFECT_FLAGS_DIRECT, MOVE_SIDE_EFFECT_TO_ATTACKER|MOVE_SUBSCRIPT_PTR_NO_RETREAT
    End

_FAILED:
    UpdateVar OPCODE_FLAG_ON, BSCRIPT_VAR_MOVE_STATUS_FLAGS, MOVE_STATUS_FAILED
    End
