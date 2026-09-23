#include "global.h"

#include "pokeathlon/pokeathlon.h"
#include "pokeathlon/pokeathlon_save.h"

#include "pokedex.h"

// A Pokemon on the course, as ov97 fills it from the party: three a
// participant, after the participant's first four bytes.
typedef struct PokeathlonCourseMon {
    u16 species;
    u16 form;
    u32 unk_04;
    u8 filler_08[8];
    u8 unk_10;
    u8 unk_11;
    u8 filler_12[0x16];
} PokeathlonCourseMon; // size: 0x28

// The course's result, where the course data keeps it: the three events'
// scores and their total.
typedef struct PokeathlonCourseResult {
    u8 filler_000[0x8B4];
    u16 scores[3];
    u8 filler_8BA[0x44];
    u16 total;
} PokeathlonCourseResult;

// A course finished alone: if its total beats the course's record, the
// record takes the scores, each at most 999, and the team that set them.
void ov96_021E786C(PokeathlonCourseData *data, PokeathlonSave *save) {
    Pokeathlon_CourseRecord *record = &save->courseRecords[data->args->course];
    int i;

    if (((PokeathlonCourseResult *)data)->total > record->total) {
        record->total = ((PokeathlonCourseResult *)data)->total;
        if (record->total > 999) {
            record->total = 999;
        }
        for (i = 0; i < 3; i++) {
            record->scores[i] = ((PokeathlonCourseResult *)data)->scores[i];
            if (record->scores[i] > 999) {
                record->scores[i] = 999;
            }
        }
        PokeathlonCourseMon *mons = (PokeathlonCourseMon *)PokeathlonCourse_GetParticipantUnk04(data, ov96_021E5F24(data));
        for (i = 0; i < 3; i++) {
            // The record keeps a species in nine bits and the course-record
            // screen (ov98_0221EE28) prints nothing past Arceus, so an added
            // species is kept as its retail base, as a form is in the Dex
            // (a Mega Venusaur as Venusaur), or as none when it has no retail
            // base -- as added species earn no medals. Kept whole, 512 on
            // were cut to another retail species and 494..511 failed the
            // screen's assertion, a reset with a wireless link up.
            u16 species = mons[i].species;
            u16 form = mons[i].form;
            if (species > MAX_SPECIES) {
                species = SpeciesToDexSpecies(species);
                form = 0;
                if (species > MAX_SPECIES) {
                    species = SPECIES_NONE;
                }
            }
            record->mons[i].species = species;
            record->mons[i].form = form;
            record->mons[i].unk_0_14 = mons[i].unk_11;
            record->mons[i].unk_0_16 = mons[i].unk_10;
            record->mons[i].unk_04 = mons[i].unk_04;
        }
    }
}
