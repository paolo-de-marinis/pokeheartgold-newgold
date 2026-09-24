    .include "macros/btlcmd.inc"

    .data

// Throat Chop's silence, an added effect of its hit: the target cannot use a
// sound move until the end of the next turn (Pokemon Central, Colpo
// Infernale). The roll that brings it here is what Sheer Force and the Covert
// Cloak stop, and a substitute that took the hit keeps it off; Shield Dust
// keeps it off here, as it does every added effect.
_000:
    CheckIgnorableAbility CHECK_OPCODE_HAVE, BATTLER_CATEGORY_SIDE_EFFECT_MON, ABILITY_SHIELD_DUST, _END
    SetMoveConditionFlag MOVE_THROAT_CHOP, BATTLER_CATEGORY_SIDE_EFFECT_MON

_END:
    End
