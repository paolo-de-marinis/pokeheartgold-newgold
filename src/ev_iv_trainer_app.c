#include "global.h"

#include "constants/balls.h"
#include "constants/items.h"
#include "constants/sndseq.h"

#include "msgdata/msg.naix"
#include "msgdata/msg/msg_0829.h"

#include "bag.h"
#include "bg_window.h"
#include "ev_iv_trainer.h"
#include "filesystem.h"
#include "font.h"
#include "gf_gfx_loader.h"
#include "gf_gfx_planes.h"
#include "heap.h"
#include "mail.h"
#include "message_format.h"
#include "msgdata.h"
#include "options.h"
#include "party.h"
#include "party_menu.h"
#include "player_data.h"
#include "pokemon.h"
#include "render_text.h"
#include "render_window.h"
#include "screen_fade.h"
#include "system.h"
#include "text.h"
#include "touchscreen.h"
#include "unk_02005D10.h"
#include "unk_02013FDC.h"
#include "yes_no_prompt.h"

#include "data/ev_iv_trainer_sets.h"

#ifdef NEWGOLD_DIAG
#include "msgdata/msg/msg_0550_T21.h"
#endif

// The EV/IV trainer. It is one app that runs the game's own party menu for
// the choice of a Pokemon ("Train which Pokemon?", no Egg) and, on a choice,
// its own two screens, in the summary screen's look: the summary's page
// plates (a/1/6/2, the EV page on the blue, Hyper Training on the red, the
// sets on the orange), its arrow buttons and its red frame, the party menu's
// blue buttons. The top screen is for looking -- the table of the six stats,
// the Pokemon as the summary shows it -- and the bottom one is touched, or
// driven with the buttons. Nothing is written until the player confirms;
// then back to the party menu, for another Pokemon or out to the dialogue.
//
// Each screen draws on one 256-colour window over the plate, so the plate's
// own colours (slot 0 to 4), the summary's text colours (slot 13) and the
// colours below can all be used in one place.

#define TRAINER_HEAP_SIZE 0x40000

enum TrainerPage {
    PAGE_EV,
    PAGE_IV,
    PAGE_SETS,
    PAGE_COUNT,
};

#ifdef NEWGOLD_DIAG
// New Gold, in the diagnostics build only: konefr's developer vendor
// (b23dc7360), his password and his Rare Candies at 1 each, on a page of its
// own that SELECT reaches after the Sets. Its texts are his, in Cherrygrove
// City's bank; his EV presets are the Sets page's.
#define PAGE_DEV      PAGE_COUNT
#define TRAINER_PAGES (PAGE_COUNT + 1)
#define TAB_LIT(app)  ((app)->page == PAGE_DEV ? PAGE_SETS : (app)->page)
#else
#define TRAINER_PAGES PAGE_COUNT
#define TAB_LIT(app)  ((app)->page)
#endif

enum TrainerState {
    STATE_CHOOSE,      // the party menu
    STATE_OPEN,        // the screens drawn, fading in
    STATE_INPUT,
    STATE_MESSAGE,     // a line printed in the message window
    STATE_YESNO,
    STATE_WAIT_BUTTON, // a line read, then on
    STATE_CLOSE,       // fading out, then the party menu again or out
    STATE_EXIT,
};

// What the message window is asking or saying, and what follows it.
enum TrainerQuestion {
    ASK_EVS,
    ASK_HYPER,
    ASK_DISCARD,
    SAY_DONE,
    SAY_NO_MONEY,
    SAY_NO_CAP,
};

// The summary's palette (a/1/6/2 member 0) as the window reads it: the plate
// colours of slot 0 and 2, the text colours of slot 13, and in slot 12 this
// app's own, which the summary's palette leaves empty.
#define COL_OUTLINE   5
#define COL_SLATE     4
#define COL_LABEL     3
#define COL_LABEL_ALT (2 * 16 + 2)
#define COL_SEPARATOR 13
#define COL_VALUE_ALT 14
#define COL_VALUE     15
#define TEXT_SLOT     13 // a window's palette is a slot: the glyphs' colours are taken from it
#define PLTT_TEXT     (TEXT_SLOT * 16)
#define PLTT_OWN      0xC0
#define COL_BAR       (PLTT_OWN + 1)
#define COL_BAR_SHINE (PLTT_OWN + 2)
#define COL_MAX       (PLTT_OWN + 3)
#define COL_MAX_SHINE (PLTT_OWN + 4)
#define COL_TRACK     (PLTT_OWN + 5)
#define COL_TRACK_TOP (PLTT_OWN + 6)
#define COL_BAR_RIM   (PLTT_OWN + 7)
#define COL_CURSOR    (PLTT_OWN + 8)
#define COL_MARK_OFF  (PLTT_OWN + 9)
#define COL_MARK_ON   (PLTT_OWN + 10)
#define PLTT_ARROWS   0x70 // slot 7: the summary's arrow buttons, a/1/6/2 member 3
#define PLTT_BUTTONS  0x80 // slot 8: the party menu's blue buttons, plist_gra member 8
#define PLTT_MON      0x90 // slot 9: the Pokemon's own
#define PLTT_BALL     0xA0 // slot 10: the ball it was caught in

// The summary's palette for each ball's icon, an offset from a/1/6/2's member
// 49 (sub_0208B48C, asm/unk_0208B1AC.s).
extern const u8 _02104C68[];

#define TEXT_DARK   MAKE_TEXT_COLOR(1, 2, 0)
#define TEXT_BLUE   MAKE_TEXT_COLOR(3, 4, 0)
#define TEXT_RED    MAKE_TEXT_COLOR(5, 6, 0)
#define TEXT_WHITE  MAKE_TEXT_COLOR(14, 15, 0)
#define TEXT_BUTTON MAKE_TEXT_COLOR(14, 9, 0)

#define TRAINER_FONT_SMALL 5 // graphic/font member 10, the narrow one
#define SCRATCH_WIDTH      24 // tiles: the widest string printed
#define SCRATCH_HEIGHT     2

static const u16 sOwnColours[16] = {
    RGB(0, 0, 0),
    RGB(31, 25, 5),  // the bar
    RGB(31, 29, 16), // its top row
    RGB(30, 16, 5),  // a stat at 252: the bar turns orange
    RGB(31, 23, 12),
    RGB(31, 30, 28), // the empty track
    RGB(25, 22, 16),
    RGB(9, 9, 9),    // the bar's rim
    RGB(31, 3, 3),   // the summary's red frame
    RGB(23, 23, 20), // a marking not set, and one set: the summary's (a/1/6/2 member 61)
    RGB(9, 8, 7),
};
static const u16 sButtonTextShadow = RGB(5, 5, 5);

// The summary's order of the stats; the record's (MON_DATA_*_EV) keeps
// Speed before Sp. Atk and Sp. Def.
static const u8 sDisplayStat[NUM_STATS] = { STAT_HP, STAT_ATK, STAT_DEF, STAT_SPATK, STAT_SPDEF, STAT_SPEED };

static const u16 sPagePlates[TRAINER_PAGES][2] = {
    // top, bottom
    { 13, 12 },
    { 19, 17 },
    { 10, 9 },
#ifdef NEWGOLD_DIAG
    // The developer page, which SELECT reaches from the Sets, keeps their
    // plates and their tab lit (TAB_LIT).
    { 10, 9 },
#endif
};
static const u16 sPageTitles[PAGE_COUNT] = { msg_0829_00001, msg_0829_00002, msg_0829_00003 };
static const u16 sTabLabels[PAGE_COUNT] = { msg_0829_00005, msg_0829_00004, msg_0829_00028 };
static const u16 sJudgeNames[] = {
    [JUDGE_NO_GOOD] = msg_0829_00030,
    [JUDGE_DECENT] = msg_0829_00031,
    [JUDGE_PRETTY_GOOD] = msg_0829_00032,
    [JUDGE_VERY_GOOD] = msg_0829_00033,
    [JUDGE_FANTASTIC] = msg_0829_00034,
    [JUDGE_BEST] = msg_0829_00035,
};

// The bottom screen, in its own pixels.
#define ROWS_LEFT    4
#define ROWS_RIGHT   143
#define ROWS_TOP     4
#define ROW_HEIGHT   20
#define SET_HEIGHT   24
#define SETS_SHOWN   6
#define TAB_TOP      166
#define TAB_BOTTOM   188
#define ARROW_W      32
#define ARROW_H      48

enum TrainerHitbox {
    HIT_ROW0,
    HIT_ROW5 = HIT_ROW0 + 5,
    HIT_TAB0,
    HIT_TAB2 = HIT_TAB0 + 2,
    HIT_DONE,
    HIT_DOWN,   // EV: take one; Sets: the next set
    HIT_UP,     // EV: add one; Sets: the set before
    HIT_BUTTON1,
    HIT_BUTTON2,
    HIT_NONE = -1,
};

static const TouchscreenHitbox sTabHitboxes[] = {
    { .rect = { TAB_TOP, TAB_BOTTOM, 4, 43 } },
    { .rect = { TAB_TOP, TAB_BOTTOM, 51, 92 } },
    { .rect = { TAB_TOP, TAB_BOTTOM, 100, 139 } },
    { .rect = { TAB_TOP, TAB_BOTTOM, 194, 250 } },
    { .rect = { TOUCHSCREEN_RECTLIST_END } },
};

// Per page: the two arrows and the two blue buttons, where they are drawn.
typedef struct PageControls {
    u8 downX, downY, upX, upY;
    u8 button1X, button1Y, button1Small;
    u8 button2X, button2Y, button2Small;
    u16 button1, button2;
} PageControls;

static const PageControls sPageControls[PAGE_COUNT] = {
    [PAGE_EV] = { 152, 50, 212, 50, 170, 110, TRUE, 170, 128, TRUE, msg_0829_00025, msg_0829_00026 },
    [PAGE_IV] = { 0, 0, 0, 0, 170, 66, FALSE, 170, 140, TRUE, msg_0829_00039, msg_0829_00040 },
    [PAGE_SETS] = { 182, 98, 182, 30, 170, 146, TRUE, 0, 0, FALSE, msg_0829_00043, 0 },
};

#define BUTTON_W       56
#define BUTTON_H_BIG   32
#define BUTTON_H_SMALL 16

typedef struct PlateLayer {
    void *charRaw;
    NNSG2dCharacterData *chars;
    u8 layer;
} PlateLayer;

typedef struct Cells {
    void *bankRaw;
    NNSG2dCellDataBank *bank;
    void *charRaw;
    NNSG2dCharacterData *chars;
} Cells;

typedef struct EvIvTrainer {
    enum HeapID heapID;
    EvIvTrainerArgs *args;
    SaveData *saveData;
    Party *party;
    Bag *bag;
    PlayerProfile *profile;
    Options *options;
    int state;
    int substate;
    int trainedCount;

    OverlayManager *partyMenu;
    PartyMenuArgs *partyArgs;
    u8 slot;
    BOOL leaving;

    // The Pokemon: as it is, and what the player has set so far.
    Pokemon *mon;
    Pokemon *preview;
    u16 species;
    u8 level;
    u8 nature;
    u8 ivs[NUM_STATS];
    u8 evs[NUM_STATS];
    u8 newEvs[NUM_STATS];
    u16 stats[NUM_STATS];
    u16 newStats[NUM_STATS];
    u32 trained;    // MON_DATA_UNUSED_114 as it is
    u32 newTrained; // the stats Hyper Training would add
    BOOL gold;      // and they come from a Gold Bottle Cap
    BOOL topChanged;
    u16 caps;
    u16 goldCaps;

    u8 page;
    u8 row;
    u8 set;
    u8 setTop;
    u8 setCount;
    s8 held;        // the hitbox held down, for the arrows' repeat
    u8 heldFrames;
    s8 pressed;     // the arrow drawn pressed
    u8 question;
    u8 printer;

    BgConfig *bgConfig;
    Window top;
    Window bottom;
    Window message;
    Window scratch; // a 16-colour window strings are printed in, then drawn from
    BOOL graphicsUp;
    PlateLayer plates[2];
    Cells arrows;
    Cells buttons;
    void *digitsRaw;
    NNSG2dCharacterData *digits;
    void *ballRaw;
    NNSG2dCharacterData *ball;
    u8 markTiles[6][2 * TILE_SIZE_4BPP]; // each marking's two tiles: not set, set
    u8 *monTiles;
    MsgData *msgData;
    MsgData *setNames;
    MessageFormat *msgFormat;
    String *string;
    String *expanded;
    YesNoPrompt *yesNo;
#ifdef NEWGOLD_DIAG
    MsgData *devMsg;  // bank 550, konefr's vendor's lines
    u8 devDigits[4];
    u8 devCursor;     // the digit, then the shop's row
    BOOL devOpen;     // the password was right
    u16 devLine;      // what the vendor said last, 0 for nothing
#endif
} EvIvTrainer;

