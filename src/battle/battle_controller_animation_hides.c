#include "battle/battle_controller_opponent.h"
#include "constants/battle_script_imports.h"
#include "constants/battle_subscript.h"
#include "move.h"

// What an animation hides while it plays, for the opponent controller's
// animation task (ov12_0225A914, ov12_0225FD14): the health boxes
// (BattleSystem_SetHpBarDisabled) and the Pokemon's shadows
// (PokepicManager_SetG3UpdateFlagsMask). A move's say so in its flags: the
// boxes stay with bit 6, the shadows go with bit 7. Of the battle
// animations (a/0/6/1), the weathers' and most binding moves' damage hide
// the boxes, Magma Storm's and Whirlpool's the shadows too; and a terrain's
// start, which covers the field as a weather's does.
void ov12_02261D30(u8 *hideHpBars, u8 *hideShadows, int isBattleAnimation, int animation, u16 move) {
    if (!isBattleAnimation) {
        u16 moveNo = move & 0xFFFF; // kept in a register for both reads, as the game's code keeps it
        if (!(GetMoveAttr(moveNo, MOVEATTR_UNK9) & 0x40)) {
            *hideHpBars = TRUE;
        } else {
            *hideHpBars = FALSE;
        }
        if (GetMoveAttr(moveNo, MOVEATTR_UNK9) & 0x80) {
            *hideShadows = TRUE;
        } else {
            *hideShadows = FALSE;
        }
        return;
    }

    switch (animation) {
    case BATTLE_ANIMATION_WEATHER_FOG:
    case BATTLE_ANIMATION_WEATHER_RAIN:
    case BATTLE_ANIMATION_WEATHER_HAIL:
    case BATTLE_ANIMATION_WEATHER_SAND:
    case BATTLE_ANIMATION_WEATHER_SUN:
    case BATTLE_ANIMATION_DAMAGE_NIGHTMARE:
    case BATTLE_ANIMATION_DAMAGE_LEECH_SEED:
    case BATTLE_ANIMATION_DAMAGE_WRAP:
    case BATTLE_ANIMATION_DAMAGE_FIRE_SPIN:
    case BATTLE_ANIMATION_DAMAGE_CLAMP:
    case BATTLE_ANIMATION_DAMAGE_SAND_TOMB:
    case BATTLE_ANIMATION_GRASSY_TERRAIN:
    case BATTLE_ANIMATION_MISTY_TERRAIN:
    case BATTLE_ANIMATION_ELECTRIC_TERRAIN:
    case BATTLE_ANIMATION_PSYCHIC_TERRAIN:
        *hideHpBars = TRUE;
        *hideShadows = FALSE;
        break;
    case BATTLE_ANIMATION_DAMAGE_MAGMA_STORM:
    case BATTLE_ANIMATION_DAMAGE_WHIRLPOOL:
        *hideHpBars = TRUE;
        *hideShadows = TRUE;
        break;
    default:
        *hideHpBars = FALSE;
        *hideShadows = FALSE;
        break;
    }
#ifdef NEWGOLD_DIAG
    if (*hideHpBars) {
        gDiagHealthBoxesHiddenBy = animation;
    }
#endif
}
