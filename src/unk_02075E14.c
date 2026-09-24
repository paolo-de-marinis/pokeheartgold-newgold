#include "global.h"

#include "constants/game_stats.h"
#include "constants/items.h"

#include "bag.h"
#include "game_stats.h"
#include "gf_3d_vramman.h"
#include "heap.h"
#include "mail.h"
#include "message_format.h"
#include "msgdata.h"
#include "overlay_manager.h"
#include "palette.h"
#include "party.h"
#include "pokedex.h"
#include "pokemon.h"
#include "pokepic.h"
#include "render_window.h"
#include "screen_fade.h"
#include "sound_chatot.h"
#include "sprite_system.h"
#include "system.h"
#include "text.h"
#include "unk_02005D10.h"
#include "unk_020163E0.h"
#include "unk_0203A3B0.h"
#include "unk_020755E8.h"
#include "unk_02088288.h"

// The evolution scene, one state a frame: the old Pokemon's cry and the
// message, the flicker between the two pictures, the new one's cry, the
// species written into the Pokemon, then the moves it learns, the summary
// screen to choose one to forget, and the fade out. B at state 8 cancels.
struct EvolutionTaskData {
    BgConfig *bgConfig;              // 0x00
    Window *window;                  // 0x04
    MsgData *msgData;                // 0x08
    MessageFormat *msgFormat;        // 0x0C
    String *string;                  // 0x10
    PaletteData *palette;            // 0x14
    PokepicManager *pokepicManager;  // 0x18
    Pokepic *oldPokepic;             // 0x1C
    Pokepic *newPokepic;             // 0x20
    Party *party;                    // 0x24
    Pokemon *mon;                    // 0x28
    Options *options;                // 0x2C
    void *unk30;                     // 0x30
    GF3DVramMan *vramMan;            // 0x34
    OverlayManager *overlayManager;  // 0x38
    PokemonSummaryArgs *summaryArgs; // 0x3C
    u8 unk40[4];                     // 0x40
    void *unk44;                     // 0x44
    Pokedex *pokedex;                // 0x48
    Bag *bag;                        // 0x4C
    GameStats *gameStats;            // 0x50
    u8 unk54[4];                     // 0x54
    void *msgIcon;                   // 0x58
    enum HeapID heapID;              // 0x5C
    u16 species;                     // 0x60
    u16 newSpecies;                  // 0x62
    u8 state;                        // 0x64
    u8 textPrinterId;                // 0x65
    u8 timer;                        // 0x66
    u8 done;                         // 0x67
    int learnsetIndex;               // 0x68
    u16 moveToLearn;                 // 0x6C
    u8 moveSlot;                     // 0x6E
    u8 unk6F;
    u8 flickerFlags;                 // 0x70
    u8 flickerStep;                  // 0x71
    u8 unk72;                        // 0x72
    u8 unk73;                        // 0x73
    u8 unk74;                        // 0x74
    u8 unk75;                        // 0x75
    int evolutionCondition;          // 0x78
    u32 unk7C;                       // 0x7C
    u8 form;                         // 0x80
    NARC *narc;                      // 0x84
    u8 unk88;                        // 0x88
    u8 unk89;                        // 0x89
    u8 yesNoState;                   // 0x8A
    u8 yesNoCursor;                  // 0x8B
    Window yesWindow;                // 0x8C
    Window noWindow;                 // 0x9C
    SpriteSystem *spriteSystem;      // 0xAC
    SpriteManager *spriteManager;    // 0xB0
    ManagedSprite *yesNoSprite;      // 0xB4
    BOOL yesNoSpriteActive;          // 0xB8
}; // size: 0xBC

typedef struct UnkStruct_02077604 {
    enum HeapID heapID;
    int unk4;
} UnkStruct_02077604;

extern const u8 _020FFEC0[];

