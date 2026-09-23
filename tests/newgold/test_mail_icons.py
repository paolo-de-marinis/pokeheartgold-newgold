#!/usr/bin/env python3
"""Run the mail's icon read-back with host sanitizers.

sub_0202B404 (src/mail.c) hands the mail viewer and the PC mailbox each
Pokemon icon the mail stored, and turns anything past the last icon into 7,
which both readers draw as an empty slot. It is extracted with its form table
and run next to GetMonIconNaixEx, which wrote those icons, so the bound is
checked against what the game actually stores.
"""

import os
from pathlib import Path
import re
import shlex
import subprocess
import tempfile
import unittest

from test_level_cap import ROOT, function

PREFIX = r'''
#include <assert.h>
#include <stdint.h>
#include "constants/pokemon.h"
#include "constants/species.h"
typedef uint8_t u8; typedef uint16_t u16; typedef uint32_t u32;
typedef int BOOL;
#define TRUE 1
#define FALSE 0
#define NELEMS(a) (sizeof(a) / sizeof((a)[0]))
@DEFINES@
@UNION@
typedef struct Mail { union MailPatternData mon_icons[3]; u16 form_flags; } Mail;
static const u8 GetMonIconPaletteEx(u32 species, u32 form, u32 isEgg) { (void)isEgg; return (species + form) % 6; }
static u32 sub_02070438(u32 species, u32 form) { (void)species; return form; }
@NATIVE@

static u16 readBack(u16 icon, u16 pal) {
    Mail mail = { .mon_icons = { { .raw = 0 } } };
    mail.mon_icons[0].icon = icon;
    mail.mon_icons[0].pal = pal;
    return sub_0202B404(&mail, 0, 2, 0);
}

int main(void) {
    // Every species' icon comes back as written, the added ones included.
    u32 last = 0;
    for (u32 species = SPECIES_BULBASAUR; species <= NUM_SPECIES; species++) {
        u32 icon = GetMonIconNaixEx(species, FALSE, 0);
        last = icon > last ? icon : last;
        union MailPatternData out = { .raw = readBack(icon, 3) };
        assert(out.icon == icon && out.pal == 3);
    }
    assert(last == LAST_MON_ICON);
    assert(GetMonIconNaixEx(SPECIES_LILLIPUP, FALSE, 0) == FIRST_ADDED_ICON);

    // An empty slot is still the placeholder both readers skip.
    union MailPatternData empty = { .raw = 0xFFFF };
    union MailPatternData out = { .raw = readBack(empty.icon, empty.pal) };
    assert(out.icon == 7 && out.pal == 0);
    out.raw = readBack(LAST_MON_ICON + 1, 2);
    assert(out.icon == 7 && out.pal == 0);

    // Retail's form conversion is untouched: Rotom's base icon with Heat's
    // form flag comes back as Heat Rotom.
    Mail rotom = { .mon_icons = { { .raw = 0 } } };
    rotom.mon_icons[1].icon = 0x1E6;
    assert(sub_0202B404(&rotom, 1, 0, ROTOM_HEAT << 5) == 0x21E);
    return 0;
}
'''


def between(text, start, end):
    begin = text.index(start)
    return text[begin:text.index(end, begin) + len(end)]


class MailIconTests(unittest.TestCase):
    def test_every_icon_survives_the_mail(self):
        mail = (ROOT / "src/mail.c").read_text()
        icons = (ROOT / "src/pokemon_icon_idx.c").read_text()
        header = (ROOT / "include/pokemon_icon_idx.h").read_text()
        defines = "\n".join(re.findall(r"^#define (?:FIRST_ADDED_ICON|LAST_MON_ICON)\b.*$", header, re.M))
        native = "\n".join([
            between(mail, "struct UnkStruct_020F67A4 {", "};"),
            between(mail, "static const struct UnkStruct_020F67A4 sFormOverrides[]", "};"),
            function(mail, "sub_0202B404"),
            function(icons, "GetMonIconNaixEx"),
        ])
        union = between((ROOT / "include/pokemon_types_def.h").read_text(), "union MailPatternData {", "\n};")
        with tempfile.TemporaryDirectory(prefix="newgold-mail-icons-") as temp:
            c, exe = Path(temp) / "check.c", Path(temp) / "check"
            c.write_text(PREFIX.replace("@DEFINES@", defines).replace("@UNION@", union).replace("@NATIVE@", native))
            result = subprocess.run(shlex.split(os.environ.get("CC", "cc")) + ["-std=c11", "-O1", "-g", "-fsanitize=address,undefined", "-fno-omit-frame-pointer", "-iquote", str(ROOT / "include"), str(c), "-o", str(exe)], capture_output=True, text=True)
            self.assertEqual(result.returncode, 0, result.stderr)
            result = subprocess.run([str(exe)], capture_output=True, text=True, env={**os.environ, "ASAN_OPTIONS": "detect_leaks=0", "UBSAN_OPTIONS": "halt_on_error=1"})
            self.assertEqual(result.returncode, 0, result.stderr)


if __name__ == "__main__":
    unittest.main()
