    .include "macros/btlcmd.inc"

    .data

// Subscript 190 with the ability read from somewhere else. The one cured is
// the ally, so the ally is in the temporary slot the message and the
// healthbar both read; the ability the line credits belongs to the other
// Pokemon, and BATTLER_CATEGORY_ABILITY_MON is the only second battler slot
// there is -- MSG_TEMP and MSG_BATTLER_TEMP are one slot, not two.
_000:
    UpdateMonData OPCODE_SET, BATTLER_CATEGORY_MSG_TEMP, BMON_DATA_STATUS, STATUS_NONE
    UpdateMonData OPCODE_FLAG_OFF, BATTLER_CATEGORY_MSG_TEMP, BMON_DATA_STATUS2, STATUS2_NIGHTMARE
    // {0}’s {1} cured its {2} status!
    PrintMessage msg_0197_00717, TAG_NICKNAME_ABILITY_STATUS, BATTLER_CATEGORY_MSG_TEMP, BATTLER_CATEGORY_ABILITY_MON, BATTLER_CATEGORY_MSG_TEMP
    Wait
    SetHealthbarStatus BATTLER_CATEGORY_MSG_TEMP, BATTLE_ANIMATION_NONE
    WaitButtonABTime 30
    End