void sub_02075630(EvolutionTaskData *data);
void sub_02075770(EvolutionTaskData *data);
void sub_0207584C(EvolutionTaskData *data, int a1);
int sub_02075A04(EvolutionTaskData *data);
void sub_02075E14(EvolutionTaskData *data);
void sub_02076C90(EvolutionTaskData *data);
void sub_02076E64(EvolutionTaskData *data, BgConfig *bgConfig);
void sub_020771A0(BgConfig *bgConfig);
u8 sub_020772F8(EvolutionTaskData *data, int msgId);
void sub_02077394(EvolutionTaskData *data);
void *sub_02077604(UnkStruct_02077604 *a0);
void sub_02077634(void *a0, int a1);
BOOL sub_02077650(void *a0);
void sub_02077664(void *a0);
BOOL sub_02005D10(u16 seqNo);
int sub_02017068(void *a0, int a1);

void sub_02075E14(EvolutionTaskData *data) {
    PokepicAnimScript animScript4[10];
    PokepicAnimScript animScript10[10];
    PokepicAnimScript animScript42[10];
    UnkStruct_02077604 sp10;
    u16 move;

    if (data->flickerFlags != 0) {
        if (!(data->flickerFlags & 1)) {
            Pokepic_AddAttr(data->oldPokepic, POKEPIC_AFFINEW, -data->flickerStep);
            Pokepic_AddAttr(data->oldPokepic, POKEPIC_AFFINEH, -data->flickerStep);
            Pokepic_AddAttr(data->newPokepic, POKEPIC_AFFINEW, data->flickerStep);
            Pokepic_AddAttr(data->newPokepic, POKEPIC_AFFINEH, data->flickerStep);
            if (Pokepic_GetAttr(data->oldPokepic, POKEPIC_AFFINEW) == 0) {
                data->flickerFlags ^= 1;
            }
        } else {
            Pokepic_AddAttr(data->oldPokepic, POKEPIC_AFFINEW, data->flickerStep);
            Pokepic_AddAttr(data->oldPokepic, POKEPIC_AFFINEH, data->flickerStep);
            Pokepic_AddAttr(data->newPokepic, POKEPIC_AFFINEW, -data->flickerStep);
            Pokepic_AddAttr(data->newPokepic, POKEPIC_AFFINEH, -data->flickerStep);
            if (Pokepic_GetAttr(data->newPokepic, POKEPIC_AFFINEW) == 0) {
                data->flickerFlags ^= 1;
                if (data->flickerStep < 0x40) {
                    data->flickerStep *= 2;
                }
            }
        }
    }

    if ((data->unk7C & 1) && data->state == 8 && (gSystem.newKeys & PAD_BUTTON_B)) {
        PaletteData_BeginPaletteFade(data->palette, 0xF, 0xF3FF, 0, 0, 16, RGB_WHITE);
        data->state = 41;
    }

    switch (data->state) {
    case 0:
        data->timer--;
        if (data->timer == 0) {
            data->state++;
        }
        break;
    case 1:
        SetMasterBrightnessNeutral(PM_LCD_TOP);
        SetMasterBrightnessNeutral(PM_LCD_BOTTOM);
        sub_0201649C(data->msgIcon, 0);
        if (data->unk7C & 2) {
            data->state = 2;
        } else {
            data->state = 4;
        }
        break;
    case 2:
        if (PaletteData_GetSelectedBuffersBitmask(data->palette) == 0) {
            data->textPrinterId = sub_020772F8(data, 0x394);
            data->state++;
        }
        break;
    case 3:
        if (!TextPrinterCheckActive(data->textPrinterId)) {
            data->state = 4;
        }
        break;
    case 4:
        if (PaletteData_GetSelectedBuffersBitmask(data->palette) == 0) {
            sub_0207294C(data->narc, data->unk44, data->oldPokepic, data->species, 2, 0, 0);
            NARC_ReadPokepicAnimScript(data->narc, animScript4, data->species, 1);
            Pokepic_SetAnimScript(data->oldPokepic, animScript4);
            Pokepic_StartAnim(data->oldPokepic, 0);
            PlayCry(data->species, data->form);
            BufferBoxMonNickname(data->msgFormat, 0, Mon_GetBoxMon(data->mon));
            if (data->unk7C & 2) {
                data->textPrinterId = sub_020772F8(data, 0x395);
            } else {
                data->textPrinterId = sub_020772F8(data, 0x393);
            }
            data->state = 5;
        }
        break;
    case 5:
        if (!TextPrinterCheckActive(data->textPrinterId) && !IsCryFinished() && sub_02017068(data->unk44, 0) == 1 && !Pokepic_IsAnimFinished(data->oldPokepic)) {
            sub_0201649C(data->msgIcon, 1);
            sub_02005D10(SEQ_GS_SHINKA);
            data->timer = 20;
            data->state = 6;
        }
        break;
    case 6:
        data->timer--;
        if (data->timer == 0) {
            sp10.heapID = data->heapID;
            sp10.unk4 = 0;
            data->unk30 = sub_02077604(&sp10);
            sub_02077634(data->unk30, 0);
            Pokepic_StartPaletteFade(data->oldPokepic, 0, 16, 4, RGB_WHITE);
            Pokepic_StartPaletteFade(data->newPokepic, 0, 16, 4, RGB_WHITE);
            GF_ASSERT(HeapExp_FndGetTotalFreeSize(data->heapID) > 0x8000);
            PlaySE(SEQ_SE_DP_W025);
            data->timer = 40;
            data->state++;
        }
        break;
    case 7:
        if (data->unk73 < 40) {
            data->unk73 += 2;
            data->unk75 -= 2;
        }
        data->timer--;
        if (data->timer == 0) {
            sub_02077634(data->unk30, 1);
            sub_02077634(data->unk30, 2);
            sub_02077634(data->unk30, 7);
            sub_02077634(data->unk30, 8);
            sub_02077634(data->unk30, 9);
            sub_02077634(data->unk30, 11);
            PlaySE(SEQ_SE_DP_W060C);
            data->flickerFlags = 16;
            data->flickerStep = 8;
            data->state++;
        }
        break;
    case 8:
        if (!sub_02077650(data->unk30)) {
            sub_02077634(data->unk30, 3);
            sub_02077634(data->unk30, 4);
            sub_02077634(data->unk30, 5);
            sub_02077634(data->unk30, 6);
            sub_02077634(data->unk30, 10);
            PaletteData_BeginPaletteFade(data->palette, 0xF, 0xF3FF, 2, 0, 16, RGB_WHITE);
            Pokepic_SetAttr(data->oldPokepic, POKEPIC_AFFINEW, 0);
            Pokepic_SetAttr(data->oldPokepic, POKEPIC_AFFINEH, 0);
            Pokepic_SetAttr(data->newPokepic, POKEPIC_AFFINEW, 0x100);
            Pokepic_SetAttr(data->newPokepic, POKEPIC_AFFINEH, 0x100);
            PlaySE(SEQ_SE_DP_W062);
            data->flickerFlags = 0;
            data->timer = 8;
            data->state++;
        }
        break;
    case 9:
        if (data->unk73 != 0) {
            data->unk73 -= 2;
            data->unk75 += 2;
        }
        if (PaletteData_GetSelectedBuffersBitmask(data->palette) == 0) {
            data->timer--;
            if (data->timer == 0) {
                sub_02077634(data->unk30, 12);
                PaletteData_BeginPaletteFade(data->palette, 0xF, 0xF3FF, 4, 16, 0, RGB_WHITE);
                Pokepic_StartPaletteFadeAll(data->pokepicManager, 16, 0, 3, RGB_WHITE);
                PlaySE(SEQ_SE_DP_W080);
                data->state++;
            }
        }
        break;
    case 10:
        if (PaletteData_GetSelectedBuffersBitmask(data->palette) == 0 && !sub_02077650(data->unk30)) {
            sub_0207294C(data->narc, data->unk44, data->newPokepic, data->newSpecies, 2, 0, 0);
            NARC_ReadPokepicAnimScript(data->narc, animScript10, data->newSpecies, 1);
            Pokepic_SetAnimScript(data->newPokepic, animScript10);
            Pokepic_StartAnim(data->newPokepic, 0);
            PlayCry(data->newSpecies, data->form);
            data->state++;
        }
        break;
    case 11:
        if (!IsCryFinished() && sub_02017068(data->unk44, 0) == 1 && !Pokepic_IsAnimFinished(data->newPokepic)) {
            SetMonData(data->mon, MON_DATA_SPECIES, &data->newSpecies);
            UpdateMonAbility(data->mon);
            CalcMonLevelAndStats(data->mon);
            BufferBoxMonNickname(data->msgFormat, 0, Mon_GetBoxMon(data->mon));
            BufferBoxMonSpeciesName(data->msgFormat, 1, Mon_GetBoxMon(data->mon));
            data->textPrinterId = sub_020772F8(data, 0x396);
            data->timer = 40;
            data->state++;
        }
        break;
    case 12:
        if (!TextPrinterCheckActive(data->textPrinterId)) {
            data->timer--;
            if (data->timer == 0) {
                Pokedex_SetMonCaughtFlag(data->pokedex, data->mon);
                GameStats_Inc(data->gameStats, GAME_STAT_UNIQUE_MONS_CAUGHT);
                GameStats_AddScore(data->gameStats, SCORE_EVENT_REGISTER_SPECIES_CAUGHT);
                if (!GetMonData(data->mon, MON_DATA_HAS_NICKNAME, NULL)) {
                    SetMonData(data->mon, MON_DATA_SPECIES_NAME, NULL);
                }
                data->state++;
            }
        }
        break;
    case 13:
        switch (MonTryLearnMoveOnEvolution(data->mon, &data->learnsetIndex, &move)) {
        case 0:
            data->state = 39;
            break;
        case MOVE_APPEND_KNOWN:
            break;
        case MOVE_APPEND_FULL:
            data->moveToLearn = move;
            data->state = 14;
            break;
        default:
            BufferBoxMonNickname(data->msgFormat, 0, Mon_GetBoxMon(data->mon));
            BufferMoveName(data->msgFormat, 1, move);
            data->textPrinterId = sub_020772F8(data, 4);
            data->timer = 30;
            data->state = 37;
            break;
        }
        break;
    case 14:
        BufferBoxMonNickname(data->msgFormat, 0, Mon_GetBoxMon(data->mon));
        BufferMoveName(data->msgFormat, 1, data->moveToLearn);
        data->textPrinterId = sub_020772F8(data, 0x4A9);
        data->timer = 30;
        data->state++;
        break;
    case 16:
        BufferBoxMonNickname(data->msgFormat, 0, Mon_GetBoxMon(data->mon));
        data->textPrinterId = sub_020772F8(data, 0x4AA);
        data->timer = 30;
        data->state++;
        break;
    case 18:
        data->textPrinterId = sub_020772F8(data, 0x4AB);
        data->timer = 1;
        data->state++;
        break;
    case 15:
    case 17:
    case 19:
    case 26:
    case 28:
    case 30:
    case 33:
        if (!TextPrinterCheckActive(data->textPrinterId)) {
            data->timer--;
            if (data->timer == 0) {
                data->state++;
            }
        }
        break;
    case 20:
        sub_0207584C(data, 1);
        data->state++;
        break;
    case 21:
        switch (sub_02075A04(data)) {
        case 1:
            data->state = 22;
            PaletteData_BeginPaletteFade(data->palette, 0xF, 0xFFFF, 1, 0, 16, RGB_BLACK);
            Pokepic_StartPaletteFadeAll(data->pokepicManager, 0, 16, 0, RGB_BLACK);
            break;
        case 2:
            data->state = 32;
            break;
        }
        break;
    case 22:
        if (PaletteData_GetSelectedBuffersBitmask(data->palette) == 0) {
            sub_0200FBF4(PM_LCD_TOP, RGB_BLACK);
            sub_0200FBF4(PM_LCD_BOTTOM, RGB_BLACK);
            sub_020771A0(data->bgConfig);
            sub_02075770(data);
            Pokepic_SetAttr(data->oldPokepic, POKEPIC_VANISHED, TRUE);
            Pokepic_SetAttr(data->newPokepic, POKEPIC_VANISHED, TRUE);
            data->summaryArgs->party = (Party *)data->mon;
            data->summaryArgs->options = data->options;
            data->summaryArgs->unk11 = 0;
            data->summaryArgs->partySlot = 0;
            data->summaryArgs->partyCount = 1;
            data->summaryArgs->moveToLearn = data->moveToLearn;
            data->summaryArgs->unk12 = 2;
            data->summaryArgs->unk28 = 0;
            data->summaryArgs->menuInputStatePtr = NULL;
            sub_02089D40(data->summaryArgs, _020FFEC0);
            sub_02077394(data);
            data->state++;
        }
        break;
    case 23:
        if (OverlayManager_Run(data->overlayManager)) {
            OverlayManager_Delete(data->overlayManager);
            data->overlayManager = NULL;
            sub_02076E64(data, data->bgConfig);
            sub_02075630(data);
            DrawFrameAndWindow2(data->window, FALSE, 1, 10);
            Pokepic_SetAttr(data->oldPokepic, POKEPIC_VANISHED, FALSE);
            Pokepic_SetAttr(data->newPokepic, POKEPIC_VANISHED, FALSE);
            Pokepic_ScheduleReloadFromNarc(data->oldPokepic);
            Pokepic_ScheduleReloadFromNarc(data->newPokepic);
            PaletteData_BeginPaletteFade(data->palette, 0xF, 0xFFFF, 1, 16, 0, RGB_BLACK);
            Pokepic_StartPaletteFadeAll(data->pokepicManager, 16, 0, 0, RGB_BLACK);
            sub_0203A880();
            data->state++;
        }
        break;
    case 24:
        SetMasterBrightnessNeutral(PM_LCD_TOP);
        SetMasterBrightnessNeutral(PM_LCD_BOTTOM);
        if (PaletteData_GetSelectedBuffersBitmask(data->palette) == 0) {
            if (data->summaryArgs->unk16 == 4) {
                data->state = 32;
            } else {
                data->moveSlot = data->summaryArgs->unk16;
                data->state = 25;
            }
        }
        break;
    case 32:
        BufferMoveName(data->msgFormat, 0, data->moveToLearn);
        data->textPrinterId = sub_020772F8(data, 0x4AD);
        data->timer = 1;
        data->state++;
        break;
    case 34:
        sub_0207584C(data, 0);
        data->state++;
        break;
    case 35:
        switch (sub_02075A04(data)) {
        case 1:
            BufferBoxMonNickname(data->msgFormat, 0, Mon_GetBoxMon(data->mon));
            BufferMoveName(data->msgFormat, 1, data->moveToLearn);
            data->textPrinterId = sub_020772F8(data, 0x4AE);
            data->timer = 30;
            data->state = 36;
            break;
        case 2:
            data->state = 14;
            break;
        }
        break;
    case 36:
        if (!TextPrinterCheckActive(data->textPrinterId)) {
            data->timer--;
            if (data->timer == 0) {
                data->state = 13;
            }
        }
        break;
    case 25:
        data->textPrinterId = sub_020772F8(data, 0x4AF);
        data->timer = 30;
        data->state++;
        break;
    case 27:
        BufferBoxMonNickname(data->msgFormat, 0, Mon_GetBoxMon(data->mon));
        BufferMoveName(data->msgFormat, 1, GetMonData(data->mon, MON_DATA_MOVE1 + data->moveSlot, NULL));
        data->textPrinterId = sub_020772F8(data, 0x4B0);
        data->timer = 30;
        data->state++;
        break;
    case 29:
        data->textPrinterId = sub_020772F8(data, 0x4B1);
        data->timer = 30;
        data->state++;
        break;
    case 31:
        BufferBoxMonNickname(data->msgFormat, 0, Mon_GetBoxMon(data->mon));
        BufferMoveName(data->msgFormat, 1, data->moveToLearn);
        data->textPrinterId = sub_020772F8(data, 0x4B2);
        data->timer = 0;
        SetMonData(data->mon, MON_DATA_MOVE1_PP_UPS + data->moveSlot, &data->timer);
        MonSetMoveInSlot(data->mon, data->moveToLearn, data->moveSlot);
        data->timer = 30;
        data->state = 37;
        break;
    case 37:
        if (!TextPrinterCheckActive(data->textPrinterId)) {
            data->state++;
        }
        break;
    case 38:
        if (!IsFanfarePlaying()) {
            data->timer--;
            if (data->timer == 0) {
                data->state = 13;
            }
        }
        break;
    case 39:
        PaletteData_BeginPaletteFade(data->palette, 0xF, 0xFFFF, 1, 0, 16, RGB_BLACK);
        Pokepic_StartPaletteFadeAll(data->pokepicManager, 0, 16, 0, RGB_BLACK);
        data->state++;
        break;
    case 40:
        if (PaletteData_GetSelectedBuffersBitmask(data->palette) == 0) {
            sub_02077664(data->unk30);
            sub_02076C90(data);
            data->done = TRUE;
        }
        break;
    case 41:
        if (PaletteData_GetSelectedBuffersBitmask(data->palette) == 0) {
            Pokepic_SetAttr(data->oldPokepic, POKEPIC_AFFINEW, 0x100);
            Pokepic_SetAttr(data->oldPokepic, POKEPIC_AFFINEH, 0x100);
            Pokepic_SetAttr(data->newPokepic, POKEPIC_AFFINEW, 0);
            Pokepic_SetAttr(data->newPokepic, POKEPIC_AFFINEH, 0);
            Pokepic_SetAttr(data->newPokepic, POKEPIC_VANISHED, TRUE);
            PaletteData_BeginPaletteFade(data->palette, 0xF, 0xF3FF, 0, 16, 0, RGB_WHITE);
            Pokepic_StartPaletteFadeAll(data->pokepicManager, 16, 0, 0, RGB_WHITE);
            data->unk72 = 0;
            data->unk73 = 0;
            data->unk74 = 0xFF;
            data->unk75 = 0xA0;
            data->flickerFlags = 0;
            StopBGM(SEQ_GS_SHINKA, 0);
            sub_02077664(data->unk30);
            data->state++;
        }
        break;
    case 42:
        if (PaletteData_GetSelectedBuffersBitmask(data->palette) == 0) {
            sub_0207294C(data->narc, data->unk44, data->oldPokepic, data->species, 2, 0, 0);
            NARC_ReadPokepicAnimScript(data->narc, animScript42, data->species, 1);
            Pokepic_SetAnimScript(data->oldPokepic, animScript42);
            Pokepic_StartAnim(data->oldPokepic, 0);
            PlayCry(data->species, data->form);
            data->state++;
        }
        break;
    case 43:
        if (!IsCryFinished() && sub_02017068(data->unk44, 0) == 1 && !Pokepic_IsAnimFinished(data->oldPokepic)) {
            BufferBoxMonNickname(data->msgFormat, 0, Mon_GetBoxMon(data->mon));
            data->textPrinterId = sub_020772F8(data, 0x397);
            data->timer = 20;
            data->state++;
        }
        break;
    case 44:
        if (!TextPrinterCheckActive(data->textPrinterId)) {
            data->timer--;
            if (data->timer == 0) {
                PaletteData_BeginPaletteFade(data->palette, 0xF, 0xFFFF, 1, 0, 16, RGB_BLACK);
                Pokepic_StartPaletteFadeAll(data->pokepicManager, 0, 16, 0, RGB_BLACK);
                data->state++;
            }
        }
        break;
    case 45:
        if (PaletteData_GetSelectedBuffersBitmask(data->palette) == 0) {
            data->done = TRUE;
        }
        break;
    }
}

