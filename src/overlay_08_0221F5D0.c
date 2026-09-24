#include "global.h"

#include "constants/battle.h"
#include "msgdata/msg/msg_0006.h"

#include "bg_window.h"

#include "battle_party_menu.h"

void ov08_0221F658(BattlePartyMenu *menu, u8 pos);
void ov08_0221E3A4(BattlePartyMenu *menu, int window, int msgId);
void ov08_0221F5D0(BattlePartyMenu *menu);

// The submenu of the Pokemon picked: its name and level, and the buttons'
// labels -- SHIFT (REVIVE for Revival Blessing), then SUMMARY and CHECK
// MOVES, which an Egg leaves blank.
void ov08_0221F5D0(BattlePartyMenu *menu) {
    FillWindowPixelBuffer(&menu->windows[0], 0);
    FillWindowPixelBuffer(&menu->windows[1], 0);
    FillWindowPixelBuffer(&menu->windows[2], 0);
    FillWindowPixelBuffer(&menu->windows[3], 0);
    ov08_0221F658(menu, menu->args->selectedPos);
    // Revival Blessing's pick is revived, not sent in: its button says so.
    ov08_0221E3A4(menu, 1, menu->args->mode == BATTLE_PARTY_MODE_REVIVE ? msg_0006_00096 : msg_0006_00015);
    if (menu->mons[menu->args->selectedPos].isEgg == FALSE) {
        ov08_0221E3A4(menu, 2, msg_0006_00018);
        ov08_0221E3A4(menu, 3, msg_0006_00019);
        return;
    }
    ScheduleWindowCopyToVram(&menu->windows[2]);
    ScheduleWindowCopyToVram(&menu->windows[3]);
}
