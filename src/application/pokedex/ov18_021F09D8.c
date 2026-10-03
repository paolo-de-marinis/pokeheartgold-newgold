#include "global.h"

#include "application/pokedex/pokedex_internal.h"
#include "msgdata/msg/msg_0802.h"

#include "message_format.h"
#include "string.h"

// The forms that are species of their own here which the FORMS page names by
// their region, as the latest games' Dex does: "Galarian Form", and Paldean
// Tauros by its breed. Any other is named as its species.
static const struct {
    u16 first;
    u16 last;
    u16 msg;
} sRegionalForms[] = {
    { SPECIES_SLOWPOKE_GALARIAN, SPECIES_SLOWBRO_GALARIAN, msg_0802_00178 },
    { SPECIES_RATTATA_ALOLAN, SPECIES_MAROWAK_ALOLAN, msg_0802_00177 },
    { SPECIES_MEOWTH_GALARIAN, SPECIES_STUNFISK_GALARIAN, msg_0802_00178 },
    { SPECIES_GROWLITHE_HISUIAN, SPECIES_DECIDUEYE_HISUIAN, msg_0802_00179 },
    { SPECIES_WOOPER_PALDEAN, SPECIES_WOOPER_PALDEAN, msg_0802_00180 },
    { SPECIES_TAUROS_COMBAT, SPECIES_TAUROS_COMBAT, msg_0802_00181 },
    { SPECIES_TAUROS_BLAZE, SPECIES_TAUROS_BLAZE, msg_0802_00182 },
    { SPECIES_TAUROS_AQUA, SPECIES_TAUROS_AQUA, msg_0802_00183 },
};

// The name of the FORMS page's entry idx (seenForms, ov18_021E8254): the
// form's for the species the Dex tells forms apart for, Male or Female, and
// the species' name for one seen genderless or a form of no region. The
// message to print is returned; the species' name goes in the message
// format's first field.
int ov18_021F09D8(PokedexAppData *pokedexApp, int idx) {
    String *name;
    u16 form = pokedexApp->seenFormSpecies[idx];

    if (form != pokedexApp->curSpecies) {
        for (u32 i = 0; i < NELEMS(sRegionalForms); i++) {
            if (form >= sRegionalForms[i].first && form <= sRegionalForms[i].last) {
                return sRegionalForms[i].msg;
            }
        }
    }
    switch (pokedexApp->curSpecies) {
    case SPECIES_UNOWN:
        return msg_0802_00121;
    case SPECIES_SHELLOS:
    case SPECIES_GASTRODON:
        return (pokedexApp->seenForms[idx] ^ 0x80) + msg_0802_00116;
    case SPECIES_BURMY:
    case SPECIES_WORMADAM:
        return (pokedexApp->seenForms[idx] ^ 0x80) + msg_0802_00118;
    case SPECIES_DEOXYS:
        return (pokedexApp->seenForms[idx] ^ 0x80) + msg_0802_00145;
    case SPECIES_SHAYMIN:
        return (pokedexApp->seenForms[idx] ^ 0x80) + msg_0802_00149;
    case SPECIES_GIRATINA:
        return (pokedexApp->seenForms[idx] ^ 0x80) + msg_0802_00151;
    case SPECIES_ROTOM:
        return (pokedexApp->seenForms[idx] ^ 0x80) + msg_0802_00153;
    case SPECIES_CASTFORM:
        return (pokedexApp->seenForms[idx] ^ 0x80) + msg_0802_00160;
    case SPECIES_CHERRIM:
        return (pokedexApp->seenForms[idx] ^ 0x80) + msg_0802_00164;
    case SPECIES_PICHU: {
        int form = pokedexApp->seenForms[idx] ^ 0x80;
        if (form == 0) {
            return msg_0802_00114;
        }
        if (form == 1) {
            return msg_0802_00115;
        }
        return msg_0802_00166;
    }
    }
    if (pokedexApp->seenForms[idx] == 1) {
        return msg_0802_00114;
    }
    if (pokedexApp->seenForms[idx] == 2) {
        return msg_0802_00115;
    }
    name = ov18_021E590C(pokedexApp->curSpecies, 2, HEAP_ID_POKEDEX_APP);
    BufferString(pokedexApp->msgFormat, 0, name, 2, 1, 2);
    String_Delete(name);
    return msg_0802_00159;
}
