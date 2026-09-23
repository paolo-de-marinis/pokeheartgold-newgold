    .include "macros/btlcmd.inc"

    .data

_000:
    // Aroma Veil on the target's side keeps a heal block off it. The status
    // move is turned away before it lands, so what gets here is Psychic
    // Noise's, which simply does not take (Pokemon Central, Aromavelo).
    CheckIgnorableAbility CHECK_OPCODE_HAVE, BATTLER_CATEGORY_DEFENDER, ABILITY_AROMA_VEIL, _AROMA_VEIL
    CompareMonDataToValue OPCODE_EQU, BATTLER_RELATIVE_ALLY|BATTLER_CATEGORY_DEFENDER, BMON_DATA_HP, 0, _NO_AROMA_VEIL
    CheckIgnorableAbility CHECK_OPCODE_HAVE, BATTLER_RELATIVE_ALLY|BATTLER_CATEGORY_DEFENDER, ABILITY_AROMA_VEIL, _AROMA_VEIL

_NO_AROMA_VEIL:
    CheckSubstitute BATTLER_CATEGORY_DEFENDER, _028
    CompareMonDataToValue OPCODE_NEQ, BATTLER_CATEGORY_DEFENDER, BMON_DATA_HEAL_BLOCK_TURNS, 0, _028
    Call BATTLE_SUBSCRIPT_ATTACK_MESSAGE_AND_ANIMATION
    UpdateMonData OPCODE_FLAG_ON, BATTLER_CATEGORY_DEFENDER, BMON_DATA_MOVE_EFFECT, MOVE_EFFECT_FLAG_HEAL_BLOCK
    UpdateMonData OPCODE_SET, BATTLER_CATEGORY_DEFENDER, BMON_DATA_HEAL_BLOCK_TURNS, 5
    // {0} was prevented from healing!
    PrintMessage msg_0197_01051, TAG_NICKNAME, BATTLER_CATEGORY_DEFENDER
    Wait 
    WaitButtonABTime 30
    End 

_028:
    PrintAttackMessage 
    Wait 
    WaitButtonABTime 15
    // It failed to affect {0}!
    PrintMessage msg_0197_01235, TAG_NICKNAME, BATTLER_CATEGORY_DEFENDER
    Wait 
    WaitButtonABTime 30
    UpdateVar OPCODE_FLAG_ON, BSCRIPT_VAR_MOVE_STATUS_FLAGS, MOVE_STATUS_NO_MORE_WORK
    End 

_AROMA_VEIL:
    End
