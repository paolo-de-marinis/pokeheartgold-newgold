#include "constants/ribbon.h"

#include "msgdata/msg/msg_0302.h"

#include "move.h"
#include "party_menu.h"
#include "pokemon.h"
#include "pokemon_summary_app.h"
#include "ribbon.h"

// The remaining summary assembly shares these record and application offsets.
typedef char PokemonSummaryMonLayoutCheck[sizeof(PokemonSummaryMon) == 0x64
            && offsetof(PokemonSummaryMon, speciesName) == 0x00
            && offsetof(PokemonSummaryMon, nickname) == 0x04
            && offsetof(PokemonSummaryMon, otName) == 0x08
            && offsetof(PokemonSummaryMon, species) == 0x0C
            && offsetof(PokemonSummaryMon, heldItem) == 0x0E
            && offsetof(PokemonSummaryMon, type1) == 0x10
            && offsetof(PokemonSummaryMon, type2) == 0x11
            && offsetof(PokemonSummaryMon, otID) == 0x14
            && offsetof(PokemonSummaryMon, exp) == 0x18
            && offsetof(PokemonSummaryMon, levelExp) == 0x1C
            && offsetof(PokemonSummaryMon, nextLevelExp) == 0x20
            && offsetof(PokemonSummaryMon, hp) == 0x24
            && offsetof(PokemonSummaryMon, maxHp) == 0x26
            && offsetof(PokemonSummaryMon, atk) == 0x28
            && offsetof(PokemonSummaryMon, def) == 0x2A
            && offsetof(PokemonSummaryMon, spatk) == 0x2C
            && offsetof(PokemonSummaryMon, spdef) == 0x2E
            && offsetof(PokemonSummaryMon, speed) == 0x30
            && offsetof(PokemonSummaryMon, ability) == 0x32
            && offsetof(PokemonSummaryMon, nature) == 0x33
            && offsetof(PokemonSummaryMon, moves) == 0x34
            && offsetof(PokemonSummaryMon, pp) == 0x3C
            && offsetof(PokemonSummaryMon, maxPp) == 0x40
            && offsetof(PokemonSummaryMon, otGender) == 0x44
            && offsetof(PokemonSummaryMon, cool) == 0x45
            && offsetof(PokemonSummaryMon, beauty) == 0x46
            && offsetof(PokemonSummaryMon, cute) == 0x47
            && offsetof(PokemonSummaryMon, smart) == 0x48
            && offsetof(PokemonSummaryMon, tough) == 0x49
            && offsetof(PokemonSummaryMon, sheen) == 0x4A
            && offsetof(PokemonSummaryMon, preferredFlavor) == 0x4B
            && offsetof(PokemonSummaryMon, markings) == 0x4C
            && offsetof(PokemonSummaryMon, form) == 0x4E
            && offsetof(PokemonSummaryMon, ribbons) == 0x54
        ? 1
        : -1];

typedef char PokemonSummaryAppLayoutCheck[offsetof(PokemonSummaryAppPrefix, windows) == 0x004
            && offsetof(PokemonSummaryAppPrefix, pageWindows) == 0x224
            && offsetof(PokemonSummaryAppPrefix, pageWindowCount) == 0x228
            && offsetof(PokemonSummaryAppPrefix, args) == 0x22C
            && offsetof(PokemonSummaryAppPrefix, mon) == 0x230
            && offsetof(PokemonSummaryAppPrefix, shinyLeaves) == 0x294
            && offsetof(PokemonSummaryAppPrefix, msgData) == 0x7A0
            && offsetof(PokemonSummaryAppPrefix, ribbonMsgData) == 0x7A4
            && offsetof(PokemonSummaryAppPrefix, messageFormat) == 0x7A8
            && offsetof(PokemonSummaryAppPrefix, stringBuffer) == 0x7AC
            && offsetof(PokemonSummaryAppPrefix, ribbonCount) == 0x7C6
        ? 1
        : -1];

