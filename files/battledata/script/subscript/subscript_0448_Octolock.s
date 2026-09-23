    .include "macros/btlcmd.inc"

    .data

// Octolock, on its hit: the target is held -- Mean Look's flag, with the
// Octolock's user as the trapper -- and marked to lose a stage of Defense and
// Sp. Def at the end of every turn the user stays in (Pokemon Central,
// Tentacolock; the controller's UMC_STATE_OCTOLOCK).
_000:
    UpdateMonData OPCODE_FLAG_ON, BATTLER_CATEGORY_DEFENDER, BMON_DATA_STATUS2, STATUS2_MEAN_LOOK
    UpdateMonDataFromVar OPCODE_SET, BATTLER_CATEGORY_DEFENDER, BMON_DATA_MEAN_LOOK_TARGET, BSCRIPT_VAR_BATTLER_ATTACKER
    SetMoveConditionFlag MOVE_OCTOLOCK, BATTLER_CATEGORY_DEFENDER
    // {0} can no longer escape!
    PrintMessage msg_0197_00408, TAG_NICKNAME, BATTLER_CATEGORY_DEFENDER
    Wait
    WaitButtonABTime 30
    End
