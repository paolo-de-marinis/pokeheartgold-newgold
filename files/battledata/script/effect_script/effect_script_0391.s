    .include "macros/btlcmd.inc"

    .data

// Clear Smog leaves the target as it came in. The reference runs its reset
// out of the post-move effects by move number; here it is an on-hit side
// effect, which is the same "only if it connected".
_000:
    UpdateVar OPCODE_SET, BSCRIPT_VAR_SIDE_EFFECT_FLAGS_INDIRECT, MOVE_SIDE_EFFECT_ON_HIT|MOVE_SUBSCRIPT_PTR_CLEAR_SMOG
    CalcCrit 
    CalcDamage
    End 
