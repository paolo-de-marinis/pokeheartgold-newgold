#include "global.h"

#include "constants/std_script.h"

#include "field_system.h"
#include "map_object.h"
#include "script_manager.h"
#include "unk_020632B0.h"

// The encounter types FieldSystem_SetEngagedTrainer records (EngagedTrainer).
enum {
    ENGAGED_SINGLE,
    ENGAGED_DOUBLE_WITH_PARTNER,
    ENGAGED_TWO_TRAINERS,
};

// Each step: if a trainer on the map sees the player, he walks up and his
// battle is recorded. A trainer who fights a double battle, with a partner
// walking up with him or without, engages only a player who can fight one
// (doublesEligible); any other trainer engages alone, or with a second
// trainer who sees the player too if the player can fight both at once.
BOOL TryGetSeenByNpcTrainers(FieldSystem *fieldSystem, BOOL doublesEligible) {
    EngagingTrainer first;
    EngagingTrainer second;
    EngagingTrainer partner;
    PlayerAvatar *playerAvatar = fieldSystem->playerAvatar;
    MapObjectManager *mapObjectManager = fieldSystem->mapObjectManager;

    if (CheckSeenByNpcTrainers(fieldSystem, mapObjectManager, playerAvatar, NULL, &first) == FALSE) {
        return FALSE;
    }
    if (first.hasPartner == FALSE) {
        // A double battle without a partner (TRAINER_BATTLE_DOUBLE_NO_PARTNER)
        // cannot run with one usable Pokemon: he does not see such a player,
        // as the partner kind does not and as talking to him gives only his
        // intro (TrainerIsDoubleBattle, PartyCheckForDouble).
        if (doublesEligible == FALSE && TrainerNumIsDouble(first.trainerNum)) {
            return FALSE;
        }
        StartMapSceneScript(fieldSystem, std_trainer_approach, first.object);
        if (doublesEligible == FALSE || CheckSeenByNpcTrainers(fieldSystem, mapObjectManager, playerAvatar, first.object, &second) == FALSE) {
            FieldSystem_SetEngagedTrainer(fieldSystem, first.object, first.unk0, first.unk4, first.scriptId, first.trainerNum, ENGAGED_SINGLE, 0);
            return TRUE;
        }
        FieldSystem_SetEngagedTrainer(fieldSystem, first.object, first.unk0, first.unk4, first.scriptId, first.trainerNum, ENGAGED_TWO_TRAINERS, 0);
        FieldSystem_SetEngagedTrainer(fieldSystem, second.object, second.unk0, second.unk4, second.scriptId, second.trainerNum, ENGAGED_TWO_TRAINERS, 1);
        return TRUE;
    } else if (first.hasPartner == TRUE) {
        if (doublesEligible == FALSE) {
            return FALSE;
        }
        GetEngagingTrainerParams(&partner, sub_02064520(fieldSystem, mapObjectManager, first.object, first.trainerNum), first.unk0, first.unk4);
        StartMapSceneScript(fieldSystem, std_trainer_approach, first.object);
        FieldSystem_SetEngagedTrainer(fieldSystem, first.object, first.unk0, first.unk4, first.scriptId, first.trainerNum, ENGAGED_DOUBLE_WITH_PARTNER, 0);
        FieldSystem_SetEngagedTrainer(fieldSystem, partner.object, partner.unk0, partner.unk4, partner.scriptId, partner.trainerNum, ENGAGED_DOUBLE_WITH_PARTNER, 1);
        return TRUE;
    }
    GF_AssertFail();
    return FALSE;
}

// The first trainer on the map, other than excluded, who sees the player and
// has not been beaten.
BOOL CheckSeenByNpcTrainers(FieldSystem *fieldSystem, MapObjectManager *mapObjectManager, PlayerAvatar *playerAvatar, LocalMapObject *excluded, EngagingTrainer *trainer) {
    int unk0;
    s32 index = 0;
    int unk4;
    LocalMapObject *object = NULL;

    while (MapObjectManager_GetNextObjectWithFlagFromIndex(mapObjectManager, &object, &index, MAPOBJECTFLAG_ACTIVE)) {
        if (excluded != NULL && excluded == object) {
            continue;
        }
        unk0 = sub_020642C4(object, playerAvatar, &unk4);
        if (unk0 != -1 && TrainerFlagCheck(fieldSystem->saveData, (u16)MapObject_GetTrainerNum(object)) == FALSE) {
            GetEngagingTrainerParams(trainer, object, unk0, unk4);
            return TRUE;
        }
    }
    return FALSE;
}

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
