    .include "macros/btlcmd.inc"

    .data

// U-turn, Volt Switch and Flip Turn taking their user out once the move is
// over (TryPivotSwitch; the engine's subscript 175 at d0380a487). Everything
// the hit sets off -- the target's Rough Skin or Static, its Rocky Helmet,
// Destiny Bond and Grudge as it faints -- has happened by now, in the steps
// every move goes through, so none of it is asked here any more.
_000:
    CheckBlackOut BATTLER_CATEGORY_DEFENDER, _END
    TryReplaceFaintedMon BATTLER_CATEGORY_ATTACKER, TRUE, _END
    CompareMonDataToValue OPCODE_EQU, BATTLER_CATEGORY_ATTACKER, BMON_DATA_HP, 0, _END
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
    UpdateVar OPCODE_FLAG_OFF, BSCRIPT_VAR_BATTLE_STATUS, BATTLE_STATUS_MOVE_ANIMATIONS_OFF
    UpdateVar OPCODE_SET, BSCRIPT_VAR_MOVE_EFFECT_CHANCE, 1
    PlayMoveAnimation BATTLER_CATEGORY_ATTACKER
    Wait 
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
