#include "constants/pokemon.h"

#include "overlay_14.h"

// The arrows either side of the box name: the box before the first is the
// last, and the one after the last is the first.
void ov14_021F028C(PCBoxApp *app, int a1) {
    if (app->curBox == 0) {
        app->curBox = NUM_BOXES - 1;
    } else {
        app->curBox--;
    }
    ov14_021F2DE8(app, app->curBox);
    ov14_021E783C(app, ov14_021E7930(app, app->curBox), 0);
    ov14_021F29E4(app->graphics, 0, 2);
    if (ov14_021E8544(app->graphics->unk2F0) == 1) {
        ov14_021E84A4(app->graphics->unk2F0);
        if (app->args->unk8 == 2 || app->args->unk8 == 3) {
            ov14_021E8248(app->graphics->unk2F0);
            ov14_021E82A8(app->graphics->unk2F0);
        }
    }
    ov14_021F0234(app, ov14_021E92AC, a1);
}

void ov14_021F0314(PCBoxApp *app, int a1) {
    if (app->curBox == NUM_BOXES - 1) {
        app->curBox = 0;
    } else {
        app->curBox++;
    }
    ov14_021F2DE8(app, app->curBox);
    ov14_021E783C(app, ov14_021E7930(app, app->curBox), 1);
    ov14_021F29E4(app->graphics, 1, 4);
    if (ov14_021E8544(app->graphics->unk2F0) == 1) {
        ov14_021E84A4(app->graphics->unk2F0);
        if (app->args->unk8 == 2 || app->args->unk8 == 3) {
            ov14_021E8248(app->graphics->unk2F0);
            ov14_021E82A8(app->graphics->unk2F0);
        }
    }
    ov14_021F0234(app, ov14_021E9370, a1);
}