static void Trainer_StartPartyMenu(EvIvTrainer *app);
static BOOL Trainer_RunPartyMenu(EvIvTrainer *app);
static void Trainer_ReadMon(EvIvTrainer *app);
static void Trainer_UpdatePreview(EvIvTrainer *app);
static void Trainer_OpenScreens(EvIvTrainer *app);
static void Trainer_CloseScreens(EvIvTrainer *app);
static void Trainer_DrawTop(EvIvTrainer *app);
static void Trainer_DrawBottom(EvIvTrainer *app);
static void Trainer_HandleInput(EvIvTrainer *app);
static void Trainer_Ask(EvIvTrainer *app, u8 question);
static void Trainer_Answered(EvIvTrainer *app, BOOL yes);
static void Trainer_Apply(EvIvTrainer *app);

// ---- the rules on the Pokemon being trained ----------------------------------------------------

static BOOL Trainer_EvsChanged(EvIvTrainer *app) {
    return memcmp(app->evs, app->newEvs, sizeof(app->evs)) != 0;
}

static BOOL Trainer_HasChanges(EvIvTrainer *app) {
    return Trainer_EvsChanged(app) || app->newTrained != 0;
}

static int Trainer_PendingCaps(EvIvTrainer *app) {
    int n = 0;
    int stat;

    if (app->gold) {
        return 0;
    }
    for (stat = 0; stat < NUM_STATS; stat++) {
        if (app->newTrained & MON_HYPER_TRAINED_BIT(stat)) {
            n++;
        }
    }
    return n;
}

static BOOL Trainer_CanTrain(EvIvTrainer *app, int stat) {
    return EvIvTrainer_CanHyperTrain(app->level, app->ivs[stat], app->trained, stat);
}

static void Trainer_SetEv(EvIvTrainer *app, int stat, int value) {
    int most = app->newEvs[stat] + EvIvTrainer_EvRoom(app->newEvs, stat);

    if (value > most) {
        value = most;
    }
    if (value < 0) {
        value = 0;
    }
    if (value == app->newEvs[stat]) {
        return;
    }
    app->newEvs[stat] = value;
    PlaySE(SEQ_SE_DP_SELECT);
    Trainer_UpdatePreview(app);
}

// The EVs the top screen previews: on the Sets page the set the cursor is on.
static const u8 *Trainer_ShownEvs(EvIvTrainer *app) {
    if (app->page == PAGE_SETS && app->setCount != 0) {
        return sEvIvTrainerSets[app->set].evs;
    }
    return app->newEvs;
}

static void Trainer_UpdatePreview(EvIvTrainer *app) {
    const u8 *evs = Trainer_ShownEvs(app);
    // The copy's other bits stay: a Mint's nature is in this field too.
    u16 flags = (u16)(GetMonData(app->mon, MON_DATA_UNUSED_114, NULL) | app->newTrained);
    int stat;

    CopyPokemonToPokemon(app->mon, app->preview);
    for (stat = 0; stat < NUM_STATS; stat++) {
        SetMonData(app->preview, MON_DATA_HP_EV + stat, &evs[stat]);
    }
    SetMonData(app->preview, MON_DATA_UNUSED_114, &flags);
    CalcMonStats(app->preview);
    for (stat = 0; stat < NUM_STATS; stat++) {
        app->newStats[stat] = GetMonData(app->preview, stat == STAT_HP ? MON_DATA_MAX_HP : MON_DATA_ATK + stat - 1, NULL);
    }
    app->topChanged = TRUE;
}

static void Trainer_ReadMon(EvIvTrainer *app) {
    int stat;

    app->mon = Party_GetMonByIndex(app->party, app->slot);
    app->species = GetMonData(app->mon, MON_DATA_SPECIES, NULL);
    app->level = GetMonData(app->mon, MON_DATA_LEVEL, NULL);
    app->nature = GetMonNatureAfterMint(app->mon);
    app->trained = GetMonData(app->mon, MON_DATA_UNUSED_114, NULL) & MON_HYPER_TRAINED_ALL;
    for (stat = 0; stat < NUM_STATS; stat++) {
        app->ivs[stat] = GetMonData(app->mon, MON_DATA_HP_IV + stat, NULL);
        app->evs[stat] = GetMonData(app->mon, MON_DATA_HP_EV + stat, NULL);
        app->newEvs[stat] = app->evs[stat];
        app->stats[stat] = GetMonData(app->mon, stat == STAT_HP ? MON_DATA_MAX_HP : MON_DATA_ATK + stat - 1, NULL);
    }
    app->newTrained = 0;
    app->gold = FALSE;
    app->caps = Bag_GetQuantity(app->bag, ITEM_BOTTLE_CAP, app->heapID);
    app->goldCaps = Bag_GetQuantity(app->bag, ITEM_GOLD_BOTTLE_CAP, app->heapID);
    app->held = HIT_NONE;
    app->pressed = HIT_NONE;
    Trainer_UpdatePreview(app);
}

static void Trainer_Apply(EvIvTrainer *app) {
    u32 fee = EvIvTrainer_Fee(app->evs, app->newEvs);
    u16 flags;
    int stat;

    for (stat = 0; stat < NUM_STATS; stat++) {
        SetMonData(app->mon, MON_DATA_HP_EV + stat, &app->newEvs[stat]);
    }
    if (app->newTrained != 0) {
        flags = (u16)(GetMonData(app->mon, MON_DATA_UNUSED_114, NULL) | app->newTrained);
        SetMonData(app->mon, MON_DATA_UNUSED_114, &flags);
        if (app->gold) {
            Bag_TakeItem(app->bag, ITEM_GOLD_BOTTLE_CAP, 1, app->heapID);
        } else {
            Bag_TakeItem(app->bag, ITEM_BOTTLE_CAP, Trainer_PendingCaps(app), app->heapID);
        }
    }
    CalcMonStats(app->mon);
    PlayerProfile_SubMoney(app->profile, fee);
    app->trainedCount++;
}

// ---- drawing ---------------------------------------------------------------------------------

// A filled rectangle, x1 and y1 included. Written here four pixels at a time
// where a tile's row allows: FillWindowPixelRect's pixel at a time took half
// of a page's redraw, and an arrow held down redraws a page every few frames.
static void Rect(Window *window, int x0, int y0, int x1, int y1, u8 colour) {
    u32 four = colour * 0x01010101;
    int x, y;

    for (y = y0; y <= y1; y++) {
        u8 *row = (u8 *)window->pixelBuffer + (y / 8) * window->width * TILE_SIZE_8BPP + (y % 8) * 8;
        for (x = x0; x <= x1;) {
            u8 *pixel = row + (x / 8) * TILE_SIZE_8BPP + x % 8;
            if ((x & 3) == 0 && x + 3 <= x1) {
                *(u32 *)pixel = four;
                x += 4;
            } else {
                *pixel = colour;
                x++;
            }
        }
    }
}

// A panel the summary's way: a dark rim two pixels wide.
static void Panel(Window *window, int x0, int y0, int x1, int y1, u8 fill) {
    Rect(window, x0, y0, x1, y1, COL_OUTLINE);
    Rect(window, x0 + 2, y0 + 2, x1 - 2, y1 - 2, fill);
}

static void Frame(Window *window, int x0, int y0, int x1, int y1) {
    Rect(window, x0, y0, x1, y0 + 1, COL_CURSOR);
    Rect(window, x0, y1 - 1, x1, y1, COL_CURSOR);
    Rect(window, x0, y0, x0 + 1, y1, COL_CURSOR);
    Rect(window, x1 - 1, y0, x1, y1, COL_CURSOR);
}

// A bar as the summary's HP bar is drawn: a dark rim, a cream track with a
// tan top row, filled from the left; full, it turns orange.
static void Bar(Window *window, int x0, int y, int w, int value, int most) {
    int n = (value * w + most / 2) / most;
    BOOL full = value >= most;

    Rect(window, x0 - 1, y - 1, x0 + w, y + 3, COL_BAR_RIM);
    Rect(window, x0, y, x0 + w - 1, y + 2, COL_TRACK);
    Rect(window, x0, y, x0 + w - 1, y, COL_TRACK_TOP);
    if (n > 0) {
        Rect(window, x0, y, x0 + n - 1, y + 2, full ? COL_MAX : COL_BAR);
        Rect(window, x0, y, x0 + n - 1, y, full ? COL_MAX_SHINE : COL_BAR_SHINE);
    }
}

static inline u8 *WindowPixel(Window *window, int x, int y) {
    return (u8 *)window->pixelBuffer + ((y / 8) * window->width + x / 8) * TILE_SIZE_8BPP + (y % 8) * 8 + x % 8;
}

// 4bpp tiles drawn into the 256-colour window, tw by th of them in rows:
// colour v becomes base + v, and 0 lets what is under it show.
static void BlitTilesFlipped(Window *window, const u8 *tiles, int tw, int th, int x, int y, u8 base, BOOL hflip, BOOL vflip) {
    int w = tw * 8;
    int h = th * 8;
    int px, py;

    for (py = 0; py < h; py++) {
        for (px = 0; px < w; px++) {
            int sx = hflip ? w - 1 - px : px;
            int sy = vflip ? h - 1 - py : py;
            const u8 *tile = tiles + ((sy / 8) * tw + sx / 8) * TILE_SIZE_4BPP;
            u8 v = (tile[(sy % 8) * 4 + (sx % 8) / 2] >> ((sx & 1) * 4)) & 0xF;
            int dx = x + px;
            int dy = y + py;

            if (v != 0 && dx >= 0 && dy >= 0 && dx < window->width * 8 && dy < window->height * 8) {
                *WindowPixel(window, dx, dy) = base + v;
            }
        }
    }
}

// The same for the first `columns` tile columns of a block tw tiles wide,
// unflipped: a printed string.
// Two source pixels a byte, and a byte with neither drawn is skipped: a
// string is mostly see-through, and an arrow held down redraws a page every
// few frames.
static void BlitTiles(Window *window, const u8 *tiles, int tw, int th, int columns, int x, int y, u8 base) {
    int width = window->width * 8;
    int height = window->height * 8;
    int tx, ty, px, py;

    for (ty = 0; ty < th; ty++) {
        for (tx = 0; tx < columns && tx < tw; tx++) {
            const u8 *row = tiles + (ty * tw + tx) * TILE_SIZE_4BPP;
            for (py = 0; py < 8; py++, row += 4) {
                int dy = y + ty * 8 + py;
                if (dy < 0 || dy >= height) {
                    continue;
                }
                for (px = 0; px < 8; px += 2) {
                    u8 pair = row[px / 2];
                    int dx = x + tx * 8 + px;
                    if (pair == 0) {
                        continue;
                    }
                    if ((pair & 0xF) != 0 && dx >= 0 && dx < width) {
                        *WindowPixel(window, dx, dy) = base + (pair & 0xF);
                    }
                    if ((pair >> 4) != 0 && dx + 1 >= 0 && dx + 1 < width) {
                        *WindowPixel(window, dx + 1, dy) = base + (pair >> 4);
                    }
                }
            }
        }
    }
}

