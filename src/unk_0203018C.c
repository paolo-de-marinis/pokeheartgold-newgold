#include "global.h"

#include "pokemon_types_def.h"
#include "save.h"
#include "unk_0202FBCC.h"

// The last species, held item and move a recorded Pokemon may have; past
// them a video is taken for corrupted. Retail's.
#define VIDEO_LAST_SPECIES 495
#define VIDEO_LAST_ITEM    536
#define VIDEO_LAST_MOVE    467

// A party as a battle video keeps it (sub_020306DC).
typedef struct RecordedParty {
    u16 maxCount;
    u16 count;
    struct UnkPokemonStruct_02072A98 mons[PARTY_SIZE];
} RecordedParty;

// Whether a battle video read from the save can be played: the header and the
// battle both carry their magic number and checksum, and every recorded
// Pokemon has a species, item and moves the game knows.
BOOL sub_0203018C(SaveData *save, u8 *video) {
    u8 *payload = video + 0xE8;
    u8 *header = video + 0x84;
    int i;
    struct UnkPokemonStruct_02072A98 *mons;
    u16 crc;
    int j;
    int k;

    if (*(u16 *)(payload + 0x1C62) != 0xE281 || *(u16 *)(header + 0x48) != 0xE281) {
        return FALSE;
    }
    crc = SaveArray_CalcCRC16(save, header, 0x58);
    if (crc != *(u16 *)(header + 0x60)) {
        return FALSE;
    }
    crc = SaveArray_CalcCRC16(save, payload, 0x1C64);
    if (crc != *(u16 *)(payload + 0x1C64)) {
        return FALSE;
    }

    for (i = 0, mons = (struct UnkPokemonStruct_02072A98 *)(payload + 0x1150 + offsetof(RecordedParty, mons)); i < 4; i++) {
        for (j = 0; j < PARTY_SIZE; j++) {
            if (mons[j].species > VIDEO_LAST_SPECIES) {
                return FALSE;
            }
            if (mons[j].heldItem > VIDEO_LAST_ITEM) {
                return FALSE;
            }
            for (k = 0; k < MAX_MON_MOVES; k++) {
                if (mons[j].moves[k] > VIDEO_LAST_MOVE) {
                    return FALSE;
                }
            }
        }
        mons = (struct UnkPokemonStruct_02072A98 *)((u8 *)mons + sizeof(RecordedParty));
    }
    return TRUE;
}
