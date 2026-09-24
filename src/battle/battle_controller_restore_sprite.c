#include "battle/battle_controller.h"
#include "battle/battle_system.h"

// A battler's own sprite back where its substitute's was (RestoreSprite), a
// disguise's for one made up by its Illusion: the packet the substitute's
// swap sends (BattleController_EmitBattlerSprites).
void BattleController_EmitRestoreSprite(BattleSystem *battleSystem, BattleContext *ctx, int battlerId) {
    BattleController_EmitBattlerSprites(battleSystem, ctx, battlerId, 56);
}
