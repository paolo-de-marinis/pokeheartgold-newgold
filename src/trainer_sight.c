#include "unk_020632B0.h"

#include "global.h"

#include "map_object.h"
#include "script_manager.h"

void GetEngagingTrainerParams(EngagingTrainer *trainer, LocalMapObject *object, int unk0, int unk4) {
    trainer->unk0 = unk0;
    trainer->unk4 = unk4;
    trainer->scriptId = MapObject_GetScriptID(object);
    trainer->trainerNum = ScriptNumToTrainerNum(trainer->scriptId);
    trainer->isDouble = TrainerNumIsDouble((u16)trainer->trainerNum);
    trainer->object = object;
}
