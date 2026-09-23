    .include "macros/btlcmd.inc"

    .data

// Receiver and Power of Alchemy: when a Pokemon faints, its ally, standing and
// holding either, takes over the ability it had, unless the ability table
// keeps that one from them (Pokemon Central, Ricezione and Forza Chimica).
// The reference declares both abilities and gives them no effect. This game
// has no line for "was taken over", so the ally's line is Entrainment's.
_000:
    CompareMonDataToValue OPCODE_EQU, BATTLER_RELATIVE_ALLY|BATTLER_CATEGORY_FAINTED_MON, BMON_DATA_HP, 0, _END
    CheckAbility CHECK_OPCODE_HAVE, BATTLER_RELATIVE_ALLY|BATTLER_CATEGORY_FAINTED_MON, ABILITY_RECEIVER, _TAKE_OVER
    CheckAbility CHECK_OPCODE_HAVE, BATTLER_RELATIVE_ALLY|BATTLER_CATEGORY_FAINTED_MON, ABILITY_POWER_OF_ALCHEMY, _TAKE_OVER
    GoTo _END

_TAKE_OVER:
    CompareMonDataToValue OPCODE_FLAG_SET, BATTLER_CATEGORY_FAINTED_MON, BMON_DATA_ABILITY_FLAGS, ABILITY_FLAG_FAILS_RECEIVER, _END
    CompareMonDataToValue OPCODE_EQU, BATTLER_CATEGORY_FAINTED_MON, BMON_DATA_ABILITY, ABILITY_NONE, _END
    AbilityPopup BATTLER_RELATIVE_ALLY|BATTLER_CATEGORY_FAINTED_MON, -1
    UpdateMonDataFromVar OPCODE_GET, BATTLER_CATEGORY_FAINTED_MON, BMON_DATA_ABILITY, BSCRIPT_VAR_CALC_TEMP
    UpdateMonDataFromVar OPCODE_SET, BATTLER_RELATIVE_ALLY|BATTLER_CATEGORY_FAINTED_MON, BMON_DATA_ABILITY, BSCRIPT_VAR_CALC_TEMP
    // {0} acquired {1}!
    PrintMessage msg_0197_01021, TAG_NICKNAME_ABILITY, BATTLER_RELATIVE_ALLY|BATTLER_CATEGORY_FAINTED_MON, BATTLER_RELATIVE_ALLY|BATTLER_CATEGORY_FAINTED_MON
    Wait
    WaitButtonABTime 30

_END:
    End
