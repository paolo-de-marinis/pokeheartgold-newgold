#include "global.h"

#include "constants/species.h"

#include "unk_0202FBCC.h"

// Reads a field of a battle video's header (sub_0202FF08 fills it): the
// species and the form of each of the twelve recorded Pokemon that is not an
// egg, the streak, a mode byte, the recorded id, and one byte more. A species
// past the last one reads as none.
u64 sub_0203088C(u8 *header, int field, int idx) {
    switch (field) {
    case 0:
        GF_ASSERT(idx < 12);
        if (((u16 *)header)[idx] > NUM_SPECIES) {
            return 0;
        }
        return ((u16 *)header)[idx];
    case 1:
        GF_ASSERT(idx < 12);
        return (header + idx)[0x18];
    case 2:
        if (*(u16 *)(header + 0x24) > 9999) {
            return 9999;
        }
        return *(u16 *)(header + 0x24);
    case 3:
        if (header[0x26] >= 33) {
            return 0;
        }
        return header[0x26];
    case 4:
        return *(u64 *)(header + 0x58);
    case 5:
        return header[0x27];
    default:
        GF_ASSERT(FALSE);
        return 0;
    }
}
