    .include "macros/btlcmd.inc"

    .data

// Smack Down and Thousand Arrows, for the Pokemon in battlerIdStatChange,
// once the move's hit has been answered (TryFallAfterHit). Something already
// standing on the ground
// cannot be knocked onto it, which is the whole of the failure case: the
// reference asks IsClientGrounded and gives up, and GotoIfGrounded asks this
// tree's BattlerIsGrounded the same question.
_000:
    GotoIfGrounded BATTLER_CATEGORY_SIDE_EFFECT_MON, _END
    CompareMonDataToValue OPCODE_FLAG_SET, BATTLER_CATEGORY_SIDE_EFFECT_MON, BMON_DATA_MOVE_EFFECT, MOVE_EFFECT_FLAG_FLY, _CANCEL_FLY
    GoTo _GROUND

_CANCEL_FLY:
    UnlockMoveChoice BATTLER_CATEGORY_SIDE_EFFECT_MON
    ToggleVanish BATTLER_CATEGORY_SIDE_EFFECT_MON, FALSE
    // The reference's script stops at the two lines above. It can afford to:
    // here the Fly flag is cleared by Fly's own second turn, and that turn is
    // the one just taken away, so clearing it is left to this.
    UpdateMonData OPCODE_FLAG_OFF, BATTLER_CATEGORY_SIDE_EFFECT_MON, BMON_DATA_MOVE_EFFECT, MOVE_EFFECT_FLAG_FLY
    Wait

_GROUND:
    UpdateMonData OPCODE_FLAG_ON, BATTLER_CATEGORY_SIDE_EFFECT_MON, BMON_DATA_MOVE_EFFECT, MOVE_EFFECT_FLAG_SMACK_DOWN
    UpdateMonData OPCODE_SET, BATTLER_CATEGORY_SIDE_EFFECT_MON, BMON_DATA_MAGNET_RISE_TURNS, 0
    // Telekinesis ends too (Pokemon Central, Abbattimento), by Gravity's case
    // of SetMoveConditionFlag, which zeroes its turns.
    SetMoveConditionFlag MOVE_GRAVITY, BATTLER_CATEGORY_SIDE_EFFECT_MON
    // {0} fell straight down!
    PrintMessage msg_0197_01784, TAG_NICKNAME, BATTLER_CATEGORY_SIDE_EFFECT_MON
    Wait
    WaitButtonABTime 30

_END:
    End
