    .include "macros/btlcmd.inc"

    .data

// Chloroblast's recoil: half of the user's own maximum HP, whatever the move
// dealt. Rock Head and Magic Guard refuse it, the way they refuse the recoil
// that is a share of the damage -- the reference asks them in the C that
// loads this script, and this game asks them here, as its other recoil
// subscripts do.
//
// The reference halves the negated total; this engine's round-up truncates
// toward zero rather than away from it, so the halving comes first and the
// sign after. The numbers are then the reference's.
_000:
    CheckAbility CHECK_OPCODE_HAVE, BATTLER_CATEGORY_ATTACKER, ABILITY_ROCK_HEAD, _END
    CheckAbility CHECK_OPCODE_HAVE, BATTLER_CATEGORY_ATTACKER, ABILITY_MAGIC_GUARD, _END
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

_END:
    End 
