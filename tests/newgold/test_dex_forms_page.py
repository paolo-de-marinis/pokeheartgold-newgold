#!/usr/bin/env python3
"""The Dex's FORMS page lists the forms of a species that were seen.

Each form is a species of its own here, recorded seen and caught on its own
(Pokedex_RecordMonSeen, test_form_dex). ov18_021E8254 fills the page's list
(PokedexAppData.seenForms) with a species' genders, or retail's forms for the
species retail tells apart; after the genders now come the forms seen, each
an entry of form 0 whose species seenFormSpecies holds, drawn and named as
that species. ov18_021F09D8 names a regional form by its region, as the
latest games' Dex does ("Galarian Form"), Paldean Tauros by its breed.

Both are cut from the tree and compiled natively over a stand-in Dex.
"""

import json
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
    u8 caughtLanguages[(NATIONAL_DEX_COUNT + 3) & ~3];
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

// What Pokedex_RecordMonSeen marks when a species is first seen as a form,
// and clears when it is seen as itself.
static void SeenFirstAs(Pokedex *dex, u16 form) {
    dex->caughtLanguages[SpeciesToDexSpecies(form)] |= DEX_SEEN_AS_FORM_ONLY;
    dex->caughtLanguages[form - DEX_FIRST_FORM] |= DEX_FORM_SEEN_FIRST;
}
static void SeenAsItself(Pokedex *dex, u16 species) {
    dex->caughtLanguages[species] &= ~DEX_SEEN_AS_FORM_ONLY;
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

    // Slowpoke seen first as the Galarian form, and only so: the Dex shows
    // that form, the genders' entries are the form's, named by its region,
    // and the form is not listed a second time.
    SeenFirstAs(&dex, SPECIES_SLOWPOKE_GALARIAN);
    assert(PokedexApp_ShownSpecies(&app, SPECIES_SLOWPOKE) == SPECIES_SLOWPOKE_GALARIAN);
    Open(&app, SPECIES_SLOWPOKE);
    assert(app.numSeenForms == 2 && app.seenForms[0] == 1 && app.seenForms[1] == 2);
    assert(app.seenFormSpecies[0] == SPECIES_SLOWPOKE_GALARIAN && app.seenFormSpecies[1] == SPECIES_SLOWPOKE_GALARIAN);
    assert(ov18_021F09D8(&app, 0) == msg_0802_00178);
    // Slowpoke itself seen: Slowpoke's genders first again, then the form.
    SeenAsItself(&dex, SPECIES_SLOWPOKE);
    assert(PokedexApp_ShownSpecies(&app, SPECIES_SLOWPOKE) == SPECIES_SLOWPOKE);
    Open(&app, SPECIES_SLOWPOKE);
    assert(app.numSeenForms == 3 && app.seenFormSpecies[0] == SPECIES_SLOWPOKE && app.seenFormSpecies[2] == SPECIES_SLOWPOKE_GALARIAN);
    // Retail's form species keep retail's list, marks or not.
    SeenFirstAs(&dex, SPECIES_SHELLOS_EAST_SEA);
    assert(PokedexApp_ShownSpecies(&app, SPECIES_SHELLOS) == SPECIES_SHELLOS);

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

    // Every form of every species, all seen, and every species shown as its
    // first form: the list never runs past its 32.
    memset(dex.formsSeen, 0xFF, sizeof(dex.formsSeen));
    memset(dex.caughtLanguages, DEX_SEEN_AS_FORM_ONLY | DEX_FORM_SEEN_FIRST, sizeof(dex.caughtLanguages));
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

CRY = r'''
#include <assert.h>
#include <stdint.h>
#include <stdio.h>
#include "constants/species.h"
typedef uint8_t u8; typedef uint16_t u16; typedef uint32_t u32;
typedef struct PokedexAppData {
    u16 curSpecies;
    u8 seenForms[0x20];
    u16 seenFormSpecies[0x20];
} PokedexAppData;
static int sDrawn = -1, sChatot, sCries;
static u32 sCrySpecies, sCryForm;
static void ov18_021F5EFC(PokedexAppData *app, int idx, int a2) { (void)app; (void)a2; sDrawn = idx; }
// ov18_021F3CA8's reading of a form entry: retail's form, Pichu's 2 its form 1.
static void ov18_021F3CA8(PokedexAppData *app, int idx, u8 *form, u8 *gender) {
    *form = app->seenForms[idx] & 0x80 ? app->seenForms[idx] ^ 0x80 : 0;
    if (app->curSpecies == SPECIES_PICHU && *form) {
        *form = *form == 2;
    }
    *gender = 0;
}
static void sub_02006E3C(u8 on) { sChatot = on; }
static void PlayCry(u16 species, u8 form) { assert(sChatot == 1); sCries++; sCrySpecies = species; sCryForm = form; }
@NATIVE@

int main(void) {
    PokedexAppData app = { SPECIES_SLOWPOKE, { 1, 0x80 }, { SPECIES_SLOWPOKE, SPECIES_SLOWPOKE_GALARIAN } };
    ov18_021F5EF0(&app, 1);
    assert(sDrawn == 1 && sCries == 1 && sCrySpecies == SPECIES_SLOWPOKE_GALARIAN && sCryForm == 0 && sChatot == 0);
    ov18_021F5EF0(&app, 0);
    assert(sDrawn == 0 && sCries == 2 && sCrySpecies == SPECIES_SLOWPOKE);
    PokedexAppData pichu = { SPECIES_PICHU, { 0x80, 0x82 }, { SPECIES_PICHU, SPECIES_PICHU } };
    ov18_021F5EF0(&pichu, 1);
    assert(sCrySpecies == SPECIES_PICHU && sCryForm == 1);
    puts("PASS: an entry moved to cries as its species and form.");
    return 0;
}
'''

TYPES = r'''
#include <assert.h>
#include <stdint.h>
#include <stdio.h>
#include "constants/species.h"
#include "constants/pokemon.h"
typedef uint8_t u8; typedef uint16_t u16; typedef uint32_t u32; typedef int32_t fx32;
typedef int BOOL;
#define TRUE 1
#define FALSE 0
#define FX32_CONST(x) ((fx32)((x) * 4096))
typedef struct { int drawn; int x, y; int type; } ManagedSprite;
typedef struct PokedexAppData {
    ManagedSprite *unk_0670[120];
    u16 curSpecies;
    u8 seenForms[0x20];
    u16 seenFormSpecies[0x20];
    u8 unk_18C7_5;
} PokedexAppData;
static ManagedSprite sSprites[120];
static int GetMonBaseStat_HandleAlternateForm(int species, int form, int stat) {
    (void)form;
@TYPES@
    assert(0);
    return 0;
}
static void ManagedSprite_SetDrawFlag(ManagedSprite *s, int flag) { s->drawn = flag; }
static void ManagedSprite_SetPositionXYWithSubscreenOffset(ManagedSprite *s, int x, int y, fx32 off) { s->x = x; s->y = y; (void)off; }
static void ov18_021F21FC(PokedexAppData *app, int spriteIdx, u16 type) { app->unk_0670[spriteIdx]->type = type; }
static void ov18_021F3CA8(PokedexAppData *app, int idx, u8 *form, u8 *gender) { (void)app; (void)idx; *form = 0; *gender = 0; }
static void ov18_021F11C0(PokedexAppData *app, int spriteIdx, int on) { (void)app; (void)spriteIdx; (void)on; }
static void ov18_021F1A7C(PokedexAppData *app, u16 species, int form, int gender, int facing, int spriteIdx, int a6) { (void)app; (void)species; (void)form; (void)gender; (void)facing; (void)spriteIdx; (void)a6; }
static u8 GetMonPicHeightBySpeciesGenderForm(u16 species, u8 gender, u8 facing, u8 form, u32 pid) { (void)species; (void)gender; (void)facing; (void)form; (void)pid; return 0; }
@NATIVE@

int main(void) {
    static PokedexAppData app = { .curSpecies = SPECIES_SLOWPOKE, .seenForms = { 1, 0x80 },
                                  .seenFormSpecies = { SPECIES_SLOWPOKE, SPECIES_SLOWPOKE_GALARIAN } };
    for (int i = 0; i < 120; i++) app.unk_0670[i] = &sSprites[i];
    ManagedSprite *icons = &sSprites[FORMS_TYPE_SPRITE];

    ov18_021F5EFC(&app, 0, 0);      // Slowpoke, drawn into the first pair
    assert(icons[0].drawn && icons[0].type == TYPE_WATER && icons[0].x == FORMS_TYPE_X_FIRST);
    assert(icons[1].drawn && icons[1].type == TYPE_PSYCHIC && icons[1].x == FORMS_TYPE_X_SECOND);
    assert(!icons[2].drawn && !icons[3].drawn);
    ov18_021F5EFC(&app, 1, 0);      // the Galarian form, into the second
    assert(!icons[0].drawn && !icons[1].drawn);
    assert(icons[2].drawn && icons[2].type == TYPE_PSYCHIC && icons[2].x == FORMS_TYPE_X_LONE && !icons[3].drawn);
    puts("PASS: the Galarian Slowpoke shows Psychic alone, Slowpoke Water and Psychic.");
    return 0;
}
'''

TOP = r'''
#include <assert.h>
#include <stdint.h>
#include <stdio.h>
#include "constants/species.h"
#include "constants/pokemon.h"
typedef uint8_t u8; typedef uint16_t u16; typedef uint32_t u32;
typedef int BOOL;
#define TRUE 1
#define FALSE 0
@DEFINES@
typedef struct Pokedex {
    u8 caughtLanguages[(NATIONAL_DEX_COUNT + 3) & ~3];
} Pokedex;
typedef struct { Pokedex *pokedex; } PokedexArgs;
typedef struct { int drawn; } ManagedSprite;
typedef struct { u16 unk_0; u16 unk_2; } PokedexAppData_UnkSub1030;
typedef struct PokedexAppData {
    PokedexArgs *args;
    ManagedSprite *unk_0670[120];
    PokedexAppData_UnkSub1030 *unk_1030;
    u8 unk_185C;
    u8 unk_185F_0 : 4;
    u8 unk_185F_4 : 4;
} PokedexAppData;
static ManagedSprite sSprites[120];
static u32 sDrawn, sDrawnGender, sIcon, sTypes;
static void ManagedSprite_SetDrawFlag(ManagedSprite *s, int flag) { s->drawn = flag; }
// The Dex's records are its species', which a form past them is not.
static int Pokedex_SpeciesGetLastSeenGender(Pokedex *pokedex, u16 species, u32 idx) { (void)pokedex; (void)idx; assert(species <= NATIONAL_DEX_COUNT); return MON_FEMALE; }
static int Pokedex_GetSeenFormByIdx(Pokedex *pokedex, int species, int idx) { (void)pokedex; (void)idx; assert(species <= NATIONAL_DEX_COUNT); return 0; }
static void ov18_021F1A7C(PokedexAppData *app, u16 species, u8 form, u8 gender, int facing, int spriteIdx, int a6) {
    (void)app; (void)facing; (void)spriteIdx; (void)a6; sDrawn = species | form << 16; sDrawnGender = gender;
}
static void ov18_021F14FC(PokedexAppData *app, u16 species, int form, int spriteIdx) { (void)app; (void)form; (void)spriteIdx; sIcon = species; }
static void ov18_021F1160(PokedexAppData *app, int spriteIdx, BOOL seenOnly) { (void)app; (void)spriteIdx; (void)seenOnly; }
static void ov18_021F21FC(PokedexAppData *app, int spriteIdx, u16 type) { (void)app; (void)spriteIdx; sTypes = sTypes << 8 | type; }
static int GetMonBaseStat_HandleAlternateForm(int species, int form, int stat) {
    (void)form;
@TYPES@
    assert(0);
    return 0;
}
@FORM_TABLE@
@NATIVE@

int main(void) {
    static Pokedex dex;
    static PokedexArgs args = { &dex };
    static PokedexAppData_UnkSub1030 grid[1] = { { SPECIES_SLOWPOKE, 2 } };
    static PokedexAppData app = { .args = &args, .unk_1030 = grid, .unk_185C = 2 };
    for (int i = 0; i < 120; i++) app.unk_0670[i] = &sSprites[i];

    // Slowpoke seen first as the Galarian form, and only so: the top screen,
    // the grid's icon and the types its pages show are the form's, in the
    // gender the species' record holds.
    dex.caughtLanguages[SPECIES_SLOWPOKE] |= DEX_SEEN_AS_FORM_ONLY;
    dex.caughtLanguages[SPECIES_SLOWPOKE_GALARIAN - DEX_FIRST_FORM] |= DEX_FORM_SEEN_FIRST;
    ov18_021F1BC8(&app, SPECIES_SLOWPOKE, 11, 10);
    assert(sDrawn == SPECIES_SLOWPOKE_GALARIAN && sDrawnGender == MON_FEMALE);
    ov18_021F1598(&app, 0, 20);
    assert(sIcon == SPECIES_SLOWPOKE_GALARIAN);
    sTypes = 0;
    ov18_021F209C(&app, SPECIES_SLOWPOKE, 0, 14);
    assert(sTypes == TYPE_PSYCHIC);
    // Slowpoke itself seen: all three are Slowpoke's.
    dex.caughtLanguages[SPECIES_SLOWPOKE] &= ~DEX_SEEN_AS_FORM_ONLY;
    ov18_021F1BC8(&app, SPECIES_SLOWPOKE, 11, 10);
    ov18_021F1598(&app, 0, 20);
    sTypes = 0;
    ov18_021F209C(&app, SPECIES_SLOWPOKE, 0, 14);
    assert(sDrawn == SPECIES_SLOWPOKE && sIcon == SPECIES_SLOWPOKE && sTypes == (TYPE_WATER << 8 | TYPE_PSYCHIC));
    puts("PASS: the grid and the top screen show the form a species was seen as first, until it is seen itself.");
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
        defines = "\n".join(re.findall(r"^#define (?:CEILDIV|DEX_FIRST_FORM|NUM_DEX_FORM_WORDS|DEX_SEEN_AS_FORM_ONLY|DEX_FORM_SEEN_FIRST)\b.*$",
                                        header, re.M))
        table = re.search(r"static const u16 sFormBaseSpecies\[.*?\n\};", dex, re.S).group(0)
        table += "\n" + function(dex, "SpeciesToDexSpecies")
        native = "\n".join([function(page, "ov18_021E83D0"), function(page, "PokedexApp_AppendSeenForms"),
                            function(page, "PokedexApp_ShownSpecies"), function(page, "ov18_021E8254"),
                            label[label.index("static const struct {"):label.index("int ov18_021F09D8(")],
                            function(label, "ov18_021F09D8")])
        msgs = "\n".join(f"#define {name} {index}" for name, (index, _) in messages().items())
        program = (PREFIX.replace("@DEFINES@", defines).replace("@MESSAGES@", msgs).replace("@FORM_TABLE@", table)
                   .replace("@NATIVE@", native) + MAIN)
        print(run(program))

    def test_moving_to_an_entry_plays_its_cry(self):
        """ov18_021F5EF0, which the arrows and the touches move to an entry
        through, draws it and plays its cry as the list cries a species
        picked on it: a form that is a species of its own cries as itself,
        with the form ov18_021F3CA8 reads (Pichu's Spiky-eared is form 1)."""
        source = (ROOT / "src/application/pokedex/ov18_021F5EF0.c").read_text()
        program = CRY.replace("@NATIVE@", function(source, "ov18_021F5EF0"))
        print(run(program))

    def test_an_entry_shows_its_own_types(self):
        """ov18_021F5EFC draws the entry's types beneath its front and back,
        with the list's type icons (ov18_021F21FC): a form that is a species
        of its own its own types, from the tree's personal data -- the
        Galarian Slowpoke Psychic alone, centred, Slowpoke Water and
        Psychic side by side -- in the pair of sprites the page draws next,
        the other hidden."""
        source = (ROOT / "src/application/pokedex/ov18_021F5EF0.c").read_text()
        records = json.loads((ROOT / "files/poketool/personal/personal.json").read_text())["baseStats"]
        header = (ROOT / "include/constants/species.h").read_text()
        numbers = {name: int(n) for name, n in re.findall(r"#define SPECIES_(\w+)\s+(\d+)", header)}
        types = {numbers[name]: records[numbers[name]]["types"] for name in ("SLOWPOKE", "SLOWPOKE_GALARIAN")}
        table = "\n".join(f"    if (species == {n}) return stat == BASE_TYPE1 ? {t[0]} : {t[1]};" for n, t in types.items())
        defines = "\n".join(re.findall(r"^#define (?:FORMS_TYPE_\w+)\b.*$", source, re.M))
        body = (defines + "\n" + function(source, "PokedexApp_HideFormTypeIcons") + "\n"
                + function(source, "PokedexApp_ShowFormTypes") + "\n" + function(source, "ov18_021F5EFC"))
        print(run(TYPES.replace("@TYPES@", table).replace("@NATIVE@", body)))

    def test_the_grid_and_the_top_screen_show_the_look_seen(self):
        """ov18_021F1BC8 (the top screen, the grid's and a species' pages'),
        ov18_021F1598 (the grid's icons) and ov18_021F209C (the types on a
        species' pages) draw the species PokedexApp_ShownSpecies gives: the
        form seen first while the Dex has seen the species only as its
        forms, the species once it is seen; the gender and form come from
        the species' own record, which a form past the Dex's species has
        none of."""
        page = PAGE.read_text()
        dex = (ROOT / "src/pokedex.c").read_text()
        header = (ROOT / "include/pokedex.h").read_text()
        defines = "\n".join(re.findall(r"^#define (?:DEX_FIRST_FORM|DEX_SEEN_AS_FORM_ONLY|DEX_FORM_SEEN_FIRST)\b.*$", header, re.M))
        table = re.search(r"static const u16 sFormBaseSpecies\[.*?\n\};", dex, re.S).group(0)
        table += "\n" + function(dex, "SpeciesToDexSpecies")
        records = json.loads((ROOT / "files/poketool/personal/personal.json").read_text())["baseStats"]
        species_h = (ROOT / "include/constants/species.h").read_text()
        numbers = {name: int(n) for name, n in re.findall(r"#define SPECIES_(\w+)\s+(\d+)", species_h)}
        types = {numbers[name]: records[numbers[name]]["types"] for name in ("SLOWPOKE", "SLOWPOKE_GALARIAN")}
        typed = "\n".join(f"    if (species == {n}) return stat == BASE_TYPE1 ? {t[0]} : {t[1]};" for n, t in types.items())
        sources = [(ROOT / "src/application/pokedex" / f).read_text() for f in ("ov18_021F1BC8.c", "ov18_021F1598.c", "ov18_021F209C.c")]
        native = "\n".join([function(page, "PokedexApp_ShownSpecies"), function(sources[0], "ov18_021F1BC8"),
                            function(sources[1], "ov18_021F1598"), function(sources[2], "ov18_021F209C")])
        print(run(TOP.replace("@DEFINES@", defines).replace("@FORM_TABLE@", table)
                  .replace("@TYPES@", typed).replace("@NATIVE@", native)))

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
