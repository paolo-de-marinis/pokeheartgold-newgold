    .include "macros/btlcmd.inc"

    .data

// Surging Strikes. The reference reads the effect inside its critical hit roll
// and skips the roll; here, as for effect 292, each hit asks for a critical
// stage no ladder reaches, which CalcCrit reads as the same thing.
_000:
    SetMultiHit 3, MULTIHIT_MULTI_HIT_MOVE
    UpdateVar OPCODE_SET, BSCRIPT_VAR_AFTER_MOVE_MESSAGE_TYPE, AFTER_MOVE_MESSAGE_MULTI_HIT
    UpdateVar OPCODE_SET, BSCRIPT_VAR_CRITICAL_BOOSTS, CRITICAL_STAGE_ALWAYS
    CalcCrit 
    CalcDamage 
    End 
