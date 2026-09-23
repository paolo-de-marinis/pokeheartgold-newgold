#include "global.h"

#include "touchscreen.h"

// Where the type search's buttons are touched: the eighteen types four to a
// row, OK and Cancel, then "----" after Fairy in the last row (retail's had
// the seventeen types and "----", Fairy's place). A touch answers the
// button's index, DEX_SEARCH_TYPE_BUTTON_*, which ov18_021FBB94 moves the
// cursor between.
const TouchscreenHitbox ov18_021FBA40[] = {
    { .rect = { 40, 55, 3, 60 } }, // Normal
    { .rect = { 40, 55, 67, 124 } }, // Fighting
    { .rect = { 40, 55, 131, 188 } }, // Flying
    { .rect = { 40, 55, 195, 252 } }, // Poison
    { .rect = { 64, 79, 3, 60 } }, // Ground
    { .rect = { 64, 79, 67, 124 } }, // Rock
    { .rect = { 64, 79, 131, 188 } }, // Bug
    { .rect = { 64, 79, 195, 252 } }, // Ghost
    { .rect = { 88, 104, 3, 60 } }, // Steel
    { .rect = { 88, 104, 67, 124 } }, // Fire
    { .rect = { 88, 104, 131, 188 } }, // Water
    { .rect = { 88, 104, 195, 252 } }, // Grass
    { .rect = { 112, 127, 3, 60 } }, // Electric
    { .rect = { 112, 127, 67, 124 } }, // Psychic
    { .rect = { 112, 127, 131, 188 } }, // Ice
    { .rect = { 112, 127, 195, 252 } }, // Dragon
    { .rect = { 136, 151, 3, 60 } }, // Dark
    { .rect = { 136, 151, 67, 124 } }, // Fairy
    { .rect = { 164, 187, 4, 75 } }, // OK
    { .rect = { 164, 187, 180, 251 } }, // Cancel
    { .rect = { 136, 151, 131, 188 } }, // "----"
    { .rect = { TOUCHSCREEN_RECTLIST_END, 0, 0, 0 } },
};
