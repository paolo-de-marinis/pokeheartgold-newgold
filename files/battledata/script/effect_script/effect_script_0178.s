    .include "macros/btlcmd.inc"

    .data

_000:
    // Role Play writes over the user's ability, so not one nothing writes
    // over (the table's, BMON_DATA_ABILITY_FLAGS), nor Commander, which
    // Pokemon Central's Giocodiruolo names on the user's side and the
    // reference's list here has too.
    CompareMonDataToValue OPCODE_FLAG_SET, BATTLER_CATEGORY_ATTACKER, BMON_DATA_ABILITY_FLAGS, ABILITY_FLAG_FAILS_SUPPRESS, _015
    CheckAbility CHECK_OPCODE_HAVE, BATTLER_CATEGORY_ATTACKER, ABILITY_COMMANDER, _015
    UpdateVar OPCODE_SET, BSCRIPT_VAR_SIDE_EFFECT_FLAGS_DIRECT, MOVE_SIDE_EFFECT_TO_DEFENDER|MOVE_SIDE_EFFECT_CHECK_HP|MOVE_SUBSCRIPT_PTR_COPY_ABILITY
    End 

_015:
    UpdateVar OPCODE_FLAG_ON, BSCRIPT_VAR_MOVE_STATUS_FLAGS, MOVE_STATUS_FAILED
    End 
