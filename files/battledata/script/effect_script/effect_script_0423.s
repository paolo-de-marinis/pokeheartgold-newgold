    .include "macros/btlcmd.inc"

    .data

// Core Enforcer hurts both foes and suppresses the ability of each one that
// has already acted this turn (Pokemon Central, Nucleocastigo). That is not a
// side effect the move gives up for Sheer Force or a Covert Cloak takes away:
// it comes on the hit, as a pivot move's switch does, through subscript 445.
_000:
    UpdateVar OPCODE_SET, BSCRIPT_VAR_SIDE_EFFECT_FLAGS_INDIRECT, MOVE_SIDE_EFFECT_ON_HIT|MOVE_SUBSCRIPT_PTR_CORE_ENFORCER
    CalcCrit
    CalcDamage
    End
