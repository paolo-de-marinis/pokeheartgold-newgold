#include "global.h"

#include "constants/species.h"

#include "pokemon.h"
#include "pokemon_summary_app.h"
#include "sound_chatot.h"
#include "unk_02005D10.h"

void sub_02089C50(PokemonSummaryAppPrefix *summary) {
    u8 delay;

    if (summary->mon.isEgg) {
        return;
    }
    sub_020729A4(summary->unk7B8, &delay, summary->mon.species, 1);
    if (summary->mon.species == SPECIES_CHATOT) {
        sub_02006EA0((SOUND_CHATOT *)summary->args->unk28, 0, 100, 0, delay);
    } else {
        // The form, which is what the cry tells Sky Shaymin from Land by. The
        // halfword this read before is the ability's now (the record's form
        // and ability swapped places so a full ability ID fits), and the
        // reference's summary patches leave this reader on it.
        sub_020062E0(summary->mon.species, delay, summary->mon.form);
    }
}
