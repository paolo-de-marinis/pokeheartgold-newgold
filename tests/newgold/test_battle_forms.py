#!/usr/bin/env python3
"""Battle forms: the ones a battle starts in, and going back afterwards.

hg-engine (d0380a487) puts every Pokemon of a trainer battle, and a wild
Pokemon, in its battle form before the battle (ChangeToBattleForm): Xerneas in
its Active Mode, a Zacian or Zamazenta holding its Rusted Sword or Shield
crowned, with Behemoth Blade or Bash where Iron Head was. A form marked
NEEDS_REVERSION goes back when its battler leaves the field and when the
battle ends (RevertFormChange), to form 0 or to the form FormReversionMapping
names. A form is a species here, so both come down to a change of species.

The real functions are extracted from src/pokemon.c and compiled natively; the
table is checked against the reference's own two files.
"""

import os
import re
import shlex
import subprocess
import sys
import tempfile
import unittest
from pathlib import Path

from test_repels import REFERENCE, ROOT, function

sys.path.insert(0, str(ROOT / "tools/newgold/import"))
import import_form_reversion  # noqa: E402

FIXTURE = r"""
#include <assert.h>
#include <stdint.h>
#include <stdio.h>
#include "constants/pokemon.h"
#include "constants/species.h"
#include "constants/items.h"
#include "constants/moves.h"
#include "constants/abilities.h"
typedef uint8_t u8;
typedef uint16_t u16;
typedef uint32_t u32;
typedef int BOOL;
#define TRUE 1
#define FALSE 0

typedef struct {
    u16 species, item, moves[MAX_MON_MOVES];
    u8 pp[MAX_MON_MOVES];
    int recalculated;
    u16 ability;
} Pokemon;

// Three slots a species: the first, second and hidden ability are the
// species' number times ten plus 1, 2 and 3; Wishiwashi has the first alone.
static int GetMonBaseStat(int species, int attr) {
    switch (attr) {
    case BASE_ABILITY_1: return species * 10 + 1;
    case BASE_ABILITY_2: return species == SPECIES_WISHIWASHI ? 0 : species * 10 + 2;
    case BASE_HIDDEN_ABILITY: return species == SPECIES_WISHIWASHI ? 0 : species * 10 + 3;
    }
    assert(0 && "Unexpected stat");
    return 0;
}

static u32 GetMonData(Pokemon *mon, int attr, void *ptr) {
    assert(ptr == NULL);
    if (attr >= MON_DATA_MOVE1 && attr < MON_DATA_MOVE1 + MAX_MON_MOVES) return mon->moves[attr - MON_DATA_MOVE1];
    if (attr >= MON_DATA_MOVE1_PP && attr < MON_DATA_MOVE1_PP + MAX_MON_MOVES) return mon->pp[attr - MON_DATA_MOVE1_PP];
    if (attr >= MON_DATA_MOVE1_MAX_PP && attr < MON_DATA_MOVE1_MAX_PP + MAX_MON_MOVES) {
        u16 move = mon->moves[attr - MON_DATA_MOVE1_MAX_PP];
        return move == MOVE_BEHEMOTH_BLADE || move == MOVE_BEHEMOTH_BASH ? 5 : 15;
    }
    switch (attr) {
    case MON_DATA_SPECIES: return mon->species;
    case MON_DATA_HELD_ITEM: return mon->item;
    case MON_DATA_ABILITY: return mon->ability;
    }
    assert(0 && "Unexpected attribute");
    return 0;
}

static void SetMonData(Pokemon *mon, int attr, const void *value) {
    if (attr >= MON_DATA_MOVE1 && attr < MON_DATA_MOVE1 + MAX_MON_MOVES) {
        mon->moves[attr - MON_DATA_MOVE1] = *(const u16 *)value;
    } else if (attr >= MON_DATA_MOVE1_PP && attr < MON_DATA_MOVE1_PP + MAX_MON_MOVES) {
        mon->pp[attr - MON_DATA_MOVE1_PP] = *(const u8 *)value;
    } else if (attr == MON_DATA_ABILITY) {
        mon->ability = *(const u16 *)value;
    } else {
        assert(attr == MON_DATA_SPECIES);
        mon->species = *(const u16 *)value;
    }
}

static void CalcMonLevelAndStats(Pokemon *mon) { mon->recalculated++; }

@TABLE@
@FUNCTIONS@

int main(void) {
    // Xerneas is always Active; the stats follow the species, and the
    // ability the slot it had.
    Pokemon xerneas = { SPECIES_XERNEAS };
    xerneas.ability = SPECIES_XERNEAS * 10 + 1;
    Mon_ChangeToBattleForm(&xerneas);
    assert(xerneas.species == SPECIES_XERNEAS_ACTIVE && xerneas.recalculated == 1);
    assert(xerneas.ability == SPECIES_XERNEAS_ACTIVE * 10 + 1);
    assert(Mon_RevertFormChange(&xerneas) && xerneas.species == SPECIES_XERNEAS);
    assert(xerneas.ability == SPECIES_XERNEAS * 10 + 1);

    // A hidden ability written without the hidden-ability bit, as a trainer's
    // is, is still the hidden one after the change; an ability in no slot
    // stays; a slot the new species has not got falls to the first.
    Pokemon darmanitan = { SPECIES_DARMANITAN_ZEN_MODE };
    darmanitan.ability = SPECIES_DARMANITAN_ZEN_MODE * 10 + 3;
    assert(Mon_RevertFormChange(&darmanitan) && darmanitan.ability == SPECIES_DARMANITAN * 10 + 3);
    Pokemon given = { SPECIES_MORPEKO_HANGRY };
    given.ability = 7;
    assert(Mon_RevertFormChange(&given) && given.ability == 7);
    Pokemon wishiwashi = { SPECIES_WISHIWASHI_SCHOOL };
    wishiwashi.ability = SPECIES_WISHIWASHI_SCHOOL * 10 + 2;
    assert(Mon_RevertFormChange(&wishiwashi) && wishiwashi.ability == SPECIES_WISHIWASHI * 10 + 1);

    // A Zacian is crowned only with its Rusted Sword, and Iron Head becomes
    // Behemoth Blade with no more PP than that holds.
    Pokemon zacian = { SPECIES_ZACIAN, ITEM_NONE, { MOVE_SLASH, MOVE_IRON_HEAD }, { 20, 12 } };
    Mon_ChangeToBattleForm(&zacian);
    assert(zacian.species == SPECIES_ZACIAN && zacian.moves[1] == MOVE_IRON_HEAD && zacian.recalculated == 0);
    zacian.item = ITEM_RUSTED_SWORD;
    Mon_ChangeToBattleForm(&zacian);
    assert(zacian.species == SPECIES_ZACIAN_CROWNED);
    assert(zacian.moves[0] == MOVE_SLASH && zacian.moves[1] == MOVE_BEHEMOTH_BLADE && zacian.pp[1] == 5);
    // Going back gives Iron Head back, at the PP it had as Behemoth Blade.
    assert(Mon_RevertFormChange(&zacian) && zacian.species == SPECIES_ZACIAN);
    assert(zacian.moves[1] == MOVE_IRON_HEAD && zacian.pp[1] == 5);
    Pokemon zamazenta = { SPECIES_ZAMAZENTA, ITEM_RUSTED_SHIELD, { MOVE_IRON_HEAD }, { 15 } };
    Mon_ChangeToBattleForm(&zamazenta);
    assert(zamazenta.species == SPECIES_ZAMAZENTA_CROWNED && zamazenta.moves[0] == MOVE_BEHEMOTH_BASH);
    // A second battle starts from the uncrowned form, as ChangeToBattleForm
    // reverts first: it is crowned once, not twice.
    Mon_ChangeToBattleForm(&zamazenta);
    assert(zamazenta.species == SPECIES_ZAMAZENTA_CROWNED && zamazenta.moves[0] == MOVE_BEHEMOTH_BASH);

    // A trainer's Genesect holding a Drive comes in in the Drive's form.
    Pokemon genesect = { SPECIES_GENESECT, ITEM_SHOCK_DRIVE };
    Mon_ChangeToBattleForm(&genesect);
    assert(genesect.species == SPECIES_GENESECT_SHOCK_DRIVE && genesect.recalculated == 1);

    // FormReversionMapping: a form number other than 0.
    Pokemon minior = { SPECIES_MINIOR_CORE_ORANGE };
    assert(Mon_RevertFormChange(&minior) && minior.species == SPECIES_MINIOR_METEOR_ORANGE);
    Pokemon zen = { SPECIES_DARMANITAN_ZEN_MODE_GALARIAN };
    assert(Mon_RevertFormChange(&zen) && zen.species == SPECIES_DARMANITAN_GALARIAN);
    Pokemon zygarde = { SPECIES_ZYGARDE_10_COMPLETE };
    assert(Mon_RevertFormChange(&zygarde) && zygarde.species == SPECIES_ZYGARDE_10_POWER_CONSTRUCT);

    // Nothing else moves: a base species, a form that is not a battle's.
    for (u16 species = 1; species <= NUM_SPECIES; species++) {
        Pokemon mon = { species };
        BOOL reverted = Mon_RevertFormChange(&mon);
        assert(reverted == (Species_GetBattleFormReversion(species) != SPECIES_NONE));
        assert(reverted || (mon.species == species && mon.recalculated == 0));
    }
    Pokemon galarian = { SPECIES_DARMANITAN_GALARIAN };
    assert(!Mon_RevertFormChange(&galarian));
    puts("PASS: battle forms are put on and taken off as hg-engine does.");
    return 0;
}
"""


