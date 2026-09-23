    .include "macros/btlcmd.inc"

    .data

// my name is tidy up and i am annoying

_000:
    Call BATTLE_SUBSCRIPT_ATTACK_MESSAGE_AND_ANIMATION

_clearSubstitute:
    CompareMonDataToValue OPCODE_FLAG_NOT, BATTLER_CATEGORY_ENEMY_SLOT_1, BMON_DATA_STATUS2, STATUS2_SUBSTITUTE, _clearSubstitutePartner
    UpdateMonData OPCODE_FLAG_OFF, BATTLER_CATEGORY_ENEMY_SLOT_1, BMON_DATA_STATUS2, STATUS2_SUBSTITUTE
    PlayBattleAnimation BATTLER_CATEGORY_ENEMY_SLOT_1, BATTLE_ANIMATION_SUBSTITUTE_OUT
    Wait
    RestoreSprite BATTLER_CATEGORY_ENEMY_SLOT_1
    Wait
    PlayBattleAnimation BATTLER_CATEGORY_ENEMY_SLOT_1, BATTLE_ANIMATION_SUB_IN
    Wait
    // {0}’s substitute faded!
    PrintMessage msg_0197_00357, TAG_NICKNAME, BATTLER_CATEGORY_ENEMY_SLOT_1
    Wait
    WaitButtonABTime 30

_clearSubstitutePartner:
    CompareMonDataToValue OPCODE_FLAG_NOT, BATTLER_CATEGORY_ENEMY_SLOT_2, BMON_DATA_STATUS2, STATUS2_SUBSTITUTE, _clearPlayerSubstitute
    UpdateMonData OPCODE_FLAG_OFF, BATTLER_CATEGORY_ENEMY_SLOT_2, BMON_DATA_STATUS2, STATUS2_SUBSTITUTE
    PlayBattleAnimation BATTLER_CATEGORY_ENEMY_SLOT_2, BATTLE_ANIMATION_SUBSTITUTE_OUT
    Wait
    RestoreSprite BATTLER_CATEGORY_ENEMY_SLOT_2
    Wait
    PlayBattleAnimation BATTLER_CATEGORY_ENEMY_SLOT_2, BATTLE_ANIMATION_SUB_IN
    Wait
    // {0}’s substitute faded!
    PrintMessage msg_0197_00357, TAG_NICKNAME, BATTLER_CATEGORY_ENEMY_SLOT_2
    Wait
    WaitButtonABTime 30

_clearPlayerSubstitute:
    CompareMonDataToValue OPCODE_FLAG_NOT, BATTLER_CATEGORY_PLAYER_SLOT_1, BMON_DATA_STATUS2, STATUS2_SUBSTITUTE, _clearPlayerSubstitutePartner
    UpdateMonData OPCODE_FLAG_OFF, BATTLER_CATEGORY_PLAYER_SLOT_1, BMON_DATA_STATUS2, STATUS2_SUBSTITUTE
    PlayBattleAnimation BATTLER_CATEGORY_PLAYER_SLOT_1, BATTLE_ANIMATION_SUBSTITUTE_OUT
    Wait
    RestoreSprite BATTLER_CATEGORY_PLAYER_SLOT_1
    Wait
    PlayBattleAnimation BATTLER_CATEGORY_PLAYER_SLOT_1, BATTLE_ANIMATION_SUB_IN
    Wait
    // {0}’s substitute faded!
    PrintMessage msg_0197_00357, TAG_NICKNAME, BATTLER_CATEGORY_PLAYER_SLOT_1
    Wait
    WaitButtonABTime 30

_clearPlayerSubstitutePartner:
    CompareMonDataToValue OPCODE_FLAG_NOT, BATTLER_CATEGORY_PLAYER_SLOT_2, BMON_DATA_STATUS2, STATUS2_SUBSTITUTE, _clearSpikes
    UpdateMonData OPCODE_FLAG_OFF, BATTLER_CATEGORY_PLAYER_SLOT_2, BMON_DATA_STATUS2, STATUS2_SUBSTITUTE
    PlayBattleAnimation BATTLER_CATEGORY_PLAYER_SLOT_2, BATTLE_ANIMATION_SUBSTITUTE_OUT
    Wait
    RestoreSprite BATTLER_CATEGORY_PLAYER_SLOT_2
    Wait
    PlayBattleAnimation BATTLER_CATEGORY_PLAYER_SLOT_2, BATTLE_ANIMATION_SUB_IN
    Wait
    // {0}’s substitute faded!
    PrintMessage msg_0197_00357, TAG_NICKNAME, BATTLER_CATEGORY_PLAYER_SLOT_2
    Wait
    WaitButtonABTime 30

