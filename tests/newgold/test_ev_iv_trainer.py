#!/usr/bin/env python3
"""The EV/IV trainer's rules, compiled from src/ev_iv_trainer_rules.c.

EVs: 252 a stat and 510 in all (Pokemon Central, Punti base), which is all
the Max button and the arrows may reach. The fee: 500 for every started ten
EVs a stat gains, as the Mochi that add ten to one stat cost, so a spread of
4, 252 and 252 from nothing is 1 + 26 + 26 tens, 26,500; taking EVs away is
free. The Judge's scale is the latest games'. Hyper Training (Allenamento
Pro) as Scarlet and Violet have it: from level 50, never a stat at 31 or one
already trained.

The app's screens and its texts are checked here too, in what can be read
without the game: every row the app prints exists and fits where it goes.
"""

import os
from pathlib import Path
import re
import shlex
import struct
import subprocess
import tempfile
import unittest

from test_repels import ROOT, function, read

FIXTURE = r"""
#include <assert.h>
#include <stdint.h>
#include "constants/pokemon.h"
typedef uint8_t u8;
typedef uint16_t u16;
typedef uint32_t u32;
typedef int BOOL;
@HEADER@
@RULES@

static u32 Fee(int hp, int atk, int def, int spe, int spa, int spd) {
    static const u8 none[NUM_STATS] = { 0 };
    u8 after[NUM_STATS] = { hp, atk, def, spe, spa, spd };
    return EvIvTrainer_Fee(none, after);
}

int main(void) {
    // 252 a stat, 510 in all.
    u8 evs[NUM_STATS] = { 0 };
    assert(EvIvTrainer_EvRoom(evs, STAT_HP) == 252);
    evs[STAT_HP] = 252;
    evs[STAT_ATK] = 252;
    assert(EvIvTrainer_EvRoom(evs, STAT_HP) == 0);
    assert(EvIvTrainer_EvRoom(evs, STAT_DEF) == 6);
    evs[STAT_DEF] = 6;
    assert(EvIvTrainer_EvRoom(evs, STAT_SPEED) == 0);
    evs[STAT_ATK] = 100;
    assert(EvIvTrainer_EvRoom(evs, STAT_ATK) == 152);

    // The fee: started tens of each stat that gains.
    assert(Fee(0, 0, 0, 0, 0, 0) == 0);
    assert(Fee(1, 0, 0, 0, 0, 0) == 500);
    assert(Fee(10, 0, 0, 0, 0, 0) == 500);
    assert(Fee(11, 0, 0, 0, 0, 0) == 1000);
    assert(Fee(4, 0, 0, 252, 252, 0) == 26500);
    assert(Fee(1, 1, 1, 1, 1, 1) == 3000);
    {
        // The mockup's: Attack 18 to 0, Sp. Atk 40 to 252 -- 22 tens; the loss is free.
        u8 before[NUM_STATS] = { 12, 18, 6, 52, 40, 8 };
        u8 after[NUM_STATS] = { 12, 0, 6, 52, 252, 8 };
        assert(EvIvTrainer_Fee(before, after) == 11000);
        assert(EvIvTrainer_Fee(after, before) == 1000);
        assert(EvIvTrainer_Fee(before, before) == 0);
    }

    // The latest games' Judge.
    assert(EvIvTrainer_JudgeRank(0) == JUDGE_NO_GOOD);
    assert(EvIvTrainer_JudgeRank(1) == JUDGE_DECENT && EvIvTrainer_JudgeRank(15) == JUDGE_DECENT);
    assert(EvIvTrainer_JudgeRank(16) == JUDGE_PRETTY_GOOD && EvIvTrainer_JudgeRank(25) == JUDGE_PRETTY_GOOD);
    assert(EvIvTrainer_JudgeRank(26) == JUDGE_VERY_GOOD && EvIvTrainer_JudgeRank(29) == JUDGE_VERY_GOOD);
    assert(EvIvTrainer_JudgeRank(30) == JUDGE_FANTASTIC);
    assert(EvIvTrainer_JudgeRank(31) == JUDGE_BEST);

    // Hyper Training: level 50, a stat under 31 that is not trained yet.
    assert(!EvIvTrainer_CanHyperTrain(49, 10, 0, STAT_HP));
    assert(EvIvTrainer_CanHyperTrain(50, 10, 0, STAT_HP));
    assert(EvIvTrainer_CanHyperTrain(100, 30, 0, STAT_SPDEF));
    assert(!EvIvTrainer_CanHyperTrain(100, 31, 0, STAT_SPDEF));
    assert(!EvIvTrainer_CanHyperTrain(100, 3, MON_HYPER_TRAINED_BIT(STAT_SPDEF), STAT_SPDEF));
    assert(EvIvTrainer_CanHyperTrain(100, 3, MON_HYPER_TRAINED_BIT(STAT_SPATK), STAT_SPDEF));
    return 0;
}
"""


