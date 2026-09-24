#include "frontier/overlay_80_0222F830.h"

#include "global.h"

#include "constants/heap.h"
#include "constants/pokemon.h"

#include "frontier/frontier.h"
#include "frontier/frontier_script_context.h"
#include "frontier/overlay_80_02229EE0.h"
#include "frontier/overlay_80_0222BDF4.h"

#include "bg_window.h"
#include "heap.h"
#include "message_format.h"
#include "party.h"
#include "pokemon.h"
#include "sys_task_api.h"
#include "unk_02096910.h"

// The Battle Factory's data, as far as FrtCmd_103 reads it.
typedef struct FactoryData {
    u8 filler0[4];
    u8 type;
    u8 levelMode;
    u8 unk6;
    u8 unk7;
    u8 filler8[3];
    u8 unkB;
    u16 winStreak;
    u8 fillerE[0xA];
    u16 trainers[14];
    FrontierTrainerData trainerData[2];
    u8 filler254[0x17E];
    u16 unk3D2[4];
    u8 unk3DA[6];
    u32 unk3E0[4];
    FrontierMon opponentMons[4];
    u8 filler4D0[4];
    Party *party;
    u8 filler4D8[4];
    u16 unk4DC[6];
    u8 filler4E8[0xC];
    void *unk4F4;
    u8 filler4F8[8];
    SysTask *unk500;
    u8 filler504[0x78];
    u8 unk57C;
    u8 unk57D;
} FactoryData;

u32 sub_0203095C(void *a0);
void ov80_0222FC08(SysTask *task, void *data);
void ov80_0223049C(FactoryData *data, int a1);
u16 ov80_02230784(FactoryData *data);
u16 ov80_02230790(FactoryData *data);
u16 ov80_02230794(FactoryData *data, u8 a1);
void ov80_022307C8(FactoryData *data);
void ov80_022307D4(FactoryData *data);
void ov80_02230AE4(FactoryData *data);
u16 ov80_02230B4C(FactoryData *data);
int ov80_02236DD4(u8 type);
int ov80_02236DF8(u8 type, int a1);
int ov80_02237120(FactoryData *data);
void ov80_02237130(FactoryData *data);
void ov80_022371B0(FactoryData *data);
u16 ov80_02237254(u8 type);
u16 ov80_022372B4(FactoryData *data);

