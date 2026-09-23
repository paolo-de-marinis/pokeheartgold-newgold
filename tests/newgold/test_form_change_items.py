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

    def test_the_rotom_catalog_opens_the_party_menu(self):
        self.assertEqual(int(records()["ITEM_ROTOM_CATALOG"]["fieldUseFunc"]), 35)
        self.assertEqual(routines()[35], "ItemMenuUseFunc_FormChange")

    def test_the_catalog_lists_each_appliance_with_its_form(self):
        """Refrigerator Frost, fan Fan, mower Mow, QUIT on the corner button,
        light bulb back to Rotom, microwave Heat, washing machine Wash."""
        source = (ROOT / "src/party_menu.c").read_text()
        body = source[source.index("sRotomCatalogMessages[] = {"):]
        messages = re.findall(r"(msg_0300_\d+|ROTOM_CATALOG_QUIT)", body[:body.index("};")])
        body = source[source.index("sRotomCatalogForms[] = {"):]
        forms = re.findall(r"(ROTOM_\w+)", body[:body.index("};")])
        gmm = (ROOT / "files/msgdata/msg/msg_0300.gmm").read_text()
        text = dict(re.findall(r'<row id="(msg_0300_\d+)".*?<language name="English">(.*?)</language>', gmm, re.S))
        listed = [(text.get(message, "QUIT"), form) for message, form in zip(messages, forms)]
        self.assertEqual(listed, [
            ("Refrigerator", "ROTOM_FROST"), ("Electric Fan", "ROTOM_FAN"), ("Lawn Mower", "ROTOM_MOW"),
            ("QUIT", "ROTOM_NORMAL"), ("Light Bulb", "ROTOM_NORMAL"), ("Microwave Oven", "ROTOM_HEAT"),
            ("Washing Machine", "ROTOM_WASH")])

    def test_the_scene_changes_the_species_it_is_given(self):
        scene = function((ROOT / "src/overlay_94.c").read_text(), "PartyMenu_AnimateIconFormChange")
        self.assertIn("Mon_ChangeFormSpecies(mon, partyMenu->args->species);", scene)
        self.assertIn("Mon_UpdateRotomForm(mon, partyMenu->args->species, partyMenu->args->selectedMoveIdx);", scene)

    def test_a_rotom_with_four_moves_is_asked_which_to_forget(self):
        """The games ask, as a machine does, and change the form only if a
        move is forgotten; hg-engine overwrote the first slot."""
        menu = (ROOT / "src/party_menu.c").read_text()
        action = function(menu, "PartyMonContextMenuAction_RotomCatalog")
        self.assertIn("Mon_RotomFormNeedsMoveSlot(", action)
        self.assertIn("PartyMenu_AskToForgetMove(partyMenu)", action)
        # Back from the summary screen, the catalog changes the form instead of
        # teaching the move, and the catalog is not spent as a machine would be.
        learn = function((ROOT / "src/party_menu_items.c").read_text(), "PartyMenu_Subtask_TMHMLearnMove")
        catalog = learn[learn.index("ITEM_ROTOM_CATALOG"):learn.index("return PARTY_MENU_STATE_WAIT_TEXT_PRINTER;")]
        self.assertIn("Rotom_GetFormOfMove(partyMenu->args->moveId)", catalog)
        self.assertIn("PartyMenu_FormChangeScene_Begin(partyMenu)", catalog)
        self.assertNotIn("PartyMenu_LearnMoveToSlot", catalog)


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


ROTOM_NATIVE = r"""
#include <assert.h>
#include <stdint.h>
#include <stdio.h>
typedef uint8_t u8;
typedef uint16_t u16;
typedef uint32_t u32;
typedef int BOOL;
#define TRUE 1
#define FALSE 0
#include "constants/moves.h"
#include "constants/pokemon.h"
typedef struct { u16 moves[MAX_MON_MOVES]; } Pokemon;
static u32 GetMonData(Pokemon *mon, int attr, void *dest) {
    (void)dest;
    return mon->moves[attr - MON_DATA_MOVE1];
}

@NATIVE@

int main(void) {
    Pokemon full = { { MOVE_THUNDERBOLT, MOVE_THUNDER_WAVE, MOVE_DOUBLE_TEAM, MOVE_SHADOW_BALL } };
    Pokemon three = { { MOVE_THUNDERBOLT, MOVE_THUNDER_WAVE, MOVE_DOUBLE_TEAM, MOVE_NONE } };
    Pokemon heat = { { MOVE_THUNDERBOLT, MOVE_OVERHEAT, MOVE_DOUBLE_TEAM, MOVE_SHADOW_BALL } };
    for (int form = ROTOM_HEAT; form < ROTOM_FORM_MAX; form++) {
        assert(Mon_RotomFormNeedsMoveSlot(&full, form));
        assert(!Mon_RotomFormNeedsMoveSlot(&three, form));
        assert(!Mon_RotomFormNeedsMoveSlot(&heat, form));
        assert(Rotom_GetFormOfMove(Rotom_GetFormMove(form)) == form);
    }
    assert(!Mon_RotomFormNeedsMoveSlot(&full, ROTOM_NORMAL));
    assert(Rotom_GetFormOfMove(MOVE_THUNDERBOLT) == ROTOM_NORMAL);
    puts("PASS: a Rotom asks to forget only with four moves and none of a form's.");
    return 0;
}
"""


class RotomFormMoves(unittest.TestCase):
    def test_only_a_full_moveset_without_a_form_move_asks(self):
        source = (ROOT / "src/pokemon.c").read_text()
        table = source[source.index("static const u16 sRotomFormMoves"):]
        table = table[:table.index("};") + 2]
        functions = [function(source, name) for name in ("Rotom_GetFormMove", "Rotom_GetFormOfMove", "Mon_RotomFormNeedsMoveSlot")]
        program = ROTOM_NATIVE.replace("@NATIVE@", "\n".join([table] + functions))
        with tempfile.TemporaryDirectory(prefix="newgold-rotom-") as temp:
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