def header():
    """ev_iv_trainer.h's constants and its enum, without the game's headers."""
    text = read("include/ev_iv_trainer.h")
    keep = re.findall(r"^#define EV_TRAINER_\w+ .*$", text, re.M)
    keep.append(re.search(r"enum JudgeRank \{.*?\};", text, re.S).group(0))
    return "\n".join(keep)


PREVIEW = r"""
#include <assert.h>
#include <stddef.h>
#include <stdint.h>
#include "constants/pokemon.h"
typedef uint8_t u8;
typedef uint16_t u16;
typedef uint32_t u32;
typedef int BOOL;
#define TRUE 1
#define MINT 0x3E       // pokemon.c's MON_MINT_NATURE_MASK
enum { PAGE_EVS, PAGE_SETS };
typedef struct { u16 flags; u8 evs[NUM_STATS]; u16 stats[NUM_STATS]; } Pokemon;
static const struct { u8 evs[NUM_STATS]; } sEvIvTrainerSets[1];
typedef struct {
    Pokemon *mon, *preview;
    u8 page, set, setCount, newEvs[NUM_STATS];
    u16 newStats[NUM_STATS];
    u32 trained, newTrained;
    BOOL topChanged;
} EvIvTrainer;

static void CopyPokemonToPokemon(Pokemon *src, Pokemon *dest) { *dest = *src; }
static u32 GetMonData(Pokemon *mon, int attr, void *dest) {
    (void)dest;
    if (attr == MON_DATA_UNUSED_114) return mon->flags;
    return mon->stats[attr == MON_DATA_MAX_HP ? STAT_HP : attr - MON_DATA_ATK + 1];
}
static void SetMonData(Pokemon *mon, int attr, const void *value) {
    if (attr == MON_DATA_UNUSED_114) mon->flags = *(const u16 *)value;
    else mon->evs[attr - MON_DATA_HP_EV] = *(const u8 *)value;
}
// A Mint for Adamant raises Attack and lowers Sp. Atk; a trained stat adds 5.
static void CalcMonStats(Pokemon *mon) {
    for (int stat = 0; stat < NUM_STATS; stat++) {
        int value = 100 + mon->evs[stat] / 4;
        if (mon->flags & MINT) value += stat == STAT_ATK ? 10 : stat == STAT_SPATK ? -10 : 0;
        if (mon->flags & MON_HYPER_TRAINED_BIT(stat)) value += 5;
        mon->stats[stat] = value;
    }
}
@APP@
int main(void) {
    Pokemon mon = { .flags = MINT | MON_HYPER_TRAINED_BIT(STAT_DEF) }, preview;
    EvIvTrainer app = { &mon, &preview, PAGE_EVS };
    CalcMonStats(&mon);
    app.trained = mon.flags & MON_HYPER_TRAINED_ALL;
    Trainer_UpdatePreview(&app);
    for (int stat = 0; stat < NUM_STATS; stat++) assert(app.newStats[stat] == mon.stats[stat]);
    app.newTrained = MON_HYPER_TRAINED_BIT(STAT_ATK);
    Trainer_UpdatePreview(&app);
    assert(app.newStats[STAT_ATK] == mon.stats[STAT_ATK] + 5 && app.newStats[STAT_SPATK] == mon.stats[STAT_SPATK]);
    assert(mon.flags == (MINT | MON_HYPER_TRAINED_BIT(STAT_DEF)));
    return 0;
}
"""


