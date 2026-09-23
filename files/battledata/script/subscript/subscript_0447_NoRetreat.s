    .include "macros/btlcmd.inc"

    .data

// No Retreat: a stage more of every stat but accuracy and evasion, and the
// user can no longer leave (Pokemon Central, Spalle al Muro). The hold is
// Mean Look's flag with the user as its own trapper, so it lasts while the
// user is in; one already held by something else keeps that hold and gains
// no second, and may use the move again.
_000:
    Call BATTLE_SUBSCRIPT_ATTACK_MESSAGE_AND_ANIMATION
    UpdateVarFromVar OPCODE_SET, BSCRIPT_VAR_BATTLER_STAT_CHANGE, BSCRIPT_VAR_BATTLER_ATTACKER
    Call BATTLE_SUBSCRIPT_BOOST_ALL_STATS
    CompareMonDataToValue OPCODE_FLAG_SET, BATTLER_CATEGORY_ATTACKER, BMON_DATA_STATUS2, STATUS2_MEAN_LOOK, _END
    UpdateMonData OPCODE_FLAG_ON, BATTLER_CATEGORY_ATTACKER, BMON_DATA_STATUS2, STATUS2_MEAN_LOOK
    UpdateMonDataFromVar OPCODE_SET, BATTLER_CATEGORY_ATTACKER, BMON_DATA_MEAN_LOOK_TARGET, BSCRIPT_VAR_BATTLER_ATTACKER
    // {0} can no longer escape because it used No Retreat!
    PrintMessage msg_0197_01847, TAG_NICKNAME, BATTLER_CATEGORY_ATTACKER
    Wait
    WaitButtonABTime 30

_END:
    End
