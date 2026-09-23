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
    CompareVarToValue OPCODE_EQU, BSCRIPT_VAR_MOVE_NO_CUR, MOVE_FLORAL_HEALING, _FloralHealing
    CheckAbility CHECK_OPCODE_HAVE, BATTLER_CATEGORY_ATTACKER, ABILITY_MEGA_LAUNCHER, _Heal75Percent

_HealHalf:
    DivideVarByValueRoundUp BSCRIPT_VAR_HP_CALC, 2
    GoTo _Heal50Percent

// Floral Healing, which the engine leaves without an effect: Heal Pulse's
// half, not boosted by Mega Launcher, and in Grassy Terrain 2732/4096 of the
// maximum rounded down (Pokemon Central, Cura Floreale).
_FloralHealing:
    GotoIfTerrainOverlayIsType GRASSY_TERRAIN, _FloralHealingOnGrass
    GoTo _HealHalf

_FloralHealingOnGrass:
    UpdateVar OPCODE_MUL, BSCRIPT_VAR_HP_CALC, 2732
    UpdateVar OPCODE_DIV, BSCRIPT_VAR_HP_CALC, 4096
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
