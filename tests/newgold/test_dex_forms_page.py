#!/usr/bin/env python3
"""The Dex's FORMS page lists the forms of a species that were seen.

Each form is a species of its own here, recorded seen and caught on its own
(Pokedex_RecordForm, test_form_dex). ov18_021E8254 fills the page's list
(PokedexAppData.seenForms) with a species' genders, or retail's forms for the
species retail tells apart; after the genders now come the forms seen, each
an entry of form 0 whose species seenFormSpecies holds, drawn and named as
that species. ov18_021F09D8 names a regional form by its region, as the
latest games' Dex does ("Galarian Form"), Paldean Tauros by its breed.

Both are cut from the tree and compiled natively over a stand-in Dex.
"""

import os
import re
import shlex
import subprocess
import tempfile
import unittest
from pathlib import Path

from test_level_cap import ROOT, function

PAGE = ROOT / "src/application/pokedex/ov18_021E5C40.c"
LABEL = ROOT / "src/application/pokedex/ov18_021F09D8.c"
GMM = ROOT / "files/msgdata/msg/msg_0802.gmm"

PREFIX = r'''
#include <assert.h>
#include <stdint.h>
#include <stdio.h>
#include <string.h>
#include "constants/species.h"
#include "constants/pokemon.h"
typedef uint8_t u8; typedef int8_t s8; typedef uint16_t u16; typedef uint32_t u32;
typedef int BOOL;
#define TRUE 1
#define FALSE 0
#define NELEMS(a) (sizeof(a) / sizeof((a)[0]))
#define HEAP_ID_POKEDEX_APP 37
@DEFINES@
@MESSAGES@
typedef struct Pokedex {
    u32 formsSeen[NUM_DEX_FORM_WORDS];
    u32 formsCaught[NUM_DEX_FORM_WORDS];
} Pokedex;
typedef struct { Pokedex *pokedex; } PokedexArgs;
typedef struct String String;
typedef struct MessageFormat MessageFormat;
typedef struct PokedexAppData {
    PokedexArgs *args;
    MessageFormat *msgFormat;
    u16 curSpecies;
    u8 seenForms[0x20];
    s8 numSeenForms;
    u16 seenFormSpecies[0x20];
} PokedexAppData;

// Retail's Dex: one form seen for the species it tells forms apart, a male
// seen first and a female second for the others.
static int Pokedex_GetSeenFormNum(Pokedex *pokedex, int species) { (void)pokedex; (void)species; return 1; }
static int Pokedex_GetSeenFormByIdx(Pokedex *pokedex, int species, int idx) { (void)pokedex; (void)species; (void)idx; return 0; }
static int Pokedex_SpeciesGetLastSeenGender(Pokedex *pokedex, u16 species, u32 idx) { (void)pokedex; (void)species; return idx == 0 ? MON_MALE : MON_FEMALE; }
static int sNamed;
static String *ov18_021E590C(u16 species, int language, int heapId) { (void)species; (void)language; (void)heapId; return (String *)&sNamed; }
static void BufferString(MessageFormat *f, u32 field, const String *s, int a3, int a4, int a5) { (void)f; (void)field; (void)s; (void)a3; (void)a4; (void)a5; sNamed++; }
static void String_Delete(String *s) { (void)s; }
@FORM_TABLE@
@NATIVE@

static void Record(Pokedex *dex, u32 *forms, u16 species) {
    forms[(species - DEX_FIRST_FORM) / 32] |= 1u << ((species - DEX_FIRST_FORM) % 32);
    (void)dex;
}

static void Open(PokedexAppData *app, u16 species) {
    app->curSpecies = species;
    app->numSeenForms = 0;
    ov18_021E8254(app);
}
'''

