#!/usr/bin/env python3
"""Check that a form counts in the Pokedex as its base species.

Every form is a species of its own here, past the last Dex species: a female
Pyroar is 1312, not Pyroar. The reference stores it as Pyroar and a form
number, so its Dex credits Pyroar. A female Litleo evolving at 35 is how the
difference shows: before src/pokedex.c mapped the form to its base, it left
Pyroar neither seen nor caught.
"""

import os
import re
import shlex
import subprocess
import tempfile
import unittest
from pathlib import Path

from test_level_cap import ROOT

REFERENCE = Path(os.environ.get("HG_ENGINE_NEWGOLD_REFERENCE",
                                "/home/paolo/Porting HGSS/hg-engine-newgold-reference"))
ENGINE = "d0380a487"


def definition(source, name):
    """A function, or a static inline one, by name, braces and all."""
    match = re.search(r"^[^\n;(]*\b" + name + r"\([^;{]*?\) \{", source, re.M)
    if match is None:
        raise ValueError(f"Function definition not found: {name}")
    depth, end = 1, match.end()
    while depth:
        depth += (source[end] == "{") - (source[end] == "}")
        end += 1
    return source[match.start():end]


def form_table(source):
    return re.search(r"static const u16 sFormBaseSpecies\[.*?\n\};", source, re.S).group(0)


def numbered():
    header = (ROOT / "include/constants/species.h").read_text()
    names = {name: int(number) for name, number in
             re.findall(r"#define SPECIES_([A-Z0-9_]+)\s+(\d+)", header)}
    last = names[re.search(r"#define LAST_DEX_SPECIES\s+SPECIES_([A-Z0-9_]+)", header).group(1)]
    gap = [names[re.search(rf"#define {edge}\s+SPECIES_([A-Z0-9_]+)", header).group(1)]
           for edge in ("FIRST_DEX_GAP", "LAST_DEX_GAP")]
    return names, last, gap


def run(program, prefix):
    with tempfile.TemporaryDirectory(prefix=prefix) as temp:
        c, exe = Path(temp) / "check.c", Path(temp) / "check"
        c.write_text(program)
        result = subprocess.run(shlex.split(os.environ.get("CC", "cc")) + [
            "-std=c11", "-O1", "-g", "-fsanitize=address,undefined", "-fno-omit-frame-pointer",
            "-iquote", str(ROOT / "include"), str(c), "-o", str(exe)], capture_output=True, text=True)
        if result.returncode:
            raise AssertionError(result.stderr)
        result = subprocess.run([str(exe)], capture_output=True, text=True,
                                env={**os.environ, "ASAN_OPTIONS": "detect_leaks=0",
                                     "UBSAN_OPTIONS": "halt_on_error=1"})
        if result.returncode:
            raise AssertionError(result.stdout + result.stderr)
        return result.stdout.strip()


PREFIX = r'''
#include <assert.h>
#include <stdint.h>
#include <stdio.h>
#include <string.h>
#include "constants/species.h"
#include "constants/pokemon.h"
typedef uint8_t u8;
typedef uint16_t u16;
typedef uint32_t u32;
typedef int BOOL;
#define TRUE 1
#define FALSE 0
#define GF_ASSERT(expr) assert(expr)
'''

