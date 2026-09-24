#include "global.h"

#include "constants/battle.h"
#include "constants/species.h"

#include "battle/battle.h"
#include "battle/battle_controller_opponent.h"
#include "battle/battle_system.h"

#include "heap.h"
#include "party.h"
#include "pokemon.h"
#include "sys_task.h"

// The task data every battler's party selection gets from ov12_0225A7AC, as
// far as the AI's reads it.
typedef struct PartySelectInput {
    BattleSystem *battleSystem;
    u8 filler_04[4];
    u8 command;
    u8 battlerId;
    u8 state;
    u8 mode;
    u8 selectedMonIndex[BATTLER_MAX];
} PartySelectInput;

void ov12_02263360(BattleSystem *battleSystem, int battlerId, int selection);
void ov12_0226430C(BattleSystem *battleSystem, int battlerId, int a2);
void ov12_0225F8AC(SysTask *task, void *_data);

// The first Pokemon of the party that has fainted, an Egg aside; 6 for none.
static int PartyFaintedMonSlot(BattleSystem *battleSystem, int battlerId) {
    int slot;
    Pokemon *mon;
    int species;

    for (slot = 0; slot < BattleSystem_GetPartySize(battleSystem, battlerId); slot++) {
        mon = BattleSystem_GetPartyMon(battleSystem, battlerId, slot);
        species = GetMonData(mon, MON_DATA_SPECIES_OR_EGG, NULL);
        if (species != SPECIES_NONE && species != SPECIES_EGG && GetMonData(mon, MON_DATA_HP, NULL) == 0) {
            break;
        }
    }
    return slot < BattleSystem_GetPartySize(battleSystem, battlerId) ? slot : 6;
}

// The trainer AI's pick of the Pokemon to send in: the one its switch decision
// chose (ov12_02258BA0), else the best matchup against a random foe
// (ov12_02258800), else the first one standing that is not on the field.
void ov12_0225F8AC(SysTask *task, void *_data) {
    PartySelectInput *data = _data;
    int battlerId;
    Party *party;
    int partner;
    int slot;
    u32 battleType = BattleSystem_GetBattleType(data->battleSystem);

    battlerId = data->battlerId;
    if ((battleType & BATTLE_TYPE_TAG) || (battleType & BATTLE_TYPE_MULTI)) {
        partner = battlerId;
    } else {
        partner = BattleSystem_GetBattlerIdPartner(data->battleSystem, battlerId);
    }
    // For Revival Blessing, the first fainted Pokemon in the party.
    if (data->mode == BATTLE_PARTY_MODE_REVIVE) {
        slot = PartyFaintedMonSlot(data->battleSystem, battlerId);
    } else if ((slot = ov12_02258BA0(data->battleSystem, battlerId)) == 6) {
        slot = ov12_02258800(data->battleSystem, battlerId);
        if (slot == 6) {
            party = BattleSystem_GetParty(data->battleSystem, data->battlerId);
            for (slot = 0; slot < Party_GetCount(party); slot++) {
                if (GetMonData(BattleSystem_GetPartyMon(data->battleSystem, data->battlerId, slot), MON_DATA_HP, NULL) != 0
                    && slot != data->selectedMonIndex[battlerId] && slot != data->selectedMonIndex[partner]) {
                    break;
                }
            }
        }
    }
    ov12_02263360(data->battleSystem, data->battlerId, slot + 1);
    ov12_0226430C(data->battleSystem, data->battlerId, data->command);
    Heap_Free(data);
    SysTask_Destroy(task);
}
