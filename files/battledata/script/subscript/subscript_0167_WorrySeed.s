    .include "macros/btlcmd.inc"

    .data

_000:
    CompareVarToValue OPCODE_FLAG_SET, BSCRIPT_VAR_MOVE_STATUS_FLAGS, MOVE_STATUS_MISSED|MOVE_STATUS_SEMI_INVULNERABLE, _041
    CheckSubstitute BATTLER_CATEGORY_DEFENDER, _041
    CompareMonDataToValue OPCODE_EQU, BATTLER_CATEGORY_DEFENDER, BMON_DATA_ABILITY, ABILITY_INSOMNIA, _041
    CompareMonDataToValue OPCODE_EQU, BATTLER_CATEGORY_DEFENDER, BMON_DATA_ABILITY, ABILITY_TRUANT, _041
    // What nothing writes over, the ability table's, as the reference's
    // move-failure check asks it (AbilityCantSupress).
    CompareMonDataToValue OPCODE_FLAG_SET, BATTLER_CATEGORY_DEFENDER, BMON_DATA_ABILITY_FLAGS, ABILITY_FLAG_FAILS_SUPPRESS, _041
    // Not Commander, which the reference's list adds and Pokemon Central's
    // Affannoseme still lists: from Scarlet and Violet 2.0.1 it is written
    // over (Torre di Comando).
    CompareMonDataToValue OPCODE_EQU, BATTLER_CATEGORY_DEFENDER, BMON_DATA_HELD_ITEM, ITEM_ABILITY_SHIELD, _041
    Call BATTLE_SUBSCRIPT_ATTACK_MESSAGE_AND_ANIMATION
    UpdateMonData OPCODE_SET, BATTLER_CATEGORY_DEFENDER, BMON_DATA_ABILITY, ABILITY_INSOMNIA
    // {0} acquired {1}!
    PrintMessage msg_0197_01021, TAG_NICKNAME_ABILITY, BATTLER_CATEGORY_DEFENDER, BATTLER_CATEGORY_DEFENDER
    Wait 
    WaitButtonABTime 30
    End 

_041:
    UpdateVar OPCODE_FLAG_ON, BSCRIPT_VAR_MOVE_STATUS_FLAGS, MOVE_STATUS_FAILED
    End 
