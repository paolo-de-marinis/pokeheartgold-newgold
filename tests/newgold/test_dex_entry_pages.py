#!/usr/bin/env python3
"""Run the Dex entry's pages (DexEntryPages) on the host, with sanitizers.

The functions are cut from src/application/pokedex/ov18_021EE984.c, their
struct and prototypes from dex_entry_pages.h, and compiled against stand-ins
for the String, the Window, the font and the tilemap: a character is its code % 7 + 3
pixels wide, the window is the Info page's, 28 tiles at (2, 17) from tile
0x30A, and ScheduleWindowCopyToVram puts the window's first tile in its first
cell, as the game's does. Every drawing is logged with its x, and the Strings
still alive are counted, so the log says what the Dex shows each frame and
whether the pages keep what they should and free the rest.
"""

import os
from pathlib import Path
import re
import shlex
import subprocess
import tempfile
import unittest

from test_level_cap import ROOT

SOURCE = ROOT / "src/application/pokedex/ov18_021EE984.c"
HEADER = ROOT / "include/application/pokedex/dex_entry_pages.h"
WIDTH = 28 * 8

PREFIX = r'''
#include <assert.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

typedef uint8_t u8;
typedef uint16_t u16;
typedef uint32_t u32;
typedef int BOOL;
#define TRUE 1
#define FALSE 0
#define CHAR_LF 0xE000
#define EOS 0xFFFF
#define MAKE_TEXT_COLOR(fg, shadow, bg) 0
enum HeapID { HEAP_ID_TEST = 7 };

typedef struct BgConfig { u16 tilemap[32 * 32]; } BgConfig;
typedef struct Window {
    BgConfig *bgConfig;
    u8 bgId, tilemapLeft, tilemapTop, width, height, paletteNum;
    u16 baseTile;
} Window;
typedef struct String { u16 maxsize, size; u16 data[]; } String;

static int live;

static String *String_New(u32 maxsize, enum HeapID heapId) {
    assert(heapId == HEAP_ID_TEST);
    String *s = malloc(sizeof(String) + (maxsize + 1) * sizeof(u16));
    s->maxsize = maxsize;
    s->size = 0;
    s->data[0] = EOS;
    live++;
    return s;
}
static void String_Delete(String *s) { live--; free(s); }
static u16 String_GetLength(String *s) { return s->size; }
static u16 *String_cstr(String *s) { return s->data; }
static void String_AddChar(String *s, u16 c) {
    assert(s->size + 1 < s->maxsize);
    s->data[s->size++] = c;
    s->data[s->size] = EOS;
}
static void String_Cat(String *dest, String *src) {
    assert(dest->size + src->size + 1 <= dest->maxsize);
    memcpy(dest->data + dest->size, src->data, (src->size + 1) * sizeof(u16));
    dest->size += src->size;
}
// pm_string.c's
static void String_GetLineN(String *dest, String *src, u32 n) {
    int i = 0;
    if (n != 0) {
        for (i = 0; i < src->size; i++) {
            if (src->data[i] == CHAR_LF && --n == 0) {
                i++;
                break;
            }
        }
    }
    dest->size = 0;
    dest->data[0] = EOS;
    for (; i < src->size && src->data[i] != CHAR_LF; i++) {
        String_AddChar(dest, src->data[i]);
    }
}

static u8 GetWindowWidth(Window *window) { return window->width; }
static void *GetBgTilemapBuffer(BgConfig *bgConfig, u8 bgId) { return bgConfig->tilemap; }
static u32 FontID_String_GetWidthMultiline(u32 fontId, String *s, u32 spacing) {
    u32 widest = 0, width = 0;
    for (int i = 0; i < s->size; i++) {
        if (s->data[i] == CHAR_LF) {
            width = 0;
        } else if ((width += s->data[i] % 7 + 3) > widest) {
            widest = width;
        }
    }
    return widest;
}
static void FillWindowPixelBuffer(Window *window, u8 fill) { }
static void ov18_021F95FC(Window *window, String *s, int x, int y, int fontId, u32 color, int alignment) {
    printf("draw %d ", x);
    for (int i = 0; i < s->size; i++) {
        putchar(s->data[i] == CHAR_LF ? '|' : s->data[i]);
    }
    putchar('\n');
}
static void ScheduleWindowCopyToVram(Window *window) {
    window->bgConfig->tilemap[window->tilemapTop * 32 + window->tilemapLeft] = window->baseTile | (window->paletteNum << 12);
}

@PAGES@

static String *entry(const char *text) {
    String *s = String_New(256, HEAP_ID_TEST);
    for (; *text; text++) {
        String_AddChar(s, *text == '|' ? CHAR_LF : *text);
    }
    return s;
}

int main(void) {
    static BgConfig bg;
    Window window = { &bg, 5, 2, 17, 28, 6, 1, 0x30A };
    DexEntryPages pages = { 0 };
    char line[512];

    // One command a line: "print TEXT" (as ov18_021EE984 prints), "frames N"
    // (the Dex's frames), "clear" (the page clears the window's tilemap),
    // "stop"; after each, the Strings alive.
    while (fgets(line, sizeof(line), stdin)) {
        line[strcspn(line, "\n")] = 0;
        if (strncmp(line, "print ", 6) == 0) {
            DexEntryPages_Print(&pages, &window, entry(line + 6), HEAP_ID_TEST);
            ScheduleWindowCopyToVram(&window);
        } else if (strncmp(line, "frames ", 7) == 0) {
            for (int n = atoi(line + 7), i = 1; i <= n; i++) {
                printf("frame %d\n", i);
                DexEntryPages_Update(&pages);
            }
        } else if (strcmp(line, "clear") == 0) {
            bg.tilemap[window.tilemapTop * 32 + window.tilemapLeft] = 0;
        } else if (strcmp(line, "stop") == 0) {
            DexEntryPages_Stop(&pages);
        }
        printf("live %d\n", live);
    }
    // As the Dex does before it removes the window: then nothing is left.
    DexEntryPages_Stop(&pages);
    return live;
}
'''


