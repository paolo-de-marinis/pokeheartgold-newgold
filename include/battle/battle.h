#ifndef POKEHEARTGOLD_BATTLE_H
#define POKEHEARTGOLD_BATTLE_H

#include "constants/battle.h"
#include "constants/moves.h"

#include "bag.h"
#include "bag_cursor.h"
#include "bg_window.h"
#include "filesystem.h"
#include "font.h"
#include "game_stats.h"
#include "item.h"
#include "move.h"
#include "msgdata.h"
#include "obj_char_transfer.h"
#include "options.h"
#include "palette.h"
#include "player_data.h"
#include "pokedex.h"
#include "pokemon_storage_system.h"
#include "pokepic.h"
#include "sav_chatot.h"
#include "sprite.h"
#include "sprite_system.h"
#include "sys_task_api.h"
#include "trainer_data.h"
#include "unk_0200CE7C.h"
#include "unk_02013534.h"

typedef struct BattleMessage {
    u8 unk0;
    u8 tag;
    u16 id;
    int param[6];
    int numDigits;
    int battlerId;
} BattleMessage;

typedef struct BattleMessageData {
    u32 id;
    int tag;
    int params[6];
} BattleMessageData;

typedef struct GetterWork GetterWork;

typedef struct FieldConditionData {
    u32 weatherTurns;
    u8 futureSightTurns[4];
    u8 wishTurns[4];
    u16 futureSightMoveNo[4];
    int battlerIdFutureSight[4];
    int futureSightMonIndex[4]; // the user's place in its party, for the landing
    u8 wishTarget[4];
} FieldConditionData;

typedef struct SideConditionData {
    u32 reflectBattler : 2;
    u32 reflectTurns : 3;
    u32 lightScreenBattler : 2;
    u32 lightScreenTurns : 3;
    u32 mistBattler : 2;
    u32 mistTurns : 3;
    u32 safeguardBattler : 2;
    u32 safeguardTurns : 3;
    u32 followMeFlag : 1;
    u32 battlerIdFollowMe : 2;
    u32 battlerBitKnockedOffItem : 6;
    u32 unk0_1D : 3;
    u32 spikesLayers : 2;
    u32 toxicSpikesLayers : 2;
    u32 auroraVeilBattler : 2;
    u32 auroraVeilTurns : 4;
    u32 unk4_4 : 22;
} SideConditionData;

typedef struct TurnData {
    u32 struggleFlag : 1;
    u32 unk0_1 : 1;
    u32 protectFlag : 1;
    u32 helpingHandFlag : 1;
    u32 magicCoatFlag : 1;
    u32 snatchFlag : 1;
    u32 roostFlag : 1;
    u32 runFlag : 2; // 1 - Fled using item, 2 - Fled using ability
    u32 endureFlag : 1;
    u32 forceExecutionOrder : 2; // EXECUTION_ORDER_*: After You brings this battler forward, Quash sends it last
    u32 gainedProtectFlagFromAlly : 1; // protectFlag came from the ally's Wide Guard, Quick Guard, Mat Block or Crafty Shield
    u32 switchedIn : 1;                // came into the battle during this turn, so has not acted in it: Payback does not double
    u32 statRaised : 1; // a stat of its rose this turn, or before the first: Burning Jealousy burns it
    u32 electrified : 1; // Electrify landed on it: its move this turn is Electric
    u32 unk0_A : 16;
    int physicalDamage[4];
    int battlerIdPhysicalDamage;
    int battlerBitPhysicalDamage;
    int specialDamage[4];
    int battlerIdSpecialDamage;
    int battlerBitSpecialDamage;
    int unk34;
    int unk38;
    int unk3C;
} TurnData;

typedef struct SelfTurnData {
    u32 ignorePressure : 1;
    u32 lightningRodFlag : 1;
    u32 stormDrainFlag : 1;
    u32 moldBreakerFlag : 1;
    u32 trickRoomFlag : 1;
    u32 endureItemFlag : 1;
    u32 rolloutCount : 3;
    // Emergency Exit and Wimp Out: this Pokemon, holding either, was above
    // half its health when a hit of this action landed on it.
    u32 retreatArmed : 1;
    // Parental Bond: this Pokemon's move is striking twice.
    u32 parentalBond : 1;
    // Sheer Force: this Pokemon's move gave its effect up for power, as
    // ov12_02250490 found before clearing the flags that say so.
    u32 sheerForceTraded : 1;
    // Emergency Exit and Wimp Out: this Pokemon, holding either, was above
    // half its health when damage from outside a move came its way.
    u32 retreatArmedOutsideMove : 1;
    // Gulp Missile: the prey this Cramorant caught during the action, for the
    // form it shows once the action is over -- GULP_MISSILE_ARROKUDA or
    // GULP_MISSILE_PIKACHU, or 0.
    u32 gulpMissilePrey : 2;
    // The Berry BtlCmd_RemoveItem takes from this Pokemon next is not eaten
    // by it: it is plucked, flung or spent on Natural Gift.
    u32 berryNotEaten : 1;
    // Dragon Tail or Circle Throw hit this Pokemon: it is dragged out once
    // the hit has been answered (ov12_0224E1BC).
    u32 dragPending : 1;
    u32 unk0_11 : 15;
    int physicalDamage;
    int battlerIdPhysicalAttacker;
    int specialDamage;
    int battlerIdSpecialAttacker;
    int unk14;
    int shellBellDamage;
} SelfTurnData;

