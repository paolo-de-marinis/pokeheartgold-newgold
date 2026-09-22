    .include "macros/btlcmd.inc"

    .data

// As One is two abilities wearing one name, so it says that first and then
// speaks as the half that has something to say on entry, which is Unnerve.
// The ability the message prints is the one the C left in the temporary slot
// rather than the one the Pokemon carries, for exactly that reason.
_000:
    CheckAbility CHECK_OPCODE_HAVE, BATTLER_CATEGORY_MSG_BATTLER_TEMP, ABILITY_AS_ONE_GLASTRIER, _TWO_ABILITIES
    CheckAbility CHECK_OPCODE_NOT_HAVE, BATTLER_CATEGORY_MSG_BATTLER_TEMP, ABILITY_AS_ONE_SPECTRIER, _UNNERVE

_TWO_ABILITIES:
    // {0} has two Abilities!
    PrintMessage msg_0197_01280, TAG_NICKNAME, BATTLER_CATEGORY_MSG_BATTLER_TEMP
    Wait
    WaitButtonABTime 30

_UNNERVE:
    // {0}’s {1} makes the opposing team too nervous to eat Berries!
    PrintMessage msg_0197_01279, TAG_NICKNAME_ABILITY, BATTLER_CATEGORY_MSG_BATTLER_TEMP, BATTLER_CATEGORY_MSG_TEMP
    Wait
    WaitButtonABTime 30
    End
