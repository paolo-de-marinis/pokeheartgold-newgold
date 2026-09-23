#include "battle/battle_controller.h"
#include "battle/battle_system.h"
#include "battle/overlay_12_0224E4FC.h"

// What the opponent controller is told to draw a Pokemon from: its species,
// form, colours, sex and personality, the cry's pitch, and what the move and
// name boxes show. The two larger packets add the party slot, the Poke Ball
// and, for a send-out, how every battler on the field looks.
typedef struct MonEncounterCommand {
    u8 command;
    u8 gender : 2;
    u8 shiny : 1;
    u8 form : 5;
    u16 species;
    u32 personality;
    int cryModulation;
    u16 moves[MAX_MON_MOVES];
    u16 movePPCur[MAX_MON_MOVES];
    u16 movePP[MAX_MON_MOVES];
    u16 nickname[POKEMON_NAME_LENGTH + 1];
} MonEncounterCommand;

typedef struct MonShowCommand {
    u8 command;
    u8 gender : 2;
    u8 shiny : 1;
    u8 form : 5;
    u16 species;
    u32 personality;
    int cryModulation;
    int selectedMonIndex;
    int ball;
    int quickSendOut;
    u16 moves[MAX_MON_MOVES];
    u16 movePPCur[MAX_MON_MOVES];
    u16 movePP[MAX_MON_MOVES];
    u16 nickname[POKEMON_NAME_LENGTH + 1];
    int partnerSelectedMonIndex;
    int substitute;
    u16 battlerSpecies[BATTLER_MAX];
    u8 battlerGender[BATTLER_MAX];
    u8 battlerShiny[BATTLER_MAX];
    u8 battlerForm[BATTLER_MAX];
    u32 battlerPersonality[BATTLER_MAX];
} MonShowCommand;

// The opponent controller reads these packets by offset.
typedef char MonEncounterCommandSizeCheck[sizeof(MonEncounterCommand) == 0x3C ? 1 : -1];
typedef char MonShowCommandSizeCheck[sizeof(MonShowCommand) == 0x74 ? 1 : -1];
typedef char MonShowCommandNicknameOffsetCheck[offsetof(MonShowCommand, nickname) == 0x30 ? 1 : -1];
typedef char MonShowCommandPartnerOffsetCheck[offsetof(MonShowCommand, partnerSelectedMonIndex) == 0x48 ? 1 : -1];

// Illusion: a battler made up as another Pokemon of its party is drawn as that
// Pokemon -- species, form, colours, sex, personality and name, and the Poke
// Ball it comes out of (ClientPokemonEncount, ClientPokemonEncountAppear and
// ClientPokemonAppear, battle_pokemon.c:280-420 at d0380a487). The reference
// changes the species, form and colours only; Pokemon Central (Illusione)
// has the sex, the ball and the name copied too.
#define ILLUSION_MAKE_UP(data, disguise)                                   \
    do {                                                                  \
        (data).species = GetMonData((disguise), MON_DATA_SPECIES, NULL);  \
        (data).form = GetMonData((disguise), MON_DATA_FORM, NULL);        \
        (data).shiny = MonIsShiny(disguise);                              \
        (data).gender = GetMonGender(disguise);                           \
        (data).personality = GetMonData((disguise), MON_DATA_PERSONALITY, NULL); \
        GetMonData((disguise), MON_DATA_NICKNAME, (data).nickname);       \
    } while (0)

void BattleController_EmitPokemonEncounter(BattleSystem *battleSystem, int battlerId) {
    MonEncounterCommand data;
    Pokemon *disguise;
    int i;

    data.command = 2;
    data.gender = battleSystem->ctx->battleMons[battlerId].gender;
    data.shiny = battleSystem->ctx->battleMons[battlerId].shiny;
    data.species = battleSystem->ctx->battleMons[battlerId].species;
    data.personality = battleSystem->ctx->battleMons[battlerId].personality;
    data.cryModulation = ov12_02256748(battleSystem->ctx, battlerId, ov12_0223AB0C(battleSystem, battlerId), TRUE);
    data.form = battleSystem->ctx->battleMons[battlerId].form;

    for (i = 0; i < MAX_MON_MOVES; i++) {
        data.moves[i] = GetBattlerVar(battleSystem->ctx, battlerId, BMON_DATA_MOVE1 + i, NULL);
        data.movePPCur[i] = GetBattlerVar(battleSystem->ctx, battlerId, BMON_DATA_CUR_PP_1 + i, NULL);
        data.movePP[i] = GetBattlerVar(battleSystem->ctx, battlerId, BMON_DATA_MAX_PP_1 + i, NULL);
    }

    GetBattlerVar(battleSystem->ctx, battlerId, BMON_DATA_NICKNAME, &data.nickname);
    disguise = Battler_IllusionMon(battleSystem, battlerId);
    if (disguise != NULL) {
        ILLUSION_MAKE_UP(data, disguise);
    }
    ov12_02262240(battleSystem, 1, battlerId, &data, sizeof(MonEncounterCommand));
}

