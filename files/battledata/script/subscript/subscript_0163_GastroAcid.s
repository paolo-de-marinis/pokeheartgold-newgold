    .include "macros/btlcmd.inc"

    .data

_000:
    CheckSubstitute BATTLER_CATEGORY_DEFENDER, _034
    CompareMonDataToValue OPCODE_FLAG_SET, BATTLER_CATEGORY_DEFENDER, BMON_DATA_MOVE_EFFECT, MOVE_EFFECT_FLAG_ABILITY_SUPPRESSED, _034
    CompareVarToValue OPCODE_FLAG_SET, BSCRIPT_VAR_MOVE_STATUS_FLAGS, MOVE_STATUS_MISSED|MOVE_STATUS_SEMI_INVULNERABLE, _034
    // What nothing suppresses, the ability table's (the reference's
    // AbilityCantSupress): the mark would not hold on it.
    CompareMonDataToValue OPCODE_FLAG_SET, BATTLER_CATEGORY_DEFENDER, BMON_DATA_ABILITY_FLAGS, ABILITY_FLAG_FAILS_SUPPRESS, _034
    // Not the three the reference's list adds, which Pokemon Central's
    // Gastroacido still lists: Commander is suppressed from Scarlet and
    // Violet 2.0.1 (Torre di Comando), Protosynthesis and Quark Drive from
    // 3.0.0 (Paleoattivazione, Carica Quark).
    // An Ability Shield keeps the ability working (Pokemon Central, Scudo abilita).
    CompareMonDataToValue OPCODE_EQU, BATTLER_CATEGORY_DEFENDER, BMON_DATA_HELD_ITEM, ITEM_ABILITY_SHIELD, _034
    Call BATTLE_SUBSCRIPT_ATTACK_MESSAGE_AND_ANIMATION
    UpdateMonData OPCODE_FLAG_ON, BATTLER_CATEGORY_DEFENDER, BMON_DATA_MOVE_EFFECT, MOVE_EFFECT_FLAG_ABILITY_SUPPRESSED
    // {0}’s ability was suppressed!
    PrintMessage msg_0197_01012, TAG_NICKNAME, BATTLER_CATEGORY_DEFENDER
    Wait 
    WaitButtonABTime 30
    End 

_034:
    UpdateVar OPCODE_FLAG_ON, BSCRIPT_VAR_MOVE_STATUS_FLAGS, MOVE_STATUS_FAILED
    End 
