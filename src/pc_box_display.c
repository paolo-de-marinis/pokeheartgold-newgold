#include "pc_box_display.h"

#include "constants/species.h"

#include "heap.h"
#include "pokemon.h"

// The remaining PC assembly shares this record's original layout.
typedef char PCBoxDisplayMonSizeCheck[sizeof(PCBoxDisplayMon) == 0x1C ? 1 : -1];
typedef char PCBoxDisplayMonSpeciesCheck[offsetof(PCBoxDisplayMon, species) == 0x04 ? 1 : -1];
typedef char PCBoxDisplayMonItemCheck[offsetof(PCBoxDisplayMon, heldItem) == 0x06 ? 1 : -1];
typedef char PCBoxDisplayMonPersonalityCheck[offsetof(PCBoxDisplayMon, personality) == 0x08 ? 1 : -1];
typedef char PCBoxDisplayMonType1Check[offsetof(PCBoxDisplayMon, type1) == 0x0C ? 1 : -1];
typedef char PCBoxDisplayMonType2Check[offsetof(PCBoxDisplayMon, type2) == 0x0D ? 1 : -1];
typedef char PCBoxDisplayMonAbilityCheck[offsetof(PCBoxDisplayMon, ability) == 0x0E ? 1 : -1];
typedef char PCBoxDisplayMonNatureCheck[offsetof(PCBoxDisplayMon, nature) == 0x0F ? 1 : -1];
typedef char PCBoxDisplayMonMarkingsCheck[offsetof(PCBoxDisplayMon, markings) == 0x10 ? 1 : -1];
typedef char PCBoxDisplayMonMovesCheck[offsetof(PCBoxDisplayMon, moves) == 0x14 ? 1 : -1];

PCBoxDisplayMon *ov14_021E7358(BoxPokemon *mon) {
    PCBoxDisplayMon *displayMon;

    if (GetBoxMonData(mon, MON_DATA_SPECIES_EXISTS, NULL)) {
        displayMon = Heap_Alloc(HEAP_ID_10, sizeof(PCBoxDisplayMon));
        displayMon->mon = mon;
        displayMon->species = GetBoxMonData(mon, MON_DATA_SPECIES, NULL);
        displayMon->heldItem = GetBoxMonData(mon, MON_DATA_HELD_ITEM, NULL);
        displayMon->personality = GetBoxMonData(mon, MON_DATA_PERSONALITY, NULL);
        displayMon->type1 = GetBoxMonData(mon, MON_DATA_TYPE_1, NULL);
        displayMon->type2 = GetBoxMonData(mon, MON_DATA_TYPE_2, NULL);
        displayMon->ability = GetBoxMonData(mon, MON_DATA_ABILITY, NULL);
        displayMon->nature = GetBoxMonNature(mon);
        displayMon->markings = GetBoxMonData(mon, MON_DATA_MARKINGS, NULL);
        displayMon->level = (u8)GetBoxMonData(mon, MON_DATA_LEVEL, NULL);
        displayMon->isEgg = (u8)GetBoxMonData(mon, MON_DATA_IS_EGG, NULL);
        displayMon->gender = GetBoxMonGender(mon);

        if (displayMon->species != SPECIES_NIDORAN_F && displayMon->species != SPECIES_NIDORAN_M && !displayMon->isEgg) {
            displayMon->showGender = TRUE;
        } else {
            displayMon->showGender = FALSE;
        }

        for (u32 i = 0; i < MAX_MON_MOVES; i++) {
            displayMon->moves[i] = GetBoxMonData(mon, MON_DATA_MOVE1 + i, NULL);
        }
    } else {
        displayMon = NULL;
    }

    return displayMon;
}