typedef struct TrainerAIData {
    u8 unk0;
    u8 unk1;
    u16 unk2;
    s8 movePoints[4]; // higher points = more priority for selection
    int unk8;
    u32 aiFlags;
    u8 unk10;
    u8 unk11;
    u8 unk12;
    u8 unk13;
    u8 *unk14;
    u8 unk18[4];
    u16 moves[BATTLER_MAX][MOVES_MAX];
    u8 unusedAbilities[BATTLER_MAX]; // Wide cache lives at the end of BattleContext.
    u16 heldItems[BATTLER_MAX];
    u16 unk68[2][4];
    u32 unk78[8];
    u8 unk98;
    u8 unk99[2];
    u8 battlerIdAttacker;
    u8 battlerIdTarget;
    u8 useItem[2];
    u8 unk9F[2];
    u16 unkA0[2];
    u8 unkA4[4];
    MoveTbl moveData[NUM_MOVES + 1];
    ItemData *itemData;
    u16 unk280[4];
    u16 unk288[4];
} TrainerAIData;

typedef struct MoveFailFlags {
    u32 paralysis : 1;
    u32 noEffect : 1;
    u32 imprison : 1;
    u32 infatuation : 1;
    u32 disabled : 1;
    u32 unk0_5 : 1;
    u32 flinch : 1;
    u32 confusion : 1;
    u32 gravity : 1;
    u32 healBlock : 1;
    u32 throatChop : 1;
    u32 unused : 20;
} MoveFailFlags;

typedef struct UnkBattlemonSub {
    u32 disabledTurns : 3;
    u32 encoredTurns : 3;
    u32 isCharged : 2;
    u32 tauntTurns : 3;
    u32 unk0_B : 2; // retail's run of guards, now BattleContext.protectSuccessTurns
    u32 perishSongTurns : 2;
    u32 rolloutCount : 3;
    u32 furyCutterCount : 3;
    u32 stockpileCount : 3;
    u32 stockpileDefCount : 3;
    u32 stockpileSpDefCount : 3;
    u32 truantFlag : 1;
    u32 flashFire : 1;
    u32 battlerIdLockOn : 2;
    u32 mimicedMoveIndex : 4;
    u32 battlerIdBinding : 2;
    u32 battlerIdMeanLook : 2;
    u32 lastResortCount : 3;
    u32 magnetRiseTurns : 3;
    u32 healBlockTurns : 3;
    u32 embargoFlag : 3;
    u32 knockOffFlag : 1;   // unclear whether true mean knocked off or not knocked
                            // off based on current information on its usage
    u32 metronomeTurns : 4; // refers to the item, not the move
    u32 micleBerryFlag : 1;
    u32 custapBerryFlag : 1;
    u32 quickClawFlag : 1;
    u32 meFirstFlag : 1;
    // Quick Draw's own Quick Claw flag, so that its line names the ability
    // and an item thief does not take it for a Quick Claw at work.
    u32 quickDrawFlag : 1;
    int rechargeCount;
    int fakeOutCount;
    int slowStartTurns;
    int meFirstCount;
    int substituteHp;
    u32 transformPersonality;
    u16 disabledMove;
    u16 bindingMove;
    u16 encoredMove;
    u16 encoredMoveIndex;
    u16 lastResortMoves[4];
    u16 moveNoChoice;
    u16 transformGender;
    int unk30;
} UnkBattlemonSub;