HOLD = r"""
#include <assert.h>
#include <stdint.h>
typedef uint8_t u8;
typedef int8_t s8;
typedef uint32_t u32;
typedef int BOOL;
#define TRUE 1
#define FALSE 0
#define NUM_STATS 6
enum { PAD_BUTTON_A = 1, PAD_BUTTON_B = 2, PAD_BUTTON_X = 4, PAD_BUTTON_Y = 8, PAD_BUTTON_L = 16, PAD_BUTTON_R = 32,
       PAD_BUTTON_START = 64, PAD_BUTTON_SELECT = 128, PAD_KEY_UP = 256, PAD_KEY_DOWN = 512, PAD_KEY_LEFT = 1024,
       PAD_KEY_RIGHT = 2048, SEQ_SE_DP_SELECT = 0 };
@ENUMS@
typedef struct { int state; u8 page, row; s8 held, pressed; u8 heldFrames; BOOL topChanged; } EvIvTrainer;
static struct { int newKeys, newAndRepeatedKeys; } gSystem;
static BOOL newTouch, touching;
static int steps, topDraws;
static BOOL System_GetTouchNewCoords(u32 *x, u32 *y) { *x = *y = 0; return newTouch; }
static BOOL System_GetTouchHeldCoords(u32 *x, u32 *y) { *x = *y = 0; return touching; }
static int Trainer_Touched(EvIvTrainer *app, u32 x, u32 y) { (void)app; (void)x; (void)y; return HIT_UP; }
static void Trainer_Act(EvIvTrainer *app, int hit, int step) { assert(hit == HIT_UP); steps += step; app->topChanged = TRUE; }
static void Trainer_Back(EvIvTrainer *app) { (void)app; assert(0); }
static void Trainer_DrawTop(EvIvTrainer *app) { topDraws++; app->topChanged = FALSE; }
static void Trainer_DrawBottom(EvIvTrainer *app) { (void)app; }
static void PlaySE(int se) { (void)se; }
@APP@
int main(void) {
    EvIvTrainer app = { STATE_INPUT, PAGE_EV, 0, HIT_NONE, HIT_NONE, 0, FALSE };
    newTouch = touching = TRUE;         // the up arrow touched: one step
    Trainer_HandleInput(&app);
    newTouch = FALSE;                   // then held for 60 frames: after 16, one step a frame
    for (int frame = 1; frame <= 60; frame++) {
        Trainer_HandleInput(&app);
        assert(steps == 1 + (frame >= 16 ? frame - 15 : 0));
    }
    assert(topDraws == 0);              // the top screen waits while the arrow is held
    touching = FALSE;
    Trainer_HandleInput(&app);
    assert(steps == 46 && topDraws == 1 && app.held == HIT_NONE);
    return 0;
}
"""

BALL = r"""
#include <assert.h>
#include <stddef.h>
#include <stdint.h>
#include "constants/balls.h"
typedef uint8_t u8;
#define MON_DATA_POKEBALL 0
#define NARC_a_1_6_2 0
#define GF_PAL_LOCATION_MAIN_BG 0
#define GF_PAL_SLOT_10_OFFSET 0
#define FALSE 0
typedef struct { void *ballRaw, *ball; int heapID; } EvIvTrainer;
// The summary's table runs to the Sport Ball: a read past it is caught (ASan).
const u8 _02104C68[BALL_SPORT + 1] = { [BALL_POKE] = 7, [BALL_SPORT] = 3 };
static int caught, member, palette;
static int GetMonData(void *mon, int attr, void *dest) { (void)mon; (void)attr; (void)dest; return caught; }
static void *GfGfxLoader_GetCharData(int narc, int which, int compressed, void **out, int heap) {
    (void)narc; (void)compressed; (void)heap; member = which; *out = NULL; return NULL;
}
static void GfGfxLoader_GXLoadPal(int narc, int which, int where, int offset, int size, int heap) {
    (void)narc; (void)where; (void)offset; (void)size; (void)heap; palette = which;
}
static void Ball(EvIvTrainer *app, void *mon) {
    @BALL@
}
static void Check(int ball, int wantMember, int wantPalette) {
    EvIvTrainer app = { 0 };
    caught = ball;
    Ball(&app, NULL);
    assert(member == wantMember && palette == wantPalette);
}
int main(void) {
    Check(BALL_NONE, 25, 49 + _02104C68[BALL_NONE]);
    Check(BALL_POKE, BALL_POKE + 24, 49 + 7);
    Check(BALL_SPORT, BALL_SPORT + 24, 49 + 3);
    Check(BALL_PARK, BALL_POKE + 24, 49 + 7);       // past the Sport Ball: a Poke Ball's icon
    Check(BALL_SPORT + 40, BALL_POKE + 24, 49 + 7);
    return 0;
}
"""