_clearSpikes:
    CheckSideCondition BATTLER_CATEGORY_ENEMY, CHECK_SIDE_COND_VAL_ZERO, SIDE_COND_SPIKES_LAYERS, _clearPlayerSpikes
    CheckSideCondition BATTLER_CATEGORY_ENEMY, CHECK_SIDE_COND_CLEAR, SIDE_COND_SPIKES_LAYERS, _clearPlayerSpikes
    RemoveEntryHazardFromQueue BATTLER_CATEGORY_ENEMY, HAZARD_IDX_SPIKES
    // The spikes disappeared from around the opposing team!
    PrintMessage msg_0197_01553, TAG_NONE
    Wait
    WaitButtonABTime 30

_clearPlayerSpikes:
    CheckSideCondition BATTLER_CATEGORY_PLAYER, CHECK_SIDE_COND_VAL_ZERO, SIDE_COND_SPIKES_LAYERS, _clearToxicSpikes
    CheckSideCondition BATTLER_CATEGORY_PLAYER, CHECK_SIDE_COND_CLEAR, SIDE_COND_SPIKES_LAYERS, _clearToxicSpikes
    RemoveEntryHazardFromQueue BATTLER_CATEGORY_PLAYER, HAZARD_IDX_SPIKES
    // The spikes disappeared from around your team!
    PrintMessage msg_0197_01552, TAG_NONE
    Wait
    WaitButtonABTime 30

_clearToxicSpikes:
    CheckSideCondition BATTLER_CATEGORY_ENEMY, CHECK_SIDE_COND_VAL_ZERO, SIDE_COND_TOXIC_SPIKES_LAYERS, _clearPlayerToxicSpikes
    CheckSideCondition BATTLER_CATEGORY_ENEMY, CHECK_SIDE_COND_CLEAR, SIDE_COND_TOXIC_SPIKES_LAYERS, _clearPlayerToxicSpikes
    RemoveEntryHazardFromQueue BATTLER_CATEGORY_ENEMY, HAZARD_IDX_TOXIC_SPIKES
    // The poison spikes disappeared from around the opposing team!
    PrintMessage msg_0197_01066, TAG_NONE
    Wait
    WaitButtonABTime 30

_clearPlayerToxicSpikes:
    CheckSideCondition BATTLER_CATEGORY_PLAYER, CHECK_SIDE_COND_VAL_ZERO, SIDE_COND_TOXIC_SPIKES_LAYERS, _clearStealthRock
    CheckSideCondition BATTLER_CATEGORY_PLAYER, CHECK_SIDE_COND_CLEAR, SIDE_COND_TOXIC_SPIKES_LAYERS, _clearStealthRock
    RemoveEntryHazardFromQueue BATTLER_CATEGORY_PLAYER, HAZARD_IDX_TOXIC_SPIKES
    // The poison spikes disappeared from around your team!
    PrintMessage msg_0197_01065, TAG_NONE
    Wait
    WaitButtonABTime 30

// Stealth Rock and Sticky Web by the side the message names, as the spikes
// above: the reference's 445 tests the battler ids for them, which never
// hold the flags, so neither was ever cleared.
_clearStealthRock:
    CheckSideCondition BATTLER_CATEGORY_ENEMY, CHECK_SIDE_COND_VAL_ZERO, SIDE_COND_STEALTH_ROCK, _clearPlayerStealthRock
    CheckSideCondition BATTLER_CATEGORY_ENEMY, CHECK_SIDE_COND_CLEAR, SIDE_COND_STEALTH_ROCK, _clearPlayerStealthRock
    RemoveEntryHazardFromQueue BATTLER_CATEGORY_ENEMY, HAZARD_IDX_STEALTH_ROCK
    // The pointed stones disappeared from the ground around the opposing team!
    PrintMessage msg_0197_01551, TAG_NONE
    Wait
    WaitButtonABTime 30

