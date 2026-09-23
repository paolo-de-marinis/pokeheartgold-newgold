    .include "macros/btlcmd.inc"

    .data

// Tar Shot lowers the target's Speed and leaves it weaker to Fire, once it
// has got through Protect; a substitute turns it away unless the user has
// Infiltrator (Pokemon Central, Colpocatrame). Subscript 452 does the rest.
_000:
    CheckAbility CHECK_OPCODE_HAVE, BATTLER_CATEGORY_ATTACKER, ABILITY_INFILTRATOR, _TAR
    CheckSubstitute BATTLER_CATEGORY_DEFENDER, _FAILED

_TAR:
    UpdateVar OPCODE_SET, BSCRIPT_VAR_SIDE_EFFECT_FLAGS_INDIRECT, MOVE_SIDE_EFFECT_ON_HIT|MOVE_SUBSCRIPT_PTR_TAR_SHOT
    End

_FAILED:
    UpdateVar OPCODE_FLAG_ON, BSCRIPT_VAR_MOVE_STATUS_FLAGS, MOVE_STATUS_FAILED
    End