typedef struct BattleMon {
    u16 species;
    u16 atk;
    u16 def;
    u16 speed;
    u16 spAtk;
    u16 spDef;
    u16 moves[MAX_MON_MOVES];
    u32 hpIV : 5;
    u32 atkIV : 5;
    u32 defIV : 5;
    u32 speedIV : 5;
    u32 spAtkIV : 5;
    u32 spDefIV : 5;
    u32 isEgg : 1;
    u32 hasNickname : 1;
    s8 statChanges[NUM_BATTLE_STATS];
    int weight;
    u8 type1;
    u8 type2;
    u8 form : 5;
    u8 shiny : 1;
    // hg-engine's critical_hits: the critical hits landed since this
    // Pokemon came out, for Galarian Farfetch'd. The two spare bits beside
    // the form, so the structure keeps its size.
    u8 criticalHits : 2;
    u8 unusedAbility;
    u32 sendOutFlag : 1;
    u32 intimidateFlag : 1;
    u32 traceFlag : 1;
    u32 downloadFlag : 1;
    u32 anticipationFlag : 1;
    u32 forewarnFlag : 1;
    u32 slowStartFlag : 1;
    u32 slowStartEnded : 1;
    u32 friskFlag : 1;
    u32 moldBreakerFlag : 1;
    u32 pressureFlag : 1;
    u32 cheekPouchPending : 1;
    u32 competitivePending : 1;
    u32 abilityActivatedFlag : 1;
    u32 unnerveFlag : 1;
    u32 screenCleanerFlag : 1;
    u32 imposterFlag : 1;
    u32 hospitalityFlag : 1;
    u32 neutralizingGasFlag : 1;
    // A third type, TYPE_NONE unless a script has added one. It takes eight of
    // the spare bits rather than a byte of its own: the assembly that still
    // reads this structure does so by offset, and type1 and type2 have code
    // above them.
    u32 type3 : 8;
    // Whether the species has any evolution left, which is what Eviolite asks.
    // Read once on the way into battle rather than per damage calculation,
    // because answering it means reading the evolution archive.
    u32 canStillEvolve : 1;
    // Whether the held Air Balloon has already said it is floating. Set on the
    // way in whether or not the message was printed, so a Pokemon that walked
    // in grounded never announces the balloon later. Another bit out of the
    // spare four, so the structure is the same size it was.
    u32 airBalloonFlag : 1;
    // Illusion: the party slot, plus one, of the Pokemon this one is made up
    // as, or 0. The last three spare bits, so the structure keeps its size.
    u32 illusionMon : 3;
    u8 movePPCur[MAX_MON_MOVES];
    u8 movePP[MAX_MON_MOVES];
    u8 level;
    u8 friendship;
    u16 nickname[POKEMON_NAME_LENGTH + 1];
    s32 hp;
    u32 maxHp;
    u16 otName[PLAYER_NAME_LENGTH + 1];
    u32 exp;
    u32 personality;
    u32 status;
    u32 status2;
    u32 otid;
    u16 item;
    u16 ability;
    u8 hitCount;
    u8 msgFlag;
    u8 gender : 4;
    u8 otGender : 4;
    u8 ball;
    u32 moveEffectFlags;
    u32 moveEffectFlagsTemp;
    UnkBattlemonSub unk88;
} BattleMon;

typedef struct PokemonStats {
    u32 stats[6];
} PokemonStats;

typedef struct PlayerActions {
    ControllerCommand command;
    u32 unk4;
    u32 unk8;
    u32 inputSelection;
} PlayerActions;

// What a move left on a battler for later. The reference keeps these apart
// from the one-turn flags because they outlive the turn: a Laser Focus lands
// next turn, a Throat Chop holds for two. Cleared when the Pokemon is loaded
// in, counted down when a turn starts.
typedef struct MoveConditions {
    u8 powderBlockingFireMove : 1; // Powder: a Fire move this turn goes off in the user's face
    u8 laserFocusTimer : 2;        // Laser Focus: every hit is a critical hit while this runs
    u8 glaiveRush : 1;             // Glaive Rush: takes double, and cannot dodge, until it moves again
    u8 throatChopTimer : 2;        // Throat Chop: no sound moves while this runs
    u8 statLoweredThisTurn : 1;    // a stat of its was lowered this turn: Lash Out doubles
    u8 bindEighthTurn : 1;         // a Grip Claw's bind: the turn STATUS2_BIND's three bits cannot count
    u8 octolocked : 1;             // Octolock: held by Mean Look's flag, Defense and Sp. Def down at each turn's end
    u8 saltCured : 1;              // Salt Cure: an eighth of its HP at each turn's end, a quarter for Water and Steel
} MoveConditions;

#define BATTLE_SCRIPT_BUFFER_WORDS 650

