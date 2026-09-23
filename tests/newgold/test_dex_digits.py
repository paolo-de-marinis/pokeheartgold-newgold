#!/usr/bin/env python3
"""Check every place that prints a Dex number prints four digits.

Retail formats a Dex number with three, and BufferIntegerAsString keeps the
last three of a longer one, so species 1000 to 1041 (Pecharunt) printed as
'?xx'. hg-engine widens the six places to four with a byte patch
(bytereplacement, "expand dex digits from 3 to 4"); here the five routines
that print it in text are C, and each must take DEX_NUMBER_DIGITS.
"""

import re
import struct
import unittest
import zlib

from test_dex_range import c_function, run_native
from test_level_cap import ROOT

def read_png4(data):
    """A 4-bit grayscale PNG's pixels, as the graphics are stored here."""
    pos, idat, header = 8, b"", None
    while pos < len(data):
        size = struct.unpack(">I", data[pos:pos + 4])[0]
        kind, body = data[pos + 4:pos + 8], data[pos + 8:pos + 8 + size]
        pos += 12 + size
        if kind == b"IHDR":
            header = body
        elif kind == b"IDAT":
            idat += body
    width, height, depth, colour = struct.unpack(">IIBB", header[:10])
    assert depth == 4 and colour == 0
    raw, stride, rows, prev, at = zlib.decompress(idat), width // 2, [], bytearray(width // 2), 0
    for _ in range(height):
        kind, line = raw[at], bytearray(raw[at + 1:at + 1 + stride])
        at += 1 + stride
        for x in range(stride):
            a, b, c = line[x - 1] if x else 0, prev[x], prev[x - 1] if x else 0
            if kind == 1:
                line[x] = (line[x] + a) & 255
            elif kind == 2:
                line[x] = (line[x] + b) & 255
            elif kind == 3:
                line[x] = (line[x] + (a + b) // 2) & 255
            elif kind == 4:
                p = a + b - c
                pa, pb, pc = abs(p - a), abs(p - b), abs(p - c)
                line[x] = (line[x] + (a if pa <= pb and pa <= pc else b if pb <= pc else c)) & 255
        prev = line
        rows.append([v for byte in line for v in (byte >> 4, byte & 15)])
    return width, height, rows


# Every routine that turns Pokedex_ConvertToCurrentDexNo's answer into text.
PRINTERS = {
    "src/pokemon_summary_info.c": "sub_0208CC88",          # the summary's first page
    "src/pc_box_display_ability.c": "ov14_021F5190",       # the PC
    "src/application/pokedex/ov18_021EE75C.c": "ov18_021EE75C",  # the Dex list
    "src/application/pokedex/ov18_021EEC34.c": "ov18_021EEC34",  # an entry's pages
    "src/application/pokedex/ov18_021F8CCC.c": "ov18_021F8CCC",  # a new catch's page
}


NATIONAL = r"""
#include <assert.h>
#include <stdio.h>
#include "constants/species.h"
typedef unsigned short u16;
typedef unsigned int u32;
typedef int BOOL;
#define FALSE 0
#define TRUE 1
u16 SpeciesToJohtoDexNo(u16 species) { return species; }
@NATIVE@
int main(void) {
    static int seen[1026];
    /* Every Dex species outside the gap is one National Dex number, 1..1025,
       apart from the two Galarian forms kept as species, which share
       Slowpoke's and Slowbro's. */
    for (u32 species = 1; species <= NATIONAL_DEX_COUNT; species++) {
        if (species >= FIRST_DEX_GAP && species <= LAST_DEX_GAP) {
            continue;
        }
        u32 number = Pokedex_ConvertToCurrentDexNo(TRUE, species);
        assert(number >= 1 && number <= 1025);
        if (species == SPECIES_SLOWPOKE_GALARIAN || species == SPECIES_SLOWBRO_GALARIAN) {
            continue;
        }
        assert(!seen[number]);
        seen[number] = 1;
    }
    for (u32 number = 1; number <= 1025; number++) {
        assert(seen[number]);
    }
    assert(Pokedex_ConvertToCurrentDexNo(TRUE, SPECIES_ARCEUS) == 493);
    assert(Pokedex_ConvertToCurrentDexNo(TRUE, SPECIES_VICTINI) == 494);
    assert(Pokedex_ConvertToCurrentDexNo(TRUE, SPECIES_LILLIPUP) == 506);
    assert(Pokedex_ConvertToCurrentDexNo(TRUE, SPECIES_PECHARUNT) == 1025);
    assert(Pokedex_ConvertToCurrentDexNo(TRUE, SPECIES_SLOWPOKE_GALARIAN) == 79);
    assert(Pokedex_ConvertToCurrentDexNo(TRUE, SPECIES_MEGA_VENUSAUR) == 3);
    assert(Pokedex_ConvertToCurrentDexNo(FALSE, SPECIES_CHIKORITA) == SPECIES_CHIKORITA);
    printf("PASS: the Dex prints National Dex numbers 1..1025: Lillipup 506, Pecharunt 1025.\n");
    return 0;
}
"""


GRID = r"""
#include <assert.h>
#include <stdio.h>
#include <string.h>
typedef unsigned char u8;
typedef unsigned short u16;
typedef int BOOL;
#define TRUE 1
#define FALSE 0
#define DEX_NUMBER_DIGITS @DIGITS@
@DEFINES@
@NATIVE@
int main(void) {
    static u16 screen[160 * 10];
    /* a caught Pecharunt in the grid's second cell of its first row */
    PokedexApp_GridCellToTiles(&screen[36 + 5], 1025, TRUE);
    u16 digits[4] = { 1, 0, 2, 5 };
    for (int i = 0; i < 4; i++) {
        assert(screen[36 + 5 + i] == (0x1000 | (GRID_DIGITS_CAUGHT + digits[i])));
    }
    assert(screen[36 + 5 + 4] == 0);
    /* its caught mark, three rows down across the cell's bottom-left corner */
    assert(screen[36 + 5 + 3 * 32 - 1] == GRID_CAUGHT_MARK_L && screen[36 + 5 + 3 * 32] == GRID_CAUGHT_MARK_R);
    memset(screen, 0, sizeof(screen));
    PokedexApp_GridCellToTiles(&screen[36], 7, FALSE);
    for (int i = 0; i < 4; i++) {
        assert(screen[36 + i] == (0x1000 | (GRID_DIGITS_SEEN + (i == 3 ? 7 : 0))));
    }
    assert(screen[36 + 3 * 32 - 1] == 0 && screen[36 + 3 * 32] == 0);
    printf("PASS: the grid draws No. 1025 in four tiles and moves the caught mark below it.\n");
    return 0;
}
"""


class DexDigitTests(unittest.TestCase):
    def test_four_digits_hold_the_last_dex_number(self):
        header = (ROOT / "include/pokedex_util.h").read_text()
        digits = int(re.search(r"#define DEX_NUMBER_DIGITS (\d+)", header).group(1))
        species = (ROOT / "include/constants/species.h").read_text()
        last = int(re.search(r"#define SPECIES_PECHARUNT\s+(\d+)", species).group(1))
        self.assertEqual(digits, 4)
        self.assertLess(last, 10 ** digits)

    def test_every_printer_takes_the_width(self):
        for path, name in PRINTERS.items():
            body = c_function((ROOT / path).read_text(), name)
            calls = re.findall(r"(?:BufferIntegerAsString|sub_0208C87C)\((.*?)\);", body, re.S)
            dex = [c for c in calls if "ConvertToCurrentDexNo" in c or "dexNo" in c]
            self.assertEqual(len(dex), 1, f"{name}: {calls}")
            self.assertIn(", DEX_NUMBER_DIGITS,", dex[0], name)

    def test_no_other_c_prints_a_dex_number(self):
        """A new printer has to be added above, and made to take the width."""
        found = set()
        for path in (ROOT / "src").rglob("*.c"):
            text = path.read_text(errors="replace")
            for m in re.finditer(r"(?:BufferIntegerAsString|sub_0208C87C)\([^;]*ConvertToCurrentDexNo", text):
                found.add(str(path.relative_to(ROOT)))
            if re.search(r"dexNo = Pokedex_ConvertToCurrentDexNo", text):
                found.add(str(path.relative_to(ROOT)))
        self.assertEqual(found, set(PRINTERS))

    def test_an_added_species_prints_its_national_number(self):
        """The species New Gold adds were appended after the gap, so their
        identifier is not their number: Lillipup is species 508 and No. 506.
        The reference prints National Dex numbers."""
        pokedex = (ROOT / "src/pokedex.c").read_text()
        tables = "\n".join(pokedex[pokedex.index(f"static const u16 {name}["):][:pokedex[pokedex.index(f"static const u16 {name}["):].index("};") + 2]
                           for name in ("sFormBaseSpecies", "sNationalDexNumbers"))
        util = (ROOT / "src/pokedex_util.c").read_text()
        native = "\n".join([tables, c_function(pokedex, "SpeciesToDexSpecies"), c_function(pokedex, "SpeciesToNationalDexNo"),
                            c_function(util, "Pokedex_ConvertToCurrentDexNo")])
        run_native(self, NATIONAL.replace("@NATIVE@", native), "newgold-dex-national-")

    def test_the_grid_draws_four_digits(self):
        """The Dex list's grid draws its numbers as tiles, three after the
        caught mark in retail: 1000 on came out as '?00'. It draws four, and
        the caught mark in the two tiles the reference adds below them."""
        source = (ROOT / "src/application/pokedex/ov18_021E5C40.c").read_text()
        defines = "\n".join(re.findall(r"^#define GRID_\w+ .*$", source, re.M))
        native = c_function(source, "PokedexApp_DexNumToTiles") + "\n" + c_function(source, "PokedexApp_GridCellToTiles")
        header = (ROOT / "include/pokedex_util.h").read_text()
        digits = re.search(r"#define DEX_NUMBER_DIGITS (\d+)", header).group(1)
        run_native(self, GRID.replace("@DIGITS@", digits).replace("@DEFINES@", defines).replace("@NATIVE@", native), "newgold-dex-grid-")
        # The mark's two tiles are in the grid's graphics, and are not empty.
        png = (ROOT / "files/graphic/zukan_gra/zukan_gra_00000003.png").read_bytes()
        width, height, pixels = read_png4(png)
        for tile in (0x18, 0x19):
            x, y = tile % (width // 8) * 8, tile // (width // 8) * 8
            self.assertTrue(any(pixels[y + dy][x + dx] != 15 for dy in range(8) for dx in range(8)), f"tile {tile:#x} is empty")

    def test_the_front_page_counts_have_four_digits(self):
        """The Dex's front page prints how many species are seen and caught;
        retail's windows and digits were three wide, so 1025 showed '025'.
        The windows (ov18_021F9F3C's 2 to 5, ov18_021F9FDC's 97 to 100) are
        DEX_NUMBER_DIGITS tiles wide, the printer draws that many, and the
        front page's tilemap puts its brackets round each window."""
        header = (ROOT / "include/pokedex_util.h").read_text()
        digits = int(re.search(r"#define DEX_NUMBER_DIGITS (\d+)", header).group(1))
        printer = c_function((ROOT / "src/application/pokedex/ov18_021EE520.c").read_text(), "ov18_021EE520")
        self.assertIn("i < DEX_NUMBER_DIGITS", printer)
        self.assertIn("PrintUIntOnWindow(printer, num, DEX_NUMBER_DIGITS,", printer)
        tables = (ROOT / "src/application/pokedex/ov18_021F9F3C.c").read_text()
        count = {"DEX_COUNT_DIGITS": digits}
        screen = (ROOT / "files/graphic/zukan_gra/zukan_gra_00000000.NSCR").read_bytes()
        tile = lambda x, y: struct.unpack_from("<H", screen, 0x24 + 2 * (y * 32 + x))[0] & 0x3FF  # noqa: E731
        for name, windows in (("ov18_021F9F3C", range(2, 6)), ("ov18_021F9FDC", range(97, 101))):
            body = tables[tables.index(name + "["):]
            rows = re.findall(r"\{ (\w+), (\w+), (\w+), (\w+), (\w+), (\w+), (0x\w+) \}", body[:body.index("};")])
            used = set()
            for window in windows:
                bg, x, y, width, height, _, base = (count.get(v) or int(v, 0) for v in rows[window])
                self.assertEqual(width, digits, f"{name}[{window}]")
                self.assertEqual((tile(x - 1, y), tile(x + width, y)), (0x19, 0x15), f"{name}[{window}]: brackets")
                # its tiles are its own: past the Dex's 280 tiles of graphics,
                # before the title windows' (0x3D0), and no other count's
                span = set(range(base, base + width * height))
                self.assertFalse(span & used, f"{name}[{window}]: tiles")
                self.assertTrue(280 <= min(span) and max(span) < 0x3D0, f"{name}[{window}]: tiles")
                used |= span


if __name__ == "__main__":
    unittest.main()
