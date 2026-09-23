    .include "macros/btlcmd.inc"

    .data

// Parental Bond: one recoil, after the last strike, for the damage both
// strikes dealt (Pokemon Central, Amorefiliale). The first strike leaves it to
// the second unless it felled the target, which ends the move. The move's
// damage so far is what the attacker has dealt since the move began
// (shellBellDamage, cleared with the move's state): this strike's without
// the ability, both strikes' with it.
// A first strike that Effect Spore answers with sleep also ends the move
// and leaves no recoil: telling would take the multi-strike loop's own check.
_000:
    CheckAbility CHECK_OPCODE_HAVE, BATTLER_CATEGORY_ATTACKER, ABILITY_ROCK_HEAD, _038
    CheckAbility CHECK_OPCODE_HAVE, BATTLER_CATEGORY_ATTACKER, ABILITY_MAGIC_GUARD, _038
    GotoIfFirstHitOfParentalBond _FIRST_STRIKE

_RECOIL:
    UpdateVarFromVar OPCODE_SET, BSCRIPT_VAR_MSG_BATTLER_TEMP, BSCRIPT_VAR_BATTLER_ATTACKER
    UpdateVarFromVar OPCODE_SET, BSCRIPT_VAR_HP_CALC, BSCRIPT_VAR_ATTACKER_SHELL_BELL_DAMAGE_DEALT
    CompareVarToValue OPCODE_EQU, BSCRIPT_VAR_HP_CALC, 0, _025
    DivideVarByValue BSCRIPT_VAR_HP_CALC, 3

_025:
    UpdateVar OPCODE_FLAG_ON, BSCRIPT_VAR_BATTLE_STATUS, BATTLE_STATUS_NO_BLINK
    Call BATTLE_SUBSCRIPT_UPDATE_HP
    // {0} is hit with recoil!
    PrintMessage msg_0197_00279, TAG_NICKNAME, BATTLER_CATEGORY_ATTACKER
    Wait 
    WaitButtonABTime 30

_038:
    End 

_FIRST_STRIKE:
    CompareMonDataToValue OPCODE_NEQ, BATTLER_CATEGORY_DEFENDER, BMON_DATA_HP, 0, _038
    GoTo _RECOIL
