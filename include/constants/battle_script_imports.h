#ifndef POKEHEARTGOLD_CONSTANTS_BATTLE_SCRIPT_IMPORTS_H
#define POKEHEARTGOLD_CONSTANTS_BATTLE_SCRIPT_IMPORTS_H

// What the imported battle scripts name and this game has not got:
// the Drives, the Memories, the weather the reference added. A script
// that mentions one of these assembles and runs; the branch it guards
// is never taken, because nothing here sets it. The list is what
// tests/newgold/test_move_effects.py counts down.
//
// The four terrain types used to be here. They have moved to
// constants/battle.h, next to the field conditions, because a terrain
// is now something this game has.

#define EXECUTION_ORDER_AFTER_YOU                      1
#define EXECUTION_ORDER_QUASH                          2
#define BATTLE_ANIMATION_GRASSY_TERRAIN                50
#define BATTLE_ANIMATION_MISTY_TERRAIN                 51
#define BATTLE_ANIMATION_ELECTRIC_TERRAIN              52
#define BATTLE_ANIMATION_PSYCHIC_TERRAIN               53
#define HOLD_EFFECT_BURN_DRIVE                         147
#define HOLD_EFFECT_CHILL_DRIVE                        148
#define HOLD_EFFECT_DOUSE_DRIVE                        149
#define HOLD_EFFECT_SHOCK_DRIVE                        150
#define HOLD_EFFECT_FIGHTING_MEMORY                    180
#define HOLD_EFFECT_FLYING_MEMORY                      181
#define HOLD_EFFECT_POISON_MEMORY                      182
#define HOLD_EFFECT_GROUND_MEMORY                      183
#define HOLD_EFFECT_ROCK_MEMORY                        184
#define HOLD_EFFECT_BUG_MEMORY                         185
#define HOLD_EFFECT_GHOST_MEMORY                       186
#define HOLD_EFFECT_STEEL_MEMORY                       187
#define HOLD_EFFECT_FIRE_MEMORY                        188
#define HOLD_EFFECT_WATER_MEMORY                       189
#define HOLD_EFFECT_GRASS_MEMORY                       190
#define HOLD_EFFECT_ELECTRIC_MEMORY                    191
#define HOLD_EFFECT_PSYCHIC_MEMORY                     192
#define HOLD_EFFECT_ICE_MEMORY                         193
#define HOLD_EFFECT_DRAGON_MEMORY                      194
#define HOLD_EFFECT_DARK_MEMORY                        195
#define HOLD_EFFECT_FAIRY_MEMORY                       196
#define ITEM_ABILITY_SHIELD                            1881
#define FIELD_CONDITION_SNOW_TEMP                      1048576
#define FIELD_CONDITION_ION_DELUGE                     134217728

#endif // POKEHEARTGOLD_CONSTANTS_BATTLE_SCRIPT_IMPORTS_H
