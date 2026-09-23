    .include "macros/btlcmd.inc"

    .data

_000:
    // A substitute turns this away unless the user has Infiltrator, which the
    // reference checks in BattleController_CheckSubstituteBlockingOtherEffects
    // before the move runs.
    CheckAbility CHECK_OPCODE_HAVE, BATTLER_CATEGORY_ATTACKER, ABILITY_INFILTRATOR, _PAST_SUBSTITUTE
    CheckSubstitute BATTLER_CATEGORY_DEFENDER, _SUBSTITUTE

_PAST_SUBSTITUTE:
    UpdateVar OPCODE_SET, BSCRIPT_VAR_SIDE_EFFECT_FLAGS_INDIRECT, MOVE_SIDE_EFFECT_ON_HIT|MOVE_SUBSCRIPT_PTR_GUARD_SPLIT
    End

_SUBSTITUTE:
    UpdateVar OPCODE_FLAG_ON, BSCRIPT_VAR_MOVE_STATUS_FLAGS, MOVE_STATUS_FAILED
    End
