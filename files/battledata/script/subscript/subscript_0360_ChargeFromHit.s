    .include "macros/btlcmd.inc"

    .data

// Charge, but earned by being hit, or by Tailwind starting on its side,
// rather than by spending a turn, so without the Sp. Def stage the move
// grants. The holder need not have survived it. The holder is the temporary
// battler: a hit's target, or the Wind Power Pokemon beside the one whose
// Tailwind it was (TryAbilityOnEntry), which the move's target is not.
_000:
    WaitButtonABTime 15
    UpdateMonData OPCODE_FLAG_ON, BATTLER_CATEGORY_MSG_BATTLER_TEMP, BMON_DATA_MOVE_EFFECT, MOVE_EFFECT_FLAG_CHARGE
    UpdateMonData OPCODE_SET, BATTLER_CATEGORY_MSG_BATTLER_TEMP, BMON_DATA_CHARGED_TURNS, 2
    // {0} began charging power!
    PrintMessage msg_0197_00487, TAG_NICKNAME, BATTLER_CATEGORY_MSG_BATTLER_TEMP
    Wait 
    WaitButtonABTime 30
    End 
