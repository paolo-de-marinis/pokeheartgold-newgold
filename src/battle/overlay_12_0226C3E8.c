#include "global.h"

#include "constants/items.h"
#include "constants/species.h"
#include "constants/trainer_class.h"

#include "battle/battle_command.h"

// battle_command.c's read-only tables from the Moon Ball's to the command
// table; see overlay_12_0226C2F8.c for the rest. The compiler lays out a file's
// tables by size, sorting them from the last defined to the first with a heap
// sort, which does not keep tables of one size in the order they were written:
// the three of 52 bytes are defined in the order that comes out as retail's.

// HGSS listed whole families here. New Gold lists only the species a Moon Stone
// actually evolves, which is what the ball has meant since Generation VIII, so
// the pre-evolutions and the already-evolved fall off and Munna joins.
const u16 sMoonBallPokemon[6] = {
    SPECIES_NIDORINA,
    SPECIES_NIDORINO,
    SPECIES_CLEFAIRY,
    SPECIES_JIGGLYPUFF,
    SPECIES_SKITTY,
    SPECIES_MUNNA,
};

const u16 sPickupTable1[18] = {
    ITEM_POTION,
    ITEM_ANTIDOTE,
    ITEM_SUPER_POTION,
    ITEM_GREAT_BALL,
    ITEM_REPEL,
    ITEM_ESCAPE_ROPE,
    ITEM_FULL_HEAL,
    ITEM_HYPER_POTION,
    ITEM_ULTRA_BALL,
    ITEM_REVIVE,
    ITEM_RARE_CANDY,
    ITEM_SUN_STONE,
    ITEM_MOON_STONE,
    ITEM_HEART_SCALE,
    ITEM_FULL_RESTORE,
    ITEM_MAX_REVIVE,
    ITEM_PP_UP,
    ITEM_MAX_ELIXIR,
};

const ManagedSpriteTemplate sPokeIconTemplate = {
    .x = 0x98,
    .y = 0x18,
    .z = 0,
    .animation = 0,
    .drawPriority = 100,
    .pal = 0,
    .vram = NNS_G2D_VRAM_TYPE_2DMAIN,
    .resIdList = { 20022, 20017, 20014, 20014, -1, -1 },
    .bgPriority = 1,
    .vramTransfer = 0,
};

// By terrain.
const u32 sSecretPowerEffectTable[13] = {
    0x8000001B,
    0x8000001B,
    0x80000001,
    0x80000001,
    0x80000008,
    0x80000008,
    0x80000004,
    0x80000016,
    0x80000004,
    0x80000005,
    0x80000018,
    0x8000001C,
    0x80000005,
};

const ManagedSpriteTemplate sLevelUpNameplateTemplate = {
    .x = 0x80,
    .y = 0,
    .z = 0,
    .animation = 0,
    .drawPriority = 200,
    .pal = 0,
    .vram = NNS_G2D_VRAM_TYPE_2DMAIN,
    .resIdList = { 20021, 20016, 20013, 20013, -1, -1 },
    .bgPriority = 1,
    .vramTransfer = 0,
};

