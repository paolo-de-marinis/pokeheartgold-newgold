    .include "macros/btlcmd.inc"

    .data

// A Cramorant with its prey spits it at what hit it (Pokemon Central,
// Inghiottimissile; CheckAbilityEffectOnHit): the Cramorant, the defender, is
// already itself again and is shown so; the attacker, battlerIdTemp, takes a
// quarter of its maximum HP, then, if it is still standing, loses a stage of
// Defense to an Arrokuda (the side-effect parameter) or is paralyzed by a
// Pikachu (none). The reference has no script for it.
_000:
    PlaySound BATTLER_CATEGORY_DEFENDER, SEQ_SE_DP_W100
    SetMosaic BATTLER_CATEGORY_DEFENDER, 8, 1
    Wait
    ChangeForm BATTLER_CATEGORY_DEFENDER
    PlaySound BATTLER_CATEGORY_DEFENDER, SEQ_SE_DP_W107
    SetMosaic BATTLER_CATEGORY_DEFENDER, 0, 1
    Wait
    UpdateVar OPCODE_FLAG_ON, BSCRIPT_VAR_BATTLE_STATUS, BATTLE_STATUS_NO_BLINK
    Call BATTLE_SUBSCRIPT_UPDATE_HP
    // {0}’s {1} hurt {2}!
    PrintMessage msg_0197_00672, TAG_NICKNAME_ABILITY_NICKNAME, BATTLER_CATEGORY_DEFENDER, BATTLER_CATEGORY_DEFENDER, BATTLER_CATEGORY_ATTACKER
    Wait
    WaitButtonABTime 30
    CompareMonDataToValue OPCODE_EQU, BATTLER_CATEGORY_ATTACKER, BMON_DATA_HP, 0, _END
    CompareVarToValue OPCODE_EQU, BSCRIPT_VAR_SIDE_EFFECT_PARAM, 0, _PIKACHU
    Call BATTLE_SUBSCRIPT_ABILITY_CUTS_STAT
    GoTo _END

_PIKACHU:
    // The paralysis names the Cramorant's ability.
    UpdateVarFromVar OPCODE_SET, BSCRIPT_VAR_MSG_BATTLER_TEMP, BSCRIPT_VAR_BATTLER_TARGET
    Call BATTLE_SUBSCRIPT_PARALYZE

_END:
    End
