    .include "macros/btlcmd.inc"

    .data

// Upper Hand strikes first and flinches, and only a target about to use an
// attack of priority +1 to +3 that has not moved yet (Pokemon Central, Colpo
// di Mano). TrySuckerPunch asks that of this move; the flinch is sure, the
// record's chance being 100.
_000:
    TrySuckerPunch _FAILED
    UpdateVar OPCODE_SET, BSCRIPT_VAR_SIDE_EFFECT_FLAGS_INDIRECT, MOVE_SIDE_EFFECT_TO_DEFENDER|MOVE_SUBSCRIPT_PTR_FLINCH
    CalcCrit 
    CalcDamage 
    End 

_FAILED:
    UpdateVar OPCODE_FLAG_ON, BSCRIPT_VAR_MOVE_STATUS_FLAGS, MOVE_STATUS_FAILED
    End 
