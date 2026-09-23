    .include "macros/btlcmd.inc"

    .data

_Start:
    // A substitute turns this away unless the user has Infiltrator, which the
    // reference checks in BattleController_CheckSubstituteBlockingOtherEffects
    // before the move runs.
    CheckAbility CHECK_OPCODE_HAVE, BATTLER_CATEGORY_ATTACKER, ABILITY_INFILTRATOR, _PAST_SUBSTITUTE
    CheckSubstitute BATTLER_CATEGORY_DEFENDER, _SUBSTITUTE

_PAST_SUBSTITUTE:
    Call BATTLE_SUBSCRIPT_ATTACK_MESSAGE_AND_ANIMATION
    HandleSoak 0
    // {0} transformed into the Water type!
    PrintMessage msg_0197_01330, TAG_NICKNAME, BATTLER_CATEGORY_DEFENDER
    Wait
    WaitButtonABTime 30
    End

_SUBSTITUTE:
    UpdateVar OPCODE_FLAG_ON, BSCRIPT_VAR_MOVE_STATUS_FLAGS, MOVE_STATUS_FAILED
    End
