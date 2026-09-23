#ifndef POKEHEARTGOLD_UNK_0202FBCC_H
#define POKEHEARTGOLD_UNK_0202FBCC_H

#include "heap.h"
#include "save.h"

struct UnkStruct_0202FBCC {
    u8 filler_0000[0x1D50];
}; // related to Battle Hall, size=0x1D50

void sub_0202FBF0(SaveData *save, enum HeapID heapID, u32 *out);
BOOL sub_0202FC48(void);
void sub_02030260(int battlerId, u32 a1, u8 data);
u8 sub_0203027C(int battlerId, u32 a1);
BOOL sub_0203018C(SaveData *save, u8 *video);
u64 sub_0203088C(u8 *header, int field, int idx);

#endif // POKEHEARTGOLD_UNK_0202FBCC_H