// A cell of an NCER drawn with its top left corner at x, y: each of its
// objects is tiles in a row from its character name (1D mapping).
static void DrawCell(Window *window, Cells *cells, int index, int x, int y, u8 base) {
    static const u8 sObjSizes[3][4][2] = {
        { { 8, 8 }, { 16, 16 }, { 32, 32 }, { 64, 64 } },
        { { 16, 8 }, { 32, 8 }, { 32, 16 }, { 64, 32 } },
        { { 8, 16 }, { 8, 32 }, { 16, 32 }, { 32, 64 } },
    };
    u32 stride = (cells->bank->cellBankAttr & 1) ? 16 : 8; // a cell with its bounding rectangle
    const NNSG2dCellData *cell = (const NNSG2dCellData *)((const u8 *)cells->bank->pCellDataArrayHead + index * stride);
    int shift = (cells->chars->mapingType >> 20) & 3;
    int left = 0x7FFF;
    int top = 0x7FFF;
    int i;

    for (i = 0; i < cell->numOAMAttrs; i++) {
        const NNSG2dCellOAMAttrData *obj = &cell->pOamAttrArray[i];
        int ox = obj->attr1 & 0x1FF;
        int oy = obj->attr0 & 0xFF;
        if (ox >= 256) {
            ox -= 512;
        }
        if (oy >= 128) {
            oy -= 256;
        }
        left = ox < left ? ox : left;
        top = oy < top ? oy : top;
    }
    for (i = 0; i < cell->numOAMAttrs; i++) {
        const NNSG2dCellOAMAttrData *obj = &cell->pOamAttrArray[i];
        int ox = obj->attr1 & 0x1FF;
        int oy = obj->attr0 & 0xFF;
        const u8 *size = sObjSizes[obj->attr0 >> 14][obj->attr1 >> 14];
        const u8 *tiles = (const u8 *)cells->chars->pRawData + ((obj->attr2 & 0x3FF) << shift) * TILE_SIZE_4BPP;
        if (ox >= 256) {
            ox -= 512;
        }
        if (oy >= 128) {
            oy -= 256;
        }
        BlitTilesFlipped(window, tiles, size[0] / 8, size[1] / 8, x + ox - left, y + oy - top, base, (obj->attr1 >> 12) & 1, (obj->attr1 >> 13) & 1);
    }
}

// A pixel of the page's plate: what its tilemap and tiles give there.
static u8 PlatePixel(EvIvTrainer *app, int screen, int x, int y) {
    PlateLayer *plate = &app->plates[screen];
    const u16 *tilemap = GetBgTilemapBuffer(app->bgConfig, plate->layer);
    u16 entry = tilemap[(y / 8) * 32 + x / 8];
    int px = (entry & 0x400) ? 7 - x % 8 : x % 8;
    int py = (entry & 0x800) ? 7 - y % 8 : y % 8;
    const u8 *tile = (const u8 *)plate->chars->pRawData + (entry & 0x3FF) * TILE_SIZE_4BPP;
    u8 v = (tile[py * 4 + px / 2] >> ((px & 1) * 4)) & 0xF;

    return v == 0 ? 0 : (entry >> 12) * 16 + v;
}

static void ReadRow(EvIvTrainer *app, u16 row) {
    ReadMsgDataIntoString(app->msgData, row, app->string);
    StringExpandPlaceholders(app->msgFormat, app->expanded, app->string);
}

enum TextAlign {
    ALIGN_LEFT,
    ALIGN_RIGHT,
    ALIGN_CENTER,
};

// The string in app->expanded, at x (left, right edge or centre) and y.
static void Print(EvIvTrainer *app, Window *window, int font, int x, int y, u32 colour, int align) {
    int w = FontID_String_GetWidth(font, app->expanded, 0);

    if (align == ALIGN_RIGHT) {
        x -= w;
    } else if (align == ALIGN_CENTER) {
        x -= w / 2;
    }
    // Printed in a 16-colour window first and drawn from there: the text
    // printer's own path into a 256-colour window converts a whole 8 KB block
    // for every glyph, and a page of these took a third of a second.
    FillWindowPixelBuffer(&app->scratch, 0);
    AddTextPrinterParameterizedWithColor(&app->scratch, font, app->expanded, 0, 0, TEXT_SPEED_NOTRANSFER, colour, NULL);
    BlitTiles(window, app->scratch.pixelBuffer, SCRATCH_WIDTH, SCRATCH_HEIGHT, (w + 8) / 8, x, y, PLTT_TEXT); // and the shadow
}

static void PrintRow(EvIvTrainer *app, Window *window, u16 row, int font, int x, int y, u32 colour, int align) {
    ReadRow(app, row);
    Print(app, window, font, x, y, colour, align);
}

static void PrintNumber(EvIvTrainer *app, Window *window, int number, int font, int x, int y, u32 colour, int align) {
    BufferIntegerAsString(app->msgFormat, 0, number, 3, PRINTING_MODE_LEFT_ALIGN, TRUE);
    PrintRow(app, window, msg_0829_00060, font, x, y, colour, align);
}

// The colour a stat's name has on the summary: red the one the nature raises,
// blue the one it lowers.
static u32 StatNameColour(EvIvTrainer *app, int stat, u32 plain) {
    if (stat != STAT_HP) {
        s8 mod = gNatureStatMods[app->nature][stat - 1];
        if (mod > 0) {
            return TEXT_RED;
        }
        if (mod < 0) {
            return TEXT_BLUE;
        }
    }
    return plain;
}

// The level the way the summary prints it, in the message printer's digits:
// their "Lv." pair is tiles 11 and 12 (sub_0200CDAC's glyph 1).
static void DrawLevel(EvIvTrainer *app, Window *win, int x, int y) {
    const u8 *digits = app->digits->pRawData;
    int place = 1;

    BlitTiles(win, digits + 11 * TILE_SIZE_4BPP, 2, 1, 2, x, y, PLTT_TEXT);
    x += 16;
    while (place * 10 <= app->level) {
        place *= 10;
    }
    for (; place >= 1; place /= 10) {
        BlitTiles(win, digits + (app->level / place % 10) * TILE_SIZE_4BPP, 1, 1, 1, x, y, PLTT_TEXT);
        x += 8;
    }
}

// "+SpA -Atk" after the nature's name: the stat it raises and the one it lowers.
static void DrawNatureMods(EvIvTrainer *app, Window *win, int x, int y) {
    int sign;
    int stat;

    for (sign = 1; sign >= -1; sign -= 2) {
        for (stat = STAT_ATK; stat < NUM_STATS; stat++) {
            if (gNatureStatMods[app->nature][stat - 1] * sign > 0) {
                ReadMsgDataIntoString(app->msgData, sign > 0 ? msg_0829_00061 : msg_0829_00062, app->expanded);
                ReadMsgDataIntoString(app->msgData, msg_0829_00018 + stat, app->string);
                String_Cat(app->expanded, app->string);
                Print(app, win, TRAINER_FONT_SMALL, x, y, sign > 0 ? TEXT_RED : TEXT_BLUE, ALIGN_LEFT);
                x += FontID_String_GetWidth(TRAINER_FONT_SMALL, app->expanded, 0) + 3;
            }
        }
    }
}

static u8 PageColour(EvIvTrainer *app) {
    return PlatePixel(app, 0, 1, 60);
}

static void DrawButton(EvIvTrainer *app, Window *window, int x, int y, u16 label, BOOL small) {
    DrawCell(window, &app->buttons, small ? 2 : 0, x, y, PLTT_BUTTONS);
    PrintRow(app, window, label, 0, x + BUTTON_W / 2, y + (small ? -1 : 6), TEXT_BUTTON, ALIGN_CENTER);
}

static void DrawArrow(EvIvTrainer *app, Window *window, int x, int y, BOOL up, BOOL lit) {
    // Cells 2 and 3 point up, 4 and 5 down; the second of each is the pressed one.
    DrawCell(window, &app->arrows, (up ? 2 : 4) + (lit ? 0 : 1), x, y, PLTT_ARROWS);
}

// A small box as the summary draws Item's: a slate label row over a light one.
static void LabelBox(EvIvTrainer *app, Window *window, int x0, int y0, int x1, u16 label, BOOL tall) {
    Panel(window, x0, y0, x1, y0 + (tall ? 34 : 18), COL_VALUE);
    Rect(window, x0 + 2, y0 + 2, x1 - 2, y0 + 16, COL_LABEL);
    PrintRow(app, window, label, 0, x0 + 5, y0 + 1, TEXT_WHITE, ALIGN_LEFT);
}

// The markings under the picture, where the summary puts them (its sprites
// 23 to 28, at x 200 to 240, y 150, their cells 4 up and left): a tile's
// pixels are 14 not set and 1 set, entries of the summary's palette.
static void DrawMarkings(EvIvTrainer *app, Window *win) {
    int markings = GetMonData(app->mon, MON_DATA_MARKINGS, NULL);
    int i;

    for (i = 0; i < 6; i++) {
        BOOL set = (markings >> i) & 1;
        BlitTiles(win, app->markTiles[i] + (set ? TILE_SIZE_4BPP : 0), 1, 1, 1, 196 + 8 * i, 146, set ? COL_MARK_ON - 1 : COL_MARK_OFF - 14);
    }
}

static void Trainer_DrawTop(EvIvTrainer *app) {
    Window *win = &app->top;
    const u8 *evs = Trainer_ShownEvs(app);
    BOOL pending = FALSE;
    int used = 0;
    int i;

    app->topChanged = FALSE;
    FillWindowPixelBuffer(win, 0);
    Rect(win, 0, 18, 146, 191, PageColour(app));
    PrintRow(app, win, msg_0829_00000, 0, 160, 8, TEXT_WHITE, ALIGN_LEFT);

    for (i = 0; i < NUM_STATS; i++) {
        used += evs[i];
        if (app->newStats[i] != app->stats[i]) {
            pending = TRUE;
        }
    }

    // IV, EV and the stat for the six, and while something changes them, the new value.
    Panel(win, 4, 20, 143, 135, COL_VALUE);
    Rect(win, 6, 22, 141, 35, COL_SLATE);
    PrintRow(app, win, msg_0829_00004, TRAINER_FONT_SMALL, 68, 21, TEXT_WHITE, ALIGN_RIGHT);
    PrintRow(app, win, msg_0829_00005, TRAINER_FONT_SMALL, 94, 21, TEXT_WHITE, ALIGN_RIGHT);
    PrintRow(app, win, msg_0829_00006, TRAINER_FONT_SMALL, 120, 21, TEXT_WHITE, ALIGN_RIGHT);
    if (pending) {
        PrintRow(app, win, msg_0829_00007, TRAINER_FONT_SMALL, 141, 21, TEXT_WHITE, ALIGN_RIGHT);
    }
    for (i = 0; i < NUM_STATS; i++) {
        int stat = sDisplayStat[i];
        int y = 36 + 16 * i;
        Rect(win, 6, y, 51, y + 15, (i % 2) ? COL_LABEL_ALT : COL_LABEL);
        Rect(win, 52, y, 141, y + 15, (i % 2) ? COL_VALUE_ALT : COL_VALUE);
        Rect(win, 6, y + 15, 51, y + 15, COL_SLATE);
        Rect(win, 52, y + 15, 141, y + 15, COL_SEPARATOR);
        PrintRow(app, win, msg_0829_00012 + stat, 0, 8, y - 2, StatNameColour(app, stat, TEXT_WHITE), ALIGN_LEFT);
        if (app->trained & MON_HYPER_TRAINED_BIT(stat)) {
            // A trained stat counts as 31, and has the star the summary gives it.
            PrintNumber(app, win, MAX_IV, 0, 68, y - 2, TEXT_DARK, ALIGN_RIGHT);
            PrintRow(app, win, msg_0829_00063, TRAINER_FONT_SMALL, 69, y + 1, TEXT_RED, ALIGN_LEFT);
        } else {
            PrintNumber(app, win, app->ivs[stat], 0, 68, y - 2, TEXT_DARK, ALIGN_RIGHT);
        }
        PrintNumber(app, win, app->evs[stat], 0, 94, y - 2, TEXT_DARK, ALIGN_RIGHT);
        PrintNumber(app, win, app->stats[stat], 0, 120, y - 2, TEXT_DARK, ALIGN_RIGHT);
        if (app->newStats[stat] != app->stats[stat]) {
            PrintNumber(app, win, app->newStats[stat], 0, 141, y - 2, app->newStats[stat] > app->stats[stat] ? TEXT_RED : TEXT_BLUE, ALIGN_RIGHT);
        }
    }

    // The EVs used of 510, and what is left.
    Panel(win, 4, 139, 143, 187, COL_VALUE);
    Rect(win, 6, 141, 51, 162, COL_LABEL);
    Rect(win, 52, 141, 141, 162, COL_VALUE);
    Rect(win, 6, 163, 141, 163, COL_SEPARATOR);
    Rect(win, 6, 164, 51, 185, COL_LABEL_ALT);
    Rect(win, 52, 164, 141, 185, COL_VALUE_ALT);
    PrintRow(app, win, msg_0829_00008, 0, 8, 144, TEXT_WHITE, ALIGN_LEFT);
    PrintRow(app, win, msg_0829_00009, 0, 8, 167, TEXT_WHITE, ALIGN_LEFT);
    BufferIntegerAsString(app->msgFormat, 0, used, 3, PRINTING_MODE_LEFT_ALIGN, TRUE);
    BufferIntegerAsString(app->msgFormat, 1, MAX_EV_SUM, 3, PRINTING_MODE_LEFT_ALIGN, TRUE);
    PrintRow(app, win, msg_0829_00042, 0, 139, 144, TEXT_DARK, ALIGN_RIGHT);
    PrintNumber(app, win, MAX_EV_SUM - used, 0, 139, 167, TEXT_DARK, ALIGN_RIGHT);
    Bar(win, 56, 158, 82, used, MAX_EV_SUM);

    // The Pokemon as the summary shows it: name, gender, level, picture, and
    // the nature in Item's box, the one a Mint gave if it was given one.
    BlitTiles(win, app->ball->pRawData, 2, 2, 2, 159, 31, PLTT_BALL);
    BufferBoxMonNickname(app->msgFormat, 0, Mon_GetBoxMon(app->mon));
    PrintRow(app, win, msg_0829_00059, 0, 176, 32, TEXT_WHITE, ALIGN_LEFT);
    switch (GetMonGender(app->mon)) {
    case MON_MALE:
        PrintRow(app, win, msg_0829_00057, 0, 241, 32, TEXT_BLUE, ALIGN_LEFT);
        break;
    case MON_FEMALE:
        PrintRow(app, win, msg_0829_00058, 0, 241, 32, TEXT_RED, ALIGN_LEFT);
        break;
    }
    DrawLevel(app, win, 160, 49);
    {
        // sub_02014494 hands the picture over in the six blocks a sprite takes it in.
        static const u8 sBlocks[6][4] = { { 0, 0, 8, 8 }, { 8, 0, 2, 4 }, { 8, 4, 2, 4 }, { 0, 8, 4, 2 }, { 4, 8, 4, 2 }, { 8, 8, 2, 2 } };
        const u8 *tiles = app->monTiles;
        for (i = 0; i < 6; i++) {
            BlitTiles(win, tiles, sBlocks[i][2], sBlocks[i][3], sBlocks[i][2], 165 + sBlocks[i][0] * 8, 60 + sBlocks[i][1] * 8, PLTT_MON);
            tiles += sBlocks[i][2] * sBlocks[i][3] * TILE_SIZE_4BPP;
        }
    }
    DrawMarkings(app, win);
    PrintRow(app, win, msg_0829_00011, 0, 161, 160, TEXT_WHITE, ALIGN_LEFT);
    BufferNatureName(app->msgFormat, 0, app->nature);
    ReadRow(app, msg_0829_00059);
    Print(app, win, 0, 161, 176, TEXT_DARK, ALIGN_LEFT);
    DrawNatureMods(app, win, 161 + FontID_String_GetWidth(0, app->expanded, 0) + 5, 176);
    ScheduleWindowCopyToVram(win);
}

