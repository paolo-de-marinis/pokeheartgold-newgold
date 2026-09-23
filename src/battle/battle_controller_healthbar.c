#include "battle/battle_controller.h"
#include "battle/battle_system.h"
#include "battle/overlay_12_0224E4FC.h"

#include "pokemon.h"

// What the opponent controller draws a health box from: level, HP, the party
// slot its name is read from, the status, the sex symbol, the experience bar,
// whether the species is already caught, and the Safari Balls left.
typedef struct HealthbarCommand {
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
    u8 delay;
} HealthbarCommand;

// The opponent controller reads this packet by offset.
typedef char HealthbarCommandSizeCheck[sizeof(HealthbarCommand) == 0x18 ? 1 : -1];

void BattleController_EmitHealthbarSlideIn(BattleSystem *battleSystem, BattleContext *ctx, int battlerId, u32 delay) {
    HealthbarCommand data;
    Pokemon *mon = BattleSystem_GetPartyMon(battleSystem, battlerId, ctx->selectedMonIndex[battlerId]);
    int species = GetMonData(mon, MON_DATA_SPECIES, NULL);
    int level = GetMonData(mon, MON_DATA_LEVEL, NULL);

    data.command = 12;
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
    data.delay = delay;

    ov12_02262240(battleSystem, 1, battlerId, &data, sizeof(HealthbarCommand));
}
