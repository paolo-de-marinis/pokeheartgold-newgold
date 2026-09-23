#!/usr/bin/env python3
"""Run Pokemon Talk's species sampling with host sanitizers.

RadioShow_PokemonTalk_AddSpecies and RadioShow_PokemonTalk_SampleSpeciesFromMapEncounters
are extracted from the port's C, with the real EncounterData and show data
layouts. The encounter table, the Dex and the random number are stand-ins.
"""

import os
from pathlib import Path
import shlex
import subprocess
import tempfile
import unittest

from test_level_cap import ROOT, function

SHOW = ROOT / "src/application/pokegear/radio/shows/pokemon_talk.c"
ENCOUNTERS = ROOT / "include/wild_encounter.h"

PREFIX = r'''
#include <assert.h>
#include <stdint.h>
#include <string.h>
#include "constants/species.h"
typedef uint8_t u8; typedef uint16_t u16; typedef uint32_t u32;
typedef int BOOL;
#define TRUE 1
#define FALSE 0
enum HeapID { HEAP_ID_NONE };
typedef struct Pokedex Pokedex;
@TYPES@

static EncounterData map;
static u8 caught[NUM_SPECIES + 1];
static void WildEncounters_ReadFromNarc(EncounterData *out, u16 mapID) { (void)mapID; *out = map; }
static BOOL Pokedex_CheckMonCaughtFlag(Pokedex *pokedex, u16 species) { (void)pokedex; assert(species <= NUM_SPECIES); return caught[species]; }
static u32 LCRandom(void) { return 0; }
@NATIVE@

static u16 sample(PokemonTalkData *data) {
    memset(data, 0, sizeof(*data));
    return RadioShow_PokemonTalk_SampleSpeciesFromMapEncounters(data, 0, 0);
}

int main(void) {
    PokemonTalkData data;

    // Lillipup and Pidgey on Route 34's grass, neither caught: the added
    // species is named as readily as the retail one.
    map.encounterRate_walking = 25;
    map.landSlots.species_morn[0] = SPECIES_LILLIPUP;
    map.landSlots.species_day[0] = SPECIES_PIDGEY;
    assert(sample(&data) == SPECIES_LILLIPUP);
    assert(data.numSpecies == 2 && data.numPrioritySpecies == 2);

    // The last species is in range, and anything past it is not.
    memset(&map, 0, sizeof(map));
    map.encounterRate_surfing = 10;
    map.surfSlots[0].species = NUM_SPECIES;
    map.surfSlots[1].species = NUM_SPECIES + 1;
    assert(sample(&data) == NUM_SPECIES);
    assert(data.numSpecies == 1);

    // A caught one is still named, just not as a priority.
    caught[NUM_SPECIES] = TRUE;
    assert(sample(&data) == NUM_SPECIES && data.numPrioritySpecies == 0);

    // A map with nothing to name gives nothing, rather than a division by zero.
    memset(&map, 0, sizeof(map));
    assert(sample(&data) == SPECIES_NONE);
    return 0;
}
'''


def between(text, start, end):
    begin = text.index(start)
    return text[begin:text.index(end, begin) + len(end)]


class PokemonTalkTests(unittest.TestCase):
    def test_the_show_names_every_species(self):
        show = SHOW.read_text()
        types = "\n".join([
            between(ENCOUNTERS.read_text(), "#define NUM_ENCOUNTERS_LAND", "} EncounterData;"),
            between(show, "typedef struct PokemonTalkData {", "} PokemonTalkData;"),
        ])
        native = "\n".join([
            function(show, "RadioShow_PokemonTalk_AddSpecies"),
            function(show, "RadioShow_PokemonTalk_SampleSpeciesFromMapEncounters"),
        ])
        with tempfile.TemporaryDirectory(prefix="newgold-pokemon-talk-") as temp:
            c, exe = Path(temp) / "check.c", Path(temp) / "check"
            c.write_text(PREFIX.replace("@TYPES@", types).replace("@NATIVE@", native))
            result = subprocess.run(shlex.split(os.environ.get("CC", "cc")) + ["-std=c11", "-O1", "-g", "-fsanitize=address,undefined", "-fno-omit-frame-pointer", "-iquote", str(ROOT / "include"), str(c), "-o", str(exe)], capture_output=True, text=True)
            self.assertEqual(result.returncode, 0, result.stderr)
            result = subprocess.run([str(exe)], capture_output=True, text=True, env={**os.environ, "ASAN_OPTIONS": "detect_leaks=0", "UBSAN_OPTIONS": "halt_on_error=1"})
            self.assertEqual(result.returncode, 0, result.stderr)


if __name__ == "__main__":
    unittest.main()