void BattleController_EmitPokemonSlideIn(BattleSystem *battleSystem, int battlerId) {
    MonShowCommand data;
    Pokemon *disguise;
    int i;

    data.command = 3;
    data.gender = battleSystem->ctx->battleMons[battlerId].gender;
    data.shiny = battleSystem->ctx->battleMons[battlerId].shiny;
    data.species = battleSystem->ctx->battleMons[battlerId].species;
    data.personality = battleSystem->ctx->battleMons[battlerId].personality;
    data.cryModulation = ov12_02256748(battleSystem->ctx, battlerId, ov12_0223AB0C(battleSystem, battlerId), TRUE);
    data.selectedMonIndex = battleSystem->ctx->selectedMonIndex[battlerId];
    data.form = battleSystem->ctx->battleMons[battlerId].form;
    data.ball = battleSystem->ctx->battleMons[battlerId].ball;
    data.partnerSelectedMonIndex = battleSystem->ctx->selectedMonIndex[BattleSystem_GetBattlerIdPartner(battleSystem, battlerId)];

    ov12_0223B854(battleSystem, battlerId, data.selectedMonIndex);

    for (i = 0; i < MAX_MON_MOVES; i++) {
        data.moves[i] = GetBattlerVar(battleSystem->ctx, battlerId, BMON_DATA_MOVE1 + i, NULL);
        data.movePPCur[i] = GetBattlerVar(battleSystem->ctx, battlerId, BMON_DATA_CUR_PP_1 + i, NULL);
        data.movePP[i] = GetBattlerVar(battleSystem->ctx, battlerId, BMON_DATA_MAX_PP_1 + i, NULL);
    }

    GetBattlerVar(battleSystem->ctx, battlerId, BMON_DATA_NICKNAME, &data.nickname);
    disguise = Battler_IllusionMon(battleSystem, battlerId);
    if (disguise != NULL) {
        ILLUSION_MAKE_UP(data, disguise);
        data.ball = BattleSystem_GetMonBall(battleSystem, disguise);
    }
    ov12_02262240(battleSystem, 1, battlerId, &data, sizeof(MonShowCommand));
}

void BattleController_EmitPokemonSendOut(BattleSystem *battleSystem, int battlerId, int ball, int quickSendOut) {
    MonShowCommand data;
    Pokemon *disguise;
    int i;

    data.command = 4;

    if (battleSystem->ctx->battleMons[battlerId].status2 & STATUS2_TRANSFORM) {
        data.gender = battleSystem->ctx->battleMons[battlerId].unk88.transformGender;
        data.personality = battleSystem->ctx->battleMons[battlerId].unk88.transformPersonality;
    } else {
        data.gender = battleSystem->ctx->battleMons[battlerId].gender;
        data.personality = battleSystem->ctx->battleMons[battlerId].personality;
    }

    data.shiny = battleSystem->ctx->battleMons[battlerId].shiny;
    data.species = battleSystem->ctx->battleMons[battlerId].species;
    data.cryModulation = ov12_02256748(battleSystem->ctx, battlerId, ov12_0223AB0C(battleSystem, battlerId), FALSE);
    data.selectedMonIndex = battleSystem->ctx->selectedMonIndex[battlerId];
    data.form = battleSystem->ctx->battleMons[battlerId].form;

    if (ball) {
        data.ball = ball;
    } else {
        data.ball = battleSystem->ctx->battleMons[battlerId].ball;
    }

    data.quickSendOut = quickSendOut;
    data.substitute = (battleSystem->ctx->battleMons[battlerId].status2 & STATUS2_SUBSTITUTE) != 0;

    ov12_0223B854(battleSystem, battlerId, data.selectedMonIndex);

    for (i = 0; i < MAX_MON_MOVES; i++) {
        data.moves[i] = GetBattlerVar(battleSystem->ctx, battlerId, BMON_DATA_MOVE1 + i, NULL);
        data.movePPCur[i] = GetBattlerVar(battleSystem->ctx, battlerId, BMON_DATA_CUR_PP_1 + i, NULL);
        data.movePP[i] = GetBattlerVar(battleSystem->ctx, battlerId, BMON_DATA_MAX_PP_1 + i, NULL);
    }

    GetBattlerVar(battleSystem->ctx, battlerId, BMON_DATA_NICKNAME, &data.nickname);

    for (i = 0; i < BATTLER_MAX; i++) {
        data.battlerSpecies[i] = battleSystem->ctx->battleMons[i].species;
        data.battlerShiny[i] = battleSystem->ctx->battleMons[i].shiny;
        data.battlerForm[i] = battleSystem->ctx->battleMons[i].form;

        if (battleSystem->ctx->battleMons[i].status2 & STATUS2_TRANSFORM) {
            data.battlerGender[i] = battleSystem->ctx->battleMons[i].unk88.transformGender;
            data.battlerPersonality[i] = battleSystem->ctx->battleMons[i].unk88.transformPersonality;
        } else {
            data.battlerGender[i] = battleSystem->ctx->battleMons[i].gender;
            data.battlerPersonality[i] = battleSystem->ctx->battleMons[i].personality;
        }

        disguise = Battler_IllusionMon(battleSystem, i);
        if (disguise != NULL) {
            data.battlerSpecies[i] = GetMonData(disguise, MON_DATA_SPECIES, NULL);
            data.battlerShiny[i] = MonIsShiny(disguise);
            data.battlerForm[i] = GetMonData(disguise, MON_DATA_FORM, NULL);
            data.battlerGender[i] = GetMonGender(disguise);
            data.battlerPersonality[i] = GetMonData(disguise, MON_DATA_PERSONALITY, NULL);
        }
    }

    disguise = Battler_IllusionMon(battleSystem, battlerId);
    if (disguise != NULL) {
        ILLUSION_MAKE_UP(data, disguise);
        if (!ball) {
            data.ball = BattleSystem_GetMonBall(battleSystem, disguise);
        }
    }
    ov12_02262240(battleSystem, 1, battlerId, &data, sizeof(MonShowCommand));
}
