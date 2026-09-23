#include "global.h"

#include "save.h"
#include "unk_02030A98.h"

#define BATTLE_HALL_MAX_STREAK 9999

// The best streak in a Battle Hall mode (0-2) with one species.
u32 sub_020312E0(SaveData *saveData, u32 *a1, u32 a2, u32 a3) {
    struct UnkStruct_02030A98 *hall = (struct UnkStruct_02030A98 *)a1;

    if (!Save_CheckExtraChunksExist(saveData)) {
        return 0;
    }
    // Retail's tables stop at its own species; an added one has no record.
    if (a3 >= BATTLE_HALL_SPECIES_RECORDS) {
        return 0;
    }
    switch (a2) {
    case 0:
        return hall->streaks[0][a3];
    case 1:
        return hall->streaks[1][a3];
    case 2:
        return hall->streaks[2][a3];
    default:
        GF_ASSERT(FALSE);
        return 0;
    }
}

u32 sub_0203132C(u32 *a0, u32 a1, u32 a2, u16 a3) {
    struct UnkStruct_02030A98 *hall = (struct UnkStruct_02030A98 *)a0;

    if (a2 >= BATTLE_HALL_SPECIES_RECORDS) {
        return 0;
    }
    if (a3 > BATTLE_HALL_MAX_STREAK) {
        a3 = BATTLE_HALL_MAX_STREAK;
    }
    switch (a1) {
    case 0:
        hall->streaks[0][a2] = a3;
        break;
    case 1:
        hall->streaks[1][a2] = a3;
        break;
    case 2:
        hall->streaks[2][a2] = a3;
        break;
    default:
        GF_ASSERT(FALSE);
        return 0;
    }
    return a3;
}

// Keeps the better of the stored streak and this one.
u32 sub_02031378(SaveData *saveData, u32 *a1, u32 a2, u32 a3, u16 a4) {
    u32 streak;

    if (!Save_CheckExtraChunksExist(saveData)) {
        return 0;
    }
    streak = sub_020312E0(saveData, a1, a2, a3);
    if (streak < a4) {
        return sub_0203132C(a1, a2, a3, a4);
    }
    if (streak > BATTLE_HALL_MAX_STREAK) {
        return sub_0203132C(a1, a2, a3, BATTLE_HALL_MAX_STREAK);
    }
    return streak;
}
