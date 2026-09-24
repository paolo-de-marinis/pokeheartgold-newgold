    .include "macros/btlcmd.inc"

    .data

// Ally Switch: the user and its ally change places in a double battle
// (Pokemon Central, Cambiaposto). SetMoveConditionFlag asks whether it works
// -- not in a single or a multi battle, not beside a fainted ally, not once
// the ally has switched places this turn, and in a row as Protect does --
// and if it does moves the two Pokemon over, so from then on the user's
// battler is its new place. Both places are drawn again: a substitute goes
// first, the new Pokemon appears as a form change has it, then its own
// substitute, and one in the air or underground keeps out of sight, as does
// a Tatsugiri in its Dondozo's mouth (Pokemon Showdown swaps the pair as it
// swaps any other; Pokemon Central says nothing of it).
_000:
    SetMoveConditionFlag MOVE_ALLY_SWITCH, BATTLER_CATEGORY_ATTACKER
    CompareVarToValue OPCODE_EQU, BSCRIPT_VAR_CALC_TEMP, 0, _FAILED
    PrintAttackMessage
    Wait
    WaitButtonABTime 15
    // The user's old place, where its ally is now, had the user's substitute.
    CompareMonDataToValue OPCODE_FLAG_NOT, BATTLER_CATEGORY_ATTACKER, BMON_DATA_STATUS2, STATUS2_SUBSTITUTE, _ALLY_WAS_BEHIND_ONE
    PlayBattleAnimation BATTLER_CATEGORY_ATTACKER_PARTNER, BATTLE_ANIMATION_SUB_OUT
    Wait
    RestoreSprite BATTLER_CATEGORY_ATTACKER_PARTNER
    Wait
    PlayBattleAnimation BATTLER_CATEGORY_ATTACKER_PARTNER, BATTLE_ANIMATION_SUB_IN
    Wait

_ALLY_WAS_BEHIND_ONE:
    CompareMonDataToValue OPCODE_FLAG_NOT, BATTLER_CATEGORY_ATTACKER_PARTNER, BMON_DATA_STATUS2, STATUS2_SUBSTITUTE, _REDRAW
    PlayBattleAnimation BATTLER_CATEGORY_ATTACKER, BATTLE_ANIMATION_SUB_OUT
    Wait
    RestoreSprite BATTLER_CATEGORY_ATTACKER
    Wait
    PlayBattleAnimation BATTLER_CATEGORY_ATTACKER, BATTLE_ANIMATION_SUB_IN
    Wait

_REDRAW:
    PlaySound BATTLER_CATEGORY_ATTACKER, SEQ_SE_DP_W100
    SetMosaic BATTLER_CATEGORY_ATTACKER, 8, 1
    SetMosaic BATTLER_CATEGORY_ATTACKER_PARTNER, 8, 1
    Wait
    ChangeForm BATTLER_CATEGORY_ATTACKER
    ChangeForm BATTLER_CATEGORY_ATTACKER_PARTNER
    PlaySound BATTLER_CATEGORY_ATTACKER, SEQ_SE_DP_W107
    SetMosaic BATTLER_CATEGORY_ATTACKER, 0, 1
    SetMosaic BATTLER_CATEGORY_ATTACKER_PARTNER, 0, 1
    Wait
    HealthbarSlideIn BATTLER_CATEGORY_ATTACKER
    HealthbarSlideIn BATTLER_CATEGORY_ATTACKER_PARTNER
    Wait
    // The user was not in the air; its ally may be, or be the Tatsugiri in
    // the user's mouth (Commander), and is out of sight in its new place and
    // no longer in its old one. A place keeps its sprite, and so whether it
    // is hidden, whoever is drawn on it.
    CompareMonDataToValue OPCODE_NEQ, BATTLER_CATEGORY_ATTACKER_PARTNER, BMON_DATA_COMMANDER, 0, _ALLY_OUT_OF_SIGHT
    CompareMonDataToValue OPCODE_FLAG_NOT, BATTLER_CATEGORY_ATTACKER_PARTNER, BMON_DATA_MOVE_EFFECT, MOVE_EFFECT_FLAG_SEMI_INVULNERABLE, _USER_DOLL

_ALLY_OUT_OF_SIGHT:
    ToggleVanish BATTLER_CATEGORY_ATTACKER, FALSE
    ToggleVanish BATTLER_CATEGORY_ATTACKER_PARTNER, TRUE
    Wait

_USER_DOLL:
    CompareMonDataToValue OPCODE_FLAG_NOT, BATTLER_CATEGORY_ATTACKER, BMON_DATA_STATUS2, STATUS2_SUBSTITUTE, _ALLY_DOLL
    PlayBattleAnimation BATTLER_CATEGORY_ATTACKER, BATTLE_ANIMATION_SUB_OUT
    Wait
    RefreshSprite BATTLER_CATEGORY_ATTACKER
    Wait
    PlayBattleAnimation BATTLER_CATEGORY_ATTACKER, BATTLE_ANIMATION_SUB_IN
    Wait

_ALLY_DOLL:
    CompareMonDataToValue OPCODE_FLAG_NOT, BATTLER_CATEGORY_ATTACKER_PARTNER, BMON_DATA_STATUS2, STATUS2_SUBSTITUTE, _SAY
    PlayBattleAnimation BATTLER_CATEGORY_ATTACKER_PARTNER, BATTLE_ANIMATION_SUB_OUT
    Wait
    RefreshSprite BATTLER_CATEGORY_ATTACKER_PARTNER
    Wait
    PlayBattleAnimation BATTLER_CATEGORY_ATTACKER_PARTNER, BATTLE_ANIMATION_SUB_IN
    Wait

_SAY:
    // {0} and {1} switched places!
    PrintMessage msg_0197_01902, TAG_NICKNAME_NICKNAME, BATTLER_CATEGORY_ATTACKER, BATTLER_CATEGORY_ATTACKER_PARTNER
    Wait
    WaitButtonABTime 30
    End

_FAILED:
    UpdateVar OPCODE_FLAG_ON, BSCRIPT_VAR_MOVE_STATUS_FLAGS, MOVE_STATUS_FAILED
    End
