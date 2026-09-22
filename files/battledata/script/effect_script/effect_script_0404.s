    .include "macros/btlcmd.inc"

    .data

// Chloroblast. Half the user's own maximum HP, not a share of the damage,
// and the reference counts it among the moves Reckless pays for.
_000:
    CheckAbility CHECK_OPCODE_NOT_HAVE, BATTLER_CATEGORY_ATTACKER, ABILITY_RECKLESS, _HIT
    UpdateVar OPCODE_SET, BSCRIPT_VAR_POWER_MULTI, 12

_HIT:
    UpdateVar OPCODE_SET, BSCRIPT_VAR_SIDE_EFFECT_FLAGS_INDIRECT, MOVE_SIDE_EFFECT_ON_HIT|MOVE_SUBSCRIPT_PTR_RECOIL_HALF_MAX_HP
    CalcCrit 
    CalcDamage 
    End 
