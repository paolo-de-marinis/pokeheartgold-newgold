    .include "macros/btlcmd.inc"

    .data

// An Illusion dropping from the Pokemon in MSG_TEMP: the reference's
// subscript 330. The disguise is already forgotten when this runs, so the
// sprite and the health box are redrawn as the Pokemon itself and the line
// names it. The reference turns the sprite with Transform's animation; this
// is the form changes' mosaic, which is what this game has for a sprite
// changing in place.

_000:
    CompareMonDataToValue OPCODE_FLAG_NOT, BATTLER_CATEGORY_MSG_TEMP, BMON_DATA_STATUS2, STATUS2_SUBSTITUTE, _REVEAL
    PlayBattleAnimation BATTLER_CATEGORY_MSG_TEMP, BATTLE_ANIMATION_SUB_OUT
    Wait
    RestoreSprite BATTLER_CATEGORY_MSG_TEMP
    Wait
    PlayBattleAnimation BATTLER_CATEGORY_MSG_TEMP, BATTLE_ANIMATION_SUB_IN
    Wait

_REVEAL:
    PlaySound BATTLER_CATEGORY_MSG_TEMP, SEQ_SE_DP_W100
    SetMosaic BATTLER_CATEGORY_MSG_TEMP, 8, 1
    Wait
    ChangeForm BATTLER_CATEGORY_MSG_TEMP
    PlaySound BATTLER_CATEGORY_MSG_TEMP, SEQ_SE_DP_W107
    SetMosaic BATTLER_CATEGORY_MSG_TEMP, 0, 1
    Wait
    HealthbarSlideIn BATTLER_CATEGORY_MSG_TEMP
    Wait
    // {0}’s illusion wore off!
    PrintMessage msg_0197_01348, TAG_NICKNAME, BATTLER_CATEGORY_MSG_TEMP
    Wait
    WaitButtonABTime 30
    CompareMonDataToValue OPCODE_FLAG_NOT, BATTLER_CATEGORY_MSG_TEMP, BMON_DATA_STATUS2, STATUS2_SUBSTITUTE, _END
    PlayBattleAnimation BATTLER_CATEGORY_MSG_TEMP, BATTLE_ANIMATION_SUB_OUT
    Wait
    RefreshSprite BATTLER_CATEGORY_MSG_TEMP
    Wait
    PlayBattleAnimation BATTLER_CATEGORY_MSG_TEMP, BATTLE_ANIMATION_SUB_IN
    Wait

_END:
    End