typedef struct BattleContext {
    u8 unk_0[4];
    u8 unk_4[4];
    ControllerCommand command;
    ControllerCommand commandNext;
    int stateFieldConditionUpdate;
    int fieldConditionUpdateData;
    int stateUpdateMonCondition;
    int updateMonConditionData;
    int stateUpdateFieldConditionExtra;
    int updateFieldConditionExtraData;
    int stateBeforeTurn;
    int beforeTurnData;
    int unk_30;
    int unk_34;
    int unk_38;
    int unk_3C;
    int unk_40;
    int unk_44;
    int unk_48;
    int unk_4C;
    int unk_50;
    int unk_54;
    int sendOutState;
    int unk_5C;
    int unk_60;
    int battlerIdAttacker;
    int battlerIdAttackerTemp;
    int battlerIdTarget;
    int battlerIdTargetTemp;
    int battlerIdFainted;
    int battlerIdSwitch;
    int battlerIdSwitchTemp;
    int battlerIdAbility;
    int battlerIdMagicCoat;
    int statChangeType;
    int statChangeParam;
    int statChangeFlag;
    int battlerIdStatChange;
    int unk_98;
    int expMonsCnt; // participants still standing, counted when the foe faints
    int expShareMonsCnt; // Exp. Share holders still standing
    u32 unk_A4[2];
    NarcId scriptNarcId;
    int scriptFileId;
    int scriptSeqNo;
    int unk_B8;
    NarcId unk_BC[4];
    int unk_CC[4];
    int unk_DC[4];
    int executionIndex;
    int unk_F0;
    BattleMessage buffMsg;
    int battlerIdTemp;
    int battlerIdLeechSeedRecv;
    int battlerIdLeechSeeded;
    int moveTemp;
    int itemTemp;
    int abilityTemp;
    int msgTemp;
    int calcTemp;
    int tempData;
    u32 unk_13C[4];
    u32 unk_14C;
    int totalTurns;
    int totalTimesFainted[4];
    int totalDamage[4];
    int meFirstTotal;
    GetterWork *getterWork;
    PokemonStats *prevLevelStats;
    u32 fieldCondition;
    FieldConditionData fieldConditionData;
    u32 fieldSideConditionFlags[2];
    SideConditionData fieldSideConditionData[2];
    TurnData turnData[4];
    SelfTurnData selfTurnData[4];
    MoveFailFlags moveFail[4];
    TrainerAIData trainerAIData;
    u32 *unk_2134;
    u32 unk_2138;
    u32 battleStatus;
    u32 battleStatus2;
    int damage;
    int hitDamage; // amount of damage dealt on hit, ie ignoring overkill damage
    int criticalCnt;
    int criticalMultiplier;
    int movePower;
    int unk_2158;
    int hpCalc;
    int moveType;
    int unk_2164;
    int prizeMoneyValue;
    u32 moveStatusFlag;
    u32 unk_2170;
    u32 unk_2174;
    u32 unk_2178;
    u8 multiHitCount;
    u8 multiHitCountTemp;
    u8 unk_217E;
    u8 beatUpCount;
    u32 unk_2180;
    u32 unk_2184;
    u32 checkMultiHit;
    u32 unk_218C[4];
    u8 selectedMonIndex[4];
    u8 unk_21A0[4];
    u8 unk_21A4[4];
    PlayerActions playerActions[4];
    u8 executionOrder[4]; // accounts for running, items, etc used in battler
                          // slots
    u8 turnOrder[4];      // by pokemon speed, accounting for trick room
    u32 effectiveSpeed[4];
    u8 linkBuffer[4][4][16];
    u8 battleBuffer[4][256];
    // Retail's script buffer, 1600 bytes. It stays here so that everything
    // after it keeps its offset for the code that still reads by offset;
    // the scripts run from battleScriptBuffer at the end.
    int battleScriptBufferRetail[400];
    BattleMon battleMons[4];
    u32 moveNoTemp;
    u32 moveNoCur;
    u32 moveNoPrev;
    u32 moveNoLockedInto[4];
    u16 moveNoProtect[4];
    u16 moveNoHit[4];
    u16 moveNoHitBattler[4];
    u16 moveNoHitType[4];
    u16 moveNoBattlerPrev[4];
    u16 moveNoCopied[4];
    u16 moveNoCopiedHit[4][4];
    u16 moveNoSketch[4];
    u16 unk_30B4[4];
    u16 movePos[4];
    u16 conversion2Move[4];
    u16 conversion2BattlerId[4];
    u16 conversion2Type[4];
    u16 moveNoMetronome[4];
    int unk_30E4[4];
    int unk_30F4[4];
    int unk_3104;
    u8 switchInFlag;
    u8 levelUpMons;
    u16 unk_310A;
    u16 unk_310C[4];
    int flingData;
    int flingScript;
    u8 safariCatchRateStage;
    u8 safariRunAttempts;
    u8 runAttempts;
    u8 battleEndFlag;
    u8 magnitude;
    u8 weatherCheckFlag;
    s16 hpTemp;
    u16 recycleItem[4];
    u8 unk_312C[4][6];
    int unk_3144;
    int queueTimeout;
    u8 unk_314C[4];
    int battlersOnField;
    u32 battleContinueFlag : 1;
    // Whether Ball Fetch has picked up a ball already this battle; it only
    // ever picks up the first that failed.
    u32 ballFetched : 1;
    u32 unused : 30;
    // Keep existing context offsets stable for untouched battle assembly.
    u16 trainerAIAbilities[BATTLER_MAX];
    // Whether the move being used is one that switches its user out, which a
    // battle script sets on its way through rather than being read from the
    // move table.
    int currentMoveSwitchStatus;
    // Which hazards a side has, in the order a Pokemon walking into them meets
    // them, and how far through that order the switch-in script has got.
    u8 entryHazardQueue[2][NUM_HAZARD_IDX];
    u8 hazardQueueTracker;
    // How far a script walking the field one Pokemon at a time has got.
    u8 abilityLoopTracker;
    // Whether the ball now in the air was thrown critically.
    u8 criticalCapture;
    // Whether Neutralizing Gas has said it filled the area and not yet that it
    // wore off: the Pokemon giving it off can leave by fainting, by being
    // switched or by losing the ability, and only the field can tell.
    u8 neutralizingGasOut;
    // What the player's party was holding when the battle began. A single-use
    // item is given back at the end rather than being gone for good.
    u16 itemsToRestore[PARTY_SIZE];
    // Intrepid Sword, Dauntless Shield and Supersweet Syrup fire once per
    // Pokemon per battle rather than once per send-out, so what has already
    // fired is remembered per party slot here and not on the BattleMon, which
    // is rebuilt every time its Pokemon walks back in. By party, not by side:
    // two partners on a side each have one (OnceOnlyEntryAbilityDone).
    u8 onceOnlyEntryAbilityDone[BATTLER_MAX][PARTY_SIZE];
    // The terrain laid over the battle and how many turns it has left. The pair
    // is fieldCondition and fieldConditionData.weatherTurns again, in the one
    // spelling a thing that can only be one of five things at a time wants.
    // Zeroed with the rest of the context when a battle begins, and gone with
    // it when the battle ends.
    u8 terrainOverlayType;
    u8 terrainOverlayTurns;
    // Set when a battler uses a move Psychic Terrain could have refused, and
    // cleared when that battler is loaded. Nothing reads it -- the reference
    // writes this flag in exactly one place and never asks about it again --
    // but the flag is the reference's, so the port keeps it rather than
    // quietly dropping the command that sets it.
    u8 psychicTerrainMoveUsed[BATTLER_MAX];
    // Which one stat Protosynthesis or Quark Drive has raised, as a STAT_*, or
    // zero for none -- STAT_HP is never the answer, so zero is free to mean
    // "not raised". Cleared when the Pokemon is loaded into its slot, so the
    // boost does not follow it out of the battle and back in.
    //
    u8 paradoxBoostedStat[BATTLER_MAX];
    // Whether the stat above was raised by a Booster Energy rather than by the
    // sun or the ground. Two things read it: the ability will not switch on a
    // second time from the weather once the energy has done it, and the
    // command that takes the boost away when the weather or the ground goes
    // leaves an energy's boost alone -- that one lasts as long as the Pokemon
    // is out. Cleared with the stat, when the Pokemon is loaded in.
    u8 boosterEnergyActivated[BATTLER_MAX];
    // Belch is only there to be used once the Pokemon has eaten a Berry, and
    // nothing else in the battle remembers that it did. Written down per party
    // slot, like the entry abilities above, so that a Pokemon which ate its
    // Berry, went out and came back can still belch. It is read by battler,
    // because the one place that reads it has no battle system to ask which
    // party a battler draws from; so the writer tells both battlers that share
    // the party, a Pokemon being free to come back in the other position of
    // a single trainer's pair (RememberBerryEaten).
    u8 berryEaten[BATTLER_MAX][PARTY_SIZE];
    // Which battlers saw hail or snow the last time their forms were checked,
    // a bit each: an Ice Face comes back when the weather begins, or on the
    // way in while it lasts, not on every check it goes on. Cleared when the
    // battler is loaded, as the reference clears its log_hail_for_ice_face.
    u8 iceFaceWeatherSeen;
    // Which battlers' Relic Song has reached a target this move, a bit each:
    // Meloetta changes form only then (hg-engine's relic_song_tracker).
    u8 relicSongTracker;
    // Cud Chew brings a Berry back up at the end of the turn after the one it
    // was eaten in, and eats it again: which Berry, and at the end of which
    // turn. Cleared when the Pokemon is loaded into its slot, so the Berry
    // does not follow it out and back in.
    u16 cudChewBerry[BATTLER_MAX];
    u16 cudChewTurn[BATTLER_MAX];
    // How many times in a row the battler's Protect or one of its family has
    // worked, up to six. hg-engine (d0380a487, include/battle.h) keeps it here
    // rather than in the two bits the BattleMon had, which stop at three, for
    // odds that go down to 1 in 729. Cleared when the battler is loaded.
    u8 protectSuccessTurns[BATTLER_MAX];
    // Dancer: the dance move another Pokemon has just used, the battlers
    // still to copy it (a bit each), who used it and at whom, and whether the
    // move running now is one of the copies. Each copy starts as a move of its
    // own, so none of this is cleared between them.
    u16 danceMove;
    u8 dancersPending;
    u8 danceUser;
    u8 danceTarget;
    u8 dancing;
    // Which battlers' Tera Shell has taken the move now under way, a bit each:
    // a multi-hit move is not very effective on every hit if it was on the
    // first, at full HP. Cleared when the next action begins.
    u8 teraShellResisting;
    // Which battlers Delta Stream's winds have said they shelter from the move
    // now under way, a bit each, so a multi-hit move says it once. Cleared
    // when the next action begins.
    u8 strongWindsWeakened;
    // How many of its own party had fainted when a Supreme Overlord came in,
    // five at most: a tenth more power for each. Counted once, on the way in,
    // and cleared when the Pokemon is loaded into its slot.
    u8 supremeOverlordFallen[BATTLER_MAX];
    // The terrain a Mimicry holder last took its type from, TERRAIN_NONE when
    // it has its own. Cleared when the Pokemon is loaded into its slot.
    u8 mimicryTerrain[BATTLER_MAX];
    // The stages an Opportunist has seen the other side gain and has yet to
    // copy, by stat. Cleared when the Pokemon is loaded into its slot.
    u8 opportunistStages[BATTLER_MAX][NUM_BATTLE_STATS];
    // Whether a battler has used up its held item since the entry abilities
    // were last looked at, for its partner's Symbiosis. Cleared when the
    // Pokemon is loaded into its slot.
    u8 symbiosisPending[BATTLER_MAX];
    // The first of the player's balls that failed to catch this battle, while
    // it waits for a Pokemon with Ball Fetch and empty hands to pick it up.
    u16 ballFetchBall;
    // A Gem is powering the move being used: set where its damage is worked
    // out, spent once the move connects, and kept for every hit and target
    // left in the move (hg-engine's gemBoostingMove). Cleared with the rest
    // of the move's state in BattleContext_Init.
    u8 gemBoostingMove;
    // Which battlers have had a stat lowered during the action being taken, a
    // bit each, for the Eject Pack once the move is over (the reference's
    // anyStatLoweredThisTurn). Cleared as each action is dispatched, and for
    // one battler when a Pokemon is loaded into its slot, so what comes in
    // does not answer for what left.
    u8 statLoweredBattlers;
    // The stages each battler's Mirror Herb is to copy, by stat: what the
    // other side has gained since the herb last looked. Written where a stage
    // goes up, read and emptied the next time the holder's items are asked,
    // and emptied when a Pokemon is loaded into the slot.
    u8 mirrorHerbStages[BATTLER_MAX][NUM_BATTLE_STATS];
    // Which battlers have had a stat raised during the action being taken, a
    // bit each, as statLoweredBattlers has the drops: a Parting Shot whose
    // target's Contrary turned the drops into rises has changed its stats all
    // the same. Cleared with statLoweredBattlers.
    u8 statRaisedBattlers;
    // Which battlers are held by a bind that a Binding Band holder began, a
    // bit each: the band is read when the bind starts, not as each turn's
    // damage is dealt. Written for the target whenever a bind begins
    // (BtlCmd_SetBindingTurns), which is the only way into one.
    u8 bindingBandBinds;
    // What Parental Bond's first strike left to the second -- the side
    // effect ov12_02250490 held back -- as the side-effect flags that ask for
    // it, until the multi-strike loop knows whether the second strike comes;
    // zero when nothing waits. Cleared as each action is dispatched.
    u32 parentalBondDeferred;
    // Echoed Voice: the turns in a row someone has used it, four at most, and
    // whether someone has in this one. A turn it was used in lengthens the
    // run when it ends, and a turn it was not ends the run.
    u8 echoedVoiceTurns;
    u8 echoedVoiceUsed;
    // Round: the battlers that have used it this turn, a bit each. Every
    // Round after the first in a turn has twice the power.
    u8 roundUsers;
    // The last move used this turn and the one before it, by anyone: Fusion
    // Flare and Fusion Bolt double straight after each other. MOVE_NONE when
    // the turn has had none.
    u16 moveUsedLast;
    u16 moveUsedBefore;
    // The turns Wonder Room and Magic Room have left, 0 when they are down.
    u8 wonderRoomTurns;
    u8 magicRoomTurns;
    // Rage Fist: the hits each Pokemon has taken this battle, six at most,
    // by the party slot it was sent out from (Battler_RageFistHits); switching
    // out and fainting keep the count.
    u8 rageFistHits[BATTLER_MAX][PARTY_SIZE];
    // The move table a battle keeps is retail's length and cannot grow, so the
    // added moves are here, where nothing reads by offset. BattleMoveTbl picks
    // the right one.
    MoveConditions moveConditions[BATTLER_MAX];
    MoveTbl addedMoveData[NUM_ADDED_MOVES];
    // hg-engine's SkillSeqWork[650] (d0380a487, include/battle.h), which it
    // moved to the end of the structure and grew for the same reason: its
    // status subscripts, with every immunity the later generations add, are
    // longer than retail's 1600 bytes. The loaders assert a script fits.
    int battleScriptBuffer[BATTLE_SCRIPT_BUFFER_WORDS];
} BattleContext;