MARKINGS = r"""
#include <assert.h>
#include <stddef.h>
#include <stdint.h>
typedef uint8_t u8;
typedef int BOOL;
#define MON_DATA_MARKINGS 0
#define TILE_SIZE_4BPP 32
typedef struct { int unused; } Window;
typedef struct { void *mon; u8 markTiles[6][2 * TILE_SIZE_4BPP]; } EvIvTrainer;
@DEFINES@
static int sMarkings, sDrawn;
static int GetMonData(void *mon, int attr, void *dest) { (void)mon; (void)attr; (void)dest; return sMarkings; }
static EvIvTrainer sApp;
static void BlitTiles(Window *window, const u8 *tiles, int tw, int th, int columns, int x, int y, u8 base) {
    int marking = (int)(tiles - sApp.markTiles[0]) / (2 * TILE_SIZE_4BPP);
    int set = (int)(tiles - sApp.markTiles[marking]) / TILE_SIZE_4BPP;
    (void)window;
    assert(tw == 1 && th == 1 && columns == 1);
    assert(x == 196 + 8 * marking && y == 146);
    // Each tile's pixels: 14 not set, 1 set, landing on the two colours.
    assert(set == ((sMarkings >> marking) & 1));
    assert(base + (set ? 1 : 14) == (set ? COL_MARK_ON : COL_MARK_OFF));
    sDrawn |= 1 << marking;
}
@DRAW@
int main(void) {
    static Window win;
    for (sMarkings = 0; sMarkings < 64; sMarkings++) {
        sDrawn = 0;
        DrawMarkings(&sApp, &win);
        assert(sDrawn == 63);
    }
    return 0;
}
"""


def run_c(source, *flags):
    with tempfile.TemporaryDirectory(prefix="newgold-trainer-") as directory:
        path = Path(directory)
        (path / "check.c").write_text(source)
        subprocess.run(shlex.split(os.environ.get("CC", "cc")) + [
            "-std=c99", "-Wall", "-Werror", "-Wno-unused-function", "-O1", *flags,
            "-iquote", str(ROOT / "include"), str(path / "check.c"), "-o", str(path / "check")], check=True)
        subprocess.run([str(path / "check")], cwd=directory, check=True)


