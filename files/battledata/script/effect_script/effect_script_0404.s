    .include "macros/btlcmd.inc"

    .data

// Chloroblast. Half the user's own maximum HP, not a share of the damage.
// The reference counts it among the moves Reckless pays for, which the damage
// calculation does, as for the other recoil moves.
_000:
    UpdateVar OPCODE_SET, BSCRIPT_VAR_SIDE_EFFECT_FLAGS_INDIRECT, MOVE_SIDE_EFFECT_ON_HIT|MOVE_SUBSCRIPT_PTR_RECOIL_HALF_MAX_HP
    CalcCrit
    CalcDamage
    End
