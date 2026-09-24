    .include "macros/btlcmd.inc"

    .data

// The hold Thousand Waves, Anchor Shot and Spirit Shackle put on a Pokemon
// they hit, once the move is over. TryHoldAfterHit has asked everything else
// and names the Pokemon the side-effect battler, so that each Pokemon a
// spread move hit can be held in turn. Mean Look's own hold (subscript 86),
// which lasts while the user stays in.
_000:
    UpdateMonData OPCODE_FLAG_ON, BATTLER_CATEGORY_SIDE_EFFECT_MON, BMON_DATA_STATUS2, STATUS2_MEAN_LOOK
    UpdateMonDataFromVar OPCODE_SET, BATTLER_CATEGORY_SIDE_EFFECT_MON, BMON_DATA_MEAN_LOOK_TARGET, BSCRIPT_VAR_BATTLER_ATTACKER
    // {0} can no longer escape!
    PrintMessage msg_0197_00408, TAG_NICKNAME, BATTLER_CATEGORY_SIDE_EFFECT_MON
    Wait 
    WaitButtonABTime 30
    End 
