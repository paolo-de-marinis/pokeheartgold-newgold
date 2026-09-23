    .include "macros/btlcmd.inc"

    .data

// Purify cures the target's status and heals its user, once it has got
// through Protect (Pokemon Central, Purificazione). It fails on a target with
// no status -- Comatose is none -- or behind a substitute unless the user has
// Infiltrator, and for a user under Heal Block. Subscript 444 does the rest.
_000:
    CompareMonDataToValue OPCODE_NEQ, BATTLER_CATEGORY_ATTACKER, BMON_DATA_HEAL_BLOCK_TURNS, 0, _FAILED
    CompareMonDataToValue OPCODE_EQU, BATTLER_CATEGORY_DEFENDER, BMON_DATA_STATUS, STATUS_NONE, _FAILED
    CheckAbility CHECK_OPCODE_HAVE, BATTLER_CATEGORY_ATTACKER, ABILITY_INFILTRATOR, _PURIFY
    CheckSubstitute BATTLER_CATEGORY_DEFENDER, _FAILED

_PURIFY:
    UpdateVar OPCODE_SET, BSCRIPT_VAR_SIDE_EFFECT_FLAGS_INDIRECT, MOVE_SIDE_EFFECT_ON_HIT|MOVE_SUBSCRIPT_PTR_PURIFY
    End

_FAILED:
    UpdateVar OPCODE_FLAG_ON, BSCRIPT_VAR_MOVE_STATUS_FLAGS, MOVE_STATUS_FAILED
    End
