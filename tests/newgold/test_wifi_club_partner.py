#!/usr/bin/env python3
"""Run the Wi-Fi Club partner check natively.

ov44_0222DFEC comes from src/overlay_44_0222CDAC.c and its record from
include/overlay_44_02232E9C.h. A partner whose party holds an added species
or item must be accepted; the bad egg, the form ids 496..507 and anything
past the last species or item are still refused.
"""

import os
from pathlib import Path
import re
import shlex
import subprocess
import tempfile
import unittest

from test_repels import ROOT, function

PREFIX = r'''
#include <assert.h>
#include <stdint.h>
#include <stdio.h>
#include <string.h>
#include "constants/items.h"
#include "constants/species.h"
typedef uint8_t u8; typedef uint16_t u16; typedef uint32_t u32; typedef int32_t s32;
@TYPES@
@NATIVE@
'''

MAIN = r'''
static s32 check(u16 species, u16 item) {
    UnkStruct_ov44_02231958 partner;
    memset(&partner, 0, sizeof(partner));
    for (int i = 0; i < 6; i++) {
        partner.unk0[i] = SPECIES_PIKACHU;
        partner.unkC[i] = ITEM_NONE;
    }
    partner.unk0[5] = species;
    partner.unkC[3] = item;
    return ov44_0222DFEC(&partner);
}

int main(void) {
    for (u32 species = 0; species <= NUM_SPECIES + 1; species++) {
        int refused = (species >= SPECIES_BAD_EGG && species <= SPECIES_ROTOM_MOW) || species > NUM_SPECIES;
        assert(check(species, ITEM_NONE) == !refused);
    }
    for (u32 item = 0; item <= ITEMS_COUNT; item++) {
        assert(check(SPECIES_PIKACHU, item) == (item < ITEMS_COUNT));
    }
    // Eggs were always accepted, and still are.
    assert(check(SPECIES_EGG, ITEM_NONE) == 1);
    assert(check(SPECIES_LILLIPUP, ITEM_CANARI_BREAD) == 1);
    puts("PASS: every species and item id through the Wi-Fi Club partner check.");
}
'''


class WifiClubPartnerTests(unittest.TestCase):
    def test_partner_with_added_species_or_items_is_accepted(self):
        header = (ROOT / "include/overlay_44_02232E9C.h").read_text()
        types = re.search(r"^typedef struct UnkStruct_ov44_02231958 \{.*?^\} UnkStruct_ov44_02231958;", header, re.M | re.S).group(0)
        native = function((ROOT / "src/overlay_44_0222CDAC.c").read_text(), "ov44_0222DFEC")
        source = PREFIX.replace("@TYPES@", types).replace("@NATIVE@", native) + MAIN
        with tempfile.TemporaryDirectory(prefix="newgold-wifi-club-") as temp:
            c, exe = Path(temp) / "check.c", Path(temp) / "check"
            c.write_text(source)
            result = subprocess.run(shlex.split(os.environ.get("CC", "cc")) + ["-std=c11", "-O1", "-g", "-fsanitize=address,undefined", "-iquote", str(ROOT / "include"), str(c), "-o", str(exe)], capture_output=True, text=True)
            self.assertEqual(result.returncode, 0, result.stderr)
            result = subprocess.run([str(exe)], capture_output=True, text=True, env={**os.environ, "ASAN_OPTIONS": "detect_leaks=0", "UBSAN_OPTIONS": "halt_on_error=1"})
            self.assertEqual(result.returncode, 0, result.stderr)
            print(result.stdout.strip())


if __name__ == "__main__":
    unittest.main()
