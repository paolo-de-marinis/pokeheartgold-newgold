#include "global.h"

#include "constants/sndseq.h"

#include "palette.h"
#include "unk_02005D10.h"

#include "battle_party_menu.h"

BOOL ov08_0221D438(BattlePartyMenu *menu);
void ov08_022220AC(BattlePartyMenu *menu, u8 pos);
int ov08_0221C1C8(BattlePartyMenu *menu);
int ov08_0221C14C(BattlePartyMenu *menu);

// The battle party menu's list, once the palette has faded in: a Pokemon
// picked opens its submenu (state 22), or, with an item to use (mode 2), has
// the item used on it; Cancel closes the menu (state 25), except when a
// switch cannot be declined (mode 1). 1 is to keep waiting.
int ov08_0221C14C(BattlePartyMenu *menu) {
    if (PaletteData_GetSelectedBuffersBitmask(menu->paletteData) != 0) {
        return 1;
    }
    if (ov08_0221D438(menu) == TRUE) {
        if (menu->args->selectedPos == 6) {
            if (menu->args->mode != 1) {
                PlaySE(SEQ_SE_DP_DECIDE);
                ov08_022220AC(menu, 6);
                return 25;
            }
        } else {
            PlaySE(SEQ_SE_DP_DECIDE);
            ov08_022220AC(menu, menu->args->selectedPos);
            if (menu->args->mode == 2) {
                return ov08_0221C1C8(menu);
            }
            menu->nextState = 7;
            return 22;
        }
    }
    return 1;
}
