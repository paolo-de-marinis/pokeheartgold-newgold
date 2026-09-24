    .include "macros/btlcmd.inc"

    .data

// Parting Shot's user going back once the move is over, when the move
// changed a stat of its target (the reference's subscript_0469_PARTING_SHOT
// at d0380a487, run from its post-move steps). Who goes is in
// MSG_BATTLER_TEMP, as the reference has it in battlerIdTemp: the attacker,
// or the Pokemon that bounced the move back with Magic Coat or Magic Bounce.
// It is named as the switched Pokemon from the start, since Pursuit's hit
// takes MSG_BATTLER_TEMP for its own. The rest is the tail of the pivot moves'
// subscript, 175: Pursuit has its chance, Natural Cure its say, and the
// trainer chooses who comes in. With nobody to come in it stays where it is.

_000:
    UpdateVarFromVar OPCODE_SET, BSCRIPT_VAR_BATTLER_SWITCH, BSCRIPT_VAR_MSG_BATTLER_TEMP
    // Commander holds this Pokemon on the field (Pokemon Central, Torre di Comando).
    CompareMonDataToValue OPCODE_NEQ, BATTLER_CATEGORY_SWITCHED_MON, BMON_DATA_COMMANDER, 0, _END
    TryReplaceFaintedMon BATTLER_CATEGORY_SWITCHED_MON, TRUE, _END
    // {0} went back to {1}!
    PrintMessage msg_0197_01067, TAG_NICKNAME_TRNAME, BATTLER_CATEGORY_SWITCHED_MON, BATTLER_CATEGORY_SWITCHED_MON
    Wait
    WaitButtonABTime 30
    Call BATTLE_SUBSCRIPT_PURSUIT
    CompareMonDataToValue OPCODE_EQU, BATTLER_CATEGORY_SWITCHED_MON, BMON_DATA_HP, 0, _END
    TryRestoreStatusOnSwitch BATTLER_CATEGORY_SWITCHED_MON, _SWITCH_OUT
    UpdateMonData OPCODE_SET, BATTLER_CATEGORY_SWITCHED_MON, BMON_DATA_STATUS, STATUS_NONE

_SWITCH_OUT:
    DeletePokemon BATTLER_CATEGORY_SWITCHED_MON
    Wait
    HealthbarSlideOut BATTLER_CATEGORY_SWITCHED_MON
    Wait
    // The user leaving with its move: what comes in did not use it (U-turn's
    // flag). A bouncer leaving is not the attacker, which stays.
    CompareVarToVar OPCODE_NEQ, BSCRIPT_VAR_BATTLER_SWITCH, BSCRIPT_VAR_BATTLER_ATTACKER, _NOT_THE_ATTACKER
    UpdateVar OPCODE_FLAG_ON, BSCRIPT_VAR_BATTLE_STATUS_2, BATTLE_STATUS2_UTURN
    UpdateVar OPCODE_FLAG_OFF, BSCRIPT_VAR_BATTLE_STATUS, BATTLE_STATUS_SYNCRONIZE
    UpdateVar OPCODE_SET, BSCRIPT_VAR_ATTACKER_SELF_TURN_STATUS_FLAGS, SELF_TURN_FLAG_CLEAR

_NOT_THE_ATTACKER:
    GoToSubscript BATTLE_SUBSCRIPT_SHOW_PARTY_LIST

_END:
    End
