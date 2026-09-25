#include "global.h"

#include "constants/move_effects.h"

#include "battle/trainer_ai.h"

// The AI's read-only tables beside its script (trainer_ai_script.c): Low
// Kick's weight table and the two effect lists, each ended by 0xFFFF
// (trainer_ai.h). The AI command table (trainer_ai_0222B0B4.c) follows them.

// Low Kick's and Grass Knot's power by the target's weight in tenths of a
// kilogram: the first row whose weight is at least the target's.
const u16 ov10_0222B068[][2] = {
    { 100, 20 },
    { 250, 40 },
    { 500, 60 },
    { 1000, 80 },
    { 2000, 100 },
    { 0xFFFF, 0xFFFF },
};

// Effects whose damage the AI estimates whatever their listed power: the
// power, the type or the damage is worked out when the move is used
// (ov10_0221F084).
const u16 ov10_0222B080[] = {
    MOVE_EFFECT_RANDOM_POWER_BASED_ON_IVS,
    MOVE_EFFECT_POWER_BASED_ON_LOW_SPEED,
    MOVE_EFFECT_NATURAL_GIFT,
    MOVE_EFFECT_JUDGEMENT,
    MOVE_EFFECT_40_DAMAGE_FLAT,
    MOVE_EFFECT_LEVEL_DAMAGE_FLAT,
    MOVE_EFFECT_RANDOM_DAMAGE_1_TO_150_LEVEL,
    MOVE_EFFECT_POWER_BASED_ON_FRIENDSHIP,
    MOVE_EFFECT_POWER_BASED_ON_LOW_FRIENDSHIP,
    MOVE_EFFECT_10_DAMAGE_FLAT,
    MOVE_EFFECT_INCREASE_POWER_WITH_WEIGHT,
    MOVE_EFFECT_BEAT_UP, // one hit per member, its table power the engine's 1
    0xFFFF,
};

// Effects the AI never compares by damage: the ones that faint, charge,
// recharge, lower the user's stats or depend on the order of the turn.
const u16 ov10_0222B098[] = {
    MOVE_EFFECT_HALVE_DEFENSE,
    MOVE_EFFECT_RECOVER_DAMAGE_SLEEP,
    MOVE_EFFECT_CHARGE_TURN_HIGH_CRIT,
    MOVE_EFFECT_CHARGE_TURN_HIGH_CRIT_FLINCH,
    MOVE_EFFECT_RECHARGE_AFTER,
    MOVE_EFFECT_CHARGE_TURN_DEF_UP,
    MOVE_EFFECT_151, // Solar Beam's charge
    MOVE_EFFECT_SPIT_UP,
    MOVE_EFFECT_HIT_LAST_WHIFF_IF_HIT,
    182, // Superpower's drop, which move_effects.h does not name
    MOVE_EFFECT_DECREASE_POWER_WITH_LESS_USER_HP,
    MOVE_EFFECT_HIT_FIRST_IF_TARGET_ATTACKING,
    MOVE_EFFECT_RECOIL_HALF,
    0xFFFF,
};
