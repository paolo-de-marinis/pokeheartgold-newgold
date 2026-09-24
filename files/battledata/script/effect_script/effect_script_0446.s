    .include "macros/btlcmd.inc"

    .data

// Revival Blessing (Pokemon Central, Preghiera Vitale): the user picks a
// fainted Pokemon of its party -- the player from the party menu, which will
// take nothing else and cannot be closed without one, the trainer AI the
// first in its party -- and it is revived with half its maximum HP; the move
// fails with none to revive. In a double battle, one whose own place stands
// empty goes back into it at once. SetMoveConditionFlag does the two steps
// (RevivalBlessingStep).
_000:
    SetMoveConditionFlag MOVE_REVIVAL_BLESSING, BATTLER_CATEGORY_ATTACKER
    CompareVarToValue OPCODE_EQU, BSCRIPT_VAR_CALC_TEMP, 0, _FAIL
    PrintAttackMessage
    Wait
    PlayMoveAnimation BATTLER_CATEGORY_ATTACKER
    Wait
    ShowParty
    WaitMonSelection
    // {0} was revived and is ready to fight again!
    PrintMessage msg_0197_01945, TAG_NICKNAME, BATTLER_CATEGORY_SWITCHED_MON_AFTER
    Wait
    WaitButtonABTime 30
    SetMoveConditionFlag MOVE_REVIVAL_BLESSING, BATTLER_CATEGORY_ATTACKER
    CompareVarToValue OPCODE_EQU, BSCRIPT_VAR_CALC_TEMP, 0, _END
    SwitchAndUpdateMon BATTLER_CATEGORY_SWITCHED_MON
    LoadPartyGaugeGraphics
    ShowPartyGauge BATTLER_CATEGORY_SWITCHED_MON
    Wait
    PrintSendOutMessage BATTLER_CATEGORY_SWITCHED_MON
    Wait
    HidePartyGauge BATTLER_CATEGORY_SWITCHED_MON
    Wait
    FreePartyGaugeGraphics
    PokemonSendOut BATTLER_CATEGORY_SWITCHED_MON
    WaitTime 72
    HealthbarSlideIn BATTLER_CATEGORY_SWITCHED_MON
    Wait
    Call BATTLE_SUBSCRIPT_HAZARDS_CHECK
    CompareVarToValue OPCODE_FLAG_NOT, BSCRIPT_VAR_BATTLE_STATUS, BATTLE_STATUS_FAINTED, _END
    Call BATTLE_SUBSCRIPT_FAINT_MON

_END:
    End

_FAIL:
    UpdateVar OPCODE_FLAG_ON, BSCRIPT_VAR_MOVE_STATUS_FLAGS, MOVE_STATUS_FAILED
    End
