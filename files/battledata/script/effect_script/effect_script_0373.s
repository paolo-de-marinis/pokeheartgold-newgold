    .include "macros/btlcmd.inc"

    .data

// Copied from Protect - using moveEffect to differentiate from different protect moves

_000:
    // Mat Block only works on the user's first turn out, as the reference
    // fails it with Fake Out and First Impression; this is their guard.
    CompareVarToValue OPCODE_NEQ, BSCRIPT_VAR_MOVE_NO_CUR, MOVE_MAT_BLOCK, _PROTECT
    CompareMonDataToVar OPCODE_NEQ, BATTLER_CATEGORY_ATTACKER, BMON_DATA_FAKE_OUT, BSCRIPT_VAR_TOTAL_TURNS, _FAIL

_PROTECT:
    UpdateVar OPCODE_SET, BSCRIPT_VAR_SIDE_EFFECT_FLAGS_DIRECT, MOVE_SIDE_EFFECT_TO_ATTACKER|MOVE_SIDE_EFFECT_CHECK_HP|MOVE_SUBSCRIPT_PTR_PROTECT
    End 

_FAIL:
    UpdateVar OPCODE_FLAG_ON, BSCRIPT_VAR_MOVE_STATUS_FLAGS, MOVE_STATUS_FAILED
    End
