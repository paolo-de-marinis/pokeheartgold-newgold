#!/usr/bin/env python3
"""Check the wild forms hg-engine's UpdatePassiveForms gives.

Half of all wild Unfezant, Frillish and Jellicent are the female form, and one
wild Dunsparce or Tandemaus in a hundred carries form 1 into Dudunsparce's
Three-Segment Form or Maushold's Family of Three. The three functions that do
it are the real ones, run on the host; that the encounter code and
GetMonEvolution call them is read from the source.
"""

import os
import re
import shlex
import subprocess
import tempfile
import unittest
from pathlib import Path

from test_level_cap import ROOT
from test_repels import function

FIXTURE = r"""
#include <assert.h>
#include <stddef.h>
#include <stdint.h>
#include "constants/pokemon.h"
#include "constants/species.h"
typedef uint8_t u8;
typedef uint16_t u16;
typedef uint32_t u32;
typedef struct { u32 species, personality, form; int formWrites; } Pokemon;
static u32 randoms[8];
static int drawn;
static u32 LCRandom(void) { return randoms[drawn++]; }
static u32 GetMonData(Pokemon *mon, int attr, void *out) {
    assert(out == NULL);
    switch (attr) {
    case MON_DATA_SPECIES: return mon->species;
    case MON_DATA_PERSONALITY: return mon->personality;
    case MON_DATA_FORM: return mon->form;
    }
    assert(0);
    return 0;
}
static void SetMonData(Pokemon *mon, int attr, const void *value) {
    assert(attr == MON_DATA_FORM);
    mon->form = *(const u8 *)value;
    mon->formWrites++;
}
@FUNCTIONS@
static u16 wild(u16 species, u32 random) {
    randoms[0] = random;
    drawn = 0;
    return WildMon_PassiveFormSpecies(species);
}
int main(void) {
    const u16 base[] = { SPECIES_UNFEZANT, SPECIES_FRILLISH, SPECIES_JELLICENT };
    const u16 female[] = { SPECIES_UNFEZANT_FEMALE, SPECIES_FRILLISH_FEMALE, SPECIES_JELLICENT_FEMALE };
    for (int i = 0; i < 3; i++) {
        assert(wild(base[i], 2) == base[i] && drawn == 1);
        assert(wild(base[i], 7) == female[i] && drawn == 1);
    }
    // Everything else draws nothing, including the female forms themselves.
    const u16 others[] = { SPECIES_PIDOVE, SPECIES_TRANQUILL, SPECIES_UNFEZANT_FEMALE, SPECIES_DUNSPARCE };
    for (int i = 0; i < 4; i++) {
        assert(wild(others[i], 7) == others[i] && drawn == 0);
    }

    const u32 species[] = { SPECIES_DUNSPARCE, SPECIES_TANDEMAUS, SPECIES_RATTATA };
    const u32 pids[] = { 0, 100, 4200, 1, 99, 12345 };
    for (int s = 0; s < 3; s++) {
        for (int p = 0; p < 6; p++) {
            Pokemon mon = { species[s], pids[p], 0, 0 };
            WildMon_SetPassiveForm(&mon);
            assert(mon.form == (s < 2 && pids[p] % 100 == 0));
            assert(mon.formWrites == (s < 2));
        }
    }

    Pokemon one = { SPECIES_DUNSPARCE, 0, 1, 0 }, zero = { SPECIES_DUNSPARCE, 0, 0, 0 };
    assert(EvolvedPassiveForm(&one, SPECIES_DUDUNSPARCE) == SPECIES_DUDUNSPARCE_THREE_SEGMENT);
    assert(EvolvedPassiveForm(&one, SPECIES_MAUSHOLD) == SPECIES_MAUSHOLD_FAMILY_OF_THREE);
    assert(EvolvedPassiveForm(&one, SPECIES_JELLICENT) == SPECIES_JELLICENT);
    assert(EvolvedPassiveForm(&one, SPECIES_NONE) == SPECIES_NONE);
    assert(EvolvedPassiveForm(&zero, SPECIES_DUDUNSPARCE) == SPECIES_DUDUNSPARCE);
    assert(EvolvedPassiveForm(&zero, SPECIES_MAUSHOLD) == SPECIES_MAUSHOLD);
    return 0;
}
"""


class PassiveForms(unittest.TestCase):
    def test_the_forms_are_given_and_kept(self):
        encounters = (ROOT / "src/field/encounter_check.c").read_text()
        pokemon = (ROOT / "src/pokemon.c").read_text()
        program = FIXTURE.replace("@FUNCTIONS@", "\n".join([
            function(encounters, "WildMon_PassiveFormSpecies"),
            function(encounters, "WildMon_SetPassiveForm"),
            function(pokemon, "EvolvedPassiveForm")]))
        with tempfile.TemporaryDirectory(prefix="newgold-forms-") as directory:
            path = Path(directory)
            (path / "test.c").write_text(program)
            subprocess.run(shlex.split(os.environ.get("CC", "cc")) + [
                "-std=c99", "-Wall", "-Werror", "-iquote", str(ROOT / "include"),
                str(path / "test.c"), "-o", str(path / "test")], check=True)
            subprocess.run([str(path / "test")], check=True)

    def test_every_wild_pokemon_goes_through_them(self):
        encounters = (ROOT / "src/field/encounter_check.c").read_text()
        for generator in ("generateWildShinyAndAddToParty", "generateWildNonShinyAndAddToParty"):
            body = function(encounters, generator)
            # Before anything reads the species: Cute Charm asks its gender ratio.
            self.assertRegex(body, r"ZeroMonData\(wildMon\);\n    species = WildMon_PassiveFormSpecies\(species\);\n",
                             generator)
        self.assertIn("WildMon_SetPassiveForm(pokemon);",
                      function(encounters, "addGeneratedMonToBattleSetupParty"))
        self.assertRegex(function((ROOT / "src/pokemon.c").read_text(), "GetMonEvolution"),
                         r"return EvolvedPassiveForm\(mon, target\);\n\}$")


if __name__ == "__main__":
    unittest.main()