class BattleFormTests(unittest.TestCase):
    def test_forms_change_and_go_back(self):
        source = (ROOT / "src/pokemon.c").read_text()
        functions = "\n".join(function(source, name) for name in (
            "Mon_SwapMove", "Species_AbilityInSameSlot", "Mon_ChangeFormSpecies", "Species_GetBattleFormReversion",
            "Mon_RevertFormChange", "Species_HeldItemForm", "Mon_UpdateHeldItemForm", "Mon_ChangeToBattleForm"))
        program = (FIXTURE.replace("@TABLE@", (ROOT / "src/data/form_reversion.h").read_text())
                   .replace("@FUNCTIONS@", functions))
        with tempfile.TemporaryDirectory(prefix="newgold-battle-forms-") as directory:
            path = Path(directory)
            (path / "test.c").write_text(program)
            subprocess.run(shlex.split(os.environ.get("CC", "cc")) + [
                "-std=c99", "-Wall", "-Werror", "-fsanitize=address,undefined", "-iquote", str(ROOT / "include"),
                str(path / "test.c"), "-o", str(path / "test")], check=True)
            result = subprocess.run([str(path / "test")], capture_output=True, text=True,
                                    env={**os.environ, "ASAN_OPTIONS": "detect_leaks=0"})
        self.assertEqual(result.returncode, 0, result.stdout + result.stderr)
        print(result.stdout.strip())

    @unittest.skipIf(REFERENCE is None, "the reference checkout is not here")
    def test_the_table_is_the_reference_s(self):
        """Every entry of the generated header, and no other, is a form hg-engine
        marks NEEDS_REVERSION and the species FormReversionMapping sends it to."""
        written = dict(re.findall(r"\[SPECIES_(\w+) - NATIONAL_DEX_COUNT - 1\] = SPECIES_(\w+),",
                                  (ROOT / "src/data/form_reversion.h").read_text()))
        self.assertEqual(written, dict(import_form_reversion.table()))
        self.assertEqual(written["MINIOR_CORE_VIOLET"], "MINIOR_METEOR_VIOLET")
        self.assertEqual(written["GRENINJA_ASH"], "GRENINJA_BATTLE_BOND")
        self.assertNotIn("DARMANITAN_GALARIAN", written)

    def test_every_battle_is_set_up_and_cleared(self):
        """Where the forms are put on and taken off: the trainer battle's
        parties, a wild Pokemon, a battler leaving the field, the player's
        party at the end."""
        trainer = function((ROOT / "src/trainer_data.c").read_text(), "EnemyTrainerSet_Init")
        self.assertIn("Mon_ChangeToBattleForm(Party_GetMonByIndex(battleSetup->party[i], j));", trainer)
        wild = function((ROOT / "src/field/encounter_check.c").read_text(), "addGeneratedMonToBattleSetupParty")
        self.assertIn("Mon_ChangeToBattleForm(pokemon);", wild)
        switch = function((ROOT / "src/battle/battle_command.c").read_text(), "BtlCmd_SwitchAndUpdateMon")
        self.assertLess(switch.index("Mon_RevertFormChange("), switch.index("ctx->selectedMonIndex[battlerId] = ctx->unk_21A0[battlerId];"))
        self.assertIn("SPECIES_ZACIAN_CROWNED", switch)
        controller = (ROOT / "src/battle/battle_controller_player.c").read_text()
        self.assertIn("Mon_RevertFormChange(BattleSystem_GetPartyMon(battleSystem, BATTLER_PLAYER, i));",
                      function(controller, "RevertBattleForms"))
        self.assertRegex(controller, r"EaseBadPoison\(battleSystem\);\n\s*RevertBattleForms\(battleSystem\);")
        check = function((ROOT / "src/battle/overlay_12_0224E4FC.c").read_text(), "Battler_CheckWeatherFormChange")
        self.assertIn("SPECIES_XERNEAS_ACTIVE, FALSE);", check)


if __name__ == "__main__":
    unittest.main()
