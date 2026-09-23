#ifndef POKEHEARTGOLD_CONSTANTS_BATTLE_SCRIPT_IMPORTS_H
#define POKEHEARTGOLD_CONSTANTS_BATTLE_SCRIPT_IMPORTS_H

// What the imported battle scripts name and this game has not got: the
// weather and the execution-order changes the reference added. A script
// that mentions one of these assembles and runs; the branch it guards
// is never taken, because nothing here sets it. The list is what
// tests/newgold/test_move_effects.py counts down.
//
// The four terrain types used to be here. They have moved to
// constants/battle.h, next to the field conditions, because a terrain
// is now something this game has. Ion Deluge's field condition went the
// same way, for the same reason, and so has snow: the weather is read
// in C now, so FIELD_CONDITION_SNOW_TEMP is a condition rather than a
// number a script sets and nothing looks at.
//
// The four Drives and the seventeen Memories went to constants/items.h
// when the whole of konefr's item range arrived, because they are real
// hold effects with real items behind them now. Those two were never
// merely inert, which is the thing to know before adding a line here: a
// placeholder carries konefr's number, and konefr's hold effects 147 to
// 150 are this game's Eviolite, Air Balloon, Absorb Bulb and Cell
// Battery. Techno Blast was picking its type off those four. Anything
// written here wants checking against items.h for the same reason.

// Totem battles are Alola's; no battle here sets the bit, which is the
// engine's own and free in this game's BATTLE_TYPE_ word.
#define BATTLE_TYPE_TOTEM                              (1 << 14)
#define EXECUTION_ORDER_AFTER_YOU                      1
#define EXECUTION_ORDER_QUASH                          2
#define BATTLE_ANIMATION_GRASSY_TERRAIN                50
#define BATTLE_ANIMATION_MISTY_TERRAIN                 51
#define BATTLE_ANIMATION_ELECTRIC_TERRAIN              52
#define BATTLE_ANIMATION_PSYCHIC_TERRAIN               53

#endif // POKEHEARTGOLD_CONSTANTS_BATTLE_SCRIPT_IMPORTS_H
