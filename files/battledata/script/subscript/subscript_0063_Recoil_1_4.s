    .include "macros/btlcmd.inc"

    .data

// A share of all the damage the move dealt, once the move is over
// (TryRecoil, the engine's Activate_RecoilDamage), which asks Rock Head and
// Magic Guard and that there was damage. So Parental Bond's two strikes cost
// one recoil, from both (Pokemon Central, Amorefiliale). The move's damage is
// what the attacker has dealt since the action began (shellBellDamage).
_000:
    UpdateVarFromVar OPCODE_SET, BSCRIPT_VAR_MSG_BATTLER_TEMP, BSCRIPT_VAR_BATTLER_ATTACKER
    UpdateVarFromVar OPCODE_SET, BSCRIPT_VAR_HP_CALC, BSCRIPT_VAR_ATTACKER_SHELL_BELL_DAMAGE_DEALT
    CompareVarToValue OPCODE_EQU, BSCRIPT_VAR_HP_CALC, 0, _END
    DivideVarByValue BSCRIPT_VAR_HP_CALC, 4
    UpdateVar OPCODE_FLAG_ON, BSCRIPT_VAR_BATTLE_STATUS, BATTLE_STATUS_NO_BLINK
    Call BATTLE_SUBSCRIPT_UPDATE_HP
    // {0} is hit with recoil!
    PrintMessage msg_0197_00279, TAG_NICKNAME, BATTLER_CATEGORY_ATTACKER
    Wait 
    WaitButtonABTime 30
_END:
    End 
