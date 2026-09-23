#include "constants/pokemon.h"

#include "overlay_14.h"

// The same box-list cursor as ov14_021F6D14, where the row's six boxes are
// grid positions 37 to 42.
void ov14_021F7184(void *data, int newTarget, int prevTarget) {
    PCBoxApp *app = data;

    if (app->graphics->unk44B == 0) {
        if (newTarget >= 37 && newTarget <= 42) {
            ov14_021F29E4(app->graphics, 9, 14);
        } else {
            ov14_021F29E4(app->graphics, 9, 8);
        }
    }
    if (newTarget == 37 && ((prevTarget >= 0 && prevTarget <= 5) || (prevTarget >= 24 && prevTarget <= 29) || (prevTarget >= 30 && prevTarget <= 31) || prevTarget == 36)) {
        newTarget = app->graphics->lastGridInput;
        GridInputHandler_SetNextLastUnk0FInputs(app->graphics->gridInput, (u8)newTarget, (u8)prevTarget, GridInputHandler_GetUnk0F(app->graphics->gridInput));
    }
    if (newTarget >= 37 && newTarget <= 42) {
        app->graphics->lastGridInput = newTarget;
    }
    if (newTarget == 37 && prevTarget == 42) {
        if (app->listBox + 1 >= NUM_BOXES) {
            app->listBox = 0;
        } else {
            app->listBox++;
        }
        ov14_021F49E0(app);
        ov14_021F48B4(app);
        ov14_021F4848(app);
        ov14_021F57B8(app);
        ov14_021F29E4(app->graphics, 5, 4);
        ov14_021F7AC4(app->graphics, newTarget, prevTarget);
        ov14_021E5A50(app->graphics, ov14_021E9F20);
    } else if (newTarget == 42 && prevTarget == 37) {
        if (app->listBox - 1 < 0) {
            app->listBox = NUM_BOXES - 1;
        } else {
            app->listBox--;
        }
        ov14_021F49E0(app);
        ov14_021F48B4(app);
        ov14_021F4848(app);
        ov14_021F57B8(app);
        ov14_021F29E4(app->graphics, 4, 2);
        ov14_021F7AC4(app->graphics, newTarget, prevTarget);
        ov14_021E5A50(app->graphics, ov14_021E9F20);
    } else {
        if (newTarget >= 37 && newTarget <= 42 && prevTarget >= 37 && prevTarget <= 42) {
            app->listBox = app->listBox / 6 * 6 + newTarget - 37;
            ov14_021F48B4(app);
            ov14_021F57B8(app);
        }
        ov14_021F7AC4(app->graphics, newTarget, prevTarget);
        ov14_021E5A50(app->graphics, ov14_021E9F20);
    }
}