class RulesTests(unittest.TestCase):
    def test_the_rules(self):
        rules = read("src/ev_iv_trainer_rules.c")
        body = "\n".join(function(rules, name) for name in (
            "EvIvTrainer_EvRoom", "EvIvTrainer_Fee", "EvIvTrainer_JudgeRank", "EvIvTrainer_CanHyperTrain"))
        source = FIXTURE.replace("@HEADER@", header()).replace("@RULES@", body)
        with tempfile.TemporaryDirectory(prefix="newgold-trainer-") as directory:
            path = Path(directory)
            (path / "check.c").write_text(source)
            subprocess.run(shlex.split(os.environ.get("CC", "cc")) + [
                "-std=c99", "-Wall", "-Wextra", "-Werror", "-Wno-unused-function", "-O2",
                "-iquote", str(ROOT / "include"), str(path / "check.c"), "-o", str(path / "check")], check=True)
            subprocess.run([str(path / "check")], cwd=directory, check=True)

    def test_the_preview_keeps_a_mint(self):
        """The top screen's projected stats are the Pokemon's own while
        nothing changes, a Mint's nature included (it shares the field with
        Hyper Training's bits)."""
        app = read("src/ev_iv_trainer_app.c")
        body = "\n".join(function(app, name) for name in ("Trainer_ShownEvs", "Trainer_UpdatePreview"))
        run_c(PREVIEW.replace("@APP@", body))

    def test_a_held_arrow_runs_and_the_top_waits(self):
        """A held arrow, after 16 frames, steps every frame (Speed 52 to 68
        in a second, 5fec2af87), and the top screen is redrawn once it is
        let go, not while it is held."""
        app = read("src/ev_iv_trainer_app.c")
        enums = "\n".join(re.search(rf"enum {name} \{{.*?\}};", app, re.S).group(0)
                          for name in ("TrainerPage", "TrainerState", "TrainerHitbox"))
        body = "\n".join(re.findall(r"^#define HOLD_\w+ .*$", app, re.M)) + "\n" + function(app, "Trainer_HandleInput")
        run_c(HOLD.replace("@ENUMS@", enums).replace("@APP@", body))

    def test_the_ball_beside_the_name(self):
        """The ball it was caught in, as the summary draws it: member ball +
        24 of a/1/6/2 (25 with none) and the summary's palette for it; past
        the Sport Ball, where the summary's icons end, a Poke Ball's
        (e4c336181)."""
        app = read("src/ev_iv_trainer_app.c")
        start = app.index("        int ball = GetMonData(app->mon, MON_DATA_POKEBALL, NULL);")
        block = app[start:app.index("\n    }\n", start)].replace("app->mon", "mon")
        run_c(BALL.replace("@BALL@", block), "-fsanitize=address,undefined", "-fno-sanitize-recover=all")

    def test_the_markings_under_the_picture(self):
        """Mockup A's name box has the summary's six markings under the
        picture: each its own tile, set or not, where the summary's sprites 23
        to 28 put them, in the summary's two colours."""
        app = read("src/ev_iv_trainer_app.c")
        defines = "\n".join(re.findall(r"^#define (?:PLTT_OWN|COL_MARK_\w+) .*$", app, re.M))
        self.assertEqual(len(defines.splitlines()), 3)
        run_c(MARKINGS.replace("@DEFINES@", defines).replace("@DRAW@", function(app, "DrawMarkings")))
        # The two colours are the summary's (a/1/6/2 member 61, entries 14 and 1).
        own = app[app.index("static const u16 sOwnColours[16] = {"):]
        own = re.findall(r"RGB\((\d+), (\d+), (\d+)\)", own[:own.index("};")])
        self.assertEqual(own[9:11], [("23", "23", "20"), ("9", "8", "7")])

    def test_the_developer_page_lights_the_sets_tab(self):
        """The diagnostics build's developer page, reached from the Sets by
        SELECT, has no tab of its own: it keeps the Sets' plates, whose Sets
        tab is lit, and the Sets' label white, where it had the EV page's
        plates, the EV tab lit and every label dark."""
        app = read("src/ev_iv_trainer_app.c")
        table = app[app.index("static const u16 sPagePlates[TRAINER_PAGES][2] = {"):]
        table = table[:table.index("};")]
        plain, diag = table.split("#ifdef NEWGOLD_DIAG")
        rows = re.findall(r"\{ (\d+), (\d+) \}", plain)
        self.assertEqual(re.findall(r"\{ (\d+), (\d+) \}", diag), [rows[2]])   # PAGE_SETS's
        self.assertIn("#define TAB_LIT(app)  ((app)->page == PAGE_DEV ? PAGE_SETS : (app)->page)", app)
        self.assertIn("t == TAB_LIT(app) ? TEXT_WHITE : TEXT_DARK", function(app, "DrawTabs"))

    def test_the_app_writes_only_what_was_confirmed(self):
        """The Pokemon is written in one place, after the YES, and the money
        and the caps are spent there too."""
        app = read("src/ev_iv_trainer_app.c")
        writes = [m.start() for m in re.finditer(r"SetMonData\(app->mon,", app)]
        apply = function(app, "Trainer_Apply")
        start = app.index(apply)
        self.assertTrue(writes and all(start <= w < start + len(apply) for w in writes), "a write outside Trainer_Apply")
        self.assertIn("PlayerProfile_SubMoney(app->profile, fee)", apply)
        self.assertIn("Bag_TakeItem(app->bag, ITEM_GOLD_BOTTLE_CAP, 1", apply)
        self.assertIn("CalcMonStats(app->mon)", apply)
        answered = function(app, "Trainer_Answered")
        self.assertIn("Trainer_Apply(app)", answered)


# The narrow font and the system one, as the app prints with them.
FONTS = {0: "font_00000000.bin", 5: "font_00000010.bin"}