// What an evolution leaves behind once the species is written: the item it
// was holding when it evolved by holding one, and Ninjask's Shedinja in the
// next free slot, if a Poke Ball is there to put it in -- a copy of the
// Pokemon with the species, the ball and a fresh record.
void sub_02076C90(EvolutionTaskData *data) {
    int i;
    u32 value;
    Pokemon *shedinja;
    Mail *mail;
    u8 ballCapsule[0x18];

    switch (data->evolutionCondition) {
    case EVO_LEVEL_NINJASK:
    case EVO_LEVEL_SHEDINJA:
        if (Bag_GetQuantity(data->bag, ITEM_POKE_BALL, data->heapID) == 0 || Party_GetCount(data->party) >= Party_GetMaxCount(data->party)) {
            break;
        }
        shedinja = AllocMonZeroed(data->heapID);
        CopyPokemonToPokemon(data->mon, shedinja);
        value = SPECIES_SHEDINJA;
        SetMonData(shedinja, MON_DATA_SPECIES, &value);
        value = ITEM_POKE_BALL;
        SetMonData(shedinja, MON_DATA_POKEBALL, &value);
        value = ITEM_NONE;
        SetMonData(shedinja, MON_DATA_HELD_ITEM, &value);
        SetMonData(shedinja, MON_DATA_MARKINGS, &value);
        for (i = MON_DATA_SINNOH_CHAMP_RIBBON; i < MON_DATA_MOVE1; i++) {
            SetMonData(shedinja, i, &value);
        }
        for (i = MON_DATA_COOL_RIBBON; i < MON_DATA_FATEFUL_ENCOUNTER; i++) {
            SetMonData(shedinja, i, &value);
        }
        for (i = MON_DATA_SUPER_COOL_RIBBON; i < MON_DATA_OT_NAME; i++) {
            SetMonData(shedinja, i, &value);
        }
        SetMonData(shedinja, MON_DATA_SHINY_LEAF_A, &value);
        SetMonData(shedinja, MON_DATA_SHINY_LEAF_B, &value);
        SetMonData(shedinja, MON_DATA_SHINY_LEAF_C, &value);
        SetMonData(shedinja, MON_DATA_SHINY_LEAF_D, &value);
        SetMonData(shedinja, MON_DATA_SHINY_LEAF_E, &value);
        SetMonData(shedinja, MON_DATA_SHINY_LEAF_CROWN, &value);
        SetMonData(shedinja, MON_DATA_MOOD, &value);
        SetMonData(shedinja, MON_DATA_SPECIES_NAME, NULL);
        SetMonData(shedinja, MON_DATA_HAS_NICKNAME, &value);
        SetMonData(shedinja, MON_DATA_STATUS, &value);
        mail = Mail_New(data->heapID);
        SetMonData(shedinja, MON_DATA_MAIL, mail);
        Heap_Free(mail);
        SetMonData(shedinja, MON_DATA_BALL_CAPSULE_ID, &value);
        MI_CpuClearFast(ballCapsule, sizeof(ballCapsule));
        SetMonData(shedinja, MON_DATA_BALL_CAPSULE, ballCapsule);
        UpdateMonAbility(shedinja);
        CalcMonLevelAndStats(shedinja);
        Party_AddMon(data->party, shedinja);
        Pokedex_SetMonCaughtFlag(data->pokedex, shedinja);
        GameStats_Inc(data->gameStats, GAME_STAT_UNIQUE_MONS_CAUGHT);
        GameStats_AddScore(data->gameStats, SCORE_EVENT_REGISTER_SPECIES_CAUGHT);
        Heap_Free(shedinja);
        Bag_TakeItem(data->bag, ITEM_POKE_BALL, 1, data->heapID);
        break;
    case EVO_TRADE_ITEM:
    case EVO_ITEM_DAY:
    case EVO_ITEM_NIGHT:
    case EVO_ITEM_ICE_PATH: // Milcery's Berry is used up, as a held item is here
        i = ITEM_NONE;
        SetMonData(data->mon, MON_DATA_HELD_ITEM, &i);
        break;
    case EVO_FORM_ARGUMENT:
        // Gimmighoul spends the 999 Gimmighoul Coins it evolved on, as in the
        // games ("consuming the coins in the process", Bulbapedia).
        if (data->species == SPECIES_GIMMIGHOUL) {
            Bag_TakeItem(data->bag, ITEM_GIMMIGHOUL_COIN, GIMMIGHOUL_EVOLUTION_COINS, data->heapID);
        }
        break;
    }
}
