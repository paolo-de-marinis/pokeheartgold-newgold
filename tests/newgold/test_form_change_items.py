#!/usr/bin/env python3
"""The items that change a Pokemon's form from the bag.

hg-engine gives the Reveal Glass field-use routine 30 and the four Nectars 34,
both opening the party menu on the item, and changes the form there
(UseItemMonAttrChangeCheck). Here a form is a species of its own, so the party
menu names the species the item turns the Pokemon into, and overlay 94's form
change scene changes it. These routines were missing: the items sat at routine
0 and did nothing.

The item data is read, the routine table is read from its source, and the
choice of species is compiled natively.
"""

import csv
import os
import re
import shlex
import subprocess
import tempfile
import unittest
from pathlib import Path

from test_level_cap import ROOT, function


def records():
    with (ROOT / "files/itemtool/itemdata/item_data.csv").open() as stream:
        return {row["item"]: row for row in csv.DictReader(stream)}


def routines():
    """The menu function of each entry of sItemFieldUseFuncs, in order."""
    body = (ROOT / "src/field_use_item.c").read_text()
    body = body[body.index("sItemFieldUseFuncs[] = {"):]
    body = body[:body.index("\n};")]
    return [re.match(r"\s*\{\s*(\w+),", line).group(1) for line in body.split("\n") if line.strip().startswith("{ ")]


NECTARS = ["ITEM_RED_NECTAR", "ITEM_YELLOW_NECTAR", "ITEM_PINK_NECTAR", "ITEM_PURPLE_NECTAR"]


class FormChangeRoutines(unittest.TestCase):
    def test_the_items_have_routines_that_open_the_party_menu(self):
        rows, table = records(), routines()
        for item, routine in [("ITEM_REVEAL_GLASS", 30)] + [(nectar, 34) for nectar in NECTARS]:
            self.assertEqual(int(rows[item]["fieldUseFunc"]), routine, item)
            self.assertEqual(table[routine], "ItemMenuUseFunc_FormChange", item)

    def test_the_scene_changes_the_species_it_is_given(self):
        scene = function((ROOT / "src/overlay_94.c").read_text(), "PartyMenu_AnimateIconFormChange")
        self.assertIn("Mon_ChangeFormSpecies(mon, partyMenu->args->species);", scene)


NATIVE = r"""
#include <assert.h>
#include <stdint.h>
#include <stdio.h>
typedef uint8_t u8;
typedef uint16_t u16;
typedef uint32_t u32;
#define NELEMS(a) (sizeof(a) / sizeof(*(a)))
#include "constants/items.h"
#include "constants/species.h"

@NATIVE@

int main(void) {
    const u16 forces[][2] = {
        { SPECIES_TORNADUS, SPECIES_TORNADUS_THERIAN }, { SPECIES_THUNDURUS, SPECIES_THUNDURUS_THERIAN },
        { SPECIES_LANDORUS, SPECIES_LANDORUS_THERIAN }, { SPECIES_ENAMORUS, SPECIES_ENAMORUS_THERIAN },
    };
    for (int i = 0; i < 4; i++) {
        assert(ItemFormChangeSpecies(ITEM_REVEAL_GLASS, forces[i][0]) == forces[i][1]);
        assert(ItemFormChangeSpecies(ITEM_REVEAL_GLASS, forces[i][1]) == forces[i][0]);
        assert(ItemFormChangeSpecies(ITEM_RED_NECTAR, forces[i][0]) == SPECIES_NONE);
    }
    const u16 styles[] = { SPECIES_ORICORIO, SPECIES_ORICORIO_POM_POM, SPECIES_ORICORIO_PAU, SPECIES_ORICORIO_SENSU };
    for (int nectar = 0; nectar < 4; nectar++) {
        for (int style = 0; style < 4; style++) {
            u16 got = ItemFormChangeSpecies(ITEM_RED_NECTAR + nectar, styles[style]);
            assert(got == (nectar == style ? SPECIES_NONE : styles[nectar]));
        }
        assert(ItemFormChangeSpecies(ITEM_RED_NECTAR + nectar, SPECIES_PIKACHU) == SPECIES_NONE);
        assert(ItemFormChangeSpecies(ITEM_RED_NECTAR + nectar, SPECIES_EGG) == SPECIES_NONE);
    }
    assert(ItemFormChangeSpecies(ITEM_REVEAL_GLASS, SPECIES_ORICORIO) == SPECIES_NONE);
    assert(ItemFormChangeSpecies(ITEM_REVEAL_GLASS, SPECIES_EGG) == SPECIES_NONE);
    assert(ItemFormChangeSpecies(ITEM_POTION, SPECIES_TORNADUS) == SPECIES_NONE);
    puts("PASS: the Reveal Glass on the four Forces of Nature, the Nectars on Oricorio's styles.");
    return 0;
}
"""


class FormChangeSpecies(unittest.TestCase):
    def test_each_item_names_the_canonical_form(self):
        source = (ROOT / "src/party_menu.c").read_text()
        tables = [source[source.index(f"static const u16 {name}"):] for name in ("sRevealGlassForms", "sNectarForms")]
        tables = [table[:table.index("};") + 2] for table in tables]
        program = NATIVE.replace("@NATIVE@", "\n".join(tables + [function(source, "ItemFormChangeSpecies")]))
        with tempfile.TemporaryDirectory(prefix="newgold-form-items-") as temp:
            c, exe = Path(temp) / "check.c", Path(temp) / "check"
            c.write_text(program)
            build = subprocess.run(
                shlex.split(os.environ.get("CC", "cc")) +
                ["-std=c11", "-O1", "-g", "-fsanitize=address,undefined", "-fno-omit-frame-pointer",
                 "-iquote", str(ROOT / "include"), str(c), "-o", str(exe)],
                capture_output=True, text=True)
            self.assertEqual(build.returncode, 0, build.stderr)
            run = subprocess.run([str(exe)], capture_output=True, text=True,
                                 env={**os.environ, "ASAN_OPTIONS": "detect_leaks=0", "UBSAN_OPTIONS": "halt_on_error=1"})
            self.assertEqual(run.returncode, 0, run.stdout + run.stderr)
            print(run.stdout.strip())


if __name__ == "__main__":
    unittest.main()