typedef struct BattleSystem BattleSystem;

typedef struct BattleHpBar {
    struct {
        u8 script;
    };
    ManagedSprite *boxObj;
    ManagedSprite *arrowObj;
    BattleSystem *battleSystem;
    SysTask *unk10;
    Window unk14;
    u8 battlerId;
    u8 type;
    u8 monId;
    u8 unk27;
    s32 hp;
    s32 maxHp;
    s32 gainedHp;
    s32 hpCalc;
    s32 exp;
    s32 maxExp;
    s32 gainedExp;
    s32 expCalc;
    u8 level;
    u8 unk49;
    u8 unk_4A;
    u8 unk4B;
    u8 unk4C;
    u8 unk4D;
    u8 unk4E;
    u8 unk_4F_0 : 1;
    u8 unk_4F_1 : 1;
    u8 unk_4F_2 : 1;
    u8 unk_4F_3 : 1;
    SysTask *sysTask;
    u16 unk54;
} BattleHpBar;

typedef struct UnkBallData UnkBallData;

typedef struct OpponentData {
    u32 unk0[6];
    ManagedSprite *managedSprite;
    u32 *unk1C;
    Pokepic *pokepic;
    u32 *unk24;
    BattleHpBar hpBar;
    void *unk80;
    u8 unk84[0x4];
    UnkBallData *ballData;
    u8 unk8C[0x108];
    u8 unk194;
    u8 battlerType;
    u8 unk196;
    u8 unk197;
    SysTask *unk198;
    u16 unk19C;
    int unk1A0;
    u32 *unk1A4;
    u8 unk1A8;
    u8 unk1A9[3];
} OpponentData;