def widths(font):
    data = (ROOT / "files/graphic/font" / FONTS[font]).read_bytes()
    header, width_at, glyphs = struct.unpack_from("<III", data, 0)
    return data[width_at:width_at + glyphs]


def charmap():
    out = {}
    for line in (ROOT / "charmap.txt").read_text(encoding="utf-8").splitlines():
        code, sep, text = line.partition("=")
        if sep and len(text) == 1 and text not in out:
            try:
                out[text] = int(code.strip(), 16)
            except ValueError:
                pass
    out[" "] = 0x1DE
    return out


def width(text, font):
    table, codes = widths(font), charmap()
    text = re.sub(r"\{[^}]*\}", "000", text)   # a number or a name: three digits' room
    return sum(table[codes.get(ch, 0x1AC) - 1] for ch in text)


def rows(bank):
    text = (ROOT / "files/msgdata/msg" / bank).read_text(encoding="utf-8")
    return {int(i): body for i, body in re.findall(r'<row id="[^"]*" index="(\d+)">.*?<language name="English">(.*?)</language>', text, re.S)}


class TextTests(unittest.TestCase):
    """The rows the app prints and where they go: (font, pixels there)."""

    ROOM = {
        0: (0, 90),                    # the title, top right
        **{r: (0, 43) for r in range(12, 18)},     # the stat names, from x 8 in a label cell ending at 51
        **{r: (0, 84) for r in range(30, 36)},     # the Judge's words, in a row's value cell
        36: (5, 76),                   # Hyper trained!, small, before the IV
        37: (5, 132), 38: (5, 132),    # the two lines under the IV page's rows
        47: (5, 132), 64: (5, 132),
        39: (0, 50), 40: (5, 50), 25: (5, 50), 26: (5, 50), 43: (5, 50),   # the blue buttons
        27: (5, 90), 24: (5, 90),
        1: (0, 88), 2: (0, 88), 3: (0, 88),   # the bottom screen's headers
        48: (0, 130),
    }

    def test_every_row_the_app_names_exists(self):
        app = read("src/ev_iv_trainer_app.c")
        bank = rows("msg_0829.gmm")
        for row in set(re.findall(r"msg_0829_(\d{5})", app)):
            self.assertIn(int(row), bank, f"msg_0829_{row} has no row")

    def test_the_rows_fit_where_they_are_printed(self):
        bank = rows("msg_0829.gmm")
        for row, (font, room) in self.ROOM.items():
            for line in bank[row].split("\\n"):
                self.assertLessEqual(width(line, font), room, f"msg_0829 row {row} {line!r} in font {font}")

    def test_the_message_window_lines_fit(self):
        """The confirmation window is 22 tiles, 176 pixels of the message font."""
        bank = rows("msg_0829.gmm")
        for row in (49, 50, 51, 52, 53, 54, 55, 56):
            for line in bank[row].split("\\n"):
                self.assertLessEqual(width(line, 0), 170, f"msg_0829 row {row} {line!r}")


class ShopTests(unittest.TestCase):
    def test_a_mart_opens_with_the_script_s_box_let_go(self):
        """The mart clears the rows of the box (MartData_InitCamera), so a
        script lets its box go first, HoldMsg or CloseMsg, as every retail
        mart does (std_mart_intro's callers, the Pokeathlon Dome's): a box
        still held open is printed into after the mart without its frame
        (the EV/IV trainer's 'Come back anytime!', 5fec2af87)."""
        marts = ("MartBuy", "SpecialMartBuy", "MartSell", "DecorationMart", "SealMart", "ScrCmd_771", "ScrCmd_772")
        for path in sorted((ROOT / "files/fielddata/script/scr_seq").glob("*.s")):
            before = None     # the last box command since the label
            for number, line in enumerate(path.read_text().splitlines(), 1):
                if re.match(r"\w+:", line):
                    before = None
                command = re.match(r"\s+(\w+)", line)
                if not command:
                    continue
                if "Msg" in command.group(1):
                    before = command.group(1)
                elif command.group(1) in marts:
                    self.assertIn(before, (None, "HoldMsg", "CloseMsg"), f"{path.name}:{number}")


if __name__ == "__main__":
    unittest.main()
