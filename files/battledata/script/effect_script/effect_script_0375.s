    .include "macros/btlcmd.inc"

    .data

// First Impression, which is Fake Out without the flinch: the reference asks
// the same question Fake Out's script already asks here, so this is Fake
// Out's guard and nothing else.
_000:
    CompareMonDataToVar OPCODE_NEQ, BATTLER_CATEGORY_ATTACKER, BMON_DATA_FAKE_OUT, BSCRIPT_VAR_TOTAL_TURNS, _FAIL
    CalcCrit 
    CalcDamage 
    End 

_FAIL:
    UpdateVar OPCODE_FLAG_ON, BSCRIPT_VAR_MOVE_STATUS_FLAGS, MOVE_STATUS_FAILED
    End 
