#include "overlay_112.h"

typedef char PokewalkerTrainerHouseMonSizeCheck[sizeof(TrainerHouseMon) == 0x38 ? 1 : -1];
typedef char PokewalkerTrainerHouseAbilityOffsetCheck[offsetof(TrainerHouseMon, ability) == 0x20 ? 1 : -1];
typedef char PokewalkerTrainerHouseNicknameOffsetCheck[offsetof(TrainerHouseMon, nickname) == 0x24 ? 1 : -1];

// NONMATCHING: two private stack slots are exchanged; all other instructions match.
// The compiled-instruction equivalence audit is recorded in docs/newgold/VALIDATION.md.
void ov112_021F33D8(TrainerHouseMon *dest, Party *party) {
    u16 nickname[POKEMON_NAME_LENGTH + 1];
    int i;
    int j;
    int count = Party_GetCount(party);
    int copied = 0;
    u32 ppUp;
    BOOL restoreShayminForm;

    for (i = 0; i < count; i++) {
        restoreShayminForm = FALSE;
        Pokemon *mon = Party_GetMonByIndex(party, i);
        if (GetMonData(mon, MON_DATA_CHECKSUM_FAILED, NULL) || GetMonData(mon, MON_DATA_IS_EGG, NULL)) {
            continue;
        }
        dest->species = (u16)GetMonData(mon, MON_DATA_SPECIES, NULL);
        dest->form = (u16)GetMonData(mon, MON_DATA_FORM, NULL);
        if (dest->species == SPECIES_SHAYMIN && dest->form == 1) {
            Mon_UpdateShayminForm(mon, 0);
            dest->form = 0;
            restoreShayminForm = TRUE;
        }
        dest->item = GetMonData(mon, MON_DATA_HELD_ITEM, NULL);
        dest->otid = GetMonData(mon, MON_DATA_OT_ID, NULL);
        dest->pid = GetMonData(mon, MON_DATA_PERSONALITY, NULL);
        dest->language = GetMonData(mon, MON_DATA_LANGUAGE, NULL);
        dest->ability = GetMonData(mon, MON_DATA_ABILITY, NULL);
        dest->friendship = GetMonData(mon, MON_DATA_FRIENDSHIP, NULL);
        dest->level = GetMonData(mon, MON_DATA_LEVEL, NULL);
        GetMonData(mon, MON_DATA_NICKNAME, nickname);
        CopyU16StringArrayN(dest->nickname, nickname, POKEMON_NAME_LENGTH);
        ppUp = 0;
        for (j = 0; j < MAX_MON_MOVES; j++) {
            dest->moves[j] = GetMonData(mon, MON_DATA_MOVE1 + j, NULL);
            ppUp |= GetMonData(mon, MON_DATA_MOVE1_PP_UPS + j, NULL) << (j * 2);
        }
        dest->ppUp = ppUp;
        u32 ivs = 0;
        for (j = 0; j < NUM_STATS; j++) {
            ivs |= GetMonData(mon, MON_DATA_HP_IV + j, NULL) << (j * 5);
            *(&dest->hpEv + j) = GetMonData(mon, MON_DATA_HP_EV + j, NULL);
        }
        dest->ivsWord = ivs;
        if (restoreShayminForm) {
            Mon_UpdateShayminForm(mon, 1);
        }
        dest++;
        if (++copied >= PARTY_SIZE) {
            break;
        }
    }
}
