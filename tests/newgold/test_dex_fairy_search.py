#!/usr/bin/env python3
"""Check the Dex's search by type offers Fairy.

Retail's type page had seventeen types and "----"; neither reference adds
Fairy, so pure Fairy species could not be found by type. Fairy's sort list
is zukan_data's last member (no list the Dex's routines number moves), the
filter asks for it, the page has a Fairy button where retail's "----" was
and "----" beside it, answered after OK and Cancel.
"""

import json
import re
import unittest

from test_dex_range import c_function, run_native
from test_level_cap import ROOT

POKEDEX = ROOT / "src/application/pokedex"

FILTER = r"""
#include <assert.h>
#include <stdio.h>
#include <string.h>
#include "application/zukanlist/zkn_data/zukan_data.naix"
#include "application/pokedex/pokedex_internal_constants.h"
typedef unsigned short u16;
typedef unsigned int u32;
typedef struct Pokedex Pokedex;
#define GF_ASSERT(x) assert(x)
#define FALSE 0
static u16 gList[2];
static u32 gAsked = 0xFFFF;
static u16 *ov18_021F8168(u32 member, u32 *count) { gAsked = member; *count = 0; return gList; }
static void ov18_021F8764(u16 *dest, u32 *destCount, u16 *list, u32 listCount, u16 *src, u32 srcCount, int a6, Pokedex *pokedex) { *destCount = 0; }
static u32 ov18_021F8970(u32 type) { return type; }
static void Heap_Free(void *p) {}
@NATIVE@
int main(void) {
    u16 src[3] = { 35, 36, 173 }, dest[3];
    u32 n;
    ov18_021F831C(DEX_SEARCH_TYPE_FAIRY, dest, &n, src, 3, 0);
    assert(gAsked + NARC_zukan_data_sort_order_dex_order_national == NARC_zukan_data_sort_order_types_fairy);
    ov18_021F831C(DEX_SEARCH_TYPE_DARK, dest, &n, src, 3, 0);
    assert(gAsked + NARC_zukan_data_sort_order_dex_order_national == NARC_zukan_data_sort_order_types_dark);
    gAsked = 0xFFFF;
    ov18_021F831C(DEX_SEARCH_TYPE_ALL, dest, &n, src, 3, 0);
    assert(gAsked == 0xFFFF && n == 3 && memcmp(dest, src, sizeof(src)) == 0);
    printf("PASS: the type filter asks Fairy's list, the archive's last, and passes everything for \"----\".\n");
    return 0;
}
"""


def constants():
    text = (ROOT / "include/application/pokedex/pokedex_internal_constants.h").read_text()
    naix = (ROOT / "files/application/zukanlist/zkn_data/zukan_data.naix").read_text()
    members = {k: int(v) for k, v in re.findall(r"(NARC_zukan_data_\w+) = (\d+)", naix)}
    out = {}
    for name, expr in re.findall(r"#define (DEX_SEARCH_TYPE_\w+)\s+(.+)", text):
        expr = re.sub(r"NARC_zukan_data_\w+", lambda m: str(members[m.group(0)]), expr)
        expr = re.sub(r"DEX_SEARCH_TYPE_\w+", lambda m: str(out[m.group(0)]), expr)
        out[name] = eval(expr)
    return out


def entries(path, name):
    body = path.read_text()
    body = body[body.index(name):]
    return [l for l in body[:body.index("};")].splitlines()[1:] if l.strip().startswith("{") or l.strip().startswith("msg_") or re.match(r"\s*\d", l)]