static void DrawTabs(EvIvTrainer *app, Window *win) {
    int t;
    int y;

    for (t = 0; t < PAGE_COUNT; t++) {
        const TouchscreenHitbox *box = &sTabHitboxes[t];
        // The tabs keep the summary's buttons; their icons become words.
        for (y = TAB_TOP; y <= TAB_BOTTOM; y++) {
            Rect(win, box->rect.left + 4, y, box->rect.right - 4, y, PlatePixel(app, 1, box->rect.left + 4, y));
        }
        PrintRow(app, win, sTabLabels[t], 0, (box->rect.left + box->rect.right) / 2 + 1, 169, t == TAB_LIT(app) ? TEXT_WHITE : TEXT_DARK, ALIGN_CENTER);
    }
    PrintRow(app, win, msg_0829_00029, 0, 221, 169, TEXT_WHITE, ALIGN_CENTER);
}

static void DrawEvPage(EvIvTrainer *app, Window *win) {
    const PageControls *c = &sPageControls[PAGE_EV];
    int stat = sDisplayStat[app->row];
    int used = 0;
    int i;

    Panel(win, ROWS_LEFT, ROWS_TOP, ROWS_RIGHT, 153, COL_VALUE);
    for (i = 0; i < NUM_STATS; i++) {
        int s = sDisplayStat[i];
        int y = 6 + ROW_HEIGHT * i;
        used += app->newEvs[s];
        Rect(win, 6, y, 51, y + 19, (i % 2) ? COL_LABEL_ALT : COL_LABEL);
        Rect(win, 52, y, 141, y + 19, (i % 2) ? COL_VALUE_ALT : COL_VALUE);
        Rect(win, 6, y + 19, 51, y + 19, COL_SLATE);
        Rect(win, 52, y + 19, 141, y + 19, COL_SEPARATOR);
        PrintRow(app, win, msg_0829_00012 + s, 0, 8, y + 1, StatNameColour(app, s, TEXT_WHITE), ALIGN_LEFT);
        Bar(win, 56, y + 8, 62, app->newEvs[s], MAX_EV_PER_STAT);
        PrintNumber(app, win, app->newEvs[s], 0, 140, y + 1, TEXT_DARK, ALIGN_RIGHT);
    }
    Rect(win, 6, 126, 51, 151, COL_SLATE);
    Rect(win, 52, 126, 141, 151, COL_VALUE);
    PrintRow(app, win, msg_0829_00010, 0, 8, 130, TEXT_WHITE, ALIGN_LEFT);
    Bar(win, 56, 137, 62, used, MAX_EV_SUM);
    PrintNumber(app, win, used, 0, 140, 130, TEXT_DARK, ALIGN_RIGHT);
    Frame(win, ROWS_LEFT, ROWS_TOP + ROW_HEIGHT * app->row, ROWS_RIGHT, ROWS_TOP + ROW_HEIGHT * app->row + 23);

    LabelBox(app, win, 154, 28, 244, msg_0829_00012 + stat, FALSE);
    DrawArrow(app, win, c->downX, c->downY, FALSE, app->newEvs[stat] > 0 && app->pressed != HIT_DOWN);
    DrawArrow(app, win, c->upX, c->upY, TRUE, EvIvTrainer_EvRoom(app->newEvs, stat) > 0 && app->pressed != HIT_UP);
    Panel(win, 186, 62, 212, 82, COL_VALUE);
    PrintNumber(app, win, app->newEvs[stat], 0, 200, 64, TEXT_DARK, ALIGN_CENTER);
    BufferIntegerAsString(app->msgFormat, 0, MAX_EV_PER_STAT, 3, PRINTING_MODE_LEFT_ALIGN, TRUE);
    PrintRow(app, win, msg_0829_00024, TRAINER_FONT_SMALL, 199, 92, TEXT_DARK, ALIGN_CENTER);
    DrawButton(app, win, c->button1X, c->button1Y, c->button1, c->button1Small);
    DrawButton(app, win, c->button2X, c->button2Y, c->button2, c->button2Small);
    PrintRow(app, win, msg_0829_00027, TRAINER_FONT_SMALL, 199, 144, TEXT_DARK, ALIGN_CENTER);
}

static void DrawIvPage(EvIvTrainer *app, Window *win) {
    const PageControls *c = &sPageControls[PAGE_IV];
    int stat = sDisplayStat[app->row];
    int i;

    Panel(win, ROWS_LEFT, ROWS_TOP, ROWS_RIGHT, 153, COL_VALUE);
    for (i = 0; i < NUM_STATS; i++) {
        int s = sDisplayStat[i];
        int y = 6 + ROW_HEIGHT * i;
        BOOL trained = ((app->trained | app->newTrained) & MON_HYPER_TRAINED_BIT(s)) != 0;
        Rect(win, 6, y, 51, y + 19, (i % 2) ? COL_LABEL_ALT : COL_LABEL);
        Rect(win, 52, y, 141, y + 19, (i % 2) ? COL_VALUE_ALT : COL_VALUE);
        Rect(win, 6, y + 19, 51, y + 19, COL_SLATE);
        Rect(win, 52, y + 19, 141, y + 19, COL_SEPARATOR);
        PrintRow(app, win, msg_0829_00012 + s, 0, 8, y + 1, StatNameColour(app, s, TEXT_WHITE), ALIGN_LEFT);
        if (trained) {
            PrintRow(app, win, msg_0829_00036, TRAINER_FONT_SMALL, 55, y + 2, TEXT_RED, ALIGN_LEFT);
            PrintNumber(app, win, MAX_IV, 0, 140, y + 1, TEXT_DARK, ALIGN_RIGHT);
        } else {
            PrintRow(app, win, sJudgeNames[EvIvTrainer_JudgeRank(app->ivs[s])], 0, 55, y + 1, TEXT_DARK, ALIGN_LEFT);
            PrintNumber(app, win, app->ivs[s], 0, 140, y + 1, TEXT_DARK, ALIGN_RIGHT);
        }
    }
    Rect(win, 6, 126, 141, 151, COL_VALUE);
    if (app->level < HYPER_TRAINING_MIN_LEVEL) {
        PrintRow(app, win, msg_0829_00047, TRAINER_FONT_SMALL, 9, 126, TEXT_DARK, ALIGN_LEFT);
        BufferIntegerAsString(app->msgFormat, 0, HYPER_TRAINING_MIN_LEVEL, 3, PRINTING_MODE_LEFT_ALIGN, TRUE);
        PrintRow(app, win, msg_0829_00064, TRAINER_FONT_SMALL, 9, 138, TEXT_DARK, ALIGN_LEFT);
    } else {
        PrintRow(app, win, msg_0829_00037, TRAINER_FONT_SMALL, 9, 126, TEXT_DARK, ALIGN_LEFT);
        PrintRow(app, win, msg_0829_00038, TRAINER_FONT_SMALL, 9, 138, TEXT_DARK, ALIGN_LEFT);
    }
    Frame(win, ROWS_LEFT, ROWS_TOP + ROW_HEIGHT * app->row, ROWS_RIGHT, ROWS_TOP + ROW_HEIGHT * app->row + 23);

    LabelBox(app, win, 154, 28, 244, msg_0829_00012 + stat, TRUE);
    if ((app->trained | app->newTrained) & MON_HYPER_TRAINED_BIT(stat)) {
        PrintRow(app, win, msg_0829_00036, TRAINER_FONT_SMALL, 159, 46, TEXT_RED, ALIGN_LEFT);
    } else {
        PrintRow(app, win, sJudgeNames[EvIvTrainer_JudgeRank(app->ivs[stat])], 0, 159, 45, TEXT_DARK, ALIGN_LEFT);
    }
    DrawButton(app, win, c->button1X, c->button1Y, c->button1, c->button1Small);
    BufferItemName(app->msgFormat, 0, app->gold ? ITEM_GOLD_BOTTLE_CAP : ITEM_BOTTLE_CAP);
    ReadRow(app, msg_0829_00059);
    Panel(win, 154, 100, 244, 134, COL_VALUE);
    Rect(win, 156, 102, 242, 116, COL_LABEL);
    Print(app, win, 0, 159, 101, TEXT_WHITE, ALIGN_LEFT);
    BufferIntegerAsString(app->msgFormat, 0, app->gold ? 1 : Trainer_PendingCaps(app), 1, PRINTING_MODE_LEFT_ALIGN, TRUE);
    BufferIntegerAsString(app->msgFormat, 1, app->gold ? app->goldCaps : app->caps, 3, PRINTING_MODE_LEFT_ALIGN, TRUE);
    PrintRow(app, win, msg_0829_00041, 0, 159, 117, TEXT_DARK, ALIGN_LEFT);
    DrawButton(app, win, c->button2X, c->button2Y, c->button2, c->button2Small);
}

// A set's EVs in a line: "4 HP / 252 Atk / 252 Spe", or "84 in each stat".
static void SpreadText(EvIvTrainer *app, const u8 *evs) {
    BOOL even = TRUE;
    int i;

    for (i = 1; i < NUM_STATS; i++) {
        if (evs[i] != evs[0]) {
            even = FALSE;
        }
    }
    if (even) {
        if (evs[0] == 0) {
            ReadMsgDataIntoString(app->msgData, msg_0829_00046, app->expanded);
        } else {
            BufferIntegerAsString(app->msgFormat, 0, evs[0], 3, PRINTING_MODE_LEFT_ALIGN, TRUE);
            ReadRow(app, msg_0829_00045);
        }
        return;
    }
    String_SetEmpty(app->expanded);
    for (i = 0; i < NUM_STATS; i++) {
        int stat = sDisplayStat[i];
        if (evs[stat] == 0) {
            continue;
        }
        if (String_GetLength(app->expanded) != 0) {
            ReadMsgDataIntoString(app->msgData, msg_0829_00044, app->string);
            String_Cat(app->expanded, app->string);
        }
        String16_FormatInteger(app->string, evs[stat], 3, PRINTING_MODE_LEFT_ALIGN, TRUE);
        String_Cat(app->expanded, app->string);
        String_AddChar(app->expanded, CHAR_SPACE);
        ReadMsgDataIntoString(app->msgData, msg_0829_00018 + stat, app->string);
        String_Cat(app->expanded, app->string);
    }
}

