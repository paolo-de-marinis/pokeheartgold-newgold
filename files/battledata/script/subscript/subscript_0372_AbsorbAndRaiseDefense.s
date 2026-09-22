    .include "macros/btlcmd.inc"

    .data

// The Attack twin of this, at 297, is what Sap Sipper and Irrigation run. Well
// Baked Body swallows the Fire move for Defense instead, so the ceiling it has
// to consult is Defense too; the compare takes the stat as a literal, which is
// the whole reason this is a second file rather than another caller of 297.
_000:
    PrintAttackMessage
    Wait
    WaitButtonABTime 15
    CompareMonDataToValue OPCODE_EQU, BATTLER_CATEGORY_DEFENDER, BMON_DATA_STAT_CHANGE_DEF, 12, _MAXED
    Call BATTLE_SUBSCRIPT_UPDATE_STAT_STAGE
    End

_MAXED:
    // {0}’s {1} made {2} useless!
    PrintMessage msg_0197_00638, TAG_NICKNAME_ABILITY_MOVE, BATTLER_CATEGORY_DEFENDER, BATTLER_CATEGORY_DEFENDER, BATTLER_CATEGORY_ATTACKER
    Wait
    WaitButtonABTime 30
    End
