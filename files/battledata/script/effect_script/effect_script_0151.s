    .include "macros/btlcmd.inc"

    .data

// Solar Beam and Solar Blade: the engine's script (d0380a487), its first turn
// the controller's (TryChargeTurn). What reaches it unlocked is a move the
// sun fires at once (SolarBeamFiresAtOnce): the attack message and "absorbed
// light!" before the hit, as the engine and Showdown's gen-9 -prepare say it
// in harsh sunlight too. Not the engine's PlayMoveAnimation there, which
// would play the move a second time with the hit here, nor its Mega Sol
// popup, which it shows off the raw ability.
_000:
    CompareMonDataToValue OPCODE_FLAG_SET, BATTLER_CATEGORY_ATTACKER, BMON_DATA_STATUS2, STATUS2_LOCKED_INTO_MOVE, _033
    PrintAttackMessage
    Wait
    WaitButtonABTime 30
    // {0} absorbed light!
    PrintMessage msg_0197_00214, TAG_NICKNAME, BATTLER_CATEGORY_ATTACKER
    Wait
    WaitButtonABTime 30
    CompareVarToValue OPCODE_EQU, BSCRIPT_VAR_BATTLER_TARGET, BATTLER_NONE, _035

_033:
    UpdateVar OPCODE_FLAG_OFF, BSCRIPT_VAR_BATTLE_STATUS, BATTLE_STATUS_MOVE_ANIMATIONS_OFF
    CalcCrit
    CalcDamage

_035:
    Call BATTLE_SUBSCRIPT_CHARGE_MOVE_CLEANUP
    End
