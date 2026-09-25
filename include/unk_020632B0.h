#ifndef POKEHEARTGOLD_UNK_020632B0_H
#define POKEHEARTGOLD_UNK_020632B0_H

#include "script.h"

// A trainer that sees the player, as CheckSeenByNpcTrainers records it: the
// two values the sight check gave (EngagedTrainer's unk0 and unk4), the
// object's script and trainer, whether a partner walks up with him, and the
// object.
typedef struct EngagingTrainer {
    int unk0;
    int unk4;
    u32 scriptId;
    u32 trainerNum;
    BOOL hasPartner;
    LocalMapObject *object;
} EngagingTrainer;

BOOL TryGetSeenByNpcTrainers(FieldSystem *fieldSystem, BOOL doublesEligible);
BOOL CheckSeenByNpcTrainers(FieldSystem *fieldSystem, MapObjectManager *mapObjectManager, PlayerAvatar *playerAvatar, LocalMapObject *excluded, EngagingTrainer *trainer);
void GetEngagingTrainerParams(EngagingTrainer *trainer, LocalMapObject *object, int unk0, int unk4);
int sub_020642C4(LocalMapObject *object, PlayerAvatar *playerAvatar, int *unk4);
u32 MapObject_GetTrainerNum(LocalMapObject *object);
LocalMapObject *sub_02064520(FieldSystem *fieldSystem, MapObjectManager *mapObjectManager, LocalMapObject *trainer, u32 trainerNum);
int sub_0206457C(FieldSystem *fieldSystem, LocalMapObject *localMapObject, PlayerAvatar *playerAvatar, int a3, int a4, int a5, int a6, u16 trainerNum);
BOOL sub_02064598(void);
void sub_020645AC(int a0);

#endif // POKEHEARTGOLD_UNK_020632B0_H
