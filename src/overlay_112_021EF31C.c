#include "constants/pokemon.h"

#include "overlay_112.h"
#include "party.h"
#include "pokemon.h"
#include "pokemon_storage_system.h"
#include "save_arrays.h"
#include "string_util.h"

typedef char PokewalkerSelectionOffsetCheck[offsetof(PokewalkerReceiveStatePrefix, selection) == 0x1D764 ? 1 : -1];
typedef char PokewalkerSelectionFormCheck[offsetof(PokewalkerSelection, form) == 0x30 ? 1 : -1];
typedef char PokewalkerPartyMonOffsetCheck[offsetof(PokewalkerReceiveStatePrefix, partyMon) == 0x1E42C ? 1 : -1];

// What ov112_021EF1F0 reads out of a box Pokemon.
typedef struct PokewalkerBoxMonSummary {
    u32 species;
    u32 personality;
    u16 unk8;
    u16 form;
    u16 heldItem;
    u16 unkE;
    u16 shiny;
    u16 gender;
    u16 level;
    u16 markings;
    u16 nickname[POKEMON_NAME_LENGTH + 1];
} PokewalkerBoxMonSummary;

// What the walker is sent about the Pokemon picked for it.
typedef struct PokewalkerMonInfo {
    u32 personality;
    u16 species;
    u8 shiny;
    u8 form;
    u8 gender;
    u8 status; // 2 for a Pokemon, 0 for none
    u16 nickname[POKEMON_NAME_LENGTH + 1];
    u8 markings[6];
    u16 heldItem;
    u8 level;
} PokewalkerMonInfo;

void ov112_021EF1F0(PCStorage *pcStorage, int box, int slot, PokewalkerBoxMonSummary *summary);
void ov112_021F04DC(void *a0, PokewalkerMonInfo *info);

// Reads the picked Pokemon into the selection, from the party when the box
// is the selector's party page.
void ov112_021EF31C(PokewalkerSelection *selection, PokewalkerReceiveStatePrefix *state) {
    PokewalkerBoxMonSummary summary;

    if (selection->unk14 == 0) {
        int box = selection->box;
        if (box == NUM_BOXES) {
            Pokemon *mon = Party_GetMonByIndex(SaveArray_Party_Get(state->saveData), selection->slot);
            selection->species = GetMonData(mon, MON_DATA_SPECIES, NULL);
            selection->form = GetMonData(mon, MON_DATA_FORM, NULL);
            GetMonData(mon, MON_DATA_NICKNAME, selection->nickname);
            selection->shiny = MonIsShiny(mon);
            selection->gender = GetMonData(mon, MON_DATA_GENDER, NULL);
            state->partyMon = mon;
            state->receivedGiftMon = NULL;
            return;
        }
        BoxPokemon *boxMon = PCStorage_GetMonByIndexPair(SaveArray_PCStorage_Get(state->saveData), box, selection->slot);
        if (GetBoxMonData(boxMon, MON_DATA_SPECIES_EXISTS, NULL)) {
            state->receivedGiftMon = boxMon;
            state->partyMon = NULL;
        }
        ov112_021EF1F0(SaveArray_PCStorage_Get(state->saveData), selection->box, selection->slot, &summary);
        selection->species = summary.species;
        selection->form = summary.form;
        CopyU16StringArrayN(selection->nickname, summary.nickname, POKEMON_NAME_LENGTH + 1);
        selection->shiny = summary.shiny;
        selection->gender = summary.gender;
    }
}

// The box selector's callback: sends the walker what it needs to show the
// Pokemon at box and slot, or that there is none.
void ov112_021EF3F8(int box, int slot, PokewalkerReceiveStatePrefix *state) {
    PokewalkerSelection *selection = &state->selection;
    PokewalkerMonInfo info;
    PokewalkerBoxMonSummary summary;
    u8 i;

    if (box != -1 && slot != -1) {
        info.status = 2;
        if (box == NUM_BOXES) {
            Pokemon *mon = Party_GetMonByIndex(SaveArray_Party_Get(state->saveData), slot);
            info.personality = GetMonData(mon, MON_DATA_PERSONALITY, NULL);
            info.species = GetMonData(mon, MON_DATA_SPECIES, NULL);
            info.form = GetMonData(mon, MON_DATA_FORM, NULL);
            GetMonData(mon, MON_DATA_NICKNAME, info.nickname);
            info.shiny = MonIsShiny(mon);
            info.gender = GetMonData(mon, MON_DATA_GENDER, NULL);
            int markings = GetMonData(mon, MON_DATA_MARKINGS, NULL);
            for (i = 0; i < 6; i++) {
                if ((markings >> i) & 1) {
                    info.markings[i] = TRUE;
                } else {
                    info.markings[i] = FALSE;
                }
            }
            info.heldItem = GetMonData(mon, MON_DATA_HELD_ITEM, NULL);
            info.level = GetMonData(mon, MON_DATA_LEVEL, NULL);
            ov112_021F04DC(selection->unk8, &info);
        } else {
            ov112_021EF1F0(SaveArray_PCStorage_Get(state->saveData), box, slot, &summary);
            info.personality = summary.personality;
            info.species = summary.species;
            info.form = summary.form;
            CopyU16StringArrayN(info.nickname, summary.nickname, POKEMON_NAME_LENGTH + 1);
            info.shiny = summary.shiny;
            info.gender = summary.gender;
            u16 markings = summary.markings;
            for (i = 0; i < 6; i++) {
                if ((markings >> i) & 1) {
                    info.markings[i] = TRUE;
                } else {
                    info.markings[i] = FALSE;
                }
            }
            info.heldItem = summary.heldItem;
            info.level = summary.level;
            ov112_021F04DC(selection->unk8, &info);
        }
    } else {
        info.status = 0;
        ov112_021F04DC(selection->unk8, &info);
    }
}
