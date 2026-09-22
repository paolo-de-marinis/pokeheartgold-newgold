#include "global.h"

#include "constants/heap.h"
#include "constants/species.h"

#include "field/overlay_02_0224F76C.h"
#include "filesystem.h"
#include "heap.h"

// One byte a species, in the only member of files/a/2/3/1, read when the
// field's sub-application fills its record for the Pokemon at the head of the
// party. What the byte means is not known yet; the table is retail's, 496
// bytes, and so stops at Arceus.
void ov02_0224F76C(int species, u8 *dest) {
    u8 *table;

    if (species <= 0 || species > SPECIES_ARCEUS) {
        GF_ASSERT(FALSE);
        return;
    }

    table = AllocAtEndAndReadWholeNarcMemberByIdPair(NARC_a_2_3_1, 0, HEAP_ID_FIELD2);
    dest[0xA] = table[species - 1];
    Heap_Free(table);
}