static void DrawSetsPage(EvIvTrainer *app, Window *win) {
    const PageControls *c = &sPageControls[PAGE_SETS];
    int r;

    Panel(win, ROWS_LEFT, ROWS_TOP, ROWS_RIGHT, 153, COL_VALUE);
    if (app->setCount == 0) {
        PrintRow(app, win, msg_0829_00048, 0, 9, 8, TEXT_DARK, ALIGN_LEFT);
        return;
    }
    for (r = 0; r < SETS_SHOWN; r++) {
        int i = app->setTop + r;
        int y = 6 + SET_HEIGHT * r;
        Rect(win, 6, y, 141, y + 23, (r % 2) ? COL_VALUE_ALT : COL_VALUE);
        Rect(win, 6, y + 23, 141, y + 23, COL_SEPARATOR);
        if (i < app->setCount) {
            ReadMsgDataIntoString(app->setNames, sEvIvTrainerSets[i].name, app->expanded);
            Print(app, win, 0, 9, y - 3, TEXT_DARK, ALIGN_LEFT);
            SpreadText(app, sEvIvTrainerSets[i].evs);
            Print(app, win, TRAINER_FONT_SMALL, 9, y + 9, TEXT_DARK, ALIGN_LEFT);
        }
    }
    Frame(win, ROWS_LEFT, ROWS_TOP + SET_HEIGHT * (app->set - app->setTop), ROWS_RIGHT, ROWS_TOP + SET_HEIGHT * (app->set - app->setTop) + 27);
    DrawArrow(app, win, c->upX, c->upY, TRUE, app->set > 0 && app->pressed != HIT_UP);
    BufferIntegerAsString(app->msgFormat, 0, app->set + 1, 2, PRINTING_MODE_LEFT_ALIGN, TRUE);
    BufferIntegerAsString(app->msgFormat, 1, app->setCount, 2, PRINTING_MODE_LEFT_ALIGN, TRUE);
    PrintRow(app, win, msg_0829_00042, 0, 198, 80, TEXT_DARK, ALIGN_CENTER);
    DrawArrow(app, win, c->downX, c->downY, FALSE, app->set + 1 < app->setCount && app->pressed != HIT_DOWN);
    DrawButton(app, win, c->button1X, c->button1Y, c->button1, c->button1Small);
}

#ifdef NEWGOLD_DIAG
static void Trainer_SetPage(EvIvTrainer *app, int page);
static void Trainer_Act(EvIvTrainer *app, int hit, int step);
static void Trainer_Back(EvIvTrainer *app);
static void Trainer_Done(EvIvTrainer *app);

// konefr's password, 0-2-5-1, which his vendor asked a digit at a time.
static const u8 sDevPassword[4] = { 0, 2, 5, 1 };
// His shop's four lines, Rare Candies at 1 each, and Exit.
static const u8 sDevQuantities[4] = { 1, 10, 50, 99 };

static void DevLine(EvIvTrainer *app, Window *win, u16 row, int line, int x, int y) {
    ReadMsgDataIntoString(app->devMsg, row, app->string);
    String_GetLineN(app->expanded, app->string, line);
    Print(app, win, 0, x, y, TEXT_DARK, ALIGN_LEFT);
}

static void DrawDevPage(EvIvTrainer *app, Window *win) {
    int i;

    Panel(win, ROWS_LEFT, ROWS_TOP, ROWS_RIGHT, 153, COL_VALUE);
    if (!app->devOpen) {
        DevLine(app, win, msg_0550_T21_00025, 0, 9, 8); // Password?
        for (i = 0; i < 4; i++) {
            int x = 18 + 28 * i;
            Panel(win, x, 36, x + 23, 61, COL_VALUE_ALT);
            DevLine(app, win, msg_0550_T21_00026 + app->devDigits[i], 0, x + 8, 40);
        }
        Frame(win, 16 + 28 * app->devCursor, 34, 16 + 28 * app->devCursor + 27, 63);
    } else {
        DevLine(app, win, msg_0550_T21_00046, 0, 9, 6);  // Developer Shop
        DevLine(app, win, msg_0550_T21_00046, 1, 9, 20); // Rare Candy: $1 each.
        for (i = 0; i < 5; i++) {
            int y = 40 + 18 * i;
            Rect(win, 6, y, 141, y + 17, (i % 2) ? COL_VALUE_ALT : COL_VALUE);
            DevLine(app, win, i < 4 ? msg_0550_T21_00038 + i : msg_0550_T21_00042, 0, 9, y);
        }
        Frame(win, ROWS_LEFT, 38 + 18 * app->devCursor, ROWS_RIGHT, 38 + 18 * app->devCursor + 21);
    }
    if (app->devLine != 0) {
        DevLine(app, win, app->devLine, 0, 9, 132);
    }
    ReadMsgDataIntoString(app->devMsg, msg_0550_T21_00048, app->expanded); // Rare Candy
    Panel(win, 154, 28, 244, 62, COL_VALUE);
    Rect(win, 156, 30, 242, 44, COL_LABEL);
    Print(app, win, 0, 159, 29, TEXT_WHITE, ALIGN_LEFT);
    PrintNumber(app, win, Bag_GetQuantity(app->bag, ITEM_RARE_CANDY, app->heapID), 0, 240, 45, TEXT_DARK, ALIGN_RIGHT);
}

static void Trainer_DevInput(EvIvTrainer *app) {
    int keys = gSystem.newKeys;
    int repeat = gSystem.newAndRepeatedKeys;
    u32 x, y;
    int i;

    if (System_GetTouchNewCoords(&x, &y)) {
        for (i = 0; sTabHitboxes[i].rect.top != TOUCHSCREEN_RECTLIST_END; i++) {
            if (TouchscreenHitbox_PointIsIn(&sTabHitboxes[i], x, y)) {
                Trainer_Act(app, HIT_TAB0 + i, 1);
                return;
            }
        }
        if (app->devOpen && x >= ROWS_LEFT && x <= ROWS_RIGHT && y >= 40 && y < 40 + 18 * 5) {
            app->devCursor = (y - 40) / 18;
            keys |= PAD_BUTTON_A;
        }
    }
    if (keys & PAD_BUTTON_B) {
        Trainer_Back(app);
        return;
    }
    if (keys & PAD_BUTTON_SELECT) {
        Trainer_SetPage(app, PAGE_EV);
        return;
    }
    if (keys & PAD_BUTTON_START) {
        Trainer_Done(app);
        return;
    }
    if (!app->devOpen) {
        if (repeat & PAD_KEY_LEFT) {
            app->devCursor = (app->devCursor + 3) % 4;
        } else if (repeat & PAD_KEY_RIGHT) {
            app->devCursor = (app->devCursor + 1) % 4;
        } else if (repeat & PAD_KEY_UP) {
            app->devDigits[app->devCursor] = (app->devDigits[app->devCursor] + 1) % 10;
        } else if (repeat & PAD_KEY_DOWN) {
            app->devDigits[app->devCursor] = (app->devDigits[app->devCursor] + 9) % 10;
        } else if (keys & PAD_BUTTON_A) {
            app->devOpen = memcmp(app->devDigits, sDevPassword, sizeof(sDevPassword)) == 0;
            app->devLine = app->devOpen ? msg_0550_T21_00036 : msg_0550_T21_00037; // Access granted. / Wrong password.
            app->devCursor = 0;
            PlaySE(app->devOpen ? SEQ_SE_DP_DECIDE : SEQ_SE_DP_CUSTOM06);
        } else {
            return;
        }
    } else {
        if (repeat & PAD_KEY_UP) {
            app->devCursor = (app->devCursor + 4) % 5;
        } else if (repeat & PAD_KEY_DOWN) {
            app->devCursor = (app->devCursor + 1) % 5;
        } else if (keys & PAD_BUTTON_A) {
            if (app->devCursor == 4) { // Exit
                Trainer_SetPage(app, PAGE_EV);
                return;
            }
            i = sDevQuantities[app->devCursor];
            if (!Bag_HasSpaceForItem(app->bag, ITEM_RARE_CANDY, i, app->heapID)) {
                app->devLine = msg_0550_T21_00045;
                PlaySE(SEQ_SE_DP_CUSTOM06);
            } else if (PlayerProfile_GetMoney(app->profile) < (u32)i) {
                app->devLine = msg_0550_T21_00044;
                PlaySE(SEQ_SE_DP_CUSTOM06);
            } else {
                PlayerProfile_SubMoney(app->profile, i);
                Bag_AddItem(app->bag, ITEM_RARE_CANDY, i, app->heapID);
                app->devLine = msg_0550_T21_00043; // Purchase complete.
                PlaySE(SEQ_SE_DP_REGI);
            }
        } else {
            return;
        }
    }
    PlaySE(SEQ_SE_DP_SELECT);
    Trainer_DrawBottom(app);
}
#endif

static void Trainer_DrawBottom(EvIvTrainer *app) {
    Window *win = &app->bottom;

    FillWindowPixelBuffer(win, 0);
    Rect(win, 0, 0, 146, 157, PageColour(app));
    Rect(win, 152, 26, 244, 160, COL_VALUE);
#ifdef NEWGOLD_DIAG
    if (app->page == PAGE_DEV) {
        ReadMsgDataIntoString(app->devMsg, msg_0550_T21_00047, app->expanded);
        Print(app, win, 0, 156, 8, TEXT_WHITE, ALIGN_LEFT);
        DrawDevPage(app, win);
    } else
#endif
    PrintRow(app, win, sPageTitles[app->page], 0, 156, 8, TEXT_WHITE, ALIGN_LEFT);
    switch (app->page) {
    case PAGE_EV:
        DrawEvPage(app, win);
        break;
    case PAGE_IV:
        DrawIvPage(app, win);
        break;
    case PAGE_SETS:
        DrawSetsPage(app, win);
        break;
    }
    DrawTabs(app, win);
    ScheduleWindowCopyToVram(win);
}

static void Trainer_Redraw(EvIvTrainer *app) {
    Trainer_DrawTop(app);
    Trainer_DrawBottom(app);
}

static void Trainer_SetPage(EvIvTrainer *app, int page) {
    if (page == app->page) {
        return;
    }
    PlaySE(SEQ_SE_DP_SELECT);
    app->page = page;
    GfGfxLoader_LoadScrnData(NARC_a_1_6_2, sPagePlates[page][0], app->bgConfig, GF_BG_LYR_MAIN_3, 0, 0, FALSE, app->heapID);
    GfGfxLoader_LoadScrnData(NARC_a_1_6_2, sPagePlates[page][1], app->bgConfig, GF_BG_LYR_SUB_3, 0, 0, FALSE, app->heapID);
    Trainer_UpdatePreview(app);
    Trainer_Redraw(app);
}

// ---- the screens -------------------------------------------------------------------------------

static void Trainer_VBlank(void *data) {
    EvIvTrainer *app = data;

    DoScheduledBgGpuUpdates(app->bgConfig);
    OS_SetIrqCheckFlag(OS_IE_VBLANK);
}

static void LoadCells(Cells *cells, NarcId narc, int bank, int chars, enum HeapID heapID) {
    cells->bankRaw = GfGfxLoader_GetCellBank(narc, bank, FALSE, &cells->bank, heapID);
    cells->charRaw = GfGfxLoader_GetCharData(narc, chars, FALSE, &cells->chars, heapID);
}

static void FreeCells(Cells *cells) {
    Heap_Free(cells->bankRaw);
    Heap_Free(cells->charRaw);
}