_clearPlayerStealthRock:
    CheckSideCondition BATTLER_CATEGORY_PLAYER, CHECK_SIDE_COND_VAL_ZERO, SIDE_COND_STEALTH_ROCK, _clearStickyWeb
    CheckSideCondition BATTLER_CATEGORY_PLAYER, CHECK_SIDE_COND_CLEAR, SIDE_COND_STEALTH_ROCK, _clearStickyWeb
    RemoveEntryHazardFromQueue BATTLER_CATEGORY_PLAYER, HAZARD_IDX_STEALTH_ROCK
    // The pointed stones disappeared from the ground around your team!
    PrintMessage msg_0197_01550, TAG_NONE
    Wait
    WaitButtonABTime 30

_clearStickyWeb:
    CheckSideCondition BATTLER_CATEGORY_ENEMY, CHECK_SIDE_COND_VAL_ZERO, SIDE_COND_STICKY_WEB, _clearPlayerStickyWeb
    CheckSideCondition BATTLER_CATEGORY_ENEMY, CHECK_SIDE_COND_CLEAR, SIDE_COND_STICKY_WEB, _clearPlayerStickyWeb
    RemoveEntryHazardFromQueue BATTLER_CATEGORY_ENEMY, HAZARD_IDX_STICKY_WEB
    // The sticky web has disappeared from the ground around the opposing team!
    PrintMessage msg_0197_01555, TAG_NONE
    Wait
    WaitButtonABTime 30

_clearPlayerStickyWeb:
    CheckSideCondition BATTLER_CATEGORY_PLAYER, CHECK_SIDE_COND_VAL_ZERO, SIDE_COND_STICKY_WEB, _boosts
    CheckSideCondition BATTLER_CATEGORY_PLAYER, CHECK_SIDE_COND_CLEAR, SIDE_COND_STICKY_WEB, _boosts
    RemoveEntryHazardFromQueue BATTLER_CATEGORY_PLAYER, HAZARD_IDX_STICKY_WEB
    // The sticky web has disappeared from the ground around you!
    PrintMessage msg_0197_01554, TAG_NONE
    Wait
    WaitButtonABTime 30

_boosts:
    // Tidying up complete!
    PrintMessage msg_0197_01549, TAG_NONE
    Wait
    WaitButtonABTime 30
    CompareMonDataToValue OPCODE_NEQ, BATTLER_CATEGORY_SIDE_EFFECT_MON, BMON_DATA_STAT_CHANGE_ATK, 12, _011
    CompareMonDataToValue OPCODE_EQU, BATTLER_CATEGORY_SIDE_EFFECT_MON, BMON_DATA_STAT_CHANGE_SPEED, 12, _046

_011:
    UpdateVar OPCODE_FLAG_ON, BSCRIPT_VAR_BATTLE_STATUS, BATTLE_STATUS_MESSAGES_OFF
    UpdateVar OPCODE_FLAG_ON, BSCRIPT_VAR_BATTLE_STATUS, BATTLE_STATUS_MOVE_ANIMATIONS_OFF|BATTLE_STATUS_NO_ATTACK_MESSAGE
    UpdateVar OPCODE_FLAG_ON, BSCRIPT_VAR_BATTLE_STATUS_2, BATTLE_STATUS2_STAT_STAGE_CHANGE_SHOWN
    UpdateVar OPCODE_SET, BSCRIPT_VAR_SIDE_EFFECT_PARAM, MOVE_SUBSCRIPT_PTR_ATTACK_UP_1_STAGE
    Call BATTLE_SUBSCRIPT_UPDATE_STAT_STAGE
    UpdateVar OPCODE_SET, BSCRIPT_VAR_SIDE_EFFECT_PARAM, MOVE_SUBSCRIPT_PTR_SPEED_UP_1_STAGE
    Call BATTLE_SUBSCRIPT_UPDATE_STAT_STAGE
    UpdateVar OPCODE_FLAG_OFF, BSCRIPT_VAR_BATTLE_STATUS_2, BATTLE_STATUS2_UPDATE_STAT_STAGES
    UpdateVar OPCODE_FLAG_OFF, BSCRIPT_VAR_BATTLE_STATUS_2, BATTLE_STATUS2_STAT_STAGE_CHANGE_SHOWN
    End

_046:
    PrintAttackMessage
    Wait
    WaitButtonABTime 30
    // {0}’s stats won’t go any higher!
    PrintMessage msg_0197_00768, TAG_NICKNAME, BATTLER_CATEGORY_SIDE_EFFECT_MON
    Wait
    WaitButtonABTime 30
    UpdateVar OPCODE_FLAG_ON, BSCRIPT_VAR_MOVE_STATUS_FLAGS, MOVE_STATUS_NO_MORE_WORK
    End
