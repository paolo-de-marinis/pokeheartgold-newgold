#include "global.h"

#include "application/pokedex/pokedex_internal.h"
#include "msgdata/msg/msg_0802.h"

#include "message_format.h"
#include "string.h"

// The name of the FORMS page's entry idx (seenForms, ov18_021E8254): the
// form's for the species the Dex tells forms apart for, Male or Female, and
// the species' name for one seen genderless. The message to print is
// returned; the species' name goes in the message format's first field.
int ov18_021F09D8(PokedexAppData *pokedexApp, int idx) {
    String *name;

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
