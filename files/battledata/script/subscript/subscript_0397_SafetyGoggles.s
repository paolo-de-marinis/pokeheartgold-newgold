    .include "macros/btlcmd.inc"

    .data

// A powder move landing on a pair of Safety Goggles: the move is announced,
// then refused. The same shape as the Soundproof script above it, with the
// item named in the sentence rather than looked up -- the reference's line
// spells "Safety Goggles" out, because it is the only item that prints it.

_000:
    PrintAttackMessage
    Wait
    WaitButtonABTime 15
    UpdateVar OPCODE_FLAG_ON, BSCRIPT_VAR_MOVE_STATUS_FLAGS, MOVE_STATUS_FAILED
    // {0} is not affected by {1} thanks to its Safety Goggles!
    PrintMessage msg_0197_01367, TAG_NICKNAME_MOVE, BATTLER_CATEGORY_DEFENDER, BATTLER_CATEGORY_ATTACKER
    Wait
    WaitButtonABTime 30
    End
