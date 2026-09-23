    .include "macros/btlcmd.inc"

    .data

_000:
    // A substitute turns this away unless the user has Infiltrator, which the
    // reference checks in BattleController_CheckSubstituteBlockingOtherEffects
    // before the move runs.
    CheckAbility CHECK_OPCODE_HAVE, BATTLER_CATEGORY_ATTACKER, ABILITY_INFILTRATOR, _PAST_SUBSTITUTE
    CheckSubstitute BATTLER_CATEGORY_DEFENDER, _SUBSTITUTE

_PAST_SUBSTITUTE:
    PrintAttackMessage 
    Wait 
    UpdateMonDataFromVar OPCODE_GET, BATTLER_CATEGORY_DEFENDER, BMON_DATA_MAXHP, BSCRIPT_VAR_HP_CALC
    CheckAbility CHECK_OPCODE_HAVE, BATTLER_CATEGORY_ATTACKER, ABILITY_MEGA_LAUNCHER, _Heal75Percent
    DivideVarByValueRoundUp BSCRIPT_VAR_HP_CALC, 2
    GoTo _Heal50Percent

_Heal75Percent:
    DivideVarByValueRoundUp BSCRIPT_VAR_HP_CALC, 4
    UpdateVar OPCODE_MUL, BSCRIPT_VAR_HP_CALC, 3

_Heal50Percent:
    UpdateVarFromVar OPCODE_SET, BSCRIPT_VAR_MSG_BATTLER_TEMP, BSCRIPT_VAR_BATTLER_TARGET
    Call BATTLE_SUBSCRIPT_RECOVER_HP
    End

_SUBSTITUTE:
    UpdateVar OPCODE_FLAG_ON, BSCRIPT_VAR_MOVE_STATUS_FLAGS, MOVE_STATUS_FAILED
    End
