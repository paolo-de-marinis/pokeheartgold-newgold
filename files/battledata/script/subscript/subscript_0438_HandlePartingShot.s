    .include "macros/btlcmd.inc"

    .data

// Parting Shot's user going back once the move is over, when the move
// lowered a stat of its target (the reference's subscript_0472_PARTING_SHOT
// at d0380a487, run from its post-move steps). The rest is the tail of the
// pivot moves' subscript, 175: Pursuit has its chance, Natural Cure its say,
// and the user's trainer chooses who comes in. With nobody to come in the
// user stays where it is.

_000:
    TryReplaceFaintedMon BATTLER_CATEGORY_ATTACKER, TRUE, _END
    UpdateVarFromVar OPCODE_SET, BSCRIPT_VAR_BATTLER_SWITCH, BSCRIPT_VAR_BATTLER_ATTACKER
    // {0} went back to {1}!
    PrintMessage msg_0197_01067, TAG_NICKNAME_TRNAME, BATTLER_CATEGORY_SWITCHED_MON, BATTLER_CATEGORY_SWITCHED_MON
    Wait
    WaitButtonABTime 30
    Call BATTLE_SUBSCRIPT_PURSUIT
    CompareMonDataToValue OPCODE_EQU, BATTLER_CATEGORY_ATTACKER, BMON_DATA_HP, 0, _END
    TryRestoreStatusOnSwitch BATTLER_CATEGORY_ATTACKER, _SWITCH_OUT
    UpdateMonData OPCODE_SET, BATTLER_CATEGORY_ATTACKER, BMON_DATA_STATUS, STATUS_NONE

_SWITCH_OUT:
    DeletePokemon BATTLER_CATEGORY_ATTACKER
    Wait
    HealthbarSlideOut BATTLER_CATEGORY_ATTACKER
    Wait
    UpdateVar OPCODE_FLAG_ON, BSCRIPT_VAR_BATTLE_STATUS_2, BATTLE_STATUS2_UTURN
    UpdateVar OPCODE_FLAG_OFF, BSCRIPT_VAR_BATTLE_STATUS, BATTLE_STATUS_SYNCRONIZE
    UpdateVar OPCODE_SET, BSCRIPT_VAR_ATTACKER_SELF_TURN_STATUS_FLAGS, SELF_TURN_FLAG_CLEAR
    GoToSubscript BATTLE_SUBSCRIPT_SHOW_PARTY_LIST

_END:
    End
