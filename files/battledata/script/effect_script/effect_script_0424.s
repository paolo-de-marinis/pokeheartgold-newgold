    .include "macros/btlcmd.inc"

    .data

// Electrify makes the target's move this turn Electric, once it has got
// through Protect, and fails on a target that has already moved (Pokemon
// Central, Elettrocontagio). A substitute turns it away unless the user has
// Infiltrator, as for Power Split. Subscript 446 does the rest.
_000:
    IfMovedThisTurn BATTLER_CATEGORY_DEFENDER, _FAILED
    CheckAbility CHECK_OPCODE_HAVE, BATTLER_CATEGORY_ATTACKER, ABILITY_INFILTRATOR, _ELECTRIFY
    CheckSubstitute BATTLER_CATEGORY_DEFENDER, _FAILED

_ELECTRIFY:
    UpdateVar OPCODE_SET, BSCRIPT_VAR_SIDE_EFFECT_FLAGS_INDIRECT, MOVE_SIDE_EFFECT_ON_HIT|MOVE_SUBSCRIPT_PTR_ELECTRIFY
    End

_FAILED:
    UpdateVar OPCODE_FLAG_ON, BSCRIPT_VAR_MOVE_STATUS_FLAGS, MOVE_STATUS_FAILED
    End
