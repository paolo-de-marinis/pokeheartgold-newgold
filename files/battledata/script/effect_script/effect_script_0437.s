    .include "macros/btlcmd.inc"

    .data

// Doodle gives the user and its ally the target's ability (Pokemon Central,
// Ricalco): subscript 457, on the target once the move has reached it, as
// Role Play's side effect is set (effect script 178). Protect is no bar, a
// substitute is, short of Infiltrator.
_000:
    CheckAbility CHECK_OPCODE_HAVE, BATTLER_CATEGORY_ATTACKER, ABILITY_INFILTRATOR, _DOODLE
    CheckSubstitute BATTLER_CATEGORY_DEFENDER, _FAILED

_DOODLE:
    UpdateVar OPCODE_SET, BSCRIPT_VAR_SIDE_EFFECT_FLAGS_DIRECT, MOVE_SIDE_EFFECT_TO_DEFENDER|MOVE_SIDE_EFFECT_CHECK_HP|MOVE_SUBSCRIPT_PTR_DOODLE
    End

_FAILED:
    UpdateVar OPCODE_FLAG_ON, BSCRIPT_VAR_MOVE_STATUS_FLAGS, MOVE_STATUS_FAILED
    End
