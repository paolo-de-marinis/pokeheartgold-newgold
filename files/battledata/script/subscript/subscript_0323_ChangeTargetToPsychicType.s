    .include "macros/btlcmd.inc"

    .data

// Called by Magic Powder.
_Start:
    // A substitute turns this away unless the user has Infiltrator, which the
    // reference checks in BattleController_CheckSubstituteBlockingOtherEffects
    // before the move runs.
    CheckAbility CHECK_OPCODE_HAVE, BATTLER_CATEGORY_ATTACKER, ABILITY_INFILTRATOR, _PAST_SUBSTITUTE
    CheckSubstitute BATTLER_CATEGORY_DEFENDER, _SUBSTITUTE

_PAST_SUBSTITUTE:
    // Arceus and Silvally keep the type their Multitype and RKS System give
    // them; a Pokemon that only wears their looks by Transform or Imposter
    // does not (Pokemon Central, Inondazione). The reference refuses the two
    // abilities before the move runs, in BattleController_BeforeMove.c.
    CompareMonDataToValue OPCODE_FLAG_SET, BATTLER_CATEGORY_DEFENDER, BMON_DATA_STATUS2, STATUS2_TRANSFORM, _PURE_TYPE
    CompareMonDataToValue OPCODE_EQU, BATTLER_CATEGORY_DEFENDER, BMON_DATA_ABILITY, ABILITY_MULTITYPE, _FAILED
    CompareMonDataToValue OPCODE_EQU, BATTLER_CATEGORY_DEFENDER, BMON_DATA_ABILITY, ABILITY_RKS_SYSTEM, _FAILED

_PURE_TYPE:
    // Nor a target that is purely Psychic already, with no type added to it
    // (Pokemon Central, Magipolvere); the reference's IsPureType, before the
    // move. The games show the move and then fail it; here it fails
    // before it is shown, as every other failure does.
    CompareMonDataToValue OPCODE_NEQ, BATTLER_CATEGORY_DEFENDER, BMON_DATA_TYPE_1, TYPE_PSYCHIC, _CHANGE_TYPE
    CompareMonDataToValue OPCODE_NEQ, BATTLER_CATEGORY_DEFENDER, BMON_DATA_TYPE_2, TYPE_PSYCHIC, _CHANGE_TYPE
    CompareMonDataToValue OPCODE_EQU, BATTLER_CATEGORY_DEFENDER, BMON_DATA_TYPE_3, TYPE_NONE, _FAILED

_CHANGE_TYPE:
    Call BATTLE_SUBSCRIPT_ATTACK_MESSAGE_AND_ANIMATION
    HandleMagicPowder 0
    // {0} transformed into the Psychic type!
    PrintMessage msg_0197_01585, TAG_NICKNAME, BATTLER_CATEGORY_DEFENDER
    Wait
    WaitButtonABTime 30
    End

_SUBSTITUTE:
_FAILED:
    UpdateVar OPCODE_FLAG_ON, BSCRIPT_VAR_MOVE_STATUS_FLAGS, MOVE_STATUS_FAILED
    End