// A trainer class and its prize money multiplier.
const u16 sPrizeMoneyTbl[0x81][2] = {
    { TRAINERCLASS_PKMN_TRAINER_ETHAN,     0 },
    { TRAINERCLASS_PKMN_TRAINER_LYRA,      0 },
    { TRAINERCLASS_YOUNGSTER,              4 },
    { TRAINERCLASS_LASS,                   4 },
    { TRAINERCLASS_CAMPER,                 4 },
    { TRAINERCLASS_PICNICKER,              4 },
    { TRAINERCLASS_BUG_CATCHER,            4 },
    { TRAINERCLASS_AROMA_LADY,             8 },
    { TRAINERCLASS_TWINS,                  4 },
    { TRAINERCLASS_HIKER,                  8 },
    { TRAINERCLASS_BATTLE_GIRL,            4 },
    { TRAINERCLASS_FISHERMAN,              8 },
    { TRAINERCLASS_CYCLIST_M,              8 },
    { TRAINERCLASS_CYCLIST_F,              8 },
    { TRAINERCLASS_BLACK_BELT,             6 },
    { TRAINERCLASS_ARTIST,                 12 },
    { TRAINERCLASS_PKMN_BREEDER_M,         12 },
    { TRAINERCLASS_PKMN_BREEDER_F,         12 },
    { TRAINERCLASS_COWGIRL,                4 },
    { TRAINERCLASS_JOGGER,                 8 },
    { TRAINERCLASS_POKEFAN_M,              16 },
    { TRAINERCLASS_POKEFAN,                16 },
    { TRAINERCLASS_POKE_KID,               2 },
    { TRAINERCLASS_RIVAL,                  16 },
    { TRAINERCLASS_ACE_TRAINER_M,          15 },
    { TRAINERCLASS_ACE_TRAINER_F,          15 },
    { TRAINERCLASS_WAITRESS,               8 },
    { TRAINERCLASS_VETERAN,                20 },
    { TRAINERCLASS_NINJA_BOY,              2 },
    { TRAINERCLASS_DRAGON_TAMER,           8 },
    { TRAINERCLASS_BIRD_KEEPER_GS,         8 },
    { TRAINERCLASS_JUGGLER,                8 },
    { TRAINERCLASS_RICH_BOY,               40 },
    { TRAINERCLASS_LADY,                   40 },
    { TRAINERCLASS_GENTLEMAN,              50 },
    { TRAINERCLASS_SOCIALITE,              50 },
    { TRAINERCLASS_BEAUTY,                 14 },
    { TRAINERCLASS_COLLECTOR,              16 },
    { TRAINERCLASS_POLICEMAN,              10 },
    { TRAINERCLASS_PKMN_RANGER_M,          15 },
    { TRAINERCLASS_PKMN_RANGER_F,          15 },
    { TRAINERCLASS_SCIENTIST,              12 },
    { TRAINERCLASS_SWIMMER_M,              4 },
    { TRAINERCLASS_SWIMMER_F,              4 },
    { TRAINERCLASS_TUBER_M,                1 },
    { TRAINERCLASS_TUBER_F,                1 },
    { TRAINERCLASS_SAILOR,                 8 },
    { TRAINERCLASS_KIMONO_GIRL,            30 },
    { TRAINERCLASS_RUIN_MANIAC,            12 },
    { TRAINERCLASS_PSYCHIC_M,              8 },
    { TRAINERCLASS_PSYCHIC_F,              8 },
    { TRAINERCLASS_PI,                     30 },
    { TRAINERCLASS_GUITARIST,              6 },
    { TRAINERCLASS_ACE_TRAINER_M_GS,       15 },
    { TRAINERCLASS_ACE_TRAINER_F_GS,       15 },
    { TRAINERCLASS_TEAM_ROCKET,            10 },
    { TRAINERCLASS_SKIER,                  8 },
    { TRAINERCLASS_ROUGHNECK,              6 },
    { TRAINERCLASS_CLOWN,                  6 },
    { TRAINERCLASS_WORKER,                 10 },
    { TRAINERCLASS_SCHOOL_KID_M,           5 },
    { TRAINERCLASS_SCHOOL_KID_F,           5 },
    { TRAINERCLASS_TEAM_ROCKET_F,          10 },
    { TRAINERCLASS_BURGLAR,                4 },
    { TRAINERCLASS_FIREBREATHER,           8 },
    { TRAINERCLASS_BIKER,                  4 },
    { TRAINERCLASS_LEADER_FALKNER,         30 },
    { TRAINERCLASS_LEADER_BUGSY,           30 },
    { TRAINERCLASS_POKE_MANIAC,            16 },
    { TRAINERCLASS_LEADER_WHITNEY,         30 },
    { TRAINERCLASS_LEADER_MORTY,           30 },
    { TRAINERCLASS_RANCHER,                10 },
    { TRAINERCLASS_LEADER_PRYCE,           30 },
    { TRAINERCLASS_LEADER_JASMINE,         30 },
    { TRAINERCLASS_LEADER_CHUCK,           30 },
    { TRAINERCLASS_LEADER_CLAIR,           30 },
    { TRAINERCLASS_TEACHER,                12 },
    { TRAINERCLASS_SUPER_NERD,             12 },
    { TRAINERCLASS_SAGE,                   12 },
    { TRAINERCLASS_MEDIUM,                 12 },
    { TRAINERCLASS_PARASOL_LADY,           8 },
    { TRAINERCLASS_WAITER,                 8 },
    { TRAINERCLASS_CHAMPION,               50 },
    { TRAINERCLASS_CAMERAMAN,              8 },
    { TRAINERCLASS_REPORTER,               10 },
    { TRAINERCLASS_IDOL,                   18 },
    { TRAINERCLASS_ELITE_FOUR_WILL,        30 },
    { TRAINERCLASS_ELITE_FOUR_KAREN,       30 },
    { TRAINERCLASS_ELITE_FOUR_KOGA,        30 },
    { TRAINERCLASS_LEADER_BROCK,           30 },
    { TRAINERCLASS_PKMN_TRAINER_CHERYL,    30 },
    { TRAINERCLASS_PKMN_TRAINER_RILEY,     30 },
    { TRAINERCLASS_PKMN_TRAINER_BUCK,      30 },
    { TRAINERCLASS_PKMN_TRAINER_MIRA,      30 },
    { TRAINERCLASS_PKMN_TRAINER_MARLEY,    30 },
    { TRAINERCLASS_PKMN_TRAINER_FTR_LUCAS, 25 },
    { TRAINERCLASS_PKMN_TRAINER_FTR_DAWN,  25 },
    { TRAINERCLASS_TOWER_TYCOON,           0 },
    { TRAINERCLASS_LEADER_MISTY,           30 },
    { TRAINERCLASS_HALL_MATRON,            0 },
    { TRAINERCLASS_FACTORY_HEAD,           0 },
    { TRAINERCLASS_ARCADE_STAR,            0 },
    { TRAINERCLASS_CASTLE_VALET,           0 },
    { TRAINERCLASS_LEADER_LT_SURGE,        30 },
    { TRAINERCLASS_LEADER_ERIKA,           30 },
    { TRAINERCLASS_LEADER_JANINE,          30 },
    { TRAINERCLASS_LEADER_SABRINA,         30 },
    { TRAINERCLASS_LEADER_BLAINE,          30 },
    { TRAINERCLASS_PKMN_TRAINER_RED,       50 },
    { TRAINERCLASS_LEADER_BLUE,            40 },
    { TRAINERCLASS_ELDER,                  30 },
    { TRAINERCLASS_ELITE_FOUR_BRUNO,       30 },
    { TRAINERCLASS_SCIENTIST_GS,           8 },
    { TRAINERCLASS_EXECUTIVE_ARIANA,       20 },
    { TRAINERCLASS_BOARDER,                8 },
    { TRAINERCLASS_EXECUTIVE_ARCHER,       20 },
    { TRAINERCLASS_EXECUTIVE_PROTON,       10 },
    { TRAINERCLASS_EXECUTIVE_PETREL,       10 },
    { TRAINERCLASS_PASSERBY,               25 },
    { TRAINERCLASS_MYSTERY_MAN,            30 },
    { TRAINERCLASS_DOUBLE_TEAM,            30 },
    { TRAINERCLASS_YOUNG_COUPLE,           16 },
    { TRAINERCLASS_PKMN_TRAINER_LANCE,     0 },
    { TRAINERCLASS_ROCKET_BOSS,            45 },
    { TRAINERCLASS_PKMN_TRAINER_LUCAS_DP,  0 },
    { TRAINERCLASS_PKMN_TRAINER_DAWN_DP,   0 },
    { TRAINERCLASS_PKMN_TRAINER_LUCAS_PT,  0 },
    { TRAINERCLASS_PKMN_TRAINER_DAWN_PT,   0 },
    { TRAINERCLASS_BIRD_KEEPER,            8 },
};

