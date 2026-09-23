#include "global.h"

#include "overlay_14.h"
#include "pc_box_display.h"
#include "sprite_system.h"

void ov14_021F3D0C(PCBoxAppGraphics *graphics, int type, int spriteIdx, int unused);
void ov14_021F3D70(PCBoxAppGraphics *graphics, PCBoxDisplayMon *mon);

// The type icons of the Pokemon the cursor is on: none for an egg, a second
// only when its second type is neither Normal nor its first. The fourth
// argument of each call is a resource id ov14_021F3D0C never reads.
void ov14_021F3D70(PCBoxAppGraphics *graphics, PCBoxDisplayMon *mon) {
    if (mon->isEgg) {
        ManagedSprite_SetDrawFlag(graphics->sprites[13], FALSE);
        ManagedSprite_SetDrawFlag(graphics->sprites[14], FALSE);
        return;
    }
    ov14_021F3D0C(graphics, mon->type1, 13, 0xC121);
    ManagedSprite_SetDrawFlag(graphics->sprites[13], TRUE);
    if (mon->type2 != TYPE_NORMAL && mon->type1 != mon->type2) {
        ov14_021F3D0C(graphics, mon->type2, 14, 0xC122);
        ManagedSprite_SetDrawFlag(graphics->sprites[14], TRUE);
    } else {
        ManagedSprite_SetDrawFlag(graphics->sprites[14], FALSE);
    }
}
