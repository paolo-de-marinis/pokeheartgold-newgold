    .include "macros/btlcmd.inc"

    .data

// The ally drinks, so the ally is who has to be in the temporary slot when
// the healing runs -- BATTLE_SUBSCRIPT_UPDATE_HP knows no other battler. The
// message is printed first, while that slot still holds the one who poured.
_000:
    // {0} drank down all the matcha that {1} made!
    PrintMessage msg_0197_01282, TAG_NICKNAME_NICKNAME, BATTLER_CATEGORY_SIDE_EFFECT_MON, BATTLER_CATEGORY_MSG_BATTLER_TEMP
    Wait
    WaitButtonABTime 30
    UpdateVarFromVar OPCODE_SET, BSCRIPT_VAR_MSG_BATTLER_TEMP, BSCRIPT_VAR_BATTLER_STAT_CHANGE
    Call BATTLE_SUBSCRIPT_UPDATE_HP
    End
