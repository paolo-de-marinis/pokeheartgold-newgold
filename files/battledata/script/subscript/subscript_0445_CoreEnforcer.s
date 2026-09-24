    .include "macros/btlcmd.inc"

    .data

// Core Enforcer, after its hit: a target that has already acted this turn --
// used its move, or had its trainer use an item on it -- has its ability
// suppressed for as long as it stays in, as Gastro Acid's is, a substitute
// no bar (Pokemon Central, Nucleocastigo). The abilities nothing suppresses,
// and an Ability Shield, keep theirs, as for Gastro Acid (subscript 163).
_000:
    IfMovedThisTurn BATTLER_CATEGORY_DEFENDER, _ACTED
    GoTo _END

_ACTED:
    CompareMonDataToValue OPCODE_FLAG_SET, BATTLER_CATEGORY_DEFENDER, BMON_DATA_MOVE_EFFECT, MOVE_EFFECT_FLAG_ABILITY_SUPPRESSED, _END
    // What nothing suppresses, the ability table's, as for Gastro Acid
    // (subscript 163).
    CompareMonDataToValue OPCODE_FLAG_SET, BATTLER_CATEGORY_DEFENDER, BMON_DATA_ABILITY_FLAGS, ABILITY_FLAG_FAILS_SUPPRESS, _END
    // An Ability Shield keeps the ability working (Pokemon Central, Scudo abilita).
    CompareMonDataToValue OPCODE_EQU, BATTLER_CATEGORY_DEFENDER, BMON_DATA_HELD_ITEM, ITEM_ABILITY_SHIELD, _END
    UpdateMonData OPCODE_FLAG_ON, BATTLER_CATEGORY_DEFENDER, BMON_DATA_MOVE_EFFECT, MOVE_EFFECT_FLAG_ABILITY_SUPPRESSED
    // {0}'s ability was suppressed!
    PrintMessage msg_0197_01012, TAG_NICKNAME, BATTLER_CATEGORY_DEFENDER
    Wait
    WaitButtonABTime 30

_END:
    End
