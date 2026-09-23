#include "global.h"

#include "constants/species.h"

#include "overlay_14.h"
#include "pokemon.h"

// A box Pokemon's form after its held item has changed: an Arceus follows its
// plate and a Giratina its Griseous Orb. TRUE when the form changed, so the
// PC redraws the Pokemon's icon.
BOOL ov14_021E64D0(BoxPokemon *boxMon) {
    u16 species = GetBoxMonData(boxMon, MON_DATA_SPECIES, NULL);
    u16 form;

    if (species == SPECIES_ARCEUS) {
        form = GetBoxMonData(boxMon, MON_DATA_FORM, NULL);
        BoxMon_UpdateArceusForm(boxMon);
        if (form != (u16)GetBoxMonData(boxMon, MON_DATA_FORM, NULL)) {
            return TRUE;
        }
    } else if (species == SPECIES_GIRATINA) {
        form = GetBoxMonData(boxMon, MON_DATA_FORM, NULL);
        BoxMon_UpdateGiratinaForm(boxMon);
        if (form != (u16)GetBoxMonData(boxMon, MON_DATA_FORM, NULL)) {
            return TRUE;
        }
    }
    return FALSE;
}
