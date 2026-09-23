#include "constants/pokemon.h"

#include "overlay_14.h"

// Up or down a row of six in the box list, wrapping past the first and the
// last box.
void ov14_021F1004(PCBoxApp *app, int direction) {
    int box = app->listBox + direction * 6;
    if (box < 0) {
        box += NUM_BOXES;
    } else if (box >= NUM_BOXES) {
        box -= NUM_BOXES;
    }
    app->listBox = box;
    ov14_021F49E0(app);
    ov14_021F48B4(app);
    ov14_021F4848(app);
    ov14_021F57B8(app);
    if (direction > 0) {
        ov14_021F29E4(app->graphics, 5, 4);
    } else {
        ov14_021F29E4(app->graphics, 4, 2);
    }
}