static const BgTemplate sPlateTemplate = {
    .bufferSize = GF_BG_BUF_SIZE_256x256_4BPP,
    .size = GF_BG_SCR_SIZE_256x256,
    .colorMode = GX_BG_COLORMODE_16,
    .screenBase = GX_BG_SCRBASE_0xf800,
    .charBase = GX_BG_CHARBASE_0x00000,
    .bgExtPltt = GX_BG_EXTPLTT_01,
    .priority = 3,
    .areaOver = GX_BG_AREAOVER_XLU,
};
static const BgTemplate sDrawTemplate = {
    .bufferSize = GF_BG_BUF_SIZE_256x256_4BPP,
    .size = GF_BG_SCR_SIZE_256x256,
    .colorMode = GX_BG_COLORMODE_256,
    .screenBase = GX_BG_SCRBASE_0xf000,
    .charBase = GX_BG_CHARBASE_0x10000,
    .bgExtPltt = GX_BG_EXTPLTT_01,
    .priority = 2,
    .areaOver = GX_BG_AREAOVER_XLU,
};
static const BgTemplate sScratchTemplate = {
    .bufferSize = GF_BG_BUF_SIZE_256x256_4BPP,
    .size = GF_BG_SCR_SIZE_256x256,
    .colorMode = GX_BG_COLORMODE_16,
    .screenBase = GX_BG_SCRBASE_0xe800,
    .charBase = GX_BG_CHARBASE_0x08000,
    .bgExtPltt = GX_BG_EXTPLTT_01,
    .priority = 0,
    .areaOver = GX_BG_AREAOVER_XLU,
};
static const BgTemplate sMessageTemplate = {
    .bufferSize = GF_BG_BUF_SIZE_256x256_4BPP,
    .size = GF_BG_SCR_SIZE_256x256,
    .colorMode = GX_BG_COLORMODE_16,
    .screenBase = GX_BG_SCRBASE_0xe800,
    .charBase = GX_BG_CHARBASE_0x04000,
    .bgExtPltt = GX_BG_EXTPLTT_01,
    .priority = 0,
    .areaOver = GX_BG_AREAOVER_XLU,
};

#define MESSAGE_TILE       1
#define YESNO_TILE         (MESSAGE_TILE + 22 * 4)
#define MESSAGE_FRAME_TILE 0x300
#define MESSAGE_FRAME_PLTT 10
#define MESSAGE_FONT_PLTT  11 // GF_PAL_SLOT_11_OFFSET
#define YESNO_PLTT         5

static void LoadOwnColours(enum GFPalLoadLocation location) {
    BG_LoadPlttData(location, sOwnColours, sizeof(sOwnColours), PLTT_OWN * 2);
    BG_LoadPlttData(location, &sButtonTextShadow, sizeof(sButtonTextShadow), (PLTT_TEXT + 9) * 2);
}

static void Trainer_OpenScreens(EvIvTrainer *app) {
    GraphicsBanks banks = {
        .bg = GX_VRAM_BG_128_A,
        .bgextpltt = GX_VRAM_BGEXTPLTT_NONE,
        .subbg = GX_VRAM_SUB_BG_128_C,
        .subbgextpltt = GX_VRAM_SUB_BGEXTPLTT_NONE,
        .obj = GX_VRAM_OBJ_16_G,
        .objextpltt = GX_VRAM_OBJEXTPLTT_NONE,
        .subobj = GX_VRAM_SUB_OBJ_16_I,
        .subobjextpltt = GX_VRAM_SUB_OBJEXTPLTT_NONE,
        .tex = GX_VRAM_TEX_NONE,
        .texpltt = GX_VRAM_TEXPLTT_NONE,
    };
    GraphicsModes modes = {
        .dispMode = GX_DISPMODE_GRAPHICS,
        .bgMode = GX_BGMODE_0,
        .subMode = GX_BGMODE_0,
        ._2d3dMode = GX_BG0_AS_2D,
    };
    PokepicTemplate pic;

    Main_SetVBlankIntrCB(NULL, NULL);
    HBlankInterruptDisable();
    GfGfx_DisableEngineAPlanes();
    GfGfx_DisableEngineBPlanes();
    GX_SetVisiblePlane(GX_PLANEMASK_NONE);
    GXS_SetVisiblePlane(GX_PLANEMASK_NONE);
    GfGfx_SetBanks(&banks);
    GX_SetDispSelect(GX_DISP_SELECT_MAIN_SUB);
    ResetVisibleHardwareWindows(PM_LCD_TOP);
    ResetVisibleHardwareWindows(PM_LCD_BOTTOM);
    sub_0200FBF4(PM_LCD_TOP, RGB_BLACK);
    sub_0200FBF4(PM_LCD_BOTTOM, RGB_BLACK);

    app->bgConfig = BgConfig_Alloc(app->heapID);
    SetBothScreensModesAndDisable(&modes);
    InitBgFromTemplate(app->bgConfig, GF_BG_LYR_MAIN_3, &sPlateTemplate, GF_BG_TYPE_TEXT);
    InitBgFromTemplate(app->bgConfig, GF_BG_LYR_MAIN_2, &sDrawTemplate, GF_BG_TYPE_TEXT);
    InitBgFromTemplate(app->bgConfig, GF_BG_LYR_SUB_3, &sPlateTemplate, GF_BG_TYPE_TEXT);
    InitBgFromTemplate(app->bgConfig, GF_BG_LYR_SUB_2, &sDrawTemplate, GF_BG_TYPE_TEXT);
    InitBgFromTemplate(app->bgConfig, GF_BG_LYR_SUB_0, &sMessageTemplate, GF_BG_TYPE_TEXT);
    InitBgFromTemplate(app->bgConfig, GF_BG_LYR_MAIN_0, &sScratchTemplate, GF_BG_TYPE_TEXT); // never shown
    BgClearTilemapBufferAndCommit(app->bgConfig, GF_BG_LYR_MAIN_0);
    ToggleBgLayer(GF_BG_LYR_MAIN_0, GF_PLANE_TOGGLE_OFF);
    BgClearTilemapBufferAndCommit(app->bgConfig, GF_BG_LYR_SUB_0);
    BG_ClearCharDataRange(GF_BG_LYR_SUB_0, 32, 0, app->heapID);

    // The summary's plates, tiles and palette on both screens; the page's own
    // tilemap is loaded per page.
    GfGfxLoader_GXLoadPal(NARC_a_1_6_2, 0, GF_PAL_LOCATION_MAIN_BG, GF_PAL_SLOT_0_OFFSET, 0x200, app->heapID);
    GfGfxLoader_GXLoadPal(NARC_a_1_6_2, 0, GF_PAL_LOCATION_SUB_BG, GF_PAL_SLOT_0_OFFSET, 0x200, app->heapID);
    LoadOwnColours(GF_PAL_LOCATION_MAIN_BG);
    LoadOwnColours(GF_PAL_LOCATION_SUB_BG);
    GfGfxLoader_LoadCharData(NARC_a_1_6_2, 2, app->bgConfig, GF_BG_LYR_MAIN_3, 0, 0, FALSE, app->heapID);
    GfGfxLoader_LoadCharData(NARC_a_1_6_2, 1, app->bgConfig, GF_BG_LYR_SUB_3, 0, 0, FALSE, app->heapID);
    app->plates[0].charRaw = GfGfxLoader_GetCharData(NARC_a_1_6_2, 2, FALSE, &app->plates[0].chars, app->heapID);
    app->plates[0].layer = GF_BG_LYR_MAIN_3;
    app->plates[1].charRaw = GfGfxLoader_GetCharData(NARC_a_1_6_2, 1, FALSE, &app->plates[1].chars, app->heapID);
    app->plates[1].layer = GF_BG_LYR_SUB_3;
    GfGfxLoader_LoadScrnData(NARC_a_1_6_2, sPagePlates[app->page][0], app->bgConfig, GF_BG_LYR_MAIN_3, 0, 0, FALSE, app->heapID);
    GfGfxLoader_LoadScrnData(NARC_a_1_6_2, sPagePlates[app->page][1], app->bgConfig, GF_BG_LYR_SUB_3, 0, 0, FALSE, app->heapID);

    // The summary's arrow buttons and the party menu's blue ones, drawn from
    // their cells; the message printer's digits for the level.
    LoadCells(&app->arrows, NARC_a_1_6_2, 6, 8, app->heapID);
    GfGfxLoader_GXLoadPal(NARC_a_1_6_2, 3, GF_PAL_LOCATION_SUB_BG, GF_PAL_SLOT_7_OFFSET, 0x20, app->heapID);
    LoadCells(&app->buttons, NARC_graphic_plist_gra, 10, 11, app->heapID);
    GfGfxLoader_GXLoadPal(NARC_graphic_plist_gra, 8, GF_PAL_LOCATION_SUB_BG, GF_PAL_SLOT_8_OFFSET, 0x20, app->heapID);
    app->digitsRaw = GfGfxLoader_GetCharData(NARC_graphic_font, 5, TRUE, &app->digits, app->heapID);

    // The ball it was caught in, as the summary draws it beside the name
    // (sub_0208B48C): its icon member ball + 24 of a/1/6/2, 25 with none.
    // The summary has icons as far as the Sport Ball; past it, a Poke Ball's.
    {
        int ball = GetMonData(app->mon, MON_DATA_POKEBALL, NULL);
        if (ball > BALL_SPORT) {
            ball = BALL_POKE;
        }
        app->ballRaw = GfGfxLoader_GetCharData(NARC_a_1_6_2, ball == BALL_NONE ? 25 : ball + 24, FALSE, &app->ball, app->heapID);
        GfGfxLoader_GXLoadPal(NARC_a_1_6_2, 49 + _02104C68[ball], GF_PAL_LOCATION_MAIN_BG, GF_PAL_SLOT_10_OFFSET, 0x20, app->heapID);
    }

    // The six markings, as the summary draws them under the picture: each
    // its own two tiles in a/0/3/9 (the summary's sprites 23 to 28, circle,
    // triangle, square, heart, star, diamond), the first not set, the second
    // set.
    {
        static const u8 sMarkingChars[6] = { 52, 56, 55, 57, 53, 54 };
        NNSG2dCharacterData *chars;
        int i;
        for (i = 0; i < 6; i++) {
            void *raw = GfGfxLoader_GetCharData(NARC_a_0_3_9, sMarkingChars[i], FALSE, &chars, app->heapID);
            memcpy(app->markTiles[i], chars->pRawData, sizeof(app->markTiles[i]));
            Heap_Free(raw);
        }
    }

    // The Pokemon's front picture, as the summary draws it.
    GetPokemonSpriteCharAndPlttNarcIds(&pic, app->mon, MON_PIC_FACING_FRONT);
    app->monTiles = Heap_Alloc(app->heapID, 10 * 10 * TILE_SIZE_4BPP);
    sub_02014494((NarcId)pic.narcID, pic.charDataID, app->heapID, 0, 0, 10, 10, app->monTiles, pic.personality, FALSE, MON_PIC_FACING_FRONT, pic.species);
    GfGfxLoader_GXLoadPal((NarcId)pic.narcID, pic.palDataID, GF_PAL_LOCATION_MAIN_BG, GF_PAL_SLOT_9_OFFSET, 0x20, app->heapID);

    // Both fonts read whole into memory while the screens are up, as the
    // naming screen does: a full redraw prints a hundred strings.
    FontID_Alloc(TRAINER_FONT_SMALL, app->heapID);
    FontID_SetAccessDirect(0, app->heapID);
    FontID_SetAccessDirect(TRAINER_FONT_SMALL, app->heapID);
    AddWindowParameterized(app->bgConfig, &app->scratch, GF_BG_LYR_MAIN_0, 0, 0, SCRATCH_WIDTH, SCRATCH_HEIGHT, 0, 0);
    AddWindowParameterized(app->bgConfig, &app->top, GF_BG_LYR_MAIN_2, 0, 0, 32, 24, TEXT_SLOT, 0);
    AddWindowParameterized(app->bgConfig, &app->bottom, GF_BG_LYR_SUB_2, 0, 0, 32, 24, TEXT_SLOT, 0);
    PutWindowTilemap(&app->top);
    PutWindowTilemap(&app->bottom);
    BgCommitTilemapBufferToVram(app->bgConfig, GF_BG_LYR_MAIN_2);
    BgCommitTilemapBufferToVram(app->bgConfig, GF_BG_LYR_SUB_2);

    // The message window, with the player's frame, and the YES/NO buttons.
    LoadUserFrameGfx2(app->bgConfig, GF_BG_LYR_SUB_0, MESSAGE_FRAME_TILE, MESSAGE_FRAME_PLTT, Options_GetFrame(app->options), app->heapID);
    LoadFontPal1(GF_PAL_LOCATION_SUB_BG, GF_PAL_SLOT_11_OFFSET, app->heapID);
    AddWindowParameterized(app->bgConfig, &app->message, GF_BG_LYR_SUB_0, 2, 19, 22, 4, MESSAGE_FONT_PLTT, MESSAGE_TILE);
    app->yesNo = YesNoPrompt_Create(app->heapID);

    Trainer_Redraw(app);
    GfGfx_EngineATogglePlanes(GX_PLANEMASK_BG2 | GX_PLANEMASK_BG3, GF_PLANE_TOGGLE_ON);
    GfGfx_EngineBTogglePlanes(GX_PLANEMASK_BG0 | GX_PLANEMASK_BG2 | GX_PLANEMASK_BG3, GF_PLANE_TOGGLE_ON);
    Main_SetVBlankIntrCB(Trainer_VBlank, app);
    app->graphicsUp = TRUE;
}

