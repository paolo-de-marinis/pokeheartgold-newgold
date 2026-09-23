#include "global.h"

#include "constants/mmodel.h"

#include "follow_mon.h"
#include "pokeathlon/pokeathlon.h"

// The Pokeathlon's walking sprite for a Pokemon on the course: the
// mmodel member of its follower model, its female one or its form's, and
// member 1 for a species past retail's.
u32 ov96_021E91B8(int species, int form, int gender) {
    u32 ret;

    if (species <= SPECIES_NONE || species > MAX_SPECIES) {
        ret = 1;
    } else {
        ret = MMODEL_FOLLOWER_MON_BASE + SpeciesToOverworldModelIndexOffset(species);
        if (OverworldModelLookupHasFemaleForm(species)) {
            if (gender == MON_FEMALE) {
                ret++;
            }
        } else {
            if (form > OverworldModelLookupFormCount(species)) {
                form = 0;
            }
            ret += form;
        }
    }
    return ret;
}
