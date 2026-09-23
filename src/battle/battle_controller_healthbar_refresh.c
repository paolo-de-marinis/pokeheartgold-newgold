#include "battle/battle_controller.h"
#include "battle/battle_system.h"
#include "battle/overlay_12_0224E4FC.h"

#include "pokemon.h"

// What the opponent controller redraws a health box from once a Pokemon has
// grown a level: EmitHealthbarSlideIn's packet without the delay.
typedef struct HealthbarRefreshCommand {
    u8 command;
    u8 level;
    s16 hp;
    u16 maxHp;
    u8 selectedMonIndex;
    u8 status : 5;
    u8 gender : 2;
    u8 caught : 1;
    u32 exp;
    u32 maxExp;
    int safariBalls;
} HealthbarRefreshCommand;

// The opponent controller reads this packet by offset.
typedef char HealthbarRefreshCommandSizeCheck[sizeof(HealthbarRefreshCommand) == 0x14 ? 1 : -1];

void ov12_02263A1C(BattleSystem *battleSystem, BattleContext *ctx, int battlerId) {
    HealthbarRefreshCommand data;
    Pokemon *mon = BattleSystem_GetPartyMon(battleSystem, battlerId, ctx->selectedMonIndex[battlerId]);
    int species = GetMonData(mon, MON_DATA_SPECIES, NULL);
    int level = GetMonData(mon, MON_DATA_LEVEL, NULL);

    data.command = 38;
    data.level = ctx->battleMons[battlerId].level;
    data.hp = ctx->battleMons[battlerId].hp;
    data.maxHp = ctx->battleMons[battlerId].maxHp;
    data.selectedMonIndex = ctx->selectedMonIndex[battlerId];
    data.status = GetBattlerStatusCondition(ctx, battlerId);

    // No sex symbol for a Nidoran that goes by its species name, which says it.
    if ((ctx->battleMons[battlerId].species == SPECIES_NIDORAN_F || ctx->battleMons[battlerId].species == SPECIES_NIDORAN_M)
        && ctx->battleMons[battlerId].hasNickname == FALSE) {
        data.gender = MON_GENDERLESS;
    } else {
        data.gender = ctx->battleMons[battlerId].gender;
    }

    data.exp = ctx->battleMons[battlerId].exp - GetMonExpBySpeciesAndLevel(species, level);
    data.maxExp = GetMonExpBySpeciesAndLevel(species, level + 1) - GetMonExpBySpeciesAndLevel(species, level);
    data.caught = BattleSystem_CheckMonCaught(battleSystem, ctx->battleMons[battlerId].species);
    data.safariBalls = BattleSystem_GetSafariBallCount(battleSystem);

    // Illusion: as EmitHealthbarSlideIn has it, the box goes on naming the
    // Pokemon the battler is made up as, with its sex and whether its species
    // is caught; the level and the experience are the battler's own. The
    // reference redraws it as the battler.
    if (ctx->battleMons[battlerId].illusionMon) {
        Pokemon *disguise = Battler_IllusionMon(battleSystem, battlerId);
        int disguiseSpecies = GetMonData(disguise, MON_DATA_SPECIES, NULL);

        data.selectedMonIndex = ctx->battleMons[battlerId].illusionMon - 1;
        if ((disguiseSpecies == SPECIES_NIDORAN_F || disguiseSpecies == SPECIES_NIDORAN_M) && !GetMonData(disguise, MON_DATA_HAS_NICKNAME, NULL)) {
            data.gender = MON_GENDERLESS;
        } else {
            data.gender = GetMonGender(disguise);
        }
        data.caught = BattleSystem_CheckMonCaught(battleSystem, disguiseSpecies);
    }

    ov12_02262240(battleSystem, 1, battlerId, &data, sizeof(HealthbarRefreshCommand));
}