MAIN = r'''
int main(void) {
    static Pokedex dex;
    static PokedexArgs args = { &dex };
    static PokedexAppData app = { &args };

    // Slowpoke seen, no form of it: its two genders, as retail lists them.
    Open(&app, SPECIES_SLOWPOKE);
    assert(app.numSeenForms == 2 && app.seenForms[0] == 1 && app.seenForms[1] == 2);
    assert(app.seenFormSpecies[0] == SPECIES_SLOWPOKE && app.seenFormSpecies[1] == SPECIES_SLOWPOKE);

    // Larry's Galarian Slowpoke seen: a third entry, form 0 of the Galarian
    // species, named as the Galarian Form.
    Record(&dex, dex.formsSeen, SPECIES_SLOWPOKE_GALARIAN);
    Open(&app, SPECIES_SLOWPOKE);
    assert(app.numSeenForms == 3 && app.seenForms[2] == 0x80 && app.seenFormSpecies[2] == SPECIES_SLOWPOKE_GALARIAN);
    assert(ov18_021F09D8(&app, 2) == msg_0802_00178);
    assert(ov18_021F09D8(&app, 0) == msg_0802_00114 && ov18_021F09D8(&app, 1) == msg_0802_00115);
    // Slowbro's own list knows nothing of the Galarian Slowpoke.
    Open(&app, SPECIES_SLOWBRO);
    assert(app.numSeenForms == 2);

    // A form caught counts as seen; forms come in their species' order.
    Record(&dex, dex.formsCaught, SPECIES_MEOWTH_GALARIAN);
    Record(&dex, dex.formsSeen, SPECIES_MEOWTH_ALOLAN);
    Open(&app, SPECIES_MEOWTH);
    assert(app.numSeenForms == 4);
    assert(app.seenFormSpecies[2] == SPECIES_MEOWTH_ALOLAN && app.seenFormSpecies[3] == SPECIES_MEOWTH_GALARIAN);
    assert(ov18_021F09D8(&app, 2) == msg_0802_00177 && ov18_021F09D8(&app, 3) == msg_0802_00178);

    // Paldean Tauros by its breed.
    Record(&dex, dex.formsSeen, SPECIES_TAUROS_COMBAT);
    Record(&dex, dex.formsSeen, SPECIES_TAUROS_AQUA);
    Open(&app, SPECIES_TAUROS);
    assert(app.numSeenForms == 4 && ov18_021F09D8(&app, 2) == msg_0802_00181 && ov18_021F09D8(&app, 3) == msg_0802_00183);

    // A form of no region is named as its species, as retail names a
    // species seen genderless.
    Record(&dex, dex.formsSeen, SPECIES_LYCANROC_MIDNIGHT);
    Open(&app, SPECIES_LYCANROC);
    assert(app.numSeenForms == 3);
    sNamed = 0;
    assert(ov18_021F09D8(&app, 2) == msg_0802_00159 && sNamed == 1);

    // The species retail tells forms apart keep retail's list.
    Open(&app, SPECIES_SHELLOS);
    assert(app.numSeenForms == 1 && app.seenForms[0] == 0x80 && app.seenFormSpecies[0] == SPECIES_SHELLOS);

    // Every form of every species, all seen: the list never runs past its 32.
    memset(dex.formsSeen, 0xFF, sizeof(dex.formsSeen));
    for (u16 species = 1; species <= NATIONAL_DEX_COUNT; species++) {
        Open(&app, species);
        assert(app.numSeenForms >= 1 && app.numSeenForms <= 0x20);
        for (int i = 0; i < app.numSeenForms; i++) {
            assert(app.seenFormSpecies[i] == species || SpeciesToDexSpecies(app.seenFormSpecies[i]) == species);
        }
    }
    puts("PASS: the FORMS page lists the forms seen after the genders, named by their region.");
    return 0;
}
'''

REGIONS = {"ALOLAN": "Alolan Form", "GALARIAN": "Galarian Form", "HISUIAN": "Hisuian Form", "PALDEAN": "Paldean Form"}
BREEDS = {"TAUROS_COMBAT": "Combat Breed", "TAUROS_BLAZE": "Blaze Breed", "TAUROS_AQUA": "Aqua Breed"}


