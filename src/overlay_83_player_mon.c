#include "move.h"
#include "overlay_83.h"

// The remaining overlay assembly consumes this original record layout.
typedef char Ov83SummarySizeCheck[sizeof(Ov83MonSummary) == 0x34 ? 1 : -1];
typedef char Ov83SummaryAbilityOffsetCheck[offsetof(Ov83MonSummary, ability) == 0xC ? 1 : -1];
typedef char Ov83SummaryMovesOffsetCheck[offsetof(Ov83MonSummary, moves) == 0x24 ? 1 : -1];
typedef char Ov83SummaryPartyOffsetCheck[offsetof(Ov83PlayerSummaryStatePrefix, party) == 0x7A4 ? 1 : -1];
typedef char Ov83SummaryOffsetCheck[offsetof(Ov83PlayerSummaryStatePrefix, summary) == 0x804 ? 1 : -1];

void ov83_02241E18(Ov83PlayerSummaryStatePrefix *state) {
    u16 i;
    u16 ppUps;
    Pokemon *mon;
    BOOL locked;

    mon = Party_GetMonByIndex(state->party, ov83_02247768(state->unk14, state->selectedMon));
    locked = AcquireMonLock(mon);
    state->summary.mon = mon;
    state->summary.boxMon = Mon_GetBoxMon(mon);
    state->summary.species = GetMonData(mon, MON_DATA_SPECIES, NULL);
    state->summary.level = GetMonData(mon, MON_DATA_LEVEL, NULL);
    state->summary.ability = GetMonData(mon, MON_DATA_ABILITY, NULL);
    state->summary.nature = GetMonNature(mon);
    state->summary.heldItem = GetMonData(mon, MON_DATA_HELD_ITEM, NULL);
    state->summary.hp = GetMonData(mon, MON_DATA_HP, NULL);
    state->summary.maxHp = GetMonData(mon, MON_DATA_MAX_HP, NULL);
    state->summary.attack = GetMonData(mon, MON_DATA_ATK, NULL);
    state->summary.spAttack = GetMonData(mon, MON_DATA_SP_ATK, NULL);
    state->summary.defense = GetMonData(mon, MON_DATA_DEF, NULL);
    state->summary.spDefense = GetMonData(mon, MON_DATA_SP_DEF, NULL);
    state->summary.speed = GetMonData(mon, MON_DATA_SPEED, NULL);
    state->summary.form = GetMonData(mon, MON_DATA_FORM, NULL);
    state->summary.personality = GetMonData(mon, MON_DATA_PERSONALITY, NULL);
    if (GetMonData(mon, MON_DATA_NO_PRINT_GENDER, NULL) == TRUE) {
        state->summary.hideGender = FALSE;
    } else {
        state->summary.hideGender = TRUE;
    }
    state->summary.gender = GetMonGender(mon);

    for (i = 0; i < MAX_MON_MOVES; i++) {
        state->summary.moves[i] = GetMonData(mon, MON_DATA_MOVE1 + i, NULL);
        state->summary.pp[i] = GetMonData(mon, MON_DATA_MOVE1_PP + i, NULL);
        ppUps = GetMonData(mon, MON_DATA_MOVE1_PP_UPS + i, NULL);
        state->summary.maxPp[i] = GetMoveMaxPP(state->summary.moves[i], ppUps);
    }
    ReleaseMonLock(mon, locked);
}