class FairySearchTests(unittest.TestCase):
    def test_the_fairy_list_is_the_archives_last(self):
        data = json.loads((ROOT / "files/application/zukanlist/zkn_data/zukan_data.json").read_text())
        last = data["sorting"][-1]
        self.assertEqual((last["type"], [o["id"] for o in last["options"]]), ("types", ["fairy"]))
        ids = {n: int(v) for n, v in re.findall(r"#define (SPECIES_\w+)\s+(\d+)\b", (ROOT / "include/constants/species.h").read_text())}
        fairy = {ids[name] for name in last["options"][0]["mons"]}
        for name in ("SPECIES_CLEFAIRY", "SPECIES_TOGEPI", "SPECIES_SYLVEON", "SPECIES_ENAMORUS"):
            self.assertIn(ids[name], fairy, name)
        self.assertNotIn(ids["SPECIES_PIKACHU"], fairy)
        # the lists the Dex's routines ask by number keep their members
        naix = (ROOT / "files/application/zukanlist/zkn_data/zukan_data.naix").read_text()
        self.assertIn("NARC_zukan_data_sort_order_types_normal = 62,", naix)
        self.assertIn("NARC_zukan_data_sort_order_body_style_quadruped = 79,", naix)

    def test_the_filter_asks_fairys_list(self):
        source = (POKEDEX / "ov18_021F831C.c").read_text()
        run_native(self, FILTER.replace("@NATIVE@", c_function(source, "ov18_021F831C")), "newgold-fairy-filter-",
                   ("-iquote", str(ROOT / "files")))
        loader = c_function((POKEDEX / "ov18_021F8168.c").read_text(), "ov18_021F8168")
        self.assertIn("NARC_zukan_data_sort_order_types_fairy - NARC_zukan_data_sort_order_dex_order_national", loader)

    def test_the_page_has_a_fairy_button(self):
        k = constants()
        self.assertEqual((k["DEX_SEARCH_TYPE_FAIRY"], k["DEX_SEARCH_TYPE_ALL"]), (17, 18))
        self.assertEqual((k["DEX_SEARCH_TYPE_BUTTON_SUBMIT"], k["DEX_SEARCH_TYPE_BUTTON_CANCEL"], k["DEX_SEARCH_TYPE_BUTTON_ALL"]), (18, 19, 20))
        # the names: one a DEX_SEARCH_TYPE_*, Fairy's row of msg_0802 is "Fairy"
        names = entries(POKEDEX / "ov18_021F9DC0.c", "ov18_021F9DC0[]")
        self.assertEqual(len(names), k["DEX_SEARCH_TYPE_ALL"] + 1)
        row = int(re.search(r"msg_0802_(\d+)", names[k["DEX_SEARCH_TYPE_FAIRY"]]).group(1))
        gmm = (ROOT / "files/msgdata/msg/msg_0802.gmm").read_text()
        self.assertIn(f'<row id="msg_0802_{row:05d}" index="{row}">\n\t\t<attribute name="window_context_name">used</attribute>\n\t\t<language name="English">Fairy</language>', gmm)
        self.assertIn("msg_0802_00064", names[k["DEX_SEARCH_TYPE_ALL"]])  # "----"
        # the buttons: nineteen and OK and Cancel, "----" answered after them
        touch = entries(POKEDEX / "ov18_021FBA40.c", "ov18_021FBA40[]")
        dpad = entries(POKEDEX / "ov18_021FBB94.c", "ov18_021FBB94[]")
        self.assertEqual(len(touch), k["DEX_SEARCH_TYPE_BUTTON_ALL"] + 2)  # and the end
        self.assertEqual(len(dpad), k["DEX_SEARCH_TYPE_BUTTON_ALL"] + 1)
        self.assertEqual(sum(len(re.findall(r"\b\d+\b", l.split("//")[0])) for l in entries(POKEDEX / "ov18_021FBD3C.c", "ov18_021FBD3C[]")),
                         k["DEX_SEARCH_TYPE_BUTTON_ALL"] + 1)
        rect = lambda i: tuple(int(v) for v in re.findall(r"\d+", touch[i].split("//")[0]))  # noqa: E731
        # "----" sits right of Fairy in the last row, where the tilemap now draws a button
        self.assertEqual(rect(k["DEX_SEARCH_TYPE_BUTTON_ALL"]), (136, 151, 131, 188))
        self.assertEqual(rect(k["DEX_SEARCH_TYPE_FAIRY"]), (136, 151, 67, 124))
        # its highlight, by DEX_SEARCH_TYPE_*, is that button's tiles
        tables = (POKEDEX / "ov18_021E5C40.c").read_text()
        body = tables[tables.index("ov18_021F990C[DEX_SEARCH_TYPE_ALL + 1] = {"):]
        highlight = re.findall(r"\{ (\d+),\s+(\d+),\s+(\d+), (\d+) \}", body[:body.index("};")])
        self.assertEqual(len(highlight), k["DEX_SEARCH_TYPE_ALL"] + 1)
        self.assertEqual(highlight[k["DEX_SEARCH_TYPE_ALL"]], ("16", "17", "8", "2"))
        # the page's answers: a button past OK and Cancel is "----"
        seq = c_function((POKEDEX / "ov18_021E8BF4.c").read_text(), "PokedexApp_MainSeq_35")
        self.assertRegex(seq, r"if \(r0 == DEX_SEARCH_TYPE_BUTTON_ALL\) \{\s*r0 = DEX_SEARCH_TYPE_ALL;")
        # window 64 holds Fairy and "----", two buttons wide
        windows = (POKEDEX / "ov18_021F9F3C.c").read_text()
        self.assertIn("{ 0, 8, 17, 16, 2, 2, 0x0A2 }, // Fairy and \"----\"", windows)
        labels = c_function((POKEDEX / "ov18_021EF848.c").read_text(), "ov18_021EF848")
        self.assertIn("ov18_021F9648(&pokedexApp->windows[64], pokedexApp->msgData, ov18_021F9DC0[DEX_SEARCH_TYPE_ALL], 32 + 64,", labels)


if __name__ == "__main__":
    unittest.main()
