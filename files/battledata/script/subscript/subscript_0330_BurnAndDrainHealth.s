    .include "macros/btlcmd.inc"

    .data

// Matcha Gotcha, on every hit: the user drains half the damage dealt, and
// then the target is burned one time in five (Pokemon Central, Spruzzate).
// The burn is the move's additional effect and the drain is not, so Sheer
// Force, which trades the burn for power, and a Covert Cloak on the target
// stop the burn alone; ov12_02250490 leaves both to this subscript for this
// move. Shield Dust is the burn subscript's to ask.
Start:
    Call BATTLE_SUBSCRIPT_DRAIN_HALF_DAMAGE_DEALT
    CheckAbility CHECK_OPCODE_HAVE, BATTLER_CATEGORY_ATTACKER, ABILITY_SHEER_FORCE, NoBurn
    CheckItemHoldEffect CHECK_OPCODE_HAVE, BATTLER_CATEGORY_DEFENDER, HOLD_EFFECT_PREVENT_SECONDARY_EFFECTS, NoBurn
    CheckEffectActivation NoBurn
    Call BATTLE_SUBSCRIPT_BURN

NoBurn:
    End
