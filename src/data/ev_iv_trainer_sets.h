#ifndef POKEHEARTGOLD_DATA_EV_IV_TRAINER_SETS_H
#define POKEHEARTGOLD_DATA_EV_IV_TRAINER_SETS_H

// The sets the EV/IV trainer's Sets page offers, a game's own: each names a
// row of EV_IV_TRAINER_SETS_BANK and gives six EVs in MON_DATA_HP_EV order
// (HP, Attack, Defense, Speed, Sp. Atk, Sp. Def). The engine has none, and
// the page says so.
//
// New Gold's are konefr's twelve EV presets (b23dc7360, 564419b1a and
// 725944f6d: his debug vendor's DEV_EV_PRESET_RESET to _FAST_BULK, 2000 to
// 2011, in ScrCmd_GiveEgg), in his menu's order, with his names: the rows
// of Cherrygrove City's bank his vendor reads them from.
#include "msgdata/msg/msg_0550_T21.h"
#define EV_IV_TRAINER_SETS_BANK NARC_msg_msg_0550_T21_bin

static const EvIvTrainerSet sEvIvTrainerSets[] = {
    // name                         HP   Atk  Def  Spe  SpA  SpD
    { msg_0550_T21_00052, { 4,   252, 0,   252, 0,   0   } }, // 2001 Physical
    { msg_0550_T21_00053, { 4,   0,   0,   252, 252, 0   } }, // 2002 Special
    { msg_0550_T21_00054, { 252, 0,   252, 0,   0,   4   } }, // 2003 Physical Tank
    { msg_0550_T21_00055, { 252, 0,   4,   0,   0,   252 } }, // 2004 Special Tank
    { msg_0550_T21_00056, { 84,  84,  84,  84,  84,  84  } }, // 2005 Balanced
    { msg_0550_T21_00060, { 252, 252, 0,   4,   0,   0   } }, // 2006 Bulk Physical
    { msg_0550_T21_00061, { 252, 0,   0,   4,   252, 0   } }, // 2007 Bulk Special
    { msg_0550_T21_00062, { 252, 0,   128, 0,   0,   128 } }, // 2008 Mixed Tank
    { msg_0550_T21_00063, { 128, 0,   128, 252, 0,   0   } }, // 2009 Fast Bulk Physical
    { msg_0550_T21_00064, { 128, 0,   0,   252, 0,   128 } }, // 2010 Fast Bulk Special
    { msg_0550_T21_00065, { 252, 0,   0,   252, 0,   0   } }, // 2011 Fast Bulk
    { msg_0550_T21_00057, { 0,   0,   0,   0,   0,   0   } }, // 2000 Reset EVs
    { EV_IV_TRAINER_SETS_END },
};

#endif // POKEHEARTGOLD_DATA_EV_IV_TRAINER_SETS_H
