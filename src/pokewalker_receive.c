#include "constants/map_sections.h"

#include "math_util.h"
#include "overlay_112.h"
#include "pokemon_storage_system.h"
#include "save_arrays.h"
#include "trainer_memo.h"

typedef char PokewalkerCaughtMonSizeCheck[sizeof(PokewalkerCaughtMon) == 0x10 ? 1 : -1];
typedef char PokewalkerGiftMonSizeCheck[sizeof(PokewalkerGiftMon) == 0x34 ? 1 : -1];
typedef char PokewalkerGiftAbilityOffsetCheck[offsetof(PokewalkerGiftMon, ability) == 0x2F ? 1 : -1];
typedef char PokewalkerGiftBallOffsetCheck[offsetof(PokewalkerGiftMon, pokeball) == 0x30 ? 1 : -1];
typedef char PokewalkerCaughtMonsOffsetCheck[offsetof(PokewalkerReceiveStatePrefix, caughtMons) == 0x9D7C ? 1 : -1];
typedef char PokewalkerGiftOffsetCheck[offsetof(PokewalkerReceiveStatePrefix, giftMon) == 0xAD00 ? 1 : -1];
typedef char PokewalkerReceivedGiftOffsetCheck[offsetof(PokewalkerReceiveStatePrefix, receivedGiftMon) == 0x1E430 ? 1 : -1];
typedef char PokewalkerProfileOffsetCheck[offsetof(PokewalkerReceiveStatePrefix, profile) == 0x1E438 ? 1 : -1];
typedef char PokewalkerSaveOffsetCheck[offsetof(PokewalkerReceiveStatePrefix, pokewalker) == 0x1E440 ? 1 : -1];
typedef char PokewalkerPokedexOffsetCheck[offsetof(PokewalkerReceiveStatePrefix, pokedex) == 0x1E444 ? 1 : -1];

void ov112_021EEAF0(PokewalkerReceiveStatePrefix *state, BOOL usePreviousBox) {
    u16 unusedState;
    u16 savedBox;
    u8 otGender;
    u8 fatefulEncounter;
    int box;
    int slot;
    PokewalkerCaughtMon *gift;
    PCStorage *storage = SaveArray_PCStorage_Get(state->saveData);
    Pokemon *mon = AllocMonZeroed(HEAP_ID_154);
    String *playerName = PlayerProfile_GetPlayerName_NewString(state->profile, HEAP_ID_154);
    int i;

    sub_02032688(state->pokewalker, &unusedState, &savedBox);
    box = usePreviousBox ? savedBox : 0;
    slot = 0;
    PokewalkerCaughtMon *caught = state->caughtMons;
    for (i = 0; i < POKEWALKER_CAUGHT_MON_COUNT; i++, caught++) {
        if (caught->species != SPECIES_NONE) {
            // Vanilla excludes the last nature from Pokewalker generation.
            ov112_021EE9A4(mon, state->profile, caught, MTRandom() % (NATURE_NUM - 1), FALSE);
            BoxMonSetTrainerMemo(Mon_GetBoxMon(mon), state->profile, 0, MAPSEC_POKEWALKER, HEAP_ID_154);
            BoxPokemon *boxMon = Mon_GetBoxMon(mon);
            PCStorage_FindFirstEmptySlot(storage, &box, &slot);
            PCStorage_PlaceMonInBoxByIndexPair(storage, box, slot, boxMon);
            Pokedex_SetMonSeenFlag(state->pokedex, mon);
            Pokedex_SetMonCaughtFlag(state->pokedex, mon);
        }
    }
    if (state->hasGiftMon) {
        String *otName = String_New(16, HEAP_ID_154);
        gift = &state->giftMon.mon;
        if (gift->species != SPECIES_NONE) {
            CopyU16ArrayToString(otName, state->giftMon.otName);
            ZeroMonData(mon);
            BoxPokemon *boxMon = Mon_GetBoxMon(mon);
            u32 nature = MTRandom() % (NATURE_NUM - 1);
            ov112_021EE9E4(mon, state->giftMon.otId, gift, nature, gift->shiny);
            otGender = state->giftMon.otGender;
            SetBoxMonData(boxMon, MON_DATA_OT_GENDER, &otGender);
            SetBoxMonData(boxMon, MON_DATA_OT_NAME_STRING, otName);
            BoxMonSetTrainerMemo(Mon_GetBoxMon(mon), state->profile, 4, state->giftMon.metLocation, HEAP_ID_154);
            SetBoxMonData(boxMon, MON_DATA_ABILITY, &state->giftMon.ability);
            fatefulEncounter = TRUE;
            SetBoxMonData(boxMon, MON_DATA_FATEFUL_ENCOUNTER, &fatefulEncounter);
            SetBoxMonData(boxMon, MON_DATA_POKEBALL, &state->giftMon.pokeball);
            PCStorage_FindFirstEmptySlot(storage, &box, &slot);
            PCStorage_PlaceMonInBoxByIndexPair(storage, box, slot, boxMon);
            Pokedex_SetMonSeenFlag(state->pokedex, mon);
            Pokedex_SetMonCaughtFlag(state->pokedex, mon);
            if (state->receivedGiftMon == NULL) {
                state->receivedGiftMon = PCStorage_GetMonByIndexPair(storage, box, slot);
            }
        }
        String_Delete(otName);
    }
    String_Delete(playerName);
    Heap_Free(mon);
}
