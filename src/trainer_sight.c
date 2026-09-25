#include "unk_020632B0.h"

#include "global.h"

#include "map_object.h"
#include "script_manager.h"

void GetEngagingTrainerParams(EngagingTrainer *trainer, LocalMapObject *object, int unk0, int unk4) {
    trainer->unk0 = unk0;
    trainer->unk4 = unk4;
    trainer->scriptId = MapObject_GetScriptID(object);
    trainer->trainerNum = ScriptNumToTrainerNum(trainer->scriptId);
    // TryGetSeenByNpcTrainers sends a partner walking up with him when this
    // is set, and looks for that partner on the map. A double battle without
    // a partner is engaged alone, as hg-engine's walking patches do.
    trainer->hasPartner = TrainerNumHasDoublePartner(trainer->trainerNum);
    trainer->object = object;
}
