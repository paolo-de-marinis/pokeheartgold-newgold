#include "global.h"

#include "constants/species.h"

#include "overlay_109_021E7850.h"

// The album's twin of Photo_CountValidMons (view_photo.c): how many of the
// photo's party are Pokemon, which picks the single-Pokemon caption or the
// "... and friends" one. Added species count too, up to the last species.
u8 ov109_021E7850(Photo *photo) {
    u8 answer = 0;
    for (u8 i = 0; i < PARTY_SIZE; ++i) {
        int species = photo->party[i].species;
        if (species > SPECIES_NONE && species <= NUM_SPECIES) {
            ++answer;
        }
    }
    return answer;
}
