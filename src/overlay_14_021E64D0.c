#include "global.h"

#include "constants/species.h"

#include "overlay_14.h"
#include "party.h"
#include "pokemon.h"
#include "save.h"

// A Pokemon's form after its held item has changed in the PC: an Arceus
// follows its plate, a Silvally its Memory, a Giratina its Griseous Orb or
// Core, and a Genesect, an Ogerpon, a Dialga or a Palkia becomes the form its
// Drive, mask or origin item gives, as in the party menu. TRUE when the form
// changed, so the PC redraws the Pokemon's icon.
//
// The PC reaches the party's Pokemon through their box half, which has no
// stats, so a Pokemon of the party whose form changed has them worked out
// again here, as the party menu does.
BOOL ov14_021E64D0(BoxPokemon *boxMon) {
    u16 species = GetBoxMonData(boxMon, MON_DATA_SPECIES, NULL);
    u16 form;
    BOOL changed;
    Party *party;
    int i;

    if (species == SPECIES_ARCEUS || species == SPECIES_SILVALLY) {
        form = GetBoxMonData(boxMon, MON_DATA_FORM, NULL);
        BoxMon_UpdateArceusForm(boxMon);
        changed = form != (u16)GetBoxMonData(boxMon, MON_DATA_FORM, NULL);
    } else if (species == SPECIES_GIRATINA) {
        form = GetBoxMonData(boxMon, MON_DATA_FORM, NULL);
        BoxMon_UpdateGiratinaForm(boxMon);
        changed = form != (u16)GetBoxMonData(boxMon, MON_DATA_FORM, NULL);
    } else {
        changed = BoxMon_UpdateHeldItemForm(boxMon);
    }

    if (changed) {
        party = SaveArray_Party_Get(SaveData_Get());
        for (i = 0; i < Party_GetCount(party); i++) {
            if (Mon_GetBoxMon(Party_GetMonByIndex(party, i)) == boxMon) {
                CalcMonLevelAndStats(Party_GetMonByIndex(party, i));
            }
        }
    }
    return changed;
}
