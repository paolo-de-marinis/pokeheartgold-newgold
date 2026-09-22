    .include "macros/btlcmd.inc"

    .data

// Charge, but earned by being hit rather than by spending a turn, so without
// the Sp. Def stage the move grants. The holder need not have survived it.
_000:
    WaitButtonABTime 15
    UpdateMonData OPCODE_FLAG_ON, BATTLER_CATEGORY_DEFENDER, BMON_DATA_MOVE_EFFECT, MOVE_EFFECT_FLAG_CHARGE
    UpdateMonData OPCODE_SET, BATTLER_CATEGORY_DEFENDER, BMON_DATA_CHARGED_TURNS, 2
    // {0} began charging power!
    PrintMessage msg_0197_00487, TAG_NICKNAME, BATTLER_CATEGORY_DEFENDER
    Wait 
    WaitButtonABTime 30
    End 
