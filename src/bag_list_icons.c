#include "global.h"

#include "bag_app_state.h"
#include "sprite_system.h"

// Where each of the bag's sprites sits, the list's item icons from the second.
extern const ManagedSpriteTemplate ov15_02200B0C[];

extern void ov15_021FF8F0(BagAppState *bagApp, int row, u16 itemId);
extern void ov15_022000F4(BagAppState *bagApp);

// Place the six icons beside the rows of the page, showing one for each row
// the list fills and, when asked, loading each one's item picture.
void ov15_02200140(BagAppState *bagApp, BagViewPocket *pocket, int count, BOOL loadIcons) {
    int i;

    for (i = 0; i < 6; i++) {
        ManagedSprite_SetPositionXYWithSubscreenOffset(bagApp->sprites[1 + i], ov15_02200B0C[1 + i].x, ov15_02200B0C[1 + i].y, FX32_CONST(256));
        if (i < count) {
            if (loadIcons) {
                ov15_021FF8F0(bagApp, i, bagApp->listItems[pocket->scroll + i]);
            }
            ManagedSprite_SetDrawFlag(bagApp->sprites[1 + i], TRUE);
        } else {
            ManagedSprite_SetDrawFlag(bagApp->sprites[1 + i], FALSE);
        }
    }
    ov15_022000F4(bagApp);
}
