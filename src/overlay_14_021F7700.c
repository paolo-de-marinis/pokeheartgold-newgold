#include "constants/pokemon.h"

#include "overlay_14.h"

// The box list's cursor for the other grid that has one (the callbacks at
// ov14_021F870C). Retail has the routine twice: this is ov14_021F6D14,
// instruction for instruction.
void ov14_021F7700(void *data, int newTarget, int prevTarget) {
    PCBoxApp *app = data;

    if (newTarget >= 0 && newTarget <= 5) {
        ov14_021F29E4(app->graphics, 9, 14);
    } else {
        ov14_021F29E4(app->graphics, 9, 8);
    }
    if (prevTarget == 8 && newTarget == 0) {
        newTarget = app->graphics->lastGridInput;
        GridInputHandler_SetNextLastUnk0FInputs(app->graphics->gridInput, (u8)newTarget, 8, 8);
    }
    if (newTarget >= 0 && newTarget <= 5) {
        app->graphics->lastGridInput = newTarget;
    }
    if (newTarget == 0 && prevTarget == 5) {
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
    } else if (newTarget == 5 && prevTarget == 0) {
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
        if (newTarget >= 0 && newTarget <= 5 && prevTarget != 8) {
            app->listBox = app->listBox / 6 * 6 + newTarget;
            ov14_021F48B4(app);
            ov14_021F57B8(app);
        }
        ov14_021F7AC4(app->graphics, newTarget, prevTarget);
        ov14_021E5A50(app->graphics, ov14_021E9F20);
    }
}
