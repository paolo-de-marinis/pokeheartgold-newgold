#include "global.h"

#include "constants/abilities.h"
#include "constants/items.h"
#include "constants/move_effects.h"
#include "constants/moves.h"
#include "constants/pokemon.h"

#include "battle/trainer_ai.h"

// The trainer AI's script. For every move the AI's Pokemon could use, the
// routine of each AI flag its trainer has runs in turn and adds to or takes
// from the move's score; the move with the best score is used. It is a list of
// words: a command's number (AIScriptCommand, the order of the command table
// ov10_0222B0B4) and its arguments. Jumps, calls and tables are word offsets
// counted from the word after the command's last argument; the comment on each
// one gives the word index it reaches, and every line starts with its own.
// Battlers are AI_BATTLER_* (trainer_ai.h). A value compared with the loaded
// one is named for what was loaded where the script loads it in the lines just
// before; the rest are plain numbers, as retail wrote them.

enum AIScriptCommand {
    AI_IF_RANDOM_LESS_THAN, // 00: jumps when a random byte is below the value
    AI_IF_RANDOM_GREATER_THAN, // 01: jumps when a random byte is above the value
    AI_IF_RANDOM_EQUAL_TO, // 02: jumps when a random byte is the value
    AI_IF_RANDOM_NOT_EQUAL_TO, // 03: jumps when a random byte is not the value
    AI_ADD_TO_MOVE_SCORE, // 04: adds to the score of the move being rated
    AI_IF_HP_PERCENT_LESS_THAN, // 05: jumps when the battler has less than the percentage of its HP
    AI_IF_HP_PERCENT_GREATER_THAN, // 06: ... more than the percentage
    AI_IF_HP_PERCENT_EQUAL_TO, // 07: ... exactly the percentage
    AI_IF_HP_PERCENT_NOT_EQUAL_TO, // 08: ... not exactly the percentage
    AI_IF_STATUS, // 09: jumps when the battler has any of the status conditions (STATUS_*)
    AI_IF_NOT_STATUS, // 0A: ... none of them
    AI_IF_VOLATILE_STATUS, // 0B: jumps when the battler has any of the volatile conditions (STATUS2_*)
    AI_IF_NOT_VOLATILE_STATUS, // 0C: ... none of them
    AI_IF_MOVE_EFFECT_FLAG, // 0D: jumps when the battler is under any of the move effects (MOVE_EFFECT_FLAG_*)
    AI_IF_NOT_MOVE_EFFECT_FLAG, // 0E: ... none of them
    AI_IF_SIDE_CONDITION, // 0F: jumps when the battler's side has any of the conditions (SIDE_CONDITION_*)
    AI_IF_NOT_SIDE_CONDITION, // 10: ... none of them
    AI_IF_LOADED_LESS_THAN, // 11: jumps when the loaded value is below the value
    AI_IF_LOADED_GREATER_THAN, // 12: ... above
    AI_IF_LOADED_EQUAL_TO, // 13: ... equal
    AI_IF_LOADED_NOT_EQUAL_TO, // 14: ... not equal
    AI_IF_LOADED_MASK, // 15: jumps when the loaded value has any of the bits
    AI_IF_LOADED_NOT_MASK, // 16: ... none of them
    AI_IF_MOVE_EQUAL_TO, // 17: jumps when the move being rated is the move
    AI_IF_MOVE_NOT_EQUAL_TO, // 18: ... is not
    AI_IF_LOADED_IN_TABLE, // 19: jumps when the loaded value is in the table (ended by AI_TABLE_END)
    AI_IF_LOADED_NOT_IN_TABLE, // 1A: ... is not
    AI_IF_ATTACKER_HAS_DAMAGING_MOVES, // 1B: jumps when the attacker has a move with power
    AI_IF_ATTACKER_HAS_NO_DAMAGING_MOVES, // 1C: ... has none
    AI_LOAD_TURN_COUNT, // 1D: loads the number of turns the battle has run
    AI_LOAD_TYPE_FROM, // 1E: loads a type: 0/2 the target's first/second, 1/3 the attacker's, 4 the move being rated's, 5..8 as 0..3 for the partners (7 reads the first type, as retail does)
    AI_LOAD_MOVE_POWER, // 1F: loads the power of the move being rated
    AI_FLAG_MOVE_DAMAGE_SCORE, // 20: loads 2 when the move being rated does the most damage of the attacker's, 1 when another does more, 0 when it is not compared (argument: whether damage rolls vary)
    AI_LOAD_BATTLER_PREVIOUS_MOVE, // 21: loads the battler's last move
    AI_IF_TEMP_EQUAL_TO, // 22: jumps when the loaded value is the value
    AI_IF_TEMP_NOT_EQUAL_TO, // 23: ... is not
    AI_IF_SPEED_COMPARE_EQUAL_TO, // 24: jumps when the speed order of attacker and target is the value (0 the attacker first)
    AI_IF_SPEED_COMPARE_NOT_EQUAL_TO, // 25: ... is not
    AI_COUNT_ALIVE_PARTY_BATTLERS, // 26: loads how many of the battler's party can still fight, besides those on the field
    AI_LOAD_CURRENT_MOVE, // 27: loads the move being rated
    AI_LOAD_CURRENT_MOVE_EFFECT, // 28: loads its effect
    AI_LOAD_BATTLER_ABILITY, // 29: loads the battler's ability, as far as the AI knows it
    AI_CALC_MAX_EFFECTIVENESS, // 2A: loads the best effectiveness of the attacker's four moves on the target, on 2B's scale
    AI_IF_MOVE_EFFECTIVENESS_EQUALS, // 2B: jumps when the move being rated has the effectiveness (0 immune, 10 x1/4, 20 x1/2, 40 neutral, 80 x2, 160 x4; a neutral STAB move reads 60)
    AI_IF_PARTY_MEMBER_STATUS, // 2C: jumps when any of the battler's benched party, standing and not an Egg, has any of the status conditions
    AI_IF_PARTY_MEMBER_NOT_STATUS, // 2D: ... when any of them has none of the status conditions
    AI_LOAD_CURRENT_WEATHER, // 2E: loads the weather
    AI_IF_CURRENT_MOVE_EFFECT_EQUAL_TO, // 2F: jumps when the move being rated has the effect
    AI_IF_CURRENT_MOVE_EFFECT_NOT_EQUAL_TO, // 30: ... does not
    AI_IF_STAT_STAGE_LESS_THAN, // 31: jumps when the battler's stat (0 HP .. 7 evasion) stage, 6 neutral, is below the value
    AI_IF_STAT_STAGE_GREATER_THAN, // 32: ... above
    AI_IF_STAT_STAGE_EQUAL_TO, // 33: ... equal
    AI_IF_STAT_STAGE_NOT_EQUAL_TO, // 34: ... not equal
    AI_IF_CURRENT_MOVE_KILLS, // 35: jumps when the move being rated would knock the target out (argument: whether damage rolls vary)
    AI_IF_CURRENT_MOVE_DOES_NOT_KILL, // 36: ... would not
    AI_IF_MOVE_KNOWN, // 37: jumps when the battler is known to have the move
    AI_IF_MOVE_NOT_KNOWN, // 38: ... is not
    AI_IF_MOVE_EFFECT_KNOWN, // 39: jumps when the battler is known to have a move with the effect
    AI_IF_MOVE_EFFECT_NOT_KNOWN, // 3A: ... is not
    AI_IF_BATTLER_UNDER_EFFECT, // 3B: jumps when the battler is disabled (0) or encored (1)
    AI_IF_CURRENT_MOVE_MATCHES_EFFECT, // 3C: jumps when the move being rated is the attacker's disabled (0) or encored (1) move
    AI_ESCAPE, // 3D: ends the script: the AI runs from the battle
    AI_IF_RANDOM_SAFARI_FLEE, // 3E: a Safari Zone command left over: this game does nothing, not even step past it
    AI_WATCH, // 3F: a Safari Zone command left over: this game does nothing, not even step past it
    AI_LOAD_HELD_ITEM, // 40: loads the battler's held item: the real one, for any battler
    AI_LOAD_HELD_ITEM_EFFECT, // 41: loads the hold effect of the battler's item, as far as the AI knows it
    AI_LOAD_GENDER, // 42: loads the battler's gender
    AI_LOAD_IS_FIRST_TURN_IN_BATTLE, // 43: loads whether it is the battler's first turn out
    AI_LOAD_STOCKPILE_COUNT, // 44: loads how many times the battler has Stockpiled
    AI_LOAD_BATTLE_TYPE, // 45: loads the battle type flags (BATTLE_TYPE_*)
    AI_LOAD_RECYCLE_ITEM, // 46: loads the item the battler's Recycle would bring back
    AI_LOAD_TYPE_OF_LOADED_MOVE, // 47: loads the type of the move loaded
    AI_LOAD_POWER_OF_LOADED_MOVE, // 48: loads its power
    AI_LOAD_EFFECT_OF_LOADED_MOVE, // 49: loads its effect
    AI_LOAD_PROTECT_CHAIN, // 4A: loads how many times in a row the battler's guards have worked
    AI_CALL, // 4B: calls the routine at the offset; POP_OR_END comes back
    AI_GOTO, // 4C: jumps
    AI_POP_OR_END, // 4D: returns from a routine, or ends the script for this move
    AI_IF_LEVEL, // 4E: jumps when the attacker's level is above (0), below (1) or equal to (2) the target's
    AI_IF_TARGET_IS_TAUNTED, // 4F: jumps when the target is taunted
    AI_IF_TARGET_IS_NOT_TAUNTED, // 50: ... is not
    AI_IF_TARGET_IS_PARTNER, // 51: jumps when the target is the attacker's partner
    AI_FLAG_BATTLER_IS_TYPE, // 52: loads whether the battler has the type
    AI_CHECK_BATTLER_ABILITY, // 53: loads whether the battler has the ability: 1 yes, 0 no, 2 not known
    AI_IF_ACTIVATED_FLASH_FIRE, // 54: jumps when the battler's Flash Fire has been set off
    AI_IF_HELD_ITEM_EQUAL_TO, // 55: jumps when the battler holds the item, as far as the AI knows
    AI_IF_FIELD_CONDITIONS_MASK, // 56: jumps when the field has any of the conditions (FIELD_CONDITION_*)
    AI_LOAD_SPIKES_LAYERS, // 57: loads how many layers of the hazard the battler's side has
    AI_IF_ANY_PARTY_MEMBER_IS_WOUNDED, // 58: jumps when any of the battler's party but the battler itself has lost HP (its partner on the field included, fainted ones too)
    AI_IF_ANY_PARTY_MEMBER_USED_PP, // 59: ... has used PP
    AI_LOAD_FLING_POWER, // 5A: loads the power Fling would have with the battler's item
    AI_LOAD_CURRENT_MOVE_PP, // 5B: loads the PP left of the move being rated
    AI_IF_CAN_USE_LAST_RESORT, // 5C: jumps when the battler could use Last Resort
    AI_LOAD_CURRENT_MOVE_CLASS, // 5D: loads the class of the move being rated (0 physical, 1 special, 2 status)
    AI_LOAD_DEFENDER_LAST_USED_MOVE_CLASS, // 5E: loads the class of the target's last move
    AI_LOAD_BATTLER_SPEED_RANK, // 5F: loads the battler's place in the speed order
    AI_LOAD_BATTLER_TURN_COUNT, // 60: loads how many turns the battler has been out
    AI_IF_PARTY_MEMBER_DEALS_MORE_DAMAGE, // 61: jumps when one of the party would do more damage to the target (argument: whether damage rolls vary)
    AI_IF_HAS_SUPER_EFFECTIVE_MOVE, // 62: jumps when the attacker has a move super effective against a foe
    AI_IF_BATTLER_DEALS_MORE_DAMAGE, // 63: jumps when the battler would do more damage than the attacker
    AI_SUM_POSITIVE_STAT_STAGES, // 64: loads the sum of the battler's raised stat stages
    AI_DIFF_STAT_STAGES, // 65: loads the battler's stat stage less the attacker's
    AI_IF_BATTLER_HAS_HIGHER_STAT, // 66: jumps when the battler's stat is higher than the attacker's
    AI_IF_BATTLER_HAS_LOWER_STAT, // 67: ... lower
    AI_IF_BATTLER_HAS_EQUAL_STAT, // 68: ... equal
    AI_CHECK_IF_HIGHEST_DAMAGE_WITH_PARTNER, // 69: loads 2 when the move being rated does the most damage of the attacker's and its partner's, 1 when not, 0 when it is not compared (argument: whether damage rolls vary)
    AI_IF_BATTLER_FAINTED, // 6A: jumps when the battler, a partner, is being replaced this turn
    AI_IF_BATTLER_NOT_FAINTED, // 6B: ... is not
    AI_LOAD_ABILITY, // 6C: loads the battler's ability
};

// Ends a table.
#define AI_TABLE_END 0xFFFFFFFF

const u32 ov10_02220AAC[] = {
    // Where each AI flag's routine starts, by flag (a word index into this script).
    /* 0000 */ 0x0020, // flag 0, basic: the moves that would fail or do nothing (hg-engine's F_PRIORITIZE_SUPER_EFFECTIVE)
    /* 0001 */ 0x20A3, // flag 1, evaluate attacks (F_EVALUATE_ATTACKS)
    /* 0002 */ 0x09F2, // flag 2, expert (F_EXPERT_ATTACKS)
    /* 0003 */ 0x20E2, // flag 3, set-up and status moves first (F_PRIORITIZE_STATUS_MOVES)
    /* 0004 */ 0x213D, // flag 4, risky (F_RISKY_ATTACKS)
    /* 0005 */ 0x2130, // flag 5, damage first (F_PRIORITIZE_DAMAGE)
    /* 0006 */ 0x2163, // flag 6, Baton Pass (hg-engine's F_MULTI_BATTLE_PARTNER)
    /* 0007 */ 0x21C6, // flag 7, double battles (F_DOUBLE_BATTLE)
    /* 0008 */ 0x27CA, // flag 8, by HP (F_PRIORITIZE_HEALING)
    /* 0009 */ 0x28E6, // flag 9, weather (F_USE_WEATHER)
    /* 000A */ 0x2918, // flag 10, harassment (F_HARRASSMENT)
    /* 000B */ 0x296E, // flag 11, unused: ends at once (hg-engine names 11, 12 and 13 roaming, Safari and catching demo; those routines are 29, 30 and 31)
    /* 000C */ 0x296E, // flag 12, unused: ends at once
    /* 000D */ 0x296E, // flag 13, unused: ends at once
    /* 000E */ 0x296E, // flag 14, unused: ends at once
    /* 000F */ 0x296E, // flag 15, unused: ends at once
    /* 0010 */ 0x296E, // flag 16, unused: ends at once
    /* 0011 */ 0x296E, // flag 17, unused: ends at once
    /* 0012 */ 0x296E, // flag 18, unused: ends at once
    /* 0013 */ 0x296E, // flag 19, unused: ends at once
    /* 0014 */ 0x296E, // flag 20, unused: ends at once
    /* 0015 */ 0x296E, // flag 21, unused: ends at once
    /* 0016 */ 0x296E, // flag 22, unused: ends at once
    /* 0017 */ 0x296E, // flag 23, unused: ends at once
    /* 0018 */ 0x296E, // flag 24, unused: ends at once
    /* 0019 */ 0x296E, // flag 25, unused: ends at once
    /* 001A */ 0x296E, // flag 26, unused: ends at once
    /* 001B */ 0x296E, // flag 27, unused: ends at once
    /* 001C */ 0x296E, // flag 28, unused: ends at once
    /* 001D */ 0x2947, // flag 29, a roaming Pokemon (AI_29, which the battle sets)
    /* 001E */ 0x2960, // flag 30, the Safari Zone (nothing sets it; its commands are empty in this game)
    /* 001F */ 0x2964, // flag 31, the catching tutorial: flees once the target is down to a fifth of its HP (nothing sets it)

    // 0020: flag 0
    /* 0020 */ AI_IF_TARGET_IS_PARTNER, 10572, // -> 296E
    /* 0022 */ AI_IF_MOVE_EQUAL_TO, MOVE_FISSURE, 8, // -> 002D
    /* 0025 */ AI_IF_MOVE_EQUAL_TO, MOVE_HORN_DRILL, 5, // -> 002D
    /* 0028 */ AI_FLAG_MOVE_DAMAGE_SCORE, 0,
    /* 002A */ AI_IF_LOADED_EQUAL_TO, 0, 81, // -> 007E

    // 002D
    /* 002D */ AI_IF_MOVE_EFFECTIVENESS_EQUALS, 0, 2474, // -> 09DA
    /* 0030 */ AI_LOAD_BATTLER_ABILITY, AI_BATTLER_ATTACKER,
    /* 0032 */ AI_IF_LOADED_EQUAL_TO, ABILITY_MOLD_BREAKER, 68, // -> 0079
    /* 0035 */ AI_LOAD_BATTLER_ABILITY, AI_BATTLER_TARGET,
    /* 0037 */ AI_IF_LOADED_EQUAL_TO, ABILITY_VOLT_ABSORB, 20, // -> 004E
    /* 003A */ AI_IF_LOADED_EQUAL_TO, ABILITY_MOTOR_DRIVE, 17, // -> 004E
    /* 003D */ AI_IF_LOADED_EQUAL_TO, ABILITY_WATER_ABSORB, 21, // -> 0055
    /* 0040 */ AI_IF_LOADED_EQUAL_TO, ABILITY_FLASH_FIRE, 25, // -> 005C
    /* 0043 */ AI_IF_LOADED_EQUAL_TO, ABILITY_WONDER_GUARD, 29, // -> 0063
    /* 0046 */ AI_IF_LOADED_EQUAL_TO, ABILITY_LEVITATE, 34, // -> 006B
    // retail asks for Levitate a second time here, so the Water check at 0072 (meant for Dry Skin) is never reached
    /* 0049 */ AI_IF_LOADED_EQUAL_TO, ABILITY_LEVITATE, 38, // -> 0072
    /* 004C */ AI_GOTO, 43, // -> 0079

    // 004E
    /* 004E */ AI_LOAD_TYPE_FROM, 4,
    /* 0050 */ AI_IF_TEMP_EQUAL_TO, TYPE_ELECTRIC, 2442, // -> 09DD
    /* 0053 */ AI_GOTO, 36, // -> 0079

    // 0055
    /* 0055 */ AI_LOAD_TYPE_FROM, 4,
    /* 0057 */ AI_IF_TEMP_EQUAL_TO, TYPE_WATER, 2435, // -> 09DD
    /* 005A */ AI_GOTO, 29, // -> 0079

    // 005C
    /* 005C */ AI_LOAD_TYPE_FROM, 4,
    /* 005E */ AI_IF_TEMP_EQUAL_TO, TYPE_FIRE, 2428, // -> 09DD
    /* 0061 */ AI_GOTO, 22, // -> 0079

    // 0063
    /* 0063 */ AI_IF_MOVE_EFFECTIVENESS_EQUALS, 80, 19, // -> 0079
    /* 0066 */ AI_IF_MOVE_EFFECTIVENESS_EQUALS, 160, 16, // -> 0079
    /* 0069 */ AI_GOTO, 2418, // -> 09DD

    // 006B
    /* 006B */ AI_LOAD_TYPE_FROM, 4,
    /* 006D */ AI_IF_TEMP_EQUAL_TO, TYPE_GROUND, 2413, // -> 09DD
    /* 0070 */ AI_GOTO, 7, // -> 0079

    // 0072
    /* 0072 */ AI_LOAD_TYPE_FROM, 4,
    /* 0074 */ AI_IF_TEMP_EQUAL_TO, TYPE_WATER, 2406, // -> 09DD
    /* 0077 */ AI_GOTO, 0, // -> 0079

    // 0079
    /* 0079 */ AI_FLAG_MOVE_DAMAGE_SCORE, 0,
    /* 007B */ AI_IF_LOADED_EQUAL_TO, 0, 0, // -> 007E

    // 007E
    /* 007E */ AI_LOAD_BATTLER_ABILITY, AI_BATTLER_TARGET,
    /* 0080 */ AI_IF_LOADED_NOT_EQUAL_TO, ABILITY_SOUNDPROOF, 38, // -> 00A9
    /* 0083 */ AI_LOAD_BATTLER_ABILITY, AI_BATTLER_ATTACKER,
    /* 0085 */ AI_IF_LOADED_EQUAL_TO, ABILITY_MOLD_BREAKER, 33, // -> 00A9
    /* 0088 */ AI_IF_MOVE_EQUAL_TO, MOVE_GROWL, 2383, // -> 09DA
    /* 008B */ AI_IF_MOVE_EQUAL_TO, MOVE_ROAR, 2380, // -> 09DA
    /* 008E */ AI_IF_MOVE_EQUAL_TO, MOVE_SING, 2377, // -> 09DA
    /* 0091 */ AI_IF_MOVE_EQUAL_TO, MOVE_SUPERSONIC, 2374, // -> 09DA
    /* 0094 */ AI_IF_MOVE_EQUAL_TO, MOVE_SCREECH, 2371, // -> 09DA
    /* 0097 */ AI_IF_MOVE_EQUAL_TO, MOVE_SNORE, 2368, // -> 09DA
    /* 009A */ AI_IF_MOVE_EQUAL_TO, MOVE_UPROAR, 2365, // -> 09DA
    /* 009D */ AI_IF_MOVE_EQUAL_TO, MOVE_METAL_SOUND, 2362, // -> 09DA
    /* 00A0 */ AI_IF_MOVE_EQUAL_TO, MOVE_GRASS_WHISTLE, 2359, // -> 09DA
    /* 00A3 */ AI_IF_MOVE_EQUAL_TO, MOVE_BUG_BUZZ, 2356, // -> 09DA
    /* 00A6 */ AI_IF_MOVE_EQUAL_TO, MOVE_CHATTER, 2353, // -> 09DA

    // 00A9
    /* 00A9 */ AI_IF_CURRENT_MOVE_EFFECT_EQUAL_TO, MOVE_EFFECT_STATUS_SLEEP, 454, // -> 0272
    /* 00AC */ AI_IF_CURRENT_MOVE_EFFECT_EQUAL_TO, MOVE_EFFECT_HALVE_DEFENSE, 468, // -> 0283
    /* 00AF */ AI_IF_CURRENT_MOVE_EFFECT_EQUAL_TO, MOVE_EFFECT_RECOVER_DAMAGE_SLEEP, 505, // -> 02AB
    /* 00B2 */ AI_IF_CURRENT_MOVE_EFFECT_EQUAL_TO, MOVE_EFFECT_ATK_UP, 514, // -> 02B7
    /* 00B5 */ AI_IF_CURRENT_MOVE_EFFECT_EQUAL_TO, MOVE_EFFECT_DEF_UP, 528, // -> 02C8
    /* 00B8 */ AI_IF_CURRENT_MOVE_EFFECT_EQUAL_TO, MOVE_EFFECT_SPEED_UP, 542, // -> 02D9
    /* 00BB */ AI_IF_CURRENT_MOVE_EFFECT_EQUAL_TO, MOVE_EFFECT_SP_ATK_UP, 559, // -> 02ED
    /* 00BE */ AI_IF_CURRENT_MOVE_EFFECT_EQUAL_TO, MOVE_EFFECT_SP_DEF_UP, 573, // -> 02FE
    /* 00C1 */ AI_IF_CURRENT_MOVE_EFFECT_EQUAL_TO, MOVE_EFFECT_ACC_UP, 587, // -> 030F
    /* 00C4 */ AI_IF_CURRENT_MOVE_EFFECT_EQUAL_TO, MOVE_EFFECT_EVA_UP, 609, // -> 0328
    /* 00C7 */ AI_IF_CURRENT_MOVE_EFFECT_EQUAL_TO, MOVE_EFFECT_ATK_DOWN, 631, // -> 0341
    /* 00CA */ AI_IF_CURRENT_MOVE_EFFECT_EQUAL_TO, MOVE_EFFECT_DEF_DOWN, 640, // -> 034D
    /* 00CD */ AI_IF_CURRENT_MOVE_EFFECT_EQUAL_TO, MOVE_EFFECT_SPEED_DOWN, 644, // -> 0354
    /* 00D0 */ AI_IF_CURRENT_MOVE_EFFECT_EQUAL_TO, MOVE_EFFECT_SP_ATK_DOWN, 657, // -> 0364
    /* 00D3 */ AI_IF_CURRENT_MOVE_EFFECT_EQUAL_TO, MOVE_EFFECT_SP_DEF_DOWN, 661, // -> 036B
    /* 00D6 */ AI_IF_CURRENT_MOVE_EFFECT_EQUAL_TO, MOVE_EFFECT_ACC_DOWN, 665, // -> 0372
    /* 00D9 */ AI_IF_CURRENT_MOVE_EFFECT_EQUAL_TO, MOVE_EFFECT_EVA_DOWN, 682, // -> 0386
    /* 00DC */ AI_IF_CURRENT_MOVE_EFFECT_EQUAL_TO, MOVE_EFFECT_RESET_STAT_CHANGES, 703, // -> 039E
    /* 00DF */ AI_IF_CURRENT_MOVE_EFFECT_EQUAL_TO, MOVE_EFFECT_BIDE, 878, // -> 0450
    /* 00E2 */ AI_IF_CURRENT_MOVE_EFFECT_EQUAL_TO, MOVE_EFFECT_FORCE_SWITCH, 770, // -> 03E7
    /* 00E5 */ AI_IF_CURRENT_MOVE_EFFECT_EQUAL_TO, MOVE_EFFECT_RESTORE_HALF_HP, 783, // -> 03F7
    /* 00E8 */ AI_IF_CURRENT_MOVE_EFFECT_EQUAL_TO, MOVE_EFFECT_STATUS_BADLY_POISON, 787, // -> 03FE
    /* 00EB */ AI_IF_CURRENT_MOVE_EFFECT_EQUAL_TO, MOVE_EFFECT_SET_LIGHT_SCREEN, 836, // -> 0432
    /* 00EE */ AI_IF_CURRENT_MOVE_EFFECT_EQUAL_TO, MOVE_EFFECT_ONE_HIT_KO, 838, // -> 0437
    /* 00F1 */ AI_IF_CURRENT_MOVE_EFFECT_EQUAL_TO, MOVE_EFFECT_CHARGE_TURN_HIGH_CRIT, 860, // -> 0450
    /* 00F4 */ AI_IF_CURRENT_MOVE_EFFECT_EQUAL_TO, MOVE_EFFECT_HALVE_HP, 857, // -> 0450
    /* 00F7 */ AI_IF_CURRENT_MOVE_EFFECT_EQUAL_TO, MOVE_EFFECT_40_DAMAGE_FLAT, 854, // -> 0450
    /* 00FA */ AI_IF_CURRENT_MOVE_EFFECT_EQUAL_TO, MOVE_EFFECT_PREVENT_STAT_REDUCTION, 873, // -> 0466
    /* 00FD */ AI_IF_CURRENT_MOVE_EFFECT_EQUAL_TO, MOVE_EFFECT_CRIT_UP_2, 875, // -> 046B
    /* 0100 */ AI_IF_CURRENT_MOVE_EFFECT_EQUAL_TO, MOVE_EFFECT_STATUS_CONFUSE, 877, // -> 0470
    /* 0103 */ AI_IF_CURRENT_MOVE_EFFECT_EQUAL_TO, MOVE_EFFECT_ATK_UP_2, 433, // -> 02B7
    /* 0106 */ AI_IF_CURRENT_MOVE_EFFECT_EQUAL_TO, MOVE_EFFECT_DEF_UP_2, 447, // -> 02C8
    /* 0109 */ AI_IF_CURRENT_MOVE_EFFECT_EQUAL_TO, MOVE_EFFECT_SPEED_UP_2, 461, // -> 02D9
    /* 010C */ AI_IF_CURRENT_MOVE_EFFECT_EQUAL_TO, MOVE_EFFECT_SP_ATK_UP_2, 478, // -> 02ED
    /* 010F */ AI_IF_CURRENT_MOVE_EFFECT_EQUAL_TO, MOVE_EFFECT_SP_DEF_UP_2, 492, // -> 02FE
    /* 0112 */ AI_IF_CURRENT_MOVE_EFFECT_EQUAL_TO, MOVE_EFFECT_ACC_UP_2, 506, // -> 030F
    /* 0115 */ AI_IF_CURRENT_MOVE_EFFECT_EQUAL_TO, MOVE_EFFECT_EVA_UP_2, 528, // -> 0328
    /* 0118 */ AI_IF_CURRENT_MOVE_EFFECT_EQUAL_TO, MOVE_EFFECT_ATK_DOWN_2, 550, // -> 0341
    /* 011B */ AI_IF_CURRENT_MOVE_EFFECT_EQUAL_TO, MOVE_EFFECT_DEF_DOWN_2, 559, // -> 034D
    /* 011E */ AI_IF_CURRENT_MOVE_EFFECT_EQUAL_TO, MOVE_EFFECT_SPEED_DOWN_2, 563, // -> 0354
    /* 0121 */ AI_IF_CURRENT_MOVE_EFFECT_EQUAL_TO, MOVE_EFFECT_SP_ATK_DOWN_2, 576, // -> 0364
    /* 0124 */ AI_IF_CURRENT_MOVE_EFFECT_EQUAL_TO, MOVE_EFFECT_SP_DEF_DOWN_2, 580, // -> 036B
    /* 0127 */ AI_IF_CURRENT_MOVE_EFFECT_EQUAL_TO, MOVE_EFFECT_ACC_DOWN_2, 584, // -> 0372
    /* 012A */ AI_IF_CURRENT_MOVE_EFFECT_EQUAL_TO, MOVE_EFFECT_EVA_DOWN_2, 601, // -> 0386
    /* 012D */ AI_IF_CURRENT_MOVE_EFFECT_EQUAL_TO, MOVE_EFFECT_SET_REFLECT, 846, // -> 047E
    /* 0130 */ AI_IF_CURRENT_MOVE_EFFECT_EQUAL_TO, MOVE_EFFECT_STATUS_POISON, 715, // -> 03FE
    /* 0133 */ AI_IF_CURRENT_MOVE_EFFECT_EQUAL_TO, MOVE_EFFECT_STATUS_PARALYZE, 845, // -> 0483
    /* 0136 */ AI_IF_CURRENT_MOVE_EFFECT_EQUAL_TO, MOVE_EFFECT_SET_SUBSTITUTE, 880, // -> 04A9
    /* 0139 */ AI_IF_CURRENT_MOVE_EFFECT_EQUAL_TO, MOVE_EFFECT_RECHARGE_AFTER, 788, // -> 0450
    /* 013C */ AI_IF_CURRENT_MOVE_EFFECT_EQUAL_TO, MOVE_EFFECT_STATUS_LEECH_SEED, 883, // -> 04B2
    /* 013F */ AI_IF_CURRENT_MOVE_EFFECT_EQUAL_TO, MOVE_EFFECT_DISABLE, 900, // -> 04C6
    /* 0142 */ AI_IF_CURRENT_MOVE_EFFECT_EQUAL_TO, MOVE_EFFECT_LEVEL_DAMAGE_FLAT, 779, // -> 0450
    /* 0145 */ AI_IF_CURRENT_MOVE_EFFECT_EQUAL_TO, MOVE_EFFECT_RANDOM_DAMAGE_1_TO_150_LEVEL, 776, // -> 0450
    /* 0148 */ AI_IF_CURRENT_MOVE_EFFECT_EQUAL_TO, MOVE_EFFECT_COUNTER, 773, // -> 0450
    /* 014B */ AI_IF_CURRENT_MOVE_EFFECT_EQUAL_TO, MOVE_EFFECT_ENCORE, 893, // -> 04CB
    /* 014E */ AI_IF_CURRENT_MOVE_EFFECT_EQUAL_TO, MOVE_EFFECT_DAMAGE_WHILE_ASLEEP, 895, // -> 04D0
    /* 0151 */ AI_IF_CURRENT_MOVE_EFFECT_EQUAL_TO, MOVE_EFFECT_NEXT_ATTACK_ALWAYS_HITS, 897, // -> 04D5
    /* 0154 */ AI_IF_CURRENT_MOVE_EFFECT_EQUAL_TO, MOVE_EFFECT_USE_RANDOM_LEARNED_MOVE_SLEEP, 889, // -> 04D0
    /* 0157 */ AI_IF_CURRENT_MOVE_EFFECT_EQUAL_TO, MOVE_EFFECT_INCREASE_POWER_WITH_LESS_HP, 758, // -> 0450
    /* 015A */ AI_IF_CURRENT_MOVE_EFFECT_EQUAL_TO, MOVE_EFFECT_PREVENT_ESCAPE, 903, // -> 04E4
    /* 015D */ AI_IF_CURRENT_MOVE_EFFECT_EQUAL_TO, MOVE_EFFECT_STATUS_NIGHTMARE, 317, // -> 029D
    /* 0160 */ AI_IF_CURRENT_MOVE_EFFECT_EQUAL_TO, MOVE_EFFECT_EVA_UP_2_MINIMIZE, 453, // -> 0328
    /* 0163 */ AI_IF_CURRENT_MOVE_EFFECT_EQUAL_TO, MOVE_EFFECT_CURSE, 899, // -> 04E9
    /* 0166 */ AI_IF_CURRENT_MOVE_EFFECT_EQUAL_TO, MOVE_EFFECT_SET_SPIKES, 943, // -> 0518
    /* 0169 */ AI_IF_CURRENT_MOVE_EFFECT_EQUAL_TO, MOVE_EFFECT_IGNORE_EVASION_REMOVE_GHOST_IMMUNE, 952, // -> 0524
    /* 016C */ AI_IF_CURRENT_MOVE_EFFECT_EQUAL_TO, MOVE_EFFECT_ALL_FAINT_3_TURNS, 954, // -> 0529
    /* 016F */ AI_IF_CURRENT_MOVE_EFFECT_EQUAL_TO, MOVE_EFFECT_WEATHER_SANDSTORM, 956, // -> 052E
    /* 0172 */ AI_IF_CURRENT_MOVE_EFFECT_EQUAL_TO, MOVE_EFFECT_ATK_UP_2_STATUS_CONFUSION, 763, // -> 0470
    /* 0175 */ AI_IF_CURRENT_MOVE_EFFECT_EQUAL_TO, MOVE_EFFECT_INFATUATE, 955, // -> 0533
    /* 0178 */ AI_IF_CURRENT_MOVE_EFFECT_EQUAL_TO, MOVE_EFFECT_POWER_BASED_ON_FRIENDSHIP, 725, // -> 0450
    /* 017B */ AI_IF_CURRENT_MOVE_EFFECT_EQUAL_TO, MOVE_EFFECT_RANDOM_POWER_MAYBE_HEAL, 722, // -> 0450
    /* 017E */ AI_IF_CURRENT_MOVE_EFFECT_EQUAL_TO, MOVE_EFFECT_POWER_BASED_ON_LOW_FRIENDSHIP, 719, // -> 0450
    /* 0181 */ AI_IF_CURRENT_MOVE_EFFECT_EQUAL_TO, MOVE_EFFECT_PREVENT_STATUS, 977, // -> 0555
    /* 0184 */ AI_IF_CURRENT_MOVE_EFFECT_EQUAL_TO, MOVE_EFFECT_RANDOM_POWER_10_CASES, 705, // -> 0448
    /* 0187 */ AI_IF_CURRENT_MOVE_EFFECT_EQUAL_TO, MOVE_EFFECT_PASS_STATS_AND_STATUS, 1005, // -> 0577
    /* 018A */ AI_IF_CURRENT_MOVE_EFFECT_EQUAL_TO, MOVE_EFFECT_10_DAMAGE_FLAT, 707, // -> 0450
    /* 018D */ AI_IF_CURRENT_MOVE_EFFECT_EQUAL_TO, MOVE_EFFECT_HEAL_HALF_MORE_IN_SUN, 615, // -> 03F7
    /* 0190 */ AI_IF_CURRENT_MOVE_EFFECT_EQUAL_TO, MOVE_EFFECT_UNUSED_133, 612, // -> 03F7
    /* 0193 */ AI_IF_CURRENT_MOVE_EFFECT_EQUAL_TO, MOVE_EFFECT_UNUSED_134, 609, // -> 03F7
    /* 0196 */ AI_IF_CURRENT_MOVE_EFFECT_EQUAL_TO, MOVE_EFFECT_RANDOM_POWER_BASED_ON_IVS, 695, // -> 0450
    /* 0199 */ AI_IF_CURRENT_MOVE_EFFECT_EQUAL_TO, MOVE_EFFECT_WEATHER_RAIN, 993, // -> 057D
    /* 019C */ AI_IF_CURRENT_MOVE_EFFECT_EQUAL_TO, MOVE_EFFECT_WEATHER_SUN, 1012, // -> 0593
    /* 019F */ AI_IF_CURRENT_MOVE_EFFECT_EQUAL_TO, MOVE_EFFECT_MAX_ATK_LOSE_HALF_MAX_HP, 273, // -> 02B3
    /* 01A2 */ AI_IF_CURRENT_MOVE_EFFECT_EQUAL_TO, MOVE_EFFECT_COPY_STAT_CHANGES, 505, // -> 039E
    /* 01A5 */ AI_IF_CURRENT_MOVE_EFFECT_EQUAL_TO, MOVE_EFFECT_MIRROR_COAT, 680, // -> 0450
    /* 01A8 */ AI_IF_CURRENT_MOVE_EFFECT_EQUAL_TO, MOVE_EFFECT_CHARGE_TURN_DEF_UP, 677, // -> 0450
    /* 01AB */ AI_IF_CURRENT_MOVE_EFFECT_EQUAL_TO, MOVE_EFFECT_HIT_IN_3_TURNS, 1022, // -> 05AC
    /* 01AE */ AI_IF_CURRENT_MOVE_EFFECT_EQUAL_TO, MOVE_EFFECT_FLEE_FROM_WILD_BATTLE, 2089, // -> 09DA
    /* 01B1 */ AI_IF_CURRENT_MOVE_EFFECT_EQUAL_TO, MOVE_EFFECT_DEF_UP_DOUBLE_ROLLOUT_POWER, 276, // -> 02C8
    /* 01B4 */ AI_IF_CURRENT_MOVE_EFFECT_EQUAL_TO, MOVE_EFFECT_UNUSED_157, 576, // -> 03F7
    /* 01B7 */ AI_IF_CURRENT_MOVE_EFFECT_EQUAL_TO, MOVE_EFFECT_ALWAYS_FLINCH_FIRST_TURN_ONLY, 1019, // -> 05B5
    /* 01BA */ AI_IF_CURRENT_MOVE_EFFECT_EQUAL_TO, MOVE_EFFECT_STOCKPILE, 1022, // -> 05BB
    /* 01BD */ AI_IF_CURRENT_MOVE_EFFECT_EQUAL_TO, MOVE_EFFECT_SPIT_UP, 1025, // -> 05C1
    /* 01C0 */ AI_IF_CURRENT_MOVE_EFFECT_EQUAL_TO, MOVE_EFFECT_SWALLOW, 1022, // -> 05C1
    /* 01C3 */ AI_IF_CURRENT_MOVE_EFFECT_EQUAL_TO, MOVE_EFFECT_WEATHER_HAIL, 1031, // -> 05CD
    /* 01C6 */ AI_IF_CURRENT_MOVE_EFFECT_EQUAL_TO, MOVE_EFFECT_TORMENT, 1047, // -> 05E0
    /* 01C9 */ AI_IF_CURRENT_MOVE_EFFECT_EQUAL_TO, MOVE_EFFECT_SP_ATK_UP_CAUSE_CONFUSION, 676, // -> 0470
    /* 01CC */ AI_IF_CURRENT_MOVE_EFFECT_EQUAL_TO, MOVE_EFFECT_STATUS_BURN, 1046, // -> 05E5
    /* 01CF */ AI_IF_CURRENT_MOVE_EFFECT_EQUAL_TO, MOVE_EFFECT_FAINT_AND_ATK_SP_ATK_DOWN_2, 904, // -> 055A
    /* 01D2 */ AI_IF_CURRENT_MOVE_EFFECT_EQUAL_TO, MOVE_EFFECT_HIT_LAST_WHIFF_IF_HIT, 635, // -> 0450
    /* 01D5 */ AI_IF_CURRENT_MOVE_EFFECT_EQUAL_TO, MOVE_EFFECT_BOOST_ALLY_POWER_BY_50_PERCENT, 1064, // -> 0600
    /* 01D8 */ AI_IF_CURRENT_MOVE_EFFECT_EQUAL_TO, MOVE_EFFECT_SWITCH_HELD_ITEMS, 1066, // -> 0605
    /* 01DB */ AI_IF_CURRENT_MOVE_EFFECT_EQUAL_TO, MOVE_EFFECT_GROUND_TRAP_USER_CONTINUOUS_HEAL, 1074, // -> 0610
    /* 01DE */ AI_IF_CURRENT_MOVE_EFFECT_EQUAL_TO, 182, 623, // -> 0450
    /* 01E1 */ AI_IF_CURRENT_MOVE_EFFECT_EQUAL_TO, 184, 1073, // -> 0615
    /* 01E4 */ AI_IF_CURRENT_MOVE_EFFECT_EQUAL_TO, MOVE_EFFECT_STATUS_SLEEP_NEXT_TURN, 139, // -> 0272
    /* 01E7 */ AI_IF_CURRENT_MOVE_EFFECT_EQUAL_TO, MOVE_EFFECT_REMOVE_HELD_ITEM, 1051, // -> 0605
    /* 01EA */ AI_IF_CURRENT_MOVE_EFFECT_EQUAL_TO, MOVE_EFFECT_SET_HP_EQUAL_TO_USER, 611, // -> 0450
    /* 01ED */ AI_IF_CURRENT_MOVE_EFFECT_EQUAL_TO, MOVE_EFFECT_MAKE_SHARED_MOVES_UNUSEABL, 1067, // -> 061B
    /* 01F0 */ AI_IF_CURRENT_MOVE_EFFECT_EQUAL_TO, MOVE_EFFECT_HEAL_STATUS, 1073, // -> 0624
    /* 01F3 */ AI_IF_CURRENT_MOVE_EFFECT_EQUAL_TO, MOVE_EFFECT_INCREASE_POWER_WITH_WEIGHT, 602, // -> 0450
    /* 01F6 */ AI_IF_CURRENT_MOVE_EFFECT_EQUAL_TO, MOVE_EFFECT_HALVE_ELECTRIC_DAMAGE, 1072, // -> 0629
    /* 01F9 */ AI_IF_CURRENT_MOVE_EFFECT_EQUAL_TO, MOVE_EFFECT_ATK_DEF_DOWN, 1074, // -> 062E
    /* 01FC */ AI_IF_CURRENT_MOVE_EFFECT_EQUAL_TO, MOVE_EFFECT_DEF_SPD_UP, 1095, // -> 0646
    /* 01FF */ AI_IF_CURRENT_MOVE_EFFECT_EQUAL_TO, MOVE_EFFECT_ATK_DEF_UP, 1119, // -> 0661
    /* 0202 */ AI_IF_CURRENT_MOVE_EFFECT_EQUAL_TO, MOVE_EFFECT_HALVE_FIRE_DAMAGE, 1143, // -> 067C
    /* 0205 */ AI_IF_CURRENT_MOVE_EFFECT_EQUAL_TO, MOVE_EFFECT_SP_ATK_SP_DEF_UP, 1145, // -> 0681
    /* 0208 */ AI_IF_CURRENT_MOVE_EFFECT_EQUAL_TO, MOVE_EFFECT_ATK_SPD_UP, 1169, // -> 069C
    /* 020B */ AI_IF_CURRENT_MOVE_EFFECT_EQUAL_TO, MOVE_EFFECT_CAMOUFLAGE, 1196, // -> 06BA
    /* 020E */ AI_IF_CURRENT_MOVE_EFFECT_EQUAL_TO, MOVE_EFFECT_HEAL_HALF_REMOVE_FLYING_TYPE, 486, // -> 03F7
    /* 0211 */ AI_IF_CURRENT_MOVE_EFFECT_EQUAL_TO, MOVE_EFFECT_GRAVITY, 1195, // -> 06BF
    /* 0214 */ AI_IF_CURRENT_MOVE_EFFECT_EQUAL_TO, MOVE_EFFECT_IGNORE_EVATION_REMOVE_DARK_IMMUNE, 1196, // -> 06C3
    /* 0217 */ AI_IF_CURRENT_MOVE_EFFECT_EQUAL_TO, MOVE_EFFECT_POWER_BASED_ON_LOW_SPEED, 566, // -> 0450
    /* 021A */ AI_IF_CURRENT_MOVE_EFFECT_EQUAL_TO, MOVE_EFFECT_FAINT_AND_FULL_HEAL_NEXT_MON, 1195, // -> 06C8
    /* 021D */ AI_IF_CURRENT_MOVE_EFFECT_EQUAL_TO, MOVE_EFFECT_NATURAL_GIFT, 1209, // -> 06D9
    /* 0220 */ AI_IF_CURRENT_MOVE_EFFECT_EQUAL_TO, MOVE_EFFECT_DOUBLE_SPEED_3_TURNS, 1280, // -> 0723
    /* 0223 */ AI_IF_CURRENT_MOVE_EFFECT_EQUAL_TO, MOVE_EFFECT_RANDOM_STAT_UP_2, 1285, // -> 072B
    /* 0226 */ AI_IF_CURRENT_MOVE_EFFECT_EQUAL_TO, MOVE_EFFECT_METAL_BURST, 1359, // -> 0778
    /* 0229 */ AI_IF_CURRENT_MOVE_EFFECT_EQUAL_TO, MOVE_EFFECT_PREVENT_ITEM_USE, 1381, // -> 0791
    /* 022C */ AI_IF_CURRENT_MOVE_EFFECT_EQUAL_TO, MOVE_EFFECT_FLING, 1392, // -> 079F
    /* 022F */ AI_IF_CURRENT_MOVE_EFFECT_EQUAL_TO, MOVE_EFFECT_TRANSFER_STATUS, 1582, // -> 0860
    /* 0232 */ AI_IF_CURRENT_MOVE_EFFECT_EQUAL_TO, MOVE_EFFECT_HIGHER_POWER_WHEN_LOW_PP, 539, // -> 0450
    /* 0235 */ AI_IF_CURRENT_MOVE_EFFECT_EQUAL_TO, MOVE_EFFECT_PREVENT_HEALING, 1662, // -> 08B6
    /* 0238 */ AI_IF_CURRENT_MOVE_EFFECT_EQUAL_TO, MOVE_EFFECT_INCREASE_POWER_WITH_MORE_HP, 533, // -> 0450
    /* 023B */ AI_IF_CURRENT_MOVE_EFFECT_EQUAL_TO, MOVE_EFFECT_SWAP_ATK_DEF, 1661, // -> 08BB
    /* 023E */ AI_IF_CURRENT_MOVE_EFFECT_EQUAL_TO, MOVE_EFFECT_SUPRESS_ABILITY, 1663, // -> 08C0
    /* 0241 */ AI_IF_CURRENT_MOVE_EFFECT_EQUAL_TO, MOVE_EFFECT_PREVENT_CRITS, 1688, // -> 08DC
    /* 0244 */ AI_IF_CURRENT_MOVE_EFFECT_EQUAL_TO, MOVE_EFFECT_USE_LAST_USED_MOVE, 1690, // -> 08E1
    /* 0247 */ AI_IF_CURRENT_MOVE_EFFECT_EQUAL_TO, MOVE_EFFECT_SWAP_ATK_SP_ATK_STAT_CHANGES, 1695, // -> 08E9
    /* 024A */ AI_IF_CURRENT_MOVE_EFFECT_EQUAL_TO, MOVE_EFFECT_SWAP_DEF_SP_DEF_STAT_CHANGES, 1707, // -> 08F8
    /* 024D */ AI_IF_CURRENT_MOVE_EFFECT_EQUAL_TO, MOVE_EFFECT_INCREASE_POWER_WITH_MORE_STAT_UP, 512, // -> 0450
    /* 0250 */ AI_IF_CURRENT_MOVE_EFFECT_EQUAL_TO, MOVE_EFFECT_FAIL_IF_NOT_USED_ALL_OTHER_MOVES, 1716, // -> 0907
    /* 0253 */ AI_IF_CURRENT_MOVE_EFFECT_EQUAL_TO, MOVE_EFFECT_SET_ABILITY_TO_INSOMNIA, 1719, // -> 090D
    /* 0256 */ AI_IF_CURRENT_MOVE_EFFECT_EQUAL_TO, MOVE_EFFECT_TOXIC_SPIKES, 1745, // -> 092A
    /* 0259 */ AI_IF_CURRENT_MOVE_EFFECT_EQUAL_TO, MOVE_EFFECT_SWAP_STAT_CHANGES, 322, // -> 039E
    /* 025C */ AI_IF_CURRENT_MOVE_EFFECT_EQUAL_TO, MOVE_EFFECT_RESTORE_HP_EVERY_TURN, 1752, // -> 0937
    /* 025F */ AI_IF_CURRENT_MOVE_EFFECT_EQUAL_TO, MOVE_EFFECT_GIVE_GROUND_IMMUNITY, 1754, // -> 093C
    /* 0262 */ AI_IF_CURRENT_MOVE_EFFECT_EQUAL_TO, MOVE_EFFECT_REMOVE_HAZARDS_SCREENS_EVA_DOWN, 1771, // -> 0950
    /* 0265 */ AI_IF_CURRENT_MOVE_EFFECT_EQUAL_TO, MOVE_EFFECT_TRICK_ROOM, 1805, // -> 0975
    /* 0268 */ AI_IF_CURRENT_MOVE_EFFECT_EQUAL_TO, MOVE_EFFECT_SP_ATK_DOWN_2_OPPOSITE_GENDER, 1809, // -> 097C
    /* 026B */ AI_IF_CURRENT_MOVE_EFFECT_EQUAL_TO, MOVE_EFFECT_STEALTH_ROCK, 1852, // -> 09AA
    /* 026E */ AI_IF_CURRENT_MOVE_EFFECT_EQUAL_TO, MOVE_EFFECT_FAINT_FULL_RESTORE_NEXT_MON, 1859, // -> 09B4
    /* 0271 */ AI_POP_OR_END,

    // 0272
    /* 0272 */ AI_IF_STATUS, AI_BATTLER_TARGET, 0xFF, 1892, // -> 09DA
    /* 0276 */ AI_IF_SIDE_CONDITION, AI_BATTLER_TARGET, 0x8, 1888, // -> 09DA
    /* 027A */ AI_LOAD_BATTLER_ABILITY, AI_BATTLER_TARGET,
    /* 027C */ AI_IF_LOADED_EQUAL_TO, ABILITY_INSOMNIA, 1883, // -> 09DA
    /* 027F */ AI_IF_LOADED_EQUAL_TO, ABILITY_VITAL_SPIRIT, 1880, // -> 09DA
    /* 0282 */ AI_POP_OR_END,

    // 0283
    /* 0283 */ AI_IF_MOVE_EFFECTIVENESS_EQUALS, 0, 1876, // -> 09DA
    /* 0286 */ AI_LOAD_BATTLER_ABILITY, AI_BATTLER_ATTACKER,
    /* 0288 */ AI_IF_LOADED_EQUAL_TO, ABILITY_MOLD_BREAKER, 5, // -> 0290
    /* 028B */ AI_LOAD_BATTLER_ABILITY, AI_BATTLER_TARGET,
    /* 028D */ AI_IF_LOADED_EQUAL_TO, ABILITY_DAMP, 1866, // -> 09DA

    // 0290
    /* 0290 */ AI_COUNT_ALIVE_PARTY_BATTLERS, AI_BATTLER_ATTACKER,
    /* 0292 */ AI_IF_LOADED_NOT_EQUAL_TO, 0, 7, // -> 029C
    /* 0295 */ AI_COUNT_ALIVE_PARTY_BATTLERS, AI_BATTLER_TARGET,
    /* 0297 */ AI_IF_LOADED_NOT_EQUAL_TO, 0, 1856, // -> 09DA
    /* 029A */ AI_GOTO, 1836, // -> 09C8

    // 029C
    /* 029C */ AI_POP_OR_END,

    // 029D
    /* 029D */ AI_IF_VOLATILE_STATUS, AI_BATTLER_TARGET, 0x8000000, 1849, // -> 09DA
    /* 02A1 */ AI_IF_NOT_STATUS, AI_BATTLER_TARGET, 0x7, 1842, // -> 09D7
    /* 02A5 */ AI_LOAD_BATTLER_ABILITY, AI_BATTLER_TARGET,
    /* 02A7 */ AI_IF_LOADED_EQUAL_TO, ABILITY_MAGIC_GUARD, 1840, // -> 09DA
    /* 02AA */ AI_POP_OR_END,

    // 02AB
    /* 02AB */ AI_IF_NOT_STATUS, AI_BATTLER_TARGET, 0x7, 1832, // -> 09D7
    /* 02AF */ AI_IF_MOVE_EFFECTIVENESS_EQUALS, 0, 1832, // -> 09DA
    /* 02B2 */ AI_POP_OR_END,

    // 02B3
    /* 02B3 */ AI_IF_HP_PERCENT_LESS_THAN, AI_BATTLER_ATTACKER, 51, 1827, // -> 09DA

    // 02B7
    /* 02B7 */ AI_LOAD_BATTLER_ABILITY, AI_BATTLER_ATTACKER,
    /* 02B9 */ AI_IF_LOADED_NOT_EQUAL_TO, ABILITY_SIMPLE, 6, // -> 02C2
    /* 02BC */ AI_IF_STAT_STAGE_GREATER_THAN, AI_BATTLER_ATTACKER, 1, 8, 1817, // -> 09DA
    /* 02C1 */ AI_POP_OR_END,

    // 02C2
    /* 02C2 */ AI_IF_STAT_STAGE_EQUAL_TO, AI_BATTLER_ATTACKER, 1, 12, 1811, // -> 09DA
    /* 02C7 */ AI_POP_OR_END,

    // 02C8
    /* 02C8 */ AI_LOAD_BATTLER_ABILITY, AI_BATTLER_ATTACKER,
    /* 02CA */ AI_IF_LOADED_NOT_EQUAL_TO, ABILITY_SIMPLE, 6, // -> 02D3
    /* 02CD */ AI_IF_STAT_STAGE_GREATER_THAN, AI_BATTLER_ATTACKER, 2, 8, 1800, // -> 09DA
    /* 02D2 */ AI_POP_OR_END,

    // 02D3
    /* 02D3 */ AI_IF_STAT_STAGE_EQUAL_TO, AI_BATTLER_ATTACKER, 2, 12, 1794, // -> 09DA
    /* 02D8 */ AI_POP_OR_END,

    // 02D9
    /* 02D9 */ AI_IF_FIELD_CONDITIONS_MASK, 0x70000, 1790, // -> 09DA
    /* 02DC */ AI_LOAD_BATTLER_ABILITY, AI_BATTLER_ATTACKER,
    /* 02DE */ AI_IF_LOADED_NOT_EQUAL_TO, ABILITY_SIMPLE, 6, // -> 02E7
    /* 02E1 */ AI_IF_STAT_STAGE_GREATER_THAN, AI_BATTLER_ATTACKER, 3, 8, 1780, // -> 09DA
    /* 02E6 */ AI_POP_OR_END,

    // 02E7
    /* 02E7 */ AI_IF_STAT_STAGE_EQUAL_TO, AI_BATTLER_ATTACKER, 3, 12, 1774, // -> 09DA
    /* 02EC */ AI_POP_OR_END,

    // 02ED
    /* 02ED */ AI_LOAD_BATTLER_ABILITY, AI_BATTLER_ATTACKER,
    /* 02EF */ AI_IF_LOADED_NOT_EQUAL_TO, ABILITY_SIMPLE, 6, // -> 02F8
    /* 02F2 */ AI_IF_STAT_STAGE_GREATER_THAN, AI_BATTLER_ATTACKER, 4, 8, 1763, // -> 09DA
    /* 02F7 */ AI_POP_OR_END,

    // 02F8
    /* 02F8 */ AI_IF_STAT_STAGE_EQUAL_TO, AI_BATTLER_ATTACKER, 4, 12, 1757, // -> 09DA
    /* 02FD */ AI_POP_OR_END,

    // 02FE
    /* 02FE */ AI_LOAD_BATTLER_ABILITY, AI_BATTLER_ATTACKER,
    /* 0300 */ AI_IF_LOADED_NOT_EQUAL_TO, ABILITY_SIMPLE, 6, // -> 0309
    /* 0303 */ AI_IF_STAT_STAGE_GREATER_THAN, AI_BATTLER_ATTACKER, 5, 8, 1746, // -> 09DA
    /* 0308 */ AI_POP_OR_END,

    // 0309
    /* 0309 */ AI_IF_STAT_STAGE_EQUAL_TO, AI_BATTLER_ATTACKER, 5, 12, 1740, // -> 09DA
    /* 030E */ AI_POP_OR_END,

    // 030F
    /* 030F */ AI_LOAD_BATTLER_ABILITY, AI_BATTLER_TARGET,
    /* 0311 */ AI_IF_LOADED_EQUAL_TO, ABILITY_NO_GUARD, 1734, // -> 09DA
    /* 0314 */ AI_LOAD_BATTLER_ABILITY, AI_BATTLER_ATTACKER,
    /* 0316 */ AI_IF_LOADED_EQUAL_TO, ABILITY_NO_GUARD, 1729, // -> 09DA
    /* 0319 */ AI_IF_LOADED_NOT_EQUAL_TO, ABILITY_SIMPLE, 6, // -> 0322
    /* 031C */ AI_IF_STAT_STAGE_GREATER_THAN, AI_BATTLER_ATTACKER, 6, 8, 1721, // -> 09DA
    /* 0321 */ AI_POP_OR_END,

    // 0322
    /* 0322 */ AI_IF_STAT_STAGE_EQUAL_TO, AI_BATTLER_ATTACKER, 6, 12, 1715, // -> 09DA
    /* 0327 */ AI_POP_OR_END,

    // 0328
    /* 0328 */ AI_LOAD_BATTLER_ABILITY, AI_BATTLER_TARGET,
    /* 032A */ AI_IF_LOADED_EQUAL_TO, ABILITY_NO_GUARD, 1709, // -> 09DA
    /* 032D */ AI_LOAD_BATTLER_ABILITY, AI_BATTLER_ATTACKER,
    /* 032F */ AI_IF_LOADED_EQUAL_TO, ABILITY_NO_GUARD, 1704, // -> 09DA
    /* 0332 */ AI_IF_LOADED_NOT_EQUAL_TO, ABILITY_SIMPLE, 6, // -> 033B
    /* 0335 */ AI_IF_STAT_STAGE_GREATER_THAN, AI_BATTLER_ATTACKER, 7, 8, 1696, // -> 09DA
    /* 033A */ AI_POP_OR_END,

    // 033B
    /* 033B */ AI_IF_STAT_STAGE_EQUAL_TO, AI_BATTLER_ATTACKER, 7, 12, 1690, // -> 09DA
    /* 0340 */ AI_POP_OR_END,

    // 0341
    /* 0341 */ AI_IF_STAT_STAGE_EQUAL_TO, AI_BATTLER_TARGET, 1, 0, 1684, // -> 09DA
    /* 0346 */ AI_LOAD_BATTLER_ABILITY, AI_BATTLER_TARGET,
    /* 0348 */ AI_IF_LOADED_EQUAL_TO, ABILITY_HYPER_CUTTER, 1679, // -> 09DA
    /* 034B */ AI_GOTO, 72, // -> 0395

    // 034D
    /* 034D */ AI_IF_STAT_STAGE_EQUAL_TO, AI_BATTLER_TARGET, 2, 0, 1672, // -> 09DA
    /* 0352 */ AI_GOTO, 65, // -> 0395

    // 0354
    /* 0354 */ AI_IF_FIELD_CONDITIONS_MASK, 0x70000, 1667, // -> 09DA
    /* 0357 */ AI_IF_STAT_STAGE_EQUAL_TO, AI_BATTLER_TARGET, 3, 0, 1662, // -> 09DA
    /* 035C */ AI_CHECK_BATTLER_ABILITY, AI_BATTLER_TARGET, ABILITY_SPEED_BOOST,
    /* 035F */ AI_IF_LOADED_EQUAL_TO, 1, 1656, // -> 09DA
    /* 0362 */ AI_GOTO, 49, // -> 0395

    // 0364
    /* 0364 */ AI_IF_STAT_STAGE_EQUAL_TO, AI_BATTLER_TARGET, 4, 0, 1649, // -> 09DA
    /* 0369 */ AI_GOTO, 42, // -> 0395

    // 036B
    /* 036B */ AI_IF_STAT_STAGE_EQUAL_TO, AI_BATTLER_TARGET, 5, 0, 1642, // -> 09DA
    /* 0370 */ AI_GOTO, 35, // -> 0395

    // 0372
    /* 0372 */ AI_IF_STAT_STAGE_EQUAL_TO, AI_BATTLER_TARGET, 6, 0, 1635, // -> 09DA
    /* 0377 */ AI_LOAD_BATTLER_ABILITY, AI_BATTLER_ATTACKER,
    /* 0379 */ AI_IF_LOADED_EQUAL_TO, ABILITY_NO_GUARD, 1630, // -> 09DA
    /* 037C */ AI_LOAD_BATTLER_ABILITY, AI_BATTLER_TARGET,
    /* 037E */ AI_IF_LOADED_EQUAL_TO, ABILITY_KEEN_EYE, 1625, // -> 09DA
    /* 0381 */ AI_IF_LOADED_EQUAL_TO, ABILITY_NO_GUARD, 1622, // -> 09DA
    /* 0384 */ AI_GOTO, 15, // -> 0395

    // 0386
    /* 0386 */ AI_IF_STAT_STAGE_EQUAL_TO, AI_BATTLER_TARGET, 7, 0, 1615, // -> 09DA
    /* 038B */ AI_LOAD_BATTLER_ABILITY, AI_BATTLER_ATTACKER,
    /* 038D */ AI_IF_LOADED_EQUAL_TO, ABILITY_NO_GUARD, 1610, // -> 09DA
    /* 0390 */ AI_LOAD_BATTLER_ABILITY, AI_BATTLER_TARGET,
    /* 0392 */ AI_IF_LOADED_EQUAL_TO, ABILITY_NO_GUARD, 1605, // -> 09DA

    // 0395
    /* 0395 */ AI_LOAD_BATTLER_ABILITY, AI_BATTLER_TARGET,
    /* 0397 */ AI_IF_LOADED_EQUAL_TO, ABILITY_CLEAR_BODY, 1600, // -> 09DA
    /* 039A */ AI_IF_LOADED_EQUAL_TO, ABILITY_WHITE_SMOKE, 1597, // -> 09DA
    /* 039D */ AI_POP_OR_END,

    // 039E
    /* 039E */ AI_IF_STAT_STAGE_LESS_THAN, AI_BATTLER_ATTACKER, 1, 6, 67, // -> 03E6
    /* 03A3 */ AI_IF_STAT_STAGE_LESS_THAN, AI_BATTLER_ATTACKER, 2, 6, 62, // -> 03E6
    /* 03A8 */ AI_IF_STAT_STAGE_LESS_THAN, AI_BATTLER_ATTACKER, 3, 6, 57, // -> 03E6
    /* 03AD */ AI_IF_STAT_STAGE_LESS_THAN, AI_BATTLER_ATTACKER, 4, 6, 52, // -> 03E6
    /* 03B2 */ AI_IF_STAT_STAGE_LESS_THAN, AI_BATTLER_ATTACKER, 5, 6, 47, // -> 03E6
    /* 03B7 */ AI_IF_STAT_STAGE_LESS_THAN, AI_BATTLER_ATTACKER, 6, 6, 42, // -> 03E6
    /* 03BC */ AI_IF_STAT_STAGE_LESS_THAN, AI_BATTLER_ATTACKER, 7, 6, 37, // -> 03E6
    /* 03C1 */ AI_IF_STAT_STAGE_GREATER_THAN, AI_BATTLER_TARGET, 1, 6, 32, // -> 03E6
    /* 03C6 */ AI_IF_STAT_STAGE_GREATER_THAN, AI_BATTLER_TARGET, 2, 6, 27, // -> 03E6
    /* 03CB */ AI_IF_STAT_STAGE_GREATER_THAN, AI_BATTLER_TARGET, 3, 6, 22, // -> 03E6
    /* 03D0 */ AI_IF_STAT_STAGE_GREATER_THAN, AI_BATTLER_TARGET, 4, 6, 17, // -> 03E6
    /* 03D5 */ AI_IF_STAT_STAGE_GREATER_THAN, AI_BATTLER_TARGET, 5, 6, 12, // -> 03E6
    /* 03DA */ AI_IF_STAT_STAGE_GREATER_THAN, AI_BATTLER_TARGET, 6, 6, 7, // -> 03E6
    /* 03DF */ AI_IF_STAT_STAGE_GREATER_THAN, AI_BATTLER_TARGET, 7, 6, 2, // -> 03E6
    /* 03E4 */ AI_GOTO, 1524, // -> 09DA

    // 03E6
    /* 03E6 */ AI_POP_OR_END,

    // 03E7
    /* 03E7 */ AI_COUNT_ALIVE_PARTY_BATTLERS, AI_BATTLER_TARGET,
    /* 03E9 */ AI_IF_LOADED_EQUAL_TO, 0, 1518, // -> 09DA
    /* 03EC */ AI_LOAD_BATTLER_ABILITY, AI_BATTLER_ATTACKER,
    /* 03EE */ AI_IF_LOADED_EQUAL_TO, ABILITY_MOLD_BREAKER, 5, // -> 03F6
    /* 03F1 */ AI_LOAD_BATTLER_ABILITY, AI_BATTLER_TARGET,
    /* 03F3 */ AI_IF_LOADED_EQUAL_TO, ABILITY_SUCTION_CUPS, 1508, // -> 09DA

    // 03F6
    /* 03F6 */ AI_POP_OR_END,

    // 03F7
    /* 03F7 */ AI_IF_HP_PERCENT_NOT_EQUAL_TO, AI_BATTLER_ATTACKER, 100, 2, // -> 03FD
    /* 03FB */ AI_ADD_TO_MOVE_SCORE, -8,

    // 03FD
    /* 03FD */ AI_POP_OR_END,

    // 03FE
    /* 03FE */ AI_LOAD_TYPE_FROM, 0,
    /* 0400 */ AI_IF_LOADED_EQUAL_TO, TYPE_STEEL, 1495, // -> 09DA
    /* 0403 */ AI_IF_LOADED_EQUAL_TO, TYPE_POISON, 1492, // -> 09DA
    /* 0406 */ AI_LOAD_TYPE_FROM, 2,
    /* 0408 */ AI_IF_LOADED_EQUAL_TO, TYPE_STEEL, 1487, // -> 09DA
    /* 040B */ AI_IF_LOADED_EQUAL_TO, TYPE_POISON, 1484, // -> 09DA
    /* 040E */ AI_LOAD_BATTLER_ABILITY, AI_BATTLER_TARGET,
    /* 0410 */ AI_IF_LOADED_EQUAL_TO, ABILITY_IMMUNITY, 1479, // -> 09DA
    /* 0413 */ AI_IF_LOADED_EQUAL_TO, ABILITY_MAGIC_GUARD, 1476, // -> 09DA
    /* 0416 */ AI_IF_LOADED_EQUAL_TO, ABILITY_POISON_HEAL, 1473, // -> 09DA
    /* 0419 */ AI_IF_LOADED_NOT_EQUAL_TO, ABILITY_LEAF_GUARD, 4, // -> 0420
    /* 041C */ AI_LOAD_CURRENT_WEATHER,
    /* 041D */ AI_IF_LOADED_EQUAL_TO, 1, 1466, // -> 09DA

    // 0420
    /* 0420 */ AI_LOAD_BATTLER_ABILITY, AI_BATTLER_TARGET,
    /* 0422 */ AI_IF_LOADED_NOT_EQUAL_TO, ABILITY_HYDRATION, 4, // -> 0429
    /* 0425 */ AI_LOAD_CURRENT_WEATHER,
    /* 0426 */ AI_IF_LOADED_EQUAL_TO, 2, 1457, // -> 09DA

    // 0429
    /* 0429 */ AI_IF_STATUS, AI_BATTLER_TARGET, 0xFF, 1453, // -> 09DA
    /* 042D */ AI_IF_SIDE_CONDITION, AI_BATTLER_TARGET, 0x8, 1449, // -> 09DA
    /* 0431 */ AI_POP_OR_END,

    // 0432
    /* 0432 */ AI_IF_SIDE_CONDITION, AI_BATTLER_ATTACKER, 0x2, 1441, // -> 09D7
    /* 0436 */ AI_POP_OR_END,

    // 0437
    /* 0437 */ AI_IF_MOVE_EFFECTIVENESS_EQUALS, 0, 1440, // -> 09DA
    /* 043A */ AI_LOAD_BATTLER_ABILITY, AI_BATTLER_ATTACKER,
    /* 043C */ AI_IF_LOADED_EQUAL_TO, ABILITY_MOLD_BREAKER, 5, // -> 0444
    /* 043F */ AI_LOAD_BATTLER_ABILITY, AI_BATTLER_TARGET,
    /* 0441 */ AI_IF_LOADED_EQUAL_TO, ABILITY_STURDY, 1430, // -> 09DA

    // 0444
    /* 0444 */ AI_IF_LEVEL, 1, 1427, // -> 09DA
    /* 0447 */ AI_POP_OR_END,

    // 0448
    /* 0448 */ AI_IF_LOADED_EQUAL_TO, ABILITY_MOLD_BREAKER, 5, // -> 0450
    /* 044B */ AI_LOAD_BATTLER_ABILITY, AI_BATTLER_TARGET,
    /* 044D */ AI_IF_LOADED_EQUAL_TO, ABILITY_LEVITATE, 1418, // -> 09DA

    // 0450
    /* 0450 */ AI_IF_MOVE_EFFECTIVENESS_EQUALS, 0, 1415, // -> 09DA
    /* 0453 */ AI_LOAD_BATTLER_ABILITY, AI_BATTLER_TARGET,
    /* 0455 */ AI_IF_LOADED_NOT_EQUAL_TO, ABILITY_WONDER_GUARD, 13, // -> 0465
    /* 0458 */ AI_LOAD_BATTLER_ABILITY, AI_BATTLER_ATTACKER,
    /* 045A */ AI_IF_LOADED_EQUAL_TO, ABILITY_MOLD_BREAKER, 8, // -> 0465
    /* 045D */ AI_IF_MOVE_EFFECTIVENESS_EQUALS, 80, 5, // -> 0465
    /* 0460 */ AI_IF_MOVE_EFFECTIVENESS_EQUALS, 160, 2, // -> 0465
    /* 0463 */ AI_GOTO, 1397, // -> 09DA

    // 0465
    /* 0465 */ AI_POP_OR_END,

    // 0466
    /* 0466 */ AI_IF_SIDE_CONDITION, AI_BATTLER_ATTACKER, 0x40, 1389, // -> 09D7
    /* 046A */ AI_POP_OR_END,

    // 046B
    /* 046B */ AI_IF_VOLATILE_STATUS, AI_BATTLER_ATTACKER, 0x100000, 1387, // -> 09DA
    /* 046F */ AI_POP_OR_END,

    // 0470
    /* 0470 */ AI_IF_VOLATILE_STATUS, AI_BATTLER_TARGET, 0x7, 1373, // -> 09D1
    /* 0474 */ AI_LOAD_BATTLER_ABILITY, AI_BATTLER_TARGET,
    /* 0476 */ AI_IF_LOADED_EQUAL_TO, ABILITY_OWN_TEMPO, 1377, // -> 09DA
    /* 0479 */ AI_IF_SIDE_CONDITION, AI_BATTLER_TARGET, 0x8, 1373, // -> 09DA
    /* 047D */ AI_POP_OR_END,

    // 047E
    /* 047E */ AI_IF_SIDE_CONDITION, AI_BATTLER_ATTACKER, 0x1, 1365, // -> 09D7
    /* 0482 */ AI_POP_OR_END,

    // 0483
    /* 0483 */ AI_IF_MOVE_EFFECTIVENESS_EQUALS, 0, 1364, // -> 09DA
    /* 0486 */ AI_LOAD_BATTLER_ABILITY, AI_BATTLER_TARGET,
    /* 0488 */ AI_IF_LOADED_EQUAL_TO, ABILITY_LIMBER, 1359, // -> 09DA
    /* 048B */ AI_IF_LOADED_EQUAL_TO, ABILITY_MAGIC_GUARD, 1356, // -> 09DA
    /* 048E */ AI_LOAD_BATTLER_ABILITY, AI_BATTLER_ATTACKER,
    /* 0490 */ AI_IF_LOADED_EQUAL_TO, ABILITY_MOLD_BREAKER, 13, // -> 04A0
    /* 0493 */ AI_IF_MOVE_EQUAL_TO, MOVE_THUNDER_WAVE, 2, // -> 0498
    /* 0496 */ AI_GOTO, 8, // -> 04A0

    // 0498
    /* 0498 */ AI_LOAD_BATTLER_ABILITY, AI_BATTLER_TARGET,
    /* 049A */ AI_IF_LOADED_EQUAL_TO, ABILITY_MOTOR_DRIVE, 1341, // -> 09DA
    /* 049D */ AI_IF_LOADED_EQUAL_TO, ABILITY_VOLT_ABSORB, 1338, // -> 09DA

    // 04A0
    /* 04A0 */ AI_IF_STATUS, AI_BATTLER_TARGET, 0xFF, 1334, // -> 09DA
    /* 04A4 */ AI_IF_SIDE_CONDITION, AI_BATTLER_TARGET, 0x8, 1330, // -> 09DA
    /* 04A8 */ AI_POP_OR_END,

    // 04A9
    /* 04A9 */ AI_IF_VOLATILE_STATUS, AI_BATTLER_ATTACKER, 0x1000000, 1322, // -> 09D7
    /* 04AD */ AI_IF_HP_PERCENT_LESS_THAN, AI_BATTLER_ATTACKER, 26, 1321, // -> 09DA
    /* 04B1 */ AI_POP_OR_END,

    // 04B2
    /* 04B2 */ AI_IF_MOVE_EFFECT_FLAG, AI_BATTLER_TARGET, 0x4, 1316, // -> 09DA
    /* 04B6 */ AI_LOAD_TYPE_FROM, 0,
    /* 04B8 */ AI_IF_LOADED_EQUAL_TO, TYPE_GRASS, 1311, // -> 09DA
    /* 04BB */ AI_LOAD_TYPE_FROM, 2,
    /* 04BD */ AI_IF_LOADED_EQUAL_TO, TYPE_GRASS, 1306, // -> 09DA
    /* 04C0 */ AI_LOAD_BATTLER_ABILITY, AI_BATTLER_TARGET,
    /* 04C2 */ AI_IF_LOADED_EQUAL_TO, ABILITY_MAGIC_GUARD, 1301, // -> 09DA
    /* 04C5 */ AI_POP_OR_END,

    // 04C6
    /* 04C6 */ AI_IF_BATTLER_UNDER_EFFECT, AI_BATTLER_TARGET, 0, 1293, // -> 09D7
    /* 04CA */ AI_POP_OR_END,

    // 04CB
    /* 04CB */ AI_IF_BATTLER_UNDER_EFFECT, AI_BATTLER_TARGET, 1, 1288, // -> 09D7
    /* 04CF */ AI_POP_OR_END,

    // 04D0
    /* 04D0 */ AI_IF_NOT_STATUS, AI_BATTLER_ATTACKER, 0x7, 1283, // -> 09D7
    /* 04D4 */ AI_POP_OR_END,

    // 04D5
    /* 04D5 */ AI_IF_MOVE_EFFECT_FLAG, AI_BATTLER_TARGET, 0x18, 1281, // -> 09DA
    /* 04D9 */ AI_LOAD_BATTLER_ABILITY, AI_BATTLER_ATTACKER,
    /* 04DB */ AI_IF_LOADED_EQUAL_TO, ABILITY_NO_GUARD, 1276, // -> 09DA
    /* 04DE */ AI_LOAD_BATTLER_ABILITY, AI_BATTLER_TARGET,
    /* 04E0 */ AI_IF_LOADED_EQUAL_TO, ABILITY_NO_GUARD, 1271, // -> 09DA
    /* 04E3 */ AI_POP_OR_END,

    // 04E4
    /* 04E4 */ AI_IF_VOLATILE_STATUS, AI_BATTLER_TARGET, 0x4000000, 1266, // -> 09DA
    /* 04E8 */ AI_POP_OR_END,

    // 04E9
    /* 04E9 */ AI_LOAD_TYPE_FROM, 1,
    /* 04EB */ AI_IF_LOADED_EQUAL_TO, TYPE_GHOST, 32, // -> 050E
    /* 04EE */ AI_LOAD_TYPE_FROM, 3,
    /* 04F0 */ AI_IF_LOADED_EQUAL_TO, TYPE_GHOST, 27, // -> 050E
    /* 04F3 */ AI_LOAD_BATTLER_ABILITY, AI_BATTLER_ATTACKER,
    /* 04F5 */ AI_IF_LOADED_NOT_EQUAL_TO, ABILITY_SIMPLE, 11, // -> 0503
    /* 04F8 */ AI_IF_STAT_STAGE_GREATER_THAN, AI_BATTLER_ATTACKER, 1, 8, 1245, // -> 09DA
    /* 04FD */ AI_IF_STAT_STAGE_GREATER_THAN, AI_BATTLER_ATTACKER, 2, 8, 1240, // -> 09DA
    /* 0502 */ AI_POP_OR_END,

    // 0503
    /* 0503 */ AI_IF_STAT_STAGE_EQUAL_TO, AI_BATTLER_ATTACKER, 1, 12, 1234, // -> 09DA
    /* 0508 */ AI_IF_STAT_STAGE_EQUAL_TO, AI_BATTLER_ATTACKER, 2, 12, 1226, // -> 09D7
    /* 050D */ AI_POP_OR_END,

    // 050E
    /* 050E */ AI_IF_VOLATILE_STATUS, AI_BATTLER_TARGET, 0x10000000, 1224, // -> 09DA
    /* 0512 */ AI_LOAD_BATTLER_ABILITY, AI_BATTLER_TARGET,
    /* 0514 */ AI_IF_LOADED_EQUAL_TO, ABILITY_MAGIC_GUARD, 1219, // -> 09DA
    /* 0517 */ AI_POP_OR_END,

    // 0518
    /* 0518 */ AI_LOAD_SPIKES_LAYERS, AI_BATTLER_TARGET, 0x4,
    /* 051B */ AI_IF_LOADED_EQUAL_TO, 3, 1212, // -> 09DA
    /* 051E */ AI_COUNT_ALIVE_PARTY_BATTLERS, AI_BATTLER_TARGET,
    /* 0520 */ AI_IF_LOADED_EQUAL_TO, 0, 1207, // -> 09DA
    /* 0523 */ AI_POP_OR_END,

    // 0524
    /* 0524 */ AI_IF_VOLATILE_STATUS, AI_BATTLER_TARGET, 0x20000000, 1202, // -> 09DA
    /* 0528 */ AI_POP_OR_END,

    // 0529
    /* 0529 */ AI_IF_MOVE_EFFECT_FLAG, AI_BATTLER_TARGET, 0x20, 1197, // -> 09DA
    /* 052D */ AI_POP_OR_END,

    // 052E
    /* 052E */ AI_LOAD_CURRENT_WEATHER,
    /* 052F */ AI_IF_LOADED_EQUAL_TO, 3, 1189, // -> 09D7
    /* 0532 */ AI_POP_OR_END,

    // 0533
    /* 0533 */ AI_IF_VOLATILE_STATUS, AI_BATTLER_TARGET, 0xF0000, 1187, // -> 09DA
    /* 0537 */ AI_LOAD_BATTLER_ABILITY, AI_BATTLER_TARGET,
    /* 0539 */ AI_IF_LOADED_EQUAL_TO, ABILITY_OBLIVIOUS, 1182, // -> 09DA
    /* 053C */ AI_LOAD_GENDER, AI_BATTLER_ATTACKER,
    /* 053E */ AI_IF_LOADED_EQUAL_TO, 0, 5, // -> 0546
    /* 0541 */ AI_IF_LOADED_EQUAL_TO, 1, 9, // -> 054D
    /* 0544 */ AI_GOTO, 1172, // -> 09DA

    // 0546
    /* 0546 */ AI_LOAD_GENDER, AI_BATTLER_TARGET,
    /* 0548 */ AI_IF_LOADED_EQUAL_TO, 1, 9, // -> 0554
    /* 054B */ AI_GOTO, 1165, // -> 09DA

    // 054D
    /* 054D */ AI_LOAD_GENDER, AI_BATTLER_TARGET,
    /* 054F */ AI_IF_LOADED_EQUAL_TO, 0, 2, // -> 0554
    /* 0552 */ AI_GOTO, 1158, // -> 09DA

    // 0554
    /* 0554 */ AI_POP_OR_END,

    // 0555
    /* 0555 */ AI_IF_SIDE_CONDITION, AI_BATTLER_ATTACKER, 0x8, 1150, // -> 09D7
    /* 0559 */ AI_POP_OR_END,

    // 055A
    /* 055A */ AI_LOAD_BATTLER_ABILITY, AI_BATTLER_ATTACKER,
    /* 055C */ AI_IF_LOADED_EQUAL_TO, ABILITY_MOLD_BREAKER, 8, // -> 0567
    /* 055F */ AI_LOAD_BATTLER_ABILITY, AI_BATTLER_TARGET,
    /* 0561 */ AI_IF_LOADED_EQUAL_TO, ABILITY_CLEAR_BODY, 1142, // -> 09DA
    /* 0564 */ AI_IF_LOADED_EQUAL_TO, ABILITY_WHITE_SMOKE, 1139, // -> 09DA

    // 0567
    /* 0567 */ AI_IF_STAT_STAGE_EQUAL_TO, AI_BATTLER_TARGET, 1, 0, 1134, // -> 09DA
    /* 056C */ AI_IF_STAT_STAGE_EQUAL_TO, AI_BATTLER_TARGET, 4, 0, 1126, // -> 09D7
    /* 0571 */ AI_COUNT_ALIVE_PARTY_BATTLERS, AI_BATTLER_ATTACKER,
    /* 0573 */ AI_IF_LOADED_EQUAL_TO, 0, 1124, // -> 09DA
    /* 0576 */ AI_POP_OR_END,

    // 0577
    /* 0577 */ AI_COUNT_ALIVE_PARTY_BATTLERS, AI_BATTLER_ATTACKER,
    /* 0579 */ AI_IF_LOADED_EQUAL_TO, 0, 1118, // -> 09DA
    /* 057C */ AI_POP_OR_END,

    // 057D
    /* 057D */ AI_LOAD_BATTLER_ABILITY, AI_BATTLER_ATTACKER,
    /* 057F */ AI_IF_LOADED_EQUAL_TO, ABILITY_SWIFT_SWIM, 12, // -> 058E
    /* 0582 */ AI_IF_LOADED_EQUAL_TO, ABILITY_HYDRATION, 9, // -> 058E
    /* 0585 */ AI_LOAD_BATTLER_ABILITY, AI_BATTLER_TARGET,
    /* 0587 */ AI_IF_LOADED_NOT_EQUAL_TO, ABILITY_HYDRATION, 4, // -> 058E
    /* 058A */ AI_IF_STATUS, AI_BATTLER_TARGET, 0xFF, 1097, // -> 09D7

    // 058E
    /* 058E */ AI_LOAD_CURRENT_WEATHER,
    /* 058F */ AI_IF_LOADED_EQUAL_TO, 2, 1093, // -> 09D7
    /* 0592 */ AI_POP_OR_END,

    // 0593
    /* 0593 */ AI_LOAD_BATTLER_ABILITY, AI_BATTLER_ATTACKER,
    /* 0595 */ AI_IF_LOADED_EQUAL_TO, ABILITY_FLOWER_GIFT, 15, // -> 05A7
    /* 0598 */ AI_IF_LOADED_EQUAL_TO, ABILITY_LEAF_GUARD, 12, // -> 05A7
    /* 059B */ AI_IF_LOADED_EQUAL_TO, ABILITY_SOLAR_POWER, 9, // -> 05A7
    /* 059E */ AI_LOAD_BATTLER_ABILITY, AI_BATTLER_TARGET,
    /* 05A0 */ AI_IF_LOADED_NOT_EQUAL_TO, ABILITY_HYDRATION, 4, // -> 05A7
    /* 05A3 */ AI_IF_STATUS, AI_BATTLER_TARGET, 0xFF, 1075, // -> 09DA

    // 05A7
    /* 05A7 */ AI_LOAD_CURRENT_WEATHER,
    /* 05A8 */ AI_IF_LOADED_EQUAL_TO, 1, 1068, // -> 09D7
    /* 05AB */ AI_POP_OR_END,

    // 05AC
    /* 05AC */ AI_IF_SIDE_CONDITION, AI_BATTLER_TARGET, 0x10, 1069, // -> 09DD
    /* 05B0 */ AI_IF_SIDE_CONDITION, AI_BATTLER_ATTACKER, 0x10, 1065, // -> 09DD
    /* 05B4 */ AI_POP_OR_END,

    // 05B5
    /* 05B5 */ AI_LOAD_IS_FIRST_TURN_IN_BATTLE, AI_BATTLER_ATTACKER,
    /* 05B7 */ AI_IF_LOADED_EQUAL_TO, 0, 1056, // -> 09DA
    /* 05BA */ AI_POP_OR_END,

    // 05BB
    /* 05BB */ AI_LOAD_STOCKPILE_COUNT, AI_BATTLER_ATTACKER,
    /* 05BD */ AI_IF_LOADED_EQUAL_TO, 3, 1050, // -> 09DA
    /* 05C0 */ AI_POP_OR_END,

    // 05C1
    /* 05C1 */ AI_IF_MOVE_EFFECTIVENESS_EQUALS, 0, 1046, // -> 09DA
    /* 05C4 */ AI_LOAD_STOCKPILE_COUNT, AI_BATTLER_ATTACKER,
    /* 05C6 */ AI_IF_LOADED_EQUAL_TO, 0, 1041, // -> 09DA
    /* 05C9 */ AI_IF_CURRENT_MOVE_EFFECT_EQUAL_TO, MOVE_EFFECT_SWALLOW, -469, // -> 03F7
    /* 05CC */ AI_POP_OR_END,

    // 05CD
    /* 05CD */ AI_LOAD_CURRENT_WEATHER,
    /* 05CE */ AI_IF_LOADED_EQUAL_TO, 4, 1030, // -> 09D7
    /* 05D1 */ AI_LOAD_BATTLER_ABILITY, AI_BATTLER_TARGET,
    /* 05D3 */ AI_IF_LOADED_NOT_EQUAL_TO, ABILITY_ICE_BODY, 9, // -> 05DF
    /* 05D6 */ AI_ADD_TO_MOVE_SCORE, -8,
    /* 05D8 */ AI_LOAD_BATTLER_ABILITY, AI_BATTLER_ATTACKER,
    /* 05DA */ AI_IF_LOADED_NOT_EQUAL_TO, ABILITY_ICE_BODY, 2, // -> 05DF
    /* 05DD */ AI_ADD_TO_MOVE_SCORE, 8,

    // 05DF
    /* 05DF */ AI_POP_OR_END,

    // 05E0
    /* 05E0 */ AI_IF_VOLATILE_STATUS, AI_BATTLER_TARGET, -2147483648, 1014, // -> 09DA
    /* 05E4 */ AI_POP_OR_END,

    // 05E5
    /* 05E5 */ AI_LOAD_BATTLER_ABILITY, AI_BATTLER_TARGET,
    /* 05E7 */ AI_IF_LOADED_EQUAL_TO, ABILITY_WATER_VEIL, 1008, // -> 09DA
    /* 05EA */ AI_IF_LOADED_EQUAL_TO, ABILITY_MAGIC_GUARD, 1005, // -> 09DA
    /* 05ED */ AI_IF_STATUS, AI_BATTLER_TARGET, 0xFF, 1001, // -> 09DA
    /* 05F1 */ AI_LOAD_TYPE_FROM, 0,
    /* 05F3 */ AI_IF_LOADED_EQUAL_TO, TYPE_FIRE, 996, // -> 09DA
    /* 05F6 */ AI_LOAD_TYPE_FROM, 2,
    /* 05F8 */ AI_IF_LOADED_EQUAL_TO, TYPE_FIRE, 991, // -> 09DA
    /* 05FB */ AI_IF_SIDE_CONDITION, AI_BATTLER_TARGET, 0x8, 987, // -> 09DA
    /* 05FF */ AI_POP_OR_END,

    // 0600
    /* 0600 */ AI_LOAD_BATTLE_TYPE,
    /* 0601 */ AI_IF_LOADED_NOT_MASK, 0x2, 982, // -> 09DA
    /* 0604 */ AI_POP_OR_END,

    // 0605
    /* 0605 */ AI_LOAD_BATTLER_ABILITY, AI_BATTLER_TARGET,
    /* 0607 */ AI_IF_LOADED_EQUAL_TO, ABILITY_STICKY_HOLD, 976, // -> 09DA
    /* 060A */ AI_LOAD_HELD_ITEM, AI_BATTLER_TARGET,
    /* 060C */ AI_IF_LOADED_EQUAL_TO, ITEM_NONE, 971, // -> 09DA
    /* 060F */ AI_POP_OR_END,

    // 0610
    /* 0610 */ AI_IF_MOVE_EFFECT_FLAG, AI_BATTLER_ATTACKER, 0x400, 966, // -> 09DA
    /* 0614 */ AI_POP_OR_END,

    // 0615
    /* 0615 */ AI_LOAD_RECYCLE_ITEM, AI_BATTLER_ATTACKER,
    /* 0617 */ AI_IF_LOADED_EQUAL_TO, ITEM_NONE, 960, // -> 09DA
    /* 061A */ AI_POP_OR_END,

    // 061B
    /* 061B */ AI_IF_MOVE_EFFECT_FLAG, AI_BATTLER_ATTACKER, 0x2000, 955, // -> 09DA
    /* 061F */ AI_IF_MOVE_EFFECT_FLAG, AI_BATTLER_TARGET, 0x40000000, 951, // -> 09DA
    /* 0623 */ AI_POP_OR_END,

    // 0624
    /* 0624 */ AI_IF_NOT_STATUS, AI_BATTLER_ATTACKER, 0xD8, 946, // -> 09DA
    /* 0628 */ AI_POP_OR_END,

    // 0629
    /* 0629 */ AI_IF_MOVE_EFFECT_FLAG, AI_BATTLER_ATTACKER, 0x10000, 941, // -> 09DA
    /* 062D */ AI_POP_OR_END,

    // 062E
    /* 062E */ AI_LOAD_BATTLER_ABILITY, AI_BATTLER_ATTACKER,
    /* 0630 */ AI_IF_LOADED_EQUAL_TO, ABILITY_MOLD_BREAKER, 8, // -> 063B
    /* 0633 */ AI_LOAD_BATTLER_ABILITY, AI_BATTLER_TARGET,
    /* 0635 */ AI_IF_LOADED_EQUAL_TO, ABILITY_CLEAR_BODY, 930, // -> 09DA
    /* 0638 */ AI_IF_LOADED_EQUAL_TO, ABILITY_WHITE_SMOKE, 927, // -> 09DA

    // 063B
    /* 063B */ AI_IF_STAT_STAGE_EQUAL_TO, AI_BATTLER_TARGET, 1, 0, 922, // -> 09DA
    /* 0640 */ AI_IF_STAT_STAGE_EQUAL_TO, AI_BATTLER_TARGET, 2, 0, 914, // -> 09D7
    /* 0645 */ AI_POP_OR_END,

    // 0646
    /* 0646 */ AI_LOAD_BATTLER_ABILITY, AI_BATTLER_ATTACKER,
    /* 0648 */ AI_IF_LOADED_NOT_EQUAL_TO, ABILITY_SIMPLE, 11, // -> 0656
    /* 064B */ AI_IF_STAT_STAGE_GREATER_THAN, AI_BATTLER_ATTACKER, 2, 8, 906, // -> 09DA
    /* 0650 */ AI_IF_STAT_STAGE_GREATER_THAN, AI_BATTLER_ATTACKER, 5, 8, 901, // -> 09DA
    /* 0655 */ AI_POP_OR_END,

    // 0656
    /* 0656 */ AI_IF_STAT_STAGE_EQUAL_TO, AI_BATTLER_ATTACKER, 2, 12, 895, // -> 09DA
    /* 065B */ AI_IF_STAT_STAGE_EQUAL_TO, AI_BATTLER_ATTACKER, 5, 12, 887, // -> 09D7
    /* 0660 */ AI_POP_OR_END,

    // 0661
    /* 0661 */ AI_LOAD_BATTLER_ABILITY, AI_BATTLER_ATTACKER,
    /* 0663 */ AI_IF_LOADED_NOT_EQUAL_TO, ABILITY_SIMPLE, 11, // -> 0671
    /* 0666 */ AI_IF_STAT_STAGE_GREATER_THAN, AI_BATTLER_ATTACKER, 1, 8, 879, // -> 09DA
    /* 066B */ AI_IF_STAT_STAGE_GREATER_THAN, AI_BATTLER_ATTACKER, 2, 8, 874, // -> 09DA
    /* 0670 */ AI_POP_OR_END,

    // 0671
    /* 0671 */ AI_IF_STAT_STAGE_EQUAL_TO, AI_BATTLER_ATTACKER, 1, 12, 868, // -> 09DA
    /* 0676 */ AI_IF_STAT_STAGE_EQUAL_TO, AI_BATTLER_ATTACKER, 2, 12, 860, // -> 09D7
    /* 067B */ AI_POP_OR_END,

    // 067C
    /* 067C */ AI_IF_MOVE_EFFECT_FLAG, AI_BATTLER_ATTACKER, 0x20000, 858, // -> 09DA
    /* 0680 */ AI_POP_OR_END,

    // 0681
    /* 0681 */ AI_LOAD_BATTLER_ABILITY, AI_BATTLER_ATTACKER,
    /* 0683 */ AI_IF_LOADED_NOT_EQUAL_TO, ABILITY_SIMPLE, 11, // -> 0691
    /* 0686 */ AI_IF_STAT_STAGE_GREATER_THAN, AI_BATTLER_ATTACKER, 4, 8, 847, // -> 09DA
    /* 068B */ AI_IF_STAT_STAGE_GREATER_THAN, AI_BATTLER_ATTACKER, 5, 8, 842, // -> 09DA
    /* 0690 */ AI_POP_OR_END,

    // 0691
    /* 0691 */ AI_IF_STAT_STAGE_EQUAL_TO, AI_BATTLER_ATTACKER, 4, 12, 836, // -> 09DA
    /* 0696 */ AI_IF_STAT_STAGE_EQUAL_TO, AI_BATTLER_ATTACKER, 5, 12, 828, // -> 09D7
    /* 069B */ AI_POP_OR_END,

    // 069C
    /* 069C */ AI_IF_FIELD_CONDITIONS_MASK, 0x70000, 827, // -> 09DA
    /* 069F */ AI_LOAD_BATTLER_ABILITY, AI_BATTLER_ATTACKER,
    /* 06A1 */ AI_IF_LOADED_NOT_EQUAL_TO, ABILITY_SIMPLE, 11, // -> 06AF
    /* 06A4 */ AI_IF_STAT_STAGE_GREATER_THAN, AI_BATTLER_ATTACKER, 1, 8, 817, // -> 09DA
    /* 06A9 */ AI_IF_STAT_STAGE_GREATER_THAN, AI_BATTLER_ATTACKER, 3, 8, 812, // -> 09DA
    /* 06AE */ AI_POP_OR_END,

    // 06AF
    /* 06AF */ AI_IF_STAT_STAGE_EQUAL_TO, AI_BATTLER_ATTACKER, 1, 12, 806, // -> 09DA
    /* 06B4 */ AI_IF_STAT_STAGE_EQUAL_TO, AI_BATTLER_ATTACKER, 3, 12, 798, // -> 09D7
    /* 06B9 */ AI_POP_OR_END,

    // 06BA
    /* 06BA */ AI_IF_MOVE_EFFECT_FLAG, AI_BATTLER_ATTACKER, 0x10000000, 796, // -> 09DA
    /* 06BE */ AI_POP_OR_END,

    // 06BF
    /* 06BF */ AI_IF_FIELD_CONDITIONS_MASK, 0x7000, 792, // -> 09DA
    /* 06C2 */ AI_POP_OR_END,

    // 06C3
    /* 06C3 */ AI_IF_MOVE_EFFECT_FLAG, AI_BATTLER_TARGET, 0x400000, 787, // -> 09DA
    /* 06C7 */ AI_POP_OR_END,

    // 06C8
    /* 06C8 */ AI_ADD_TO_MOVE_SCORE, -20,
    /* 06CA */ AI_COUNT_ALIVE_PARTY_BATTLERS, AI_BATTLER_ATTACKER,
    /* 06CC */ AI_IF_LOADED_EQUAL_TO, 0, 779, // -> 09DA
    /* 06CF */ AI_IF_PARTY_MEMBER_STATUS, AI_BATTLER_ATTACKER, 0xFF, 5, // -> 06D8
    /* 06D3 */ AI_IF_ANY_PARTY_MEMBER_IS_WOUNDED, AI_BATTLER_ATTACKER, 2, // -> 06D8
    /* 06D6 */ AI_GOTO, 770, // -> 09DA

    // 06D8
    /* 06D8 */ AI_POP_OR_END,

    // 06D9
    /* 06D9 */ AI_LOAD_HELD_ITEM, AI_BATTLER_ATTACKER,
    /* 06DB */ AI_IF_LOADED_NOT_IN_TABLE, 4, 764, // table 06E2, -> 09DA
    /* 06DE */ AI_IF_MOVE_EFFECTIVENESS_EQUALS, 0, 761, // -> 09DA
    /* 06E1 */ AI_POP_OR_END,

    // 06E2
    /* 06E2 */ ITEM_CHERI_BERRY, ITEM_CHESTO_BERRY, ITEM_PECHA_BERRY, ITEM_RAWST_BERRY,
               ITEM_ASPEAR_BERRY, ITEM_LEPPA_BERRY, ITEM_ORAN_BERRY, ITEM_PERSIM_BERRY,
               ITEM_LUM_BERRY, ITEM_SITRUS_BERRY, ITEM_FIGY_BERRY, ITEM_WIKI_BERRY,
               ITEM_MAGO_BERRY, ITEM_AGUAV_BERRY, ITEM_IAPAPA_BERRY, ITEM_RAZZ_BERRY,
               ITEM_BLUK_BERRY, ITEM_NANAB_BERRY, ITEM_WEPEAR_BERRY, ITEM_PINAP_BERRY,
               ITEM_POMEG_BERRY, ITEM_KELPSY_BERRY, ITEM_QUALOT_BERRY, ITEM_HONDEW_BERRY,
               ITEM_GREPA_BERRY, ITEM_TAMATO_BERRY, ITEM_CORNN_BERRY, ITEM_MAGOST_BERRY,
               ITEM_RABUTA_BERRY, ITEM_NOMEL_BERRY, ITEM_SPELON_BERRY, ITEM_PAMTRE_BERRY,
               ITEM_WATMEL_BERRY, ITEM_DURIN_BERRY, ITEM_BELUE_BERRY, ITEM_OCCA_BERRY,
               ITEM_PASSHO_BERRY, ITEM_WACAN_BERRY, ITEM_RINDO_BERRY, ITEM_YACHE_BERRY,
               ITEM_CHOPLE_BERRY, ITEM_KEBIA_BERRY, ITEM_SHUCA_BERRY, ITEM_COBA_BERRY,
               ITEM_PAYAPA_BERRY, ITEM_TANGA_BERRY, ITEM_CHARTI_BERRY, ITEM_KASIB_BERRY,
               ITEM_HABAN_BERRY, ITEM_COLBUR_BERRY, ITEM_BABIRI_BERRY, ITEM_CHILAN_BERRY,
               ITEM_LIECHI_BERRY, ITEM_GANLON_BERRY, ITEM_SALAC_BERRY, ITEM_PETAYA_BERRY,
               ITEM_APICOT_BERRY, ITEM_LANSAT_BERRY, ITEM_STARF_BERRY, ITEM_ENIGMA_BERRY,
               ITEM_MICLE_BERRY, ITEM_CUSTAP_BERRY, ITEM_JABOCA_BERRY, ITEM_ROWAP_BERRY,
               AI_TABLE_END,

    // 0723
    /* 0723 */ AI_IF_FIELD_CONDITIONS_MASK, 0x70000, 692, // -> 09DA
    /* 0726 */ AI_IF_SIDE_CONDITION, AI_BATTLER_ATTACKER, 0x300, 688, // -> 09DA
    /* 072A */ AI_POP_OR_END,

    // 072B
    /* 072B */ AI_LOAD_BATTLER_ABILITY, AI_BATTLER_ATTACKER,
    /* 072D */ AI_IF_LOADED_EQUAL_TO, ABILITY_SIMPLE, 36, // -> 0754
    /* 0730 */ AI_IF_STAT_STAGE_EQUAL_TO, AI_BATTLER_ATTACKER, 1, 12, 677, // -> 09DA
    /* 0735 */ AI_IF_STAT_STAGE_EQUAL_TO, AI_BATTLER_ATTACKER, 2, 12, 672, // -> 09DA
    /* 073A */ AI_IF_STAT_STAGE_EQUAL_TO, AI_BATTLER_ATTACKER, 3, 12, 667, // -> 09DA
    /* 073F */ AI_IF_STAT_STAGE_EQUAL_TO, AI_BATTLER_ATTACKER, 4, 12, 662, // -> 09DA
    /* 0744 */ AI_IF_STAT_STAGE_EQUAL_TO, AI_BATTLER_ATTACKER, 5, 12, 657, // -> 09DA
    /* 0749 */ AI_IF_STAT_STAGE_EQUAL_TO, AI_BATTLER_ATTACKER, 7, 12, 652, // -> 09DA
    /* 074E */ AI_IF_STAT_STAGE_EQUAL_TO, AI_BATTLER_ATTACKER, 6, 12, 647, // -> 09DA
    /* 0753 */ AI_POP_OR_END,

    // 0754
    /* 0754 */ AI_IF_STAT_STAGE_GREATER_THAN, AI_BATTLER_ATTACKER, 1, 8, 641, // -> 09DA
    /* 0759 */ AI_IF_STAT_STAGE_GREATER_THAN, AI_BATTLER_ATTACKER, 2, 8, 636, // -> 09DA
    /* 075E */ AI_IF_STAT_STAGE_GREATER_THAN, AI_BATTLER_ATTACKER, 3, 8, 631, // -> 09DA
    /* 0763 */ AI_IF_STAT_STAGE_GREATER_THAN, AI_BATTLER_ATTACKER, 4, 8, 626, // -> 09DA
    /* 0768 */ AI_IF_STAT_STAGE_GREATER_THAN, AI_BATTLER_ATTACKER, 5, 8, 621, // -> 09DA
    /* 076D */ AI_IF_STAT_STAGE_GREATER_THAN, AI_BATTLER_ATTACKER, 7, 8, 616, // -> 09DA
    /* 0772 */ AI_IF_STAT_STAGE_GREATER_THAN, AI_BATTLER_ATTACKER, 6, 8, 611, // -> 09DA
    /* 0777 */ AI_POP_OR_END,

    // 0778
    /* 0778 */ AI_IF_MOVE_EFFECTIVENESS_EQUALS, 0, 607, // -> 09DA
    /* 077B */ AI_LOAD_BATTLER_ABILITY, AI_BATTLER_TARGET,
    /* 077D */ AI_IF_LOADED_EQUAL_TO, ABILITY_STALL, 602, // -> 09DA
    // ITEM_SHINY_STONE is 107, HOLD_EFFECT_SPEED_DOWN (Lagging Tail, Full Incense): retail compares the hold effect's number with the held item
    /* 0780 */ AI_IF_HELD_ITEM_EQUAL_TO, AI_BATTLER_TARGET, ITEM_SHINY_STONE, 598, // -> 09DA
    /* 0784 */ AI_LOAD_BATTLER_ABILITY, AI_BATTLER_ATTACKER,
    /* 0786 */ AI_IF_LOADED_EQUAL_TO, ABILITY_STALL, 7, // -> 0790
    // the same: 107 as an item is the Shiny Stone
    /* 0789 */ AI_IF_HELD_ITEM_EQUAL_TO, AI_BATTLER_ATTACKER, ITEM_SHINY_STONE, 3, // -> 0790
    /* 078D */ AI_IF_SPEED_COMPARE_EQUAL_TO, 0, 586, // -> 09DA

    // 0790
    /* 0790 */ AI_POP_OR_END,

    // 0791
    /* 0791 */ AI_IF_MOVE_EFFECT_FLAG, AI_BATTLER_TARGET, 0x4000000, 581, // -> 09DA
    /* 0795 */ AI_LOAD_RECYCLE_ITEM, AI_BATTLER_TARGET,
    /* 0797 */ AI_IF_LOADED_EQUAL_TO, ITEM_NONE, 4, // -> 079E
    /* 079A */ AI_LOAD_BATTLE_TYPE,
    /* 079B */ AI_IF_LOADED_MASK, 0x80, 572, // -> 09DA

    // 079E
    /* 079E */ AI_POP_OR_END,

    // 079F
    /* 079F */ AI_IF_MOVE_EFFECTIVENESS_EQUALS, 0, 568, // -> 09DA
    /* 07A2 */ AI_LOAD_FLING_POWER, AI_BATTLER_ATTACKER,
    /* 07A4 */ AI_IF_LOADED_LESS_THAN, 10, 563, // -> 09DA
    /* 07A7 */ AI_LOAD_BATTLER_ABILITY, AI_BATTLER_ATTACKER,
    /* 07A9 */ AI_IF_LOADED_EQUAL_TO, ABILITY_MULTITYPE, 558, // -> 09DA
    /* 07AC */ AI_LOAD_HELD_ITEM_EFFECT, AI_BATTLER_ATTACKER,
    /* 07AE */ AI_IF_LOADED_IN_TABLE, 168, 7, // table 0859, -> 07B8
    /* 07B1 */ AI_IF_LOADED_IN_TABLE, 168, 89, // table 085C, -> 080D
    /* 07B4 */ AI_IF_LOADED_IN_TABLE, 167, 148, // table 085E, -> 084B
    /* 07B7 */ AI_POP_OR_END,

    // 07B8
    /* 07B8 */ AI_IF_SIDE_CONDITION, AI_BATTLER_TARGET, 0x8, 37, // -> 07E1
    /* 07BC */ AI_IF_STATUS, AI_BATTLER_TARGET, 0xFF, 33, // -> 07E1
    /* 07C0 */ AI_LOAD_BATTLER_ABILITY, AI_BATTLER_ATTACKER,
    /* 07C2 */ AI_IF_LOADED_EQUAL_TO, ABILITY_POISON_HEAL, 28, // -> 07E1
    /* 07C5 */ AI_LOAD_TYPE_FROM, 0,
    /* 07C7 */ AI_IF_LOADED_EQUAL_TO, TYPE_POISON, 23, // -> 07E1
    /* 07CA */ AI_IF_LOADED_EQUAL_TO, TYPE_STEEL, 20, // -> 07E1
    /* 07CD */ AI_LOAD_TYPE_FROM, 2,
    /* 07CF */ AI_IF_LOADED_EQUAL_TO, TYPE_POISON, 15, // -> 07E1
    /* 07D2 */ AI_IF_LOADED_EQUAL_TO, TYPE_STEEL, 12, // -> 07E1
    /* 07D5 */ AI_LOAD_BATTLER_ABILITY, AI_BATTLER_TARGET,
    /* 07D7 */ AI_IF_LOADED_EQUAL_TO, ABILITY_IMMUNITY, 7, // -> 07E1
    /* 07DA */ AI_IF_LOADED_EQUAL_TO, ABILITY_POISON_HEAL, 4, // -> 07E1
    /* 07DD */ AI_IF_LOADED_EQUAL_TO, ABILITY_MAGIC_GUARD, 1, // -> 07E1
    /* 07E0 */ AI_POP_OR_END,

    // 07E1
    /* 07E1 */ AI_IF_SIDE_CONDITION, AI_BATTLER_ATTACKER, 0x8, 492, // -> 09D1
    /* 07E5 */ AI_IF_STATUS, AI_BATTLER_ATTACKER, 0xFF, 488, // -> 09D1
    /* 07E9 */ AI_LOAD_TYPE_FROM, 1,
    /* 07EB */ AI_IF_LOADED_EQUAL_TO, TYPE_POISON, 483, // -> 09D1
    /* 07EE */ AI_IF_LOADED_EQUAL_TO, TYPE_STEEL, 480, // -> 09D1
    /* 07F1 */ AI_LOAD_TYPE_FROM, 3,
    /* 07F3 */ AI_IF_LOADED_EQUAL_TO, TYPE_POISON, 475, // -> 09D1
    /* 07F6 */ AI_IF_LOADED_EQUAL_TO, TYPE_STEEL, 472, // -> 09D1
    /* 07F9 */ AI_LOAD_BATTLER_ABILITY, AI_BATTLER_ATTACKER,
    /* 07FB */ AI_IF_LOADED_EQUAL_TO, ABILITY_KLUTZ, 467, // -> 09D1
    /* 07FE */ AI_IF_LOADED_EQUAL_TO, ABILITY_IMMUNITY, 464, // -> 09D1
    /* 0801 */ AI_IF_LOADED_EQUAL_TO, ABILITY_POISON_HEAL, 461, // -> 09D1
    /* 0804 */ AI_IF_LOADED_EQUAL_TO, ABILITY_MAGIC_GUARD, 458, // -> 09D1
    /* 0807 */ AI_IF_LOADED_EQUAL_TO, ABILITY_GUTS, 455, // -> 09D1
    /* 080A */ AI_ADD_TO_MOVE_SCORE, 3,
    /* 080C */ AI_POP_OR_END,

    // 080D
    /* 080D */ AI_IF_SIDE_CONDITION, AI_BATTLER_TARGET, 0x8, 23, // -> 0828
    /* 0811 */ AI_IF_STATUS, AI_BATTLER_TARGET, 0xFF, 19, // -> 0828
    /* 0815 */ AI_LOAD_TYPE_FROM, 0,
    /* 0817 */ AI_IF_LOADED_EQUAL_TO, TYPE_FIRE, 14, // -> 0828
    /* 081A */ AI_LOAD_TYPE_FROM, 2,
    /* 081C */ AI_IF_LOADED_EQUAL_TO, TYPE_FIRE, 9, // -> 0828
    /* 081F */ AI_LOAD_BATTLER_ABILITY, AI_BATTLER_TARGET,
    /* 0821 */ AI_IF_LOADED_EQUAL_TO, ABILITY_MAGIC_GUARD, 4, // -> 0828
    /* 0824 */ AI_IF_LOADED_EQUAL_TO, ABILITY_WATER_VEIL, 1, // -> 0828
    /* 0827 */ AI_POP_OR_END,

    // 0828
    /* 0828 */ AI_IF_SIDE_CONDITION, AI_BATTLER_ATTACKER, 0x8, 421, // -> 09D1
    /* 082C */ AI_IF_STATUS, AI_BATTLER_ATTACKER, 0xFF, 417, // -> 09D1
    /* 0830 */ AI_LOAD_TYPE_FROM, 1,
    /* 0832 */ AI_IF_LOADED_EQUAL_TO, TYPE_FIRE, 412, // -> 09D1
    /* 0835 */ AI_LOAD_TYPE_FROM, 3,
    /* 0837 */ AI_IF_LOADED_EQUAL_TO, TYPE_FIRE, 407, // -> 09D1
    /* 083A */ AI_LOAD_BATTLER_ABILITY, AI_BATTLER_ATTACKER,
    /* 083C */ AI_IF_LOADED_EQUAL_TO, ABILITY_KLUTZ, 402, // -> 09D1
    /* 083F */ AI_IF_LOADED_EQUAL_TO, ABILITY_MAGIC_GUARD, 399, // -> 09D1
    /* 0842 */ AI_IF_LOADED_EQUAL_TO, ABILITY_WATER_VEIL, 396, // -> 09D1
    /* 0845 */ AI_IF_LOADED_EQUAL_TO, ABILITY_GUTS, 393, // -> 09D1
    /* 0848 */ AI_ADD_TO_MOVE_SCORE, 3,
    /* 084A */ AI_POP_OR_END,

    // 084B
    /* 084B */ AI_IF_SIDE_CONDITION, AI_BATTLER_TARGET, 0x8, 386, // -> 09D1
    /* 084F */ AI_IF_STATUS, AI_BATTLER_TARGET, 0xFF, 382, // -> 09D1
    /* 0853 */ AI_LOAD_BATTLER_ABILITY, AI_BATTLER_TARGET,
    /* 0855 */ AI_IF_LOADED_EQUAL_TO, ABILITY_LIMBER, 377, // -> 09D1
    /* 0858 */ AI_POP_OR_END,

    // 0859
    /* 0859 */ HOLD_EFFECT_PSN_USER, HOLD_EFFECT_STRENGTHEN_POISON, AI_TABLE_END,

    // 085C
    /* 085C */ HOLD_EFFECT_BRN_USER, AI_TABLE_END,

    // 085E
    /* 085E */ HOLD_EFFECT_PIKA_SPATK_UP, AI_TABLE_END,

    // 0860
    /* 0860 */ AI_IF_NOT_STATUS, AI_BATTLER_ATTACKER, 0xFF, 374, // -> 09DA
    /* 0864 */ AI_IF_STATUS, AI_BATTLER_TARGET, 0xFF, 370, // -> 09DA
    /* 0868 */ AI_IF_SIDE_CONDITION, AI_BATTLER_TARGET, 0x8, 366, // -> 09DA
    /* 086C */ AI_IF_STATUS, AI_BATTLER_ATTACKER, 0xF88, 10, // -> 087A
    /* 0870 */ AI_IF_STATUS, AI_BATTLER_ATTACKER, 0x10, 40, // -> 089C
    /* 0874 */ AI_IF_STATUS, AI_BATTLER_ATTACKER, 0x40, 56, // -> 08B0
    /* 0878 */ AI_GOTO, 59, // -> 08B5

    // 087A
    /* 087A */ AI_LOAD_BATTLER_ABILITY, AI_BATTLER_ATTACKER,
    /* 087C */ AI_IF_LOADED_EQUAL_TO, ABILITY_POISON_HEAL, 347, // -> 09DA
    /* 087F */ AI_LOAD_TYPE_FROM, 0,
    /* 0881 */ AI_IF_LOADED_EQUAL_TO, TYPE_POISON, 342, // -> 09DA
    /* 0884 */ AI_IF_LOADED_EQUAL_TO, TYPE_STEEL, 339, // -> 09DA
    /* 0887 */ AI_LOAD_TYPE_FROM, 2,
    /* 0889 */ AI_IF_LOADED_EQUAL_TO, TYPE_POISON, 334, // -> 09DA
    /* 088C */ AI_IF_LOADED_EQUAL_TO, TYPE_STEEL, 331, // -> 09DA
    /* 088F */ AI_LOAD_BATTLER_ABILITY, AI_BATTLER_TARGET,
    /* 0891 */ AI_IF_LOADED_EQUAL_TO, ABILITY_IMMUNITY, 326, // -> 09DA
    /* 0894 */ AI_IF_LOADED_EQUAL_TO, ABILITY_POISON_HEAL, 323, // -> 09DA
    /* 0897 */ AI_IF_LOADED_EQUAL_TO, ABILITY_MAGIC_GUARD, 320, // -> 09DA
    /* 089A */ AI_GOTO, 25, // -> 08B5

    // 089C
    /* 089C */ AI_LOAD_TYPE_FROM, 0,
    /* 089E */ AI_IF_LOADED_EQUAL_TO, TYPE_FIRE, 313, // -> 09DA
    /* 08A1 */ AI_LOAD_TYPE_FROM, 2,
    /* 08A3 */ AI_IF_LOADED_EQUAL_TO, TYPE_FIRE, 308, // -> 09DA
    /* 08A6 */ AI_LOAD_BATTLER_ABILITY, AI_BATTLER_TARGET,
    /* 08A8 */ AI_IF_LOADED_EQUAL_TO, ABILITY_MAGIC_GUARD, 303, // -> 09DA
    /* 08AB */ AI_IF_LOADED_EQUAL_TO, ABILITY_WATER_VEIL, 300, // -> 09DA
    /* 08AE */ AI_GOTO, 5, // -> 08B5

    // 08B0
    /* 08B0 */ AI_LOAD_BATTLER_ABILITY, AI_BATTLER_TARGET,
    /* 08B2 */ AI_IF_LOADED_EQUAL_TO, ABILITY_LIMBER, 293, // -> 09DA

    // 08B5
    /* 08B5 */ AI_POP_OR_END,

    // 08B6
    /* 08B6 */ AI_IF_MOVE_EFFECT_FLAG, AI_BATTLER_TARGET, 0x2000000, 288, // -> 09DA
    /* 08BA */ AI_POP_OR_END,

    // 08BB
    /* 08BB */ AI_IF_MOVE_EFFECT_FLAG, AI_BATTLER_ATTACKER, 0x800000, 283, // -> 09DA
    /* 08BF */ AI_POP_OR_END,

    // 08C0
    /* 08C0 */ AI_IF_MOVE_EFFECT_FLAG, AI_BATTLER_TARGET, 0x200000, 278, // -> 09DA
    /* 08C4 */ AI_LOAD_BATTLER_ABILITY, AI_BATTLER_TARGET,
    /* 08C6 */ AI_IF_LOADED_EQUAL_TO, ABILITY_MULTITYPE, 273, // -> 09DA
    /* 08C9 */ AI_IF_LOADED_EQUAL_TO, ABILITY_TRUANT, 270, // -> 09DA
    /* 08CC */ AI_IF_LOADED_EQUAL_TO, ABILITY_SLOW_START, 267, // -> 09DA
    /* 08CF */ AI_IF_LOADED_EQUAL_TO, ABILITY_STENCH, 264, // -> 09DA
    /* 08D2 */ AI_IF_LOADED_EQUAL_TO, ABILITY_RUN_AWAY, 261, // -> 09DA
    /* 08D5 */ AI_IF_LOADED_EQUAL_TO, ABILITY_PICKUP, 258, // -> 09DA
    /* 08D8 */ AI_IF_LOADED_EQUAL_TO, ABILITY_HONEY_GATHER, 255, // -> 09DA
    /* 08DB */ AI_POP_OR_END,

    // 08DC
    /* 08DC */ AI_IF_SIDE_CONDITION, AI_BATTLER_ATTACKER, 0x7000, 250, // -> 09DA
    /* 08E0 */ AI_POP_OR_END,

    // 08E1
    /* 08E1 */ AI_LOAD_TURN_COUNT,
    /* 08E2 */ AI_IF_LOADED_NOT_EQUAL_TO, 0, 3, // -> 08E8
    /* 08E5 */ AI_IF_SPEED_COMPARE_EQUAL_TO, 0, 242, // -> 09DA

    // 08E8
    /* 08E8 */ AI_POP_OR_END,

    // 08E9
    /* 08E9 */ AI_DIFF_STAT_STAGES, AI_BATTLER_TARGET, 1,
    /* 08EC */ AI_IF_LOADED_LESS_THAN, 1, 2, // -> 08F1
    /* 08EF */ AI_GOTO, 6, // -> 08F7

    // 08F1
    /* 08F1 */ AI_DIFF_STAT_STAGES, AI_BATTLER_TARGET, 4,
    /* 08F4 */ AI_IF_LOADED_LESS_THAN, 1, 227, // -> 09DA

    // 08F7
    /* 08F7 */ AI_POP_OR_END,

    // 08F8
    /* 08F8 */ AI_DIFF_STAT_STAGES, AI_BATTLER_TARGET, 2,
    /* 08FB */ AI_IF_LOADED_LESS_THAN, 1, 2, // -> 0900
    /* 08FE */ AI_GOTO, 6, // -> 0906

    // 0900
    /* 0900 */ AI_DIFF_STAT_STAGES, AI_BATTLER_TARGET, 5,
    /* 0903 */ AI_IF_LOADED_LESS_THAN, 1, 212, // -> 09DA

    // 0906
    /* 0906 */ AI_POP_OR_END,

    // 0907
    /* 0907 */ AI_IF_CAN_USE_LAST_RESORT, AI_BATTLER_ATTACKER, 2, // -> 090C
    /* 090A */ AI_ADD_TO_MOVE_SCORE, -10,

    // 090C
    /* 090C */ AI_POP_OR_END,

    // 090D
    /* 090D */ AI_LOAD_BATTLER_ABILITY, AI_BATTLER_TARGET,
    /* 090F */ AI_IF_LOADED_EQUAL_TO, ABILITY_TRUANT, 200, // -> 09DA
    /* 0912 */ AI_IF_LOADED_EQUAL_TO, ABILITY_INSOMNIA, 197, // -> 09DA
    /* 0915 */ AI_IF_LOADED_EQUAL_TO, ABILITY_VITAL_SPIRIT, 194, // -> 09DA
    /* 0918 */ AI_IF_LOADED_EQUAL_TO, ABILITY_MULTITYPE, 191, // -> 09DA
    /* 091B */ AI_IF_NOT_STATUS, AI_BATTLER_TARGET, 0x7, 10, // -> 0929
    /* 091F */ AI_IF_MOVE_KNOWN, AI_BATTLER_TARGET, MOVE_SLEEP_TALK, 6, // -> 0929
    /* 0923 */ AI_IF_MOVE_KNOWN, AI_BATTLER_TARGET, MOVE_SNORE, 2, // -> 0929
    /* 0927 */ AI_ADD_TO_MOVE_SCORE, -10,

    // 0929
    /* 0929 */ AI_POP_OR_END,

    // 092A
    /* 092A */ AI_LOAD_SPIKES_LAYERS, AI_BATTLER_TARGET, 0x400,
    /* 092D */ AI_IF_LOADED_EQUAL_TO, 2, 170, // -> 09DA
    /* 0930 */ AI_COUNT_ALIVE_PARTY_BATTLERS, AI_BATTLER_TARGET,
    /* 0932 */ AI_IF_LOADED_EQUAL_TO, 0, 165, // -> 09DA
    /* 0935 */ AI_POP_OR_END,
    // 0936: not reached
    /* 0936 */ AI_POP_OR_END,

    // 0937
    /* 0937 */ AI_IF_MOVE_EFFECT_FLAG, AI_BATTLER_ATTACKER, 0x1000000, 159, // -> 09DA
    /* 093B */ AI_POP_OR_END,

    // 093C
    /* 093C */ AI_IF_MOVE_EFFECT_FLAG, AI_BATTLER_ATTACKER, 0x8000000, 154, // -> 09DA
    /* 0940 */ AI_LOAD_BATTLER_ABILITY, AI_BATTLER_ATTACKER,
    /* 0942 */ AI_IF_LOADED_EQUAL_TO, ABILITY_LEVITATE, 149, // -> 09DA
    /* 0945 */ AI_LOAD_TYPE_FROM, 1,
    /* 0947 */ AI_IF_LOADED_EQUAL_TO, TYPE_FLYING, 144, // -> 09DA
    /* 094A */ AI_LOAD_TYPE_FROM, 3,
    /* 094C */ AI_IF_LOADED_EQUAL_TO, TYPE_FLYING, 139, // -> 09DA
    /* 094F */ AI_POP_OR_END,

    // 0950
    /* 0950 */ AI_IF_STAT_STAGE_NOT_EQUAL_TO, AI_BATTLER_TARGET, 7, 0, 31, // -> 0974
    /* 0955 */ AI_IF_SIDE_CONDITION, AI_BATTLER_TARGET, 0x2, 27, // -> 0974
    /* 0959 */ AI_IF_SIDE_CONDITION, AI_BATTLER_TARGET, 0x1, 23, // -> 0974
    /* 095D */ AI_LOAD_CURRENT_WEATHER,
    /* 095E */ AI_IF_LOADED_EQUAL_TO, 5, 19, // -> 0974
    /* 0961 */ AI_COUNT_ALIVE_PARTY_BATTLERS, AI_BATTLER_TARGET,
    /* 0963 */ AI_IF_LOADED_EQUAL_TO, 0, 116, // -> 09DA
    /* 0966 */ AI_IF_SIDE_CONDITION, AI_BATTLER_TARGET, 0x4, 10, // -> 0974
    /* 096A */ AI_IF_SIDE_CONDITION, AI_BATTLER_TARGET, 0x80, 6, // -> 0974
    /* 096E */ AI_IF_SIDE_CONDITION, AI_BATTLER_TARGET, 0x400, 2, // -> 0974
    /* 0972 */ AI_GOTO, 102, // -> 09DA

    // 0974
    /* 0974 */ AI_POP_OR_END,

    // 0975
    /* 0975 */ AI_IF_SPEED_COMPARE_EQUAL_TO, 0, 98, // -> 09DA
    /* 0978 */ AI_IF_SPEED_COMPARE_EQUAL_TO, 2, 95, // -> 09DA
    /* 097B */ AI_POP_OR_END,

    // 097C
    /* 097C */ AI_LOAD_BATTLER_ABILITY, AI_BATTLER_ATTACKER,
    /* 097E */ AI_IF_LOADED_EQUAL_TO, ABILITY_MOLD_BREAKER, 11, // -> 098C
    /* 0981 */ AI_LOAD_BATTLER_ABILITY, AI_BATTLER_TARGET,
    /* 0983 */ AI_IF_LOADED_EQUAL_TO, ABILITY_OBLIVIOUS, 84, // -> 09DA
    /* 0986 */ AI_IF_LOADED_EQUAL_TO, ABILITY_CLEAR_BODY, 81, // -> 09DA
    /* 0989 */ AI_IF_LOADED_EQUAL_TO, ABILITY_WHITE_SMOKE, 78, // -> 09DA

    // 098C
    /* 098C */ AI_LOAD_GENDER, AI_BATTLER_ATTACKER,
    /* 098E */ AI_IF_LOADED_EQUAL_TO, 0, 5, // -> 0996
    /* 0991 */ AI_IF_LOADED_EQUAL_TO, 1, 9, // -> 099D
    /* 0994 */ AI_GOTO, 68, // -> 09DA

    // 0996
    /* 0996 */ AI_LOAD_GENDER, AI_BATTLER_TARGET,
    /* 0998 */ AI_IF_LOADED_EQUAL_TO, 1, 9, // -> 09A4
    /* 099B */ AI_GOTO, 61, // -> 09DA

    // 099D
    /* 099D */ AI_LOAD_GENDER, AI_BATTLER_TARGET,
    /* 099F */ AI_IF_LOADED_EQUAL_TO, 0, 2, // -> 09A4
    /* 09A2 */ AI_GOTO, 54, // -> 09DA

    // 09A4
    /* 09A4 */ AI_IF_STAT_STAGE_LESS_THAN, AI_BATTLER_TARGET, 4, 1, 49, // -> 09DA
    /* 09A9 */ AI_POP_OR_END,

    // 09AA
    /* 09AA */ AI_IF_SIDE_CONDITION, AI_BATTLER_TARGET, 0x80, 44, // -> 09DA
    /* 09AE */ AI_COUNT_ALIVE_PARTY_BATTLERS, AI_BATTLER_TARGET,
    /* 09B0 */ AI_IF_LOADED_EQUAL_TO, 0, 39, // -> 09DA
    /* 09B3 */ AI_POP_OR_END,

    // 09B4
    /* 09B4 */ AI_ADD_TO_MOVE_SCORE, -20,
    /* 09B6 */ AI_COUNT_ALIVE_PARTY_BATTLERS, AI_BATTLER_ATTACKER,
    /* 09B8 */ AI_IF_LOADED_EQUAL_TO, 0, 31, // -> 09DA
    /* 09BB */ AI_IF_ANY_PARTY_MEMBER_IS_WOUNDED, AI_BATTLER_ATTACKER, 9, // -> 09C7
    /* 09BE */ AI_IF_PARTY_MEMBER_STATUS, AI_BATTLER_ATTACKER, 0xFF, 5, // -> 09C7
    /* 09C2 */ AI_IF_ANY_PARTY_MEMBER_USED_PP, AI_BATTLER_ATTACKER, 2, // -> 09C7
    /* 09C5 */ AI_GOTO, 19, // -> 09DA

    // 09C7
    /* 09C7 */ AI_POP_OR_END,

    // 09C8
    /* 09C8 */ AI_ADD_TO_MOVE_SCORE, -1,
    /* 09CA */ AI_POP_OR_END,

    // 09CB
    /* 09CB */ AI_ADD_TO_MOVE_SCORE, -2,
    /* 09CD */ AI_POP_OR_END,

    // 09CE
    /* 09CE */ AI_ADD_TO_MOVE_SCORE, -3,
    /* 09D0 */ AI_POP_OR_END,

    // 09D1
    /* 09D1 */ AI_ADD_TO_MOVE_SCORE, -5,
    /* 09D3 */ AI_POP_OR_END,
    // 09D4: not reached
    /* 09D4 */ AI_ADD_TO_MOVE_SCORE, -6,
    /* 09D6 */ AI_POP_OR_END,

    // 09D7
    /* 09D7 */ AI_ADD_TO_MOVE_SCORE, -8,
    /* 09D9 */ AI_POP_OR_END,

    // 09DA
    /* 09DA */ AI_ADD_TO_MOVE_SCORE, -10,
    /* 09DC */ AI_POP_OR_END,

    // 09DD
    /* 09DD */ AI_ADD_TO_MOVE_SCORE, -12,
    /* 09DF */ AI_POP_OR_END,

    // 09E0
    /* 09E0 */ AI_ADD_TO_MOVE_SCORE, -30,
    /* 09E2 */ AI_POP_OR_END,

    // 09E3
    /* 09E3 */ AI_ADD_TO_MOVE_SCORE, 1,
    /* 09E5 */ AI_POP_OR_END,

    // 09E6
    /* 09E6 */ AI_ADD_TO_MOVE_SCORE, 2,
    /* 09E8 */ AI_POP_OR_END,

    // 09E9
    /* 09E9 */ AI_ADD_TO_MOVE_SCORE, 3,
    /* 09EB */ AI_POP_OR_END,

    // 09EC
    /* 09EC */ AI_ADD_TO_MOVE_SCORE, 5,
    /* 09EE */ AI_POP_OR_END,

    // 09EF
    /* 09EF */ AI_ADD_TO_MOVE_SCORE, 10,
    /* 09F1 */ AI_POP_OR_END,

    // 09F2: flag 2
    /* 09F2 */ AI_IF_TARGET_IS_PARTNER, 8058, // -> 296E
    /* 09F4 */ AI_IF_CURRENT_MOVE_EFFECT_EQUAL_TO, MOVE_EFFECT_STATUS_SLEEP, 532, // -> 0C0B
    /* 09F7 */ AI_IF_CURRENT_MOVE_EFFECT_EQUAL_TO, MOVE_EFFECT_RECOVER_HALF_DAMAGE_DELT, 545, // -> 0C1B
    /* 09FA */ AI_IF_CURRENT_MOVE_EFFECT_EQUAL_TO, MOVE_EFFECT_HALVE_DEFENSE, 559, // -> 0C2C
    /* 09FD */ AI_IF_CURRENT_MOVE_EFFECT_EQUAL_TO, MOVE_EFFECT_RECOVER_DAMAGE_SLEEP, 611, // -> 0C63
    /* 0A00 */ AI_IF_CURRENT_MOVE_EFFECT_EQUAL_TO, MOVE_EFFECT_COPY_MOVE, 633, // -> 0C7C
    /* 0A03 */ AI_IF_CURRENT_MOVE_EFFECT_EQUAL_TO, MOVE_EFFECT_ATK_UP, 704, // -> 0CC6
    /* 0A06 */ AI_IF_CURRENT_MOVE_EFFECT_EQUAL_TO, MOVE_EFFECT_DEF_UP, 736, // -> 0CE9
    /* 0A09 */ AI_IF_CURRENT_MOVE_EFFECT_EQUAL_TO, MOVE_EFFECT_SPEED_UP, 794, // -> 0D26
    /* 0A0C */ AI_IF_CURRENT_MOVE_EFFECT_EQUAL_TO, MOVE_EFFECT_SP_ATK_UP, 804, // -> 0D33
    /* 0A0F */ AI_IF_CURRENT_MOVE_EFFECT_EQUAL_TO, MOVE_EFFECT_SP_DEF_UP, 836, // -> 0D56
    /* 0A12 */ AI_IF_CURRENT_MOVE_EFFECT_EQUAL_TO, MOVE_EFFECT_ACC_UP, 894, // -> 0D93
    /* 0A15 */ AI_IF_CURRENT_MOVE_EFFECT_EQUAL_TO, MOVE_EFFECT_EVA_UP, 908, // -> 0DA4
    /* 0A18 */ AI_IF_CURRENT_MOVE_EFFECT_EQUAL_TO, MOVE_EFFECT_BYPASS_ACCURACY, 1003, // -> 0E06
    /* 0A1B */ AI_IF_CURRENT_MOVE_EFFECT_EQUAL_TO, MOVE_EFFECT_ATK_DOWN, 1030, // -> 0E24
    /* 0A1E */ AI_IF_CURRENT_MOVE_EFFECT_EQUAL_TO, MOVE_EFFECT_DEF_DOWN, 1073, // -> 0E52
    /* 0A21 */ AI_IF_CURRENT_MOVE_EFFECT_EQUAL_TO, MOVE_EFFECT_SPEED_DOWN, 1111, // -> 0E7B
    /* 0A24 */ AI_IF_CURRENT_MOVE_EFFECT_EQUAL_TO, MOVE_EFFECT_SP_ATK_DOWN, 1121, // -> 0E88
    /* 0A27 */ AI_IF_CURRENT_MOVE_EFFECT_EQUAL_TO, MOVE_EFFECT_SP_DEF_DOWN, 1166, // -> 0EB8
    /* 0A2A */ AI_IF_CURRENT_MOVE_EFFECT_EQUAL_TO, MOVE_EFFECT_ACC_DOWN, 1184, // -> 0ECD
    /* 0A2D */ AI_IF_CURRENT_MOVE_EFFECT_EQUAL_TO, MOVE_EFFECT_EVA_DOWN, 1274, // -> 0F2A
    /* 0A30 */ AI_IF_CURRENT_MOVE_EFFECT_EQUAL_TO, MOVE_EFFECT_RESET_STAT_CHANGES, 1292, // -> 0F3F
    /* 0A33 */ AI_IF_CURRENT_MOVE_EFFECT_EQUAL_TO, MOVE_EFFECT_BIDE, 1409, // -> 0FB7
    /* 0A36 */ AI_IF_CURRENT_MOVE_EFFECT_EQUAL_TO, MOVE_EFFECT_FORCE_SWITCH, 1413, // -> 0FBE
    /* 0A39 */ AI_IF_CURRENT_MOVE_EFFECT_EQUAL_TO, MOVE_EFFECT_CONVERSION, 1467, // -> 0FF7
    /* 0A3C */ AI_IF_CURRENT_MOVE_EFFECT_EQUAL_TO, MOVE_EFFECT_RESTORE_HALF_HP, 1492, // -> 1013
    /* 0A3F */ AI_IF_CURRENT_MOVE_EFFECT_EQUAL_TO, MOVE_EFFECT_STATUS_BADLY_POISON, 1539, // -> 1045
    /* 0A42 */ AI_IF_CURRENT_MOVE_EFFECT_EQUAL_TO, MOVE_EFFECT_SET_LIGHT_SCREEN, 1572, // -> 1069
    /* 0A45 */ AI_IF_CURRENT_MOVE_EFFECT_EQUAL_TO, MOVE_EFFECT_RECOVER_HEALTH_AND_SLEEP, 1605, // -> 108D
    /* 0A48 */ AI_IF_CURRENT_MOVE_EFFECT_EQUAL_TO, MOVE_EFFECT_ONE_HIT_KO, 1656, // -> 10C3
    /* 0A4B */ AI_IF_CURRENT_MOVE_EFFECT_EQUAL_TO, MOVE_EFFECT_CHARGE_TURN_HIGH_CRIT, 2988, // -> 15FA
    /* 0A4E */ AI_IF_CURRENT_MOVE_EFFECT_EQUAL_TO, MOVE_EFFECT_HALVE_HP, 1656, // -> 10C9
    /* 0A51 */ AI_IF_CURRENT_MOVE_EFFECT_EQUAL_TO, MOVE_EFFECT_BIND_HIT, 1660, // -> 10D0
    /* 0A54 */ AI_IF_CURRENT_MOVE_EFFECT_EQUAL_TO, MOVE_EFFECT_HIGH_CRITICAL, 1681, // -> 10E8
    /* 0A57 */ AI_IF_CURRENT_MOVE_EFFECT_EQUAL_TO, MOVE_EFFECT_RECOIL_QUARTER_DAMAGE_DELT, 5628, // -> 2056
    /* 0A5A */ AI_IF_CURRENT_MOVE_EFFECT_EQUAL_TO, MOVE_EFFECT_STATUS_CONFUSE, 1708, // -> 1109
    /* 0A5D */ AI_IF_CURRENT_MOVE_EFFECT_EQUAL_TO, MOVE_EFFECT_ATK_UP_2, 614, // -> 0CC6
    /* 0A60 */ AI_IF_CURRENT_MOVE_EFFECT_EQUAL_TO, MOVE_EFFECT_DEF_UP_2, 646, // -> 0CE9
    /* 0A63 */ AI_IF_CURRENT_MOVE_EFFECT_EQUAL_TO, MOVE_EFFECT_SPEED_UP_2, 704, // -> 0D26
    /* 0A66 */ AI_IF_CURRENT_MOVE_EFFECT_EQUAL_TO, MOVE_EFFECT_SP_ATK_UP_2, 714, // -> 0D33
    /* 0A69 */ AI_IF_CURRENT_MOVE_EFFECT_EQUAL_TO, MOVE_EFFECT_SP_DEF_UP_2, 746, // -> 0D56
    /* 0A6C */ AI_IF_CURRENT_MOVE_EFFECT_EQUAL_TO, MOVE_EFFECT_ACC_UP_2, 804, // -> 0D93
    /* 0A6F */ AI_IF_CURRENT_MOVE_EFFECT_EQUAL_TO, MOVE_EFFECT_EVA_UP_2, 818, // -> 0DA4
    /* 0A72 */ AI_IF_CURRENT_MOVE_EFFECT_EQUAL_TO, MOVE_EFFECT_ATK_DOWN_2, 943, // -> 0E24
    /* 0A75 */ AI_IF_CURRENT_MOVE_EFFECT_EQUAL_TO, MOVE_EFFECT_DEF_DOWN_2, 986, // -> 0E52
    /* 0A78 */ AI_IF_CURRENT_MOVE_EFFECT_EQUAL_TO, MOVE_EFFECT_SPEED_DOWN_2, 1024, // -> 0E7B
    /* 0A7B */ AI_IF_CURRENT_MOVE_EFFECT_EQUAL_TO, MOVE_EFFECT_SP_ATK_DOWN_2, 1034, // -> 0E88
    /* 0A7E */ AI_IF_CURRENT_MOVE_EFFECT_EQUAL_TO, MOVE_EFFECT_SP_DEF_DOWN_2, 1079, // -> 0EB8
    /* 0A81 */ AI_IF_CURRENT_MOVE_EFFECT_EQUAL_TO, MOVE_EFFECT_ACC_DOWN_2, 1097, // -> 0ECD
    /* 0A84 */ AI_IF_CURRENT_MOVE_EFFECT_EQUAL_TO, MOVE_EFFECT_EVA_DOWN_2, 1187, // -> 0F2A
    /* 0A87 */ AI_IF_CURRENT_MOVE_EFFECT_EQUAL_TO, MOVE_EFFECT_SET_REFLECT, 1703, // -> 1131
    /* 0A8A */ AI_IF_CURRENT_MOVE_EFFECT_EQUAL_TO, MOVE_EFFECT_STATUS_POISON, 1737, // -> 1156
    /* 0A8D */ AI_IF_CURRENT_MOVE_EFFECT_EQUAL_TO, MOVE_EFFECT_STATUS_PARALYZE, 1745, // -> 1161
    /* 0A90 */ AI_IF_CURRENT_MOVE_EFFECT_EQUAL_TO, MOVE_EFFECT_ATK_UP_2_STATUS_CONFUSION, 1645, // -> 1100
    /* 0A93 */ AI_IF_CURRENT_MOVE_EFFECT_EQUAL_TO, MOVE_EFFECT_LOWER_SPEED_HIT, 977, // -> 0E67
    /* 0A96 */ AI_IF_CURRENT_MOVE_EFFECT_EQUAL_TO, MOVE_EFFECT_CHARGE_TURN_HIGH_CRIT_FLINCH, 2913, // -> 15FA
    /* 0A99 */ AI_IF_CURRENT_MOVE_EFFECT_EQUAL_TO, MOVE_EFFECT_PRIORITY_NEG_1_BYPASS_ACCURACY, 1750, // -> 1172
    /* 0A9C */ AI_IF_CURRENT_MOVE_EFFECT_EQUAL_TO, MOVE_EFFECT_SET_SUBSTITUTE, 1767, // -> 1186
    /* 0A9F */ AI_IF_CURRENT_MOVE_EFFECT_EQUAL_TO, MOVE_EFFECT_RECHARGE_AFTER, 1851, // -> 11DD
    /* 0AA2 */ AI_IF_CURRENT_MOVE_EFFECT_EQUAL_TO, MOVE_EFFECT_STATUS_LEECH_SEED, 1440, // -> 1045
    /* 0AA5 */ AI_IF_CURRENT_MOVE_EFFECT_EQUAL_TO, MOVE_EFFECT_DISABLE, 1882, // -> 1202
    /* 0AA8 */ AI_IF_CURRENT_MOVE_EFFECT_EQUAL_TO, MOVE_EFFECT_COUNTER, 1898, // -> 1215
    /* 0AAB */ AI_IF_CURRENT_MOVE_EFFECT_EQUAL_TO, MOVE_EFFECT_ENCORE, 1992, // -> 1276
    /* 0AAE */ AI_IF_CURRENT_MOVE_EFFECT_EQUAL_TO, MOVE_EFFECT_AVERAGE_HP, 2095, // -> 12E0
    /* 0AB1 */ AI_IF_CURRENT_MOVE_EFFECT_EQUAL_TO, MOVE_EFFECT_DAMAGE_WHILE_ASLEEP, 2118, // -> 12FA
    /* 0AB4 */ AI_IF_CURRENT_MOVE_EFFECT_EQUAL_TO, MOVE_EFFECT_NEXT_ATTACK_ALWAYS_HITS, 2118, // -> 12FD
    /* 0AB7 */ AI_IF_CURRENT_MOVE_EFFECT_EQUAL_TO, MOVE_EFFECT_USE_RANDOM_LEARNED_MOVE_SLEEP, 2121, // -> 1303
    /* 0ABA */ AI_IF_CURRENT_MOVE_EFFECT_EQUAL_TO, MOVE_EFFECT_KO_MON_THAT_DEFEATED_USER, 2125, // -> 130A
    /* 0ABD */ AI_IF_CURRENT_MOVE_EFFECT_EQUAL_TO, MOVE_EFFECT_INCREASE_POWER_WITH_LESS_HP, 2155, // -> 132B
    /* 0AC0 */ AI_IF_CURRENT_MOVE_EFFECT_EQUAL_TO, MOVE_EFFECT_CURE_PARTY_STATUS, 2191, // -> 1352
    /* 0AC3 */ AI_IF_CURRENT_MOVE_EFFECT_EQUAL_TO, MOVE_EFFECT_STEAL_HELD_ITEM, 2199, // -> 135D
    /* 0AC6 */ AI_IF_CURRENT_MOVE_EFFECT_EQUAL_TO, MOVE_EFFECT_PREVENT_ESCAPE, 1543, // -> 10D0
    /* 0AC9 */ AI_IF_CURRENT_MOVE_EFFECT_EQUAL_TO, MOVE_EFFECT_EVA_UP_2_MINIMIZE, 728, // -> 0DA4
    /* 0ACC */ AI_IF_CURRENT_MOVE_EFFECT_EQUAL_TO, MOVE_EFFECT_CURSE, 2231, // -> 1386
    /* 0ACF */ AI_IF_CURRENT_MOVE_EFFECT_EQUAL_TO, MOVE_EFFECT_PROTECT, 2292, // -> 13C6
    /* 0AD2 */ AI_IF_CURRENT_MOVE_EFFECT_EQUAL_TO, MOVE_EFFECT_SET_SPIKES, 2406, // -> 143B
    /* 0AD5 */ AI_IF_CURRENT_MOVE_EFFECT_EQUAL_TO, MOVE_EFFECT_IGNORE_EVASION_REMOVE_GHOST_IMMUNE, 2424, // -> 1450
    /* 0AD8 */ AI_IF_CURRENT_MOVE_EFFECT_EQUAL_TO, MOVE_EFFECT_SURVIVE_WITH_1_HP, 2449, // -> 146C
    /* 0ADB */ AI_IF_CURRENT_MOVE_EFFECT_EQUAL_TO, MOVE_EFFECT_PASS_STATS_AND_STATUS, 2464, // -> 147E
    /* 0ADE */ AI_IF_CURRENT_MOVE_EFFECT_EQUAL_TO, MOVE_EFFECT_HIT_BEFORE_SWITCH, 2551, // -> 14D8
    /* 0AE1 */ AI_IF_CURRENT_MOVE_EFFECT_EQUAL_TO, MOVE_EFFECT_HEAL_HALF_MORE_IN_SUN, 1313, // -> 1005
    /* 0AE4 */ AI_IF_CURRENT_MOVE_EFFECT_EQUAL_TO, MOVE_EFFECT_UNUSED_133, 1310, // -> 1005
    /* 0AE7 */ AI_IF_CURRENT_MOVE_EFFECT_EQUAL_TO, MOVE_EFFECT_UNUSED_134, 1307, // -> 1005
    /* 0AEA */ AI_IF_CURRENT_MOVE_EFFECT_EQUAL_TO, MOVE_EFFECT_WEATHER_RAIN, 2581, // -> 1502
    /* 0AED */ AI_IF_CURRENT_MOVE_EFFECT_EQUAL_TO, MOVE_EFFECT_WEATHER_SUN, 2621, // -> 152D
    /* 0AF0 */ AI_IF_CURRENT_MOVE_EFFECT_EQUAL_TO, MOVE_EFFECT_MAX_ATK_LOSE_HALF_MAX_HP, 2653, // -> 1550
    /* 0AF3 */ AI_IF_CURRENT_MOVE_EFFECT_EQUAL_TO, MOVE_EFFECT_COPY_STAT_CHANGES, 2659, // -> 1559
    /* 0AF6 */ AI_IF_CURRENT_MOVE_EFFECT_EQUAL_TO, MOVE_EFFECT_MIRROR_COAT, 2721, // -> 159A
    /* 0AF9 */ AI_IF_CURRENT_MOVE_EFFECT_EQUAL_TO, MOVE_EFFECT_CHARGE_TURN_DEF_UP, 2814, // -> 15FA
    /* 0AFC */ AI_IF_CURRENT_MOVE_EFFECT_EQUAL_TO, MOVE_EFFECT_151, 2811, // -> 15FA
    /* 0AFF */ AI_IF_CURRENT_MOVE_EFFECT_EQUAL_TO, MOVE_EFFECT_151, 2855, // -> 1629
    /* 0B02 */ AI_IF_CURRENT_MOVE_EFFECT_EQUAL_TO, MOVE_EFFECT_FLY, 2878, // -> 1643
    /* 0B05 */ AI_IF_CURRENT_MOVE_EFFECT_EQUAL_TO, MOVE_EFFECT_UNUSED_157, 1291, // -> 1013
    /* 0B08 */ AI_IF_CURRENT_MOVE_EFFECT_EQUAL_TO, MOVE_EFFECT_ALWAYS_FLINCH_FIRST_TURN_ONLY, 2972, // -> 16A7
    /* 0B0B */ AI_IF_CURRENT_MOVE_EFFECT_EQUAL_TO, MOVE_EFFECT_SPIT_UP, 2972, // -> 16AA
    /* 0B0E */ AI_IF_CURRENT_MOVE_EFFECT_EQUAL_TO, MOVE_EFFECT_SWALLOW, 1282, // -> 1013
    /* 0B11 */ AI_IF_CURRENT_MOVE_EFFECT_EQUAL_TO, MOVE_EFFECT_WEATHER_HAIL, 2977, // -> 16B5
    /* 0B14 */ AI_IF_CURRENT_MOVE_EFFECT_EQUAL_TO, MOVE_EFFECT_SP_ATK_UP_CAUSE_CONFUSION, 1517, // -> 1104
    /* 0B17 */ AI_IF_CURRENT_MOVE_EFFECT_EQUAL_TO, MOVE_EFFECT_FAINT_AND_ATK_SP_ATK_DOWN_2, 274, // -> 0C2C
    /* 0B1A */ AI_IF_CURRENT_MOVE_EFFECT_EQUAL_TO, MOVE_EFFECT_DOUBLE_POWER_WHEN_STATUSED, 3004, // -> 16D9
    /* 0B1D */ AI_IF_CURRENT_MOVE_EFFECT_EQUAL_TO, MOVE_EFFECT_HIT_LAST_WHIFF_IF_HIT, 3008, // -> 16E0
    /* 0B20 */ AI_IF_CURRENT_MOVE_EFFECT_EQUAL_TO, MOVE_EFFECT_DOUBLE_POWER_AND_CURE_PARALYSIS, 3052, // -> 170F
    /* 0B23 */ AI_IF_CURRENT_MOVE_EFFECT_EQUAL_TO, MOVE_EFFECT_SWITCH_HELD_ITEMS, 3058, // -> 1718
    /* 0B26 */ AI_IF_CURRENT_MOVE_EFFECT_EQUAL_TO, MOVE_EFFECT_COPY_ABILITY, 3361, // -> 184A
    /* 0B29 */ AI_IF_CURRENT_MOVE_EFFECT_EQUAL_TO, MOVE_EFFECT_GROUND_TRAP_USER_CONTINUOUS_HEAL, 3404, // -> 1878
    /* 0B2C */ AI_IF_CURRENT_MOVE_EFFECT_EQUAL_TO, 182, 3402, // -> 1879
    /* 0B2F */ AI_IF_CURRENT_MOVE_EFFECT_EQUAL_TO, 183, 3429, // -> 1897
    /* 0B32 */ AI_IF_CURRENT_MOVE_EFFECT_EQUAL_TO, 184, 3456, // -> 18B5
    /* 0B35 */ AI_IF_CURRENT_MOVE_EFFECT_EQUAL_TO, 185, 3472, // -> 18C8
    /* 0B38 */ AI_IF_CURRENT_MOVE_EFFECT_EQUAL_TO, MOVE_EFFECT_REMOVE_SCREENS, 3491, // -> 18DE
    /* 0B3B */ AI_IF_CURRENT_MOVE_EFFECT_EQUAL_TO, MOVE_EFFECT_REMOVE_HELD_ITEM, 3501, // -> 18EB
    /* 0B3E */ AI_IF_CURRENT_MOVE_EFFECT_EQUAL_TO, MOVE_EFFECT_SET_HP_EQUAL_TO_USER, 3513, // -> 18FA
    /* 0B41 */ AI_IF_CURRENT_MOVE_EFFECT_EQUAL_TO, MOVE_EFFECT_DECREASE_POWER_WITH_LESS_USER_HP, 3536, // -> 1914
    /* 0B44 */ AI_IF_CURRENT_MOVE_EFFECT_EQUAL_TO, MOVE_EFFECT_SWITCH_ABILITIES, 3331, // -> 184A
    /* 0B47 */ AI_IF_CURRENT_MOVE_EFFECT_EQUAL_TO, MOVE_EFFECT_MAKE_SHARED_MOVES_UNUSEABL, 3555, // -> 192D
    /* 0B4A */ AI_IF_CURRENT_MOVE_EFFECT_EQUAL_TO, MOVE_EFFECT_HEAL_STATUS, 3563, // -> 1938
    /* 0B4D */ AI_IF_CURRENT_MOVE_EFFECT_EQUAL_TO, MOVE_EFFECT_STEAL_STATUS_MOVE, 3569, // -> 1941
    /* 0B50 */ AI_IF_CURRENT_MOVE_EFFECT_EQUAL_TO, MOVE_EFFECT_RECOIL_THIRD, 5379, // -> 2056
    /* 0B53 */ AI_IF_CURRENT_MOVE_EFFECT_EQUAL_TO, MOVE_EFFECT_HIGH_CRITICAL_BURN_HIT, 1426, // -> 10E8
    /* 0B56 */ AI_IF_CURRENT_MOVE_EFFECT_EQUAL_TO, MOVE_EFFECT_HALVE_ELECTRIC_DAMAGE, 3618, // -> 197B
    /* 0B59 */ AI_IF_CURRENT_MOVE_EFFECT_EQUAL_TO, MOVE_EFFECT_USER_SP_ATK_DOWN_2, 3638, // -> 1992
    /* 0B5C */ AI_IF_CURRENT_MOVE_EFFECT_EQUAL_TO, MOVE_EFFECT_ATK_DEF_DOWN, 755, // -> 0E52
    /* 0B5F */ AI_IF_CURRENT_MOVE_EFFECT_EQUAL_TO, MOVE_EFFECT_DEF_SPD_UP, 500, // -> 0D56
    /* 0B62 */ AI_IF_CURRENT_MOVE_EFFECT_EQUAL_TO, MOVE_EFFECT_ATK_DEF_UP, 388, // -> 0CE9
    /* 0B65 */ AI_IF_CURRENT_MOVE_EFFECT_EQUAL_TO, MOVE_EFFECT_HIGH_CRITICAL_POISON_HIT, 1408, // -> 10E8
    /* 0B68 */ AI_IF_CURRENT_MOVE_EFFECT_EQUAL_TO, MOVE_EFFECT_HALVE_FIRE_DAMAGE, 3648, // -> 19AB
    /* 0B6B */ AI_IF_CURRENT_MOVE_EFFECT_EQUAL_TO, MOVE_EFFECT_SP_ATK_SP_DEF_UP, 488, // -> 0D56
    /* 0B6E */ AI_IF_CURRENT_MOVE_EFFECT_EQUAL_TO, MOVE_EFFECT_ATK_SPD_UP, 3665, // -> 19C2
    /* 0B71 */ AI_IF_CURRENT_MOVE_EFFECT_EQUAL_TO, MOVE_EFFECT_HEAL_HALF_REMOVE_FLYING_TYPE, 1183, // -> 1013
    /* 0B74 */ AI_IF_CURRENT_MOVE_EFFECT_EQUAL_TO, MOVE_EFFECT_GRAVITY, 3679, // -> 19D6
    /* 0B77 */ AI_IF_CURRENT_MOVE_EFFECT_EQUAL_TO, MOVE_EFFECT_IGNORE_EVATION_REMOVE_DARK_IMMUNE, 3710, // -> 19F8
    /* 0B7A */ AI_IF_CURRENT_MOVE_EFFECT_EQUAL_TO, MOVE_EFFECT_DOUBLE_POWER_HEAL_SLEEP, 3734, // -> 1A13
    /* 0B7D */ AI_IF_CURRENT_MOVE_EFFECT_EQUAL_TO, MOVE_EFFECT_SPEED_DOWN_HIT, 3753, // -> 1A29
    /* 0B80 */ AI_IF_CURRENT_MOVE_EFFECT_EQUAL_TO, MOVE_EFFECT_POWER_BASED_ON_LOW_SPEED, 3770, // -> 1A3D
    /* 0B83 */ AI_IF_CURRENT_MOVE_EFFECT_EQUAL_TO, MOVE_EFFECT_FAINT_AND_FULL_HEAL_NEXT_MON, 5350, // -> 206C
    /* 0B86 */ AI_IF_CURRENT_MOVE_EFFECT_EQUAL_TO, MOVE_EFFECT_DOUBLE_POWER_WHEN_BELOW_HALF, 3765, // -> 1A3E
    /* 0B89 */ AI_IF_CURRENT_MOVE_EFFECT_EQUAL_TO, MOVE_EFFECT_REMOVE_PROTECT, 3787, // -> 1A57
    /* 0B8C */ AI_IF_CURRENT_MOVE_EFFECT_EQUAL_TO, MOVE_EFFECT_EAT_BERRY, 3862, // -> 1AA5
    /* 0B8F */ AI_IF_CURRENT_MOVE_EFFECT_EQUAL_TO, MOVE_EFFECT_DOUBLE_SPEED_3_TURNS, 3888, // -> 1AC2
    /* 0B92 */ AI_IF_CURRENT_MOVE_EFFECT_EQUAL_TO, MOVE_EFFECT_RANDOM_STAT_UP_2, 3909, // -> 1ADA
    /* 0B95 */ AI_IF_CURRENT_MOVE_EFFECT_EQUAL_TO, MOVE_EFFECT_METAL_BURST, 3927, // -> 1AEF
    /* 0B98 */ AI_IF_CURRENT_MOVE_EFFECT_EQUAL_TO, MOVE_EFFECT_SWITCH_HIT, 3996, // -> 1B37
    /* 0B9B */ AI_IF_CURRENT_MOVE_EFFECT_EQUAL_TO, MOVE_EFFECT_DEF_SPD_DOWN_HIT, 4062, // -> 1B7C
    /* 0B9E */ AI_IF_CURRENT_MOVE_EFFECT_EQUAL_TO, MOVE_EFFECT_DOUBLE_POWER_IF_HIT, 4084, // -> 1B95
    /* 0BA1 */ AI_IF_CURRENT_MOVE_EFFECT_EQUAL_TO, MOVE_EFFECT_DOUBLE_POWER_IF_TARGET_HIT, 4106, // -> 1BAE
    /* 0BA4 */ AI_IF_CURRENT_MOVE_EFFECT_EQUAL_TO, MOVE_EFFECT_PREVENT_ITEM_USE, 4143, // -> 1BD6
    /* 0BA7 */ AI_IF_CURRENT_MOVE_EFFECT_EQUAL_TO, MOVE_EFFECT_FLING, 4146, // -> 1BDC
    /* 0BAA */ AI_IF_CURRENT_MOVE_EFFECT_EQUAL_TO, MOVE_EFFECT_TRANSFER_STATUS, 4210, // -> 1C1F
    /* 0BAD */ AI_IF_CURRENT_MOVE_EFFECT_EQUAL_TO, MOVE_EFFECT_HIGHER_POWER_WHEN_LOW_PP, 4221, // -> 1C2D
    /* 0BB0 */ AI_IF_CURRENT_MOVE_EFFECT_EQUAL_TO, MOVE_EFFECT_PREVENT_HEALING, 4285, // -> 1C70
    /* 0BB3 */ AI_IF_CURRENT_MOVE_EFFECT_EQUAL_TO, MOVE_EFFECT_INCREASE_POWER_WITH_MORE_HP, 4357, // -> 1CBB
    /* 0BB6 */ AI_IF_CURRENT_MOVE_EFFECT_EQUAL_TO, MOVE_EFFECT_SWAP_ATK_DEF, 4394, // -> 1CE3
    /* 0BB9 */ AI_IF_CURRENT_MOVE_EFFECT_EQUAL_TO, MOVE_EFFECT_SUPRESS_ABILITY, 4427, // -> 1D07
    /* 0BBC */ AI_IF_CURRENT_MOVE_EFFECT_EQUAL_TO, MOVE_EFFECT_PREVENT_CRITS, 4451, // -> 1D22
    /* 0BBF */ AI_IF_CURRENT_MOVE_EFFECT_EQUAL_TO, MOVE_EFFECT_USE_MOVE_FIRST, 4476, // -> 1D3E
    /* 0BC2 */ AI_IF_CURRENT_MOVE_EFFECT_EQUAL_TO, MOVE_EFFECT_USE_LAST_USED_MOVE, 4506, // -> 1D5F
    /* 0BC5 */ AI_IF_CURRENT_MOVE_EFFECT_EQUAL_TO, MOVE_EFFECT_SWAP_ATK_SP_ATK_STAT_CHANGES, 4592, // -> 1DB8
    /* 0BC8 */ AI_IF_CURRENT_MOVE_EFFECT_EQUAL_TO, MOVE_EFFECT_SWAP_DEF_SP_DEF_STAT_CHANGES, 4698, // -> 1E25
    /* 0BCB */ AI_IF_CURRENT_MOVE_EFFECT_EQUAL_TO, MOVE_EFFECT_INCREASE_POWER_WITH_MORE_STAT_UP, 4804, // -> 1E92
    /* 0BCE */ AI_IF_CURRENT_MOVE_EFFECT_EQUAL_TO, MOVE_EFFECT_FAIL_IF_NOT_USED_ALL_OTHER_MOVES, 4850, // -> 1EC3
    /* 0BD1 */ AI_IF_CURRENT_MOVE_EFFECT_EQUAL_TO, MOVE_EFFECT_SET_ABILITY_TO_INSOMNIA, 4868, // -> 1ED8
    /* 0BD4 */ AI_IF_CURRENT_MOVE_EFFECT_EQUAL_TO, MOVE_EFFECT_HIT_FIRST_IF_TARGET_ATTACKING, 4888, // -> 1EEF
    /* 0BD7 */ AI_IF_CURRENT_MOVE_EFFECT_EQUAL_TO, MOVE_EFFECT_TOXIC_SPIKES, 4904, // -> 1F02
    /* 0BDA */ AI_IF_CURRENT_MOVE_EFFECT_EQUAL_TO, MOVE_EFFECT_SWAP_STAT_CHANGES, 4922, // -> 1F17
    /* 0BDD */ AI_IF_CURRENT_MOVE_EFFECT_EQUAL_TO, MOVE_EFFECT_RESTORE_HP_EVERY_TURN, 4992, // -> 1F60
    /* 0BE0 */ AI_IF_CURRENT_MOVE_EFFECT_EQUAL_TO, MOVE_EFFECT_GIVE_GROUND_IMMUNITY, 4999, // -> 1F6A
    /* 0BE3 */ AI_IF_CURRENT_MOVE_EFFECT_EQUAL_TO, MOVE_EFFECT_RECOIL_BURN_HIT, 5232, // -> 2056
    /* 0BE6 */ AI_IF_CURRENT_MOVE_EFFECT_EQUAL_TO, MOVE_EFFECT_DIVE, 2650, // -> 1643
    /* 0BE9 */ AI_IF_CURRENT_MOVE_EFFECT_EQUAL_TO, MOVE_EFFECT_DIG, 2647, // -> 1643
    /* 0BEC */ AI_IF_CURRENT_MOVE_EFFECT_EQUAL_TO, MOVE_EFFECT_REMOVE_HAZARDS_SCREENS_EVA_DOWN, 5027, // -> 1F92
    /* 0BEF */ AI_IF_CURRENT_MOVE_EFFECT_EQUAL_TO, MOVE_EFFECT_TRICK_ROOM, 5108, // -> 1FE6
    /* 0BF2 */ AI_IF_CURRENT_MOVE_EFFECT_EQUAL_TO, MOVE_EFFECT_BLIZZARD, 5131, // -> 2000
    /* 0BF5 */ AI_IF_CURRENT_MOVE_EFFECT_EQUAL_TO, MOVE_EFFECT_RECOIL_PARALYZE_HIT, 5214, // -> 2056
    /* 0BF8 */ AI_IF_CURRENT_MOVE_EFFECT_EQUAL_TO, MOVE_EFFECT_BOUNCE, 2632, // -> 1643
    /* 0BFB */ AI_IF_CURRENT_MOVE_EFFECT_EQUAL_TO, MOVE_EFFECT_SP_ATK_DOWN_2_OPPOSITE_GENDER, 5146, // -> 2018
    /* 0BFE */ AI_IF_CURRENT_MOVE_EFFECT_EQUAL_TO, MOVE_EFFECT_STEALTH_ROCK, 5182, // -> 203F
    /* 0C01 */ AI_IF_CURRENT_MOVE_EFFECT_EQUAL_TO, MOVE_EFFECT_RECOIL_HALF, 5202, // -> 2056
    /* 0C04 */ AI_IF_CURRENT_MOVE_EFFECT_EQUAL_TO, MOVE_EFFECT_FAINT_FULL_RESTORE_NEXT_MON, 5221, // -> 206C
    /* 0C07 */ AI_IF_CURRENT_MOVE_EFFECT_EQUAL_TO, MOVE_EFFECT_SHADOW_FORCE, 2629, // -> 164F
    /* 0C0A */ AI_POP_OR_END,

    // 0C0B
    /* 0C0B */ AI_IF_MOVE_EFFECT_KNOWN, AI_BATTLER_ATTACKER, MOVE_EFFECT_RECOVER_DAMAGE_SLEEP, 6, // -> 0C15
    /* 0C0F */ AI_IF_MOVE_EFFECT_KNOWN, AI_BATTLER_ATTACKER, MOVE_EFFECT_STATUS_NIGHTMARE, 2, // -> 0C15
    /* 0C13 */ AI_GOTO, 5, // -> 0C1A

    // 0C15
    /* 0C15 */ AI_IF_RANDOM_LESS_THAN, 128, 2, // -> 0C1A
    /* 0C18 */ AI_ADD_TO_MOVE_SCORE, 1,

    // 0C1A
    /* 0C1A */ AI_POP_OR_END,

    // 0C1B
    /* 0C1B */ AI_IF_MOVE_EFFECTIVENESS_EQUALS, 0, 8, // -> 0C26
    /* 0C1E */ AI_IF_MOVE_EFFECTIVENESS_EQUALS, 20, 5, // -> 0C26
    /* 0C21 */ AI_IF_MOVE_EFFECTIVENESS_EQUALS, 10, 2, // -> 0C26
    /* 0C24 */ AI_GOTO, 5, // -> 0C2B

    // 0C26
    /* 0C26 */ AI_IF_RANDOM_LESS_THAN, 50, 2, // -> 0C2B
    /* 0C29 */ AI_ADD_TO_MOVE_SCORE, -3,

    // 0C2B
    /* 0C2B */ AI_POP_OR_END,

    // 0C2C
    /* 0C2C */ AI_IF_STAT_STAGE_LESS_THAN, AI_BATTLER_TARGET, 7, 7, 12, // -> 0C3D
    /* 0C31 */ AI_ADD_TO_MOVE_SCORE, -1,
    /* 0C33 */ AI_IF_STAT_STAGE_LESS_THAN, AI_BATTLER_TARGET, 7, 10, 5, // -> 0C3D
    /* 0C38 */ AI_IF_RANDOM_LESS_THAN, 128, 2, // -> 0C3D
    /* 0C3B */ AI_ADD_TO_MOVE_SCORE, -1,

    // 0C3D
    /* 0C3D */ AI_IF_HP_PERCENT_LESS_THAN, AI_BATTLER_ATTACKER, 80, 8, // -> 0C49
    /* 0C41 */ AI_IF_SPEED_COMPARE_EQUAL_TO, 1, 5, // -> 0C49
    /* 0C44 */ AI_IF_RANDOM_LESS_THAN, 50, 27, // -> 0C62
    /* 0C47 */ AI_GOTO, -635, // -> 09CE

    // 0C49
    /* 0C49 */ AI_IF_HP_PERCENT_GREATER_THAN, AI_BATTLER_ATTACKER, 50, 16, // -> 0C5D
    /* 0C4D */ AI_IF_RANDOM_LESS_THAN, 128, 2, // -> 0C52
    /* 0C50 */ AI_ADD_TO_MOVE_SCORE, 1,

    // 0C52
    /* 0C52 */ AI_IF_HP_PERCENT_GREATER_THAN, AI_BATTLER_ATTACKER, 30, 12, // -> 0C62
    /* 0C56 */ AI_IF_RANDOM_LESS_THAN, 50, 9, // -> 0C62
    /* 0C59 */ AI_ADD_TO_MOVE_SCORE, 1,
    /* 0C5B */ AI_GOTO, 5, // -> 0C62

    // 0C5D
    /* 0C5D */ AI_IF_RANDOM_LESS_THAN, 50, 2, // -> 0C62
    /* 0C60 */ AI_ADD_TO_MOVE_SCORE, -1,

    // 0C62
    /* 0C62 */ AI_POP_OR_END,

    // 0C63
    /* 0C63 */ AI_IF_MOVE_EFFECTIVENESS_EQUALS, 0, 19, // -> 0C79
    /* 0C66 */ AI_IF_MOVE_EFFECTIVENESS_EQUALS, 10, 16, // -> 0C79
    /* 0C69 */ AI_IF_MOVE_EFFECTIVENESS_EQUALS, 20, 13, // -> 0C79
    /* 0C6C */ AI_IF_STATUS, AI_BATTLER_TARGET, 0x7, 2, // -> 0C72
    /* 0C70 */ AI_GOTO, 9, // -> 0C7B

    // 0C72
    /* 0C72 */ AI_IF_RANDOM_LESS_THAN, 51, 6, // -> 0C7B
    /* 0C75 */ AI_ADD_TO_MOVE_SCORE, 3,
    /* 0C77 */ AI_GOTO, 2, // -> 0C7B

    // 0C79
    /* 0C79 */ AI_ADD_TO_MOVE_SCORE, -1,

    // 0C7B
    /* 0C7B */ AI_POP_OR_END,

    // 0C7C
    /* 0C7C */ AI_IF_SPEED_COMPARE_EQUAL_TO, 1, 12, // -> 0C8B
    /* 0C7F */ AI_LOAD_BATTLER_PREVIOUS_MOVE, AI_BATTLER_TARGET,
    /* 0C81 */ AI_IF_LOADED_NOT_IN_TABLE, 18, 7, // table 0C96, -> 0C8B
    /* 0C84 */ AI_IF_RANDOM_LESS_THAN, 128, 14, // -> 0C95
    /* 0C87 */ AI_ADD_TO_MOVE_SCORE, 2,
    /* 0C89 */ AI_GOTO, 10, // -> 0C95

    // 0C8B
    /* 0C8B */ AI_LOAD_BATTLER_PREVIOUS_MOVE, AI_BATTLER_TARGET,
    /* 0C8D */ AI_IF_LOADED_IN_TABLE, 6, 5, // table 0C96, -> 0C95
    /* 0C90 */ AI_IF_RANDOM_LESS_THAN, 80, 2, // -> 0C95
    /* 0C93 */ AI_ADD_TO_MOVE_SCORE, -1,

    // 0C95
    /* 0C95 */ AI_POP_OR_END,

    // 0C96
    /* 0C96 */ MOVE_SLEEP_POWDER, MOVE_LOVELY_KISS, MOVE_SPORE, MOVE_HYPNOSIS, MOVE_SING,
               MOVE_GRASS_WHISTLE, MOVE_SHADOW_PUNCH, MOVE_SAND_ATTACK, MOVE_SMOKE_SCREEN,
               MOVE_TOXIC, MOVE_GUILLOTINE, MOVE_HORN_DRILL, MOVE_FISSURE, MOVE_SHEER_COLD,
               MOVE_CROSS_CHOP, MOVE_AEROBLAST, MOVE_CONFUSE_RAY, MOVE_SWEET_KISS, MOVE_SCREECH,
               MOVE_COTTON_SPORE, MOVE_SCARY_FACE, MOVE_FAKE_TEARS, MOVE_METAL_SOUND,
               MOVE_THUNDER_WAVE, MOVE_GLARE, MOVE_POISON_POWDER, MOVE_SHADOW_BALL,
               MOVE_DYNAMIC_PUNCH, MOVE_HYPER_BEAM, MOVE_EXTREME_SPEED, MOVE_THIEF, MOVE_COVET,
               MOVE_ATTRACT, MOVE_SWAGGER, MOVE_TORMENT, MOVE_FLATTER, MOVE_TRICK, MOVE_SUPERPOWER,
               MOVE_SKILL_SWAP, MOVE_PSYCHO_SHIFT, MOVE_POWER_SWAP, MOVE_GUARD_SWAP,
               MOVE_SUCKER_PUNCH, MOVE_HEART_SWAP, MOVE_SWITCHEROO, MOVE_CAPTIVATE, MOVE_DARK_VOID,
               AI_TABLE_END,

    // 0CC6
    /* 0CC6 */ AI_IF_STAT_STAGE_LESS_THAN, AI_BATTLER_ATTACKER, 1, 9, 7, // -> 0CD2
    /* 0CCB */ AI_IF_RANDOM_LESS_THAN, 100, 13, // -> 0CDB
    /* 0CCE */ AI_ADD_TO_MOVE_SCORE, -1,
    /* 0CD0 */ AI_GOTO, 9, // -> 0CDB

    // 0CD2
    /* 0CD2 */ AI_IF_HP_PERCENT_NOT_EQUAL_TO, AI_BATTLER_ATTACKER, 100, 5, // -> 0CDB
    /* 0CD6 */ AI_IF_RANDOM_LESS_THAN, 128, 2, // -> 0CDB
    /* 0CD9 */ AI_ADD_TO_MOVE_SCORE, 2,

    // 0CDB
    /* 0CDB */ AI_IF_HP_PERCENT_GREATER_THAN, AI_BATTLER_ATTACKER, 70, 9, // -> 0CE8
    /* 0CDF */ AI_IF_HP_PERCENT_LESS_THAN, AI_BATTLER_ATTACKER, 40, 3, // -> 0CE6
    /* 0CE3 */ AI_IF_RANDOM_LESS_THAN, 40, 2, // -> 0CE8

    // 0CE6
    /* 0CE6 */ AI_ADD_TO_MOVE_SCORE, -2,

    // 0CE8
    /* 0CE8 */ AI_POP_OR_END,

    // 0CE9
    /* 0CE9 */ AI_IF_STAT_STAGE_LESS_THAN, AI_BATTLER_ATTACKER, 2, 9, 7, // -> 0CF5
    /* 0CEE */ AI_IF_RANDOM_LESS_THAN, 100, 13, // -> 0CFE
    /* 0CF1 */ AI_ADD_TO_MOVE_SCORE, -1,
    /* 0CF3 */ AI_GOTO, 9, // -> 0CFE

    // 0CF5
    /* 0CF5 */ AI_IF_HP_PERCENT_NOT_EQUAL_TO, AI_BATTLER_ATTACKER, 100, 5, // -> 0CFE
    /* 0CF9 */ AI_IF_RANDOM_LESS_THAN, 128, 2, // -> 0CFE
    /* 0CFC */ AI_ADD_TO_MOVE_SCORE, 2,

    // 0CFE
    /* 0CFE */ AI_IF_HP_PERCENT_LESS_THAN, AI_BATTLER_ATTACKER, 70, 3, // -> 0D05
    /* 0D02 */ AI_IF_RANDOM_LESS_THAN, 200, 22, // -> 0D1B

    // 0D05
    /* 0D05 */ AI_IF_HP_PERCENT_LESS_THAN, AI_BATTLER_ATTACKER, 40, 16, // -> 0D19
    /* 0D09 */ AI_LOAD_BATTLER_PREVIOUS_MOVE, AI_BATTLER_TARGET,
    /* 0D0B */ AI_LOAD_POWER_OF_LOADED_MOVE,
    /* 0D0C */ AI_IF_LOADED_EQUAL_TO, 0, 7, // -> 0D16
    /* 0D0F */ AI_LOAD_DEFENDER_LAST_USED_MOVE_CLASS,
    /* 0D10 */ AI_IF_LOADED_EQUAL_TO, 1, 6, // -> 0D19
    /* 0D13 */ AI_IF_RANDOM_LESS_THAN, 60, 5, // -> 0D1B

    // 0D16
    /* 0D16 */ AI_IF_RANDOM_LESS_THAN, 60, 2, // -> 0D1B

    // 0D19
    /* 0D19 */ AI_ADD_TO_MOVE_SCORE, -2,

    // 0D1B
    /* 0D1B */ AI_POP_OR_END,
    // 0D1C: a table no command refers to
    /* 0D1C */ 0, 1, 3, 4, 2, 5, 6, 7, 8, AI_TABLE_END,

    // 0D26
    /* 0D26 */ AI_IF_SPEED_COMPARE_EQUAL_TO, 1, 4, // -> 0D2D
    /* 0D29 */ AI_ADD_TO_MOVE_SCORE, -3,
    /* 0D2B */ AI_GOTO, 5, // -> 0D32

    // 0D2D
    /* 0D2D */ AI_IF_RANDOM_LESS_THAN, 70, 2, // -> 0D32
    /* 0D30 */ AI_ADD_TO_MOVE_SCORE, 3,

    // 0D32
    /* 0D32 */ AI_POP_OR_END,

    // 0D33
    /* 0D33 */ AI_IF_STAT_STAGE_LESS_THAN, AI_BATTLER_ATTACKER, 4, 9, 7, // -> 0D3F
    /* 0D38 */ AI_IF_RANDOM_LESS_THAN, 100, 13, // -> 0D48
    /* 0D3B */ AI_ADD_TO_MOVE_SCORE, -1,
    /* 0D3D */ AI_GOTO, 9, // -> 0D48

    // 0D3F
    /* 0D3F */ AI_IF_HP_PERCENT_NOT_EQUAL_TO, AI_BATTLER_ATTACKER, 100, 5, // -> 0D48
    /* 0D43 */ AI_IF_RANDOM_LESS_THAN, 128, 2, // -> 0D48
    /* 0D46 */ AI_ADD_TO_MOVE_SCORE, 2,

    // 0D48
    /* 0D48 */ AI_IF_HP_PERCENT_GREATER_THAN, AI_BATTLER_ATTACKER, 70, 9, // -> 0D55
    /* 0D4C */ AI_IF_HP_PERCENT_LESS_THAN, AI_BATTLER_ATTACKER, 40, 3, // -> 0D53
    /* 0D50 */ AI_IF_RANDOM_LESS_THAN, 70, 2, // -> 0D55

    // 0D53
    /* 0D53 */ AI_ADD_TO_MOVE_SCORE, -2,

    // 0D55
    /* 0D55 */ AI_POP_OR_END,

    // 0D56
    /* 0D56 */ AI_IF_STAT_STAGE_LESS_THAN, AI_BATTLER_ATTACKER, 5, 9, 7, // -> 0D62
    /* 0D5B */ AI_IF_RANDOM_LESS_THAN, 100, 13, // -> 0D6B
    /* 0D5E */ AI_ADD_TO_MOVE_SCORE, -1,
    /* 0D60 */ AI_GOTO, 9, // -> 0D6B

    // 0D62
    /* 0D62 */ AI_IF_HP_PERCENT_NOT_EQUAL_TO, AI_BATTLER_ATTACKER, 100, 5, // -> 0D6B
    /* 0D66 */ AI_IF_RANDOM_LESS_THAN, 128, 2, // -> 0D6B
    /* 0D69 */ AI_ADD_TO_MOVE_SCORE, 2,

    // 0D6B
    /* 0D6B */ AI_IF_HP_PERCENT_LESS_THAN, AI_BATTLER_ATTACKER, 70, 3, // -> 0D72
    /* 0D6F */ AI_IF_RANDOM_LESS_THAN, 200, 22, // -> 0D88

    // 0D72
    /* 0D72 */ AI_IF_HP_PERCENT_LESS_THAN, AI_BATTLER_ATTACKER, 40, 16, // -> 0D86
    /* 0D76 */ AI_LOAD_BATTLER_PREVIOUS_MOVE, AI_BATTLER_TARGET,
    /* 0D78 */ AI_LOAD_POWER_OF_LOADED_MOVE,
    /* 0D79 */ AI_IF_LOADED_EQUAL_TO, 0, 7, // -> 0D83
    /* 0D7C */ AI_LOAD_DEFENDER_LAST_USED_MOVE_CLASS,
    /* 0D7D */ AI_IF_LOADED_EQUAL_TO, 0, 6, // -> 0D86
    /* 0D80 */ AI_IF_RANDOM_LESS_THAN, 60, 5, // -> 0D88

    // 0D83
    /* 0D83 */ AI_IF_RANDOM_LESS_THAN, 60, 2, // -> 0D88

    // 0D86
    /* 0D86 */ AI_ADD_TO_MOVE_SCORE, -2,

    // 0D88
    /* 0D88 */ AI_POP_OR_END,
    // 0D89: a table no command refers to
    /* 0D89 */ 0, 1, 3, 4, 2, 5, 6, 7, 8, AI_TABLE_END,

    // 0D93
    /* 0D93 */ AI_IF_STAT_STAGE_LESS_THAN, AI_BATTLER_ATTACKER, 6, 9, 5, // -> 0D9D
    /* 0D98 */ AI_IF_RANDOM_LESS_THAN, 50, 2, // -> 0D9D
    /* 0D9B */ AI_ADD_TO_MOVE_SCORE, -2,

    // 0D9D
    /* 0D9D */ AI_IF_HP_PERCENT_GREATER_THAN, AI_BATTLER_ATTACKER, 70, 2, // -> 0DA3
    /* 0DA1 */ AI_ADD_TO_MOVE_SCORE, -2,

    // 0DA3
    /* 0DA3 */ AI_POP_OR_END,

    // 0DA4
    /* 0DA4 */ AI_IF_HP_PERCENT_LESS_THAN, AI_BATTLER_ATTACKER, 90, 5, // -> 0DAD
    /* 0DA8 */ AI_IF_RANDOM_LESS_THAN, 100, 2, // -> 0DAD
    /* 0DAB */ AI_ADD_TO_MOVE_SCORE, 3,

    // 0DAD
    /* 0DAD */ AI_IF_STAT_STAGE_LESS_THAN, AI_BATTLER_ATTACKER, 7, 9, 5, // -> 0DB7
    /* 0DB2 */ AI_IF_RANDOM_LESS_THAN, 128, 2, // -> 0DB7
    /* 0DB5 */ AI_ADD_TO_MOVE_SCORE, -1,

    // 0DB7
    /* 0DB7 */ AI_IF_NOT_STATUS, AI_BATTLER_TARGET, 0x80, 12, // -> 0DC7
    /* 0DBB */ AI_IF_HP_PERCENT_GREATER_THAN, AI_BATTLER_ATTACKER, 50, 3, // -> 0DC2
    /* 0DBF */ AI_IF_RANDOM_LESS_THAN, 80, 5, // -> 0DC7

    // 0DC2
    /* 0DC2 */ AI_IF_RANDOM_LESS_THAN, 50, 2, // -> 0DC7
    /* 0DC5 */ AI_ADD_TO_MOVE_SCORE, 3,

    // 0DC7
    /* 0DC7 */ AI_IF_NOT_MOVE_EFFECT_FLAG, AI_BATTLER_TARGET, 0x4, 5, // -> 0DD0
    /* 0DCB */ AI_IF_RANDOM_LESS_THAN, 70, 2, // -> 0DD0
    /* 0DCE */ AI_ADD_TO_MOVE_SCORE, 3,

    // 0DD0
    /* 0DD0 */ AI_IF_NOT_MOVE_EFFECT_FLAG, AI_BATTLER_ATTACKER, 0x400, 7, // -> 0DDB
    /* 0DD4 */ AI_IF_RANDOM_LESS_THAN, 128, 15, // -> 0DE6
    /* 0DD7 */ AI_ADD_TO_MOVE_SCORE, 2,
    /* 0DD9 */ AI_GOTO, 11, // -> 0DE6

    // 0DDB
    /* 0DDB */ AI_IF_NOT_MOVE_EFFECT_FLAG, AI_BATTLER_ATTACKER, 0x1000000, 7, // -> 0DE6
    /* 0DDF */ AI_IF_RANDOM_LESS_THAN, 128, 4, // -> 0DE6
    /* 0DE2 */ AI_ADD_TO_MOVE_SCORE, 2,
    /* 0DE4 */ AI_GOTO, 0, // -> 0DE6

    // 0DE6
    /* 0DE6 */ AI_IF_NOT_VOLATILE_STATUS, AI_BATTLER_TARGET, 0x10000000, 5, // -> 0DEF
    /* 0DEA */ AI_IF_RANDOM_LESS_THAN, 70, 2, // -> 0DEF
    /* 0DED */ AI_ADD_TO_MOVE_SCORE, 3,

    // 0DEF
    /* 0DEF */ AI_IF_HP_PERCENT_GREATER_THAN, AI_BATTLER_ATTACKER, 70, 18, // -> 0E05
    /* 0DF3 */ AI_IF_STAT_STAGE_EQUAL_TO, AI_BATTLER_ATTACKER, 7, 6, 13, // -> 0E05
    /* 0DF8 */ AI_IF_HP_PERCENT_LESS_THAN, AI_BATTLER_ATTACKER, 40, 7, // -> 0E03
    /* 0DFC */ AI_IF_HP_PERCENT_LESS_THAN, AI_BATTLER_TARGET, 40, 3, // -> 0E03
    /* 0E00 */ AI_IF_RANDOM_LESS_THAN, 70, 2, // -> 0E05

    // 0E03
    /* 0E03 */ AI_ADD_TO_MOVE_SCORE, -2,

    // 0E05
    /* 0E05 */ AI_POP_OR_END,

    // 0E06
    /* 0E06 */ AI_IF_STAT_STAGE_GREATER_THAN, AI_BATTLER_TARGET, 7, 10, 17, // -> 0E1C
    /* 0E0B */ AI_IF_STAT_STAGE_LESS_THAN, AI_BATTLER_ATTACKER, 6, 2, 12, // -> 0E1C
    /* 0E10 */ AI_IF_STAT_STAGE_GREATER_THAN, AI_BATTLER_TARGET, 7, 8, 9, // -> 0E1E
    /* 0E15 */ AI_IF_STAT_STAGE_LESS_THAN, AI_BATTLER_ATTACKER, 6, 4, 4, // -> 0E1E
    /* 0E1A */ AI_GOTO, 7, // -> 0E23

    // 0E1C
    /* 0E1C */ AI_ADD_TO_MOVE_SCORE, 1,

    // 0E1E
    /* 0E1E */ AI_IF_RANDOM_LESS_THAN, 100, 2, // -> 0E23
    /* 0E21 */ AI_ADD_TO_MOVE_SCORE, 1,

    // 0E23
    /* 0E23 */ AI_POP_OR_END,

    // 0E24
    /* 0E24 */ AI_IF_STAT_STAGE_EQUAL_TO, AI_BATTLER_TARGET, 1, 6, 18, // -> 0E3B
    /* 0E29 */ AI_ADD_TO_MOVE_SCORE, -1,
    /* 0E2B */ AI_IF_HP_PERCENT_GREATER_THAN, AI_BATTLER_ATTACKER, 90, 2, // -> 0E31
    /* 0E2F */ AI_ADD_TO_MOVE_SCORE, -1,

    // 0E31
    /* 0E31 */ AI_IF_STAT_STAGE_GREATER_THAN, AI_BATTLER_TARGET, 1, 3, 5, // -> 0E3B
    /* 0E36 */ AI_IF_RANDOM_LESS_THAN, 50, 2, // -> 0E3B
    /* 0E39 */ AI_ADD_TO_MOVE_SCORE, -2,

    // 0E3B
    /* 0E3B */ AI_IF_HP_PERCENT_GREATER_THAN, AI_BATTLER_TARGET, 70, 2, // -> 0E41
    /* 0E3F */ AI_ADD_TO_MOVE_SCORE, -2,

    // 0E41
    /* 0E41 */ AI_LOAD_DEFENDER_LAST_USED_MOVE_CLASS,
    /* 0E42 */ AI_IF_LOADED_NOT_EQUAL_TO, 1, 5, // -> 0E4A
    /* 0E45 */ AI_IF_RANDOM_LESS_THAN, 128, 2, // -> 0E4A
    /* 0E48 */ AI_ADD_TO_MOVE_SCORE, -2,

    // 0E4A
    /* 0E4A */ AI_POP_OR_END,
    // 0E4B: a table no command refers to
    /* 0E4B */ 0, 1, 4, 5, 6, 8, AI_TABLE_END,

    // 0E52
    /* 0E52 */ AI_IF_HP_PERCENT_LESS_THAN, AI_BATTLER_ATTACKER, 70, 5, // -> 0E5B
    /* 0E56 */ AI_IF_STAT_STAGE_GREATER_THAN, AI_BATTLER_TARGET, 2, 3, 5, // -> 0E60

    // 0E5B
    /* 0E5B */ AI_IF_RANDOM_LESS_THAN, 50, 2, // -> 0E60
    /* 0E5E */ AI_ADD_TO_MOVE_SCORE, -2,

    // 0E60
    /* 0E60 */ AI_IF_HP_PERCENT_GREATER_THAN, AI_BATTLER_TARGET, 70, 2, // -> 0E66
    /* 0E64 */ AI_ADD_TO_MOVE_SCORE, -2,

    // 0E66
    /* 0E66 */ AI_POP_OR_END,

    // 0E67
    /* 0E67 */ AI_IF_MOVE_EFFECTIVENESS_EQUALS, 0, 16, // -> 0E7A
    /* 0E6A */ AI_IF_MOVE_EFFECTIVENESS_EQUALS, 10, 13, // -> 0E7A
    /* 0E6D */ AI_IF_MOVE_EFFECTIVENESS_EQUALS, 20, 10, // -> 0E7A
    /* 0E70 */ AI_IF_MOVE_EQUAL_TO, MOVE_ICY_WIND, 8, // -> 0E7B
    /* 0E73 */ AI_IF_MOVE_EQUAL_TO, MOVE_ROCK_TOMB, 5, // -> 0E7B
    /* 0E76 */ AI_IF_MOVE_EQUAL_TO, MOVE_MUD_SHOT, 2, // -> 0E7B
    /* 0E79 */ AI_POP_OR_END,

    // 0E7A
    /* 0E7A */ AI_POP_OR_END,

    // 0E7B
    /* 0E7B */ AI_IF_SPEED_COMPARE_EQUAL_TO, 1, 4, // -> 0E82
    /* 0E7E */ AI_ADD_TO_MOVE_SCORE, -3,
    /* 0E80 */ AI_GOTO, 5, // -> 0E87

    // 0E82
    /* 0E82 */ AI_IF_RANDOM_LESS_THAN, 70, 2, // -> 0E87
    /* 0E85 */ AI_ADD_TO_MOVE_SCORE, 2,

    // 0E87
    /* 0E87 */ AI_POP_OR_END,

    // 0E88
    /* 0E88 */ AI_IF_STAT_STAGE_EQUAL_TO, AI_BATTLER_TARGET, 4, 6, 18, // -> 0E9F
    /* 0E8D */ AI_ADD_TO_MOVE_SCORE, -1,
    /* 0E8F */ AI_IF_HP_PERCENT_GREATER_THAN, AI_BATTLER_ATTACKER, 90, 2, // -> 0E95
    /* 0E93 */ AI_ADD_TO_MOVE_SCORE, -1,

    // 0E95
    /* 0E95 */ AI_IF_STAT_STAGE_GREATER_THAN, AI_BATTLER_TARGET, 4, 3, 5, // -> 0E9F
    /* 0E9A */ AI_IF_RANDOM_LESS_THAN, 50, 2, // -> 0E9F
    /* 0E9D */ AI_ADD_TO_MOVE_SCORE, -2,

    // 0E9F
    /* 0E9F */ AI_IF_HP_PERCENT_GREATER_THAN, AI_BATTLER_TARGET, 70, 2, // -> 0EA5
    /* 0EA3 */ AI_ADD_TO_MOVE_SCORE, -2,

    // 0EA5
    /* 0EA5 */ AI_LOAD_DEFENDER_LAST_USED_MOVE_CLASS,
    /* 0EA6 */ AI_IF_LOADED_NOT_EQUAL_TO, 0, 5, // -> 0EAE
    /* 0EA9 */ AI_IF_RANDOM_LESS_THAN, 128, 2, // -> 0EAE
    /* 0EAC */ AI_ADD_TO_MOVE_SCORE, -2,

    // 0EAE
    /* 0EAE */ AI_POP_OR_END,
    // 0EAF: a table no command refers to
    /* 0EAF */ 10, 11, 12, 13, 14, 15, 16, 17, AI_TABLE_END,

    // 0EB8
    /* 0EB8 */ AI_IF_HP_PERCENT_LESS_THAN, AI_BATTLER_ATTACKER, 70, 5, // -> 0EC1
    /* 0EBC */ AI_IF_STAT_STAGE_GREATER_THAN, AI_BATTLER_TARGET, 5, 3, 5, // -> 0EC6

    // 0EC1
    /* 0EC1 */ AI_IF_RANDOM_LESS_THAN, 50, 2, // -> 0EC6
    /* 0EC4 */ AI_ADD_TO_MOVE_SCORE, -2,

    // 0EC6
    /* 0EC6 */ AI_IF_HP_PERCENT_GREATER_THAN, AI_BATTLER_TARGET, 70, 2, // -> 0ECC
    /* 0ECA */ AI_ADD_TO_MOVE_SCORE, -2,

    // 0ECC
    /* 0ECC */ AI_POP_OR_END,

    // 0ECD
    /* 0ECD */ AI_IF_HP_PERCENT_LESS_THAN, AI_BATTLER_ATTACKER, 70, 4, // -> 0ED5
    /* 0ED1 */ AI_IF_HP_PERCENT_GREATER_THAN, AI_BATTLER_TARGET, 70, 5, // -> 0EDA

    // 0ED5
    /* 0ED5 */ AI_IF_RANDOM_LESS_THAN, 100, 2, // -> 0EDA
    /* 0ED8 */ AI_ADD_TO_MOVE_SCORE, -1,

    // 0EDA
    /* 0EDA */ AI_IF_STAT_STAGE_GREATER_THAN, AI_BATTLER_ATTACKER, 6, 4, 5, // -> 0EE4
    /* 0EDF */ AI_IF_RANDOM_LESS_THAN, 80, 2, // -> 0EE4
    /* 0EE2 */ AI_ADD_TO_MOVE_SCORE, -2,

    // 0EE4
    /* 0EE4 */ AI_IF_NOT_STATUS, AI_BATTLER_TARGET, 0x80, 5, // -> 0EED
    /* 0EE8 */ AI_IF_RANDOM_LESS_THAN, 70, 2, // -> 0EED
    /* 0EEB */ AI_ADD_TO_MOVE_SCORE, 2,

    // 0EED
    /* 0EED */ AI_IF_NOT_MOVE_EFFECT_FLAG, AI_BATTLER_TARGET, 0x4, 5, // -> 0EF6
    /* 0EF1 */ AI_IF_RANDOM_LESS_THAN, 70, 2, // -> 0EF6
    /* 0EF4 */ AI_ADD_TO_MOVE_SCORE, 2,

    // 0EF6
    /* 0EF6 */ AI_IF_NOT_MOVE_EFFECT_FLAG, AI_BATTLER_ATTACKER, 0x400, 7, // -> 0F01
    /* 0EFA */ AI_IF_RANDOM_LESS_THAN, 128, 13, // -> 0F0A
    /* 0EFD */ AI_ADD_TO_MOVE_SCORE, 1,
    /* 0EFF */ AI_GOTO, 9, // -> 0F0A

    // 0F01
    /* 0F01 */ AI_IF_NOT_MOVE_EFFECT_FLAG, AI_BATTLER_ATTACKER, 0x1000000, 5, // -> 0F0A
    /* 0F05 */ AI_IF_RANDOM_LESS_THAN, 128, 2, // -> 0F0A
    /* 0F08 */ AI_ADD_TO_MOVE_SCORE, 1,

    // 0F0A
    /* 0F0A */ AI_IF_NOT_VOLATILE_STATUS, AI_BATTLER_TARGET, 0x10000000, 5, // -> 0F13
    /* 0F0E */ AI_IF_RANDOM_LESS_THAN, 70, 2, // -> 0F13
    /* 0F11 */ AI_ADD_TO_MOVE_SCORE, 2,

    // 0F13
    /* 0F13 */ AI_IF_HP_PERCENT_GREATER_THAN, AI_BATTLER_ATTACKER, 70, 18, // -> 0F29
    /* 0F17 */ AI_IF_STAT_STAGE_EQUAL_TO, AI_BATTLER_TARGET, 6, 6, 13, // -> 0F29
    /* 0F1C */ AI_IF_HP_PERCENT_LESS_THAN, AI_BATTLER_ATTACKER, 40, 7, // -> 0F27
    /* 0F20 */ AI_IF_HP_PERCENT_LESS_THAN, AI_BATTLER_TARGET, 40, 3, // -> 0F27
    /* 0F24 */ AI_IF_RANDOM_LESS_THAN, 70, 2, // -> 0F29

    // 0F27
    /* 0F27 */ AI_ADD_TO_MOVE_SCORE, -2,

    // 0F29
    /* 0F29 */ AI_POP_OR_END,

    // 0F2A
    /* 0F2A */ AI_IF_HP_PERCENT_LESS_THAN, AI_BATTLER_ATTACKER, 70, 5, // -> 0F33
    /* 0F2E */ AI_IF_STAT_STAGE_GREATER_THAN, AI_BATTLER_TARGET, 7, 3, 5, // -> 0F38

    // 0F33
    /* 0F33 */ AI_IF_RANDOM_LESS_THAN, 50, 2, // -> 0F38
    /* 0F36 */ AI_ADD_TO_MOVE_SCORE, -2,

    // 0F38
    /* 0F38 */ AI_IF_HP_PERCENT_GREATER_THAN, AI_BATTLER_TARGET, 70, 2, // -> 0F3E
    /* 0F3C */ AI_ADD_TO_MOVE_SCORE, -2,

    // 0F3E
    /* 0F3E */ AI_POP_OR_END,

    // 0F3F
    /* 0F3F */ AI_IF_STAT_STAGE_GREATER_THAN, AI_BATTLER_ATTACKER, 1, 8, 47, // -> 0F73
    /* 0F44 */ AI_IF_STAT_STAGE_GREATER_THAN, AI_BATTLER_ATTACKER, 2, 8, 42, // -> 0F73
    /* 0F49 */ AI_IF_STAT_STAGE_GREATER_THAN, AI_BATTLER_ATTACKER, 4, 8, 37, // -> 0F73
    /* 0F4E */ AI_IF_STAT_STAGE_GREATER_THAN, AI_BATTLER_ATTACKER, 5, 8, 32, // -> 0F73
    /* 0F53 */ AI_IF_STAT_STAGE_GREATER_THAN, AI_BATTLER_ATTACKER, 7, 8, 27, // -> 0F73
    /* 0F58 */ AI_IF_STAT_STAGE_LESS_THAN, AI_BATTLER_TARGET, 1, 4, 22, // -> 0F73
    /* 0F5D */ AI_IF_STAT_STAGE_LESS_THAN, AI_BATTLER_TARGET, 2, 4, 17, // -> 0F73
    /* 0F62 */ AI_IF_STAT_STAGE_LESS_THAN, AI_BATTLER_TARGET, 4, 4, 12, // -> 0F73
    /* 0F67 */ AI_IF_STAT_STAGE_LESS_THAN, AI_BATTLER_TARGET, 5, 4, 7, // -> 0F73
    /* 0F6C */ AI_IF_STAT_STAGE_LESS_THAN, AI_BATTLER_TARGET, 6, 4, 2, // -> 0F73
    /* 0F71 */ AI_GOTO, 5, // -> 0F78

    // 0F73
    /* 0F73 */ AI_IF_RANDOM_LESS_THAN, 50, 2, // -> 0F78
    /* 0F76 */ AI_ADD_TO_MOVE_SCORE, -3,

    // 0F78
    /* 0F78 */ AI_IF_STAT_STAGE_GREATER_THAN, AI_BATTLER_TARGET, 1, 8, 52, // -> 0FB1
    /* 0F7D */ AI_IF_STAT_STAGE_GREATER_THAN, AI_BATTLER_TARGET, 2, 8, 47, // -> 0FB1
    /* 0F82 */ AI_IF_STAT_STAGE_GREATER_THAN, AI_BATTLER_TARGET, 4, 8, 42, // -> 0FB1
    /* 0F87 */ AI_IF_STAT_STAGE_GREATER_THAN, AI_BATTLER_TARGET, 5, 8, 37, // -> 0FB1
    /* 0F8C */ AI_IF_STAT_STAGE_GREATER_THAN, AI_BATTLER_TARGET, 7, 8, 32, // -> 0FB1
    /* 0F91 */ AI_IF_STAT_STAGE_LESS_THAN, AI_BATTLER_ATTACKER, 1, 4, 27, // -> 0FB1
    /* 0F96 */ AI_IF_STAT_STAGE_LESS_THAN, AI_BATTLER_ATTACKER, 2, 4, 22, // -> 0FB1
    /* 0F9B */ AI_IF_STAT_STAGE_LESS_THAN, AI_BATTLER_ATTACKER, 4, 4, 17, // -> 0FB1
    /* 0FA0 */ AI_IF_STAT_STAGE_LESS_THAN, AI_BATTLER_ATTACKER, 5, 4, 12, // -> 0FB1
    /* 0FA5 */ AI_IF_STAT_STAGE_LESS_THAN, AI_BATTLER_ATTACKER, 6, 4, 7, // -> 0FB1
    /* 0FAA */ AI_IF_RANDOM_LESS_THAN, 50, 9, // -> 0FB6
    /* 0FAD */ AI_ADD_TO_MOVE_SCORE, -1,
    /* 0FAF */ AI_GOTO, 5, // -> 0FB6

    // 0FB1
    /* 0FB1 */ AI_IF_RANDOM_LESS_THAN, 50, 2, // -> 0FB6
    /* 0FB4 */ AI_ADD_TO_MOVE_SCORE, 3,

    // 0FB6
    /* 0FB6 */ AI_POP_OR_END,

    // 0FB7
    /* 0FB7 */ AI_IF_HP_PERCENT_GREATER_THAN, AI_BATTLER_ATTACKER, 90, 2, // -> 0FBD
    /* 0FBB */ AI_ADD_TO_MOVE_SCORE, -2,

    // 0FBD
    /* 0FBD */ AI_POP_OR_END,

    // 0FBE
    /* 0FBE */ AI_LOAD_BATTLER_TURN_COUNT, AI_BATTLER_TARGET,
    /* 0FC0 */ AI_IF_LOADED_GREATER_THAN, 3, 41, // -> 0FEC
    /* 0FC3 */ AI_IF_SIDE_CONDITION, AI_BATTLER_TARGET, 0x4, 42, // -> 0FF1
    /* 0FC7 */ AI_IF_SIDE_CONDITION, AI_BATTLER_TARGET, 0x80, 38, // -> 0FF1
    /* 0FCB */ AI_IF_SIDE_CONDITION, AI_BATTLER_TARGET, 0x400, 34, // -> 0FF1
    /* 0FCF */ AI_IF_STAT_STAGE_GREATER_THAN, AI_BATTLER_TARGET, 1, 8, 29, // -> 0FF1
    /* 0FD4 */ AI_IF_STAT_STAGE_GREATER_THAN, AI_BATTLER_TARGET, 2, 8, 24, // -> 0FF1
    /* 0FD9 */ AI_IF_STAT_STAGE_GREATER_THAN, AI_BATTLER_TARGET, 4, 8, 19, // -> 0FF1
    /* 0FDE */ AI_IF_STAT_STAGE_GREATER_THAN, AI_BATTLER_TARGET, 5, 8, 14, // -> 0FF1
    /* 0FE3 */ AI_IF_STAT_STAGE_GREATER_THAN, AI_BATTLER_TARGET, 7, 8, 9, // -> 0FF1
    /* 0FE8 */ AI_ADD_TO_MOVE_SCORE, -3,
    /* 0FEA */ AI_GOTO, 10, // -> 0FF6

    // 0FEC
    /* 0FEC */ AI_IF_RANDOM_LESS_THAN, 64, 2, // -> 0FF1
    /* 0FEF */ AI_ADD_TO_MOVE_SCORE, 2,

    // 0FF1
    /* 0FF1 */ AI_IF_RANDOM_LESS_THAN, 128, 2, // -> 0FF6
    /* 0FF4 */ AI_ADD_TO_MOVE_SCORE, 2,

    // 0FF6
    /* 0FF6 */ AI_POP_OR_END,

    // 0FF7
    /* 0FF7 */ AI_IF_HP_PERCENT_GREATER_THAN, AI_BATTLER_ATTACKER, 90, 2, // -> 0FFD
    /* 0FFB */ AI_ADD_TO_MOVE_SCORE, -2,

    // 0FFD
    /* 0FFD */ AI_LOAD_TURN_COUNT,
    /* 0FFE */ AI_IF_LOADED_EQUAL_TO, 0, 3, // -> 1004
    /* 1001 */ AI_IF_RANDOM_LESS_THAN, 200, -1593, // -> 09CB

    // 1004
    /* 1004 */ AI_POP_OR_END,

    // 1005
    /* 1005 */ AI_LOAD_CURRENT_WEATHER,
    /* 1006 */ AI_IF_LOADED_EQUAL_TO, 4, 8, // -> 1011
    /* 1009 */ AI_IF_LOADED_EQUAL_TO, 2, 5, // -> 1011
    /* 100C */ AI_IF_LOADED_EQUAL_TO, 3, 2, // -> 1011
    /* 100F */ AI_GOTO, 2, // -> 1013

    // 1011
    /* 1011 */ AI_ADD_TO_MOVE_SCORE, -2,

    // 1013
    /* 1013 */ AI_IF_HP_PERCENT_EQUAL_TO, AI_BATTLER_ATTACKER, 100, 18, // -> 1029
    /* 1017 */ AI_IF_SPEED_COMPARE_EQUAL_TO, 1, 19, // -> 102D
    /* 101A */ AI_ADD_TO_MOVE_SCORE, -8,
    /* 101C */ AI_GOTO, 38, // -> 1044
    // 101E: not reached
    /* 101E */ AI_IF_HP_PERCENT_LESS_THAN, AI_BATTLER_ATTACKER, 50, 22, // -> 1038
    /* 1022 */ AI_IF_HP_PERCENT_GREATER_THAN, AI_BATTLER_ATTACKER, 80, 3, // -> 1029
    /* 1026 */ AI_IF_RANDOM_LESS_THAN, 70, 15, // -> 1038

    // 1029
    /* 1029 */ AI_ADD_TO_MOVE_SCORE, -3,
    /* 102B */ AI_GOTO, 23, // -> 1044

    // 102D
    /* 102D */ AI_IF_HP_PERCENT_LESS_THAN, AI_BATTLER_ATTACKER, 70, 7, // -> 1038
    /* 1031 */ AI_IF_RANDOM_LESS_THAN, 30, 4, // -> 1038
    /* 1034 */ AI_ADD_TO_MOVE_SCORE, -3,
    /* 1036 */ AI_GOTO, 12, // -> 1044

    // 1038
    /* 1038 */ AI_IF_MOVE_EFFECT_NOT_KNOWN, AI_BATTLER_TARGET, MOVE_EFFECT_STEAL_STATUS_MOVE, 3, // -> 103F
    /* 103C */ AI_IF_RANDOM_LESS_THAN, 100, 5, // -> 1044

    // 103F
    /* 103F */ AI_IF_RANDOM_LESS_THAN, 20, 2, // -> 1044
    /* 1042 */ AI_ADD_TO_MOVE_SCORE, 2,

    // 1044
    /* 1044 */ AI_POP_OR_END,

    // 1045
    /* 1045 */ AI_IF_ATTACKER_HAS_NO_DAMAGING_MOVES, 18, // -> 1059
    /* 1047 */ AI_IF_HP_PERCENT_GREATER_THAN, AI_BATTLER_ATTACKER, 50, 5, // -> 1050
    /* 104B */ AI_IF_RANDOM_LESS_THAN, 50, 2, // -> 1050
    /* 104E */ AI_ADD_TO_MOVE_SCORE, -3,

    // 1050
    /* 1050 */ AI_IF_HP_PERCENT_GREATER_THAN, AI_BATTLER_TARGET, 50, 5, // -> 1059
    /* 1054 */ AI_IF_RANDOM_LESS_THAN, 50, 2, // -> 1059
    /* 1057 */ AI_ADD_TO_MOVE_SCORE, -3,

    // 1059
    /* 1059 */ AI_IF_MOVE_EFFECT_KNOWN, AI_BATTLER_ATTACKER, MOVE_EFFECT_SP_DEF_UP, 6, // -> 1063
    /* 105D */ AI_IF_MOVE_EFFECT_KNOWN, AI_BATTLER_ATTACKER, MOVE_EFFECT_PROTECT, 2, // -> 1063
    /* 1061 */ AI_GOTO, 5, // -> 1068

    // 1063
    /* 1063 */ AI_IF_RANDOM_LESS_THAN, 60, 2, // -> 1068
    /* 1066 */ AI_ADD_TO_MOVE_SCORE, 2,

    // 1068
    /* 1068 */ AI_POP_OR_END,

    // 1069
    /* 1069 */ AI_IF_HP_PERCENT_LESS_THAN, AI_BATTLER_ATTACKER, 50, 20, // -> 1081
    /* 106D */ AI_IF_HP_PERCENT_LESS_THAN, AI_BATTLER_ATTACKER, 90, 5, // -> 1076
    /* 1071 */ AI_IF_RANDOM_LESS_THAN, 128, 2, // -> 1076
    /* 1074 */ AI_ADD_TO_MOVE_SCORE, 1,

    // 1076
    /* 1076 */ AI_LOAD_DEFENDER_LAST_USED_MOVE_CLASS,
    /* 1077 */ AI_IF_LOADED_NOT_EQUAL_TO, 1, 9, // -> 1083
    /* 107A */ AI_IF_RANDOM_LESS_THAN, 64, 6, // -> 1083
    /* 107D */ AI_ADD_TO_MOVE_SCORE, 1,
    /* 107F */ AI_GOTO, 2, // -> 1083

    // 1081
    /* 1081 */ AI_ADD_TO_MOVE_SCORE, -2,

    // 1083
    /* 1083 */ AI_POP_OR_END,
    // 1084: a table no command refers to
    /* 1084 */ 10, 11, 12, 13, 14, 15, 16, 17, AI_TABLE_END,

    // 108D
    /* 108D */ AI_IF_SPEED_COMPARE_EQUAL_TO, 1, 23, // -> 10A7
    /* 1090 */ AI_IF_HP_PERCENT_NOT_EQUAL_TO, AI_BATTLER_ATTACKER, 100, 4, // -> 1098
    /* 1094 */ AI_ADD_TO_MOVE_SCORE, -8,
    /* 1096 */ AI_GOTO, 42, // -> 10C2

    // 1098
    /* 1098 */ AI_IF_HP_PERCENT_LESS_THAN, AI_BATTLER_ATTACKER, 40, 26, // -> 10B6
    /* 109C */ AI_IF_HP_PERCENT_GREATER_THAN, AI_BATTLER_ATTACKER, 50, 3, // -> 10A3
    /* 10A0 */ AI_IF_RANDOM_LESS_THAN, 70, 19, // -> 10B6

    // 10A3
    /* 10A3 */ AI_ADD_TO_MOVE_SCORE, -3,
    /* 10A5 */ AI_GOTO, 27, // -> 10C2

    // 10A7
    /* 10A7 */ AI_IF_HP_PERCENT_LESS_THAN, AI_BATTLER_ATTACKER, 60, 11, // -> 10B6
    /* 10AB */ AI_IF_HP_PERCENT_GREATER_THAN, AI_BATTLER_ATTACKER, 70, 3, // -> 10B2
    /* 10AF */ AI_IF_RANDOM_LESS_THAN, 50, 4, // -> 10B6

    // 10B2
    /* 10B2 */ AI_ADD_TO_MOVE_SCORE, -3,
    /* 10B4 */ AI_GOTO, 12, // -> 10C2

    // 10B6
    /* 10B6 */ AI_IF_MOVE_EFFECT_NOT_KNOWN, AI_BATTLER_TARGET, MOVE_EFFECT_STEAL_STATUS_MOVE, 3, // -> 10BD
    /* 10BA */ AI_IF_RANDOM_LESS_THAN, 50, 5, // -> 10C2

    // 10BD
    /* 10BD */ AI_IF_RANDOM_LESS_THAN, 10, 2, // -> 10C2
    /* 10C0 */ AI_ADD_TO_MOVE_SCORE, 3,

    // 10C2
    /* 10C2 */ AI_POP_OR_END,

    // 10C3
    /* 10C3 */ AI_IF_RANDOM_LESS_THAN, 192, 2, // -> 10C8
    /* 10C6 */ AI_ADD_TO_MOVE_SCORE, 1,

    // 10C8
    /* 10C8 */ AI_POP_OR_END,

    // 10C9
    /* 10C9 */ AI_IF_HP_PERCENT_GREATER_THAN, AI_BATTLER_TARGET, 50, 2, // -> 10CF
    /* 10CD */ AI_ADD_TO_MOVE_SCORE, -1,

    // 10CF
    /* 10CF */ AI_POP_OR_END,

    // 10D0
    /* 10D0 */ AI_IF_STATUS, AI_BATTLER_TARGET, 0x80, 14, // -> 10E2
    /* 10D4 */ AI_IF_VOLATILE_STATUS, AI_BATTLER_TARGET, 0x10000000, 10, // -> 10E2
    /* 10D8 */ AI_IF_MOVE_EFFECT_FLAG, AI_BATTLER_TARGET, 0x20, 6, // -> 10E2
    /* 10DC */ AI_IF_VOLATILE_STATUS, AI_BATTLER_TARGET, 0xF0000, 2, // -> 10E2
    /* 10E0 */ AI_GOTO, 5, // -> 10E7

    // 10E2
    /* 10E2 */ AI_IF_RANDOM_LESS_THAN, 128, 2, // -> 10E7
    /* 10E5 */ AI_ADD_TO_MOVE_SCORE, 1,

    // 10E7
    /* 10E7 */ AI_POP_OR_END,

    // 10E8
    /* 10E8 */ AI_IF_MOVE_EFFECTIVENESS_EQUALS, 0, 20, // -> 10FF
    /* 10EB */ AI_IF_MOVE_EFFECTIVENESS_EQUALS, 10, 17, // -> 10FF
    /* 10EE */ AI_IF_MOVE_EFFECTIVENESS_EQUALS, 20, 14, // -> 10FF
    /* 10F1 */ AI_IF_MOVE_EFFECTIVENESS_EQUALS, 80, 6, // -> 10FA
    /* 10F4 */ AI_IF_MOVE_EFFECTIVENESS_EQUALS, 160, 3, // -> 10FA
    /* 10F7 */ AI_IF_RANDOM_LESS_THAN, 128, 5, // -> 10FF

    // 10FA
    /* 10FA */ AI_IF_RANDOM_LESS_THAN, 128, 2, // -> 10FF
    /* 10FD */ AI_ADD_TO_MOVE_SCORE, 1,

    // 10FF
    /* 10FF */ AI_POP_OR_END,

    // 1100
    /* 1100 */ AI_IF_MOVE_KNOWN, AI_BATTLER_ATTACKER, MOVE_PSYCH_UP, 27, // -> 111F

    // 1104
    /* 1104 */ AI_IF_RANDOM_LESS_THAN, 128, 2, // -> 1109
    /* 1107 */ AI_ADD_TO_MOVE_SCORE, 1,

    // 1109
    /* 1109 */ AI_IF_HP_PERCENT_GREATER_THAN, AI_BATTLER_TARGET, 70, 17, // -> 111E
    /* 110D */ AI_IF_RANDOM_LESS_THAN, 128, 2, // -> 1112
    /* 1110 */ AI_ADD_TO_MOVE_SCORE, -1,

    // 1112
    /* 1112 */ AI_IF_HP_PERCENT_GREATER_THAN, AI_BATTLER_TARGET, 50, 8, // -> 111E
    /* 1116 */ AI_ADD_TO_MOVE_SCORE, -1,
    /* 1118 */ AI_IF_HP_PERCENT_GREATER_THAN, AI_BATTLER_TARGET, 30, 2, // -> 111E
    /* 111C */ AI_ADD_TO_MOVE_SCORE, -1,

    // 111E
    /* 111E */ AI_POP_OR_END,

    // 111F
    /* 111F */ AI_IF_STAT_STAGE_GREATER_THAN, AI_BATTLER_TARGET, 1, 3, 10, // -> 112E
    /* 1124 */ AI_ADD_TO_MOVE_SCORE, 3,
    /* 1126 */ AI_LOAD_TURN_COUNT,
    /* 1127 */ AI_IF_LOADED_NOT_EQUAL_TO, 0, 6, // -> 1130
    /* 112A */ AI_ADD_TO_MOVE_SCORE, 2,
    /* 112C */ AI_GOTO, 2, // -> 1130

    // 112E
    /* 112E */ AI_ADD_TO_MOVE_SCORE, -5,

    // 1130
    /* 1130 */ AI_POP_OR_END,

    // 1131
    /* 1131 */ AI_IF_HP_PERCENT_LESS_THAN, AI_BATTLER_ATTACKER, 50, 20, // -> 1149
    /* 1135 */ AI_IF_HP_PERCENT_LESS_THAN, AI_BATTLER_ATTACKER, 90, 5, // -> 113E
    /* 1139 */ AI_IF_RANDOM_LESS_THAN, 128, 2, // -> 113E
    /* 113C */ AI_ADD_TO_MOVE_SCORE, 1,

    // 113E
    /* 113E */ AI_LOAD_DEFENDER_LAST_USED_MOVE_CLASS,
    /* 113F */ AI_IF_LOADED_NOT_EQUAL_TO, 0, 9, // -> 114B
    /* 1142 */ AI_IF_RANDOM_LESS_THAN, 64, 6, // -> 114B
    /* 1145 */ AI_ADD_TO_MOVE_SCORE, 1,
    /* 1147 */ AI_GOTO, 2, // -> 114B

    // 1149
    /* 1149 */ AI_ADD_TO_MOVE_SCORE, -2,

    // 114B
    /* 114B */ AI_POP_OR_END,
    // 114C: a table no command refers to
    /* 114C */ 0, 1, 2, 3, 4, 5, 6, 7, 8, AI_TABLE_END,

    // 1156
    /* 1156 */ AI_IF_HP_PERCENT_LESS_THAN, AI_BATTLER_ATTACKER, 50, 4, // -> 115E
    /* 115A */ AI_IF_HP_PERCENT_GREATER_THAN, AI_BATTLER_TARGET, 50, 2, // -> 1160

    // 115E
    /* 115E */ AI_ADD_TO_MOVE_SCORE, -1,

    // 1160
    /* 1160 */ AI_POP_OR_END,

    // 1161
    /* 1161 */ AI_IF_SPEED_COMPARE_EQUAL_TO, 1, 8, // -> 116C
    /* 1164 */ AI_IF_HP_PERCENT_GREATER_THAN, AI_BATTLER_ATTACKER, 70, 9, // -> 1171
    /* 1168 */ AI_ADD_TO_MOVE_SCORE, -1,
    /* 116A */ AI_GOTO, 5, // -> 1171

    // 116C
    /* 116C */ AI_IF_RANDOM_LESS_THAN, 20, 2, // -> 1171
    /* 116F */ AI_ADD_TO_MOVE_SCORE, 3,

    // 1171
    /* 1171 */ AI_POP_OR_END,

    // 1172
    /* 1172 */ AI_IF_SPEED_COMPARE_EQUAL_TO, 1, 16, // -> 1185
    /* 1175 */ AI_IF_HP_PERCENT_GREATER_THAN, AI_BATTLER_ATTACKER, 60, 12, // -> 1185
    /* 1179 */ AI_IF_HP_PERCENT_LESS_THAN, AI_BATTLER_ATTACKER, 40, 3, // -> 1180
    /* 117D */ AI_IF_RANDOM_LESS_THAN, 180, 5, // -> 1185

    // 1180
    /* 1180 */ AI_IF_RANDOM_LESS_THAN, 50, 2, // -> 1185
    /* 1183 */ AI_ADD_TO_MOVE_SCORE, -1,

    // 1185
    /* 1185 */ AI_POP_OR_END,

    // 1186
    /* 1186 */ AI_IF_MOVE_NOT_KNOWN, AI_BATTLER_ATTACKER, MOVE_FOCUS_PUNCH, 5, // -> 118F
    /* 118A */ AI_IF_RANDOM_LESS_THAN, 96, 2, // -> 118F
    /* 118D */ AI_ADD_TO_MOVE_SCORE, 1,

    // 118F
    /* 118F */ AI_IF_HP_PERCENT_GREATER_THAN, AI_BATTLER_ATTACKER, 90, 23, // -> 11AA
    /* 1193 */ AI_IF_HP_PERCENT_GREATER_THAN, AI_BATTLER_ATTACKER, 70, 14, // -> 11A5
    /* 1197 */ AI_IF_HP_PERCENT_GREATER_THAN, AI_BATTLER_ATTACKER, 50, 5, // -> 11A0
    /* 119B */ AI_IF_RANDOM_LESS_THAN, 100, 2, // -> 11A0
    /* 119E */ AI_ADD_TO_MOVE_SCORE, -1,

    // 11A0
    /* 11A0 */ AI_IF_RANDOM_LESS_THAN, 100, 2, // -> 11A5
    /* 11A3 */ AI_ADD_TO_MOVE_SCORE, -1,

    // 11A5
    /* 11A5 */ AI_IF_RANDOM_LESS_THAN, 100, 2, // -> 11AA
    /* 11A8 */ AI_ADD_TO_MOVE_SCORE, -1,

    // 11AA
    /* 11AA */ AI_IF_SPEED_COMPARE_EQUAL_TO, 1, 47, // -> 11DC
    /* 11AD */ AI_LOAD_BATTLER_PREVIOUS_MOVE, AI_BATTLER_TARGET,
    /* 11AF */ AI_LOAD_EFFECT_OF_LOADED_MOVE,
    /* 11B0 */ AI_IF_LOADED_EQUAL_TO, MOVE_EFFECT_STATUS_SLEEP, 20, // -> 11C7
    /* 11B3 */ AI_IF_LOADED_EQUAL_TO, MOVE_EFFECT_STATUS_BADLY_POISON, 17, // -> 11C7
    /* 11B6 */ AI_IF_LOADED_EQUAL_TO, MOVE_EFFECT_STATUS_POISON, 14, // -> 11C7
    /* 11B9 */ AI_IF_LOADED_EQUAL_TO, MOVE_EFFECT_STATUS_PARALYZE, 11, // -> 11C7
    /* 11BC */ AI_IF_LOADED_EQUAL_TO, MOVE_EFFECT_STATUS_BURN, 8, // -> 11C7
    /* 11BF */ AI_IF_LOADED_EQUAL_TO, MOVE_EFFECT_STATUS_CONFUSE, 11, // -> 11CD
    /* 11C2 */ AI_IF_LOADED_EQUAL_TO, MOVE_EFFECT_STATUS_LEECH_SEED, 14, // -> 11D3
    /* 11C5 */ AI_GOTO, 21, // -> 11DC

    // 11C7
    /* 11C7 */ AI_IF_NOT_STATUS, AI_BATTLER_TARGET, 0xFF, 12, // -> 11D7
    /* 11CB */ AI_GOTO, 15, // -> 11DC

    // 11CD
    /* 11CD */ AI_IF_NOT_VOLATILE_STATUS, AI_BATTLER_TARGET, 0x7, 6, // -> 11D7
    /* 11D1 */ AI_GOTO, 9, // -> 11DC

    // 11D3
    /* 11D3 */ AI_IF_MOVE_EFFECT_FLAG, AI_BATTLER_TARGET, 0x4, 5, // -> 11DC

    // 11D7
    /* 11D7 */ AI_IF_RANDOM_LESS_THAN, 100, 2, // -> 11DC
    /* 11DA */ AI_ADD_TO_MOVE_SCORE, 1,

    // 11DC
    /* 11DC */ AI_POP_OR_END,

    // 11DD
    /* 11DD */ AI_IF_MOVE_EFFECTIVENESS_EQUALS, 0, 31, // -> 11FF
    /* 11E0 */ AI_IF_MOVE_EFFECTIVENESS_EQUALS, 10, 28, // -> 11FF
    /* 11E3 */ AI_IF_MOVE_EFFECTIVENESS_EQUALS, 20, 25, // -> 11FF
    /* 11E6 */ AI_LOAD_BATTLER_ABILITY, AI_BATTLER_ATTACKER,
    /* 11E8 */ AI_IF_LOADED_EQUAL_TO, ABILITY_TRUANT, 9, // -> 11F4
    /* 11EB */ AI_IF_SPEED_COMPARE_EQUAL_TO, 1, 13, // -> 11FB
    /* 11EE */ AI_IF_HP_PERCENT_GREATER_THAN, AI_BATTLER_ATTACKER, 40, 13, // -> 11FF
    /* 11F2 */ AI_GOTO, 13, // -> 1201

    // 11F4
    /* 11F4 */ AI_IF_RANDOM_LESS_THAN, 80, 10, // -> 1201
    /* 11F7 */ AI_ADD_TO_MOVE_SCORE, 1,
    /* 11F9 */ AI_GOTO, 6, // -> 1201

    // 11FB
    /* 11FB */ AI_IF_HP_PERCENT_LESS_THAN, AI_BATTLER_ATTACKER, 60, 2, // -> 1201

    // 11FF
    /* 11FF */ AI_ADD_TO_MOVE_SCORE, -1,

    // 1201
    /* 1201 */ AI_POP_OR_END,

    // 1202
    /* 1202 */ AI_IF_SPEED_COMPARE_EQUAL_TO, 1, 15, // -> 1214
    /* 1205 */ AI_LOAD_BATTLER_PREVIOUS_MOVE, AI_BATTLER_TARGET,
    /* 1207 */ AI_LOAD_POWER_OF_LOADED_MOVE,
    /* 1208 */ AI_IF_LOADED_EQUAL_TO, 0, 4, // -> 120F
    /* 120B */ AI_ADD_TO_MOVE_SCORE, 1,
    /* 120D */ AI_GOTO, 5, // -> 1214

    // 120F
    /* 120F */ AI_IF_RANDOM_LESS_THAN, 100, 2, // -> 1214
    /* 1212 */ AI_ADD_TO_MOVE_SCORE, -1,

    // 1214
    /* 1214 */ AI_POP_OR_END,

    // 1215
    /* 1215 */ AI_IF_STATUS, AI_BATTLER_TARGET, 0x7, 80, // -> 1269
    /* 1219 */ AI_IF_VOLATILE_STATUS, AI_BATTLER_TARGET, 0xF0000, 76, // -> 1269
    /* 121D */ AI_IF_VOLATILE_STATUS, AI_BATTLER_TARGET, 0x7, 72, // -> 1269
    /* 1221 */ AI_IF_HP_PERCENT_GREATER_THAN, AI_BATTLER_ATTACKER, 30, 5, // -> 122A
    /* 1225 */ AI_IF_RANDOM_LESS_THAN, 10, 2, // -> 122A
    /* 1228 */ AI_ADD_TO_MOVE_SCORE, -1,

    // 122A
    /* 122A */ AI_IF_HP_PERCENT_GREATER_THAN, AI_BATTLER_ATTACKER, 50, 5, // -> 1233
    /* 122E */ AI_IF_RANDOM_LESS_THAN, 100, 2, // -> 1233
    /* 1231 */ AI_ADD_TO_MOVE_SCORE, -1,

    // 1233
    /* 1233 */ AI_IF_MOVE_KNOWN, AI_BATTLER_ATTACKER, MOVE_MIRROR_COAT, 44, // -> 1263
    /* 1237 */ AI_LOAD_BATTLER_PREVIOUS_MOVE, AI_BATTLER_TARGET,
    /* 1239 */ AI_LOAD_POWER_OF_LOADED_MOVE,
    /* 123A */ AI_IF_LOADED_EQUAL_TO, 0, 18, // -> 124F
    /* 123D */ AI_IF_TARGET_IS_NOT_TAUNTED, 5, // -> 1244
    /* 123F */ AI_IF_RANDOM_LESS_THAN, 100, 2, // -> 1244
    /* 1242 */ AI_ADD_TO_MOVE_SCORE, 1,

    // 1244
    /* 1244 */ AI_LOAD_DEFENDER_LAST_USED_MOVE_CLASS,
    /* 1245 */ AI_IF_LOADED_NOT_EQUAL_TO, 0, 33, // -> 1269
    /* 1248 */ AI_IF_RANDOM_LESS_THAN, 100, 32, // -> 126B
    /* 124B */ AI_ADD_TO_MOVE_SCORE, 1,
    /* 124D */ AI_GOTO, 28, // -> 126B

    // 124F
    /* 124F */ AI_IF_TARGET_IS_NOT_TAUNTED, 5, // -> 1256
    /* 1251 */ AI_IF_RANDOM_LESS_THAN, 100, 2, // -> 1256
    /* 1254 */ AI_ADD_TO_MOVE_SCORE, 1,

    // 1256
    /* 1256 */ AI_LOAD_TYPE_FROM, 0,
    /* 1258 */ AI_IF_LOADED_IN_TABLE, 17, 16, // table 126C, -> 126B
    /* 125B */ AI_LOAD_TYPE_FROM, 2,
    /* 125D */ AI_IF_LOADED_IN_TABLE, 12, 11, // table 126C, -> 126B
    /* 1260 */ AI_IF_RANDOM_LESS_THAN, 50, 8, // -> 126B

    // 1263
    /* 1263 */ AI_IF_RANDOM_LESS_THAN, 100, 2, // -> 1268
    /* 1266 */ AI_ADD_TO_MOVE_SCORE, 4,

    // 1268
    /* 1268 */ AI_POP_OR_END,

    // 1269
    /* 1269 */ AI_ADD_TO_MOVE_SCORE, -1,

    // 126B
    /* 126B */ AI_POP_OR_END,

    // 126C
    /* 126C */ TYPE_NORMAL, TYPE_FIGHTING, TYPE_FLYING, TYPE_POISON, TYPE_GROUND, TYPE_ROCK,
               TYPE_BUG, TYPE_GHOST, TYPE_STEEL, AI_TABLE_END,

    // 1276
    /* 1276 */ AI_IF_BATTLER_UNDER_EFFECT, AI_BATTLER_TARGET, 0, 9, // -> 1283
    /* 127A */ AI_IF_SPEED_COMPARE_EQUAL_TO, 1, 13, // -> 128A
    /* 127D */ AI_LOAD_BATTLER_PREVIOUS_MOVE, AI_BATTLER_TARGET,
    /* 127F */ AI_LOAD_EFFECT_OF_LOADED_MOVE,
    /* 1280 */ AI_IF_LOADED_NOT_IN_TABLE, 10, 7, // table 128D, -> 128A

    // 1283
    /* 1283 */ AI_IF_RANDOM_LESS_THAN, 30, 6, // -> 128C
    /* 1286 */ AI_ADD_TO_MOVE_SCORE, 3,
    /* 1288 */ AI_GOTO, 2, // -> 128C

    // 128A
    /* 128A */ AI_ADD_TO_MOVE_SCORE, -2,

    // 128C
    /* 128C */ AI_POP_OR_END,

    // 128D
    /* 128D */ MOVE_EFFECT_RECOVER_DAMAGE_SLEEP, MOVE_EFFECT_ATK_UP, MOVE_EFFECT_DEF_UP,
               MOVE_EFFECT_SPEED_UP, MOVE_EFFECT_SP_ATK_UP, MOVE_EFFECT_RESET_STAT_CHANGES,
               MOVE_EFFECT_FORCE_SWITCH, MOVE_EFFECT_CONVERSION, MOVE_EFFECT_STATUS_BADLY_POISON,
               MOVE_EFFECT_SET_LIGHT_SCREEN, MOVE_EFFECT_RECOVER_HEALTH_AND_SLEEP,
               MOVE_EFFECT_HALVE_HP, MOVE_EFFECT_SP_DEF_UP_2, MOVE_EFFECT_STATUS_CONFUSE,
               MOVE_EFFECT_STATUS_POISON, MOVE_EFFECT_STATUS_PARALYZE,
               MOVE_EFFECT_STATUS_LEECH_SEED, MOVE_EFFECT_DO_NOTHING, MOVE_EFFECT_ATK_UP_2,
               MOVE_EFFECT_ENCORE, MOVE_EFFECT_CONVERSION2, MOVE_EFFECT_NEXT_ATTACK_ALWAYS_HITS,
               MOVE_EFFECT_CURE_PARTY_STATUS, MOVE_EFFECT_PREVENT_ESCAPE,
               MOVE_EFFECT_STATUS_NIGHTMARE, MOVE_EFFECT_PROTECT, MOVE_EFFECT_SWITCH_ABILITIES,
               MOVE_EFFECT_IGNORE_EVASION_REMOVE_GHOST_IMMUNE, MOVE_EFFECT_ALL_FAINT_3_TURNS,
               MOVE_EFFECT_WEATHER_SANDSTORM, MOVE_EFFECT_SURVIVE_WITH_1_HP,
               MOVE_EFFECT_ATK_UP_2_STATUS_CONFUSION, MOVE_EFFECT_INFATUATE,
               MOVE_EFFECT_PREVENT_STATUS, MOVE_EFFECT_WEATHER_RAIN, MOVE_EFFECT_WEATHER_SUN,
               MOVE_EFFECT_MAX_ATK_LOSE_HALF_MAX_HP, MOVE_EFFECT_COPY_STAT_CHANGES,
               MOVE_EFFECT_HIT_IN_3_TURNS, MOVE_EFFECT_ALWAYS_FLINCH_FIRST_TURN_ONLY,
               MOVE_EFFECT_STOCKPILE, MOVE_EFFECT_SPIT_UP, MOVE_EFFECT_SWALLOW,
               MOVE_EFFECT_WEATHER_HAIL, MOVE_EFFECT_TORMENT, MOVE_EFFECT_STATUS_BURN,
               MOVE_EFFECT_MAKE_GLOBAL_TARGET, MOVE_EFFECT_SP_DEF_UP_DOUBLE_ELECTRIC_POWER,
               MOVE_EFFECT_SWITCH_HELD_ITEMS, MOVE_EFFECT_COPY_ABILITY,
               MOVE_EFFECT_GROUND_TRAP_USER_CONTINUOUS_HEAL, 184, MOVE_EFFECT_REMOVE_HELD_ITEM,
               MOVE_EFFECT_SWITCH_ABILITIES, MOVE_EFFECT_MAKE_SHARED_MOVES_UNUSEABL,
               MOVE_EFFECT_HEAL_STATUS, MOVE_EFFECT_REMOVE_ALL_PP_ON_DEFEAT, 199,
               MOVE_EFFECT_HALVE_ELECTRIC_DAMAGE, MOVE_EFFECT_HALVE_FIRE_DAMAGE,
               MOVE_EFFECT_ATK_SPD_UP, MOVE_EFFECT_CAMOUFLAGE, MOVE_EFFECT_GRAVITY,
               MOVE_EFFECT_IGNORE_EVATION_REMOVE_DARK_IMMUNE,
               MOVE_EFFECT_FAINT_AND_FULL_HEAL_NEXT_MON, MOVE_EFFECT_NATURAL_GIFT,
               MOVE_EFFECT_REMOVE_PROTECT, MOVE_EFFECT_DOUBLE_SPEED_3_TURNS,
               MOVE_EFFECT_RANDOM_STAT_UP_2, MOVE_EFFECT_FLING, MOVE_EFFECT_TRANSFER_STATUS,
               MOVE_EFFECT_PREVENT_HEALING, MOVE_EFFECT_SWAP_ATK_DEF, MOVE_EFFECT_SUPRESS_ABILITY,
               MOVE_EFFECT_PREVENT_CRITS, MOVE_EFFECT_SWAP_ATK_SP_ATK_STAT_CHANGES,
               MOVE_EFFECT_SWAP_DEF_SP_DEF_STAT_CHANGES, MOVE_EFFECT_SET_ABILITY_TO_INSOMNIA,
               MOVE_EFFECT_SWAP_STAT_CHANGES, MOVE_EFFECT_RESTORE_HP_EVERY_TURN,
               MOVE_EFFECT_GIVE_GROUND_IMMUNITY, MOVE_EFFECT_TRICK_ROOM, AI_TABLE_END,

    // 12E0
    /* 12E0 */ AI_IF_HP_PERCENT_LESS_THAN, AI_BATTLER_TARGET, 80, 19, // -> 12F7
    /* 12E4 */ AI_IF_SPEED_COMPARE_EQUAL_TO, 1, 8, // -> 12EF
    /* 12E7 */ AI_IF_HP_PERCENT_GREATER_THAN, AI_BATTLER_ATTACKER, 40, 12, // -> 12F7
    /* 12EB */ AI_ADD_TO_MOVE_SCORE, 1,
    /* 12ED */ AI_GOTO, 10, // -> 12F9

    // 12EF
    /* 12EF */ AI_IF_HP_PERCENT_GREATER_THAN, AI_BATTLER_ATTACKER, 60, 4, // -> 12F7
    /* 12F3 */ AI_ADD_TO_MOVE_SCORE, 1,
    /* 12F5 */ AI_GOTO, 2, // -> 12F9

    // 12F7
    /* 12F7 */ AI_ADD_TO_MOVE_SCORE, -1,

    // 12F9
    /* 12F9 */ AI_POP_OR_END,

    // 12FA
    /* 12FA */ AI_ADD_TO_MOVE_SCORE, 2,
    /* 12FC */ AI_POP_OR_END,

    // 12FD
    /* 12FD */ AI_IF_RANDOM_LESS_THAN, 128, 2, // -> 1302
    /* 1300 */ AI_ADD_TO_MOVE_SCORE, 2,

    // 1302
    /* 1302 */ AI_POP_OR_END,

    // 1303
    /* 1303 */ AI_IF_STATUS, AI_BATTLER_ATTACKER, 0x7, -2328, // -> 09EF
    /* 1307 */ AI_ADD_TO_MOVE_SCORE, -5,
    /* 1309 */ AI_POP_OR_END,

    // 130A
    /* 130A */ AI_ADD_TO_MOVE_SCORE, -1,
    /* 130C */ AI_IF_SPEED_COMPARE_EQUAL_TO, 1, 27, // -> 132A
    /* 130F */ AI_IF_HP_PERCENT_GREATER_THAN, AI_BATTLER_ATTACKER, 70, 23, // -> 132A
    /* 1313 */ AI_IF_RANDOM_LESS_THAN, 128, 2, // -> 1318
    /* 1316 */ AI_ADD_TO_MOVE_SCORE, 1,

    // 1318
    /* 1318 */ AI_IF_HP_PERCENT_GREATER_THAN, AI_BATTLER_ATTACKER, 50, 14, // -> 132A
    /* 131C */ AI_IF_RANDOM_LESS_THAN, 128, 2, // -> 1321
    /* 131F */ AI_ADD_TO_MOVE_SCORE, 1,

    // 1321
    /* 1321 */ AI_IF_HP_PERCENT_GREATER_THAN, AI_BATTLER_ATTACKER, 30, 5, // -> 132A
    /* 1325 */ AI_IF_RANDOM_LESS_THAN, 100, 2, // -> 132A
    /* 1328 */ AI_ADD_TO_MOVE_SCORE, 2,

    // 132A
    /* 132A */ AI_POP_OR_END,

    // 132B
    /* 132B */ AI_IF_SPEED_COMPARE_EQUAL_TO, 1, 14, // -> 133C
    /* 132E */ AI_IF_HP_PERCENT_GREATER_THAN, AI_BATTLER_ATTACKER, 33, 29, // -> 134F
    /* 1332 */ AI_IF_HP_PERCENT_GREATER_THAN, AI_BATTLER_ATTACKER, 20, 27, // -> 1351
    /* 1336 */ AI_IF_HP_PERCENT_LESS_THAN, AI_BATTLER_ATTACKER, 8, 12, // -> 1346
    /* 133A */ AI_GOTO, 12, // -> 1348

    // 133C
    /* 133C */ AI_IF_HP_PERCENT_GREATER_THAN, AI_BATTLER_ATTACKER, 60, 15, // -> 134F
    /* 1340 */ AI_IF_HP_PERCENT_GREATER_THAN, AI_BATTLER_ATTACKER, 40, 13, // -> 1351
    /* 1344 */ AI_GOTO, 2, // -> 1348

    // 1346
    /* 1346 */ AI_ADD_TO_MOVE_SCORE, 1,

    // 1348
    /* 1348 */ AI_IF_RANDOM_LESS_THAN, 100, 6, // -> 1351
    /* 134B */ AI_ADD_TO_MOVE_SCORE, 1,
    /* 134D */ AI_GOTO, 2, // -> 1351

    // 134F
    /* 134F */ AI_ADD_TO_MOVE_SCORE, -1,

    // 1351
    /* 1351 */ AI_POP_OR_END,

    // 1352
    /* 1352 */ AI_IF_STATUS, AI_BATTLER_ATTACKER, 0xFF, 6, // -> 135C
    /* 1356 */ AI_IF_PARTY_MEMBER_STATUS, AI_BATTLER_ATTACKER, 0xFF, 2, // -> 135C
    /* 135A */ AI_ADD_TO_MOVE_SCORE, -5,

    // 135C
    /* 135C */ AI_POP_OR_END,

    // 135D
    /* 135D */ AI_LOAD_HELD_ITEM_EFFECT, AI_BATTLER_TARGET,
    /* 135F */ AI_IF_LOADED_NOT_IN_TABLE, 10, 7, // table 136C, -> 1369
    /* 1362 */ AI_IF_RANDOM_LESS_THAN, 50, 6, // -> 136B
    /* 1365 */ AI_ADD_TO_MOVE_SCORE, 1,
    /* 1367 */ AI_GOTO, 2, // -> 136B

    // 1369
    /* 1369 */ AI_ADD_TO_MOVE_SCORE, -2,

    // 136B
    /* 136B */ AI_POP_OR_END,

    // 136C
    /* 136C */ HOLD_EFFECT_SLP_RESTORE, HOLD_EFFECT_STATUS_RESTORE, HOLD_EFFECT_HP_RESTORE,
               HOLD_EFFECT_ACC_REDUCE, HOLD_EFFECT_HP_RESTORE_GRADUAL, HOLD_EFFECT_PIKA_SPATK_UP,
               HOLD_EFFECT_CUBONE_ATK_UP, HOLD_EFFECT_WEAKEN_SE_FIRE, HOLD_EFFECT_WEAKEN_SE_WATER,
               HOLD_EFFECT_WEAKEN_SE_ELECTRIC, HOLD_EFFECT_WEAKEN_SE_GRASS,
               HOLD_EFFECT_WEAKEN_SE_ICE, HOLD_EFFECT_WEAKEN_SE_FIGHT,
               HOLD_EFFECT_WEAKEN_SE_POISON, HOLD_EFFECT_WEAKEN_SE_GROUND,
               HOLD_EFFECT_WEAKEN_SE_FLYING, HOLD_EFFECT_WEAKEN_SE_PSYCHIC,
               HOLD_EFFECT_WEAKEN_SE_BUG, HOLD_EFFECT_WEAKEN_SE_ROCK, HOLD_EFFECT_WEAKEN_SE_GHOST,
               HOLD_EFFECT_WEAKEN_SE_DRAGON, HOLD_EFFECT_WEAKEN_SE_DARK,
               HOLD_EFFECT_WEAKEN_SE_STEEL, HOLD_EFFECT_WEAKEN_NORMAL,
               HOLD_EFFECT_HP_RESTORE_PSN_TYPE, AI_TABLE_END,

    // 1386
    /* 1386 */ AI_LOAD_TYPE_FROM, 1,
    /* 1388 */ AI_IF_LOADED_EQUAL_TO, TYPE_GHOST, 52, // -> 13BF
    /* 138B */ AI_LOAD_TYPE_FROM, 3,
    /* 138D */ AI_IF_LOADED_EQUAL_TO, TYPE_GHOST, 47, // -> 13BF
    /* 1390 */ AI_IF_STAT_STAGE_GREATER_THAN, AI_BATTLER_ATTACKER, 2, 9, 48, // -> 13C5
    /* 1395 */ AI_IF_MOVE_KNOWN, AI_BATTLER_ATTACKER, MOVE_GYRO_BALL, 6, // -> 139F
    /* 1399 */ AI_IF_MOVE_KNOWN, AI_BATTLER_ATTACKER, MOVE_TRICK_ROOM, 2, // -> 139F
    /* 139D */ AI_GOTO, 5, // -> 13A4

    // 139F
    /* 139F */ AI_IF_RANDOM_LESS_THAN, 32, 7, // -> 13A9
    /* 13A2 */ AI_ADD_TO_MOVE_SCORE, 1,

    // 13A4
    /* 13A4 */ AI_IF_RANDOM_LESS_THAN, 128, 2, // -> 13A9
    /* 13A7 */ AI_ADD_TO_MOVE_SCORE, 1,

    // 13A9
    /* 13A9 */ AI_IF_STAT_STAGE_GREATER_THAN, AI_BATTLER_ATTACKER, 2, 7, 23, // -> 13C5
    /* 13AE */ AI_IF_RANDOM_LESS_THAN, 128, 2, // -> 13B3
    /* 13B1 */ AI_ADD_TO_MOVE_SCORE, 1,

    // 13B3
    /* 13B3 */ AI_IF_STAT_STAGE_GREATER_THAN, AI_BATTLER_ATTACKER, 2, 6, 13, // -> 13C5
    /* 13B8 */ AI_IF_RANDOM_LESS_THAN, 128, 10, // -> 13C5
    /* 13BB */ AI_ADD_TO_MOVE_SCORE, 1,
    /* 13BD */ AI_GOTO, 6, // -> 13C5

    // 13BF
    /* 13BF */ AI_IF_HP_PERCENT_GREATER_THAN, AI_BATTLER_ATTACKER, 80, 2, // -> 13C5
    /* 13C3 */ AI_ADD_TO_MOVE_SCORE, -1,

    // 13C5
    /* 13C5 */ AI_POP_OR_END,

    // 13C6
    /* 13C6 */ AI_IF_MOVE_KNOWN, AI_BATTLER_TARGET, MOVE_FEINT, 6, // -> 13D0
    /* 13CA */ AI_IF_MOVE_KNOWN, AI_BATTLER_TARGET, MOVE_SHADOW_FORCE, 2, // -> 13D0
    /* 13CE */ AI_GOTO, 5, // -> 13D5

    // 13D0
    /* 13D0 */ AI_IF_RANDOM_LESS_THAN, 128, 2, // -> 13D5
    /* 13D3 */ AI_ADD_TO_MOVE_SCORE, -2,

    // 13D5
    /* 13D5 */ AI_LOAD_PROTECT_CHAIN, AI_BATTLER_ATTACKER,
    /* 13D7 */ AI_IF_LOADED_GREATER_THAN, 1, 94, // -> 1438
    /* 13DA */ AI_IF_STATUS, AI_BATTLER_ATTACKER, 0x80, 86, // -> 1434
    /* 13DE */ AI_IF_VOLATILE_STATUS, AI_BATTLER_ATTACKER, 0x10000000, 82, // -> 1434
    /* 13E2 */ AI_IF_MOVE_EFFECT_FLAG, AI_BATTLER_ATTACKER, 0x20, 78, // -> 1434
    /* 13E6 */ AI_IF_VOLATILE_STATUS, AI_BATTLER_ATTACKER, 0xF0000, 74, // -> 1434
    /* 13EA */ AI_IF_MOVE_EFFECT_FLAG, AI_BATTLER_ATTACKER, 0x4, 70, // -> 1434
    /* 13EE */ AI_IF_MOVE_EFFECT_FLAG, AI_BATTLER_ATTACKER, 0x1800, 66, // -> 1434
    /* 13F2 */ AI_IF_MOVE_EFFECT_KNOWN, AI_BATTLER_TARGET, MOVE_EFFECT_RESTORE_HALF_HP, 62, // -> 1434
    /* 13F6 */ AI_IF_MOVE_EFFECT_KNOWN, AI_BATTLER_TARGET, MOVE_EFFECT_DEF_UP_DOUBLE_ROLLOUT_POWER, 58, // -> 1434
    /* 13FA */ AI_IF_STATUS, AI_BATTLER_TARGET, 0x80, 33, // -> 141F
    /* 13FE */ AI_IF_VOLATILE_STATUS, AI_BATTLER_TARGET, 0x10000000, 29, // -> 141F
    /* 1402 */ AI_IF_MOVE_EFFECT_FLAG, AI_BATTLER_TARGET, 0x20, 25, // -> 141F
    /* 1406 */ AI_IF_VOLATILE_STATUS, AI_BATTLER_TARGET, 0xF0000, 21, // -> 141F
    /* 140A */ AI_IF_MOVE_EFFECT_FLAG, AI_BATTLER_TARGET, 0x4, 17, // -> 141F
    /* 140E */ AI_IF_MOVE_EFFECT_FLAG, AI_BATTLER_TARGET, 0x1800, 13, // -> 141F
    /* 1412 */ AI_LOAD_BATTLE_TYPE,
    /* 1413 */ AI_IF_LOADED_MASK, 0x2, 9, // -> 141F
    /* 1416 */ AI_IF_MOVE_EFFECT_FLAG, AI_BATTLER_ATTACKER, 0x18, 5, // -> 141F
    /* 141A */ AI_IF_RANDOM_LESS_THAN, 85, 2, // -> 141F
    /* 141D */ AI_GOTO, 2, // -> 1421

    // 141F
    /* 141F */ AI_ADD_TO_MOVE_SCORE, 2,

    // 1421
    /* 1421 */ AI_IF_RANDOM_LESS_THAN, 128, 2, // -> 1426
    /* 1424 */ AI_ADD_TO_MOVE_SCORE, -1,

    // 1426
    /* 1426 */ AI_LOAD_PROTECT_CHAIN, AI_BATTLER_ATTACKER,
    /* 1428 */ AI_IF_LOADED_EQUAL_TO, 0, 15, // -> 143A
    /* 142B */ AI_ADD_TO_MOVE_SCORE, -1,
    /* 142D */ AI_IF_RANDOM_LESS_THAN, 128, 10, // -> 143A
    /* 1430 */ AI_ADD_TO_MOVE_SCORE, -1,
    /* 1432 */ AI_GOTO, 6, // -> 143A

    // 1434
    /* 1434 */ AI_IF_MOVE_EFFECT_FLAG, AI_BATTLER_ATTACKER, 0x18, 2, // -> 143A

    // 1438
    /* 1438 */ AI_ADD_TO_MOVE_SCORE, -2,

    // 143A
    /* 143A */ AI_POP_OR_END,

    // 143B
    /* 143B */ AI_IF_RANDOM_LESS_THAN, 128, 17, // -> 144F
    /* 143E */ AI_ADD_TO_MOVE_SCORE, 1,
    /* 1440 */ AI_IF_MOVE_KNOWN, AI_BATTLER_ATTACKER, MOVE_ROAR, 6, // -> 144A
    /* 1444 */ AI_IF_MOVE_KNOWN, AI_BATTLER_ATTACKER, MOVE_WHIRLWIND, 2, // -> 144A
    /* 1448 */ AI_GOTO, 5, // -> 144F

    // 144A
    /* 144A */ AI_IF_RANDOM_LESS_THAN, 64, 2, // -> 144F
    /* 144D */ AI_ADD_TO_MOVE_SCORE, 1,

    // 144F
    /* 144F */ AI_POP_OR_END,

    // 1450
    /* 1450 */ AI_LOAD_TYPE_FROM, 1,
    /* 1452 */ AI_IF_LOADED_EQUAL_TO, TYPE_GHOST, 14, // -> 1463
    /* 1455 */ AI_LOAD_TYPE_FROM, 3,
    /* 1457 */ AI_IF_LOADED_EQUAL_TO, TYPE_GHOST, 9, // -> 1463
    /* 145A */ AI_IF_STAT_STAGE_GREATER_THAN, AI_BATTLER_TARGET, 7, 8, 7, // -> 1466
    /* 145F */ AI_ADD_TO_MOVE_SCORE, -2,
    /* 1461 */ AI_GOTO, 8, // -> 146B

    // 1463
    /* 1463 */ AI_IF_RANDOM_LESS_THAN, 80, 5, // -> 146B

    // 1466
    /* 1466 */ AI_IF_RANDOM_LESS_THAN, 80, 2, // -> 146B
    /* 1469 */ AI_ADD_TO_MOVE_SCORE, 2,

    // 146B
    /* 146B */ AI_POP_OR_END,

    // 146C
    /* 146C */ AI_IF_HP_PERCENT_LESS_THAN, AI_BATTLER_ATTACKER, 4, 4, // -> 1474
    /* 1470 */ AI_IF_HP_PERCENT_LESS_THAN, AI_BATTLER_ATTACKER, 35, 4, // -> 1478

    // 1474
    /* 1474 */ AI_ADD_TO_MOVE_SCORE, -1,
    /* 1476 */ AI_GOTO, 5, // -> 147D

    // 1478
    /* 1478 */ AI_IF_RANDOM_LESS_THAN, 70, 2, // -> 147D
    /* 147B */ AI_ADD_TO_MOVE_SCORE, 1,

    // 147D
    /* 147D */ AI_POP_OR_END,

    // 147E
    /* 147E */ AI_IF_STAT_STAGE_GREATER_THAN, AI_BATTLER_ATTACKER, 1, 8, 22, // -> 1499
    /* 1483 */ AI_IF_STAT_STAGE_GREATER_THAN, AI_BATTLER_ATTACKER, 2, 8, 17, // -> 1499
    /* 1488 */ AI_IF_STAT_STAGE_GREATER_THAN, AI_BATTLER_ATTACKER, 4, 8, 12, // -> 1499
    /* 148D */ AI_IF_STAT_STAGE_GREATER_THAN, AI_BATTLER_ATTACKER, 5, 8, 7, // -> 1499
    /* 1492 */ AI_IF_STAT_STAGE_GREATER_THAN, AI_BATTLER_ATTACKER, 7, 8, 2, // -> 1499
    /* 1497 */ AI_GOTO, 20, // -> 14AD

    // 1499
    /* 1499 */ AI_IF_SPEED_COMPARE_EQUAL_TO, 1, 6, // -> 14A2
    /* 149C */ AI_IF_HP_PERCENT_GREATER_THAN, AI_BATTLER_ATTACKER, 60, 55, // -> 14D7
    /* 14A0 */ AI_GOTO, 4, // -> 14A6

    // 14A2
    /* 14A2 */ AI_IF_HP_PERCENT_GREATER_THAN, AI_BATTLER_ATTACKER, 70, 49, // -> 14D7

    // 14A6
    /* 14A6 */ AI_IF_RANDOM_LESS_THAN, 80, 46, // -> 14D7
    /* 14A9 */ AI_ADD_TO_MOVE_SCORE, 2,
    /* 14AB */ AI_GOTO, 42, // -> 14D7

    // 14AD
    /* 14AD */ AI_IF_STAT_STAGE_GREATER_THAN, AI_BATTLER_ATTACKER, 1, 7, 22, // -> 14C8
    /* 14B2 */ AI_IF_STAT_STAGE_GREATER_THAN, AI_BATTLER_ATTACKER, 2, 7, 17, // -> 14C8
    /* 14B7 */ AI_IF_STAT_STAGE_GREATER_THAN, AI_BATTLER_ATTACKER, 4, 7, 12, // -> 14C8
    /* 14BC */ AI_IF_STAT_STAGE_GREATER_THAN, AI_BATTLER_ATTACKER, 5, 7, 7, // -> 14C8
    /* 14C1 */ AI_IF_STAT_STAGE_GREATER_THAN, AI_BATTLER_ATTACKER, 7, 7, 2, // -> 14C8
    /* 14C6 */ AI_GOTO, 13, // -> 14D5

    // 14C8
    /* 14C8 */ AI_IF_SPEED_COMPARE_EQUAL_TO, 1, 6, // -> 14D1
    /* 14CB */ AI_IF_HP_PERCENT_GREATER_THAN, AI_BATTLER_ATTACKER, 60, 6, // -> 14D5
    /* 14CF */ AI_GOTO, 6, // -> 14D7

    // 14D1
    /* 14D1 */ AI_IF_HP_PERCENT_LESS_THAN, AI_BATTLER_ATTACKER, 70, 2, // -> 14D7

    // 14D5
    /* 14D5 */ AI_ADD_TO_MOVE_SCORE, -2,

    // 14D7
    /* 14D7 */ AI_POP_OR_END,

    // 14D8
    /* 14D8 */ AI_LOAD_IS_FIRST_TURN_IN_BATTLE, AI_BATTLER_ATTACKER,
    /* 14DA */ AI_IF_LOADED_NOT_EQUAL_TO, 0, 22, // -> 14F3
    /* 14DD */ AI_LOAD_TYPE_FROM, 0,
    /* 14DF */ AI_IF_LOADED_EQUAL_TO, TYPE_GHOST, 17, // -> 14F3
    /* 14E2 */ AI_LOAD_TYPE_FROM, 0,
    /* 14E4 */ AI_IF_LOADED_EQUAL_TO, TYPE_PSYCHIC, 12, // -> 14F3
    /* 14E7 */ AI_LOAD_TYPE_FROM, 2,
    /* 14E9 */ AI_IF_LOADED_EQUAL_TO, TYPE_GHOST, 7, // -> 14F3
    /* 14EC */ AI_LOAD_TYPE_FROM, 2,
    /* 14EE */ AI_IF_LOADED_EQUAL_TO, TYPE_PSYCHIC, 2, // -> 14F3
    /* 14F1 */ AI_GOTO, 5, // -> 14F8

    // 14F3
    /* 14F3 */ AI_IF_RANDOM_LESS_THAN, 128, 2, // -> 14F8
    /* 14F6 */ AI_ADD_TO_MOVE_SCORE, 1,

    // 14F8
    /* 14F8 */ AI_IF_MOVE_NOT_KNOWN, AI_BATTLER_TARGET, MOVE_U_TURN, 5, // -> 1501
    /* 14FC */ AI_IF_RANDOM_LESS_THAN, 128, 2, // -> 1501
    /* 14FF */ AI_ADD_TO_MOVE_SCORE, 1,

    // 1501
    /* 1501 */ AI_POP_OR_END,

    // 1502
    /* 1502 */ AI_IF_SPEED_COMPARE_EQUAL_TO, 0, 5, // -> 150A
    /* 1505 */ AI_LOAD_BATTLER_ABILITY, AI_BATTLER_ATTACKER,
    /* 1507 */ AI_IF_LOADED_EQUAL_TO, ABILITY_SWIFT_SWIM, 28, // -> 1526

    // 150A
    /* 150A */ AI_IF_HP_PERCENT_LESS_THAN, AI_BATTLER_ATTACKER, 40, 28, // -> 152A
    /* 150E */ AI_LOAD_CURRENT_WEATHER,
    /* 150F */ AI_IF_LOADED_EQUAL_TO, 4, 20, // -> 1526
    /* 1512 */ AI_IF_LOADED_EQUAL_TO, 1, 17, // -> 1526
    /* 1515 */ AI_IF_LOADED_EQUAL_TO, 3, 14, // -> 1526
    /* 1518 */ AI_LOAD_BATTLER_ABILITY, AI_BATTLER_ATTACKER,
    /* 151A */ AI_IF_LOADED_EQUAL_TO, ABILITY_RAIN_DISH, 9, // -> 1526
    /* 151D */ AI_IF_LOADED_NOT_EQUAL_TO, ABILITY_HYDRATION, 12, // -> 152C
    /* 1520 */ AI_IF_STATUS, AI_BATTLER_ATTACKER, 0xFF, 2, // -> 1526
    /* 1524 */ AI_GOTO, 6, // -> 152C

    // 1526
    /* 1526 */ AI_ADD_TO_MOVE_SCORE, 1,
    /* 1528 */ AI_GOTO, 2, // -> 152C

    // 152A
    /* 152A */ AI_ADD_TO_MOVE_SCORE, -1,

    // 152C
    /* 152C */ AI_POP_OR_END,

    // 152D
    /* 152D */ AI_IF_HP_PERCENT_LESS_THAN, AI_BATTLER_ATTACKER, 40, 28, // -> 154D
    /* 1531 */ AI_LOAD_CURRENT_WEATHER,
    /* 1532 */ AI_IF_LOADED_EQUAL_TO, 4, 20, // -> 1549
    /* 1535 */ AI_IF_LOADED_EQUAL_TO, 2, 17, // -> 1549
    /* 1538 */ AI_IF_LOADED_EQUAL_TO, 3, 14, // -> 1549
    /* 153B */ AI_LOAD_BATTLER_ABILITY, AI_BATTLER_ATTACKER,
    /* 153D */ AI_IF_LOADED_EQUAL_TO, ABILITY_FLOWER_GIFT, 9, // -> 1549
    /* 1540 */ AI_IF_LOADED_NOT_EQUAL_TO, ABILITY_LEAF_GUARD, 12, // -> 154F
    /* 1543 */ AI_IF_STATUS, AI_BATTLER_ATTACKER, 0xFF, 2, // -> 1549
    /* 1547 */ AI_GOTO, 6, // -> 154F

    // 1549
    /* 1549 */ AI_ADD_TO_MOVE_SCORE, 1,
    /* 154B */ AI_GOTO, 2, // -> 154F

    // 154D
    /* 154D */ AI_ADD_TO_MOVE_SCORE, -1,

    // 154F
    /* 154F */ AI_POP_OR_END,

    // 1550
    /* 1550 */ AI_IF_HP_PERCENT_LESS_THAN, AI_BATTLER_ATTACKER, 90, 2, // -> 1556
    /* 1554 */ AI_GOTO, 2, // -> 1558

    // 1556
    /* 1556 */ AI_ADD_TO_MOVE_SCORE, -2,

    // 1558
    /* 1558 */ AI_POP_OR_END,

    // 1559
    /* 1559 */ AI_IF_STAT_STAGE_GREATER_THAN, AI_BATTLER_TARGET, 1, 8, 22, // -> 1574
    /* 155E */ AI_IF_STAT_STAGE_GREATER_THAN, AI_BATTLER_TARGET, 2, 8, 17, // -> 1574
    /* 1563 */ AI_IF_STAT_STAGE_GREATER_THAN, AI_BATTLER_TARGET, 4, 8, 12, // -> 1574
    /* 1568 */ AI_IF_STAT_STAGE_GREATER_THAN, AI_BATTLER_TARGET, 5, 8, 7, // -> 1574
    /* 156D */ AI_IF_STAT_STAGE_GREATER_THAN, AI_BATTLER_TARGET, 7, 8, 2, // -> 1574
    /* 1572 */ AI_GOTO, 35, // -> 1597

    // 1574
    /* 1574 */ AI_IF_STAT_STAGE_LESS_THAN, AI_BATTLER_ATTACKER, 1, 7, 27, // -> 1594
    /* 1579 */ AI_IF_STAT_STAGE_LESS_THAN, AI_BATTLER_ATTACKER, 2, 7, 22, // -> 1594
    /* 157E */ AI_IF_STAT_STAGE_LESS_THAN, AI_BATTLER_ATTACKER, 4, 7, 17, // -> 1594
    /* 1583 */ AI_IF_STAT_STAGE_LESS_THAN, AI_BATTLER_ATTACKER, 5, 7, 12, // -> 1594
    /* 1588 */ AI_IF_STAT_STAGE_LESS_THAN, AI_BATTLER_ATTACKER, 7, 7, 5, // -> 1592
    /* 158D */ AI_IF_RANDOM_LESS_THAN, 50, 9, // -> 1599
    /* 1590 */ AI_GOTO, 5, // -> 1597

    // 1592
    /* 1592 */ AI_ADD_TO_MOVE_SCORE, 1,

    // 1594
    /* 1594 */ AI_ADD_TO_MOVE_SCORE, 1,
    /* 1596 */ AI_POP_OR_END,

    // 1597
    /* 1597 */ AI_ADD_TO_MOVE_SCORE, -2,

    // 1599
    /* 1599 */ AI_POP_OR_END,

    // 159A
    /* 159A */ AI_IF_STATUS, AI_BATTLER_TARGET, 0x7, 80, // -> 15EE
    /* 159E */ AI_IF_VOLATILE_STATUS, AI_BATTLER_TARGET, 0xF0000, 76, // -> 15EE
    /* 15A2 */ AI_IF_VOLATILE_STATUS, AI_BATTLER_TARGET, 0x7, 72, // -> 15EE
    /* 15A6 */ AI_IF_HP_PERCENT_GREATER_THAN, AI_BATTLER_ATTACKER, 30, 5, // -> 15AF
    /* 15AA */ AI_IF_RANDOM_LESS_THAN, 10, 2, // -> 15AF
    /* 15AD */ AI_ADD_TO_MOVE_SCORE, -1,

    // 15AF
    /* 15AF */ AI_IF_HP_PERCENT_GREATER_THAN, AI_BATTLER_ATTACKER, 50, 5, // -> 15B8
    /* 15B3 */ AI_IF_RANDOM_LESS_THAN, 100, 2, // -> 15B8
    /* 15B6 */ AI_ADD_TO_MOVE_SCORE, -1,

    // 15B8
    /* 15B8 */ AI_IF_MOVE_KNOWN, AI_BATTLER_ATTACKER, MOVE_COUNTER, 44, // -> 15E8
    /* 15BC */ AI_LOAD_BATTLER_PREVIOUS_MOVE, AI_BATTLER_TARGET,
    /* 15BE */ AI_LOAD_POWER_OF_LOADED_MOVE,
    /* 15BF */ AI_IF_LOADED_EQUAL_TO, 0, 18, // -> 15D4
    /* 15C2 */ AI_IF_TARGET_IS_NOT_TAUNTED, 5, // -> 15C9
    /* 15C4 */ AI_IF_RANDOM_LESS_THAN, 100, 2, // -> 15C9
    /* 15C7 */ AI_ADD_TO_MOVE_SCORE, 1,

    // 15C9
    /* 15C9 */ AI_LOAD_DEFENDER_LAST_USED_MOVE_CLASS,
    /* 15CA */ AI_IF_LOADED_NOT_EQUAL_TO, 1, 33, // -> 15EE
    /* 15CD */ AI_IF_RANDOM_LESS_THAN, 100, 32, // -> 15F0
    /* 15D0 */ AI_ADD_TO_MOVE_SCORE, 1,
    /* 15D2 */ AI_GOTO, 28, // -> 15F0

    // 15D4
    /* 15D4 */ AI_IF_TARGET_IS_NOT_TAUNTED, 5, // -> 15DB
    /* 15D6 */ AI_IF_RANDOM_LESS_THAN, 100, 2, // -> 15DB
    /* 15D9 */ AI_ADD_TO_MOVE_SCORE, 1,

    // 15DB
    /* 15DB */ AI_LOAD_TYPE_FROM, 0,
    /* 15DD */ AI_IF_LOADED_IN_TABLE, 17, 16, // table 15F1, -> 15F0
    /* 15E0 */ AI_LOAD_TYPE_FROM, 2,
    /* 15E2 */ AI_IF_LOADED_IN_TABLE, 12, 11, // table 15F1, -> 15F0
    /* 15E5 */ AI_IF_RANDOM_LESS_THAN, 50, 8, // -> 15F0

    // 15E8
    /* 15E8 */ AI_IF_RANDOM_LESS_THAN, 100, 2, // -> 15ED
    /* 15EB */ AI_ADD_TO_MOVE_SCORE, 4,

    // 15ED
    /* 15ED */ AI_POP_OR_END,

    // 15EE
    /* 15EE */ AI_ADD_TO_MOVE_SCORE, -1,

    // 15F0
    /* 15F0 */ AI_POP_OR_END,

    // 15F1
    /* 15F1 */ TYPE_FIRE, TYPE_WATER, TYPE_GRASS, TYPE_ELECTRIC, TYPE_PSYCHIC, TYPE_ICE,
               TYPE_DRAGON, TYPE_DARK, AI_TABLE_END,

    // 15FA
    /* 15FA */ AI_IF_MOVE_EFFECTIVENESS_EQUALS, 0, 41, // -> 1626
    /* 15FD */ AI_IF_MOVE_EFFECTIVENESS_EQUALS, 10, 38, // -> 1626
    /* 1600 */ AI_IF_MOVE_EFFECTIVENESS_EQUALS, 20, 35, // -> 1626
    /* 1603 */ AI_IF_CURRENT_MOVE_EFFECT_EQUAL_TO, MOVE_EFFECT_151, 2, // -> 1608
    /* 1606 */ AI_GOTO, 8, // -> 1610

    // 1608
    /* 1608 */ AI_LOAD_CURRENT_WEATHER,
    /* 1609 */ AI_IF_LOADED_NOT_EQUAL_TO, 1, 4, // -> 1610
    /* 160C */ AI_ADD_TO_MOVE_SCORE, 2,
    /* 160E */ AI_GOTO, 24, // -> 1628

    // 1610
    /* 1610 */ AI_IF_HELD_ITEM_EQUAL_TO, AI_BATTLER_ATTACKER, ITEM_POWER_HERB, 2, // -> 1616
    /* 1614 */ AI_GOTO, 4, // -> 161A

    // 1616
    /* 1616 */ AI_ADD_TO_MOVE_SCORE, 2,
    /* 1618 */ AI_GOTO, 14, // -> 1628

    // 161A
    /* 161A */ AI_IF_MOVE_EFFECT_KNOWN, AI_BATTLER_TARGET, MOVE_EFFECT_PROTECT, 8, // -> 1626
    /* 161E */ AI_IF_HP_PERCENT_GREATER_THAN, AI_BATTLER_ATTACKER, 38, 6, // -> 1628
    /* 1622 */ AI_ADD_TO_MOVE_SCORE, -1,
    /* 1624 */ AI_GOTO, 2, // -> 1628

    // 1626
    /* 1626 */ AI_ADD_TO_MOVE_SCORE, -2,

    // 1628
    /* 1628 */ AI_POP_OR_END,

    // 1629
    /* 1629 */ AI_IF_MOVE_EFFECTIVENESS_EQUALS, 0, 17, // -> 163D
    /* 162C */ AI_IF_MOVE_EFFECTIVENESS_EQUALS, 20, 14, // -> 163D
    /* 162F */ AI_IF_MOVE_EFFECTIVENESS_EQUALS, 10, 11, // -> 163D
    /* 1632 */ AI_LOAD_CURRENT_WEATHER,
    /* 1633 */ AI_IF_LOADED_EQUAL_TO, 1, 7, // -> 163D
    /* 1636 */ AI_IF_LOADED_NOT_EQUAL_TO, 2, 9, // -> 1642
    /* 1639 */ AI_ADD_TO_MOVE_SCORE, 1,
    /* 163B */ AI_GOTO, 5, // -> 1642

    // 163D
    /* 163D */ AI_IF_RANDOM_LESS_THAN, 50, 2, // -> 1642
    /* 1640 */ AI_ADD_TO_MOVE_SCORE, -3,

    // 1642
    /* 1642 */ AI_POP_OR_END,

    // 1643
    /* 1643 */ AI_IF_HELD_ITEM_EQUAL_TO, AI_BATTLER_ATTACKER, ITEM_POWER_HERB, -49, // -> 1616
    /* 1647 */ AI_IF_MOVE_EFFECT_NOT_KNOWN, AI_BATTLER_TARGET, MOVE_EFFECT_PROTECT, 4, // -> 164F
    /* 164B */ AI_ADD_TO_MOVE_SCORE, -1,
    /* 164D */ AI_GOTO, 80, // -> 169F

    // 164F
    /* 164F */ AI_IF_MOVE_EFFECTIVENESS_EQUALS, 0, 78, // -> 16A0
    /* 1652 */ AI_IF_MOVE_EFFECTIVENESS_EQUALS, 10, 75, // -> 16A0
    /* 1655 */ AI_IF_MOVE_EFFECTIVENESS_EQUALS, 20, 72, // -> 16A0
    /* 1658 */ AI_IF_HELD_ITEM_EQUAL_TO, AI_BATTLER_ATTACKER, ITEM_POWER_HERB, 2, // -> 165E
    /* 165C */ AI_GOTO, 4, // -> 1662

    // 165E
    /* 165E */ AI_ADD_TO_MOVE_SCORE, 1,
    /* 1660 */ AI_GOTO, 61, // -> 169F

    // 1662
    /* 1662 */ AI_IF_STATUS, AI_BATTLER_TARGET, 0x80, 52, // -> 169A
    /* 1666 */ AI_IF_VOLATILE_STATUS, AI_BATTLER_TARGET, 0x10000000, 48, // -> 169A
    /* 166A */ AI_IF_MOVE_EFFECT_FLAG, AI_BATTLER_TARGET, 0x4, 44, // -> 169A
    /* 166E */ AI_LOAD_CURRENT_WEATHER,
    /* 166F */ AI_IF_LOADED_EQUAL_TO, 3, 5, // -> 1677
    /* 1672 */ AI_IF_LOADED_EQUAL_TO, 4, 14, // -> 1683
    /* 1675 */ AI_GOTO, 24, // -> 168F

    // 1677
    /* 1677 */ AI_LOAD_TYPE_FROM, 1,
    /* 1679 */ AI_IF_LOADED_IN_TABLE, 39, 30, // table 16A3, -> 169A
    /* 167C */ AI_LOAD_TYPE_FROM, 3,
    /* 167E */ AI_IF_LOADED_IN_TABLE, 34, 25, // table 16A3, -> 169A
    /* 1681 */ AI_GOTO, 12, // -> 168F

    // 1683
    /* 1683 */ AI_LOAD_TYPE_FROM, 1,
    /* 1685 */ AI_IF_LOADED_EQUAL_TO, TYPE_ICE, 18, // -> 169A
    /* 1688 */ AI_LOAD_TYPE_FROM, 3,
    /* 168A */ AI_IF_LOADED_EQUAL_TO, TYPE_ICE, 13, // -> 169A
    /* 168D */ AI_GOTO, 0, // -> 168F

    // 168F
    /* 168F */ AI_IF_SPEED_COMPARE_EQUAL_TO, 1, 13, // -> 169F
    /* 1692 */ AI_LOAD_BATTLER_PREVIOUS_MOVE, AI_BATTLER_TARGET,
    /* 1694 */ AI_LOAD_EFFECT_OF_LOADED_MOVE,
    /* 1695 */ AI_IF_LOADED_NOT_EQUAL_TO, MOVE_EFFECT_NEXT_ATTACK_ALWAYS_HITS, 2, // -> 169A
    /* 1698 */ AI_GOTO, 5, // -> 169F

    // 169A
    /* 169A */ AI_IF_RANDOM_LESS_THAN, 80, 2, // -> 169F
    /* 169D */ AI_ADD_TO_MOVE_SCORE, 1,

    // 169F
    /* 169F */ AI_POP_OR_END,

    // 16A0
    /* 16A0 */ AI_ADD_TO_MOVE_SCORE, 1,
    /* 16A2 */ AI_POP_OR_END,

    // 16A3
    /* 16A3 */ TYPE_GROUND, TYPE_ROCK, TYPE_STEEL, AI_TABLE_END,

    // 16A7
    /* 16A7 */ AI_ADD_TO_MOVE_SCORE, 2,
    /* 16A9 */ AI_POP_OR_END,

    // 16AA
    /* 16AA */ AI_LOAD_STOCKPILE_COUNT, AI_BATTLER_ATTACKER,
    /* 16AC */ AI_IF_LOADED_LESS_THAN, 2, 5, // -> 16B4
    /* 16AF */ AI_IF_RANDOM_LESS_THAN, 80, 2, // -> 16B4
    /* 16B2 */ AI_ADD_TO_MOVE_SCORE, 2,

    // 16B4
    /* 16B4 */ AI_POP_OR_END,

    // 16B5
    /* 16B5 */ AI_IF_HP_PERCENT_LESS_THAN, AI_BATTLER_ATTACKER, 40, 29, // -> 16D6
    /* 16B9 */ AI_LOAD_CURRENT_WEATHER,
    /* 16BA */ AI_IF_LOADED_EQUAL_TO, 1, 8, // -> 16C5
    /* 16BD */ AI_IF_LOADED_EQUAL_TO, 2, 5, // -> 16C5
    /* 16C0 */ AI_IF_LOADED_EQUAL_TO, 3, 2, // -> 16C5
    /* 16C3 */ AI_GOTO, 19, // -> 16D8

    // 16C5
    /* 16C5 */ AI_ADD_TO_MOVE_SCORE, 1,
    /* 16C7 */ AI_IF_MOVE_NOT_KNOWN, AI_BATTLER_ATTACKER, MOVE_BLIZZARD, 2, // -> 16CD
    /* 16CB */ AI_ADD_TO_MOVE_SCORE, 2,

    // 16CD
    /* 16CD */ AI_LOAD_BATTLER_ABILITY, AI_BATTLER_ATTACKER,
    /* 16CF */ AI_IF_LOADED_NOT_EQUAL_TO, ABILITY_ICE_BODY, 6, // -> 16D8
    /* 16D2 */ AI_ADD_TO_MOVE_SCORE, 2,
    /* 16D4 */ AI_GOTO, 2, // -> 16D8

    // 16D6
    /* 16D6 */ AI_ADD_TO_MOVE_SCORE, -1,

    // 16D8
    /* 16D8 */ AI_POP_OR_END,

    // 16D9
    /* 16D9 */ AI_IF_NOT_STATUS, AI_BATTLER_TARGET, 0xD8, 2, // -> 16DF
    /* 16DD */ AI_ADD_TO_MOVE_SCORE, 1,

    // 16DF
    /* 16DF */ AI_POP_OR_END,

    // 16E0
    /* 16E0 */ AI_IF_MOVE_EFFECTIVENESS_EQUALS, 0, 34, // -> 1705
    /* 16E3 */ AI_IF_MOVE_EFFECTIVENESS_EQUALS, 10, 31, // -> 1705
    /* 16E6 */ AI_IF_MOVE_EFFECTIVENESS_EQUALS, 20, 28, // -> 1705
    /* 16E9 */ AI_IF_VOLATILE_STATUS, AI_BATTLER_ATTACKER, 0x1000000, -3329, // -> 09EC
    /* 16ED */ AI_IF_STATUS, AI_BATTLER_TARGET, 0x7, 27, // -> 170C
    /* 16F1 */ AI_IF_VOLATILE_STATUS, AI_BATTLER_TARGET, 0xF0000, 20, // -> 1709
    /* 16F5 */ AI_IF_VOLATILE_STATUS, AI_BATTLER_TARGET, 0x7, 16, // -> 1709
    /* 16F9 */ AI_LOAD_IS_FIRST_TURN_IN_BATTLE, AI_BATTLER_ATTACKER,
    /* 16FB */ AI_IF_LOADED_NOT_EQUAL_TO, 0, 16, // -> 170E
    /* 16FE */ AI_IF_RANDOM_LESS_THAN, 200, 13, // -> 170E
    /* 1701 */ AI_ADD_TO_MOVE_SCORE, 1,
    /* 1703 */ AI_GOTO, 9, // -> 170E

    // 1705
    /* 1705 */ AI_ADD_TO_MOVE_SCORE, -1,
    /* 1707 */ AI_GOTO, 5, // -> 170E

    // 1709
    /* 1709 */ AI_IF_RANDOM_LESS_THAN, 100, 2, // -> 170E

    // 170C
    /* 170C */ AI_ADD_TO_MOVE_SCORE, 1,

    // 170E
    /* 170E */ AI_POP_OR_END,

    // 170F
    /* 170F */ AI_IF_STATUS, AI_BATTLER_TARGET, 0x40, 2, // -> 1715
    /* 1713 */ AI_GOTO, 2, // -> 1717

    // 1715
    /* 1715 */ AI_ADD_TO_MOVE_SCORE, 1,

    // 1717
    /* 1717 */ AI_POP_OR_END,

    // 1718
    /* 1718 */ AI_LOAD_HELD_ITEM_EFFECT, AI_BATTLER_ATTACKER,
    /* 171A */ AI_IF_LOADED_IN_TABLE, 242, 16, // table 180F, -> 172D
    /* 171D */ AI_IF_LOADED_IN_TABLE, 253, 22, // table 181D, -> 1736
    /* 1720 */ AI_IF_LOADED_IN_TABLE, 252, 105, // table 181F, -> 178C
    /* 1723 */ AI_IF_LOADED_IN_TABLE, 251, 170, // table 1821, -> 17D0
    /* 1726 */ AI_IF_LOADED_IN_TABLE, 224, 213, // table 1809, -> 17FE

    // 1729
    /* 1729 */ AI_ADD_TO_MOVE_SCORE, -3,
    /* 172B */ AI_GOTO, 219, // -> 1808

    // 172D
    /* 172D */ AI_LOAD_HELD_ITEM_EFFECT, AI_BATTLER_TARGET,
    /* 172F */ AI_IF_LOADED_IN_TABLE, 263, -9, // table 1839, -> 1729
    /* 1732 */ AI_ADD_TO_MOVE_SCORE, 5,
    /* 1734 */ AI_GOTO, 210, // -> 1808

    // 1736
    /* 1736 */ AI_LOAD_HELD_ITEM_EFFECT, AI_BATTLER_TARGET,
    /* 1738 */ AI_IF_LOADED_IN_TABLE, 254, -18, // table 1839, -> 1729
    /* 173B */ AI_IF_STATUS, AI_BATTLER_TARGET, 0xFF, 35, // -> 1762
    /* 173F */ AI_IF_SIDE_CONDITION, AI_BATTLER_TARGET, 0x8, 31, // -> 1762
    /* 1743 */ AI_LOAD_TYPE_FROM, 0,
    /* 1745 */ AI_IF_LOADED_EQUAL_TO, TYPE_STEEL, 26, // -> 1762
    /* 1748 */ AI_IF_LOADED_EQUAL_TO, TYPE_POISON, 23, // -> 1762
    /* 174B */ AI_LOAD_TYPE_FROM, 2,
    /* 174D */ AI_IF_LOADED_EQUAL_TO, TYPE_STEEL, 18, // -> 1762
    /* 1750 */ AI_IF_LOADED_EQUAL_TO, TYPE_POISON, 15, // -> 1762
    /* 1753 */ AI_LOAD_BATTLER_ABILITY, AI_BATTLER_TARGET,
    /* 1755 */ AI_IF_LOADED_EQUAL_TO, ABILITY_IMMUNITY, 10, // -> 1762
    /* 1758 */ AI_IF_LOADED_EQUAL_TO, ABILITY_MAGIC_GUARD, 7, // -> 1762
    /* 175B */ AI_IF_LOADED_EQUAL_TO, ABILITY_POISON_HEAL, 4, // -> 1762
    /* 175E */ AI_ADD_TO_MOVE_SCORE, 5,
    /* 1760 */ AI_GOTO, 166, // -> 1808

    // 1762
    /* 1762 */ AI_IF_STATUS, AI_BATTLER_ATTACKER, 0xFF, -61, // -> 1729
    /* 1766 */ AI_IF_SIDE_CONDITION, AI_BATTLER_ATTACKER, 0x8, -65, // -> 1729
    /* 176A */ AI_LOAD_TYPE_FROM, 1,
    /* 176C */ AI_IF_LOADED_EQUAL_TO, TYPE_STEEL, -70, // -> 1729
    /* 176F */ AI_IF_LOADED_EQUAL_TO, TYPE_POISON, -73, // -> 1729
    /* 1772 */ AI_LOAD_TYPE_FROM, 3,
    /* 1774 */ AI_IF_LOADED_EQUAL_TO, TYPE_STEEL, -78, // -> 1729
    /* 1777 */ AI_IF_LOADED_EQUAL_TO, TYPE_POISON, -81, // -> 1729
    /* 177A */ AI_LOAD_BATTLER_ABILITY, AI_BATTLER_ATTACKER,
    /* 177C */ AI_IF_LOADED_EQUAL_TO, ABILITY_IMMUNITY, -86, // -> 1729
    /* 177F */ AI_IF_LOADED_EQUAL_TO, ABILITY_MAGIC_GUARD, -89, // -> 1729
    /* 1782 */ AI_IF_LOADED_EQUAL_TO, ABILITY_POISON_HEAL, -92, // -> 1729
    /* 1785 */ AI_IF_LOADED_EQUAL_TO, ABILITY_KLUTZ, -95, // -> 1729
    /* 1788 */ AI_ADD_TO_MOVE_SCORE, 5,
    /* 178A */ AI_GOTO, 124, // -> 1808

    // 178C
    /* 178C */ AI_LOAD_HELD_ITEM_EFFECT, AI_BATTLER_TARGET,
    /* 178E */ AI_IF_LOADED_IN_TABLE, 168, -104, // table 1839, -> 1729
    /* 1791 */ AI_LOAD_BATTLER_ABILITY, AI_BATTLER_TARGET,
    /* 1793 */ AI_IF_LOADED_EQUAL_TO, ABILITY_WATER_VEIL, 25, // -> 17AF
    /* 1796 */ AI_IF_LOADED_EQUAL_TO, ABILITY_MAGIC_GUARD, 22, // -> 17AF
    /* 1799 */ AI_IF_STATUS, AI_BATTLER_TARGET, 0xFF, 18, // -> 17AF
    /* 179D */ AI_IF_SIDE_CONDITION, AI_BATTLER_TARGET, 0x8, 14, // -> 17AF
    /* 17A1 */ AI_LOAD_TYPE_FROM, 0,
    /* 17A3 */ AI_IF_LOADED_EQUAL_TO, TYPE_FIRE, 9, // -> 17AF
    /* 17A6 */ AI_LOAD_TYPE_FROM, 2,
    /* 17A8 */ AI_IF_LOADED_EQUAL_TO, TYPE_FIRE, 4, // -> 17AF
    /* 17AB */ AI_ADD_TO_MOVE_SCORE, 5,
    /* 17AD */ AI_GOTO, 89, // -> 1808

    // 17AF
    /* 17AF */ AI_LOAD_BATTLER_ABILITY, AI_BATTLER_ATTACKER,
    /* 17B1 */ AI_IF_LOADED_EQUAL_TO, ABILITY_WATER_VEIL, -139, // -> 1729
    /* 17B4 */ AI_IF_LOADED_EQUAL_TO, ABILITY_MAGIC_GUARD, -142, // -> 1729
    /* 17B7 */ AI_IF_LOADED_EQUAL_TO, ABILITY_KLUTZ, -3561, // -> 09D1
    /* 17BA */ AI_IF_STATUS, AI_BATTLER_ATTACKER, 0xFF, -149, // -> 1729
    /* 17BE */ AI_IF_SIDE_CONDITION, AI_BATTLER_ATTACKER, 0x8, -153, // -> 1729
    /* 17C2 */ AI_LOAD_TYPE_FROM, 1,
    /* 17C4 */ AI_IF_LOADED_EQUAL_TO, TYPE_FIRE, -158, // -> 1729
    /* 17C7 */ AI_LOAD_TYPE_FROM, 3,
    /* 17C9 */ AI_IF_LOADED_EQUAL_TO, TYPE_FIRE, -163, // -> 1729
    /* 17CC */ AI_ADD_TO_MOVE_SCORE, 5,
    /* 17CE */ AI_GOTO, 56, // -> 1808

    // 17D0
    /* 17D0 */ AI_LOAD_HELD_ITEM_EFFECT, AI_BATTLER_TARGET,
    /* 17D2 */ AI_IF_LOADED_IN_TABLE, 100, -172, // table 1839, -> 1729
    /* 17D5 */ AI_LOAD_TYPE_FROM, 0,
    /* 17D7 */ AI_IF_LOADED_EQUAL_TO, TYPE_POISON, 14, // -> 17E8
    /* 17DA */ AI_LOAD_TYPE_FROM, 2,
    /* 17DC */ AI_IF_LOADED_EQUAL_TO, TYPE_POISON, 9, // -> 17E8
    /* 17DF */ AI_LOAD_BATTLER_ABILITY, AI_BATTLER_TARGET,
    /* 17E1 */ AI_IF_LOADED_EQUAL_TO, ABILITY_MAGIC_GUARD, -130, // -> 1762
    /* 17E4 */ AI_ADD_TO_MOVE_SCORE, 5,
    /* 17E6 */ AI_GOTO, 32, // -> 1808

    // 17E8
    /* 17E8 */ AI_LOAD_TYPE_FROM, 1,
    /* 17EA */ AI_IF_LOADED_EQUAL_TO, TYPE_POISON, -196, // -> 1729
    /* 17ED */ AI_LOAD_TYPE_FROM, 3,
    /* 17EF */ AI_IF_LOADED_EQUAL_TO, TYPE_POISON, -201, // -> 1729
    /* 17F2 */ AI_LOAD_BATTLER_ABILITY, AI_BATTLER_ATTACKER,
    /* 17F4 */ AI_IF_LOADED_EQUAL_TO, ABILITY_MAGIC_GUARD, -206, // -> 1729
    /* 17F7 */ AI_IF_LOADED_EQUAL_TO, ABILITY_KLUTZ, -209, // -> 1729
    /* 17FA */ AI_ADD_TO_MOVE_SCORE, 5,
    /* 17FC */ AI_GOTO, 10, // -> 1808

    // 17FE
    /* 17FE */ AI_LOAD_HELD_ITEM_EFFECT, AI_BATTLER_TARGET,
    /* 1800 */ AI_IF_LOADED_IN_TABLE, 32, -218, // table 1823, -> 1729
    /* 1803 */ AI_IF_RANDOM_LESS_THAN, 50, 2, // -> 1808
    /* 1806 */ AI_ADD_TO_MOVE_SCORE, 2,

    // 1808
    /* 1808 */ AI_POP_OR_END,

    // 1809
    /* 1809 */ HOLD_EFFECT_HP_RESTORE_SPICY, HOLD_EFFECT_HP_RESTORE_DRY,
               HOLD_EFFECT_HP_RESTORE_SWEET, HOLD_EFFECT_HP_RESTORE_BITTER,
               HOLD_EFFECT_HP_RESTORE_SOUR, AI_TABLE_END,

    // 180F
    /* 180F */ HOLD_EFFECT_CHOICE_ATK, HOLD_EFFECT_CHOICE_SPATK, HOLD_EFFECT_CHOICE_SPEED,
               HOLD_EFFECT_SPEED_DOWN_GROUNDED, HOLD_EFFECT_SPEED_DOWN,
               HOLD_EFFECT_DMG_USER_CONTACT_XFR, HOLD_EFFECT_LVLUP_ATK_EV_UP,
               HOLD_EFFECT_LVLUP_DEF_EV_UP, HOLD_EFFECT_LVLUP_SPATK_EV_UP,
               HOLD_EFFECT_LVLUP_DEF_EV_UP, HOLD_EFFECT_LVLUP_SPDEF_EV_UP,
               HOLD_EFFECT_LVLUP_SPEED_EV_UP, HOLD_EFFECT_LVLUP_HP_EV_UP, AI_TABLE_END,

    // 181D
    /* 181D */ HOLD_EFFECT_PSN_USER, AI_TABLE_END,

    // 181F
    /* 181F */ HOLD_EFFECT_BRN_USER, AI_TABLE_END,

    // 1821
    /* 1821 */ HOLD_EFFECT_HP_RESTORE_PSN_TYPE, AI_TABLE_END,

    // 1823
    /* 1823 */ HOLD_EFFECT_HP_RESTORE_SPICY, HOLD_EFFECT_HP_RESTORE_DRY,
               HOLD_EFFECT_HP_RESTORE_SWEET, HOLD_EFFECT_HP_RESTORE_BITTER,
               HOLD_EFFECT_HP_RESTORE_SOUR, HOLD_EFFECT_EVS_UP_SPEED_DOWN, HOLD_EFFECT_CHOICE_ATK,
               HOLD_EFFECT_CHOICE_SPATK, HOLD_EFFECT_CHOICE_SPEED, HOLD_EFFECT_SPEED_DOWN_GROUNDED,
               HOLD_EFFECT_SPEED_DOWN, HOLD_EFFECT_DMG_USER_CONTACT_XFR,
               HOLD_EFFECT_LVLUP_ATK_EV_UP, HOLD_EFFECT_LVLUP_DEF_EV_UP,
               HOLD_EFFECT_LVLUP_SPATK_EV_UP, HOLD_EFFECT_LVLUP_SPDEF_EV_UP,
               HOLD_EFFECT_LVLUP_SPEED_EV_UP, HOLD_EFFECT_LVLUP_HP_EV_UP, HOLD_EFFECT_PSN_USER,
               HOLD_EFFECT_BRN_USER, HOLD_EFFECT_HP_RESTORE_PSN_TYPE, AI_TABLE_END,

    // 1839
    /* 1839 */ HOLD_EFFECT_EVS_UP_SPEED_DOWN, HOLD_EFFECT_CHOICE_ATK, HOLD_EFFECT_CHOICE_SPATK,
               HOLD_EFFECT_CHOICE_SPEED, HOLD_EFFECT_SPEED_DOWN_GROUNDED, HOLD_EFFECT_SPEED_DOWN,
               HOLD_EFFECT_DMG_USER_CONTACT_XFR, HOLD_EFFECT_LVLUP_ATK_EV_UP,
               HOLD_EFFECT_LVLUP_DEF_EV_UP, HOLD_EFFECT_LVLUP_SPATK_EV_UP,
               HOLD_EFFECT_LVLUP_SPDEF_EV_UP, HOLD_EFFECT_LVLUP_SPEED_EV_UP,
               HOLD_EFFECT_LVLUP_HP_EV_UP, HOLD_EFFECT_PSN_USER, HOLD_EFFECT_BRN_USER,
               HOLD_EFFECT_HP_RESTORE_PSN_TYPE, AI_TABLE_END,

    // 184A
    /* 184A */ AI_LOAD_BATTLER_ABILITY, AI_BATTLER_ATTACKER,
    /* 184C */ AI_IF_LOADED_IN_TABLE, 15, 5, // table 185E, -> 1854
    /* 184F */ AI_LOAD_BATTLER_ABILITY, AI_BATTLER_TARGET,
    /* 1851 */ AI_IF_LOADED_IN_TABLE, 10, 4, // table 185E, -> 1858

    // 1854
    /* 1854 */ AI_ADD_TO_MOVE_SCORE, -1,
    /* 1856 */ AI_GOTO, 5, // -> 185D

    // 1858
    /* 1858 */ AI_IF_RANDOM_LESS_THAN, 50, 2, // -> 185D
    /* 185B */ AI_ADD_TO_MOVE_SCORE, 2,

    // 185D
    /* 185D */ AI_POP_OR_END,

    // 185E
    /* 185E */ ABILITY_SPEED_BOOST, ABILITY_BATTLE_ARMOR, ABILITY_SAND_VEIL, ABILITY_STATIC,
               ABILITY_FLASH_FIRE, ABILITY_WONDER_GUARD, ABILITY_EFFECT_SPORE, ABILITY_SWIFT_SWIM,
               ABILITY_HUGE_POWER, ABILITY_RAIN_DISH, ABILITY_CUTE_CHARM, ABILITY_SHED_SKIN,
               ABILITY_MARVEL_SCALE, ABILITY_PURE_POWER, ABILITY_CHLOROPHYLL, ABILITY_SHIELD_DUST,
               ABILITY_ADAPTABILITY, ABILITY_MAGIC_GUARD, ABILITY_MOLD_BREAKER, ABILITY_SUPER_LUCK,
               ABILITY_UNAWARE, ABILITY_TINTED_LENS, ABILITY_FILTER, ABILITY_SOLID_ROCK,
               ABILITY_RECKLESS, AI_TABLE_END,

    // 1878
    /* 1878 */ AI_POP_OR_END,

    // 1879
    /* 1879 */ AI_IF_MOVE_EFFECTIVENESS_EQUALS, 0, 24, // -> 1894
    /* 187C */ AI_IF_MOVE_EFFECTIVENESS_EQUALS, 10, 21, // -> 1894
    /* 187F */ AI_IF_MOVE_EFFECTIVENESS_EQUALS, 20, 18, // -> 1894
    /* 1882 */ AI_IF_STAT_STAGE_LESS_THAN, AI_BATTLER_ATTACKER, 1, 6, 13, // -> 1894
    /* 1887 */ AI_IF_SPEED_COMPARE_EQUAL_TO, 1, 6, // -> 1890
    /* 188A */ AI_IF_HP_PERCENT_GREATER_THAN, AI_BATTLER_ATTACKER, 40, 6, // -> 1894
    /* 188E */ AI_GOTO, 6, // -> 1896

    // 1890
    /* 1890 */ AI_IF_HP_PERCENT_LESS_THAN, AI_BATTLER_ATTACKER, 60, 2, // -> 1896

    // 1894
    /* 1894 */ AI_ADD_TO_MOVE_SCORE, -1,

    // 1896
    /* 1896 */ AI_POP_OR_END,

    // 1897
    /* 1897 */ AI_IF_HP_PERCENT_GREATER_THAN, AI_BATTLER_TARGET, 30, 5, // -> 18A0
    /* 189B */ AI_IF_RANDOM_LESS_THAN, 100, 2, // -> 18A0
    /* 189E */ AI_ADD_TO_MOVE_SCORE, -1,

    // 18A0
    /* 18A0 */ AI_LOAD_IS_FIRST_TURN_IN_BATTLE, AI_BATTLER_ATTACKER,
    /* 18A2 */ AI_IF_LOADED_EQUAL_TO, 0, 10, // -> 18AF
    /* 18A5 */ AI_IF_RANDOM_LESS_THAN, 150, 12, // -> 18B4
    /* 18A8 */ AI_ADD_TO_MOVE_SCORE, 1,
    /* 18AA */ AI_GOTO, 8, // -> 18B4
    // 18AC: not reached
    /* 18AC */ AI_IF_RANDOM_LESS_THAN, 50, 5, // -> 18B4

    // 18AF
    /* 18AF */ AI_IF_RANDOM_LESS_THAN, 30, 2, // -> 18B4
    /* 18B2 */ AI_ADD_TO_MOVE_SCORE, -1,

    // 18B4
    /* 18B4 */ AI_POP_OR_END,

    // 18B5
    /* 18B5 */ AI_LOAD_RECYCLE_ITEM, AI_BATTLER_ATTACKER,
    /* 18B7 */ AI_IF_LOADED_NOT_IN_TABLE, 10, 7, // table 18C4, -> 18C1
    /* 18BA */ AI_IF_RANDOM_LESS_THAN, 50, 6, // -> 18C3
    /* 18BD */ AI_ADD_TO_MOVE_SCORE, 1,
    /* 18BF */ AI_GOTO, 2, // -> 18C3

    // 18C1
    /* 18C1 */ AI_ADD_TO_MOVE_SCORE, -2,

    // 18C3
    /* 18C3 */ AI_POP_OR_END,

    // 18C4
    /* 18C4 */ ITEM_CHESTO_BERRY, ITEM_LUM_BERRY, ITEM_STARF_BERRY, AI_TABLE_END,

    // 18C8
    /* 18C8 */ AI_IF_STATUS, AI_BATTLER_TARGET, 0x7, 15, // -> 18DB
    /* 18CC */ AI_IF_VOLATILE_STATUS, AI_BATTLER_TARGET, 0xF0000, 11, // -> 18DB
    /* 18D0 */ AI_IF_VOLATILE_STATUS, AI_BATTLER_TARGET, 0x7, 7, // -> 18DB
    /* 18D4 */ AI_IF_RANDOM_LESS_THAN, 180, 4, // -> 18DB
    /* 18D7 */ AI_ADD_TO_MOVE_SCORE, 2,
    /* 18D9 */ AI_GOTO, 2, // -> 18DD

    // 18DB
    /* 18DB */ AI_ADD_TO_MOVE_SCORE, -2,

    // 18DD
    /* 18DD */ AI_POP_OR_END,

    // 18DE
    /* 18DE */ AI_IF_SIDE_CONDITION, AI_BATTLER_TARGET, 0x1, 6, // -> 18E8
    /* 18E2 */ AI_IF_SIDE_CONDITION, AI_BATTLER_TARGET, 0x2, 2, // -> 18E8
    /* 18E6 */ AI_GOTO, 2, // -> 18EA

    // 18E8
    /* 18E8 */ AI_ADD_TO_MOVE_SCORE, 1,

    // 18EA
    /* 18EA */ AI_POP_OR_END,

    // 18EB
    /* 18EB */ AI_IF_HP_PERCENT_LESS_THAN, AI_BATTLER_TARGET, 30, 10, // -> 18F9
    /* 18EF */ AI_LOAD_IS_FIRST_TURN_IN_BATTLE, AI_BATTLER_ATTACKER,
    /* 18F1 */ AI_IF_LOADED_GREATER_THAN, 0, 5, // -> 18F9
    /* 18F4 */ AI_IF_RANDOM_LESS_THAN, 180, 2, // -> 18F9
    /* 18F7 */ AI_ADD_TO_MOVE_SCORE, 1,

    // 18F9
    /* 18F9 */ AI_POP_OR_END,

    // 18FA
    /* 18FA */ AI_IF_HP_PERCENT_LESS_THAN, AI_BATTLER_TARGET, 70, 19, // -> 1911
    /* 18FE */ AI_IF_SPEED_COMPARE_EQUAL_TO, 1, 8, // -> 1909
    /* 1901 */ AI_IF_HP_PERCENT_GREATER_THAN, AI_BATTLER_ATTACKER, 40, 12, // -> 1911
    /* 1905 */ AI_ADD_TO_MOVE_SCORE, 1,
    /* 1907 */ AI_GOTO, 10, // -> 1913

    // 1909
    /* 1909 */ AI_IF_HP_PERCENT_GREATER_THAN, AI_BATTLER_ATTACKER, 50, 4, // -> 1911
    /* 190D */ AI_ADD_TO_MOVE_SCORE, 1,
    /* 190F */ AI_GOTO, 2, // -> 1913

    // 1911
    /* 1911 */ AI_ADD_TO_MOVE_SCORE, -1,

    // 1913
    /* 1913 */ AI_POP_OR_END,

    // 1914
    /* 1914 */ AI_IF_MOVE_EFFECTIVENESS_EQUALS, 0, 19, // -> 192A
    /* 1917 */ AI_IF_MOVE_EFFECTIVENESS_EQUALS, 10, 16, // -> 192A
    /* 191A */ AI_IF_MOVE_EFFECTIVENESS_EQUALS, 20, 13, // -> 192A
    /* 191D */ AI_IF_SPEED_COMPARE_EQUAL_TO, 1, 6, // -> 1926
    /* 1920 */ AI_IF_HP_PERCENT_GREATER_THAN, AI_BATTLER_TARGET, 50, 8, // -> 192C
    /* 1924 */ AI_GOTO, 4, // -> 192A

    // 1926
    /* 1926 */ AI_IF_HP_PERCENT_GREATER_THAN, AI_BATTLER_TARGET, 70, 2, // -> 192C

    // 192A
    /* 192A */ AI_ADD_TO_MOVE_SCORE, -1,

    // 192C
    /* 192C */ AI_POP_OR_END,

    // 192D
    /* 192D */ AI_LOAD_IS_FIRST_TURN_IN_BATTLE, AI_BATTLER_ATTACKER,
    /* 192F */ AI_IF_LOADED_GREATER_THAN, 0, 5, // -> 1937
    /* 1932 */ AI_IF_RANDOM_LESS_THAN, 100, 2, // -> 1937
    /* 1935 */ AI_ADD_TO_MOVE_SCORE, 2,

    // 1937
    /* 1937 */ AI_POP_OR_END,

    // 1938
    /* 1938 */ AI_IF_HP_PERCENT_LESS_THAN, AI_BATTLER_TARGET, 50, 2, // -> 193E
    /* 193C */ AI_GOTO, 2, // -> 1940

    // 193E
    /* 193E */ AI_ADD_TO_MOVE_SCORE, -1,

    // 1940
    /* 1940 */ AI_POP_OR_END,

    // 1941
    /* 1941 */ AI_LOAD_IS_FIRST_TURN_IN_BATTLE, AI_BATTLER_ATTACKER,
    /* 1943 */ AI_IF_LOADED_EQUAL_TO, 1, 33, // -> 1967
    /* 1946 */ AI_IF_RANDOM_LESS_THAN, 30, 49, // -> 197A
    /* 1949 */ AI_IF_SPEED_COMPARE_EQUAL_TO, 1, 13, // -> 1959
    /* 194C */ AI_IF_HP_PERCENT_NOT_EQUAL_TO, AI_BATTLER_ATTACKER, 100, 37, // -> 1975
    /* 1950 */ AI_IF_HP_PERCENT_LESS_THAN, AI_BATTLER_TARGET, 70, 33, // -> 1975
    /* 1954 */ AI_IF_RANDOM_LESS_THAN, 60, 35, // -> 197A
    /* 1957 */ AI_GOTO, 28, // -> 1975

    // 1959
    /* 1959 */ AI_IF_HP_PERCENT_GREATER_THAN, AI_BATTLER_TARGET, 25, 24, // -> 1975
    /* 195D */ AI_IF_MOVE_EFFECT_KNOWN, AI_BATTLER_TARGET, MOVE_EFFECT_RESTORE_HALF_HP, 6, // -> 1967
    /* 1961 */ AI_IF_MOVE_EFFECT_KNOWN, AI_BATTLER_TARGET, MOVE_EFFECT_DEF_UP_DOUBLE_ROLLOUT_POWER, 2, // -> 1967
    /* 1965 */ AI_GOTO, 7, // -> 196E

    // 1967
    /* 1967 */ AI_IF_RANDOM_LESS_THAN, 150, 16, // -> 197A
    /* 196A */ AI_ADD_TO_MOVE_SCORE, 2,
    /* 196C */ AI_GOTO, 12, // -> 197A

    // 196E
    /* 196E */ AI_IF_RANDOM_LESS_THAN, 230, 4, // -> 1975
    /* 1971 */ AI_ADD_TO_MOVE_SCORE, 1,
    /* 1973 */ AI_GOTO, 5, // -> 197A

    // 1975
    /* 1975 */ AI_IF_RANDOM_LESS_THAN, 30, 2, // -> 197A
    /* 1978 */ AI_ADD_TO_MOVE_SCORE, -2,

    // 197A
    /* 197A */ AI_POP_OR_END,

    // 197B
    /* 197B */ AI_IF_HP_PERCENT_LESS_THAN, AI_BATTLER_ATTACKER, 50, 16, // -> 198F
    /* 197F */ AI_LOAD_TYPE_FROM, 0,
    /* 1981 */ AI_IF_LOADED_EQUAL_TO, TYPE_ELECTRIC, 7, // -> 198B
    /* 1984 */ AI_LOAD_TYPE_FROM, 2,
    /* 1986 */ AI_IF_LOADED_EQUAL_TO, TYPE_ELECTRIC, 2, // -> 198B
    /* 1989 */ AI_GOTO, 4, // -> 198F

    // 198B
    /* 198B */ AI_ADD_TO_MOVE_SCORE, 1,
    /* 198D */ AI_GOTO, 2, // -> 1991

    // 198F
    /* 198F */ AI_ADD_TO_MOVE_SCORE, -1,

    // 1991
    /* 1991 */ AI_POP_OR_END,

    // 1992
    /* 1992 */ AI_IF_MOVE_EFFECTIVENESS_EQUALS, 0, 19, // -> 19A8
    /* 1995 */ AI_IF_MOVE_EFFECTIVENESS_EQUALS, 10, 16, // -> 19A8
    /* 1998 */ AI_IF_MOVE_EFFECTIVENESS_EQUALS, 20, 13, // -> 19A8
    /* 199B */ AI_IF_SPEED_COMPARE_EQUAL_TO, 1, 6, // -> 19A4
    /* 199E */ AI_IF_HP_PERCENT_GREATER_THAN, AI_BATTLER_ATTACKER, 60, 8, // -> 19AA
    /* 19A2 */ AI_GOTO, 4, // -> 19A8

    // 19A4
    /* 19A4 */ AI_IF_HP_PERCENT_GREATER_THAN, AI_BATTLER_ATTACKER, 80, 2, // -> 19AA

    // 19A8
    /* 19A8 */ AI_ADD_TO_MOVE_SCORE, -1,

    // 19AA
    /* 19AA */ AI_POP_OR_END,

    // 19AB
    /* 19AB */ AI_IF_HP_PERCENT_LESS_THAN, AI_BATTLER_ATTACKER, 50, 16, // -> 19BF
    /* 19AF */ AI_LOAD_TYPE_FROM, 0,
    /* 19B1 */ AI_IF_LOADED_EQUAL_TO, TYPE_FIRE, 7, // -> 19BB
    /* 19B4 */ AI_LOAD_TYPE_FROM, 2,
    /* 19B6 */ AI_IF_LOADED_EQUAL_TO, TYPE_FIRE, 2, // -> 19BB
    /* 19B9 */ AI_GOTO, 4, // -> 19BF

    // 19BB
    /* 19BB */ AI_ADD_TO_MOVE_SCORE, 1,
    /* 19BD */ AI_GOTO, 2, // -> 19C1

    // 19BF
    /* 19BF */ AI_ADD_TO_MOVE_SCORE, -1,

    // 19C1
    /* 19C1 */ AI_POP_OR_END,

    // 19C2
    /* 19C2 */ AI_IF_SPEED_COMPARE_EQUAL_TO, 1, 11, // -> 19D0
    /* 19C5 */ AI_IF_HP_PERCENT_GREATER_THAN, AI_BATTLER_ATTACKER, 50, 12, // -> 19D5
    /* 19C9 */ AI_IF_RANDOM_LESS_THAN, 70, 9, // -> 19D5
    /* 19CC */ AI_ADD_TO_MOVE_SCORE, -1,
    /* 19CE */ AI_GOTO, 5, // -> 19D5

    // 19D0
    /* 19D0 */ AI_IF_RANDOM_LESS_THAN, 128, 2, // -> 19D5
    /* 19D3 */ AI_ADD_TO_MOVE_SCORE, 1,

    // 19D5
    /* 19D5 */ AI_POP_OR_END,

    // 19D6
    /* 19D6 */ AI_LOAD_BATTLER_ABILITY, AI_BATTLER_TARGET,
    /* 19D8 */ AI_IF_LOADED_EQUAL_TO, ABILITY_LEVITATE, 23, // -> 19F2
    /* 19DB */ AI_IF_MOVE_EFFECT_FLAG, AI_BATTLER_TARGET, 0x8000000, 19, // -> 19F2
    /* 19DF */ AI_LOAD_TYPE_FROM, 0,
    /* 19E1 */ AI_IF_LOADED_EQUAL_TO, TYPE_FLYING, 14, // -> 19F2
    /* 19E4 */ AI_LOAD_TYPE_FROM, 2,
    /* 19E6 */ AI_IF_LOADED_EQUAL_TO, TYPE_FLYING, 9, // -> 19F2
    /* 19E9 */ AI_IF_HP_PERCENT_LESS_THAN, AI_BATTLER_ATTACKER, 60, 10, // -> 19F7
    /* 19ED */ AI_IF_RANDOM_LESS_THAN, 128, 2, // -> 19F2
    /* 19F0 */ AI_GOTO, 5, // -> 19F7

    // 19F2
    /* 19F2 */ AI_IF_RANDOM_LESS_THAN, 64, 2, // -> 19F7
    /* 19F5 */ AI_ADD_TO_MOVE_SCORE, 1,

    // 19F7
    /* 19F7 */ AI_POP_OR_END,

    // 19F8
    /* 19F8 */ AI_LOAD_TYPE_FROM, 0,
    /* 19FA */ AI_IF_LOADED_EQUAL_TO, TYPE_DARK, 13, // -> 1A0A
    /* 19FD */ AI_LOAD_TYPE_FROM, 2,
    /* 19FF */ AI_IF_LOADED_EQUAL_TO, TYPE_DARK, 8, // -> 1A0A
    /* 1A02 */ AI_IF_STAT_STAGE_GREATER_THAN, AI_BATTLER_TARGET, 7, 8, 6, // -> 1A0D
    /* 1A07 */ AI_ADD_TO_MOVE_SCORE, -2,
    /* 1A09 */ AI_POP_OR_END,

    // 1A0A
    /* 1A0A */ AI_IF_RANDOM_LESS_THAN, 80, 5, // -> 1A12

    // 1A0D
    /* 1A0D */ AI_IF_RANDOM_LESS_THAN, 80, 2, // -> 1A12
    /* 1A10 */ AI_ADD_TO_MOVE_SCORE, 2,

    // 1A12
    /* 1A12 */ AI_POP_OR_END,

    // 1A13
    /* 1A13 */ AI_IF_MOVE_EFFECTIVENESS_EQUALS, 0, 12, // -> 1A22
    /* 1A16 */ AI_IF_MOVE_EFFECTIVENESS_EQUALS, 20, 9, // -> 1A22
    /* 1A19 */ AI_IF_MOVE_EFFECTIVENESS_EQUALS, 10, 6, // -> 1A22
    /* 1A1C */ AI_IF_STATUS, AI_BATTLER_TARGET, 0x7, 6, // -> 1A26
    /* 1A20 */ AI_GOTO, 6, // -> 1A28

    // 1A22
    /* 1A22 */ AI_ADD_TO_MOVE_SCORE, -1,
    /* 1A24 */ AI_GOTO, 2, // -> 1A28

    // 1A26
    /* 1A26 */ AI_ADD_TO_MOVE_SCORE, 1,

    // 1A28
    /* 1A28 */ AI_POP_OR_END,

    // 1A29
    /* 1A29 */ AI_IF_MOVE_EFFECTIVENESS_EQUALS, 0, 11, // -> 1A37
    /* 1A2C */ AI_IF_MOVE_EFFECTIVENESS_EQUALS, 20, 8, // -> 1A37
    /* 1A2F */ AI_IF_MOVE_EFFECTIVENESS_EQUALS, 10, 5, // -> 1A37
    /* 1A32 */ AI_IF_SPEED_COMPARE_EQUAL_TO, 1, 5, // -> 1A3A
    /* 1A35 */ AI_GOTO, 5, // -> 1A3C

    // 1A37
    /* 1A37 */ AI_ADD_TO_MOVE_SCORE, -1,
    /* 1A39 */ AI_POP_OR_END,

    // 1A3A
    /* 1A3A */ AI_ADD_TO_MOVE_SCORE, 1,

    // 1A3C
    /* 1A3C */ AI_POP_OR_END,

    // 1A3D
    /* 1A3D */ AI_POP_OR_END,

    // 1A3E
    /* 1A3E */ AI_IF_MOVE_EFFECTIVENESS_EQUALS, 0, 19, // -> 1A54
    /* 1A41 */ AI_IF_MOVE_EFFECTIVENESS_EQUALS, 20, 16, // -> 1A54
    /* 1A44 */ AI_IF_MOVE_EFFECTIVENESS_EQUALS, 10, 13, // -> 1A54
    /* 1A47 */ AI_IF_HP_PERCENT_GREATER_THAN, AI_BATTLER_TARGET, 50, 11, // -> 1A56
    /* 1A4B */ AI_ADD_TO_MOVE_SCORE, 1,
    /* 1A4D */ AI_IF_RANDOM_LESS_THAN, 128, 6, // -> 1A56
    /* 1A50 */ AI_ADD_TO_MOVE_SCORE, 1,
    /* 1A52 */ AI_GOTO, 2, // -> 1A56

    // 1A54
    /* 1A54 */ AI_ADD_TO_MOVE_SCORE, -1,

    // 1A56
    /* 1A56 */ AI_POP_OR_END,

    // 1A57
    /* 1A57 */ AI_IF_MOVE_EFFECT_KNOWN, AI_BATTLER_TARGET, MOVE_EFFECT_PROTECT, 5, // -> 1A60
    /* 1A5B */ AI_IF_RANDOM_LESS_THAN, 64, 2, // -> 1A60
    /* 1A5E */ AI_GOTO, 65, // -> 1AA1

    // 1A60
    /* 1A60 */ AI_IF_STATUS, AI_BATTLER_ATTACKER, 0x80, 29, // -> 1A81
    /* 1A64 */ AI_IF_VOLATILE_STATUS, AI_BATTLER_ATTACKER, 0x10000000, 25, // -> 1A81
    /* 1A68 */ AI_IF_MOVE_EFFECT_FLAG, AI_BATTLER_ATTACKER, 0x20, 21, // -> 1A81
    /* 1A6C */ AI_IF_VOLATILE_STATUS, AI_BATTLER_ATTACKER, 0xF0000, 17, // -> 1A81
    /* 1A70 */ AI_IF_MOVE_EFFECT_FLAG, AI_BATTLER_ATTACKER, 0x4, 13, // -> 1A81
    /* 1A74 */ AI_IF_MOVE_EFFECT_FLAG, AI_BATTLER_ATTACKER, 0x1800, 9, // -> 1A81
    /* 1A78 */ AI_IF_HP_PERCENT_EQUAL_TO, AI_BATTLER_TARGET, 100, 10, // -> 1A86
    /* 1A7C */ AI_LOAD_HELD_ITEM_EFFECT, AI_BATTLER_TARGET,
    /* 1A7E */ AI_IF_LOADED_NOT_IN_TABLE, 33, 5, // table 1AA2, -> 1A86

    // 1A81
    /* 1A81 */ AI_IF_RANDOM_LESS_THAN, 128, 2, // -> 1A86
    /* 1A84 */ AI_ADD_TO_MOVE_SCORE, 1,

    // 1A86
    /* 1A86 */ AI_LOAD_PROTECT_CHAIN, AI_BATTLER_TARGET,
    /* 1A88 */ AI_IF_LOADED_EQUAL_TO, 0, 6, // -> 1A91
    /* 1A8B */ AI_IF_LOADED_EQUAL_TO, 1, 10, // -> 1A98
    /* 1A8E */ AI_IF_LOADED_GREATER_THAN, 2, 14, // -> 1A9F

    // 1A91
    /* 1A91 */ AI_IF_RANDOM_LESS_THAN, 128, 13, // -> 1AA1
    /* 1A94 */ AI_ADD_TO_MOVE_SCORE, 1,
    /* 1A96 */ AI_GOTO, 9, // -> 1AA1

    // 1A98
    /* 1A98 */ AI_IF_RANDOM_LESS_THAN, 192, 6, // -> 1AA1
    /* 1A9B */ AI_ADD_TO_MOVE_SCORE, 1,
    /* 1A9D */ AI_GOTO, 2, // -> 1AA1

    // 1A9F
    /* 1A9F */ AI_ADD_TO_MOVE_SCORE, -2,

    // 1AA1
    /* 1AA1 */ AI_POP_OR_END,

    // 1AA2
    /* 1AA2 */ HOLD_EFFECT_HP_RESTORE_GRADUAL, HOLD_EFFECT_HP_RESTORE_PSN_TYPE, AI_TABLE_END,

    // 1AA5
    /* 1AA5 */ AI_IF_MOVE_EFFECTIVENESS_EQUALS, 0, 23, // -> 1ABF
    /* 1AA8 */ AI_IF_MOVE_EFFECTIVENESS_EQUALS, 20, 20, // -> 1ABF
    /* 1AAB */ AI_IF_MOVE_EFFECTIVENESS_EQUALS, 10, 17, // -> 1ABF
    /* 1AAE */ AI_LOAD_IS_FIRST_TURN_IN_BATTLE, AI_BATTLER_ATTACKER,
    /* 1AB0 */ AI_IF_LOADED_EQUAL_TO, 0, 5, // -> 1AB8
    /* 1AB3 */ AI_IF_RANDOM_LESS_THAN, 64, 2, // -> 1AB8
    /* 1AB6 */ AI_ADD_TO_MOVE_SCORE, 1,

    // 1AB8
    /* 1AB8 */ AI_IF_RANDOM_LESS_THAN, 128, 6, // -> 1AC1
    /* 1ABB */ AI_ADD_TO_MOVE_SCORE, 1,
    /* 1ABD */ AI_GOTO, 2, // -> 1AC1

    // 1ABF
    /* 1ABF */ AI_ADD_TO_MOVE_SCORE, -1,

    // 1AC1
    /* 1AC1 */ AI_POP_OR_END,

    // 1AC2
    /* 1AC2 */ AI_IF_RANDOM_LESS_THAN, 64, 20, // -> 1AD9
    /* 1AC5 */ AI_IF_SPEED_COMPARE_EQUAL_TO, 0, 15, // -> 1AD7
    /* 1AC8 */ AI_IF_HP_PERCENT_LESS_THAN, AI_BATTLER_ATTACKER, 31, 11, // -> 1AD7
    /* 1ACC */ AI_IF_HP_PERCENT_GREATER_THAN, AI_BATTLER_ATTACKER, 75, 3, // -> 1AD3
    /* 1AD0 */ AI_IF_RANDOM_LESS_THAN, 64, 6, // -> 1AD9

    // 1AD3
    /* 1AD3 */ AI_ADD_TO_MOVE_SCORE, 1,
    /* 1AD5 */ AI_GOTO, 2, // -> 1AD9

    // 1AD7
    /* 1AD7 */ AI_ADD_TO_MOVE_SCORE, -1,

    // 1AD9
    /* 1AD9 */ AI_POP_OR_END,

    // 1ADA
    /* 1ADA */ AI_IF_HP_PERCENT_LESS_THAN, AI_BATTLER_ATTACKER, 51, 14, // -> 1AEC
    /* 1ADE */ AI_IF_HP_PERCENT_GREATER_THAN, AI_BATTLER_ATTACKER, 90, 3, // -> 1AE5
    /* 1AE2 */ AI_IF_RANDOM_LESS_THAN, 128, 9, // -> 1AEE

    // 1AE5
    /* 1AE5 */ AI_IF_RANDOM_LESS_THAN, 64, 6, // -> 1AEE
    /* 1AE8 */ AI_ADD_TO_MOVE_SCORE, 1,
    /* 1AEA */ AI_GOTO, 2, // -> 1AEE

    // 1AEC
    /* 1AEC */ AI_ADD_TO_MOVE_SCORE, -1,

    // 1AEE
    /* 1AEE */ AI_POP_OR_END,

    // 1AEF
    /* 1AEF */ AI_IF_STATUS, AI_BATTLER_TARGET, 0x7, 65, // -> 1B34
    /* 1AF3 */ AI_IF_VOLATILE_STATUS, AI_BATTLER_TARGET, 0xF0000, 61, // -> 1B34
    /* 1AF7 */ AI_IF_VOLATILE_STATUS, AI_BATTLER_TARGET, 0x7, 57, // -> 1B34
    /* 1AFB */ AI_IF_MOVE_EFFECT_KNOWN, AI_BATTLER_TARGET, 185, 53, // -> 1B34
    /* 1AFF */ AI_IF_MOVE_EFFECT_KNOWN, AI_BATTLER_TARGET, MOVE_EFFECT_HIT_LAST_WHIFF_IF_HIT, 49, // -> 1B34
    /* 1B03 */ AI_IF_MOVE_EFFECT_KNOWN, AI_BATTLER_TARGET, MOVE_EFFECT_PRIORITY_NEG_1_BYPASS_ACCURACY, 45, // -> 1B34
    /* 1B07 */ AI_IF_HP_PERCENT_GREATER_THAN, AI_BATTLER_ATTACKER, 30, 5, // -> 1B10
    /* 1B0B */ AI_IF_RANDOM_LESS_THAN, 10, 2, // -> 1B10
    /* 1B0E */ AI_ADD_TO_MOVE_SCORE, -1,

    // 1B10
    /* 1B10 */ AI_IF_HP_PERCENT_GREATER_THAN, AI_BATTLER_ATTACKER, 50, 5, // -> 1B19
    /* 1B14 */ AI_IF_RANDOM_LESS_THAN, 100, 2, // -> 1B19
    /* 1B17 */ AI_ADD_TO_MOVE_SCORE, -1,

    // 1B19
    /* 1B19 */ AI_IF_RANDOM_LESS_THAN, 192, 2, // -> 1B1E
    /* 1B1C */ AI_ADD_TO_MOVE_SCORE, 1,

    // 1B1E
    /* 1B1E */ AI_LOAD_BATTLER_PREVIOUS_MOVE, AI_BATTLER_TARGET,
    /* 1B20 */ AI_LOAD_POWER_OF_LOADED_MOVE,
    /* 1B21 */ AI_IF_LOADED_EQUAL_TO, 0, 7, // -> 1B2B
    /* 1B24 */ AI_IF_TARGET_IS_NOT_TAUNTED, 5, // -> 1B2B
    /* 1B26 */ AI_IF_RANDOM_LESS_THAN, 100, 2, // -> 1B2B
    /* 1B29 */ AI_ADD_TO_MOVE_SCORE, 1,

    // 1B2B
    /* 1B2B */ AI_IF_TARGET_IS_NOT_TAUNTED, 9, // -> 1B36
    /* 1B2D */ AI_IF_RANDOM_LESS_THAN, 100, 6, // -> 1B36
    /* 1B30 */ AI_ADD_TO_MOVE_SCORE, 1,
    /* 1B32 */ AI_GOTO, 2, // -> 1B36

    // 1B34
    /* 1B34 */ AI_ADD_TO_MOVE_SCORE, -1,

    // 1B36
    /* 1B36 */ AI_POP_OR_END,

    // 1B37
    /* 1B37 */ AI_IF_MOVE_EFFECTIVENESS_EQUALS, 0, 15, // -> 1B49
    /* 1B3A */ AI_IF_MOVE_EFFECTIVENESS_EQUALS, 10, 12, // -> 1B49
    /* 1B3D */ AI_IF_MOVE_EFFECTIVENESS_EQUALS, 20, 9, // -> 1B49
    /* 1B40 */ AI_COUNT_ALIVE_PARTY_BATTLERS, AI_BATTLER_ATTACKER,
    /* 1B42 */ AI_IF_LOADED_EQUAL_TO, 0, 54, // -> 1B7B
    /* 1B45 */ AI_IF_HAS_SUPER_EFFECTIVE_MOVE, 6, // -> 1B4D
    /* 1B47 */ AI_GOTO, 9, // -> 1B52

    // 1B49
    /* 1B49 */ AI_ADD_TO_MOVE_SCORE, -1,
    /* 1B4B */ AI_GOTO, 46, // -> 1B7B

    // 1B4D
    /* 1B4D */ AI_IF_RANDOM_LESS_THAN, 64, 2, // -> 1B52
    /* 1B50 */ AI_ADD_TO_MOVE_SCORE, -2,

    // 1B52
    /* 1B52 */ AI_IF_PARTY_MEMBER_DEALS_MORE_DAMAGE, 0, 7, // -> 1B5C
    /* 1B55 */ AI_IF_RANDOM_LESS_THAN, 64, 4, // -> 1B5C
    /* 1B58 */ AI_ADD_TO_MOVE_SCORE, -2,
    /* 1B5A */ AI_GOTO, 31, // -> 1B7B

    // 1B5C
    /* 1B5C */ AI_IF_HP_PERCENT_GREATER_THAN, AI_BATTLER_TARGET, 70, 9, // -> 1B69
    /* 1B60 */ AI_IF_HP_PERCENT_GREATER_THAN, AI_BATTLER_TARGET, 30, 10, // -> 1B6E
    /* 1B64 */ AI_IF_RANDOM_LESS_THAN, 128, 12, // -> 1B73
    /* 1B67 */ AI_GOTO, 5, // -> 1B6E

    // 1B69
    /* 1B69 */ AI_IF_RANDOM_LESS_THAN, 64, 2, // -> 1B6E
    /* 1B6C */ AI_ADD_TO_MOVE_SCORE, 1,

    // 1B6E
    /* 1B6E */ AI_IF_RANDOM_LESS_THAN, 128, 2, // -> 1B73
    /* 1B71 */ AI_ADD_TO_MOVE_SCORE, 1,

    // 1B73
    /* 1B73 */ AI_IF_SPEED_COMPARE_EQUAL_TO, 0, 3, // -> 1B79
    /* 1B76 */ AI_IF_RANDOM_LESS_THAN, 128, 2, // -> 1B7B

    // 1B79
    /* 1B79 */ AI_ADD_TO_MOVE_SCORE, 1,

    // 1B7B
    /* 1B7B */ AI_POP_OR_END,

    // 1B7C
    /* 1B7C */ AI_IF_MOVE_EFFECTIVENESS_EQUALS, 0, 19, // -> 1B92
    /* 1B7F */ AI_IF_MOVE_EFFECTIVENESS_EQUALS, 10, 16, // -> 1B92
    /* 1B82 */ AI_IF_MOVE_EFFECTIVENESS_EQUALS, 20, 13, // -> 1B92
    /* 1B85 */ AI_IF_SPEED_COMPARE_EQUAL_TO, 1, 6, // -> 1B8E
    /* 1B88 */ AI_IF_HP_PERCENT_GREATER_THAN, AI_BATTLER_ATTACKER, 60, 8, // -> 1B94
    /* 1B8C */ AI_GOTO, 4, // -> 1B92

    // 1B8E
    /* 1B8E */ AI_IF_HP_PERCENT_GREATER_THAN, AI_BATTLER_ATTACKER, 80, 2, // -> 1B94

    // 1B92
    /* 1B92 */ AI_ADD_TO_MOVE_SCORE, -1,

    // 1B94
    /* 1B94 */ AI_POP_OR_END,

    // 1B95
    /* 1B95 */ AI_IF_MOVE_EFFECTIVENESS_EQUALS, 0, 19, // -> 1BAB
    /* 1B98 */ AI_IF_MOVE_EFFECTIVENESS_EQUALS, 20, 16, // -> 1BAB
    /* 1B9B */ AI_IF_MOVE_EFFECTIVENESS_EQUALS, 10, 13, // -> 1BAB
    /* 1B9E */ AI_IF_SPEED_COMPARE_EQUAL_TO, 0, 12, // -> 1BAD
    /* 1BA1 */ AI_IF_HP_PERCENT_LESS_THAN, AI_BATTLER_ATTACKER, 30, 8, // -> 1BAD
    /* 1BA5 */ AI_IF_RANDOM_LESS_THAN, 64, 5, // -> 1BAD
    /* 1BA8 */ AI_ADD_TO_MOVE_SCORE, 1,
    /* 1BAA */ AI_POP_OR_END,

    // 1BAB
    /* 1BAB */ AI_ADD_TO_MOVE_SCORE, -1,

    // 1BAD
    /* 1BAD */ AI_POP_OR_END,

    // 1BAE
    /* 1BAE */ AI_IF_MOVE_EFFECTIVENESS_EQUALS, 0, 24, // -> 1BC9
    /* 1BB1 */ AI_IF_MOVE_EFFECTIVENESS_EQUALS, 20, 21, // -> 1BC9
    /* 1BB4 */ AI_IF_MOVE_EFFECTIVENESS_EQUALS, 10, 18, // -> 1BC9
    /* 1BB7 */ AI_IF_SPEED_COMPARE_EQUAL_TO, 0, 24, // -> 1BD2
    /* 1BBA */ AI_LOAD_BATTLER_ABILITY, AI_BATTLER_ATTACKER,
    /* 1BBC */ AI_IF_LOADED_EQUAL_TO, ABILITY_ROUGH_SKIN, 14, // -> 1BCD
    /* 1BBF */ AI_LOAD_HELD_ITEM_EFFECT, AI_BATTLER_ATTACKER,
    /* 1BC1 */ AI_IF_LOADED_IN_TABLE, 15, 9, // table 1BD3, -> 1BCD
    /* 1BC4 */ AI_IF_RANDOM_LESS_THAN, 128, 6, // -> 1BCD
    /* 1BC7 */ AI_GOTO, 9, // -> 1BD2

    // 1BC9
    /* 1BC9 */ AI_ADD_TO_MOVE_SCORE, -1,
    /* 1BCB */ AI_GOTO, 5, // -> 1BD2

    // 1BCD
    /* 1BCD */ AI_IF_RANDOM_LESS_THAN, 128, 2, // -> 1BD2
    /* 1BD0 */ AI_ADD_TO_MOVE_SCORE, 1,

    // 1BD2
    /* 1BD2 */ AI_POP_OR_END,

    // 1BD3
    /* 1BD3 */ HOLD_EFFECT_PREVENT_STAT_DROPS, HOLD_EFFECT_COPY_STAT_INCREASE, AI_TABLE_END,

    // 1BD6
    /* 1BD6 */ AI_IF_RANDOM_LESS_THAN, 128, 2, // -> 1BDB
    /* 1BD9 */ AI_ADD_TO_MOVE_SCORE, 1,

    // 1BDB
    /* 1BDB */ AI_POP_OR_END,

    // 1BDC
    /* 1BDC */ AI_IF_MOVE_EFFECTIVENESS_EQUALS, 0, 50, // -> 1C11
    /* 1BDF */ AI_IF_MOVE_EFFECTIVENESS_EQUALS, 20, 47, // -> 1C11
    /* 1BE2 */ AI_IF_MOVE_EFFECTIVENESS_EQUALS, 10, 44, // -> 1C11
    /* 1BE5 */ AI_LOAD_FLING_POWER, AI_BATTLER_ATTACKER,
    /* 1BE7 */ AI_IF_LOADED_LESS_THAN, 30, 13, // -> 1BF7
    /* 1BEA */ AI_IF_LOADED_GREATER_THAN, 90, 14, // -> 1BFB
    /* 1BED */ AI_IF_LOADED_GREATER_THAN, 60, 26, // -> 1C0A
    /* 1BF0 */ AI_IF_RANDOM_LESS_THAN, 128, 37, // -> 1C18
    /* 1BF3 */ AI_ADD_TO_MOVE_SCORE, -1,
    /* 1BF5 */ AI_GOTO, 33, // -> 1C18

    // 1BF7
    /* 1BF7 */ AI_ADD_TO_MOVE_SCORE, -2,
    /* 1BF9 */ AI_GOTO, 29, // -> 1C18

    // 1BFB
    /* 1BFB */ AI_IF_MOVE_EFFECTIVENESS_EQUALS, 80, 10, // -> 1C08
    /* 1BFE */ AI_IF_MOVE_EFFECTIVENESS_EQUALS, 160, 7, // -> 1C08
    /* 1C01 */ AI_IF_RANDOM_LESS_THAN, 128, 6, // -> 1C0A
    /* 1C04 */ AI_ADD_TO_MOVE_SCORE, 1,
    /* 1C06 */ AI_GOTO, 2, // -> 1C0A

    // 1C08
    /* 1C08 */ AI_ADD_TO_MOVE_SCORE, 4,

    // 1C0A
    /* 1C0A */ AI_IF_RANDOM_LESS_THAN, 64, 11, // -> 1C18
    /* 1C0D */ AI_ADD_TO_MOVE_SCORE, 1,
    /* 1C0F */ AI_GOTO, 7, // -> 1C18

    // 1C11
    /* 1C11 */ AI_LOAD_HELD_ITEM_EFFECT, AI_BATTLER_ATTACKER,
    /* 1C13 */ AI_IF_LOADED_IN_TABLE, 3, 2, // table 1C19, -> 1C18
    /* 1C16 */ AI_ADD_TO_MOVE_SCORE, -1,

    // 1C18
    /* 1C18 */ AI_POP_OR_END,

    // 1C19
    /* 1C19 */ HOLD_EFFECT_FLINCH_CHANCE, HOLD_EFFECT_STRENGTHEN_POISON, HOLD_EFFECT_PSN_USER,
               HOLD_EFFECT_BRN_USER, HOLD_EFFECT_PIKA_SPATK_UP, AI_TABLE_END,

    // 1C1F
    /* 1C1F */ AI_IF_NOT_STATUS, AI_BATTLER_ATTACKER, 0xFF, -4681, // -> 09DA
    /* 1C23 */ AI_IF_RANDOM_LESS_THAN, 128, 6, // -> 1C2C
    /* 1C26 */ AI_IF_HP_PERCENT_LESS_THAN, AI_BATTLER_TARGET, 30, 2, // -> 1C2C
    /* 1C2A */ AI_ADD_TO_MOVE_SCORE, 1,

    // 1C2C
    /* 1C2C */ AI_POP_OR_END,

    // 1C2D
    /* 1C2D */ AI_IF_MOVE_EFFECTIVENESS_EQUALS, 0, 61, // -> 1C6D
    /* 1C30 */ AI_IF_MOVE_EFFECTIVENESS_EQUALS, 20, 58, // -> 1C6D
    /* 1C33 */ AI_IF_MOVE_EFFECTIVENESS_EQUALS, 10, 55, // -> 1C6D
    /* 1C36 */ AI_LOAD_CURRENT_MOVE_PP,
    /* 1C37 */ AI_IF_LOADED_EQUAL_TO, 1, 47, // -> 1C69
    /* 1C3A */ AI_IF_LOADED_EQUAL_TO, 2, 35, // -> 1C60
    /* 1C3D */ AI_IF_LOADED_EQUAL_TO, 3, 34, // -> 1C62
    /* 1C40 */ AI_LOAD_BATTLER_ABILITY, AI_BATTLER_TARGET,
    /* 1C42 */ AI_IF_LOADED_NOT_EQUAL_TO, ABILITY_PRESSURE, 5, // -> 1C4A
    /* 1C45 */ AI_IF_RANDOM_LESS_THAN, 30, 2, // -> 1C4A
    /* 1C48 */ AI_ADD_TO_MOVE_SCORE, 1,

    // 1C4A
    /* 1C4A */ AI_IF_STAT_STAGE_GREATER_THAN, AI_BATTLER_TARGET, 7, 10, 17, // -> 1C60
    /* 1C4F */ AI_IF_STAT_STAGE_LESS_THAN, AI_BATTLER_ATTACKER, 6, 2, 12, // -> 1C60
    /* 1C54 */ AI_IF_STAT_STAGE_GREATER_THAN, AI_BATTLER_TARGET, 7, 8, 9, // -> 1C62
    /* 1C59 */ AI_IF_STAT_STAGE_LESS_THAN, AI_BATTLER_ATTACKER, 6, 4, 4, // -> 1C62
    /* 1C5E */ AI_GOTO, 15, // -> 1C6F

    // 1C60
    /* 1C60 */ AI_ADD_TO_MOVE_SCORE, 1,

    // 1C62
    /* 1C62 */ AI_IF_RANDOM_LESS_THAN, 100, 10, // -> 1C6F
    /* 1C65 */ AI_ADD_TO_MOVE_SCORE, 1,
    /* 1C67 */ AI_GOTO, 6, // -> 1C6F

    // 1C69
    /* 1C69 */ AI_ADD_TO_MOVE_SCORE, 3,
    /* 1C6B */ AI_GOTO, 2, // -> 1C6F

    // 1C6D
    /* 1C6D */ AI_ADD_TO_MOVE_SCORE, -1,

    // 1C6F
    /* 1C6F */ AI_POP_OR_END,

    // 1C70
    /* 1C70 */ AI_IF_MOVE_EFFECT_KNOWN, AI_BATTLER_TARGET, MOVE_EFFECT_RECOVER_DAMAGE_SLEEP, 65, // -> 1CB5
    /* 1C74 */ AI_IF_MOVE_EFFECT_KNOWN, AI_BATTLER_TARGET, MOVE_EFFECT_RESTORE_HALF_HP, 61, // -> 1CB5
    /* 1C78 */ AI_IF_MOVE_EFFECT_KNOWN, AI_BATTLER_TARGET, MOVE_EFFECT_HEAL_HALF_REMOVE_FLYING_TYPE, 57, // -> 1CB5
    /* 1C7C */ AI_IF_MOVE_EFFECT_KNOWN, AI_BATTLER_TARGET, MOVE_EFFECT_UNUSED_157, 53, // -> 1CB5
    /* 1C80 */ AI_IF_MOVE_EFFECT_KNOWN, AI_BATTLER_TARGET, MOVE_EFFECT_HEAL_HALF_MORE_IN_SUN, 49, // -> 1CB5
    /* 1C84 */ AI_IF_MOVE_EFFECT_KNOWN, AI_BATTLER_TARGET, MOVE_EFFECT_RECOVER_HEALTH_AND_SLEEP, 45, // -> 1CB5
    /* 1C88 */ AI_IF_MOVE_EFFECT_KNOWN, AI_BATTLER_TARGET, MOVE_EFFECT_SWALLOW, 41, // -> 1CB5
    /* 1C8C */ AI_IF_MOVE_EFFECT_KNOWN, AI_BATTLER_TARGET, MOVE_EFFECT_RECOVER_HALF_DAMAGE_DELT, 37, // -> 1CB5
    /* 1C90 */ AI_IF_MOVE_EFFECT_KNOWN, AI_BATTLER_TARGET, MOVE_EFFECT_GROUND_TRAP_USER_CONTINUOUS_HEAL, 33, // -> 1CB5
    /* 1C94 */ AI_IF_MOVE_EFFECT_KNOWN, AI_BATTLER_TARGET, MOVE_EFFECT_RESTORE_HP_EVERY_TURN, 29, // -> 1CB5
    /* 1C98 */ AI_IF_MOVE_EFFECT_KNOWN, AI_BATTLER_TARGET, MOVE_EFFECT_STATUS_LEECH_SEED, 25, // -> 1CB5
    /* 1C9C */ AI_IF_MOVE_EFFECT_KNOWN, AI_BATTLER_TARGET, MOVE_EFFECT_FAINT_AND_FULL_HEAL_NEXT_MON, 21, // -> 1CB5
    /* 1CA0 */ AI_IF_MOVE_EFFECT_KNOWN, AI_BATTLER_TARGET, MOVE_EFFECT_FAINT_FULL_RESTORE_NEXT_MON, 17, // -> 1CB5
    /* 1CA4 */ AI_IF_MOVE_EFFECT_FLAG, AI_BATTLER_ATTACKER, 0x4, 13, // -> 1CB5
    /* 1CA8 */ AI_IF_MOVE_EFFECT_FLAG, AI_BATTLER_TARGET, 0x1000000, 9, // -> 1CB5
    /* 1CAC */ AI_IF_MOVE_EFFECT_FLAG, AI_BATTLER_TARGET, 0x400, 5, // -> 1CB5
    /* 1CB0 */ AI_IF_RANDOM_LESS_THAN, 96, 2, // -> 1CB5
    /* 1CB3 */ AI_GOTO, 5, // -> 1CBA

    // 1CB5
    /* 1CB5 */ AI_IF_RANDOM_LESS_THAN, 25, 2, // -> 1CBA
    /* 1CB8 */ AI_ADD_TO_MOVE_SCORE, 1,

    // 1CBA
    /* 1CBA */ AI_POP_OR_END,

    // 1CBB
    /* 1CBB */ AI_IF_MOVE_EFFECTIVENESS_EQUALS, 0, 34, // -> 1CE0
    /* 1CBE */ AI_IF_MOVE_EFFECTIVENESS_EQUALS, 20, 31, // -> 1CE0
    /* 1CC1 */ AI_IF_MOVE_EFFECTIVENESS_EQUALS, 10, 28, // -> 1CE0
    /* 1CC4 */ AI_IF_HP_PERCENT_LESS_THAN, AI_BATTLER_TARGET, 50, 24, // -> 1CE0
    /* 1CC8 */ AI_IF_HP_PERCENT_EQUAL_TO, AI_BATTLER_TARGET, 100, 6, // -> 1CD2
    /* 1CCC */ AI_IF_HP_PERCENT_GREATER_THAN, AI_BATTLER_TARGET, 85, 9, // -> 1CD9
    /* 1CD0 */ AI_GOTO, 16, // -> 1CE2

    // 1CD2
    /* 1CD2 */ AI_IF_SPEED_COMPARE_EQUAL_TO, 1, 2, // -> 1CD7
    /* 1CD5 */ AI_ADD_TO_MOVE_SCORE, 1,

    // 1CD7
    /* 1CD7 */ AI_ADD_TO_MOVE_SCORE, 1,

    // 1CD9
    /* 1CD9 */ AI_IF_RANDOM_LESS_THAN, 25, 6, // -> 1CE2
    /* 1CDC */ AI_ADD_TO_MOVE_SCORE, 1,
    /* 1CDE */ AI_GOTO, 2, // -> 1CE2

    // 1CE0
    /* 1CE0 */ AI_ADD_TO_MOVE_SCORE, -1,

    // 1CE2
    /* 1CE2 */ AI_POP_OR_END,

    // 1CE3
    /* 1CE3 */ AI_IF_HP_PERCENT_GREATER_THAN, AI_BATTLER_ATTACKER, 90, 10, // -> 1CF1
    /* 1CE7 */ AI_IF_HP_PERCENT_GREATER_THAN, AI_BATTLER_ATTACKER, 60, 13, // -> 1CF8
    /* 1CEB */ AI_IF_HP_PERCENT_GREATER_THAN, AI_BATTLER_ATTACKER, 30, 16, // -> 1CFF
    /* 1CEF */ AI_GOTO, -4902, // -> 09CB

    // 1CF1
    /* 1CF1 */ AI_IF_RANDOM_LESS_THAN, 96, 18, // -> 1D06
    /* 1CF4 */ AI_ADD_TO_MOVE_SCORE, 1,
    /* 1CF6 */ AI_GOTO, 14, // -> 1D06

    // 1CF8
    /* 1CF8 */ AI_IF_RANDOM_LESS_THAN, 128, 11, // -> 1D06
    /* 1CFB */ AI_ADD_TO_MOVE_SCORE, 1,
    /* 1CFD */ AI_GOTO, 7, // -> 1D06

    // 1CFF
    /* 1CFF */ AI_IF_RANDOM_LESS_THAN, 164, 4, // -> 1D06
    /* 1D02 */ AI_ADD_TO_MOVE_SCORE, 1,
    /* 1D04 */ AI_GOTO, 0, // -> 1D06

    // 1D06
    /* 1D06 */ AI_POP_OR_END,

    // 1D07
    /* 1D07 */ AI_IF_RANDOM_LESS_THAN, 64, 23, // -> 1D21
    /* 1D0A */ AI_ADD_TO_MOVE_SCORE, 1,
    /* 1D0C */ AI_IF_HP_PERCENT_GREATER_THAN, AI_BATTLER_TARGET, 70, 17, // -> 1D21
    /* 1D10 */ AI_IF_RANDOM_LESS_THAN, 128, 2, // -> 1D15
    /* 1D13 */ AI_ADD_TO_MOVE_SCORE, -1,

    // 1D15
    /* 1D15 */ AI_IF_HP_PERCENT_GREATER_THAN, AI_BATTLER_TARGET, 50, 8, // -> 1D21
    /* 1D19 */ AI_ADD_TO_MOVE_SCORE, -1,
    /* 1D1B */ AI_IF_HP_PERCENT_GREATER_THAN, AI_BATTLER_TARGET, 30, 2, // -> 1D21
    /* 1D1F */ AI_ADD_TO_MOVE_SCORE, -1,

    // 1D21
    /* 1D21 */ AI_POP_OR_END,

    // 1D22
    /* 1D22 */ AI_IF_HP_PERCENT_LESS_THAN, AI_BATTLER_ATTACKER, 70, 21, // -> 1D3B
    /* 1D26 */ AI_IF_MOVE_EFFECT_KNOWN, AI_BATTLER_TARGET, MOVE_EFFECT_HIGH_CRITICAL, 13, // -> 1D37
    /* 1D2A */ AI_IF_MOVE_EFFECT_KNOWN, AI_BATTLER_TARGET, MOVE_EFFECT_HIGH_CRITICAL_BURN_HIT, 9, // -> 1D37
    /* 1D2E */ AI_IF_MOVE_EFFECT_KNOWN, AI_BATTLER_TARGET, MOVE_EFFECT_HIGH_CRITICAL_POISON_HIT, 5, // -> 1D37
    /* 1D32 */ AI_IF_RANDOM_LESS_THAN, 64, 2, // -> 1D37
    /* 1D35 */ AI_GOTO, 6, // -> 1D3D

    // 1D37
    /* 1D37 */ AI_ADD_TO_MOVE_SCORE, 1,
    /* 1D39 */ AI_GOTO, 2, // -> 1D3D

    // 1D3B
    /* 1D3B */ AI_ADD_TO_MOVE_SCORE, -1,

    // 1D3D
    /* 1D3D */ AI_POP_OR_END,

    // 1D3E
    /* 1D3E */ AI_IF_SPEED_COMPARE_EQUAL_TO, 1, 27, // -> 1D5C
    /* 1D41 */ AI_IF_BATTLER_DEALS_MORE_DAMAGE, AI_BATTLER_TARGET, 0, 2, // -> 1D47
    /* 1D45 */ AI_GOTO, 5, // -> 1D4C

    // 1D47
    /* 1D47 */ AI_IF_RANDOM_LESS_THAN, 32, 2, // -> 1D4C
    /* 1D4A */ AI_ADD_TO_MOVE_SCORE, 1,

    // 1D4C
    /* 1D4C */ AI_LOAD_DEFENDER_LAST_USED_MOVE_CLASS,
    /* 1D4D */ AI_IF_LOADED_EQUAL_TO, 2, 5, // -> 1D55
    /* 1D50 */ AI_IF_RANDOM_LESS_THAN, 128, 11, // -> 1D5E
    /* 1D53 */ AI_ADD_TO_MOVE_SCORE, 1,

    // 1D55
    /* 1D55 */ AI_IF_RANDOM_LESS_THAN, 64, 6, // -> 1D5E
    /* 1D58 */ AI_ADD_TO_MOVE_SCORE, 1,
    /* 1D5A */ AI_GOTO, 2, // -> 1D5E

    // 1D5C
    /* 1D5C */ AI_ADD_TO_MOVE_SCORE, -2,

    // 1D5E
    /* 1D5E */ AI_POP_OR_END,

    // 1D5F
    /* 1D5F */ AI_IF_SPEED_COMPARE_EQUAL_TO, 1, 23, // -> 1D79
    /* 1D62 */ AI_IF_BATTLER_DEALS_MORE_DAMAGE, AI_BATTLER_TARGET, 0, 12, // -> 1D72
    /* 1D66 */ AI_LOAD_BATTLER_PREVIOUS_MOVE, AI_BATTLER_TARGET,
    /* 1D68 */ AI_IF_LOADED_NOT_IN_TABLE, 29, 14, // table 1D88, -> 1D79
    /* 1D6B */ AI_IF_RANDOM_LESS_THAN, 128, 25, // -> 1D87
    /* 1D6E */ AI_ADD_TO_MOVE_SCORE, 2,
    /* 1D70 */ AI_GOTO, 21, // -> 1D87

    // 1D72
    /* 1D72 */ AI_IF_RANDOM_LESS_THAN, 32, 18, // -> 1D87
    /* 1D75 */ AI_ADD_TO_MOVE_SCORE, 2,
    /* 1D77 */ AI_GOTO, 14, // -> 1D87

    // 1D79
    /* 1D79 */ AI_IF_BATTLER_DEALS_MORE_DAMAGE, AI_BATTLER_TARGET, 0, 10, // -> 1D87
    /* 1D7D */ AI_LOAD_BATTLER_PREVIOUS_MOVE, AI_BATTLER_TARGET,
    /* 1D7F */ AI_IF_LOADED_IN_TABLE, 6, 5, // table 1D88, -> 1D87
    /* 1D82 */ AI_IF_RANDOM_LESS_THAN, 80, 2, // -> 1D87
    /* 1D85 */ AI_ADD_TO_MOVE_SCORE, -1,

    // 1D87
    /* 1D87 */ AI_POP_OR_END,

    // 1D88
    /* 1D88 */ MOVE_SLEEP_POWDER, MOVE_LOVELY_KISS, MOVE_SPORE, MOVE_HYPNOSIS, MOVE_SING,
               MOVE_GRASS_WHISTLE, MOVE_SHADOW_PUNCH, MOVE_SAND_ATTACK, MOVE_SMOKE_SCREEN,
               MOVE_TOXIC, MOVE_GUILLOTINE, MOVE_HORN_DRILL, MOVE_FISSURE, MOVE_SHEER_COLD,
               MOVE_CROSS_CHOP, MOVE_AEROBLAST, MOVE_CONFUSE_RAY, MOVE_SWEET_KISS, MOVE_SCREECH,
               MOVE_COTTON_SPORE, MOVE_SCARY_FACE, MOVE_FAKE_TEARS, MOVE_METAL_SOUND,
               MOVE_THUNDER_WAVE, MOVE_GLARE, MOVE_POISON_POWDER, MOVE_SHADOW_BALL,
               MOVE_DYNAMIC_PUNCH, MOVE_HYPER_BEAM, MOVE_EXTREME_SPEED, MOVE_THIEF, MOVE_COVET,
               MOVE_ATTRACT, MOVE_SWAGGER, MOVE_TORMENT, MOVE_FLATTER, MOVE_TRICK, MOVE_SUPERPOWER,
               MOVE_SKILL_SWAP, MOVE_PSYCHO_SHIFT, MOVE_POWER_SWAP, MOVE_GUARD_SWAP,
               MOVE_SUCKER_PUNCH, MOVE_HEART_SWAP, MOVE_SWITCHEROO, MOVE_CAPTIVATE, MOVE_DARK_VOID,
               AI_TABLE_END,

    // 1DB8
    /* 1DB8 */ AI_DIFF_STAT_STAGES, AI_BATTLER_TARGET, 1,
    /* 1DBB */ AI_IF_LOADED_GREATER_THAN, 3, 11, // -> 1DC9
    /* 1DBE */ AI_IF_LOADED_GREATER_THAN, 1, 22, // -> 1DD7
    /* 1DC1 */ AI_IF_LOADED_GREATER_THAN, 0, 33, // -> 1DE5
    /* 1DC4 */ AI_IF_LOADED_EQUAL_TO, 0, 44, // -> 1DF3
    /* 1DC7 */ AI_GOTO, 91, // -> 1E24

    // 1DC9
    /* 1DC9 */ AI_DIFF_STAT_STAGES, AI_BATTLER_TARGET, 4,
    /* 1DCC */ AI_IF_LOADED_GREATER_THAN, 3, 50, // -> 1E01
    /* 1DCF */ AI_IF_LOADED_GREATER_THAN, 1, 54, // -> 1E08
    /* 1DD2 */ AI_IF_LOADED_EQUAL_TO, 0, 58, // -> 1E0F
    /* 1DD5 */ AI_GOTO, 77, // -> 1E24

    // 1DD7
    /* 1DD7 */ AI_DIFF_STAT_STAGES, AI_BATTLER_TARGET, 4,
    /* 1DDA */ AI_IF_LOADED_GREATER_THAN, 3, 43, // -> 1E08
    /* 1DDD */ AI_IF_LOADED_GREATER_THAN, 1, 47, // -> 1E0F
    /* 1DE0 */ AI_IF_LOADED_EQUAL_TO, 0, 51, // -> 1E16
    /* 1DE3 */ AI_GOTO, 63, // -> 1E24

    // 1DE5
    /* 1DE5 */ AI_DIFF_STAT_STAGES, AI_BATTLER_TARGET, 4,
    /* 1DE8 */ AI_IF_LOADED_GREATER_THAN, 3, 36, // -> 1E0F
    /* 1DEB */ AI_IF_LOADED_GREATER_THAN, 1, 40, // -> 1E16
    /* 1DEE */ AI_IF_LOADED_EQUAL_TO, 0, 44, // -> 1E1D
    /* 1DF1 */ AI_GOTO, 49, // -> 1E24

    // 1DF3
    /* 1DF3 */ AI_DIFF_STAT_STAGES, AI_BATTLER_TARGET, 4,
    /* 1DF6 */ AI_IF_LOADED_GREATER_THAN, 3, 22, // -> 1E0F
    /* 1DF9 */ AI_IF_LOADED_GREATER_THAN, 1, 26, // -> 1E16
    /* 1DFC */ AI_IF_LOADED_GREATER_THAN, 0, 30, // -> 1E1D
    /* 1DFF */ AI_GOTO, 35, // -> 1E24

    // 1E01
    /* 1E01 */ AI_IF_RANDOM_LESS_THAN, 128, 4, // -> 1E08
    /* 1E04 */ AI_ADD_TO_MOVE_SCORE, 5,
    /* 1E06 */ AI_GOTO, 28, // -> 1E24

    // 1E08
    /* 1E08 */ AI_IF_RANDOM_LESS_THAN, 128, 4, // -> 1E0F
    /* 1E0B */ AI_ADD_TO_MOVE_SCORE, 4,
    /* 1E0D */ AI_GOTO, 21, // -> 1E24

    // 1E0F
    /* 1E0F */ AI_IF_RANDOM_LESS_THAN, 128, 4, // -> 1E16
    /* 1E12 */ AI_ADD_TO_MOVE_SCORE, 3,
    /* 1E14 */ AI_GOTO, 14, // -> 1E24

    // 1E16
    /* 1E16 */ AI_IF_RANDOM_LESS_THAN, 128, 4, // -> 1E1D
    /* 1E19 */ AI_ADD_TO_MOVE_SCORE, 2,
    /* 1E1B */ AI_GOTO, 7, // -> 1E24

    // 1E1D
    /* 1E1D */ AI_IF_RANDOM_LESS_THAN, 128, 4, // -> 1E24
    /* 1E20 */ AI_ADD_TO_MOVE_SCORE, 1,
    /* 1E22 */ AI_GOTO, 0, // -> 1E24

    // 1E24
    /* 1E24 */ AI_POP_OR_END,

    // 1E25
    /* 1E25 */ AI_DIFF_STAT_STAGES, AI_BATTLER_TARGET, 2,
    /* 1E28 */ AI_IF_LOADED_GREATER_THAN, 3, 11, // -> 1E36
    /* 1E2B */ AI_IF_LOADED_GREATER_THAN, 1, 22, // -> 1E44
    /* 1E2E */ AI_IF_LOADED_GREATER_THAN, 0, 33, // -> 1E52
    /* 1E31 */ AI_IF_LOADED_EQUAL_TO, 0, 44, // -> 1E60
    /* 1E34 */ AI_GOTO, 91, // -> 1E91

    // 1E36
    /* 1E36 */ AI_DIFF_STAT_STAGES, AI_BATTLER_TARGET, 5,
    /* 1E39 */ AI_IF_LOADED_GREATER_THAN, 3, 50, // -> 1E6E
    /* 1E3C */ AI_IF_LOADED_GREATER_THAN, 1, 54, // -> 1E75
    /* 1E3F */ AI_IF_LOADED_EQUAL_TO, 0, 58, // -> 1E7C
    /* 1E42 */ AI_GOTO, 77, // -> 1E91

    // 1E44
    /* 1E44 */ AI_DIFF_STAT_STAGES, AI_BATTLER_TARGET, 5,
    /* 1E47 */ AI_IF_LOADED_GREATER_THAN, 3, 43, // -> 1E75
    /* 1E4A */ AI_IF_LOADED_GREATER_THAN, 1, 47, // -> 1E7C
    /* 1E4D */ AI_IF_LOADED_EQUAL_TO, 0, 51, // -> 1E83
    /* 1E50 */ AI_GOTO, 63, // -> 1E91

    // 1E52
    /* 1E52 */ AI_DIFF_STAT_STAGES, AI_BATTLER_TARGET, 5,
    /* 1E55 */ AI_IF_LOADED_GREATER_THAN, 3, 36, // -> 1E7C
    /* 1E58 */ AI_IF_LOADED_GREATER_THAN, 1, 40, // -> 1E83
    /* 1E5B */ AI_IF_LOADED_EQUAL_TO, 0, 44, // -> 1E8A
    /* 1E5E */ AI_GOTO, 49, // -> 1E91

    // 1E60
    /* 1E60 */ AI_DIFF_STAT_STAGES, AI_BATTLER_TARGET, 5,
    /* 1E63 */ AI_IF_LOADED_GREATER_THAN, 3, 22, // -> 1E7C
    /* 1E66 */ AI_IF_LOADED_GREATER_THAN, 1, 26, // -> 1E83
    /* 1E69 */ AI_IF_LOADED_GREATER_THAN, 0, 30, // -> 1E8A
    /* 1E6C */ AI_GOTO, 35, // -> 1E91

    // 1E6E
    /* 1E6E */ AI_IF_RANDOM_LESS_THAN, 128, 4, // -> 1E75
    /* 1E71 */ AI_ADD_TO_MOVE_SCORE, 5,
    /* 1E73 */ AI_GOTO, 28, // -> 1E91

    // 1E75
    /* 1E75 */ AI_IF_RANDOM_LESS_THAN, 128, 4, // -> 1E7C
    /* 1E78 */ AI_ADD_TO_MOVE_SCORE, 4,
    /* 1E7A */ AI_GOTO, 21, // -> 1E91

    // 1E7C
    /* 1E7C */ AI_IF_RANDOM_LESS_THAN, 128, 4, // -> 1E83
    /* 1E7F */ AI_ADD_TO_MOVE_SCORE, 3,
    /* 1E81 */ AI_GOTO, 14, // -> 1E91

    // 1E83
    /* 1E83 */ AI_IF_RANDOM_LESS_THAN, 128, 4, // -> 1E8A
    /* 1E86 */ AI_ADD_TO_MOVE_SCORE, 2,
    /* 1E88 */ AI_GOTO, 7, // -> 1E91

    // 1E8A
    /* 1E8A */ AI_IF_RANDOM_LESS_THAN, 128, 4, // -> 1E91
    /* 1E8D */ AI_ADD_TO_MOVE_SCORE, 1,
    /* 1E8F */ AI_GOTO, 0, // -> 1E91

    // 1E91
    /* 1E91 */ AI_POP_OR_END,

    // 1E92
    /* 1E92 */ AI_IF_MOVE_EFFECTIVENESS_EQUALS, 0, 45, // -> 1EC2
    /* 1E95 */ AI_IF_MOVE_EFFECTIVENESS_EQUALS, 20, 42, // -> 1EC2
    /* 1E98 */ AI_IF_MOVE_EFFECTIVENESS_EQUALS, 10, 39, // -> 1EC2
    /* 1E9B */ AI_SUM_POSITIVE_STAT_STAGES, AI_BATTLER_TARGET,
    /* 1E9D */ AI_IF_LOADED_GREATER_THAN, 6, 14, // -> 1EAE
    /* 1EA0 */ AI_IF_LOADED_GREATER_THAN, 5, 16, // -> 1EB3
    /* 1EA3 */ AI_IF_LOADED_GREATER_THAN, 4, 18, // -> 1EB8
    /* 1EA6 */ AI_IF_LOADED_GREATER_THAN, 3, 20, // -> 1EBD
    /* 1EA9 */ AI_IF_LOADED_GREATER_THAN, 2, 17, // -> 1EBD
    /* 1EAC */ AI_GOTO, 20, // -> 1EC2

    // 1EAE
    /* 1EAE */ AI_IF_RANDOM_LESS_THAN, 128, 2, // -> 1EB3
    /* 1EB1 */ AI_ADD_TO_MOVE_SCORE, 4,

    // 1EB3
    /* 1EB3 */ AI_IF_RANDOM_LESS_THAN, 128, 2, // -> 1EB8
    /* 1EB6 */ AI_ADD_TO_MOVE_SCORE, 3,

    // 1EB8
    /* 1EB8 */ AI_IF_RANDOM_LESS_THAN, 128, 2, // -> 1EBD
    /* 1EBB */ AI_ADD_TO_MOVE_SCORE, 2,

    // 1EBD
    /* 1EBD */ AI_IF_RANDOM_LESS_THAN, 128, 2, // -> 1EC2
    /* 1EC0 */ AI_ADD_TO_MOVE_SCORE, 1,

    // 1EC2
    /* 1EC2 */ AI_POP_OR_END,

    // 1EC3
    /* 1EC3 */ AI_IF_MOVE_EFFECTIVENESS_EQUALS, 0, 11, // -> 1ED1
    /* 1EC6 */ AI_IF_MOVE_EFFECTIVENESS_EQUALS, 20, 8, // -> 1ED1
    /* 1EC9 */ AI_IF_MOVE_EFFECTIVENESS_EQUALS, 10, 5, // -> 1ED1
    /* 1ECC */ AI_IF_CAN_USE_LAST_RESORT, AI_BATTLER_ATTACKER, 6, // -> 1ED5
    /* 1ECF */ AI_GOTO, 6, // -> 1ED7

    // 1ED1
    /* 1ED1 */ AI_ADD_TO_MOVE_SCORE, -1,
    /* 1ED3 */ AI_GOTO, 2, // -> 1ED7

    // 1ED5
    /* 1ED5 */ AI_ADD_TO_MOVE_SCORE, 1,

    // 1ED7
    /* 1ED7 */ AI_POP_OR_END,

    // 1ED8
    /* 1ED8 */ AI_IF_MOVE_NOT_KNOWN, AI_BATTLER_TARGET, MOVE_REST, 2, // -> 1EDE
    /* 1EDC */ AI_ADD_TO_MOVE_SCORE, 1,

    // 1EDE
    /* 1EDE */ AI_IF_HP_PERCENT_LESS_THAN, AI_BATTLER_ATTACKER, 50, 5, // -> 1EE7
    /* 1EE2 */ AI_IF_RANDOM_LESS_THAN, 128, 2, // -> 1EE7
    /* 1EE5 */ AI_ADD_TO_MOVE_SCORE, 1,

    // 1EE7
    /* 1EE7 */ AI_IF_RANDOM_LESS_THAN, 64, 4, // -> 1EEE
    /* 1EEA */ AI_ADD_TO_MOVE_SCORE, 1,
    /* 1EEC */ AI_GOTO, 0, // -> 1EEE

    // 1EEE
    /* 1EEE */ AI_POP_OR_END,

    // 1EEF
    /* 1EEF */ AI_IF_MOVE_EFFECTIVENESS_EQUALS, 0, 13, // -> 1EFF
    /* 1EF2 */ AI_IF_MOVE_EFFECTIVENESS_EQUALS, 20, 10, // -> 1EFF
    /* 1EF5 */ AI_IF_MOVE_EFFECTIVENESS_EQUALS, 10, 7, // -> 1EFF
    /* 1EF8 */ AI_IF_RANDOM_LESS_THAN, 64, 6, // -> 1F01
    /* 1EFB */ AI_ADD_TO_MOVE_SCORE, 1,
    /* 1EFD */ AI_GOTO, 2, // -> 1F01

    // 1EFF
    /* 1EFF */ AI_ADD_TO_MOVE_SCORE, -1,

    // 1F01
    /* 1F01 */ AI_POP_OR_END,

    // 1F02
    /* 1F02 */ AI_IF_RANDOM_LESS_THAN, 128, 17, // -> 1F16
    /* 1F05 */ AI_ADD_TO_MOVE_SCORE, 1,
    /* 1F07 */ AI_IF_MOVE_KNOWN, AI_BATTLER_ATTACKER, MOVE_ROAR, 6, // -> 1F11
    /* 1F0B */ AI_IF_MOVE_KNOWN, AI_BATTLER_ATTACKER, MOVE_WHIRLWIND, 2, // -> 1F11
    /* 1F0F */ AI_GOTO, 5, // -> 1F16

    // 1F11
    /* 1F11 */ AI_IF_RANDOM_LESS_THAN, 64, 2, // -> 1F16
    /* 1F14 */ AI_ADD_TO_MOVE_SCORE, 1,

    // 1F16
    /* 1F16 */ AI_POP_OR_END,

    // 1F17
    /* 1F17 */ AI_IF_STAT_STAGE_GREATER_THAN, AI_BATTLER_TARGET, 1, 7, 26, // -> 1F36
    /* 1F1C */ AI_IF_STAT_STAGE_GREATER_THAN, AI_BATTLER_TARGET, 2, 7, 21, // -> 1F36
    /* 1F21 */ AI_IF_STAT_STAGE_GREATER_THAN, AI_BATTLER_TARGET, 4, 7, 16, // -> 1F36
    /* 1F26 */ AI_IF_STAT_STAGE_GREATER_THAN, AI_BATTLER_TARGET, 5, 7, 11, // -> 1F36
    /* 1F2B */ AI_IF_STAT_STAGE_GREATER_THAN, AI_BATTLER_TARGET, 7, 7, 6, // -> 1F36
    /* 1F30 */ AI_IF_VOLATILE_STATUS, AI_BATTLER_TARGET, 0x100000, 2, // -> 1F36
    /* 1F34 */ AI_GOTO, 39, // -> 1F5D

    // 1F36
    /* 1F36 */ AI_IF_STAT_STAGE_LESS_THAN, AI_BATTLER_ATTACKER, 1, 7, 31, // -> 1F5A
    /* 1F3B */ AI_IF_STAT_STAGE_LESS_THAN, AI_BATTLER_ATTACKER, 2, 7, 26, // -> 1F5A
    /* 1F40 */ AI_IF_STAT_STAGE_LESS_THAN, AI_BATTLER_ATTACKER, 4, 7, 21, // -> 1F5A
    /* 1F45 */ AI_IF_STAT_STAGE_LESS_THAN, AI_BATTLER_ATTACKER, 5, 7, 16, // -> 1F5A
    /* 1F4A */ AI_IF_STAT_STAGE_LESS_THAN, AI_BATTLER_ATTACKER, 7, 7, 9, // -> 1F58
    /* 1F4F */ AI_IF_NOT_VOLATILE_STATUS, AI_BATTLER_ATTACKER, 0x100000, 7, // -> 1F5A
    /* 1F53 */ AI_IF_RANDOM_LESS_THAN, 50, 9, // -> 1F5F
    /* 1F56 */ AI_GOTO, 5, // -> 1F5D

    // 1F58
    /* 1F58 */ AI_ADD_TO_MOVE_SCORE, 1,

    // 1F5A
    /* 1F5A */ AI_ADD_TO_MOVE_SCORE, 1,
    /* 1F5C */ AI_POP_OR_END,

    // 1F5D
    /* 1F5D */ AI_ADD_TO_MOVE_SCORE, -2,

    // 1F5F
    /* 1F5F */ AI_POP_OR_END,

    // 1F60
    /* 1F60 */ AI_IF_HP_PERCENT_LESS_THAN, AI_BATTLER_ATTACKER, 30, 5, // -> 1F69
    /* 1F64 */ AI_IF_RANDOM_LESS_THAN, 128, 2, // -> 1F69
    /* 1F67 */ AI_ADD_TO_MOVE_SCORE, 1,

    // 1F69
    /* 1F69 */ AI_POP_OR_END,

    // 1F6A
    /* 1F6A */ AI_IF_HP_PERCENT_LESS_THAN, AI_BATTLER_ATTACKER, 50, 31, // -> 1F8D
    /* 1F6E */ AI_IF_MOVE_KNOWN, AI_BATTLER_TARGET, MOVE_EARTHQUAKE, 10, // -> 1F7C
    /* 1F72 */ AI_IF_MOVE_KNOWN, AI_BATTLER_TARGET, MOVE_EARTH_POWER, 6, // -> 1F7C
    /* 1F76 */ AI_IF_MOVE_KNOWN, AI_BATTLER_TARGET, MOVE_FISSURE, 2, // -> 1F7C
    /* 1F7A */ AI_GOTO, 2, // -> 1F7E

    // 1F7C
    /* 1F7C */ AI_ADD_TO_MOVE_SCORE, 1,

    // 1F7E
    /* 1F7E */ AI_LOAD_TYPE_FROM, 0,
    /* 1F80 */ AI_IF_LOADED_EQUAL_TO, TYPE_GROUND, 8, // -> 1F8B
    /* 1F83 */ AI_LOAD_TYPE_FROM, 2,
    /* 1F85 */ AI_IF_LOADED_EQUAL_TO, TYPE_GROUND, 3, // -> 1F8B
    /* 1F88 */ AI_IF_RANDOM_LESS_THAN, 128, 2, // -> 1F8D

    // 1F8B
    /* 1F8B */ AI_ADD_TO_MOVE_SCORE, 1,

    // 1F8D
    /* 1F8D */ AI_POP_OR_END,
    // 1F8E: not reached
    /* 1F8E */ AI_POP_OR_END,
    /* 1F8F */ AI_POP_OR_END,
    /* 1F90 */ AI_POP_OR_END,
    /* 1F91 */ AI_POP_OR_END,

    // 1F92
    /* 1F92 */ AI_IF_SIDE_CONDITION, AI_BATTLER_TARGET, 0x2, 18, // -> 1FA8
    /* 1F96 */ AI_IF_SIDE_CONDITION, AI_BATTLER_TARGET, 0x1, 14, // -> 1FA8
    /* 1F9A */ AI_IF_SIDE_CONDITION, AI_BATTLER_TARGET, 0x4, 40, // -> 1FC6
    /* 1F9E */ AI_IF_SIDE_CONDITION, AI_BATTLER_TARGET, 0x80, 36, // -> 1FC6
    /* 1FA2 */ AI_IF_SIDE_CONDITION, AI_BATTLER_TARGET, 0x400, 32, // -> 1FC6
    /* 1FA6 */ AI_GOTO, 41, // -> 1FD1

    // 1FA8
    /* 1FA8 */ AI_IF_HP_PERCENT_GREATER_THAN, AI_BATTLER_ATTACKER, 30, 5, // -> 1FB1
    /* 1FAC */ AI_COUNT_ALIVE_PARTY_BATTLERS, AI_BATTLER_ATTACKER,
    /* 1FAE */ AI_IF_LOADED_EQUAL_TO, 0, 41, // -> 1FDA

    // 1FB1
    /* 1FB1 */ AI_ADD_TO_MOVE_SCORE, 1,
    /* 1FB3 */ AI_COUNT_ALIVE_PARTY_BATTLERS, AI_BATTLER_TARGET,
    /* 1FB5 */ AI_IF_LOADED_EQUAL_TO, 0, 45, // -> 1FE5
    /* 1FB8 */ AI_IF_SIDE_CONDITION, AI_BATTLER_TARGET, 0x4, 14, // -> 1FCA
    /* 1FBC */ AI_IF_SIDE_CONDITION, AI_BATTLER_TARGET, 0x80, 10, // -> 1FCA
    /* 1FC0 */ AI_IF_SIDE_CONDITION, AI_BATTLER_TARGET, 0x400, 6, // -> 1FCA
    /* 1FC4 */ AI_GOTO, 11, // -> 1FD1

    // 1FC6
    /* 1FC6 */ AI_ADD_TO_MOVE_SCORE, -2,
    /* 1FC8 */ AI_GOTO, 7, // -> 1FD1

    // 1FCA
    /* 1FCA */ AI_IF_RANDOM_LESS_THAN, 128, 4, // -> 1FD1
    /* 1FCD */ AI_ADD_TO_MOVE_SCORE, -1,
    /* 1FCF */ AI_GOTO, 0, // -> 1FD1

    // 1FD1
    /* 1FD1 */ AI_IF_HP_PERCENT_LESS_THAN, AI_BATTLER_ATTACKER, 70, 5, // -> 1FDA
    /* 1FD5 */ AI_IF_STAT_STAGE_GREATER_THAN, AI_BATTLER_TARGET, 7, 3, 5, // -> 1FDF

    // 1FDA
    /* 1FDA */ AI_IF_RANDOM_LESS_THAN, 50, 2, // -> 1FDF
    /* 1FDD */ AI_ADD_TO_MOVE_SCORE, -2,

    // 1FDF
    /* 1FDF */ AI_IF_HP_PERCENT_GREATER_THAN, AI_BATTLER_TARGET, 70, 2, // -> 1FE5
    /* 1FE3 */ AI_ADD_TO_MOVE_SCORE, -2,

    // 1FE5
    /* 1FE5 */ AI_POP_OR_END,

    // 1FE6
    /* 1FE6 */ AI_LOAD_BATTLE_TYPE,
    /* 1FE7 */ AI_IF_LOADED_MASK, 0x2, 21, // -> 1FFF
    /* 1FEA */ AI_IF_HP_PERCENT_GREATER_THAN, AI_BATTLER_ATTACKER, 30, 5, // -> 1FF3
    /* 1FEE */ AI_COUNT_ALIVE_PARTY_BATTLERS, AI_BATTLER_ATTACKER,
    /* 1FF0 */ AI_IF_LOADED_EQUAL_TO, 0, 12, // -> 1FFF

    // 1FF3
    /* 1FF3 */ AI_IF_SPEED_COMPARE_EQUAL_TO, 1, 4, // -> 1FFA
    /* 1FF6 */ AI_ADD_TO_MOVE_SCORE, -1,
    /* 1FF8 */ AI_GOTO, 5, // -> 1FFF

    // 1FFA
    /* 1FFA */ AI_IF_RANDOM_LESS_THAN, 64, 2, // -> 1FFF
    /* 1FFD */ AI_ADD_TO_MOVE_SCORE, 3,

    // 1FFF
    /* 1FFF */ AI_POP_OR_END,

    // 2000
    /* 2000 */ AI_IF_MOVE_EFFECTIVENESS_EQUALS, 0, 14, // -> 2011
    /* 2003 */ AI_IF_MOVE_EFFECTIVENESS_EQUALS, 20, 11, // -> 2011
    /* 2006 */ AI_IF_MOVE_EFFECTIVENESS_EQUALS, 10, 8, // -> 2011
    /* 2009 */ AI_LOAD_CURRENT_WEATHER,
    /* 200A */ AI_IF_LOADED_NOT_EQUAL_TO, 4, 9, // -> 2016
    /* 200D */ AI_ADD_TO_MOVE_SCORE, 1,
    /* 200F */ AI_GOTO, 5, // -> 2016

    // 2011
    /* 2011 */ AI_IF_RANDOM_LESS_THAN, 50, 2, // -> 2016
    /* 2014 */ AI_ADD_TO_MOVE_SCORE, -3,

    // 2016
    /* 2016 */ AI_POP_OR_END,
    // 2017: not reached
    /* 2017 */ AI_POP_OR_END,

    // 2018
    /* 2018 */ AI_IF_STAT_STAGE_EQUAL_TO, AI_BATTLER_TARGET, 4, 6, 18, // -> 202F
    /* 201D */ AI_ADD_TO_MOVE_SCORE, -1,
    /* 201F */ AI_IF_HP_PERCENT_GREATER_THAN, AI_BATTLER_ATTACKER, 90, 2, // -> 2025
    /* 2023 */ AI_ADD_TO_MOVE_SCORE, -1,

    // 2025
    /* 2025 */ AI_IF_STAT_STAGE_GREATER_THAN, AI_BATTLER_TARGET, 4, 3, 5, // -> 202F
    /* 202A */ AI_IF_RANDOM_LESS_THAN, 50, 2, // -> 202F
    /* 202D */ AI_ADD_TO_MOVE_SCORE, -2,

    // 202F
    /* 202F */ AI_IF_HP_PERCENT_GREATER_THAN, AI_BATTLER_TARGET, 70, 2, // -> 2035
    /* 2033 */ AI_ADD_TO_MOVE_SCORE, -2,

    // 2035
    /* 2035 */ AI_LOAD_DEFENDER_LAST_USED_MOVE_CLASS,
    /* 2036 */ AI_IF_LOADED_NOT_EQUAL_TO, 0, 5, // -> 203E
    /* 2039 */ AI_IF_RANDOM_LESS_THAN, 64, 2, // -> 203E
    /* 203C */ AI_ADD_TO_MOVE_SCORE, -1,

    // 203E
    /* 203E */ AI_POP_OR_END,

    // 203F
    /* 203F */ AI_IF_RANDOM_LESS_THAN, 128, 17, // -> 2053
    /* 2042 */ AI_ADD_TO_MOVE_SCORE, 1,
    /* 2044 */ AI_IF_MOVE_KNOWN, AI_BATTLER_ATTACKER, MOVE_ROAR, 6, // -> 204E
    /* 2048 */ AI_IF_MOVE_KNOWN, AI_BATTLER_ATTACKER, MOVE_WHIRLWIND, 2, // -> 204E
    /* 204C */ AI_GOTO, 5, // -> 2053

    // 204E
    /* 204E */ AI_IF_RANDOM_LESS_THAN, 64, 2, // -> 2053
    /* 2051 */ AI_ADD_TO_MOVE_SCORE, 1,

    // 2053
    /* 2053 */ AI_POP_OR_END,
    // 2054: not reached
    /* 2054 */ AI_POP_OR_END,
    /* 2055 */ AI_POP_OR_END,

    // 2056
    /* 2056 */ AI_IF_MOVE_EFFECTIVENESS_EQUALS, 0, 18, // -> 206B
    /* 2059 */ AI_IF_MOVE_EFFECTIVENESS_EQUALS, 20, 15, // -> 206B
    /* 205C */ AI_IF_MOVE_EFFECTIVENESS_EQUALS, 10, 12, // -> 206B
    /* 205F */ AI_LOAD_BATTLER_ABILITY, AI_BATTLER_ATTACKER,
    /* 2061 */ AI_IF_LOADED_EQUAL_TO, ABILITY_ROCK_HEAD, 5, // -> 2069
    /* 2064 */ AI_IF_LOADED_EQUAL_TO, ABILITY_MAGIC_GUARD, 2, // -> 2069
    /* 2067 */ AI_GOTO, 2, // -> 206B

    // 2069
    /* 2069 */ AI_ADD_TO_MOVE_SCORE, 1,

    // 206B
    /* 206B */ AI_POP_OR_END,

    // 206C
    /* 206C */ AI_IF_HP_PERCENT_LESS_THAN, AI_BATTLER_ATTACKER, 80, 8, // -> 2078
    /* 2070 */ AI_IF_SPEED_COMPARE_EQUAL_TO, 1, 5, // -> 2078
    /* 2073 */ AI_IF_RANDOM_LESS_THAN, 192, 44, // -> 20A2
    /* 2076 */ AI_GOTO, -5799, // -> 09D1

    // 2078
    /* 2078 */ AI_IF_HP_PERCENT_GREATER_THAN, AI_BATTLER_ATTACKER, 50, 33, // -> 209D
    /* 207C */ AI_IF_RANDOM_LESS_THAN, 192, 19, // -> 2092
    /* 207F */ AI_ADD_TO_MOVE_SCORE, 1,
    /* 2081 */ AI_IF_HAS_SUPER_EFFECTIVE_MOVE, 5, // -> 2088
    /* 2083 */ AI_IF_RANDOM_LESS_THAN, 192, 2, // -> 2088
    /* 2086 */ AI_ADD_TO_MOVE_SCORE, 1,

    // 2088
    /* 2088 */ AI_IF_PARTY_MEMBER_DEALS_MORE_DAMAGE, 0, 2, // -> 208D
    /* 208B */ AI_GOTO, 5, // -> 2092

    // 208D
    /* 208D */ AI_IF_RANDOM_LESS_THAN, 128, 2, // -> 2092
    /* 2090 */ AI_ADD_TO_MOVE_SCORE, 1,

    // 2092
    /* 2092 */ AI_IF_HP_PERCENT_GREATER_THAN, AI_BATTLER_ATTACKER, 30, 12, // -> 20A2
    /* 2096 */ AI_IF_RANDOM_LESS_THAN, 128, 9, // -> 20A2
    /* 2099 */ AI_ADD_TO_MOVE_SCORE, 1,
    /* 209B */ AI_GOTO, 5, // -> 20A2

    // 209D
    /* 209D */ AI_IF_RANDOM_LESS_THAN, 50, 2, // -> 20A2
    /* 20A0 */ AI_ADD_TO_MOVE_SCORE, -1,

    // 20A2
    /* 20A2 */ AI_POP_OR_END,

    // 20A3: flag 1
    /* 20A3 */ AI_IF_TARGET_IS_PARTNER, 2249, // -> 296E
    /* 20A5 */ AI_IF_CURRENT_MOVE_KILLS, 0, 31, // -> 20C7
    /* 20A8 */ AI_FLAG_MOVE_DAMAGE_SCORE, 0,
    /* 20AA */ AI_IF_LOADED_EQUAL_TO, 1, -5861, // -> 09C8
    /* 20AD */ AI_IF_CURRENT_MOVE_EFFECT_EQUAL_TO, MOVE_EFFECT_HALVE_DEFENSE, 8, // -> 20B8
    /* 20B0 */ AI_IF_CURRENT_MOVE_EFFECT_EQUAL_TO, MOVE_EFFECT_HIT_LAST_WHIFF_IF_HIT, 5, // -> 20B8
    /* 20B3 */ AI_IF_CURRENT_MOVE_EFFECT_EQUAL_TO, MOVE_EFFECT_HIT_FIRST_IF_TARGET_ATTACKING, 2, // -> 20B8
    /* 20B6 */ AI_GOTO, 5, // -> 20BD

    // 20B8
    /* 20B8 */ AI_IF_RANDOM_LESS_THAN, 51, 2, // -> 20BD
    /* 20BB */ AI_ADD_TO_MOVE_SCORE, -2,

    // 20BD
    /* 20BD */ AI_IF_MOVE_EFFECTIVENESS_EQUALS, 160, 1, // -> 20C1
    /* 20C0 */ AI_POP_OR_END,

    // 20C1
    /* 20C1 */ AI_IF_RANDOM_LESS_THAN, 80, 29, // -> 20E1
    /* 20C4 */ AI_ADD_TO_MOVE_SCORE, 2,
    /* 20C6 */ AI_POP_OR_END,

    // 20C7
    /* 20C7 */ AI_IF_CURRENT_MOVE_EFFECT_EQUAL_TO, MOVE_EFFECT_HALVE_DEFENSE, 23, // -> 20E1
    /* 20CA */ AI_IF_CURRENT_MOVE_EFFECT_EQUAL_TO, MOVE_EFFECT_HIT_LAST_WHIFF_IF_HIT, 11, // -> 20D8
    /* 20CD */ AI_IF_CURRENT_MOVE_EFFECT_EQUAL_TO, MOVE_EFFECT_HIT_FIRST_IF_TARGET_ATTACKING, 8, // -> 20D8
    /* 20D0 */ AI_IF_CURRENT_MOVE_EFFECT_EQUAL_TO, MOVE_EFFECT_HIT_IN_3_TURNS, 5, // -> 20D8
    /* 20D3 */ AI_IF_CURRENT_MOVE_EFFECT_EQUAL_TO, MOVE_EFFECT_PRIORITY_1, 7, // -> 20DD
    /* 20D6 */ AI_GOTO, 7, // -> 20DF

    // 20D8
    /* 20D8 */ AI_IF_RANDOM_LESS_THAN, 170, 6, // -> 20E1
    /* 20DB */ AI_GOTO, 2, // -> 20DF

    // 20DD
    /* 20DD */ AI_ADD_TO_MOVE_SCORE, 2,

    // 20DF
    /* 20DF */ AI_ADD_TO_MOVE_SCORE, 4,

    // 20E1
    /* 20E1 */ AI_POP_OR_END,

    // 20E2: flag 3
    /* 20E2 */ AI_IF_TARGET_IS_PARTNER, 2186, // -> 296E
    /* 20E4 */ AI_LOAD_TURN_COUNT,
    /* 20E5 */ AI_IF_LOADED_NOT_EQUAL_TO, 0, 9, // -> 20F1
    /* 20E8 */ AI_LOAD_CURRENT_MOVE_EFFECT,
    /* 20E9 */ AI_IF_LOADED_NOT_IN_TABLE, 6, 5, // table 20F2, -> 20F1
    /* 20EC */ AI_IF_RANDOM_LESS_THAN, 80, 2, // -> 20F1
    /* 20EF */ AI_ADD_TO_MOVE_SCORE, 2,

    // 20F1
    /* 20F1 */ AI_POP_OR_END,

    // 20F2
    /* 20F2 */ MOVE_EFFECT_ATK_UP, MOVE_EFFECT_DEF_UP, MOVE_EFFECT_SPEED_UP, MOVE_EFFECT_SP_ATK_UP,
               MOVE_EFFECT_SP_DEF_UP, MOVE_EFFECT_ACC_UP, MOVE_EFFECT_EVA_UP, MOVE_EFFECT_ATK_DOWN,
               MOVE_EFFECT_DEF_DOWN, MOVE_EFFECT_SPEED_DOWN, MOVE_EFFECT_SP_ATK_DOWN,
               MOVE_EFFECT_SP_DEF_DOWN, MOVE_EFFECT_ACC_DOWN, MOVE_EFFECT_EVA_DOWN,
               MOVE_EFFECT_CONVERSION, MOVE_EFFECT_SET_LIGHT_SCREEN, MOVE_EFFECT_SP_DEF_UP_2,
               MOVE_EFFECT_CRIT_UP_2, MOVE_EFFECT_STATUS_CONFUSE, MOVE_EFFECT_ATK_UP_2,
               MOVE_EFFECT_DEF_UP_2, MOVE_EFFECT_SPEED_UP_2, MOVE_EFFECT_SP_ATK_UP_2,
               MOVE_EFFECT_SP_DEF_UP_2, MOVE_EFFECT_ACC_UP_2, MOVE_EFFECT_EVA_UP_2,
               MOVE_EFFECT_ATK_DOWN_2, MOVE_EFFECT_DEF_DOWN_2, MOVE_EFFECT_SPEED_DOWN_2,
               MOVE_EFFECT_SP_ATK_DOWN_2, MOVE_EFFECT_SP_DEF_DOWN_2, MOVE_EFFECT_ACC_DOWN_2,
               MOVE_EFFECT_EVA_DOWN_2, MOVE_EFFECT_SET_REFLECT, MOVE_EFFECT_STATUS_POISON,
               MOVE_EFFECT_STATUS_PARALYZE, MOVE_EFFECT_SET_SUBSTITUTE,
               MOVE_EFFECT_STATUS_LEECH_SEED, MOVE_EFFECT_EVA_UP_2_MINIMIZE, MOVE_EFFECT_CURSE,
               MOVE_EFFECT_ATK_UP_2_STATUS_CONFUSION, MOVE_EFFECT_CAMOUFLAGE,
               MOVE_EFFECT_STATUS_SLEEP_NEXT_TURN, MOVE_EFFECT_DEF_UP_DOUBLE_ROLLOUT_POWER,
               MOVE_EFFECT_TORMENT, MOVE_EFFECT_SP_ATK_UP_CAUSE_CONFUSION, MOVE_EFFECT_STATUS_BURN,
               MOVE_EFFECT_GROUND_TRAP_USER_CONTINUOUS_HEAL,
               MOVE_EFFECT_MAKE_SHARED_MOVES_UNUSEABL, 199, MOVE_EFFECT_ATK_DEF_DOWN,
               MOVE_EFFECT_DEF_SPD_UP, MOVE_EFFECT_ATK_DEF_UP, MOVE_EFFECT_SP_ATK_SP_DEF_UP,
               MOVE_EFFECT_CAMOUFLAGE, MOVE_EFFECT_DOUBLE_SPEED_3_TURNS,
               MOVE_EFFECT_RANDOM_STAT_UP_2, MOVE_EFFECT_PREVENT_CRITS,
               MOVE_EFFECT_GIVE_GROUND_IMMUNITY, MOVE_EFFECT_REMOVE_HAZARDS_SCREENS_EVA_DOWN,
               MOVE_EFFECT_WHIRLPOOL, AI_TABLE_END,

    // 2130: flag 5
    /* 2130 */ AI_IF_TARGET_IS_PARTNER, 2108, // -> 296E
    /* 2132 */ AI_FLAG_MOVE_DAMAGE_SCORE, 0,
    /* 2134 */ AI_IF_LOADED_NOT_EQUAL_TO, 0, 5, // -> 213C
    /* 2137 */ AI_IF_RANDOM_LESS_THAN, 100, 2, // -> 213C
    /* 213A */ AI_ADD_TO_MOVE_SCORE, 2,

    // 213C
    /* 213C */ AI_POP_OR_END,

    // 213D: flag 4
    /* 213D */ AI_IF_TARGET_IS_PARTNER, 2095, // -> 296E
    /* 213F */ AI_LOAD_CURRENT_MOVE_EFFECT,
    /* 2140 */ AI_IF_LOADED_NOT_IN_TABLE, 6, 5, // table 2149, -> 2148
    /* 2143 */ AI_IF_RANDOM_LESS_THAN, 128, 2, // -> 2148
    /* 2146 */ AI_ADD_TO_MOVE_SCORE, 2,

    // 2148
    /* 2148 */ AI_POP_OR_END,

    // 2149
    /* 2149 */ MOVE_EFFECT_STATUS_SLEEP, MOVE_EFFECT_HALVE_DEFENSE, MOVE_EFFECT_COPY_MOVE,
               MOVE_EFFECT_ONE_HIT_KO, MOVE_EFFECT_HIGH_CRITICAL, MOVE_EFFECT_STATUS_CONFUSE,
               MOVE_EFFECT_CALL_RANDOM_MOVE, MOVE_EFFECT_RANDOM_DAMAGE_1_TO_150_LEVEL,
               MOVE_EFFECT_COUNTER, MOVE_EFFECT_KO_MON_THAT_DEFEATED_USER,
               MOVE_EFFECT_ATK_UP_2_STATUS_CONFUSION, MOVE_EFFECT_INFATUATE,
               MOVE_EFFECT_RANDOM_POWER_MAYBE_HEAL, MOVE_EFFECT_RAISE_ALL_STATS_HIT,
               MOVE_EFFECT_MAX_ATK_LOSE_HALF_MAX_HP, MOVE_EFFECT_MIRROR_COAT,
               MOVE_EFFECT_HIT_LAST_WHIFF_IF_HIT, 185, 199, MOVE_EFFECT_POWER_BASED_ON_LOW_SPEED,
               MOVE_EFFECT_RANDOM_STAT_UP_2, MOVE_EFFECT_METAL_BURST,
               MOVE_EFFECT_DOUBLE_POWER_IF_HIT, MOVE_EFFECT_USE_MOVE_FIRST,
               MOVE_EFFECT_HIT_FIRST_IF_TARGET_ATTACKING, AI_TABLE_END,

    // 2163: flag 6
    /* 2163 */ AI_IF_TARGET_IS_PARTNER, 2057, // -> 296E
    /* 2165 */ AI_COUNT_ALIVE_PARTY_BATTLERS, AI_BATTLER_ATTACKER,
    /* 2167 */ AI_IF_LOADED_EQUAL_TO, 0, 91, // -> 21C5
    /* 216A */ AI_FLAG_MOVE_DAMAGE_SCORE, 0,
    /* 216C */ AI_IF_LOADED_NOT_EQUAL_TO, 0, 86, // -> 21C5
    /* 216F */ AI_IF_MOVE_EFFECT_KNOWN, AI_BATTLER_ATTACKER, MOVE_EFFECT_PASS_STATS_AND_STATUS, 3, // -> 2176
    /* 2173 */ AI_IF_RANDOM_LESS_THAN, 80, -46, // -> 2148

    // 2176
    /* 2176 */ AI_IF_MOVE_EQUAL_TO, MOVE_SWORDS_DANCE, 20, // -> 218D
    /* 2179 */ AI_IF_MOVE_EQUAL_TO, MOVE_DRAGON_DANCE, 17, // -> 218D
    /* 217C */ AI_IF_MOVE_EQUAL_TO, MOVE_CALM_MIND, 14, // -> 218D
    /* 217F */ AI_IF_MOVE_EQUAL_TO, MOVE_NASTY_PLOT, 11, // -> 218D
    /* 2182 */ AI_IF_CURRENT_MOVE_EFFECT_EQUAL_TO, MOVE_EFFECT_PROTECT, 18, // -> 2197
    /* 2185 */ AI_IF_MOVE_EQUAL_TO, MOVE_BATON_PASS, 26, // -> 21A2
    /* 2188 */ AI_IF_RANDOM_LESS_THAN, 20, -67, // -> 2148
    /* 218B */ AI_ADD_TO_MOVE_SCORE, 3,

    // 218D
    /* 218D */ AI_LOAD_TURN_COUNT,
    /* 218E */ AI_IF_LOADED_EQUAL_TO, 0, -6053, // -> 09EC
    /* 2191 */ AI_IF_HP_PERCENT_LESS_THAN, AI_BATTLER_ATTACKER, 60, -6075, // -> 09DA
    /* 2195 */ AI_GOTO, -6068, // -> 09E3

    // 2197
    /* 2197 */ AI_LOAD_BATTLER_PREVIOUS_MOVE, AI_BATTLER_ATTACKER,
    /* 2199 */ AI_IF_LOADED_IN_TABLE, 3, -6097, // table 219F, -> 09CB
    /* 219C */ AI_ADD_TO_MOVE_SCORE, 2,
    /* 219E */ AI_POP_OR_END,

    // 219F
    /* 219F */ MOVE_PROTECT, MOVE_DETECT, AI_TABLE_END,

    // 21A2
    /* 21A2 */ AI_LOAD_TURN_COUNT,
    /* 21A3 */ AI_IF_LOADED_EQUAL_TO, 0, -6107, // -> 09CB
    /* 21A6 */ AI_IF_STAT_STAGE_GREATER_THAN, AI_BATTLER_ATTACKER, 1, 8, -6082, // -> 09E9
    /* 21AB */ AI_IF_STAT_STAGE_GREATER_THAN, AI_BATTLER_ATTACKER, 1, 7, -6090, // -> 09E6
    /* 21B0 */ AI_IF_STAT_STAGE_GREATER_THAN, AI_BATTLER_ATTACKER, 1, 6, -6098, // -> 09E3
    /* 21B5 */ AI_IF_STAT_STAGE_GREATER_THAN, AI_BATTLER_ATTACKER, 4, 8, -6097, // -> 09E9
    /* 21BA */ AI_IF_STAT_STAGE_GREATER_THAN, AI_BATTLER_ATTACKER, 4, 7, -6105, // -> 09E6
    /* 21BF */ AI_IF_STAT_STAGE_GREATER_THAN, AI_BATTLER_ATTACKER, 4, 6, -6113, // -> 09E3
    /* 21C4 */ AI_POP_OR_END,

    // 21C5
    /* 21C5 */ AI_POP_OR_END,

    // 21C6: flag 7
    /* 21C6 */ AI_IF_TARGET_IS_PARTNER, 1010, // -> 25BA
    /* 21C8 */ AI_FLAG_MOVE_DAMAGE_SCORE, 0,
    /* 21CA */ AI_IF_LOADED_EQUAL_TO, 0, 113, // -> 223E
    /* 21CD */ AI_IF_CURRENT_MOVE_EFFECT_EQUAL_TO, MOVE_EFFECT_ONE_HIT_KO, 48, // -> 2200
    /* 21D0 */ AI_IF_CURRENT_MOVE_EFFECT_EQUAL_TO, MOVE_EFFECT_40_DAMAGE_FLAT, 45, // -> 2200
    /* 21D3 */ AI_IF_CURRENT_MOVE_EFFECT_EQUAL_TO, MOVE_EFFECT_LEVEL_DAMAGE_FLAT, 42, // -> 2200
    /* 21D6 */ AI_IF_CURRENT_MOVE_EFFECT_EQUAL_TO, MOVE_EFFECT_RANDOM_DAMAGE_1_TO_150_LEVEL, 39, // -> 2200
    /* 21D9 */ AI_IF_CURRENT_MOVE_EFFECT_EQUAL_TO, MOVE_EFFECT_10_DAMAGE_FLAT, 36, // -> 2200
    /* 21DC */ AI_IF_MOVE_EFFECTIVENESS_EQUALS, 20, 5, // -> 21E4
    /* 21DF */ AI_IF_MOVE_EFFECTIVENESS_EQUALS, 10, 16, // -> 21F2
    /* 21E2 */ AI_GOTO, 28, // -> 2200

    // 21E4
    /* 21E4 */ AI_IF_CURRENT_MOVE_KILLS, 0, 25, // -> 2200
    /* 21E7 */ AI_IF_HP_PERCENT_EQUAL_TO, AI_BATTLER_TARGET_PARTNER, 0, 21, // -> 2200
    /* 21EB */ AI_IF_RANDOM_LESS_THAN, 64, 18, // -> 2200
    /* 21EE */ AI_ADD_TO_MOVE_SCORE, -1,
    /* 21F0 */ AI_GOTO, 14, // -> 2200

    // 21F2
    /* 21F2 */ AI_IF_CURRENT_MOVE_KILLS, 0, 11, // -> 2200
    /* 21F5 */ AI_IF_HP_PERCENT_EQUAL_TO, AI_BATTLER_TARGET_PARTNER, 0, 7, // -> 2200
    /* 21F9 */ AI_IF_RANDOM_LESS_THAN, 64, 4, // -> 2200
    /* 21FC */ AI_ADD_TO_MOVE_SCORE, -2,
    /* 21FE */ AI_GOTO, 0, // -> 2200

    // 2200
    /* 2200 */ AI_CHECK_IF_HIGHEST_DAMAGE_WITH_PARTNER, 0,
    /* 2202 */ AI_IF_LOADED_NOT_EQUAL_TO, 2, 20, // -> 2219
    /* 2205 */ AI_IF_CURRENT_MOVE_EFFECT_EQUAL_TO, MOVE_EFFECT_HALVE_DEFENSE, 54, // -> 223E
    /* 2208 */ AI_IF_CURRENT_MOVE_EFFECT_EQUAL_TO, MOVE_EFFECT_PRIORITY_1, 7, // -> 2212
    /* 220B */ AI_IF_RANDOM_LESS_THAN, 128, 11, // -> 2219
    /* 220E */ AI_ADD_TO_MOVE_SCORE, 1,
    /* 2210 */ AI_GOTO, 44, // -> 223E

    // 2212
    /* 2212 */ AI_IF_RANDOM_LESS_THAN, 50, 4, // -> 2219
    /* 2215 */ AI_ADD_TO_MOVE_SCORE, 1,
    /* 2217 */ AI_GOTO, 37, // -> 223E

    // 2219
    /* 2219 */ AI_IF_CURRENT_MOVE_EFFECT_EQUAL_TO, MOVE_EFFECT_ONE_HIT_KO, 34, // -> 223E
    /* 221C */ AI_IF_CURRENT_MOVE_EFFECT_EQUAL_TO, MOVE_EFFECT_40_DAMAGE_FLAT, 31, // -> 223E
    /* 221F */ AI_IF_CURRENT_MOVE_EFFECT_EQUAL_TO, MOVE_EFFECT_LEVEL_DAMAGE_FLAT, 28, // -> 223E
    /* 2222 */ AI_IF_CURRENT_MOVE_EFFECT_EQUAL_TO, MOVE_EFFECT_RANDOM_DAMAGE_1_TO_150_LEVEL, 25, // -> 223E
    /* 2225 */ AI_IF_CURRENT_MOVE_EFFECT_EQUAL_TO, MOVE_EFFECT_10_DAMAGE_FLAT, 22, // -> 223E
    /* 2228 */ AI_IF_MOVE_EFFECTIVENESS_EQUALS, 80, 5, // -> 2230
    /* 222B */ AI_IF_MOVE_EFFECTIVENESS_EQUALS, 160, 9, // -> 2237
    /* 222E */ AI_GOTO, 14, // -> 223E

    // 2230
    /* 2230 */ AI_IF_RANDOM_LESS_THAN, 100, 11, // -> 223E
    /* 2233 */ AI_ADD_TO_MOVE_SCORE, 1,
    /* 2235 */ AI_GOTO, 7, // -> 223E

    // 2237
    /* 2237 */ AI_IF_RANDOM_LESS_THAN, 64, 4, // -> 223E
    /* 223A */ AI_ADD_TO_MOVE_SCORE, 1,
    /* 223C */ AI_GOTO, 0, // -> 223E

    // 223E
    /* 223E */ AI_IF_MOVE_EQUAL_TO, MOVE_SKILL_SWAP, 686, // -> 24EF
    /* 2241 */ AI_LOAD_TYPE_FROM, 4,
    /* 2243 */ AI_IF_MOVE_EQUAL_TO, MOVE_EARTHQUAKE, 565, // -> 247B
    /* 2246 */ AI_IF_MOVE_EQUAL_TO, MOVE_MAGNITUDE, 562, // -> 247B
    /* 2249 */ AI_IF_MOVE_EQUAL_TO, MOVE_FUTURE_SIGHT, 601, // -> 24A5
    /* 224C */ AI_IF_MOVE_EQUAL_TO, MOVE_DOOM_DESIRE, 598, // -> 24A5
    /* 224F */ AI_IF_MOVE_EQUAL_TO, MOVE_RAIN_DANCE, 34, // -> 2274
    /* 2252 */ AI_IF_MOVE_EQUAL_TO, MOVE_SUNNY_DAY, 72, // -> 229D
    /* 2255 */ AI_IF_MOVE_EQUAL_TO, MOVE_HAIL, 166, // -> 22FE
    /* 2258 */ AI_IF_MOVE_EQUAL_TO, MOVE_SANDSTORM, 200, // -> 2323
    /* 225B */ AI_IF_MOVE_EQUAL_TO, MOVE_GRAVITY, 239, // -> 234D
    /* 225E */ AI_IF_MOVE_EQUAL_TO, MOVE_TRICK_ROOM, 334, // -> 23AF
    /* 2261 */ AI_IF_MOVE_EQUAL_TO, MOVE_FOLLOW_ME, 403, // -> 23F7
    /* 2264 */ AI_LOAD_TYPE_FROM, 4,
    /* 2266 */ AI_IF_LOADED_EQUAL_TO, TYPE_ELECTRIC, 684, // -> 2515
    /* 2269 */ AI_IF_LOADED_EQUAL_TO, TYPE_FIRE, 795, // -> 2587
    /* 226C */ AI_IF_LOADED_EQUAL_TO, TYPE_WATER, 743, // -> 2556
    /* 226F */ AI_IF_MOVE_KNOWN, AI_BATTLER_ATTACKER_PARTNER, MOVE_HELPING_HAND, 483, // -> 2456
    /* 2273 */ AI_POP_OR_END,

    // 2274
    /* 2274 */ AI_LOAD_BATTLER_ABILITY, AI_BATTLER_ATTACKER,
    /* 2276 */ AI_IF_LOADED_EQUAL_TO, ABILITY_HYDRATION, 5, // -> 227E
    /* 2279 */ AI_IF_LOADED_EQUAL_TO, ABILITY_DRY_SKIN, 6, // -> 2282
    /* 227C */ AI_GOTO, 8, // -> 2286

    // 227E
    /* 227E */ AI_IF_NOT_STATUS, AI_BATTLER_ATTACKER, 0xFF, 4, // -> 2286

    // 2282
    /* 2282 */ AI_ADD_TO_MOVE_SCORE, 2,
    /* 2284 */ AI_GOTO, 0, // -> 2286

    // 2286
    /* 2286 */ AI_CHECK_BATTLER_ABILITY, AI_BATTLER_ATTACKER_PARTNER, ABILITY_HYDRATION,
    /* 2289 */ AI_IF_LOADED_EQUAL_TO, 1, 8, // -> 2294
    /* 228C */ AI_CHECK_BATTLER_ABILITY, AI_BATTLER_ATTACKER_PARTNER, ABILITY_DRY_SKIN,
    /* 228F */ AI_IF_LOADED_EQUAL_TO, 1, 6, // -> 2298
    /* 2292 */ AI_GOTO, 8, // -> 229C

    // 2294
    /* 2294 */ AI_IF_NOT_STATUS, AI_BATTLER_ATTACKER_PARTNER, 0xFF, 4, // -> 229C

    // 2298
    /* 2298 */ AI_ADD_TO_MOVE_SCORE, 2,
    /* 229A */ AI_GOTO, 0, // -> 229C

    // 229C
    /* 229C */ AI_POP_OR_END,

    // 229D
    /* 229D */ AI_LOAD_BATTLER_ABILITY, AI_BATTLER_ATTACKER,
    /* 229F */ AI_IF_LOADED_EQUAL_TO, ABILITY_LEAF_GUARD, 11, // -> 22AD
    /* 22A2 */ AI_IF_LOADED_EQUAL_TO, ABILITY_FLOWER_GIFT, 16, // -> 22B5
    /* 22A5 */ AI_IF_LOADED_EQUAL_TO, ABILITY_DRY_SKIN, 17, // -> 22B9
    /* 22A8 */ AI_IF_LOADED_EQUAL_TO, ABILITY_SOLAR_POWER, 18, // -> 22BD
    /* 22AB */ AI_GOTO, 27, // -> 22C8

    // 22AD
    /* 22AD */ AI_IF_STATUS, AI_BATTLER_ATTACKER, 0xFF, 23, // -> 22C8
    /* 22B1 */ AI_IF_HP_PERCENT_LESS_THAN, AI_BATTLER_ATTACKER, 30, 19, // -> 22C8

    // 22B5
    /* 22B5 */ AI_ADD_TO_MOVE_SCORE, 2,
    /* 22B7 */ AI_GOTO, 15, // -> 22C8

    // 22B9
    /* 22B9 */ AI_ADD_TO_MOVE_SCORE, -2,
    /* 22BB */ AI_GOTO, 11, // -> 22C8

    // 22BD
    /* 22BD */ AI_IF_HP_PERCENT_LESS_THAN, AI_BATTLER_ATTACKER, 50, 2, // -> 22C3
    /* 22C1 */ AI_ADD_TO_MOVE_SCORE, 1,

    // 22C3
    /* 22C3 */ AI_IF_RANDOM_LESS_THAN, 128, 2, // -> 22C8
    /* 22C6 */ AI_ADD_TO_MOVE_SCORE, -2,

    // 22C8
    /* 22C8 */ AI_CHECK_BATTLER_ABILITY, AI_BATTLER_ATTACKER_PARTNER, ABILITY_LEAF_GUARD,
    /* 22CB */ AI_IF_LOADED_EQUAL_TO, 1, 20, // -> 22E2
    /* 22CE */ AI_CHECK_BATTLER_ABILITY, AI_BATTLER_ATTACKER_PARTNER, ABILITY_FLOWER_GIFT,
    /* 22D1 */ AI_IF_LOADED_EQUAL_TO, 1, 22, // -> 22EA
    /* 22D4 */ AI_CHECK_BATTLER_ABILITY, AI_BATTLER_ATTACKER_PARTNER, ABILITY_DRY_SKIN,
    /* 22D7 */ AI_IF_LOADED_EQUAL_TO, 1, 20, // -> 22EE
    /* 22DA */ AI_CHECK_BATTLER_ABILITY, AI_BATTLER_ATTACKER_PARTNER, ABILITY_SOLAR_POWER,
    /* 22DD */ AI_IF_LOADED_EQUAL_TO, 1, 18, // -> 22F2
    /* 22E0 */ AI_GOTO, 27, // -> 22FD

    // 22E2
    /* 22E2 */ AI_IF_STATUS, AI_BATTLER_ATTACKER_PARTNER, 0xFF, 23, // -> 22FD
    /* 22E6 */ AI_IF_HP_PERCENT_LESS_THAN, AI_BATTLER_ATTACKER_PARTNER, 30, 19, // -> 22FD

    // 22EA
    /* 22EA */ AI_ADD_TO_MOVE_SCORE, 2,
    /* 22EC */ AI_GOTO, 15, // -> 22FD

    // 22EE
    /* 22EE */ AI_ADD_TO_MOVE_SCORE, -2,
    /* 22F0 */ AI_GOTO, 11, // -> 22FD

    // 22F2
    /* 22F2 */ AI_IF_HP_PERCENT_LESS_THAN, AI_BATTLER_ATTACKER_PARTNER, 50, 2, // -> 22F8
    /* 22F6 */ AI_ADD_TO_MOVE_SCORE, 1,

    // 22F8
    /* 22F8 */ AI_IF_RANDOM_LESS_THAN, 128, 2, // -> 22FD
    /* 22FB */ AI_ADD_TO_MOVE_SCORE, -2,

    // 22FD
    /* 22FD */ AI_POP_OR_END,

    // 22FE
    /* 22FE */ AI_LOAD_BATTLER_ABILITY, AI_BATTLER_ATTACKER,
    /* 2300 */ AI_IF_LOADED_EQUAL_TO, ABILITY_ICE_BODY, 9, // -> 230C
    /* 2303 */ AI_IF_LOADED_EQUAL_TO, ABILITY_SNOW_CLOAK, 6, // -> 230C
    /* 2306 */ AI_IF_MOVE_KNOWN, AI_BATTLER_ATTACKER, MOVE_BLIZZARD, 2, // -> 230C
    /* 230A */ AI_GOTO, 2, // -> 230E

    // 230C
    /* 230C */ AI_ADD_TO_MOVE_SCORE, 2,

    // 230E
    /* 230E */ AI_CHECK_BATTLER_ABILITY, AI_BATTLER_ATTACKER_PARTNER, ABILITY_ICE_BODY,
    /* 2311 */ AI_IF_LOADED_EQUAL_TO, 1, 12, // -> 2320
    /* 2314 */ AI_CHECK_BATTLER_ABILITY, AI_BATTLER_ATTACKER_PARTNER, ABILITY_SNOW_CLOAK,
    /* 2317 */ AI_IF_LOADED_EQUAL_TO, 1, 6, // -> 2320
    /* 231A */ AI_IF_MOVE_KNOWN, AI_BATTLER_ATTACKER_PARTNER, MOVE_BLIZZARD, 2, // -> 2320
    /* 231E */ AI_GOTO, 2, // -> 2322

    // 2320
    /* 2320 */ AI_ADD_TO_MOVE_SCORE, 2,

    // 2322
    /* 2322 */ AI_POP_OR_END,

    // 2323
    /* 2323 */ AI_LOAD_BATTLER_ABILITY, AI_BATTLER_ATTACKER,
    /* 2325 */ AI_IF_LOADED_EQUAL_TO, ABILITY_SAND_VEIL, 12, // -> 2334
    /* 2328 */ AI_LOAD_TYPE_FROM, 1,
    /* 232A */ AI_IF_LOADED_EQUAL_TO, TYPE_ROCK, 7, // -> 2334
    /* 232D */ AI_LOAD_TYPE_FROM, 3,
    /* 232F */ AI_IF_LOADED_EQUAL_TO, TYPE_ROCK, 2, // -> 2334
    /* 2332 */ AI_GOTO, 4, // -> 2338

    // 2334
    /* 2334 */ AI_ADD_TO_MOVE_SCORE, 2,
    /* 2336 */ AI_GOTO, 0, // -> 2338

    // 2338
    /* 2338 */ AI_CHECK_BATTLER_ABILITY, AI_BATTLER_ATTACKER_PARTNER, ABILITY_SAND_VEIL,
    /* 233B */ AI_IF_LOADED_EQUAL_TO, 1, 12, // -> 234A
    /* 233E */ AI_LOAD_TYPE_FROM, 6,
    /* 2340 */ AI_IF_LOADED_EQUAL_TO, TYPE_ROCK, 7, // -> 234A
    /* 2343 */ AI_LOAD_TYPE_FROM, 8,
    /* 2345 */ AI_IF_LOADED_EQUAL_TO, TYPE_ROCK, 2, // -> 234A
    /* 2348 */ AI_GOTO, 2, // -> 234C

    // 234A
    /* 234A */ AI_ADD_TO_MOVE_SCORE, 2,

    // 234C
    /* 234C */ AI_POP_OR_END,

    // 234D
    /* 234D */ AI_IF_FIELD_CONDITIONS_MASK, 0x7000, 1143, // -> 27C7
    /* 2350 */ AI_CHECK_BATTLER_ABILITY, AI_BATTLER_ATTACKER, ABILITY_LEVITATE,
    /* 2353 */ AI_IF_LOADED_EQUAL_TO, 1, 12, // -> 2362
    /* 2356 */ AI_FLAG_BATTLER_IS_TYPE, AI_BATTLER_ATTACKER, TYPE_FLYING,
    /* 2359 */ AI_IF_LOADED_EQUAL_TO, 1, 6, // -> 2362
    /* 235C */ AI_IF_MOVE_EFFECT_FLAG, AI_BATTLER_ATTACKER, 0x8000000, 2, // -> 2362
    /* 2360 */ AI_GOTO, 4, // -> 2366

    // 2362
    /* 2362 */ AI_ADD_TO_MOVE_SCORE, -5,
    /* 2364 */ AI_GOTO, 0, // -> 2366

    // 2366
    /* 2366 */ AI_CHECK_BATTLER_ABILITY, AI_BATTLER_ATTACKER_PARTNER, ABILITY_LEVITATE,
    /* 2369 */ AI_IF_LOADED_EQUAL_TO, 1, 12, // -> 2378
    /* 236C */ AI_FLAG_BATTLER_IS_TYPE, AI_BATTLER_ATTACKER_PARTNER, TYPE_FLYING,
    /* 236F */ AI_IF_LOADED_EQUAL_TO, 1, 6, // -> 2378
    /* 2372 */ AI_IF_MOVE_EFFECT_FLAG, AI_BATTLER_ATTACKER_PARTNER, 0x8000000, 2, // -> 2378
    /* 2376 */ AI_GOTO, 4, // -> 237C

    // 2378
    /* 2378 */ AI_ADD_TO_MOVE_SCORE, -5,
    /* 237A */ AI_GOTO, 0, // -> 237C

    // 237C
    /* 237C */ AI_CHECK_BATTLER_ABILITY, AI_BATTLER_TARGET, ABILITY_LEVITATE,
    /* 237F */ AI_IF_LOADED_EQUAL_TO, 1, 12, // -> 238E
    /* 2382 */ AI_FLAG_BATTLER_IS_TYPE, AI_BATTLER_TARGET, TYPE_FLYING,
    /* 2385 */ AI_IF_LOADED_EQUAL_TO, 1, 6, // -> 238E
    /* 2388 */ AI_IF_MOVE_EFFECT_FLAG, AI_BATTLER_TARGET, 0x8000000, 2, // -> 238E
    /* 238C */ AI_GOTO, 7, // -> 2395

    // 238E
    /* 238E */ AI_IF_RANDOM_LESS_THAN, 64, 4, // -> 2395
    /* 2391 */ AI_ADD_TO_MOVE_SCORE, 3,
    /* 2393 */ AI_GOTO, 0, // -> 2395

    // 2395
    /* 2395 */ AI_CHECK_BATTLER_ABILITY, AI_BATTLER_TARGET_PARTNER, ABILITY_LEVITATE,
    /* 2398 */ AI_IF_LOADED_EQUAL_TO, 1, 12, // -> 23A7
    /* 239B */ AI_FLAG_BATTLER_IS_TYPE, AI_BATTLER_TARGET_PARTNER, TYPE_FLYING,
    /* 239E */ AI_IF_LOADED_EQUAL_TO, 1, 6, // -> 23A7
    /* 23A1 */ AI_IF_MOVE_EFFECT_FLAG, AI_BATTLER_TARGET_PARTNER, 0x8000000, 2, // -> 23A7
    /* 23A5 */ AI_GOTO, 7, // -> 23AE

    // 23A7
    /* 23A7 */ AI_IF_RANDOM_LESS_THAN, 64, 4, // -> 23AE
    /* 23AA */ AI_ADD_TO_MOVE_SCORE, 3,
    /* 23AC */ AI_GOTO, 0, // -> 23AE

    // 23AE
    /* 23AE */ AI_POP_OR_END,

    // 23AF
    /* 23AF */ AI_IF_HP_PERCENT_EQUAL_TO, AI_BATTLER_ATTACKER_PARTNER, 0, -6611, // -> 09E0
    /* 23B3 */ AI_IF_HP_PERCENT_EQUAL_TO, AI_BATTLER_TARGET_PARTNER, 0, -6615, // -> 09E0
    /* 23B7 */ AI_IF_HP_PERCENT_EQUAL_TO, AI_BATTLER_TARGET, 0, -6619, // -> 09E0
    /* 23BB */ AI_LOAD_BATTLER_SPEED_RANK, AI_BATTLER_ATTACKER,
    /* 23BD */ AI_IF_LOADED_EQUAL_TO, 0, 11, // -> 23CB
    /* 23C0 */ AI_IF_LOADED_EQUAL_TO, 1, 18, // -> 23D5
    /* 23C3 */ AI_IF_LOADED_EQUAL_TO, 2, 22, // -> 23DC
    /* 23C6 */ AI_IF_LOADED_EQUAL_TO, 3, 31, // -> 23E8
    /* 23C9 */ AI_GOTO, 43, // -> 23F6

    // 23CB
    /* 23CB */ AI_LOAD_BATTLER_SPEED_RANK, AI_BATTLER_ATTACKER_PARTNER,
    /* 23CD */ AI_IF_LOADED_EQUAL_TO, 1, -6640, // -> 09E0
    /* 23D0 */ AI_IF_LOADED_EQUAL_TO, 0, -6643, // -> 09E0
    /* 23D3 */ AI_GOTO, 31, // -> 23F4

    // 23D5
    /* 23D5 */ AI_LOAD_BATTLER_SPEED_RANK, AI_BATTLER_ATTACKER_PARTNER,
    /* 23D7 */ AI_IF_LOADED_EQUAL_TO, 0, -6650, // -> 09E0
    /* 23DA */ AI_GOTO, 24, // -> 23F4

    // 23DC
    /* 23DC */ AI_LOAD_BATTLER_SPEED_RANK, AI_BATTLER_ATTACKER_PARTNER,
    /* 23DE */ AI_IF_LOADED_NOT_EQUAL_TO, 3, 19, // -> 23F4
    /* 23E1 */ AI_IF_RANDOM_LESS_THAN, 64, 16, // -> 23F4
    /* 23E4 */ AI_ADD_TO_MOVE_SCORE, 5,
    /* 23E6 */ AI_GOTO, 14, // -> 23F6

    // 23E8
    /* 23E8 */ AI_LOAD_BATTLER_SPEED_RANK, AI_BATTLER_ATTACKER_PARTNER,
    /* 23EA */ AI_IF_LOADED_NOT_EQUAL_TO, 2, 7, // -> 23F4
    /* 23ED */ AI_IF_RANDOM_LESS_THAN, 64, 4, // -> 23F4
    /* 23F0 */ AI_ADD_TO_MOVE_SCORE, 5,
    /* 23F2 */ AI_GOTO, 2, // -> 23F6

    // 23F4
    /* 23F4 */ AI_ADD_TO_MOVE_SCORE, -5,

    // 23F6
    /* 23F6 */ AI_POP_OR_END,

    // 23F7
    /* 23F7 */ AI_IF_HP_PERCENT_GREATER_THAN, AI_BATTLER_ATTACKER, 90, 13, // -> 2408
    /* 23FB */ AI_IF_HP_PERCENT_GREATER_THAN, AI_BATTLER_ATTACKER, 50, 23, // -> 2416
    /* 23FF */ AI_IF_HP_PERCENT_GREATER_THAN, AI_BATTLER_ATTACKER, 30, 33, // -> 2424
    /* 2403 */ AI_IF_RANDOM_LESS_THAN, 64, 79, // -> 2455
    /* 2406 */ AI_GOTO, -6711, // -> 09D1

    // 2408
    /* 2408 */ AI_IF_HP_PERCENT_GREATER_THAN, AI_BATTLER_ATTACKER_PARTNER, 90, 38, // -> 2432
    /* 240C */ AI_IF_HP_PERCENT_GREATER_THAN, AI_BATTLER_ATTACKER_PARTNER, 50, 48, // -> 2440
    /* 2410 */ AI_IF_HP_PERCENT_GREATER_THAN, AI_BATTLER_ATTACKER_PARTNER, 30, 51, // -> 2447
    /* 2414 */ AI_GOTO, 56, // -> 244E

    // 2416
    /* 2416 */ AI_IF_HP_PERCENT_GREATER_THAN, AI_BATTLER_ATTACKER_PARTNER, 90, 31, // -> 2439
    /* 241A */ AI_IF_HP_PERCENT_GREATER_THAN, AI_BATTLER_ATTACKER_PARTNER, 50, 20, // -> 2432
    /* 241E */ AI_IF_HP_PERCENT_GREATER_THAN, AI_BATTLER_ATTACKER_PARTNER, 30, 30, // -> 2440
    /* 2422 */ AI_GOTO, 35, // -> 2447

    // 2424
    /* 2424 */ AI_IF_HP_PERCENT_GREATER_THAN, AI_BATTLER_ATTACKER_PARTNER, 90, 17, // -> 2439
    /* 2428 */ AI_IF_HP_PERCENT_GREATER_THAN, AI_BATTLER_ATTACKER_PARTNER, 50, 13, // -> 2439
    /* 242C */ AI_IF_HP_PERCENT_GREATER_THAN, AI_BATTLER_ATTACKER_PARTNER, 30, 16, // -> 2440
    /* 2430 */ AI_GOTO, 21, // -> 2447

    // 2432
    /* 2432 */ AI_IF_RANDOM_LESS_THAN, 64, 32, // -> 2455
    /* 2435 */ AI_ADD_TO_MOVE_SCORE, -1,
    /* 2437 */ AI_GOTO, 28, // -> 2455

    // 2439
    /* 2439 */ AI_IF_RANDOM_LESS_THAN, 64, 25, // -> 2455
    /* 243C */ AI_ADD_TO_MOVE_SCORE, -2,
    /* 243E */ AI_GOTO, 21, // -> 2455

    // 2440
    /* 2440 */ AI_IF_RANDOM_LESS_THAN, 64, 18, // -> 2455
    /* 2443 */ AI_ADD_TO_MOVE_SCORE, 1,
    /* 2445 */ AI_GOTO, 14, // -> 2455

    // 2447
    /* 2447 */ AI_IF_RANDOM_LESS_THAN, 64, 11, // -> 2455
    /* 244A */ AI_ADD_TO_MOVE_SCORE, 2,
    /* 244C */ AI_GOTO, 7, // -> 2455

    // 244E
    /* 244E */ AI_IF_RANDOM_LESS_THAN, 64, 4, // -> 2455
    /* 2451 */ AI_ADD_TO_MOVE_SCORE, 3,
    /* 2453 */ AI_GOTO, 0, // -> 2455

    // 2455
    /* 2455 */ AI_POP_OR_END,

    // 2456
    /* 2456 */ AI_IF_CURRENT_MOVE_EFFECT_EQUAL_TO, MOVE_EFFECT_ONE_HIT_KO, 17, // -> 246A
    /* 2459 */ AI_IF_CURRENT_MOVE_EFFECT_EQUAL_TO, MOVE_EFFECT_40_DAMAGE_FLAT, 14, // -> 246A
    /* 245C */ AI_IF_CURRENT_MOVE_EFFECT_EQUAL_TO, MOVE_EFFECT_LEVEL_DAMAGE_FLAT, 11, // -> 246A
    /* 245F */ AI_IF_CURRENT_MOVE_EFFECT_EQUAL_TO, MOVE_EFFECT_RANDOM_DAMAGE_1_TO_150_LEVEL, 8, // -> 246A
    /* 2462 */ AI_IF_CURRENT_MOVE_EFFECT_EQUAL_TO, MOVE_EFFECT_10_DAMAGE_FLAT, 5, // -> 246A
    /* 2465 */ AI_FLAG_MOVE_DAMAGE_SCORE, 0,
    /* 2467 */ AI_IF_LOADED_NOT_EQUAL_TO, 0, -6791, // -> 09E3

    // 246A
    /* 246A */ AI_POP_OR_END,
    // 246B: not reached
    /* 246B */ AI_IF_STATUS, AI_BATTLER_ATTACKER, 0xFF, 1, // -> 2470
    /* 246F */ AI_POP_OR_END,
    /* 2470 */ AI_FLAG_MOVE_DAMAGE_SCORE, 0,
    /* 2472 */ AI_IF_LOADED_EQUAL_TO, 0, -6820, // -> 09D1
    /* 2475 */ AI_ADD_TO_MOVE_SCORE, 1,
    /* 2477 */ AI_IF_LOADED_EQUAL_TO, 2, -6804, // -> 09E6
    /* 247A */ AI_POP_OR_END,

    // 247B
    /* 247B */ AI_IF_MOVE_EFFECT_FLAG, AI_BATTLER_ATTACKER_PARTNER, 0x8000000, -6809, // -> 09E6
    /* 247F */ AI_CHECK_BATTLER_ABILITY, AI_BATTLER_ATTACKER_PARTNER, ABILITY_LEVITATE,
    /* 2482 */ AI_IF_LOADED_EQUAL_TO, 1, -6815, // -> 09E6
    /* 2485 */ AI_FLAG_BATTLER_IS_TYPE, AI_BATTLER_ATTACKER_PARTNER, TYPE_FLYING,
    /* 2488 */ AI_IF_LOADED_EQUAL_TO, 1, -6821, // -> 09E6
    /* 248B */ AI_FLAG_BATTLER_IS_TYPE, AI_BATTLER_ATTACKER_PARTNER, TYPE_FIRE,
    /* 248E */ AI_IF_LOADED_EQUAL_TO, 1, -6839, // -> 09DA
    /* 2491 */ AI_FLAG_BATTLER_IS_TYPE, AI_BATTLER_ATTACKER_PARTNER, TYPE_ELECTRIC,
    /* 2494 */ AI_IF_LOADED_EQUAL_TO, 1, -6845, // -> 09DA
    /* 2497 */ AI_FLAG_BATTLER_IS_TYPE, AI_BATTLER_ATTACKER_PARTNER, TYPE_POISON,
    /* 249A */ AI_IF_LOADED_EQUAL_TO, 1, -6851, // -> 09DA
    /* 249D */ AI_FLAG_BATTLER_IS_TYPE, AI_BATTLER_ATTACKER_PARTNER, TYPE_ROCK,
    /* 24A0 */ AI_IF_LOADED_EQUAL_TO, 1, -6857, // -> 09DA
    /* 24A3 */ AI_GOTO, -6871, // -> 09CE

    // 24A5
    /* 24A5 */ AI_IF_HP_PERCENT_EQUAL_TO, AI_BATTLER_ATTACKER_PARTNER, 0, 69, // -> 24EE
    /* 24A9 */ AI_IF_MOVE_KNOWN, AI_BATTLER_ATTACKER_PARTNER, MOVE_FUTURE_SIGHT, 6, // -> 24B3
    /* 24AD */ AI_IF_MOVE_KNOWN, AI_BATTLER_ATTACKER_PARTNER, MOVE_DOOM_DESIRE, 2, // -> 24B3
    /* 24B1 */ AI_GOTO, 59, // -> 24EE

    // 24B3
    /* 24B3 */ AI_LOAD_BATTLER_SPEED_RANK, AI_BATTLER_ATTACKER,
    /* 24B5 */ AI_IF_LOADED_EQUAL_TO, 3, -6890, // -> 09CE
    /* 24B8 */ AI_IF_LOADED_EQUAL_TO, 2, 8, // -> 24C3
    /* 24BB */ AI_IF_LOADED_EQUAL_TO, 1, 23, // -> 24D5
    /* 24BE */ AI_IF_LOADED_EQUAL_TO, 0, 35, // -> 24E4
    /* 24C1 */ AI_GOTO, 43, // -> 24EE

    // 24C3
    /* 24C3 */ AI_LOAD_BATTLER_SPEED_RANK, AI_BATTLER_ATTACKER_PARTNER,
    /* 24C5 */ AI_IF_LOADED_EQUAL_TO, 0, -6906, // -> 09CE
    /* 24C8 */ AI_IF_LOADED_EQUAL_TO, 1, -6909, // -> 09CE
    /* 24CB */ AI_IF_RANDOM_LESS_THAN, 128, 32, // -> 24EE
    /* 24CE */ AI_LOAD_BATTLER_SPEED_RANK, AI_BATTLER_ATTACKER_PARTNER,
    /* 24D0 */ AI_IF_LOADED_EQUAL_TO, 2, -6917, // -> 09CE
    /* 24D3 */ AI_GOTO, 25, // -> 24EE

    // 24D5
    /* 24D5 */ AI_LOAD_BATTLER_SPEED_RANK, AI_BATTLER_ATTACKER_PARTNER,
    /* 24D7 */ AI_IF_LOADED_EQUAL_TO, 0, -6924, // -> 09CE
    /* 24DA */ AI_IF_RANDOM_LESS_THAN, 128, 17, // -> 24EE
    /* 24DD */ AI_LOAD_BATTLER_SPEED_RANK, AI_BATTLER_ATTACKER_PARTNER,
    /* 24DF */ AI_IF_LOADED_EQUAL_TO, 1, -6932, // -> 09CE
    /* 24E2 */ AI_GOTO, 10, // -> 24EE

    // 24E4
    /* 24E4 */ AI_IF_RANDOM_LESS_THAN, 128, 7, // -> 24EE
    /* 24E7 */ AI_LOAD_BATTLER_SPEED_RANK, AI_BATTLER_ATTACKER_PARTNER,
    /* 24E9 */ AI_IF_LOADED_EQUAL_TO, 0, -6942, // -> 09CE
    /* 24EC */ AI_GOTO, 0, // -> 24EE

    // 24EE
    /* 24EE */ AI_POP_OR_END,

    // 24EF
    /* 24EF */ AI_LOAD_BATTLER_ABILITY, AI_BATTLER_ATTACKER,
    /* 24F1 */ AI_IF_LOADED_EQUAL_TO, ABILITY_TRUANT, -6920, // -> 09EC
    /* 24F4 */ AI_IF_LOADED_EQUAL_TO, ABILITY_SLOW_START, -6923, // -> 09EC
    /* 24F7 */ AI_IF_LOADED_EQUAL_TO, ABILITY_STALL, -6926, // -> 09EC
    /* 24FA */ AI_IF_LOADED_EQUAL_TO, ABILITY_KLUTZ, -6929, // -> 09EC
    /* 24FD */ AI_LOAD_BATTLER_ABILITY, AI_BATTLER_TARGET,
    /* 24FF */ AI_IF_LOADED_EQUAL_TO, ABILITY_SHADOW_TAG, -6940, // -> 09E6
    /* 2502 */ AI_IF_LOADED_EQUAL_TO, ABILITY_PURE_POWER, -6943, // -> 09E6
    /* 2505 */ AI_IF_LOADED_EQUAL_TO, ABILITY_HUGE_POWER, -6946, // -> 09E6
    /* 2508 */ AI_IF_LOADED_EQUAL_TO, ABILITY_MOLD_BREAKER, -6949, // -> 09E6
    /* 250B */ AI_IF_LOADED_EQUAL_TO, ABILITY_SOLID_ROCK, -6952, // -> 09E6
    /* 250E */ AI_IF_LOADED_EQUAL_TO, ABILITY_FILTER, -6955, // -> 09E6
    /* 2511 */ AI_IF_LOADED_EQUAL_TO, ABILITY_FLOWER_GIFT, -6958, // -> 09E6
    /* 2514 */ AI_POP_OR_END,

    // 2515
    /* 2515 */ AI_IF_MOVE_EQUAL_TO, MOVE_DISCHARGE, 29, // -> 2535
    /* 2518 */ AI_CHECK_BATTLER_ABILITY, AI_BATTLER_TARGET_PARTNER, ABILITY_LIGHTNINGROD,
    /* 251B */ AI_IF_LOADED_EQUAL_TO, 1, 2, // -> 2520
    /* 251E */ AI_GOTO, 10, // -> 252A

    // 2520
    /* 2520 */ AI_ADD_TO_MOVE_SCORE, -1,
    /* 2522 */ AI_FLAG_BATTLER_IS_TYPE, AI_BATTLER_TARGET_PARTNER, TYPE_GROUND,
    /* 2525 */ AI_IF_LOADED_EQUAL_TO, 0, 2, // -> 252A
    /* 2528 */ AI_ADD_TO_MOVE_SCORE, -8,

    // 252A
    /* 252A */ AI_CHECK_BATTLER_ABILITY, AI_BATTLER_ATTACKER_PARTNER, ABILITY_LIGHTNINGROD,
    /* 252D */ AI_IF_LOADED_EQUAL_TO, 1, -6998, // -> 09DA
    /* 2530 */ AI_IF_MOVE_EQUAL_TO, MOVE_DISCHARGE, 2, // -> 2535
    /* 2533 */ AI_GOTO, 32, // -> 2555

    // 2535
    /* 2535 */ AI_CHECK_BATTLER_ABILITY, AI_BATTLER_ATTACKER_PARTNER, ABILITY_MOTOR_DRIVE,
    /* 2538 */ AI_IF_LOADED_EQUAL_TO, 1, -6994, // -> 09E9
    /* 253B */ AI_CHECK_BATTLER_ABILITY, AI_BATTLER_ATTACKER_PARTNER, ABILITY_VOLT_ABSORB,
    /* 253E */ AI_IF_LOADED_EQUAL_TO, 1, -7000, // -> 09E9
    /* 2541 */ AI_FLAG_BATTLER_IS_TYPE, AI_BATTLER_ATTACKER_PARTNER, TYPE_WATER,
    /* 2544 */ AI_IF_LOADED_EQUAL_TO, 1, -7021, // -> 09DA
    /* 2547 */ AI_FLAG_BATTLER_IS_TYPE, AI_BATTLER_ATTACKER_PARTNER, TYPE_FLYING,
    /* 254A */ AI_IF_LOADED_EQUAL_TO, 1, -7027, // -> 09DA
    /* 254D */ AI_FLAG_BATTLER_IS_TYPE, AI_BATTLER_ATTACKER_PARTNER, TYPE_GROUND,
    /* 2550 */ AI_IF_LOADED_EQUAL_TO, 1, -7018, // -> 09E9
    /* 2553 */ AI_ADD_TO_MOVE_SCORE, -3,

    // 2555
    /* 2555 */ AI_POP_OR_END,

    // 2556
    /* 2556 */ AI_IF_MOVE_EQUAL_TO, MOVE_SURF, 19, // -> 256C
    /* 2559 */ AI_CHECK_BATTLER_ABILITY, AI_BATTLER_TARGET_PARTNER, ABILITY_STORM_DRAIN,
    /* 255C */ AI_IF_LOADED_EQUAL_TO, 0, 2, // -> 2561
    /* 255F */ AI_ADD_TO_MOVE_SCORE, -1,

    // 2561
    /* 2561 */ AI_CHECK_BATTLER_ABILITY, AI_BATTLER_ATTACKER_PARTNER, ABILITY_STORM_DRAIN,
    /* 2564 */ AI_IF_LOADED_EQUAL_TO, 1, -7053, // -> 09DA
    /* 2567 */ AI_IF_MOVE_EQUAL_TO, MOVE_SURF, 2, // -> 256C
    /* 256A */ AI_GOTO, 26, // -> 2586

    // 256C
    /* 256C */ AI_CHECK_BATTLER_ABILITY, AI_BATTLER_ATTACKER_PARTNER, ABILITY_DRY_SKIN,
    /* 256F */ AI_IF_LOADED_EQUAL_TO, 1, -7049, // -> 09E9
    /* 2572 */ AI_CHECK_BATTLER_ABILITY, AI_BATTLER_ATTACKER_PARTNER, ABILITY_WATER_ABSORB,
    /* 2575 */ AI_IF_LOADED_EQUAL_TO, 1, -7055, // -> 09E9
    /* 2578 */ AI_FLAG_BATTLER_IS_TYPE, AI_BATTLER_ATTACKER_PARTNER, TYPE_GROUND,
    /* 257B */ AI_IF_LOADED_EQUAL_TO, 1, -7076, // -> 09DA
    /* 257E */ AI_FLAG_BATTLER_IS_TYPE, AI_BATTLER_ATTACKER_PARTNER, TYPE_FIRE,
    /* 2581 */ AI_IF_LOADED_EQUAL_TO, 1, -7082, // -> 09DA
    /* 2584 */ AI_ADD_TO_MOVE_SCORE, -3,

    // 2586
    /* 2586 */ AI_POP_OR_END,

    // 2587
    /* 2587 */ AI_IF_ACTIVATED_FLASH_FIRE, AI_BATTLER_ATTACKER, 2, // -> 258C
    /* 258A */ AI_GOTO, 2, // -> 258E

    // 258C
    /* 258C */ AI_ADD_TO_MOVE_SCORE, 1,

    // 258E
    /* 258E */ AI_IF_MOVE_EQUAL_TO, MOVE_LAVA_PLUME, 2, // -> 2593
    /* 2591 */ AI_GOTO, 38, // -> 25B9

    // 2593
    /* 2593 */ AI_CHECK_BATTLER_ABILITY, AI_BATTLER_ATTACKER_PARTNER, ABILITY_DRY_SKIN,
    /* 2596 */ AI_IF_LOADED_EQUAL_TO, 1, -7115, // -> 09CE
    /* 2599 */ AI_CHECK_BATTLER_ABILITY, AI_BATTLER_ATTACKER_PARTNER, ABILITY_FLASH_FIRE,
    /* 259C */ AI_IF_LOADED_EQUAL_TO, 1, -7094, // -> 09E9
    /* 259F */ AI_FLAG_BATTLER_IS_TYPE, AI_BATTLER_ATTACKER_PARTNER, TYPE_GRASS,
    /* 25A2 */ AI_IF_LOADED_EQUAL_TO, 1, -7115, // -> 09DA
    /* 25A5 */ AI_FLAG_BATTLER_IS_TYPE, AI_BATTLER_ATTACKER_PARTNER, TYPE_STEEL,
    /* 25A8 */ AI_IF_LOADED_EQUAL_TO, 1, -7121, // -> 09DA
    /* 25AB */ AI_FLAG_BATTLER_IS_TYPE, AI_BATTLER_ATTACKER_PARTNER, TYPE_ICE,
    /* 25AE */ AI_IF_LOADED_EQUAL_TO, 1, -7127, // -> 09DA
    /* 25B1 */ AI_FLAG_BATTLER_IS_TYPE, AI_BATTLER_ATTACKER_PARTNER, TYPE_BUG,
    /* 25B4 */ AI_IF_LOADED_EQUAL_TO, 1, -7133, // -> 09DA
    /* 25B7 */ AI_ADD_TO_MOVE_SCORE, -3,

    // 25B9
    /* 25B9 */ AI_POP_OR_END,

    // 25BA
    /* 25BA */ AI_IF_BATTLER_FAINTED, AI_BATTLER_ATTACKER_PARTNER, 522, // -> 27C7
    /* 25BD */ AI_FLAG_MOVE_DAMAGE_SCORE, 0,
    /* 25BF */ AI_IF_LOADED_EQUAL_TO, 0, 135, // -> 2649
    /* 25C2 */ AI_LOAD_TYPE_FROM, 4,
    /* 25C4 */ AI_IF_LOADED_EQUAL_TO, TYPE_FIRE, 11, // -> 25D2
    /* 25C7 */ AI_IF_LOADED_EQUAL_TO, TYPE_ELECTRIC, 21, // -> 25DF
    /* 25CA */ AI_IF_LOADED_EQUAL_TO, TYPE_WATER, 76, // -> 2619
    /* 25CD */ AI_IF_MOVE_EQUAL_TO, MOVE_FLING, 382, // -> 274E

    // 25D0
    /* 25D0 */ AI_GOTO, -7154, // -> 09E0

    // 25D2
    /* 25D2 */ AI_CHECK_BATTLER_ABILITY, AI_BATTLER_ATTACKER_PARTNER, ABILITY_FLASH_FIRE,
    /* 25D5 */ AI_IF_LOADED_EQUAL_TO, 1, 2, // -> 25DA
    /* 25D8 */ AI_GOTO, -10, // -> 25D0

    // 25DA
    /* 25DA */ AI_IF_ACTIVATED_FLASH_FIRE, AI_BATTLER_ATTACKER_PARTNER, -13, // -> 25D0
    /* 25DD */ AI_GOTO, -7158, // -> 09E9

    // 25DF
    /* 25DF */ AI_CHECK_BATTLER_ABILITY, AI_BATTLER_ATTACKER_PARTNER, ABILITY_MOTOR_DRIVE,
    /* 25E2 */ AI_IF_LOADED_EQUAL_TO, 1, 8, // -> 25ED
    /* 25E5 */ AI_CHECK_BATTLER_ABILITY, AI_BATTLER_ATTACKER_PARTNER, ABILITY_VOLT_ABSORB,
    /* 25E8 */ AI_IF_LOADED_EQUAL_TO, 1, 12, // -> 25F7
    /* 25EB */ AI_GOTO, -29, // -> 25D0

    // 25ED
    /* 25ED */ AI_IF_RANDOM_LESS_THAN, 160, 40, // -> 2618
    /* 25F0 */ AI_IF_STAT_STAGE_EQUAL_TO, AI_BATTLER_ATTACKER_PARTNER, 3, 12, -37, // -> 25D0
    /* 25F5 */ AI_GOTO, -7182, // -> 09E9

    // 25F7
    /* 25F7 */ AI_IF_HP_PERCENT_EQUAL_TO, AI_BATTLER_ATTACKER_PARTNER, 100, -7201, // -> 09DA
    /* 25FB */ AI_IF_HP_PERCENT_GREATER_THAN, AI_BATTLER_ATTACKER_PARTNER, 90, 25, // -> 2618
    /* 25FF */ AI_IF_HP_PERCENT_GREATER_THAN, AI_BATTLER_ATTACKER_PARTNER, 75, 6, // -> 2609
    /* 2603 */ AI_IF_HP_PERCENT_GREATER_THAN, AI_BATTLER_ATTACKER_PARTNER, 50, 7, // -> 260E
    /* 2607 */ AI_GOTO, 10, // -> 2613

    // 2609
    /* 2609 */ AI_IF_RANDOM_LESS_THAN, 64, -7203, // -> 09E9
    /* 260C */ AI_GOTO, 10, // -> 2618

    // 260E
    /* 260E */ AI_IF_RANDOM_LESS_THAN, 128, -7208, // -> 09E9
    /* 2611 */ AI_GOTO, 5, // -> 2618

    // 2613
    /* 2613 */ AI_IF_RANDOM_LESS_THAN, 192, -7213, // -> 09E9
    /* 2616 */ AI_GOTO, 0, // -> 2618

    // 2618
    /* 2618 */ AI_POP_OR_END,

    // 2619
    /* 2619 */ AI_CHECK_BATTLER_ABILITY, AI_BATTLER_ATTACKER_PARTNER, ABILITY_WATER_ABSORB,
    /* 261C */ AI_IF_LOADED_EQUAL_TO, 1, 8, // -> 2627
    /* 261F */ AI_CHECK_BATTLER_ABILITY, AI_BATTLER_ATTACKER_PARTNER, ABILITY_DRY_SKIN,
    /* 2622 */ AI_IF_LOADED_EQUAL_TO, 1, 2, // -> 2627
    /* 2625 */ AI_GOTO, -87, // -> 25D0

    // 2627
    /* 2627 */ AI_IF_HP_PERCENT_EQUAL_TO, AI_BATTLER_ATTACKER_PARTNER, 100, -7249, // -> 09DA
    /* 262B */ AI_IF_HP_PERCENT_GREATER_THAN, AI_BATTLER_ATTACKER_PARTNER, 90, 25, // -> 2648
    /* 262F */ AI_IF_HP_PERCENT_GREATER_THAN, AI_BATTLER_ATTACKER_PARTNER, 75, 6, // -> 2639
    /* 2633 */ AI_IF_HP_PERCENT_GREATER_THAN, AI_BATTLER_ATTACKER_PARTNER, 50, 7, // -> 263E
    /* 2637 */ AI_GOTO, 10, // -> 2643

    // 2639
    /* 2639 */ AI_IF_RANDOM_LESS_THAN, 64, -7251, // -> 09E9
    /* 263C */ AI_GOTO, 10, // -> 2648

    // 263E
    /* 263E */ AI_IF_RANDOM_LESS_THAN, 128, -7256, // -> 09E9
    /* 2641 */ AI_GOTO, 5, // -> 2648

    // 2643
    /* 2643 */ AI_IF_RANDOM_LESS_THAN, 192, -7261, // -> 09E9
    /* 2646 */ AI_GOTO, 0, // -> 2648

    // 2648
    /* 2648 */ AI_POP_OR_END,

    // 2649
    /* 2649 */ AI_IF_MOVE_EQUAL_TO, MOVE_SKILL_SWAP, 32, // -> 266C
    /* 264C */ AI_IF_MOVE_EQUAL_TO, MOVE_WILL_O_WISP, 132, // -> 26D3
    /* 264F */ AI_IF_MOVE_EQUAL_TO, MOVE_THUNDER_WAVE, 169, // -> 26FB
    /* 2652 */ AI_IF_CURRENT_MOVE_EFFECT_EQUAL_TO, MOVE_EFFECT_STATUS_BADLY_POISON, 190, // -> 2713
    /* 2655 */ AI_IF_CURRENT_MOVE_EFFECT_EQUAL_TO, MOVE_EFFECT_STATUS_POISON, 187, // -> 2713
    /* 2658 */ AI_IF_MOVE_EQUAL_TO, MOVE_HELPING_HAND, 204, // -> 2727
    /* 265B */ AI_IF_MOVE_EQUAL_TO, MOVE_SWAGGER, 222, // -> 273C
    /* 265E */ AI_IF_MOVE_EQUAL_TO, MOVE_TRICK, 237, // -> 274E
    /* 2661 */ AI_IF_MOVE_EQUAL_TO, MOVE_SWITCHEROO, 234, // -> 274E
    /* 2664 */ AI_IF_MOVE_EQUAL_TO, MOVE_GASTRO_ACID, 232, // -> 274F
    /* 2667 */ AI_IF_MOVE_EQUAL_TO, MOVE_ACUPRESSURE, 250, // -> 2764
    /* 266A */ AI_GOTO, 347, // -> 27C7

    // 266C
    /* 266C */ AI_LOAD_BATTLER_ABILITY, AI_BATTLER_TARGET,
    /* 266E */ AI_IF_LOADED_EQUAL_TO, ABILITY_TRUANT, -7298, // -> 09EF
    /* 2671 */ AI_IF_LOADED_EQUAL_TO, ABILITY_SLOW_START, -7301, // -> 09EF
    /* 2674 */ AI_LOAD_BATTLER_ABILITY, AI_BATTLER_ATTACKER,
    /* 2676 */ AI_IF_LOADED_NOT_EQUAL_TO, ABILITY_LEVITATE, 20, // -> 268D
    /* 2679 */ AI_LOAD_BATTLER_ABILITY, AI_BATTLER_TARGET,
    /* 267B */ AI_IF_LOADED_EQUAL_TO, ABILITY_LEVITATE, 329, // -> 27C7
    /* 267E */ AI_LOAD_TYPE_FROM, 0,
    /* 2680 */ AI_IF_LOADED_NOT_EQUAL_TO, TYPE_ELECTRIC, 10, // -> 268D
    /* 2683 */ AI_ADD_TO_MOVE_SCORE, 1,
    /* 2685 */ AI_LOAD_TYPE_FROM, 2,
    /* 2687 */ AI_IF_LOADED_NOT_EQUAL_TO, TYPE_ELECTRIC, 3, // -> 268D
    /* 268A */ AI_ADD_TO_MOVE_SCORE, 1,
    /* 268C */ AI_POP_OR_END,

    // 268D
    /* 268D */ AI_LOAD_BATTLER_ABILITY, AI_BATTLER_ATTACKER,
    /* 268F */ AI_IF_LOADED_EQUAL_TO, ABILITY_COMPOUNDEYES, 5, // -> 2697
    /* 2692 */ AI_IF_LOADED_EQUAL_TO, ABILITY_NO_GUARD, 2, // -> 2697
    /* 2695 */ AI_GOTO, 304, // -> 27C7

    // 2697
    /* 2697 */ AI_IF_MOVE_KNOWN, AI_BATTLER_ATTACKER_PARTNER, MOVE_FIRE_BLAST, 54, // -> 26D1
    /* 269B */ AI_IF_MOVE_KNOWN, AI_BATTLER_ATTACKER_PARTNER, MOVE_THUNDER, 50, // -> 26D1
    /* 269F */ AI_IF_MOVE_KNOWN, AI_BATTLER_ATTACKER_PARTNER, MOVE_CROSS_CHOP, 46, // -> 26D1
    /* 26A3 */ AI_IF_MOVE_KNOWN, AI_BATTLER_ATTACKER_PARTNER, MOVE_HYDRO_PUMP, 42, // -> 26D1
    /* 26A7 */ AI_IF_MOVE_KNOWN, AI_BATTLER_ATTACKER_PARTNER, MOVE_DYNAMIC_PUNCH, 38, // -> 26D1
    /* 26AB */ AI_IF_MOVE_KNOWN, AI_BATTLER_ATTACKER_PARTNER, MOVE_BLIZZARD, 34, // -> 26D1
    /* 26AF */ AI_IF_MOVE_KNOWN, AI_BATTLER_ATTACKER_PARTNER, MOVE_ZAP_CANNON, 30, // -> 26D1
    /* 26B3 */ AI_IF_MOVE_KNOWN, AI_BATTLER_ATTACKER_PARTNER, MOVE_MEGAHORN, 26, // -> 26D1
    /* 26B7 */ AI_IF_MOVE_KNOWN, AI_BATTLER_ATTACKER_PARTNER, MOVE_FOCUS_BLAST, 22, // -> 26D1
    /* 26BB */ AI_IF_MOVE_KNOWN, AI_BATTLER_ATTACKER_PARTNER, MOVE_GUNK_SHOT, 18, // -> 26D1
    /* 26BF */ AI_IF_MOVE_KNOWN, AI_BATTLER_ATTACKER_PARTNER, MOVE_MAGMA_STORM, 14, // -> 26D1
    /* 26C3 */ AI_IF_MOVE_KNOWN, AI_BATTLER_ATTACKER_PARTNER, MOVE_POWER_WHIP, 10, // -> 26D1
    /* 26C7 */ AI_IF_MOVE_KNOWN, AI_BATTLER_ATTACKER_PARTNER, MOVE_SEED_FLARE, 6, // -> 26D1
    /* 26CB */ AI_IF_MOVE_KNOWN, AI_BATTLER_ATTACKER_PARTNER, MOVE_HEAD_SMASH, 2, // -> 26D1
    /* 26CF */ AI_GOTO, 246, // -> 27C7

    // 26D1
    /* 26D1 */ AI_GOTO, -7402, // -> 09E9

    // 26D3
    /* 26D3 */ AI_CHECK_BATTLER_ABILITY, AI_BATTLER_ATTACKER_PARTNER, ABILITY_FLASH_FIRE,
    /* 26D6 */ AI_IF_LOADED_EQUAL_TO, 1, -263, // -> 25D2
    /* 26D9 */ AI_CHECK_BATTLER_ABILITY, AI_BATTLER_ATTACKER_PARTNER, ABILITY_GUTS,
    /* 26DC */ AI_IF_LOADED_NOT_EQUAL_TO, 1, 232, // -> 27C7
    /* 26DF */ AI_IF_STATUS, AI_BATTLER_ATTACKER_PARTNER, 0xFF, 228, // -> 27C7
    /* 26E3 */ AI_LOAD_TYPE_FROM, 0,
    /* 26E5 */ AI_IF_LOADED_EQUAL_TO, TYPE_FIRE, 223, // -> 27C7
    /* 26E8 */ AI_LOAD_TYPE_FROM, 2,
    /* 26EA */ AI_IF_LOADED_EQUAL_TO, TYPE_FIRE, 218, // -> 27C7
    /* 26ED */ AI_IF_HELD_ITEM_EQUAL_TO, AI_BATTLER_ATTACKER_PARTNER, ITEM_FLAME_ORB, 214, // -> 27C7
    /* 26F1 */ AI_IF_HELD_ITEM_EQUAL_TO, AI_BATTLER_ATTACKER_PARTNER, ITEM_TOXIC_ORB, 210, // -> 27C7
    /* 26F5 */ AI_IF_HP_PERCENT_LESS_THAN, AI_BATTLER_ATTACKER_PARTNER, 81, 206, // -> 27C7
    /* 26F9 */ AI_GOTO, -7439, // -> 09EC

    // 26FB
    /* 26FB */ AI_LOAD_TYPE_FROM, 0,
    /* 26FD */ AI_IF_LOADED_EQUAL_TO, TYPE_GROUND, 199, // -> 27C7
    /* 2700 */ AI_LOAD_TYPE_FROM, 2,
    /* 2702 */ AI_IF_LOADED_EQUAL_TO, TYPE_GROUND, 194, // -> 27C7
    /* 2705 */ AI_CHECK_BATTLER_ABILITY, AI_BATTLER_ATTACKER_PARTNER, ABILITY_MOTOR_DRIVE,
    /* 2708 */ AI_IF_LOADED_EQUAL_TO, 1, -300, // -> 25DF
    /* 270B */ AI_CHECK_BATTLER_ABILITY, AI_BATTLER_ATTACKER_PARTNER, ABILITY_VOLT_ABSORB,
    /* 270E */ AI_IF_LOADED_EQUAL_TO, 1, -306, // -> 25DF
    /* 2711 */ AI_GOTO, 180, // -> 27C7

    // 2713
    /* 2713 */ AI_CHECK_BATTLER_ABILITY, AI_BATTLER_ATTACKER_PARTNER, ABILITY_POISON_HEAL,
    /* 2716 */ AI_IF_LOADED_NOT_EQUAL_TO, 1, 174, // -> 27C7
    /* 2719 */ AI_IF_STATUS, AI_BATTLER_TARGET, 0xFF, 170, // -> 27C7
    /* 271D */ AI_IF_HELD_ITEM_EQUAL_TO, AI_BATTLER_ATTACKER_PARTNER, ITEM_TOXIC_ORB, 166, // -> 27C7
    /* 2721 */ AI_IF_HP_PERCENT_GREATER_THAN, AI_BATTLER_ATTACKER_PARTNER, 91, 162, // -> 27C7
    /* 2725 */ AI_GOTO, -7483, // -> 09EC

    // 2727
    /* 2727 */ AI_IF_HP_PERCENT_EQUAL_TO, AI_BATTLER_ATTACKER_PARTNER, 0, -7499, // -> 09E0
    /* 272B */ AI_IF_HP_PERCENT_GREATER_THAN, AI_BATTLER_ATTACKER_PARTNER, 50, 7, // -> 2736
    /* 272F */ AI_LOAD_BATTLER_SPEED_RANK, AI_BATTLER_ATTACKER_PARTNER,
    /* 2731 */ AI_IF_LOADED_LESS_THAN, 1, 2, // -> 2736
    /* 2734 */ AI_GOTO, 5, // -> 273B

    // 2736
    /* 2736 */ AI_IF_RANDOM_LESS_THAN, 64, -7537, // -> 09C8
    /* 2739 */ AI_ADD_TO_MOVE_SCORE, 2,

    // 273B
    /* 273B */ AI_POP_OR_END,

    // 273C
    /* 273C */ AI_IF_HELD_ITEM_EQUAL_TO, AI_BATTLER_TARGET, ITEM_PERSIM_BERRY, 6, // -> 2746
    /* 2740 */ AI_IF_HELD_ITEM_EQUAL_TO, AI_BATTLER_TARGET, ITEM_LUM_BERRY, 2, // -> 2746
    /* 2744 */ AI_GOTO, 129, // -> 27C7

    // 2746
    /* 2746 */ AI_IF_STAT_STAGE_GREATER_THAN, AI_BATTLER_TARGET, 1, 7, 2, // -> 274D
    /* 274B */ AI_ADD_TO_MOVE_SCORE, 3,

    // 274D
    /* 274D */ AI_POP_OR_END,

    // 274E
    /* 274E */ AI_POP_OR_END,

    // 274F
    /* 274F */ AI_IF_MOVE_EFFECT_FLAG, AI_BATTLER_ATTACKER_PARTNER, 0x200000, 116, // -> 27C7
    /* 2753 */ AI_CHECK_BATTLER_ABILITY, AI_BATTLER_ATTACKER_PARTNER, ABILITY_TRUANT,
    /* 2756 */ AI_IF_LOADED_EQUAL_TO, 1, 8, // -> 2761
    /* 2759 */ AI_CHECK_BATTLER_ABILITY, AI_BATTLER_ATTACKER_PARTNER, ABILITY_SLOW_START,
    /* 275C */ AI_IF_LOADED_EQUAL_TO, 1, 2, // -> 2761
    /* 275F */ AI_GOTO, 2, // -> 2763

    // 2761
    /* 2761 */ AI_ADD_TO_MOVE_SCORE, 5,

    // 2763
    /* 2763 */ AI_POP_OR_END,

    // 2764
    /* 2764 */ AI_CHECK_BATTLER_ABILITY, AI_BATTLER_ATTACKER_PARTNER, ABILITY_SIMPLE,
    /* 2767 */ AI_IF_LOADED_EQUAL_TO, 1, 37, // -> 278F
    /* 276A */ AI_IF_STAT_STAGE_EQUAL_TO, AI_BATTLER_ATTACKER_PARTNER, 1, 12, 88, // -> 27C7
    /* 276F */ AI_IF_STAT_STAGE_EQUAL_TO, AI_BATTLER_ATTACKER_PARTNER, 2, 12, 83, // -> 27C7
    /* 2774 */ AI_IF_STAT_STAGE_EQUAL_TO, AI_BATTLER_ATTACKER_PARTNER, 3, 12, 78, // -> 27C7
    /* 2779 */ AI_IF_STAT_STAGE_EQUAL_TO, AI_BATTLER_ATTACKER_PARTNER, 4, 12, 73, // -> 27C7
    /* 277E */ AI_IF_STAT_STAGE_EQUAL_TO, AI_BATTLER_ATTACKER_PARTNER, 5, 12, 68, // -> 27C7
    /* 2783 */ AI_IF_STAT_STAGE_EQUAL_TO, AI_BATTLER_ATTACKER_PARTNER, 7, 12, 63, // -> 27C7
    /* 2788 */ AI_IF_STAT_STAGE_EQUAL_TO, AI_BATTLER_ATTACKER_PARTNER, 6, 12, 58, // -> 27C7
    /* 278D */ AI_GOTO, 35, // -> 27B2

    // 278F
    /* 278F */ AI_IF_STAT_STAGE_GREATER_THAN, AI_BATTLER_ATTACKER_PARTNER, 1, 8, -7610, // -> 09DA
    /* 2794 */ AI_IF_STAT_STAGE_GREATER_THAN, AI_BATTLER_ATTACKER_PARTNER, 2, 8, -7615, // -> 09DA
    /* 2799 */ AI_IF_STAT_STAGE_GREATER_THAN, AI_BATTLER_ATTACKER_PARTNER, 3, 8, -7620, // -> 09DA
    /* 279E */ AI_IF_STAT_STAGE_GREATER_THAN, AI_BATTLER_ATTACKER_PARTNER, 4, 8, -7625, // -> 09DA
    /* 27A3 */ AI_IF_STAT_STAGE_GREATER_THAN, AI_BATTLER_ATTACKER_PARTNER, 5, 8, -7630, // -> 09DA
    /* 27A8 */ AI_IF_STAT_STAGE_GREATER_THAN, AI_BATTLER_ATTACKER_PARTNER, 7, 8, -7635, // -> 09DA
    /* 27AD */ AI_IF_STAT_STAGE_GREATER_THAN, AI_BATTLER_ATTACKER_PARTNER, 6, 8, -7640, // -> 09DA

    // 27B2
    /* 27B2 */ AI_IF_HP_PERCENT_LESS_THAN, AI_BATTLER_ATTACKER_PARTNER, 51, 14, // -> 27C4
    /* 27B6 */ AI_IF_HP_PERCENT_GREATER_THAN, AI_BATTLER_ATTACKER_PARTNER, 90, 3, // -> 27BD
    /* 27BA */ AI_IF_RANDOM_LESS_THAN, 128, 9, // -> 27C6

    // 27BD
    /* 27BD */ AI_IF_RANDOM_LESS_THAN, 80, 6, // -> 27C6
    /* 27C0 */ AI_ADD_TO_MOVE_SCORE, 2,
    /* 27C2 */ AI_GOTO, 2, // -> 27C6

    // 27C4
    /* 27C4 */ AI_ADD_TO_MOVE_SCORE, -1,

    // 27C6
    /* 27C6 */ AI_POP_OR_END,

    // 27C7
    /* 27C7 */ AI_ADD_TO_MOVE_SCORE, -30,
    /* 27C9 */ AI_POP_OR_END,

    // 27CA: flag 8
    /* 27CA */ AI_IF_TARGET_IS_PARTNER, -530, // -> 25BA
    /* 27CC */ AI_IF_HP_PERCENT_GREATER_THAN, AI_BATTLER_ATTACKER, 70, 10, // -> 27DA
    /* 27D0 */ AI_IF_HP_PERCENT_GREATER_THAN, AI_BATTLER_ATTACKER, 30, 12, // -> 27E0
    /* 27D4 */ AI_LOAD_CURRENT_MOVE_EFFECT,
    /* 27D5 */ AI_IF_LOADED_IN_TABLE, 111, 14, // table 2847, -> 27E6
    /* 27D8 */ AI_GOTO, 17, // -> 27EB

    // 27DA
    /* 27DA */ AI_LOAD_CURRENT_MOVE_EFFECT,
    /* 27DB */ AI_IF_LOADED_IN_TABLE, 45, 8, // table 280B, -> 27E6
    /* 27DE */ AI_GOTO, 11, // -> 27EB

    // 27E0
    /* 27E0 */ AI_LOAD_CURRENT_MOVE_EFFECT,
    /* 27E1 */ AI_IF_LOADED_IN_TABLE, 52, 2, // table 2818, -> 27E6
    /* 27E4 */ AI_GOTO, 5, // -> 27EB

    // 27E6
    /* 27E6 */ AI_IF_RANDOM_LESS_THAN, 50, 2, // -> 27EB
    /* 27E9 */ AI_ADD_TO_MOVE_SCORE, -2,

    // 27EB
    /* 27EB */ AI_IF_HP_PERCENT_GREATER_THAN, AI_BATTLER_TARGET, 70, 10, // -> 27F9
    /* 27EF */ AI_IF_HP_PERCENT_GREATER_THAN, AI_BATTLER_TARGET, 30, 12, // -> 27FF
    /* 27F3 */ AI_LOAD_CURRENT_MOVE_EFFECT,
    /* 27F4 */ AI_IF_LOADED_IN_TABLE, 176, 14, // table 28A7, -> 2805
    /* 27F7 */ AI_GOTO, 17, // -> 280A

    // 27F9
    /* 27F9 */ AI_LOAD_CURRENT_MOVE_EFFECT,
    /* 27FA */ AI_IF_LOADED_IN_TABLE, 126, 8, // table 287B, -> 2805
    /* 27FD */ AI_GOTO, 11, // -> 280A

    // 27FF
    /* 27FF */ AI_LOAD_CURRENT_MOVE_EFFECT,
    /* 2800 */ AI_IF_LOADED_IN_TABLE, 121, 2, // table 287C, -> 2805
    /* 2803 */ AI_GOTO, 5, // -> 280A

    // 2805
    /* 2805 */ AI_IF_RANDOM_LESS_THAN, 50, 2, // -> 280A
    /* 2808 */ AI_ADD_TO_MOVE_SCORE, -2,

    // 280A
    /* 280A */ AI_POP_OR_END,

    // 280B
    /* 280B */ MOVE_EFFECT_HALVE_DEFENSE, MOVE_EFFECT_RESTORE_HALF_HP,
               MOVE_EFFECT_RECOVER_HEALTH_AND_SLEEP, MOVE_EFFECT_KO_MON_THAT_DEFEATED_USER,
               MOVE_EFFECT_INCREASE_POWER_WITH_LESS_HP, MOVE_EFFECT_SURVIVE_WITH_1_HP,
               MOVE_EFFECT_HEAL_HALF_MORE_IN_SUN, MOVE_EFFECT_FAINT_AND_ATK_SP_ATK_DOWN_2,
               MOVE_EFFECT_REMOVE_ALL_PP_ON_DEFEAT, MOVE_EFFECT_HEAL_HALF_REMOVE_FLYING_TYPE,
               MOVE_EFFECT_FAINT_AND_FULL_HEAL_NEXT_MON, MOVE_EFFECT_FAINT_FULL_RESTORE_NEXT_MON,
               AI_TABLE_END,

    // 2818
    /* 2818 */ MOVE_EFFECT_HALVE_DEFENSE, MOVE_EFFECT_ATK_UP, MOVE_EFFECT_DEF_UP,
               MOVE_EFFECT_SPEED_UP, MOVE_EFFECT_SP_ATK_UP, MOVE_EFFECT_SP_DEF_UP,
               MOVE_EFFECT_ACC_UP, MOVE_EFFECT_EVA_UP, MOVE_EFFECT_ATK_DOWN, MOVE_EFFECT_DEF_DOWN,
               MOVE_EFFECT_SPEED_DOWN, MOVE_EFFECT_SP_ATK_DOWN, MOVE_EFFECT_SP_DEF_DOWN,
               MOVE_EFFECT_ACC_DOWN, MOVE_EFFECT_EVA_DOWN, MOVE_EFFECT_BIDE,
               MOVE_EFFECT_CONVERSION, MOVE_EFFECT_SET_LIGHT_SCREEN,
               MOVE_EFFECT_PREVENT_STAT_REDUCTION, MOVE_EFFECT_CRIT_UP_2, MOVE_EFFECT_ATK_UP_2,
               MOVE_EFFECT_DEF_UP_2, MOVE_EFFECT_SPEED_UP_2, MOVE_EFFECT_SP_ATK_UP_2,
               MOVE_EFFECT_SP_DEF_UP_2, MOVE_EFFECT_ACC_UP_2, MOVE_EFFECT_EVA_UP_2,
               MOVE_EFFECT_ATK_DOWN_2, MOVE_EFFECT_DEF_DOWN_2, MOVE_EFFECT_SPEED_DOWN_2,
               MOVE_EFFECT_SP_ATK_DOWN_2, MOVE_EFFECT_SP_DEF_DOWN_2, MOVE_EFFECT_ACC_DOWN_2,
               MOVE_EFFECT_EVA_DOWN_2, MOVE_EFFECT_CONVERSION2, MOVE_EFFECT_PREVENT_STATUS,
               MOVE_EFFECT_MAX_ATK_LOSE_HALF_MAX_HP, MOVE_EFFECT_ATK_DEF_DOWN,
               MOVE_EFFECT_DEF_SPD_UP, MOVE_EFFECT_ATK_DEF_UP, MOVE_EFFECT_SP_ATK_SP_DEF_UP,
               MOVE_EFFECT_ATK_SPD_UP, MOVE_EFFECT_PREVENT_CRITS,
               MOVE_EFFECT_SWAP_ATK_SP_ATK_STAT_CHANGES, MOVE_EFFECT_SWAP_DEF_SP_DEF_STAT_CHANGES,
               MOVE_EFFECT_SP_ATK_DOWN_2_OPPOSITE_GENDER, AI_TABLE_END,

    // 2847
    /* 2847 */ MOVE_EFFECT_ATK_UP, MOVE_EFFECT_DEF_UP, MOVE_EFFECT_SPEED_UP, MOVE_EFFECT_SP_ATK_UP,
               MOVE_EFFECT_SP_DEF_UP, MOVE_EFFECT_ACC_UP, MOVE_EFFECT_EVA_UP, MOVE_EFFECT_ATK_DOWN,
               MOVE_EFFECT_DEF_DOWN, MOVE_EFFECT_SPEED_DOWN, MOVE_EFFECT_SP_ATK_DOWN,
               MOVE_EFFECT_SP_DEF_DOWN, MOVE_EFFECT_ACC_DOWN, MOVE_EFFECT_EVA_DOWN,
               MOVE_EFFECT_BIDE, MOVE_EFFECT_CONVERSION, MOVE_EFFECT_SET_LIGHT_SCREEN,
               MOVE_EFFECT_PREVENT_STAT_REDUCTION, MOVE_EFFECT_CRIT_UP_2, MOVE_EFFECT_ATK_UP_2,
               MOVE_EFFECT_DEF_UP_2, MOVE_EFFECT_SPEED_UP_2, MOVE_EFFECT_SP_ATK_UP_2,
               MOVE_EFFECT_SP_DEF_UP_2, MOVE_EFFECT_ACC_UP_2, MOVE_EFFECT_EVA_UP_2,
               MOVE_EFFECT_ATK_DOWN_2, MOVE_EFFECT_DEF_DOWN_2, MOVE_EFFECT_SPEED_DOWN_2,
               MOVE_EFFECT_SP_ATK_DOWN_2, MOVE_EFFECT_SP_DEF_DOWN_2, MOVE_EFFECT_ACC_DOWN_2,
               MOVE_EFFECT_EVA_DOWN_2, MOVE_EFFECT_RAISE_ATK_WHEN_HIT, MOVE_EFFECT_CONVERSION2,
               MOVE_EFFECT_NEXT_ATTACK_ALWAYS_HITS, MOVE_EFFECT_PREVENT_STATUS,
               MOVE_EFFECT_MAX_ATK_LOSE_HALF_MAX_HP, MOVE_EFFECT_COPY_STAT_CHANGES,
               MOVE_EFFECT_MIRROR_COAT, MOVE_EFFECT_DECREASE_POWER_WITH_LESS_USER_HP,
               MOVE_EFFECT_ATK_DEF_DOWN, MOVE_EFFECT_DEF_SPD_UP, MOVE_EFFECT_ATK_DEF_UP,
               MOVE_EFFECT_SP_ATK_SP_DEF_UP, MOVE_EFFECT_ATK_SPD_UP,
               MOVE_EFFECT_HALVE_ELECTRIC_DAMAGE, MOVE_EFFECT_HALVE_FIRE_DAMAGE,
               MOVE_EFFECT_RANDOM_STAT_UP_2, MOVE_EFFECT_METAL_BURST,
               MOVE_EFFECT_SP_ATK_DOWN_2_OPPOSITE_GENDER, AI_TABLE_END,

    // 287B
    /* 287B */ AI_TABLE_END,

    // 287C
    /* 287C */ MOVE_EFFECT_ATK_UP, MOVE_EFFECT_DEF_UP, MOVE_EFFECT_SPEED_UP, MOVE_EFFECT_SP_ATK_UP,
               MOVE_EFFECT_SP_DEF_UP, MOVE_EFFECT_ACC_UP, MOVE_EFFECT_EVA_UP, MOVE_EFFECT_ATK_DOWN,
               MOVE_EFFECT_DEF_DOWN, MOVE_EFFECT_SPEED_DOWN, MOVE_EFFECT_SP_ATK_DOWN,
               MOVE_EFFECT_SP_DEF_DOWN, MOVE_EFFECT_ACC_DOWN, MOVE_EFFECT_EVA_DOWN,
               MOVE_EFFECT_PREVENT_STAT_REDUCTION, MOVE_EFFECT_CRIT_UP_2, MOVE_EFFECT_ATK_UP_2,
               MOVE_EFFECT_DEF_UP_2, MOVE_EFFECT_SPEED_UP_2, MOVE_EFFECT_SP_ATK_UP_2,
               MOVE_EFFECT_SP_DEF_UP_2, MOVE_EFFECT_ACC_UP_2, MOVE_EFFECT_EVA_UP_2,
               MOVE_EFFECT_ATK_DOWN_2, MOVE_EFFECT_DEF_DOWN_2, MOVE_EFFECT_SPEED_DOWN_2,
               MOVE_EFFECT_SP_ATK_DOWN_2, MOVE_EFFECT_SP_DEF_DOWN_2, MOVE_EFFECT_ACC_DOWN_2,
               MOVE_EFFECT_EVA_DOWN_2, MOVE_EFFECT_STATUS_POISON, MOVE_EFFECT_AVERAGE_HP,
               MOVE_EFFECT_ALL_FAINT_3_TURNS, MOVE_EFFECT_PREVENT_STATUS, MOVE_EFFECT_ATK_DEF_DOWN,
               MOVE_EFFECT_DEF_SPD_UP, MOVE_EFFECT_ATK_DEF_UP, MOVE_EFFECT_SP_ATK_SP_DEF_UP,
               MOVE_EFFECT_ATK_SPD_UP, MOVE_EFFECT_RANDOM_STAT_UP_2,
               MOVE_EFFECT_INCREASE_POWER_WITH_MORE_HP, MOVE_EFFECT_SP_ATK_DOWN_2_OPPOSITE_GENDER,
               AI_TABLE_END,

    // 28A7
    /* 28A7 */ MOVE_EFFECT_STATUS_SLEEP, MOVE_EFFECT_HALVE_DEFENSE, MOVE_EFFECT_ATK_UP,
               MOVE_EFFECT_DEF_UP, MOVE_EFFECT_SPEED_UP, MOVE_EFFECT_SP_ATK_UP,
               MOVE_EFFECT_SP_DEF_UP, MOVE_EFFECT_ACC_UP, MOVE_EFFECT_EVA_UP, MOVE_EFFECT_ATK_DOWN,
               MOVE_EFFECT_DEF_DOWN, MOVE_EFFECT_SPEED_DOWN, MOVE_EFFECT_SP_ATK_DOWN,
               MOVE_EFFECT_SP_DEF_DOWN, MOVE_EFFECT_ACC_DOWN, MOVE_EFFECT_EVA_DOWN,
               MOVE_EFFECT_BIDE, MOVE_EFFECT_CONVERSION, MOVE_EFFECT_STATUS_BADLY_POISON,
               MOVE_EFFECT_SET_LIGHT_SCREEN, MOVE_EFFECT_ONE_HIT_KO, MOVE_EFFECT_HALVE_HP,
               MOVE_EFFECT_HALVE_HP, MOVE_EFFECT_PREVENT_STAT_REDUCTION, MOVE_EFFECT_CRIT_UP_2,
               MOVE_EFFECT_STATUS_CONFUSE, MOVE_EFFECT_ATK_UP_2, MOVE_EFFECT_DEF_UP_2,
               MOVE_EFFECT_SPEED_UP_2, MOVE_EFFECT_SP_ATK_UP_2, MOVE_EFFECT_SP_DEF_UP_2,
               MOVE_EFFECT_ACC_UP_2, MOVE_EFFECT_EVA_UP_2, MOVE_EFFECT_ATK_DOWN_2,
               MOVE_EFFECT_DEF_DOWN_2, MOVE_EFFECT_SPEED_DOWN_2, MOVE_EFFECT_SP_ATK_DOWN_2,
               MOVE_EFFECT_SP_DEF_DOWN_2, MOVE_EFFECT_ACC_DOWN_2, MOVE_EFFECT_EVA_DOWN_2,
               MOVE_EFFECT_STATUS_POISON, MOVE_EFFECT_STATUS_PARALYZE, MOVE_EFFECT_AVERAGE_HP,
               MOVE_EFFECT_CONVERSION2, MOVE_EFFECT_NEXT_ATTACK_ALWAYS_HITS,
               MOVE_EFFECT_DECREASE_LAST_MOVE_PP, MOVE_EFFECT_ALL_FAINT_3_TURNS,
               MOVE_EFFECT_ATK_UP_2_STATUS_CONFUSION, MOVE_EFFECT_DOUBLE_POWER_EACH_TURN,
               MOVE_EFFECT_INFATUATE, MOVE_EFFECT_PREVENT_STATUS, MOVE_EFFECT_COPY_STAT_CHANGES,
               MOVE_EFFECT_MIRROR_COAT, MOVE_EFFECT_STATUS_BURN, MOVE_EFFECT_ATK_DEF_DOWN,
               MOVE_EFFECT_DEF_SPD_UP, MOVE_EFFECT_ATK_DEF_UP, MOVE_EFFECT_SP_ATK_SP_DEF_UP,
               MOVE_EFFECT_ATK_SPD_UP, MOVE_EFFECT_RANDOM_STAT_UP_2,
               MOVE_EFFECT_INCREASE_POWER_WITH_MORE_HP, MOVE_EFFECT_SP_ATK_DOWN_2_OPPOSITE_GENDER,
               AI_TABLE_END,

    // 28E6: flag 9
    /* 28E6 */ AI_IF_TARGET_IS_PARTNER, 134, // -> 296E
    /* 28E8 */ AI_LOAD_TURN_COUNT,
    /* 28E9 */ AI_IF_LOADED_NOT_EQUAL_TO, 0, 43, // -> 2917
    /* 28EC */ AI_IF_CURRENT_MOVE_EFFECT_EQUAL_TO, MOVE_EFFECT_WEATHER_SUN, 9, // -> 28F8
    /* 28EF */ AI_IF_CURRENT_MOVE_EFFECT_EQUAL_TO, MOVE_EFFECT_WEATHER_RAIN, 12, // -> 28FE
    /* 28F2 */ AI_IF_CURRENT_MOVE_EFFECT_EQUAL_TO, MOVE_EFFECT_WEATHER_SANDSTORM, 15, // -> 2904
    /* 28F5 */ AI_IF_CURRENT_MOVE_EFFECT_EQUAL_TO, MOVE_EFFECT_WEATHER_HAIL, 18, // -> 290A

    // 28F8
    /* 28F8 */ AI_LOAD_CURRENT_WEATHER,
    /* 28F9 */ AI_IF_LOADED_EQUAL_TO, 1, 27, // -> 2917
    /* 28FC */ AI_GOTO, 18, // -> 2910

    // 28FE
    /* 28FE */ AI_LOAD_CURRENT_WEATHER,
    /* 28FF */ AI_IF_LOADED_EQUAL_TO, 2, 21, // -> 2917
    /* 2902 */ AI_GOTO, 12, // -> 2910

    // 2904
    /* 2904 */ AI_LOAD_CURRENT_WEATHER,
    /* 2905 */ AI_IF_LOADED_EQUAL_TO, 3, 15, // -> 2917
    /* 2908 */ AI_GOTO, 6, // -> 2910

    // 290A
    /* 290A */ AI_LOAD_CURRENT_WEATHER,
    /* 290B */ AI_IF_LOADED_EQUAL_TO, 4, 9, // -> 2917
    /* 290E */ AI_GOTO, 0, // -> 2910

    // 2910
    /* 2910 */ AI_LOAD_IS_FIRST_TURN_IN_BATTLE, AI_BATTLER_ATTACKER,
    /* 2912 */ AI_IF_LOADED_EQUAL_TO, 0, 2, // -> 2917
    /* 2915 */ AI_ADD_TO_MOVE_SCORE, 5,

    // 2917
    /* 2917 */ AI_POP_OR_END,

    // 2918: flag 10
    /* 2918 */ AI_IF_TARGET_IS_PARTNER, 84, // -> 296E
    /* 291A */ AI_LOAD_CURRENT_MOVE_EFFECT,
    /* 291B */ AI_IF_LOADED_NOT_IN_TABLE, 6, 5, // table 2924, -> 2923
    /* 291E */ AI_IF_RANDOM_LESS_THAN, 128, 2, // -> 2923
    /* 2921 */ AI_ADD_TO_MOVE_SCORE, 2,

    // 2923
    /* 2923 */ AI_POP_OR_END,

    // 2924
    /* 2924 */ MOVE_EFFECT_STATUS_SLEEP, MOVE_EFFECT_ATK_DOWN, MOVE_EFFECT_DEF_DOWN,
               MOVE_EFFECT_ACC_DOWN, MOVE_EFFECT_EVA_DOWN, MOVE_EFFECT_STATUS_CONFUSE,
               MOVE_EFFECT_ATK_DOWN_2, MOVE_EFFECT_DEF_DOWN_2, MOVE_EFFECT_SPEED_DOWN_2,
               MOVE_EFFECT_SP_DEF_DOWN_2, MOVE_EFFECT_STATUS_POISON, MOVE_EFFECT_STATUS_PARALYZE,
               MOVE_EFFECT_STATUS_LEECH_SEED, MOVE_EFFECT_ENCORE,
               MOVE_EFFECT_DECREASE_LAST_MOVE_PP, MOVE_EFFECT_SET_SPIKES,
               MOVE_EFFECT_ATK_UP_2_STATUS_CONFUSION, MOVE_EFFECT_INFATUATE, MOVE_EFFECT_TORMENT,
               MOVE_EFFECT_SP_ATK_UP_CAUSE_CONFUSION, MOVE_EFFECT_STATUS_BURN,
               MOVE_EFFECT_NATURE_POWER, MOVE_EFFECT_STATUS_SLEEP_NEXT_TURN,
               MOVE_EFFECT_REMOVE_HELD_ITEM, MOVE_EFFECT_MAKE_SHARED_MOVES_UNUSEABL,
               MOVE_EFFECT_SECRET_POWER, 199, MOVE_EFFECT_ATK_DEF_DOWN, MOVE_EFFECT_CAMOUFLAGE,
               MOVE_EFFECT_PREVENT_ITEM_USE, MOVE_EFFECT_TRANSFER_STATUS, MOVE_EFFECT_TOXIC_SPIKES,
               MOVE_EFFECT_REMOVE_HAZARDS_SCREENS_EVA_DOWN,
               MOVE_EFFECT_SP_ATK_DOWN_2_OPPOSITE_GENDER, AI_TABLE_END,

    // 2947: flag 29
    /* 2947 */ AI_IF_VOLATILE_STATUS, AI_BATTLER_ATTACKER, 0xE000, 20, // -> 295F
    /* 294B */ AI_IF_VOLATILE_STATUS, AI_BATTLER_ATTACKER, 0x4000000, 16, // -> 295F
    /* 294F */ AI_LOAD_ABILITY, AI_BATTLER_TARGET,
    /* 2951 */ AI_IF_LOADED_EQUAL_TO, ABILITY_SHADOW_TAG, 11, // -> 295F
    /* 2954 */ AI_LOAD_ABILITY, AI_BATTLER_ATTACKER,
    /* 2956 */ AI_IF_LOADED_EQUAL_TO, ABILITY_LEVITATE, 5, // -> 295E
    /* 2959 */ AI_LOAD_ABILITY, AI_BATTLER_TARGET,
    /* 295B */ AI_IF_LOADED_EQUAL_TO, ABILITY_ARENA_TRAP, 1, // -> 295F

    // 295E
    /* 295E */ AI_ESCAPE,

    // 295F
    /* 295F */ AI_POP_OR_END,

    // 2960: flag 30
    /* 2960 */ AI_IF_RANDOM_SAFARI_FLEE, 1, // -> 2963
    /* 2962 */ AI_WATCH,

    // 2963
    /* 2963 */ AI_ESCAPE,

    // 2964: flag 31
    /* 2964 */ AI_IF_HP_PERCENT_EQUAL_TO, AI_BATTLER_TARGET, 20, 5, // -> 296D
    /* 2968 */ AI_IF_HP_PERCENT_LESS_THAN, AI_BATTLER_TARGET, 20, 1, // -> 296D
    /* 296C */ AI_POP_OR_END,

    // 296D
    /* 296D */ AI_ESCAPE,

    // 296E: flag 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28
    /* 296E */ AI_POP_OR_END,
};
