    .include "macros/btlcmd.inc"

    .data

// Circle Throw and Dragon Tail: damage, then whatever Whirlwind does. That is
// subscript 91, unchanged, which is also where Suction Cups and Ingrain get
// their say. It opens by asking for the attack message and animation, which
// have already been shown by the time the damage is done; both commands
// refuse to repeat themselves, so nothing is printed twice. The reference
// reuses the same subscript for the same reason.
_000:
    UpdateVar OPCODE_SET, BSCRIPT_VAR_SIDE_EFFECT_FLAGS_INDIRECT, MOVE_SIDE_EFFECT_CHECK_HP_AND_SUBSTITUTE|MOVE_SIDE_EFFECT_TO_DEFENDER|MOVE_SUBSCRIPT_PTR_FORCE_TARGET_TO_SWITCH_OR_FLEE
    CalcCrit 
    CalcDamage 
    End 