typedef struct UnkBattleSystemSub17C {
    ManagedSprite *unk0;
    BattleSystem *battleSystem;
    u8 unk8;
    u8 unk9;
    s16 unkA;
    s16 unkC;
    u16 unused;
} UnkBattleSystemSub17C; // size: 0x10

typedef struct UnkBattleSystemSub1D0 {
    u8 *unk0;
    int unk4;
    int unk8;
    int unkC;
} UnkBattleSystemSub1D0;

typedef struct UnkBattleSystemSub220 {
    int unk0;
    int unk4;
    int unk8;
} UnkBattleSystemSub220;

typedef struct BattleInput BattleInput;

struct BattleSystem {
    u32 *unk0;
    BgConfig *bgConfig;
    Window *window;
    MsgData *msgData;
    u32 *unk10;
    MessageFormat *msgFormat;
    String *msgBuffer;
    u32 unk1C;
    u32 unk20;
    u32 unk24;
    PaletteData *palette;
    u32 battleType;
    BattleContext *ctx;
    OpponentData *opponentData[4];
    int maxBattlers;
    PlayerProfile *playerProfile[4];
    Bag *bag;
    BagCursor *bagCursor;
    Pokedex *pokedex;
    PCStorage *storage;
    Party *trainerParty[4];
    SOUND_CHATOT *chatotVoice[4];
    PokepicManager *pokepicManager;
    u32 *unk8C;
    SpriteSystem *spriteRenderer;
    SpriteManager *gfxHandler;
    u32 *unk98;
    u32 *unk9C;
    u16 trainerId[4];
    u8 trainerGender[4];
    Trainer trainers[4];
    UnkBattleSystemSub17C unk17C[2]; // Battle Background..?
    BattleInput *battleInput;
    u32 *unk1A0[2];
    BattleNumberPrinter *hpNumPrinter;
    BattleNumberPrinter *levelNumPrinter;
    void *msgIcon;
    Options *options;
    u32 *unk1B8;
    void *unk1BC;
    u8 *unk1C0;
    u32 *unk1C4;
    void *unk1C8; // related to animations
    u32 *unk1CC;
    UnkBattleSystemSub1D0 unk1D0[4];
    UnkBattleSystemSub220 unk210;
    GameStats *gameStats;
    u8 *unk220;
    u16 *unk224;
    u8 sendBuffer[0x1000];
    u8 recvBuffer[0x1000];
    u16 unk2228[0x70];
    u16 unk2308[0x70];
    u16 unk23E8;
    u16 unk23EA;
    u16 unk23EC;
    u16 unk23EE;
    u16 unk23F0;
    u16 unk23F2;
    u8 *unk23F4;
    u8 *unk23F8;
    u8 unk23FC;
    u8 unk23FD;
    u8 unk23FE;
    u8 unk240F_0 : 1;
    u8 unk240F_1 : 1;
    u8 unk240E_F : 1;
    u8 criticalHpMusic : 2;
    u8 criticalHpMusicDelay : 3;
    Terrain terrain;
    int backgroundId;
    int location;
    u32 battleSpecial;
    int timezone; // might be timeOfDay? unclear
    int safariBallCnt;
    u8 unk2418[4];
    u32 unk241C;
    u8 battleOutcomeFlag;
    u8 unk2421;
    u16 unk2422;
    int unk2424;
    int unk2428;
    int weather;
    BOOL metBill;
    u32 unk2434;
    int unk2438;
    int unk243C;
    int unk2440;
    u8 unk2442;
    u8 unk2445;
    u16 unk2446;
    u32 rand;
    u32 randTemp;
    u16 unk244C[4];
    u16 unk2454[4];
    u16 unk245C[4];
    int unk2464[4];
    u32 isRecordingPaused : 1;
    u32 unk2474_1 : 1;
    u32 unk2474_2 : 1;
    u32 isFishing : 1;
    u32 unk2474_4 : 28;
    u32 unk2478;
    SysTask *unk247C;
    u8 chatotVoiceParam[4];
    Pokemon *bugContestCaughtMon;
    u8 unk248C[4];
};

