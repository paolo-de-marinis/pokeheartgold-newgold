    .include "macros/btlcmd.inc"

    .data

// Reflect Type makes the user the target's types once it has got through
// Protect (Pokemon Central, Riflettipo). It fails for a user with Multitype
// or RKS System, whose type is its ability's, and on a target with no type
// to give. Subscript 443 does the copying.
_000:
    CheckAbility CHECK_OPCODE_HAVE, BATTLER_CATEGORY_ATTACKER, ABILITY_MULTITYPE, _FAILED
    CheckAbility CHECK_OPCODE_HAVE, BATTLER_CATEGORY_ATTACKER, ABILITY_RKS_SYSTEM, _FAILED
    CompareMonDataToValue OPCODE_NEQ, BATTLER_CATEGORY_DEFENDER, BMON_DATA_TYPE_1, TYPE_MYSTERY, _REFLECT
    CompareMonDataToValue OPCODE_NEQ, BATTLER_CATEGORY_DEFENDER, BMON_DATA_TYPE_2, TYPE_MYSTERY, _REFLECT

_FAILED:
    UpdateVar OPCODE_FLAG_ON, BSCRIPT_VAR_MOVE_STATUS_FLAGS, MOVE_STATUS_FAILED
    End

_REFLECT:
    UpdateVar OPCODE_SET, BSCRIPT_VAR_SIDE_EFFECT_FLAGS_INDIRECT, MOVE_SIDE_EFFECT_ON_HIT|MOVE_SUBSCRIPT_PTR_REFLECT_TYPE
    End
