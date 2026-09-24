#include "global.h"

#include "battle_party_menu.h"

int ov08_0221D5DC(BattlePartyMenu *menu, int pos);
void ov08_02221E6C(BattlePartyMenu *menu, u8 button, u8 state, u8 a3);
u8 ov08_02222564(BattlePartyMenu *menu);
void ov08_022221CC(BattlePartyMenu *menu, u8 screen);

// Draws the buttons of a battle party menu screen in the states they take
// there (ov08_02221E6C; state 3 is greyed out). On the list (screen 0) each
// Pokemon's button is drawn by what ov08_0221D5DC says of it, and Cancel is
// greyed when a switch cannot be declined (mode 1); on the submenu of the
// Pokemon picked (1), SUMMARY and CHECK MOVES are greyed for an Egg; the
// screens after those grey the buttons of empty move slots.
void ov08_022221CC(BattlePartyMenu *menu, u8 screen) {
    u16 i;

    switch (screen) {
    case 0:
        for (i = 0; i < 6; i++) {
            int kind = ov08_0221D5DC(menu, i);
            if (kind == 0) {
                ov08_02221E6C(menu, i, 3, 1);
            } else if (kind == 1) {
                ov08_02221E6C(menu, i, 0, 0);
            } else if (kind == 2) {
                ov08_02221E6C(menu, i, 0, 1);
            }
        }
        if (menu->args->mode == 1) {
            ov08_02221E6C(menu, 6, 3, 0);
        } else {
            ov08_02221E6C(menu, 6, 0, 0);
        }
        break;
    case 1:
        ov08_02221E6C(menu, 6, 0, 0);
        ov08_02221E6C(menu, 7, 0, 0);
        if (menu->mons[menu->args->selectedPos].isEgg) {
            ov08_02221E6C(menu, 8, 3, 0);
            ov08_02221E6C(menu, 10, 3, 0);
        } else {
            ov08_02221E6C(menu, 8, 0, 0);
            ov08_02221E6C(menu, 10, 0, 0);
        }
        break;
    case 2:
        if (ov08_02222564(menu) == 1) {
            ov08_02221E6C(menu, 12, 0, 0);
            ov08_02221E6C(menu, 13, 0, 0);
        } else {
            ov08_02221E6C(menu, 12, 3, 0);
            ov08_02221E6C(menu, 13, 3, 0);
        }
        ov08_02221E6C(menu, 11, 0, 0);
        ov08_02221E6C(menu, 6, 0, 0);
        break;
    case 3:
        if (ov08_02222564(menu) == 1) {
            ov08_02221E6C(menu, 12, 0, 0);
            ov08_02221E6C(menu, 13, 0, 0);
        } else {
            ov08_02221E6C(menu, 12, 3, 0);
            ov08_02221E6C(menu, 13, 3, 0);
        }
        for (i = 0; i < 4; i++) {
            if (menu->mons[menu->args->selectedPos].moves[i].move != 0) {
                ov08_02221E6C(menu, i + 14, 0, 0);
            } else {
                ov08_02221E6C(menu, i + 14, 3, 0);
            }
        }
        ov08_02221E6C(menu, 9, 0, 0);
        ov08_02221E6C(menu, 6, 0, 0);
        break;
    case 4:
        ov08_02221E6C(menu, 6, 0, 0);
        for (i = 0; i < 4; i++) {
            if (menu->args->unk34 == i) {
                ov08_02221E6C(menu, i + 30, 2, 0);
            } else {
                ov08_02221E6C(menu, i + 30, 0, 0);
            }
        }
        break;
    case 5:
        for (i = 0; i < 4; i++) {
            if (menu->mons[menu->args->selectedPos].moves[i].move != 0) {
                ov08_02221E6C(menu, i + 19, 0, 0);
            } else {
                ov08_02221E6C(menu, i + 19, 3, 0);
            }
        }
        ov08_02221E6C(menu, 6, 0, 0);
        break;
    case 6:
    case 8:
        ov08_02221E6C(menu, 23, 0, 0);
        ov08_02221E6C(menu, 24, 0, 0);
        ov08_02221E6C(menu, 25, 0, 0);
        ov08_02221E6C(menu, 26, 0, 0);
        ov08_02221E6C(menu, 27, 0, 0);
        ov08_02221E6C(menu, 6, 0, 0);
        if (menu->unk2077_4 == 1) {
            ov08_02221E6C(menu, 18, 0, 0);
        }
        break;
    case 7:
        ov08_02221E6C(menu, 28, 0, 0);
        ov08_02221E6C(menu, 6, 0, 0);
        if (menu->unk2077_4 == 1) {
            ov08_02221E6C(menu, 18, 0, 0);
        }
        break;
    case 9:
        ov08_02221E6C(menu, 29, 0, 0);
        ov08_02221E6C(menu, 6, 0, 0);
        if (menu->unk2077_4 == 1) {
            ov08_02221E6C(menu, 18, 0, 0);
        }
        break;
    }
}
