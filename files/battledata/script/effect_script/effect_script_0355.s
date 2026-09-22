    .include "macros/btlcmd.inc"

    .data

// Thousand Waves, Spirit Shackle, Anchor Shot. The damage lands and then the
// target is held exactly where Mean Look holds it -- the reference runs
// subscript 86 itself once the move is over, and the side effect is where
// this tree keeps that kind of after-damage work. Subscript 86 does the rest:
// a protected, missed or already-trapped target, or one behind a substitute,
// simply fails.
_000:
    UpdateVar OPCODE_SET, BSCRIPT_VAR_SIDE_EFFECT_FLAGS_INDIRECT, MOVE_SIDE_EFFECT_CHECK_HP|MOVE_SIDE_EFFECT_TO_DEFENDER|MOVE_SUBSCRIPT_PTR_MEAN_LOOK
    CalcCrit 
    CalcDamage 
    End 