REGISTRATION = PREFIX + r'''
#define POKEDEX_MAGIC 0xBEEFCAFE
#define ASSERT_POKEDEX(pokedex) assert((pokedex)->magic == POKEDEX_MAGIC)
#define GAME_LANGUAGE 2
#define WORDS ((NATIONAL_DEX_COUNT + 8 + 31) / 32)

// The fields the two setters touch, sized as the save's are: for the Dex
// species and no further, so a form's own number would be out of bounds.
typedef struct Pokedex {
    u32 magic;
    u32 caughtSpecies[WORDS];
    u32 seenSpecies[WORDS];
    u32 seenGenders[2][WORDS];
    u32 spindaPersonality;
} Pokedex;

typedef struct Pokemon { u16 species; } Pokemon;
static u32 GetMonData(Pokemon *mon, int field, void *unused) {
    (void)unused;
    return field == MON_DATA_SPECIES ? mon->species : 0;
}
static u32 GetMonGender(Pokemon *mon) { (void)mon; return MON_FEMALE; }
static u32 GetMonUnownLetter(Pokemon *mon) { (void)mon; return 0; }
static void Pokedex_TryAppendSeenForm(Pokedex *pokedex, u16 species, Pokemon *mon) { (void)pokedex; (void)species; (void)mon; }
static void Pokedex_TryAppendUnownLetter(Pokedex *pokedex, u32 letter, BOOL caught) { (void)pokedex; (void)letter; (void)caught; }
static void Pokedex_SetCaughtLanguage(Pokedex *pokedex, u32 species, u32 language) { (void)pokedex; (void)species; (void)language; }
static void Pokedex_SetInternationalViewFlag(Pokedex *pokedex) { (void)pokedex; }
@NATIVE@

int main(void) {
    static Pokedex dex = { .magic = POKEDEX_MAGIC };

    // A female Litleo evolved: the scene registers the mon as Pyroar's
    // female form, and the Dex credits Pyroar, female.
    Pokemon pyroar = { SPECIES_PYROAR_FEMALE };
    Pokedex_SetMonCaughtFlag(&dex, &pyroar);
    assert(Pokedex_CheckMonCaughtFlag(&dex, SPECIES_PYROAR));
    assert(Pokedex_CheckMonSeenFlag(&dex, SPECIES_PYROAR));
    assert(CheckDexFlag((const u8 *)dex.seenGenders[0], SPECIES_PYROAR));
    // Asking about the form asks about its base.
    assert(Pokedex_CheckMonCaughtFlag(&dex, SPECIES_PYROAR_FEMALE));

    // Seeing a form is seeing its base, and no more than that.
    Pokemon meowstic = { SPECIES_MEOWSTIC_FEMALE };
    Pokedex_SetMonSeenFlag(&dex, &meowstic);
    assert(Pokedex_CheckMonSeenFlag(&dex, SPECIES_MEOWSTIC));
    assert(!Pokedex_CheckMonCaughtFlag(&dex, SPECIES_MEOWSTIC));

    // A Gigantamax Low Key Toxtricity is a Toxtricity, not a Low Key one,
    // which has no page either.
    Pokemon toxtricity = { SPECIES_GIGANTAMAX_TOXTRICITY_LOW_KEY };
    Pokedex_SetMonCaughtFlag(&dex, &toxtricity);
    assert(Pokedex_CheckMonCaughtFlag(&dex, SPECIES_TOXTRICITY));

    // Every form lands on a Dex page, and nothing else moves.
    for (u16 species = NATIONAL_DEX_COUNT + 1; species <= NUM_SPECIES; species++) {
        Pokemon mon = { species };
        Pokedex_SetMonSeenFlag(&dex, &mon);
        assert(Pokedex_CheckMonSeenFlag(&dex, species));
    }
    for (u16 species = 1; species <= NATIONAL_DEX_COUNT; species++) {
        assert(SpeciesToDexSpecies(species) == species);
    }
    printf("PASS: %d forms register as their base species.\n", NUM_SPECIES - NATIONAL_DEX_COUNT);
    return 0;
}
'''

NATIVE = ["CheckDexFlag", "SetDexFlag", "SetDexFlagState", "CheckDexGender",
          "Pokedex_SetSeenGenderFlagInternal", "Pokedex_SetSeenGenderFlag",
          "DexSpeciesIsInvalid", "SpeciesToDexSpecies", "Pokedex_CheckMonCaughtFlag",
          "Pokedex_CheckMonSeenFlag", "Pokedex_SetMonSeenFlag", "Pokedex_SetMonCaughtFlag"]


class FormTableTests(unittest.TestCase):
    def setUp(self):
        self.table = dict(re.findall(r"\[SPECIES_([A-Z0-9_]+) - NATIONAL_DEX_COUNT - 1\] = SPECIES_([A-Z0-9_]+),",
                                     form_table((ROOT / "src/pokedex.c").read_text())))

    def test_every_form_has_a_dex_species(self):
        names, last, (first_gap, last_gap) = numbered()
        forms = {name for name, number in names.items() if number > last}
        self.assertEqual(set(self.table), forms)
        for form, base in self.table.items():
            self.assertLessEqual(names[base], last, form)
            self.assertFalse(first_gap <= names[base] <= last_gap, form)
        self.assertEqual(self.table["PYROAR_FEMALE"], "PYROAR")

    def test_the_table_is_the_reference_form_data(self):
        """The reference's PokeFormDataTbl lists each form under the species
        it stores for it. The importer reads FormToSpeciesMapping instead, so
        this is a second source, not the same one read twice."""
        if not (REFERENCE / ".git").exists():
            self.skipTest("no reference checkout")
        source = subprocess.run(["git", "-C", str(REFERENCE), "show", f"{ENGINE}:data/PokeFormDataTbl.c"],
                                capture_output=True, text=True, errors="replace", check=True).stdout
        stored = {}
        for base, body in re.findall(r"\[SPECIES_([A-Z0-9_]+)\]\s*=\s*\{(.*?)\}", source, re.S):
            for form in re.findall(r"SPECIES_([A-Z0-9_]+)", body):
                stored.setdefault(form, set()).add(base)
        for form, base in self.table.items():
            self.assertEqual(stored.get(form), {base}, form)


class FormRegistrationTests(unittest.TestCase):
    def test_a_form_registers_its_base(self):
        source = (ROOT / "src/pokedex.c").read_text()
        native = form_table(source) + "\n" + "\n".join(definition(source, name) for name in NATIVE)
        print(run(REGISTRATION.replace("@NATIVE@", native), "newgold-form-dex-"))


if __name__ == "__main__":
    unittest.main()