struct GetterWork {
    BattleSystem *battleSystem;
    BattleContext *ctx;
    UnkBallData *ballData;
    ManagedSprite *unkC[2];
    TextOBJ *unk14;
    UnkStruct_02021AC8 unk18;
    int captureType;
    int state;
    int ballID;
    int tempData[8];
    void *tempPointers[2];
}; // size: 0x58

typedef BOOL (*BtlCmdFunc)(BattleSystem *, BattleContext *);

typedef struct {
    u16 unk0;
    u16 unk2;
    u16 unk4;
    u16 unk6;
    u16 unk8[4];
    u16 unk10;
} UnkBtlCmdStruct_CPM;

// This is information used for selecting a target on the bottom screen in a
// double battle
typedef struct TargetPokemon {
    u8 selectedMon;
    u8 gender : 2;
    u8 hide : 1;
    u8 unused1_3 : 5;
    u8 status;
    u8 unused3;
    s16 hp;
    u16 hpMax;
} TargetPokemon;

// Information used for selecting an item on the bottom screen
typedef struct BattleItem {
    u16 id;
    u8 page;
    u8 monIndex;
} BattleItem;

typedef struct BattleCursorPosition BattleCursorPosition;

typedef struct UnkStruct_134 {
    s32 unk0;
    enum HeapID heapID;
    s32 unk8;
    s32 unkC;
    int ball;
    s32 unk14;
    s32 unk18;
    SpriteSystem *spriteSystem;
    PaletteData *paletteData;
    BattleSystem *battleSystem;
} UnkStruct_134;

typedef struct UnkStruct_50C {
    BgConfig *bgConfig;
    PaletteData *paletteData;
    PokepicManager *pokepicManager;
    Pokemon *mon;
    BOOL natDexEnabled;
    enum HeapID heapID;
} UnkStruct_50C;

struct UnkBallData { // TODO: Give a better name.
    int unk0;
    int unk4;
    int unk8;
    int unkC;
    int unk10;
    int unk14;
    int unk18;
    int unk1C;
    u8 unk20;
    u8 unk21;
    s8 unk22;
    u8 unk23;
    BOOL unk24;
    int unk28;
    SpriteManager *spriteManager;
    ManagedSprite *managedSprite;
    u8 unk34[0x5C];
    UnkStruct_134 unk90;
    u8 unkB8[0xC];
    int unkC4;
    int unkC8;
    SysTask *unkCC;
    int unkD0;
    int unkD4;
    int unkD8;
    int unkDC;
}; // Size: 0xe0

#endif
