#!/usr/bin/env python3
"""Run the mart's price printer on every price a mart sells at.

ov31_0225DE24 (src/overlay_31_0225DE24.c) prints a row of the mart's item
list, handing BufferIntegerAsString a digit count. String16_FormatInteger
(src/pm_string.c) starts at 10^(count - 1), so a price with more digits than
the count prints '?' for its top digit: at four digits the vitamins' 10000
read '?000'. The function is extracted and run with the formatter stubbed to
record what it was asked; the prices are item_data.csv's for every item listed
in src/scrcmd_mart.c.
"""

import csv
import re
import unittest

from test_form_dex import run
from test_level_cap import ROOT, function

PROGRAM = r'''
#include <assert.h>
#include <stddef.h>
#include <stdint.h>
typedef uint8_t u8; typedef uint32_t u32; typedef int32_t s32; typedef int BOOL;
#define TRUE 1
typedef struct MessageFormat MessageFormat;
typedef struct MsgData MsgData;
typedef struct Window Window;
typedef struct String String;
enum { MART_TYPE_NORMAL, MART_TYPE_1, MART_TYPE_SEAL, MART_TYPE_3, MART_TYPE_4 };
enum { PRINTING_MODE_LEFT_ALIGN };
#define msg_0435_00018 18
#define msg_0435_00019 19
#define HEAP_ID_8 8
#define TEXT_SPEED_NOTRANSFER 0xFF
#define MAKE_TEXT_COLOR(fg, sh, bg) 0

static u32 sDigits;
static s32 sNumber;

void BufferIntegerAsString(MessageFormat *f, u32 idx, s32 num, u32 numDigits, int mode, BOOL charset) {
    sNumber = num;
    sDigits = numDigits;
}
String *ReadMsgData_ExpandPlaceholders(MessageFormat *f, MsgData *d, u32 msgNo, int heapID) { return NULL; }
u8 AddTextPrinterParameterizedWithColor(Window *w, int font, String *s, u32 x, u32 y, u32 speed, u32 color, void *cb) { return 0; }
void String_Delete(String *s) { }

@NATIVE@

int main(void) {
    static const u32 prices[] = { @PRICES@ };
    for (size_t i = 0; i < sizeof(prices) / sizeof(prices[0]); i++) {
        ov31_0225DE24(NULL, NULL, NULL, prices[i], MART_TYPE_NORMAL);
        assert(sNumber == (s32)prices[i]);
        u32 top = 1;
        for (u32 d = 1; d < sDigits; d++) {
            top *= 10;
        }
        // The first digit String16_FormatInteger prints.
        assert(sNumber / top < 10);
    }
    return 0;
}
'''


def mart_prices():
    rows = list(csv.reader((ROOT / "files/itemtool/itemdata/item_data.csv").read_text().splitlines()))
    head = rows[0]
    data = {r[0]: dict(zip(head[1:], r[1:])) for r in rows[1:]}
    sold = set(re.findall(r"\bITEM_\w+", (ROOT / "src/scrcmd_mart.c").read_text()))
    return {name: int(data[name]["price"]) | (int(data[name]["price_high"]) << 16) for name in sold}


class MartPriceTests(unittest.TestCase):
    def test_every_mart_price_prints_whole(self):
        prices = mart_prices()
        self.assertGreaterEqual(max(prices.values()), 10000, "no mart sells anything with five digits")
        source = (ROOT / "src/overlay_31_0225DE24.c").read_text()
        native = "\n".join(l for l in source.splitlines() if l.startswith("#define ")) + "\n"
        native += function(source, "ov31_0225DE24")
        run(PROGRAM.replace("@NATIVE@", native).replace("@PRICES@", ", ".join(map(str, sorted(set(prices.values()))))),
            "newgold-mart-prices-")


if __name__ == "__main__":
    unittest.main()
