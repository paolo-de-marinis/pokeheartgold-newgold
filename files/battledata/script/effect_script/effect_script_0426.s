    .include "macros/btlcmd.inc"

    .data

// Octolock holds the target in and wears its defences down each turn, once
// it has got through Protect; it fails on a Ghost-type, on a target already
// held, and behind a substitute unless the user has Infiltrator (Pokemon
// Central, Tentacolock). Subscript 448 does the holding.
_000:
    CompareMonDataToValue OPCODE_EQU, BATTLER_CATEGORY_DEFENDER, BMON_DATA_TYPE_1, TYPE_GHOST, _FAILED
    CompareMonDataToValue OPCODE_EQU, BATTLER_CATEGORY_DEFENDER, BMON_DATA_TYPE_2, TYPE_GHOST, _FAILED
    CompareMonDataToValue OPCODE_EQU, BATTLER_CATEGORY_DEFENDER, BMON_DATA_TYPE_3, TYPE_GHOST, _FAILED
    CompareMonDataToValue OPCODE_FLAG_SET, BATTLER_CATEGORY_DEFENDER, BMON_DATA_STATUS2, STATUS2_MEAN_LOOK, _FAILED
    CheckAbility CHECK_OPCODE_HAVE, BATTLER_CATEGORY_ATTACKER, ABILITY_INFILTRATOR, _OCTOLOCK
    CheckSubstitute BATTLER_CATEGORY_DEFENDER, _FAILED

_OCTOLOCK:
    UpdateVar OPCODE_SET, BSCRIPT_VAR_SIDE_EFFECT_FLAGS_INDIRECT, MOVE_SIDE_EFFECT_ON_HIT|MOVE_SUBSCRIPT_PTR_OCTOLOCK
    End

_FAILED:
    UpdateVar OPCODE_FLAG_ON, BSCRIPT_VAR_MOVE_STATUS_FLAGS, MOVE_STATUS_FAILED
    End
