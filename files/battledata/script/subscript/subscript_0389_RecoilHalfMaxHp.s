    .include "macros/btlcmd.inc"

    .data

// Chloroblast's recoil: half of the user's own maximum HP, whatever the move
// dealt, once the move is over (TryRecoil, the engine's
// Activate_RecoilDamage), which asks Rock Head and Magic Guard and that the
// move dealt damage. With Parental Bond it comes once, after both strikes.
//
// The reference halves the negated total; this engine's round-up truncates
// toward zero rather than away from it, so the halving comes first and the
// sign after. The numbers are then the reference's.
_000:
    UpdateVarFromVar OPCODE_SET, BSCRIPT_VAR_MSG_BATTLER_TEMP, BSCRIPT_VAR_BATTLER_ATTACKER
    UpdateMonDataFromVar OPCODE_GET, BATTLER_CATEGORY_ATTACKER, BMON_DATA_MAXHP, BSCRIPT_VAR_HP_CALC
    DivideVarByValueRoundUp BSCRIPT_VAR_HP_CALC, 2
    UpdateVar OPCODE_MUL, BSCRIPT_VAR_HP_CALC, -1
    UpdateVar OPCODE_FLAG_ON, BSCRIPT_VAR_BATTLE_STATUS, BATTLE_STATUS_NO_BLINK
    Call BATTLE_SUBSCRIPT_UPDATE_HP
    // {0} is hit with recoil!
    PrintMessage msg_0197_00279, TAG_NICKNAME, BATTLER_CATEGORY_ATTACKER
    Wait 
    WaitButtonABTime 30
    End 