static void Trainer_CloseScreens(EvIvTrainer *app) {
    if (!app->graphicsUp) {
        return;
    }
    Main_SetVBlankIntrCB(NULL, NULL);
    YesNoPrompt_Destroy(app->yesNo);
    RemoveWindow(&app->message);
    RemoveWindow(&app->bottom);
    RemoveWindow(&app->top);
    RemoveWindow(&app->scratch);
    FontID_SetAccessLazy(0);
    FontID_Release(TRAINER_FONT_SMALL);
    Heap_Free(app->monTiles);
    Heap_Free(app->digitsRaw);
    Heap_Free(app->ballRaw);
    FreeCells(&app->buttons);
    FreeCells(&app->arrows);
    Heap_Free(app->plates[1].charRaw);
    Heap_Free(app->plates[0].charRaw);
    FreeBgTilemapBuffer(app->bgConfig, GF_BG_LYR_SUB_0);
    FreeBgTilemapBuffer(app->bgConfig, GF_BG_LYR_SUB_2);
    FreeBgTilemapBuffer(app->bgConfig, GF_BG_LYR_SUB_3);
    FreeBgTilemapBuffer(app->bgConfig, GF_BG_LYR_MAIN_0);
    FreeBgTilemapBuffer(app->bgConfig, GF_BG_LYR_MAIN_2);
    FreeBgTilemapBuffer(app->bgConfig, GF_BG_LYR_MAIN_3);
    Heap_Free(app->bgConfig);
    GfGfx_DisableEngineAPlanes();
    GfGfx_DisableEngineBPlanes();
    GX_SetVisiblePlane(GX_PLANEMASK_NONE);
    GXS_SetVisiblePlane(GX_PLANEMASK_NONE);
    app->graphicsUp = FALSE;
}

// ---- the party menu --------------------------------------------------------------------------

static void Trainer_StartPartyMenu(EvIvTrainer *app) {
    FieldSystem *fieldSystem = app->args->fieldSystem;
    PartyMenuArgs *args = app->partyArgs;

    MI_CpuClearFast(args, sizeof(PartyMenuArgs));
    args->party = app->party;
    args->bag = app->bag;
    args->mailbox = Save_Mailbox_Get(app->saveData);
    args->options = app->options;
    args->fieldSystem = fieldSystem;
    args->menuInputStatePtr = &fieldSystem->menuInputState;
    args->context = PARTY_MENU_CONTEXT_TRAIN_MON;
    args->partySlot = app->slot;
    app->partyMenu = OverlayManager_New(&gOverlayTemplate_PartyMenu, args, app->heapID);
}

static BOOL Trainer_RunPartyMenu(EvIvTrainer *app) {
    if (!OverlayManager_Run(app->partyMenu)) {
        return FALSE;
    }
    OverlayManager_Delete(app->partyMenu);
    app->partyMenu = NULL;
    return TRUE;
}

// ---- input -------------------------------------------------------------------------------------

static int Trainer_TouchedRow(EvIvTrainer *app, u32 x, u32 y) {
    int height = app->page == PAGE_SETS ? SET_HEIGHT : ROW_HEIGHT;
    int rows = app->page == PAGE_SETS ? SETS_SHOWN : NUM_STATS;
    int r;

    if (x < ROWS_LEFT || x > ROWS_RIGHT || y < ROWS_TOP + 2) {
        return HIT_NONE;
    }
    r = (y - ROWS_TOP - 2) / height;
    return r < rows ? HIT_ROW0 + r : HIT_NONE;
}

static BOOL InBox(u32 x, u32 y, int x0, int y0, int w, int h) {
    return (int)x >= x0 && (int)x < x0 + w && (int)y >= y0 && (int)y < y0 + h;
}

static int Trainer_Touched(EvIvTrainer *app, u32 x, u32 y) {
    const PageControls *c = &sPageControls[app->page];
    int i;
    int row;

    for (i = 0; sTabHitboxes[i].rect.top != TOUCHSCREEN_RECTLIST_END; i++) {
        if (TouchscreenHitbox_PointIsIn(&sTabHitboxes[i], x, y)) {
            return HIT_TAB0 + i;
        }
    }
    row = Trainer_TouchedRow(app, x, y);
    if (row != HIT_NONE) {
        return row;
    }
    if (c->downX != 0 && InBox(x, y, c->downX, c->downY, ARROW_W, ARROW_H)) {
        return HIT_DOWN;
    }
    if (c->upX != 0 && InBox(x, y, c->upX, c->upY, ARROW_W, ARROW_H)) {
        return HIT_UP;
    }
    if (c->button1 != 0 && InBox(x, y, c->button1X, c->button1Y, BUTTON_W, c->button1Small ? BUTTON_H_SMALL : BUTTON_H_BIG)) {
        return HIT_BUTTON1;
    }
    if (c->button2 != 0 && InBox(x, y, c->button2X, c->button2Y, BUTTON_W, c->button2Small ? BUTTON_H_SMALL : BUTTON_H_BIG)) {
        return HIT_BUTTON2;
    }
    return HIT_NONE;
}

static void Trainer_MoveSet(EvIvTrainer *app, int step) {
    int set = app->set + step;

    if (set < 0 || set >= app->setCount) {
        return;
    }
    PlaySE(SEQ_SE_DP_SELECT);
    app->set = set;
    if (app->set < app->setTop) {
        app->setTop = app->set;
    } else if (app->set >= app->setTop + SETS_SHOWN) {
        app->setTop = app->set - SETS_SHOWN + 1;
    }
    Trainer_UpdatePreview(app);
}

static void Trainer_Error(void) {
    PlaySE(SEQ_SE_DP_CUSTOM06);
}

// Train, the Bottle Cap's: the stat the cursor is on, once more or once less.
static void Trainer_TrainOne(EvIvTrainer *app) {
    int stat = sDisplayStat[app->row];
    u32 bit = MON_HYPER_TRAINED_BIT(stat);

    if (app->gold || !Trainer_CanTrain(app, stat)) {
        Trainer_Error();
        return;
    }
    if (app->newTrained & bit) {
        app->newTrained &= ~bit;
    } else if (Trainer_PendingCaps(app) < app->caps) {
        app->newTrained |= bit;
    } else {
        Trainer_Ask(app, SAY_NO_CAP);
        return;
    }
    PlaySE(SEQ_SE_DP_SELECT);
    Trainer_UpdatePreview(app);
}

// Train all, the Gold Bottle Cap's: every stat that can be trained, or none again.
static void Trainer_TrainAll(EvIvTrainer *app) {
    u32 all = 0;
    int stat;

    for (stat = 0; stat < NUM_STATS; stat++) {
        if (Trainer_CanTrain(app, stat)) {
            all |= MON_HYPER_TRAINED_BIT(stat);
        }
    }
    if (app->gold) {
        app->gold = FALSE;
        app->newTrained = 0;
    } else if (all == 0) {
        Trainer_Error();
        return;
    } else if (app->goldCaps == 0) {
        app->gold = TRUE; // for the message's item name
        Trainer_Ask(app, SAY_NO_CAP);
        app->gold = FALSE;
        return;
    } else {
        app->gold = TRUE;
        app->newTrained = all;
    }
    PlaySE(SEQ_SE_DP_SELECT);
    Trainer_UpdatePreview(app);
}

static void Trainer_Done(EvIvTrainer *app) {
    PlaySE(SEQ_SE_DP_DECIDE);
    if (!Trainer_HasChanges(app)) {
        app->leaving = FALSE;
        app->state = STATE_CLOSE;
        app->substate = 0;
        return;
    }
    if (EvIvTrainer_Fee(app->evs, app->newEvs) > PlayerProfile_GetMoney(app->profile)) {
        Trainer_Ask(app, SAY_NO_MONEY);
    } else if (Trainer_EvsChanged(app)) {
        Trainer_Ask(app, ASK_EVS);
    } else {
        Trainer_Ask(app, ASK_HYPER);
    }
}

static void Trainer_Back(EvIvTrainer *app) {
    PlaySE(SEQ_SE_DP_DECIDE);
    if (Trainer_HasChanges(app)) {
        Trainer_Ask(app, ASK_DISCARD);
    } else {
        app->state = STATE_CLOSE;
        app->substate = 0;
    }
}

// What a touch or a button does on the page: hit is the control, step the
// size of a change the arrows and L/R make.
static void Trainer_Act(EvIvTrainer *app, int hit, int step) {
    int stat = sDisplayStat[app->row];

    if (hit >= HIT_TAB0 && hit <= HIT_TAB2) {
        Trainer_SetPage(app, hit - HIT_TAB0);
        return;
    }
    if (hit == HIT_DONE) {
        Trainer_Done(app);
        return;
    }
    if (hit >= HIT_ROW0 && hit <= HIT_ROW5) {
        int row = hit - HIT_ROW0;
        if (app->page == PAGE_SETS) {
            if (app->setTop + row < app->setCount) {
                Trainer_MoveSet(app, app->setTop + row - app->set);
            }
        } else if (row != app->row) {
            PlaySE(SEQ_SE_DP_SELECT);
            app->row = row;
        }
        return;
    }
    switch (app->page) {
    case PAGE_EV:
        if (hit == HIT_DOWN) {
            Trainer_SetEv(app, stat, app->newEvs[stat] - step);
        } else if (hit == HIT_UP) {
            Trainer_SetEv(app, stat, app->newEvs[stat] + step);
        } else if (hit == HIT_BUTTON1) {
            Trainer_SetEv(app, stat, MAX_EV_PER_STAT);
        } else if (hit == HIT_BUTTON2) {
            Trainer_SetEv(app, stat, 0);
        }
        break;
    case PAGE_IV:
        if (hit == HIT_BUTTON1) {
            Trainer_TrainOne(app);
        } else if (hit == HIT_BUTTON2) {
            Trainer_TrainAll(app);
        }
        break;
    case PAGE_SETS:
        if (hit == HIT_DOWN) {
            Trainer_MoveSet(app, 1);
        } else if (hit == HIT_UP) {
            Trainer_MoveSet(app, -1);
        } else if (hit == HIT_BUTTON1 && app->setCount != 0) {
            // Apply: the set goes to the EV page, to be touched up there.
            memcpy(app->newEvs, sEvIvTrainerSets[app->set].evs, sizeof(app->newEvs));
            PlaySE(SEQ_SE_DP_DECIDE);
            app->page = PAGE_SETS + 1; // not the page shown, so that the next one is drawn
            Trainer_SetPage(app, PAGE_EV);
        }
        break;
    }
}

#define HOLD_DELAY  16
#define HOLD_REPEAT 1

