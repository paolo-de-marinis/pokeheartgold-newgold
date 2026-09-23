    .include "macros/btlcmd.inc"

    .data

// Poison Puppeteer (Pokemon Central, Malia Tossica): a Pokemon the ability's
// Pokemon poisons, or badly poisons, with a move is confused as well -- not by
// Toxic Spikes, an ability's poison or a Toxic Orb, and not one already
// confused, which the ability passes over without a word. Own Tempo and
// Safeguard keep the confusion off as they keep any off. The Poison and Bad
// Poison subscripts call this once the poison has taken. The reference
// declares the ability and reads it only in its lists of what cannot be
// copied.
_000:
    CompareVarToValue OPCODE_EQU, BSCRIPT_VAR_SIDE_EFFECT_TYPE, SIDE_EFFECT_TYPE_ABILITY, _END
    CompareVarToValue OPCODE_EQU, BSCRIPT_VAR_SIDE_EFFECT_TYPE, SIDE_EFFECT_TYPE_HELD_ITEM, _END
    CompareVarToValue OPCODE_EQU, BSCRIPT_VAR_SIDE_EFFECT_TYPE, SIDE_EFFECT_TYPE_TOXIC_SPIKES, _END
    CheckAbility CHECK_OPCODE_NOT_HAVE, BATTLER_CATEGORY_ATTACKER, ABILITY_POISON_PUPPETEER, _END
    CompareMonDataToValue OPCODE_EQU, BATTLER_CATEGORY_SIDE_EFFECT_MON, BMON_DATA_HP, 0, _END
    CompareMonDataToValue OPCODE_FLAG_SET, BATTLER_CATEGORY_SIDE_EFFECT_MON, BMON_DATA_STATUS2, STATUS2_CONFUSION, _END
    CheckIgnorableAbility CHECK_OPCODE_HAVE, BATTLER_CATEGORY_SIDE_EFFECT_MON, ABILITY_OWN_TEMPO, _END
    CompareVarToValue OPCODE_FLAG_SET, BSCRIPT_VAR_SIDE_CONDITION_STAT_CHANGE, SIDE_CONDITION_SAFEGUARD, _END
    AbilityPopup BATTLER_CATEGORY_ATTACKER, -1
    PlayBattleAnimation BATTLER_CATEGORY_SIDE_EFFECT_MON, BATTLE_ANIMATION_CONFUSED
    Wait
    Random 3, 2
    UpdateMonDataFromVar OPCODE_FLAG_ON, BATTLER_CATEGORY_SIDE_EFFECT_MON, BMON_DATA_STATUS2, BSCRIPT_VAR_CALC_TEMP
    // {0} became confused!
    PrintMessage msg_0197_00156, TAG_NICKNAME, BATTLER_CATEGORY_SIDE_EFFECT_MON
    Wait
    WaitButtonABTime 30

_END:
    End
