    .include "macros/btlcmd.inc"

    .data

// Swallows the move and raises the holder's Attack by whatever
// BSCRIPT_VAR_SIDE_EFFECT_PARAM asks for: one stage for Sap Sipper, two for
// Irrigation. An Attack already at its ceiling leaves the move merely useless,
// the way Motor Drive does.
_000:
    PrintAttackMessage 
    Wait 
    WaitButtonABTime 15
    CompareMonDataToValue OPCODE_EQU, BATTLER_CATEGORY_DEFENDER, BMON_DATA_STAT_CHANGE_ATK, 12, _MAXED
    Call BATTLE_SUBSCRIPT_UPDATE_STAT_STAGE
    End 

_MAXED:
    // {0}’s {1} made {2} useless!
    PrintMessage msg_0197_00638, TAG_NICKNAME_ABILITY_MOVE, BATTLER_CATEGORY_DEFENDER, BATTLER_CATEGORY_DEFENDER, BATTLER_CATEGORY_ATTACKER
    Wait 
    WaitButtonABTime 30
    End 