static void Trainer_HandleInput(EvIvTrainer *app) {
    int keys = gSystem.newKeys;
    int repeat = gSystem.newAndRepeatedKeys;
    u32 x, y;
    int hit = HIT_NONE;
    int step = 1;
    u8 page = app->page;
    u8 row = app->row;
    s8 pressed = app->pressed;

#ifdef NEWGOLD_DIAG
    if (app->page == PAGE_DEV) {
        Trainer_DevInput(app);
        return;
    }
    if (app->page == PAGE_SETS && keys & PAD_BUTTON_SELECT) {
        Trainer_SetPage(app, PAGE_DEV);
        return;
    }
#endif

    if (System_GetTouchNewCoords(&x, &y)) {
        hit = Trainer_Touched(app, x, y);
        app->held = (hit == HIT_DOWN || hit == HIT_UP) ? hit : HIT_NONE;
        app->heldFrames = 0;
    } else if (app->held != HIT_NONE && System_GetTouchHeldCoords(&x, &y) && Trainer_Touched(app, x, y) == app->held) {
        // An arrow held down runs.
        if (++app->heldFrames >= HOLD_DELAY && (app->heldFrames - HOLD_DELAY) % HOLD_REPEAT == 0) {
            hit = app->held;
        }
    } else {
        app->held = HIT_NONE;
    }
    app->pressed = app->held;

    if (hit == HIT_NONE) {
        if (keys & PAD_BUTTON_B) {
            Trainer_Back(app);
            return;
        }
        if (keys & PAD_BUTTON_START || (keys & PAD_BUTTON_A && app->page == PAGE_EV)) {
            hit = HIT_DONE;
        } else if (keys & PAD_BUTTON_SELECT) {
            hit = HIT_TAB0 + (app->page + 1) % PAGE_COUNT;
        } else if (keys & (PAD_BUTTON_A | PAD_BUTTON_X)) {
            hit = HIT_BUTTON1;  // Max, Train, Apply
        } else if (keys & PAD_BUTTON_Y) {
            hit = HIT_BUTTON2;  // Clear, Train all
        } else if (repeat & PAD_KEY_UP) {
            if (app->page == PAGE_SETS) {
                hit = HIT_UP;
            } else {
                app->row = (app->row + NUM_STATS - 1) % NUM_STATS;
            }
        } else if (repeat & PAD_KEY_DOWN) {
            if (app->page == PAGE_SETS) {
                hit = HIT_DOWN;
            } else {
                app->row = (app->row + 1) % NUM_STATS;
            }
        } else if (app->page == PAGE_EV && repeat & (PAD_KEY_LEFT | PAD_BUTTON_L)) {
            hit = HIT_DOWN;
            step = (repeat & PAD_BUTTON_L) ? 10 : 1;
        } else if (app->page == PAGE_EV && repeat & (PAD_KEY_RIGHT | PAD_BUTTON_R)) {
            hit = HIT_UP;
            step = (repeat & PAD_BUTTON_R) ? 10 : 1;
        }
        if (app->row != row) {
            PlaySE(SEQ_SE_DP_SELECT);
        }
    }
    if (hit != HIT_NONE) {
        Trainer_Act(app, hit, step);
    }
    if (app->state != STATE_INPUT || app->page != page) {
        return;
    }
    // While an arrow is held only the bottom screen follows it; the top
    // catches up when it is let go.
    if (app->topChanged && app->held == HIT_NONE) {
        Trainer_DrawTop(app);
    }
    if (hit != HIT_NONE || app->row != row || app->pressed != pressed) {
        Trainer_DrawBottom(app);
    }
}

// ---- the message window ----------------------------------------------------------------------

static void Trainer_Ask(EvIvTrainer *app, u8 question) {
    u16 row;

    app->question = question;
    switch (question) {
    case ASK_EVS:
        if (EvIvTrainer_Fee(app->evs, app->newEvs) == 0) {
            row = msg_0829_00050;
        } else {
            BufferIntegerAsString(app->msgFormat, 0, EvIvTrainer_Fee(app->evs, app->newEvs), 6, PRINTING_MODE_LEFT_ALIGN, TRUE);
            row = msg_0829_00049;
        }
        break;
    case ASK_HYPER:
        if (app->gold) {
            BufferItemNameWithIndefArticle(app->msgFormat, 0, ITEM_GOLD_BOTTLE_CAP);
            row = msg_0829_00051;
        } else if (Trainer_PendingCaps(app) == 1) {
            BufferItemNameWithIndefArticle(app->msgFormat, 0, ITEM_BOTTLE_CAP);
            row = msg_0829_00051;
        } else {
            BufferItemNamePlural(app->msgFormat, 0, ITEM_BOTTLE_CAP);
            BufferIntegerAsString(app->msgFormat, 1, Trainer_PendingCaps(app), 1, PRINTING_MODE_LEFT_ALIGN, TRUE);
            row = msg_0829_00052;
        }
        break;
    case ASK_DISCARD:
        row = msg_0829_00055;
        break;
    case SAY_DONE:
        BufferBoxMonNickname(app->msgFormat, 0, Mon_GetBoxMon(app->mon));
        row = msg_0829_00056;
        break;
    case SAY_NO_MONEY:
        row = msg_0829_00053;
        break;
    default: // SAY_NO_CAP
        BufferItemNameWithIndefArticle(app->msgFormat, 0, app->gold ? ITEM_GOLD_BOTTLE_CAP : ITEM_BOTTLE_CAP);
        row = msg_0829_00054;
        break;
    }
    ReadRow(app, row);
    FillWindowPixelBuffer(&app->message, 0xF);
    DrawFrameAndWindow2(&app->message, TRUE, MESSAGE_FRAME_TILE, MESSAGE_FRAME_PLTT);
    app->printer = AddTextPrinterParameterized(&app->message, 1, app->expanded, 0, 0, Options_GetTextFrameDelay(app->options), NULL);
    app->state = STATE_MESSAGE;
}

static void Trainer_ShowYesNo(EvIvTrainer *app) {
    YesNoPromptTemplate template;

    MI_CpuFill8(&template, 0, sizeof(template));
    template.bgConfig = app->bgConfig;
    template.bgId = GF_BG_LYR_SUB_0;
    template.tileStart = YESNO_TILE;
    template.plttSlot = YESNO_PLTT;
    template.x = 25;
    template.y = 16;
    template.initialCursorPos = 0;
    YesNoPrompt_InitFromTemplate(app->yesNo, &template);
    app->state = STATE_YESNO;
}

static void Trainer_CloseMessage(EvIvTrainer *app) {
    ClearFrameAndWindow2(&app->message, TRUE);
    ScheduleBgTilemapBufferTransfer(app->bgConfig, GF_BG_LYR_SUB_0);
    app->state = STATE_INPUT;
}

static void Trainer_Answered(EvIvTrainer *app, BOOL yes) {
    switch (app->question) {
    case ASK_EVS:
        if (yes && app->newTrained != 0) {
            Trainer_Ask(app, ASK_HYPER);
            return;
        }
        // fallthrough
    case ASK_HYPER:
        if (!yes) {
            Trainer_CloseMessage(app);
            return;
        }
        Trainer_Apply(app);
        PlaySE(SEQ_SE_DP_REGI);
        Trainer_ReadMon(app); // what it is now, behind the message
        Trainer_Redraw(app);
        Trainer_Ask(app, SAY_DONE);
        return;
    case ASK_DISCARD:
        if (yes) {
            Trainer_CloseMessage(app);
            app->state = STATE_CLOSE;
            app->substate = 0;
        } else {
            Trainer_CloseMessage(app);
        }
        return;
    case SAY_DONE:
        Trainer_CloseMessage(app);
        app->state = STATE_CLOSE;
        app->substate = 0;
        return;
    default:
        Trainer_CloseMessage(app);
        return;
    }
}

// ---- the app -----------------------------------------------------------------------------------

BOOL EvIvTrainer_Init(OverlayManager *manager, int *state) {
    EvIvTrainerArgs *args = OverlayManager_GetArgs(manager);
    EvIvTrainer *app;
    int i;

    Heap_Create(HEAP_ID_3, HEAP_ID_EV_IV_TRAINER, TRAINER_HEAP_SIZE);
    app = OverlayManager_CreateAndGetData(manager, sizeof(EvIvTrainer), HEAP_ID_EV_IV_TRAINER);
    MI_CpuClearFast(app, sizeof(EvIvTrainer));
    app->heapID = HEAP_ID_EV_IV_TRAINER;
    app->args = args;
    app->saveData = args->fieldSystem->saveData;
    app->party = SaveArray_Party_Get(app->saveData);
    app->bag = Save_Bag_Get(app->saveData);
    app->profile = Save_PlayerData_GetProfile(app->saveData);
    app->options = Save_PlayerData_GetOptionsAddr(app->saveData);
    app->partyArgs = Heap_Alloc(app->heapID, sizeof(PartyMenuArgs));
    app->preview = AllocMonZeroed(app->heapID);
    // Read whole: a redraw reads a hundred rows, and a lazy bank goes to the card for each.
    app->msgData = NewMsgDataFromNarc(MSGDATA_LOAD_DIRECT, NARC_msgdata_msg, NARC_msg_msg_0829_bin, app->heapID);
    app->setNames = NewMsgDataFromNarc(MSGDATA_LOAD_DIRECT, NARC_msgdata_msg, EV_IV_TRAINER_SETS_BANK, app->heapID);
    app->msgFormat = MessageFormat_New(app->heapID);
    app->string = String_New(128, app->heapID);
#ifdef NEWGOLD_DIAG
    app->devMsg = NewMsgDataFromNarc(MSGDATA_LOAD_LAZY, NARC_msgdata_msg, NARC_msg_msg_0550_T21_bin, app->heapID);
#endif
    app->expanded = String_New(128, app->heapID);
    for (i = 0; sEvIvTrainerSets[i].name != EV_IV_TRAINER_SETS_END; i++) { }
    app->setCount = i;
    app->state = STATE_CHOOSE;
    Trainer_StartPartyMenu(app);
    return TRUE;
}

BOOL EvIvTrainer_Main(OverlayManager *manager, int *state) {
    EvIvTrainer *app = OverlayManager_GetData(manager);

    switch (app->state) {
    case STATE_CHOOSE:
        if (!Trainer_RunPartyMenu(app)) {
            break;
        }
        if (app->partyArgs->partySlot >= Party_GetCount(app->party)) {
            app->state = STATE_EXIT;
            break;
        }
        app->slot = app->partyArgs->partySlot;
        app->page = PAGE_EV;
        app->row = 0;
        app->set = 0;
        app->setTop = 0;
        Trainer_ReadMon(app);
        Trainer_OpenScreens(app);
        BeginNormalPaletteFade(FADE_BOTH_SCREENS, FADE_TYPE_BRIGHTNESS_IN, FADE_TYPE_BRIGHTNESS_IN, RGB_BLACK, 6, 1, app->heapID);
        app->state = STATE_OPEN;
        break;
    case STATE_OPEN:
        if (IsPaletteFadeFinished()) {
            app->state = STATE_INPUT;
        }
        break;
    case STATE_INPUT:
        Trainer_HandleInput(app);
        break;
    case STATE_MESSAGE:
        if (TextPrinterCheckActive(app->printer)) {
            break;
        }
        if (app->question <= ASK_DISCARD) {
            Trainer_ShowYesNo(app);
        } else {
            app->state = STATE_WAIT_BUTTON;
        }
        break;
    case STATE_YESNO:
        switch (YesNoPrompt_HandleInput(app->yesNo)) {
        case YESNORESPONSE_YES:
            YesNoPrompt_Reset(app->yesNo);
            Trainer_Answered(app, TRUE);
            break;
        case YESNORESPONSE_NO:
            YesNoPrompt_Reset(app->yesNo);
            Trainer_Answered(app, FALSE);
            break;
        default:
            break;
        }
        break;
    case STATE_WAIT_BUTTON:
        if (gSystem.newKeys & (PAD_BUTTON_A | PAD_BUTTON_B) || System_GetTouchNew()) {
            PlaySE(SEQ_SE_DP_SELECT);
            Trainer_Answered(app, TRUE);
        }
        break;
    case STATE_CLOSE:
        if (app->substate == 0) {
            BeginNormalPaletteFade(FADE_BOTH_SCREENS, FADE_TYPE_BRIGHTNESS_OUT, FADE_TYPE_BRIGHTNESS_OUT, RGB_BLACK, 6, 1, app->heapID);
            app->substate = 1;
        } else if (IsPaletteFadeFinished()) {
            Trainer_CloseScreens(app);
            app->state = STATE_CHOOSE;
            Trainer_StartPartyMenu(app);
        }
        break;
    case STATE_EXIT:
        return TRUE;
    }
    return FALSE;
}

BOOL EvIvTrainer_Exit(OverlayManager *manager, int *state) {
    EvIvTrainer *app = OverlayManager_GetData(manager);

    Trainer_CloseScreens(app);
    *app->args->trained = app->trainedCount;
    String_Delete(app->expanded);
    String_Delete(app->string);
    MessageFormat_Delete(app->msgFormat);
    DestroyMsgData(app->setNames);
#ifdef NEWGOLD_DIAG
    DestroyMsgData(app->devMsg);
#endif
    DestroyMsgData(app->msgData);
    Heap_Free(app->preview);
    Heap_Free(app->partyArgs);
    OverlayManager_FreeData(manager);
    Heap_Destroy(HEAP_ID_EV_IV_TRAINER);
    return TRUE;
}
