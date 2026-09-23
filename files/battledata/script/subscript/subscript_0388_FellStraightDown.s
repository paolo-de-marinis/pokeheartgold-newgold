    .include "macros/btlcmd.inc"

    .data

// Smack Down and Thousand Arrows. Something already standing on the ground
// cannot be knocked onto it, which is the whole of the failure case: the
// reference asks IsClientGrounded and gives up, and GotoIfGrounded asks this
// tree's BattlerIsGrounded the same question.
_000:
    GotoIfGrounded BATTLER_CATEGORY_DEFENDER, _END
    CompareMonDataToValue OPCODE_FLAG_SET, BATTLER_CATEGORY_DEFENDER, BMON_DATA_MOVE_EFFECT, MOVE_EFFECT_FLAG_FLY, _CANCEL_FLY
    GoTo _GROUND

_CANCEL_FLY:
    UnlockMoveChoice BATTLER_CATEGORY_DEFENDER
    ToggleVanish BATTLER_CATEGORY_DEFENDER, FALSE
    // The reference's script stops at the two lines above. It can afford to:
    // here the Fly flag is cleared by Fly's own second turn, and that turn is
    // the one just taken away, so clearing it is left to this.
    UpdateMonData OPCODE_FLAG_OFF, BATTLER_CATEGORY_DEFENDER, BMON_DATA_MOVE_EFFECT, MOVE_EFFECT_FLAG_FLY
    Wait

_GROUND:
    UpdateMonData OPCODE_FLAG_ON, BATTLER_CATEGORY_DEFENDER, BMON_DATA_MOVE_EFFECT, MOVE_EFFECT_FLAG_SMACK_DOWN
    UpdateMonData OPCODE_SET, BATTLER_CATEGORY_DEFENDER, BMON_DATA_MAGNET_RISE_TURNS, 0
    // {0} fell straight down!
    PrintMessage msg_0197_01784, TAG_NICKNAME, BATTLER_CATEGORY_DEFENDER
    Wait
    WaitButtonABTime 30

_END:
    End
