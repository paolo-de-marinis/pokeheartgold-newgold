    .include "macros/btlcmd.inc"

    .data

// Protosynthesis and Quark Drive switching on. Which of the two it is decides
// only the first line; the stat named in the second was picked out in
// BattleContext_ActivateParadoxAbility and left in the temporary message
// variable.
//
// The reference's own copy of this script names the ability in the Quark Drive
// line with BSCRIPT_VAR_CALC_TEMP, which is a script variable standing where a
// battler category belongs and would read out some other Pokemon's ability.
// That is a slip rather than a behaviour, so the battler below is the same one
// the rest of the script uses.

_000:
    CheckAbility CHECK_OPCODE_HAVE, BATTLER_CATEGORY_MSG_BATTLER_TEMP, ABILITY_QUARK_DRIVE, _QuarkDrive
    // The harsh sunlight activated {0}'s {1}!
    PrintMessage msg_0197_01683, TAG_NICKNAME_ABILITY, BATTLER_CATEGORY_MSG_BATTLER_TEMP, BATTLER_CATEGORY_MSG_BATTLER_TEMP
    Wait
    WaitButtonABTime 30
    GoTo _StatRaised

_QuarkDrive:
    // The Electric Terrain activated {0}'s {1}!
    PrintMessage msg_0197_01686, TAG_NICKNAME_ABILITY, BATTLER_CATEGORY_MSG_BATTLER_TEMP, BATTLER_CATEGORY_MSG_BATTLER_TEMP
    Wait
    WaitButtonABTime 30

_StatRaised:
    // {0}'s {1} was heightened!
    PrintMessage msg_0197_01689, TAG_NICKNAME_STAT, BATTLER_CATEGORY_MSG_BATTLER_TEMP, BATTLER_CATEGORY_MSG_TEMP
    Wait
    WaitButtonABTime 30
    End