def pages_code():
    source = SOURCE.read_text()
    header = HEADER.read_text()
    declarations = header[header.index("typedef struct DexEntryPages {"):header.index("#endif")]
    functions = source[source.index("#define DEX_ENTRY_PAGE_LINES"):source.index("// A species' Dex entry")]
    return declarations + functions


FRAMES = int(re.search(r"#define DEX_ENTRY_PAGE_FRAMES (\d+)", SOURCE.read_text()).group(1))


def width(text):
    return max(sum(ord(c) % 7 + 3 for c in line) for line in text.split("|"))


def centred(text):
    return max(0, (WIDTH - width(text)) // 2)


class DexEntryPagesTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.temp = tempfile.TemporaryDirectory(prefix="newgold-dex-pages-")
        c, cls.exe = Path(cls.temp.name) / "pages.c", Path(cls.temp.name) / "pages"
        c.write_text(PREFIX.replace("@PAGES@", pages_code()))
        result = subprocess.run(shlex.split(os.environ.get("CC", "cc")) + ["-std=c11", "-O1", "-g", "-fsanitize=address,undefined", "-fno-omit-frame-pointer", "-Wno-unused-function", "-Wno-unused-parameter", str(c), "-o", str(cls.exe)], capture_output=True, text=True)
        assert result.returncode == 0, result.stderr

    @classmethod
    def tearDownClass(cls):
        cls.temp.cleanup()

    def run_pages(self, *commands):
        """What was drawn, as (frame, x, text), and the Strings alive after
        each command."""
        result = subprocess.run([str(self.exe)], input="\n".join(commands) + "\n", capture_output=True, text=True,
                                env={**os.environ, "ASAN_OPTIONS": "detect_leaks=1", "UBSAN_OPTIONS": "halt_on_error=1"})
        self.assertEqual(result.returncode, 0, result.stderr)
        drawn, live, frame = [], [], 0
        for line in result.stdout.splitlines():
            word, _, rest = line.partition(" ")
            if word == "frame":
                frame = int(rest)
            elif word == "draw":
                x, _, text = rest.partition(" ")
                drawn.append((frame, int(x), text))
            else:
                live.append(int(rest))
                frame = 0
        return drawn, live

    def test_the_period_is_five_seconds_of_the_dex(self):
        """The Dex and the capture page's task run 30 frames a second."""
        self.assertEqual(FRAMES, 5 * 30)

    def test_three_lines_are_drawn_once_and_kept_nowhere(self):
        for text in ("The seed on its back|is filled with nutrients.|It grows.", "One line.", "A|B|C|"):
            drawn, live = self.run_pages(f"print {text}", f"frames {FRAMES * 3}")
            self.assertEqual(drawn, [(0, centred(text), text)], text)
            self.assertEqual(live, [0, 0], text)

    def test_more_lines_turn_every_period_and_back(self):
        text = "It resembles a mysterious object|introduced in a paranormal|magazine as a cutting-edge|weapon shaped like a Cobalion."
        first, second = "It resembles a mysterious object|introduced in a paranormal|magazine as a cutting-edge", "weapon shaped like a Cobalion."
        drawn, live = self.run_pages(f"print {text}", f"frames {FRAMES * 3}")
        self.assertEqual(drawn, [(0, centred(first), first), (FRAMES, centred(second), second),
                                 (FRAMES * 2, centred(first), first), (FRAMES * 3, centred(second), second)])
        self.assertEqual(live, [1, 1])

    def test_five_and_six_lines_are_two_pages(self):
        for text in ("a b|c d|e f|g h|i j", "a b|c d|e f|g h|i j|k l"):
            lines = text.split("|")
            drawn, _ = self.run_pages(f"print {text}", f"frames {FRAMES * 2}")
            self.assertEqual([t for _, _, t in drawn], ["|".join(lines[:3]), "|".join(lines[3:]), "|".join(lines[:3])], text)

    def test_a_line_wider_than_the_window_starts_at_its_edge(self):
        wide = "W" * 60
        self.assertGreater(width(wide), WIDTH)
        drawn, _ = self.run_pages(f"print {wide}|b|c", f"print a|b|c|{wide}", f"frames {FRAMES}")
        self.assertEqual([(x, t) for _, x, t in drawn], [(0, f"{wide}|b|c"), (centred("a|b|c"), "a|b|c"), (0, wide)])

    def test_another_entry_takes_the_place_of_the_turning_one(self):
        drawn, live = self.run_pages("print a|b|c|d", f"frames {FRAMES // 2}", "print e|f", f"frames {FRAMES * 2}",
                                     "print g|h|i|j", f"frames {FRAMES}")
        self.assertEqual([(f, t) for f, _, t in drawn], [(0, "a|b|c"), (0, "e|f"), (0, "g|h|i"), (FRAMES, "j")])
        self.assertEqual(live, [1, 1, 0, 0, 1, 1])

    def test_the_pages_stop_when_the_entry_leaves_the_screen(self):
        drawn, live = self.run_pages("print a|b|c|d", "frames 10", "clear", f"frames {FRAMES * 2}")
        self.assertEqual([t for _, _, t in drawn], ["a|b|c"])
        self.assertEqual(live, [1, 1, 1, 0])

    def test_the_pages_stop_before_the_window_goes(self):
        drawn, live = self.run_pages("print a|b|c|d", "frames 10", "stop", f"frames {FRAMES * 2}", "stop")
        self.assertEqual([t for _, _, t in drawn], ["a|b|c"])
        self.assertEqual(live, [1, 1, 0, 0, 0])


if __name__ == "__main__":
    unittest.main()