void sub_0208981C(PokemonSummaryAppPrefix *summary, Pokemon *mon, PokemonSummaryMon *summaryMon) {
    BOOL locked = AcquireMonLock(mon);
    summaryMon->species = GetMonData(mon, MON_DATA_SPECIES, NULL);

    BoxPokemon *boxMon = Mon_GetBoxMon(mon);
    ReadMsgDataIntoString(summary->msgData, msg_0302_00011, summary->stringBuffer);
    BufferBoxMonSpeciesName(summary->messageFormat, 0, boxMon);
    StringExpandPlaceholders(summary->messageFormat, summary->mon.speciesName, summary->stringBuffer);
    ReadMsgDataIntoString(summary->msgData, msg_0302_00000, summary->stringBuffer);
    BufferBoxMonNickname(summary->messageFormat, 0, boxMon);
    StringExpandPlaceholders(summary->messageFormat, summary->mon.nickname, summary->stringBuffer);
    ReadMsgDataIntoString(summary->msgData, msg_0302_00014, summary->stringBuffer);
    BufferBoxMonOTName(summary->messageFormat, 0, boxMon);
    StringExpandPlaceholders(summary->messageFormat, summary->mon.otName, summary->stringBuffer);

    summaryMon->heldItem = GetMonData(mon, MON_DATA_HELD_ITEM, NULL);
    summaryMon->level = (u8)GetMonData(mon, MON_DATA_LEVEL, NULL);
    summaryMon->isEgg = GetMonData(mon, MON_DATA_IS_EGG, NULL);
    if (GetMonData(mon, MON_DATA_NO_PRINT_GENDER, NULL) == TRUE && !summaryMon->isEgg) {
        summaryMon->showGender = FALSE;
    } else {
        summaryMon->showGender = TRUE;
    }
    summaryMon->gender = GetMonGender(mon);
    summaryMon->pokeball = (u8)GetMonData(mon, MON_DATA_POKEBALL, NULL);
    summaryMon->type1 = GetMonData(mon, MON_DATA_TYPE_1, NULL);
    summaryMon->type2 = GetMonData(mon, MON_DATA_TYPE_2, NULL);
    summaryMon->otID = GetMonData(mon, MON_DATA_OT_ID, NULL);
    summaryMon->exp = GetMonData(mon, MON_DATA_EXPERIENCE, NULL);
    summaryMon->otGender = GetMonData(mon, MON_DATA_OT_GENDER, NULL);
    summaryMon->levelExp = GetMonExpBySpeciesAndLevel(summaryMon->species, summaryMon->level);
    if (summaryMon->level == MAX_LEVEL) {
        summaryMon->nextLevelExp = summaryMon->levelExp;
    } else {
        summaryMon->nextLevelExp = GetMonExpBySpeciesAndLevel(summaryMon->species, summaryMon->level + 1);
    }
    summaryMon->hp = GetMonData(mon, MON_DATA_HP, NULL);
    summaryMon->maxHp = GetMonData(mon, MON_DATA_MAX_HP, NULL);
    summaryMon->atk = GetMonData(mon, MON_DATA_ATK, NULL);
    summaryMon->def = GetMonData(mon, MON_DATA_DEF, NULL);
    summaryMon->spatk = GetMonData(mon, MON_DATA_SP_ATK, NULL);
    summaryMon->spdef = GetMonData(mon, MON_DATA_SP_DEF, NULL);
    summaryMon->speed = GetMonData(mon, MON_DATA_SPEED, NULL);
    summaryMon->ability = GetMonData(mon, MON_DATA_ABILITY, NULL);
    summaryMon->nature = GetMonNature(mon);

    for (u16 i = 0; i < MAX_MON_MOVES; i++) {
        summaryMon->moves[i] = GetMonData(mon, MON_DATA_MOVE1 + i, NULL);
        summaryMon->pp[i] = GetMonData(mon, MON_DATA_MOVE1_PP + i, NULL);
        u8 ppUps = GetMonData(mon, MON_DATA_MOVE1_PP_UPS + i, NULL);
        summaryMon->maxPp[i] = GetMoveMaxPP(summaryMon->moves[i], ppUps);
    }

    summaryMon->cool = GetMonData(mon, MON_DATA_COOL, NULL);
    summaryMon->beauty = GetMonData(mon, MON_DATA_BEAUTY, NULL);
    summaryMon->cute = GetMonData(mon, MON_DATA_CUTE, NULL);
    summaryMon->smart = GetMonData(mon, MON_DATA_SMART, NULL);
    summaryMon->tough = GetMonData(mon, MON_DATA_TOUGH, NULL);
    summaryMon->sheen = GetMonData(mon, MON_DATA_SHEEN, NULL);
    summaryMon->preferredFlavor = FLAVOR_MAX;
    for (u16 i = FLAVOR_START; i < FLAVOR_MAX; i++) {
        if (MonGetFlavorPreference(mon, i) == 1) {
            summaryMon->preferredFlavor = i;
            break;
        }
    }

    summaryMon->markings = GetMonData(mon, MON_DATA_MARKINGS, NULL);
    summaryMon->form = GetMonData(mon, MON_DATA_FORM, NULL);
    summaryMon->statusIcon = Pokemon_GetStatusIconId(mon);
    if (Pokemon_IsImmuneToPokerus(mon) == TRUE) {
        summaryMon->pokerus = 2;
    } else if (Pokemon_HasPokerus(mon) == TRUE) {
        summaryMon->pokerus = 1;
        if (summaryMon->statusIcon == PARTY_MON_STATUS_ICON_OK) {
            summaryMon->statusIcon = PARTY_MON_STATUS_ICON_UNSET;
        }
    } else {
        summaryMon->pokerus = 0;
    }
    if (MonIsShiny(mon) == TRUE) {
        summaryMon->isShiny = TRUE;
    } else {
        summaryMon->isShiny = FALSE;
    }

    summaryMon->ribbons[0] = 0;
    summaryMon->ribbons[1] = 0;
    summaryMon->ribbons[2] = 0;
    summaryMon->ribbons[3] = 0;
    summary->ribbonCount = 0;
    for (u16 i = 0; i < RIBBON_MAX; i++) {
        if (GetMonData(mon, GetRibbonAttr(i, RIBBONDAT_MONDATNO), NULL)) {
            summaryMon->ribbons[(u32)i >> 5] |= 1u << (i & 31);
            summary->ribbonCount++;
        }
    }
    for (u16 i = 0; i < NELEMS(summary->shinyLeaves); i++) {
        summary->shinyLeaves[i] = GetMonData(mon, MON_DATA_SHINY_LEAF_A + i, NULL);
    }
    ReleaseMonLock(mon, locked);
}