// The battle script commands, by opcode. Past retail's 225 the numbers are
// hg-engine's, so a battle script written for that engine runs here.
const BtlCmdFunc sBattleScriptCommandTable[] = {
    BtlCmd_PlayEncounterAnimation, // 0
    BtlCmd_SetPokemonEncounter, // 1
    BtlCmd_PokemonSlideIn, // 2
    BtlCmd_PokemonSendOut, // 3
    BtlCmd_RecallPokemon, // 4
    BtlCmd_DeletePokemon, // 5
    BtlCmd_SetTrainerEncounter, // 6
    BtlCmd_ThrowPokeball, // 7
    BtlCmd_TrainerSlideOut, // 8
    BtlCmd_TrainerSlideIn, // 9
    BtlCmd_BackgroundSlideIn, // 10
    BtlCmd_HealthbarSlideIn, // 11
    BtlCmd_HealthbarSlideInDelay, // 12
    BtlCmd_HealthbarSlideOut, // 13
    BtlCmd_Wait, // 14
    BtlCmd_CalcDamage, // 15
    BtlCmd_CalcDamageRaw, // 16
    BtlCmd_PrintAttackMessage, // 17
    BtlCmd_PrintMessage, // 18
    BtlCmd_PrintGlobalMessage, // 19
    BtlCmd_PrintBufferedMessage, // 20
    BtlCmd_BufferMessage, // 21
    BtlCmd_BufferLocalMessage, // 22
    BtlCmd_PlayMoveAnimation, // 23
    BtlCmd_PlayMoveAnimationOnMons, // 24
    BtlCmd_FlickerMon, // 25
    BtlCmd_UpdateHealthbarValue, // 26
    BtlCmd_UpdateHealthbar, // 27
    BtlCmd_TryFaintMon, // 28
    BtlCmd_PlayFaintAnimation, // 29
    BtlCmd_WaitButtonABTime, // 30
    BtlCmd_PlaySound, // 31
    BtlCmd_CompareVarToValue, // 32
    BtlCmd_CompareMonDataToValue, // 33
    BtlCmd_FadeOutBattle, // 34
    BtlCmd_GoToSubscript, // 35
    BtlCmd_GoToEffectScript, // 36
    BtlCmd_GoToMoveScript, // 37
    BtlCmd_CalcCrit, // 38
    BtlCmd_CalcExpGain, // 39
    BtlCmd_StartGetExpTask, // 40
    BtlCmd_WaitGetExpTask, // 41
    BtlCmd_WaitGetExpTaskLoop, // 42
    BtlCmd_ShowParty, // 43
    BtlCmd_WaitMonSelection, // 44
    BtlCmd_SwitchAndUpdateMon, // 45
    BtlCmd_GoToIfAnySwitches, // 46
    BtlCmd_StartCatchMonTask, // 47
    BtlCmd_WaitCatchMonTask, // 48
    BtlCmd_SetMultiHit, // 49
    BtlCmd_UpdateVar, // 50
    BtlCmd_ChangeStatStage, // 51
    BtlCmd_UpdateMonData, // 52
    BtlCmd_ClearVolatileStatus, // 53
    BtlCmd_ToggleVanish, // 54
    BtlCmd_CheckAbility, // 55
    BtlCmd_Random, // 56
    BtlCmd_UpdateVar2, // 57
    BtlCmd_UpdateMonDataFromVar, // 58
    BtlCmd_Goto, // 59
    BtlCmd_Call, // 60
    BtlCmd_CallFromVar, // 61
    BtlCmd_SetMirrorMove, // 62
    BtlCmd_ResetAllStatChanges, // 63
    BtlCmd_LockMoveChoice, // 64
    BtlCmd_UnlockMoveChoice, // 65
    BtlCmd_SetHealthbarStatus, // 66
    BtlCmd_PrintTrainerMessage, // 67
    BtlCmd_PayPrizeMoney, // 68
    BtlCmd_PlayBattleAnimation, // 69
    BtlCmd_PlayBattleAnimationOnMons, // 70
    BtlCmd_PlayBattleAnimationFromVar, // 71
    BtlCmd_PrintRecallMessage, // 72
    BtlCmd_PrintSendOutMessage, // 73
    BtlCmd_PrintEncounterMessage, // 74
    BtlCmd_PrintFirstSendOutMessage, // 75
    BtlCmd_PrintBufferedTrainerMessage, // 76
    BtlCmd_TryConversion, // 77
    BtlCmd_CompareVarToVar, // 78
    BtlCmd_CompareMonDataToVar, // 79
    BtlCmd_AddPayDayMoney, // 80
    BtlCmd_TryLightScreen, // 81
    BtlCmd_TryReflect, // 82
    BtlCmd_TryMist, // 83
    BtlCmd_TryOHKOMove, // 84
    BtlCmd_DivideVarByValue, // 85
    BtlCmd_DivideVarByVar, // 86
    BtlCmd_TryMimic, // 87
    BtlCmd_Metronome, // 88
    BtlCmd_TryDisable, // 89
    BtlCmd_Counter, // 90
    BtlCmd_MirrorCoat, // 91
    BtlCmd_TryEncore, // 92
    BtlCmd_TryConversion2, // 93
    BtlCmd_TrySketch, // 94
    BtlCmd_TrySleepTalk, // 95
    BtlCmd_CalcFlailPower, // 96
    BtlCmd_TrySpite, // 97
    BtlCmd_TryPartyStatusRefresh, // 98
    BtlCmd_TryStealItem, // 99
    BtlCmd_TryProtection, // 100
    BtlCmd_TrySubstitute, // 101
    BtlCmd_TryWhirlwind, // 102
    BtlCmd_Transform, // 103
    BtlCmd_TrySpikes, // 104
    BtlCmd_CheckSpikes, // 105
    BtlCmd_TryPerishSong, // 106
    BtlCmd_GetTurnOrderBySpeed, // 107
    BtlCmd_GoToIfValidMon, // 108
    BtlCmd_EndOfTurnWeatherEffect, // 109
    BtlCmd_CalcRolloutPower, // 110
    BtlCmd_CalcFuryCutterPower, // 111
    BtlCmd_TryAttract, // 112
    BtlCmd_TrySafeguard, // 113
    BtlCmd_Present, // 114
    BtlCmd_CalcMagnitudePower, // 115
    BtlCmd_TryReplaceFaintedMon, // 116
    BtlCmd_RapidSpin, // 117
    BtlCmd_WeatherHPRecovery, // 118
    BtlCmd_CalcHiddenPowerParams, // 119
    BtlCmd_CopyStatStages, // 120
    BtlCmd_TryFutureSight, // 121
    BtlCmd_CheckMoveHit, // 122
    BtlCmd_TryTeleport, // 123
    BtlCmd_BeatUp, // 124
    BtlCmd_FollowMe, // 125
    BtlCmd_TryHelpingHand, // 126
    BtlCmd_TrySwapItems, // 127
    BtlCmd_TryWish, // 128
    BtlCmd_TryAssist, // 129
    BtlCmd_TrySetMagicCoat, // 130
    BtlCmd_MagicCoat, // 131
    BtlCmd_CalcRevengeDamageMul, // 132
    BtlCmd_TryBreakScreens, // 133
    BtlCmd_TryYawn, // 134
    BtlCmd_TryKnockOff, // 135
    BtlCmd_CalcHPFalloffPower, // 136
    BtlCmd_TryImprison, // 137
    BtlCmd_TryGrudge, // 138
    BtlCmd_TrySnatch, // 139
    BtlCmd_CalcWeightBasedPower, // 140
    BtlCmd_CalcWeatherBallParams, // 141
    BtlCmd_TryPursuit, // 142
    BtlCmd_ApplyTypeEffectiveness, // 143
    BtlCmd_IfTurnFlag, // 144
    BtlCmd_SetTurnFlag, // 145
    BtlCmd_CalcGyroBallPower, // 146
    BtlCmd_TryMetalBurst, // 147
    BtlCmd_CalcPaybackPower, // 148
    BtlCmd_CalcTrumpCardPower, // 149
    BtlCmd_CalcWringOutPower, // 150
    BtlCmd_TryMeFirst, // 151
    BtlCmd_TryCopycat, // 152
    BtlCmd_CalcPunishmentPower, // 153
    BtlCmd_TrySuckerPunch, // 154
    BtlCmd_CheckSideCondition, // 155
    BtlCmd_TryFeint, // 156
    BtlCmd_TryPyschoShift, // 157
    BtlCmd_TryLastResort, // 158
    BtlCmd_TryToxicSpikes, // 159
    BtlCmd_CheckToxicSpikes, // 160
    BtlCmd_CheckIgnorableAbility, // 161
    BtlCmd_IfSameSide, // 162
    BtlCmd_GenerateEndOfBattleItem, // 163
    BtlCmd_TrickRoom, // 164
    BtlCmd_IfMovedThisTurn, // 165
    BtlCmd_CheckItemHoldEffect, // 166
    BtlCmd_GetItemHoldEffect, // 167
    BtlCmd_GetItemEffectParam, // 168
    BtlCmd_TryCamouflage, // 169
    BtlCmd_GetTerrainMove, // 170
    BtlCmd_GetTerrainSecondaryEffect, // 171
    BtlCmd_CalcNaturalGiftParams, // 172
    BtlCmd_TryPluck, // 173
    BtlCmd_TryFling, // 174
    BtlCmd_YesNoMenu, // 175
    BtlCmd_WaitYesNoResult, // 176
    BtlCmd_ChoosePokemonMenu, // 177
    BtlCmd_WaitPokemonMenuResult, // 178
    BtlCmd_SetLinkBattleResult, // 179
    BtlCmd_CheckStealthRock, // 180
    BtlCmd_CheckEffectActivation, // 181
    BtlCmd_CheckChatterActivation, // 182
    BtlCmd_GetCurrentMoveData, // 183
    BtlCmd_SetMosaic, // 184
    BtlCmd_ChangeForm, // 185
    BtlCmd_SetBattleBackground, // 186
    BtlCmd_UseBagItem, // 187
    BtlCmd_TryEscape, // 188
    BtlCmd_ShowBattleStartPartyGauge, // 189
    BtlCmd_HideBattleStartPartyGauge, // 190
    BtlCmd_ShowPartyGauge, // 191
    BtlCmd_HidePartyGauge, // 192
    BtlCmd_LoadPartyGaugeGraphics, // 193
    BtlCmd_FreePartyGaugeGraphics, // 194
    BtlCmd_IncrementGameStat, // 195
    BtlCmd_RestoreSprite, // 196
    BtlCmd_TriggerAbilityOnHit, // 197
    BtlCmd_SpriteToOAM, // 198
    BtlCmd_OAMToSprite, // 199
    BtlCmd_CheckWhiteout, // 200
    BtlCmd_BoostRandomStatBy2, // 201
    BtlCmd_RemoveItem, // 202
    BtlCmd_TryRecycle, // 203
    BtlCmd_CheckItemHoldEffectOnHit, // 204
    BtlCmd_PrintBattleResultMessage, // 205
    BtlCmd_PrintEscapeMessage, // 206
    BtlCmd_PrintForfeitMessage, // 207
    BtlCmd_CheckHoldOnWith1HP, // 208
    BtlCmd_TryRestoreStatusOnSwitch, // 209
    BtlCmd_CheckSubstitute, // 210
    BtlCmd_CheckIgnoreWeather, // 211
    BtlCmd_SetRandomTarget, // 212
    BtlCmd_CheckItemHoldEffectOnUTurn, // 213
    BtlCmd_RefreshSprite, // 214
    BtlCmd_PlayMoveHitSound, // 215
    BtlCmd_PlayBGM, // 216
    BtlCmd_CheckSafariGameDone, // 217
    BtlCmd_WaitTime, // 218
    BtlCmd_CheckCurMoveIsType, // 219
    BtlCmd_LoadArchivedMonData, // 220
    BtlCmd_RefreshMonData, // 221
    BtlCmd_222, // 222
    BtlCmd_223, // 223
    BtlCmd_EndScript, // 224
    BtlCmd_ReduceWeight, // 225
    BtlCmd_CalcHeavySlamPower, // 226
    BtlCmd_IsAttackerLevelLowerThanDefender, // 227
    BtlCmd_SetTailwindCounter, // 228
    BtlCmd_GotoIfTailwindActive, // 229
    BtlCmd_GotoIfCurrentFieldIsType, // 230
    BtlCmd_GotoIfMovePowerNotZero, // 231
    BtlCmd_GotoIfGrounded, // 232
    BtlCmd_GotoIfCurrentAdjustedMoveIsType, // 233
    BtlCmd_GotoIfContactMove, // 234
    BtlCmd_GotoIfSoundMove, // 235
    BtlCmd_UpdateTerrainOverlay, // 236
    BtlCmd_GotoIfTerrainOverlayIsType, // 237
    BtlCmd_SetPsychicTerrainMoveUsedFlag, // 238
    BtlCmd_GotoIfFirstHitOfParentalBond, // 239
    BtlCmd_GotoIfSecondHitOfParentalBond, // 240
    BtlCmd_SetParentalBondFlag, // 241
    BtlCmd_GotoIfCurrentMoveIsValidForParentalBond, // 242
    BtlCmd_GotoIfCanApplyKnockOffBoost, // 243
    BtlCmd_GotoIfParentalBondIsActive, // 244
    BtlCmd_ChangePermanentBackground, // 245
    BtlCmd_ChangeExecutionOrderPriority, // 246
    BtlCmd_SetBindingTurns, // 247
    BtlCmd_ClearBindingTurns, // 248
    BtlCmd_CanClearPrimalWeather, // 249
    BtlCmd_SetAbilityActivatedFlag, // 250
    BtlCmd_SwitchInAbilityCheck, // 251
    BtlCmd_TryStickyWeb, // 252
    BtlCmd_TryMegaOrUltraBurstDuringPursuit, // 253
    BtlCmd_CalcConfusionDamage, // 254
    BtlCmd_CheckCanActivateDefiantOrCompetitive, // 255
    BtlCmd_JumpToCurrentEntryHazard, // 256
    BtlCmd_AddEntryHazardToQueue, // 257
    BtlCmd_RemoveEntryHazardFromQueue, // 258
    BtlCmd_CheckProtectContactMoves, // 259
    BtlCmd_TryIncinerate, // 260
    BtlCmd_AddType, // 261
    BtlCmd_TryAuroraVeil, // 262
    BtlCmd_ClearAuroraVeil, // 263
    BtlCmd_StrengthSapCalc, // 264
    BtlCmd_CheckTargetIsPartner, // 265
    BtlCmd_ClearSmog, // 266
    BtlCmd_GoToIfThirdType, // 267
    BtlCmd_GoToIfTerastallized, // 268
    BtlCmd_HandleRoost, // 269
    BtlCmd_HandleSoak, // 270
    BtlCmd_HandleMagicPowder, // 271
    BtlCmd_HandleForestsCurse, // 272
    BtlCmd_HandleTrickOrTreat, // 273
    BtlCmd_HandleBurnUp, // 274
    BtlCmd_HandleDoubleShock, // 275
    BtlCmd_StuffCheeks, // 276
    BtlCmd_SetMoveConditionFlag, // 277
    BtlCmd_AbilityPopup, // 278
    BtlCmd_ActivateParadoxAbility, // 279
    BtlCmd_ResetParadoxAbility, // 280
    BtlCmd_SetCurrentMoveSwitchingStatus, // 281
    BtlCmd_TrySynchronizeStatus, // 282
    BtlCmd_TryCureStatusBerry, // 283
    BtlCmd_BatchUpdateHealthBar, // 284
    BtlCmd_BatchUpdateHealthBarValue, // 285
    BtlCmd_BatchFollowupMessage, // 286
    BtlCmd_BatchEffectivenessMessage, // 287
    BtlCmd_DivideVarByValueRoundUp, // 288
    BtlCmd_IsPursuitActive, // 289
    BtlCmd_GoBackToBeforeMove, // 290
    BtlCmd_MakeTotem, // 291
    BtlCmd_GetMonByCottonDownOrder, // 292
    BtlCmd_TryActivateZeroToHero, // 293
};
