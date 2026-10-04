#ifndef POKEHEARTGOLD_DATA_EV_IV_TRAINER_SETS_H
#define POKEHEARTGOLD_DATA_EV_IV_TRAINER_SETS_H

// The sets the EV/IV trainer's Sets page offers, a game's own: each names a
// row of EV_IV_TRAINER_SETS_BANK and gives six EVs in MON_DATA_HP_EV order
// (HP, Attack, Defense, Speed, Sp. Atk, Sp. Def). The engine has none, and
// the page says so.
#define EV_IV_TRAINER_SETS_BANK NARC_msg_msg_0829_bin

static const EvIvTrainerSet sEvIvTrainerSets[] = {
    { EV_IV_TRAINER_SETS_END },
};

#endif // POKEHEARTGOLD_DATA_EV_IV_TRAINER_SETS_H