def messages():
    """msg_0802's ids, by the gmm's rows: id -> (index, English text)."""
    return {m[0]: (int(m[1]), m[2]) for m in re.findall(
        r'<row id="(msg_0802_\d+)" index="(\d+)">.*?<language name="English">(.*?)</language>', GMM.read_text(), re.S)}


def run(program):
    with tempfile.TemporaryDirectory(prefix="newgold-dex-forms-page-") as temp:
        c, exe = Path(temp) / "check.c", Path(temp) / "check"
        c.write_text(program)
        build = subprocess.run(shlex.split(os.environ.get("CC", "cc")) + [
            "-std=c11", "-O1", "-g", "-fsanitize=address,undefined", "-fno-omit-frame-pointer",
            "-iquote", str(ROOT / "include"), str(c), "-o", str(exe)], capture_output=True, text=True)
        if build.returncode:
            raise AssertionError(build.stderr)
        result = subprocess.run([str(exe)], capture_output=True, text=True,
                                env={**os.environ, "ASAN_OPTIONS": "detect_leaks=0", "UBSAN_OPTIONS": "halt_on_error=1"})
        if result.returncode:
            raise AssertionError(result.stdout + result.stderr)
        return result.stdout.strip()


class DexFormsPageTests(unittest.TestCase):
    def test_the_page_lists_the_forms_seen(self):
        page, label = PAGE.read_text(), LABEL.read_text()
        dex = (ROOT / "src/pokedex.c").read_text()
        header = (ROOT / "include/pokedex.h").read_text()
        defines = "\n".join(re.findall(r"^#define (?:CEILDIV|DEX_FIRST_FORM|NUM_DEX_FORM_WORDS)\b.*$", header, re.M))
        table = re.search(r"static const u16 sFormBaseSpecies\[.*?\n\};", dex, re.S).group(0)
        table += "\n" + function(dex, "SpeciesToDexSpecies")
        native = "\n".join([function(page, "ov18_021E83D0"), function(page, "PokedexApp_AppendSeenForms"),
                            function(page, "ov18_021E8254"),
                            label[label.index("static const struct {"):label.index("int ov18_021F09D8(")],
                            function(label, "ov18_021F09D8")])
        msgs = "\n".join(f"#define {name} {index}" for name, (index, _) in messages().items())
        program = (PREFIX.replace("@DEFINES@", defines).replace("@MESSAGES@", msgs).replace("@FORM_TABLE@", table)
                   .replace("@NATIVE@", native) + MAIN)
        print(run(program))

    def test_a_regional_form_is_named_by_its_region(self):
        """Every regional form the tree has falls in sRegionalForms under its
        region's name, and nothing else does: the totems (_LARGE) and the
        Galarian Darmanitan's Zen Mode, a battle's, are named as their
        species."""
        label = LABEL.read_text()
        header = (ROOT / "include/constants/species.h").read_text()
        numbers = {name: int(n) for name, n in re.findall(r"#define SPECIES_(\w+)\s+(\d+)", header)}
        text = {name: t for name, (_, t) in messages().items()}
        ranges = [(numbers[a], numbers[b], text[m]) for a, b, m in
                  re.findall(r"\{ SPECIES_(\w+), SPECIES_(\w+), (msg_0802_\d+) \}", label)]
        named = {}
        for name, number in numbers.items():
            hits = [t for lo, hi, t in ranges if lo <= number <= hi]
            if hits:
                named[name] = hits[0]
        expected = {}
        for name in numbers:
            region = next((r for r in REGIONS if name.endswith("_" + r)), None)
            if region and not name.endswith("_LARGE") and "ZEN_MODE" not in name:
                expected[name] = REGIONS[region]
        expected.update(BREEDS)
        self.assertEqual(named, expected)


if __name__ == "__main__":
    unittest.main()
