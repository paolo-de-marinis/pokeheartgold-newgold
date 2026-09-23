#include "global.h"

#include "field_system.h"
#include "igt.h"
#include "map_header.h"
#include "message_format.h"
#include "player_data.h"
#include "pokedex.h"
#include "save_local_field_data.h"

// What the save window shows beside "Save the game?": where the player is,
// the player's name, the badges, the Dex count and the play time.
typedef struct SaveStats {
    int dexCount;
    u32 mapsec;
    PlayerProfile *profile;
    IGT *igt;
} SaveStats;

void ov01_021F3F50(SaveStats *stats, FieldSystem *fieldSystem);
void ov01_021F3F9C(MessageFormat *msgFmt, SaveStats *stats);
int ov01_021F4044(SaveStats *stats);

void ov01_021F3F50(SaveStats *stats, FieldSystem *fieldSystem) {
    SaveData *saveData = fieldSystem->saveData;
    Location *position = LocalFieldData_GetCurrentPosition(Save_LocalFieldData_Get(saveData));
    Pokedex *pokedex = Save_Pokedex_Get(saveData);

    stats->mapsec = MapHeader_GetMapSec(position->mapId);
    if (Pokedex_IsEnabled(pokedex)) {
        stats->dexCount = Pokedex_CountDexOwned(pokedex);
    } else {
        stats->dexCount = 0;
    }
    stats->profile = Save_PlayerData_GetProfile(saveData);
    stats->igt = Save_PlayerData_GetIGTAddr(saveData);
}

// The fields' placeholders: 0 the place, 1 the name, 2 the badges, 3 the Dex
// count, 4 and 5 the hours and minutes.
void ov01_021F3F9C(MessageFormat *msgFmt, SaveStats *stats) {
    int hours;
    u32 digits;
    PrintingMode mode;

    BufferLandmarkName(msgFmt, 0, stats->mapsec);
    BufferPlayersName(msgFmt, 1, stats->profile);
    BufferIntegerAsString(msgFmt, 2, PlayerProfile_CountBadges(stats->profile), 2, PRINTING_MODE_LEFT_ALIGN, TRUE);
    if (stats->dexCount >= 100) {
        digits = 3;
        mode = PRINTING_MODE_LEFT_ALIGN;
    } else if (stats->dexCount >= 10) {
        digits = 3;
        mode = PRINTING_MODE_RIGHT_ALIGN;
    } else {
        digits = 2;
        mode = PRINTING_MODE_RIGHT_ALIGN;
    }
    BufferIntegerAsString(msgFmt, 3, stats->dexCount, digits, mode, TRUE);
    hours = GetIGTHours(stats->igt);
    if (hours >= 100) {
        digits = 3;
        mode = PRINTING_MODE_LEFT_ALIGN;
    } else if (hours >= 10) {
        digits = 3;
        mode = PRINTING_MODE_RIGHT_ALIGN;
    } else {
        digits = 2;
        mode = PRINTING_MODE_RIGHT_ALIGN;
    }
    BufferIntegerAsString(msgFmt, 4, hours, digits, mode, TRUE);
    BufferIntegerAsString(msgFmt, 5, GetIGTMinutes(stats->igt), 2, PRINTING_MODE_LEADING_ZEROS, TRUE);
}

int ov01_021F4044(SaveStats *stats) {
    return 10;
}
