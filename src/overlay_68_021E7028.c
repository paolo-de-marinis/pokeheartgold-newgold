#include "global.h"

#include "constants/pokemon.h"

#include "move.h"
#include "overlay_68_021E7028.h"
#include "unk_02077678.h"

// Draws the icon beside a move in the relearner's list: its type, or, when the
// list shows contest data, its contest condition. The icon table holds every
// type first and the conditions after them, so a condition is looked up past
// the last type.
void ov68_021E7028(MoveRelearnerApp *app, u16 move, u16 idx) {
    int icon;
    NarcId narcId;

    if (app->args->unk_18 == 0) {
        icon = GetMoveAttr(move, MOVEATTR_TYPE);
    } else {
        icon = GetMoveAttr(move, MOVEATTR_CONTEST_TYPE) + NUMBER_OF_MON_TYPES;
    }
    narcId = sub_020776B4();
    SpriteSystem_ReplaceCharResObj(app->spriteSystem, app->spriteManager, narcId, sub_02077678(icon), TRUE, 0xB8AB + idx);
    if (idx < 4) {
        ManagedSprite_SetPaletteOverride(app->sprites[idx + 4], sub_0207769C(icon) + 4);
    } else {
        ManagedSprite_SetPaletteOverride(app->sprites[idx + 4], sub_0207769C(icon));
    }
}
