#include "battle/battle_system.h"
#include "battle/trainer_ai.h"

// Whether the AI's Pokemon is about to faint to Perish Song: it switches, to
// whichever Pokemon its pick decides (6, no party slot chosen yet).
BOOL ov10_0221F5F4(BattleContext *ctx, int battlerId) {
    if ((ctx->battleMons[battlerId].moveEffectFlags & MOVE_EFFECT_FLAG_PERISH_SONG) && ctx->battleMons[battlerId].unk88.perishSongTurns == 0) {
        ctx->unk_21A4[battlerId] = 6;
        return TRUE;
    }
    return FALSE;
}
