#ifndef POKEHEARTGOLD_POKEMON_SUMMARY_APP_H
#define POKEHEARTGOLD_POKEMON_SUMMARY_APP_H

#include "bg_window.h"
#include "message_format.h"
#include "msgdata.h"
#include "unk_02088288.h"

typedef struct PokemonSummaryMon {
    String *speciesName;
    String *nickname;
    String *otName;
    u16 species;
    u16 heldItem;
    u8 type1;
    u8 type2;
    u8 level : 7;
    u8 showGender : 1;
    u8 gender : 2;
    u8 pokeball : 6;
    u32 otID;
    u32 exp;
    u32 levelExp;
    u32 nextLevelExp;
    u16 hp;
    u16 maxHp;
    u16 atk;
    u16 def;
    u16 spatk;
    u16 spdef;
    u16 speed;
    // Swapped with the halfword at 0x4E so battle-legal ability IDs fit. The
    // record cannot grow: it is embedded in the assembly-shared application.
    // MON_DATA_FORM is a five-bit saved field, so a byte cannot truncate it.
    u8 form;
    // sub_0208C7F8 reads this byte at application offset 0x263 for
    // gNatureStatMods, so it must stay here.
    u8 nature;
    u16 moves[MAX_MON_MOVES];
    u8 pp[MAX_MON_MOVES];
    u8 maxPp[MAX_MON_MOVES];
    u8 otGender;
    u8 cool;
    u8 beauty;
    u8 cute;
    u8 smart;
    u8 tough;
    u8 sheen;
    u8 preferredFlavor;
    u16 markings;
    // Was form. Nothing in the summary application reads this halfword, which is
    // why it can carry the full ability ID.
    u16 ability;
    // Read as a complete 28-bit value: unk_0208B1AC.s masks with lsl #4 / lsr #4
    // and compares with 7, so these bits are not spare.
    u32 statusIcon : 28;
    u32 isEgg : 1;
    u32 isShiny : 1;
    u32 pokerus : 2;
    // The original record reserves four words, including room past RIBBON_MAX.
    u32 ribbons[4];
} PokemonSummaryMon;

// Only the prefix of the existing summary application allocation is identified
// here. Do not allocate or copy the complete application using this type's size.
typedef struct PokemonSummaryAppPrefix {
    BgConfig *bgConfig;
    // sub_0208C3E4 creates exactly 34 fixed windows.
    Window windows[34];
    Window *pageWindows;
    u32 pageWindowCount;
    PokemonSummaryArgs *args;
    PokemonSummaryMon mon;
    u8 shinyLeaves[MON_DATA_SHINY_LEAF_CROWN - MON_DATA_SHINY_LEAF_A + 1];
    u8 unk29A[0x7A0 - 0x29A];
    MsgData *msgData;
    MsgData *ribbonMsgData;
    MessageFormat *messageFormat;
    String *stringBuffer;
    u8 unk7B0[0x7C6 - 0x7B0];
    u8 ribbonCount;
} PokemonSummaryAppPrefix;

void sub_0208981C(PokemonSummaryAppPrefix *summary, Pokemon *mon, PokemonSummaryMon *summaryMon);
void sub_0208D178(PokemonSummaryAppPrefix *summary);

#endif // POKEHEARTGOLD_POKEMON_SUMMARY_APP_H