BOOL FrtCmd_103(FrontierScriptContext *ctx) {
    int i;
    int type1;
    int type2;
    int partySize;
    Pokemon *mon;

    u8 action = FrontierScriptContext_ReadByte(ctx);
    u8 arg1 = FrontierScriptContext_ReadByte(ctx);
    u8 arg2 = FrontierScriptContext_ReadByte(ctx);
    u16 *out = FrontierScript_ReadVarPtr(ctx);
    FactoryData *data = Frontier_GetData(ctx->frontierSystem->unk0);
    FrontierMap *map = FrontierSystem_GetFrontierMap(ctx->frontierSystem);

    switch (action) {
    case 0:
        data->unk7 = arg1;
        break;
    case 1:
        data->levelMode = arg1;
        break;
    case 2:
        data->type = arg1;
        break;
    case 3:
        *out = data->unk4DC[arg1];
        break;
    case 4:
        *out = data->winStreak;
        break;
    case 5:
        if (data->winStreak < 9999) {
            data->winStreak++;
        }
        break;
    case 7:
        OS_ResetSystem(0);
        break;
    case 9:
        *out = sub_0203095C(data->unk4F4);
        break;
    case 10:
        ov80_0223049C(data, 2);
        break;
    case 14:
        *out = ov80_02230784(data);
        break;
    case 15:
        *out = data->opponentMons[arg1].species;
        break;
    case 16:
        *out = data->opponentMons[arg1].moves[arg2];
        break;
    case 17:
        mon = AllocMonZeroed(HEAP_ID_FIELD2);
        ov80_0222A140(&data->opponentMons[arg1], mon, ov80_02237120(data));
        *out = GetMonData(mon, MON_DATA_TYPE_1, NULL);
        Heap_Free(mon);
        break;
    case 18: {
        // The type most of the next trainer's Pokemon share, if two share one.
        int typeCounts[18];
        int numMons = ov80_02236DF8(data->type, 1);

        for (i = 0; i < 18; i++) {
            typeCounts[i] = 0;
        }
        mon = AllocMonZeroed(HEAP_ID_FIELD2);
        for (i = 0; i < numMons; i++) {
            ov80_0222A140(&data->opponentMons[i], mon, ov80_02237120(data));
            type1 = GetMonData(mon, MON_DATA_TYPE_1, NULL);
            type2 = GetMonData(mon, MON_DATA_TYPE_2, NULL);
            if (type1 == type2) {
                type2 = TYPE_NONE;
            }
            typeCounts[type1]++;
            if (type2 != TYPE_NONE) {
                typeCounts[type2]++;
            }
        }
        Heap_Free(mon);
        type1 = 0;
        for (i = 0; i < 18; i++) {
            if (typeCounts[type1] < typeCounts[i]) {
                type1 = i;
            }
        }
        if (typeCounts[type1] <= 1) {
            *out = TYPE_NONE;
        } else {
            *out = type1;
        }
        break;
    }
    case 19:
        *out = ov80_022372B4(data);
        break;
    case 20:
        *out = ov80_02230794(data, arg1);
        break;
    case 21:
        ov80_022307C8(data);
        break;
    case 22:
        ov80_022307D4(data);
        break;
    case 23:
        *out = ov80_02230790(data);
        break;
    case 24:
        *out = data->unk57C;
        break;
    case 26:
        *out = data->unk57D;
        break;
    case 27:
        sub_02096910(data);
        break;
    case 28:
        *out = ov80_02237254(data->type);
        break;
    case 29:
        *out = data->type;
        break;
    case 30:
        BgTilemapRectChangePalette((BgConfig *)map->unk0, 3, 3, 10, 26, 11, arg1);
        ScheduleBgTilemapBufferTransfer((BgConfig *)map->unk0, 3);
        break;
    case 31:
        data->unk500 = SysTask_CreateOnMainQueue(ov80_0222FC08, FrontierSystem_GetFrontierMap(ctx->frontierSystem), 5);
        break;
    case 32:
        if (data->unk500 != NULL) {
            SysTask_Destroy(data->unk500);
            data->unk500 = NULL;
        }
        break;
    case 33:
        ov80_0222A474(&data->trainerData[0], data->trainers[data->unk6], HEAP_ID_FIELD2, 0xCC);
        ov80_0222A474(&data->trainerData[1], data->trainers[data->unk6 + 7], HEAP_ID_FIELD2, 0xCC);
        break;
    case 34:
        partySize = ov80_02236DD4(data->type);
        for (i = 0; i < partySize; i++) {
            BufferBoxMonSpeciesName(ctx->frontierSystem->unk44, i, Mon_GetBoxMon(Party_GetMonByIndex(data->party, i)));
        }
        break;
    case 35:
        *out = ov80_02230B4C(data);
        break;
    case 36:
        ov80_02230AE4(data);
        break;
    case 37:
        *out = 0;
        if (data->type == 0) {
            if (data->winStreak + 1 == 21) {
                *out = 1;
            } else if (data->winStreak + 1 == 49) {
                *out = 2;
            }
        }
        break;
    case 38:
        ov80_022371B0(data);
        break;
    case 39:
        ov80_0222A52C(data->opponentMons, data->unk3D2, data->unk3DA, data->unk3E0, NULL, 4, HEAP_ID_FIELD2, 0xCD);
        break;
    case 40:
        ov80_02237130(data);
        break;
    case 41:
        *out = data->unkB;
        data->unkB = 1;
        break;
    }

    return FALSE;
}
