#!/usr/bin/env python3
"""Run the photo viewer's and the photo album's party counts with host sanitizers.

Photo_CountValidMons (src/application/view_photo.c) and its twin in the album,
ov109_021E7850 (src/overlay_109_021E7850.c), choose between the single-Pokemon
caption and the "... and friends" one. Each is extracted and run against the
real PhotoMon layout; the rest of the photo is a stand-in.
"""

import os
from pathlib import Path
import shlex
import subprocess
import tempfile
import unittest

from test_level_cap import ROOT, function

PREFIX = r'''
#include <assert.h>
#include <stdint.h>
#include "constants/species.h"
typedef uint8_t u8; typedef uint16_t u16;
@PARTY_SIZE@
@PHOTOMON@
typedef struct Photo { PhotoMon party[PARTY_SIZE]; } Photo;
@NATIVE@
#define COUNT @NAME@

int main(void) {
    // A retail species and an added one are two, so the caption is "and friends".
    Photo photo = { .party = { { .species = SPECIES_PIDGEY }, { .species = SPECIES_LILLIPUP } } };
    assert(COUNT(&photo) == 2);

    // A party of added species only is counted too, up to the last species.
    Photo added = { .party = { { .species = SPECIES_LILLIPUP }, { .species = NUM_SPECIES } } };
    assert(COUNT(&added) == 2);

    // Eggs are stored as SPECIES_NONE and nothing exists past the last species.
    Photo empty = { .party = { { .species = SPECIES_NONE }, { .species = NUM_SPECIES + 1 } } };
    assert(COUNT(&empty) == 0);
    return 0;
}
'''


class PhotoCaptionTests(unittest.TestCase):
    def test_added_species_count_toward_the_caption(self):
        self.check("src/application/view_photo.c", "Photo_CountValidMons")

    def test_the_album_counts_them_too(self):
        self.check("src/overlay_109_021E7850.c", "ov109_021E7850")

    def check(self, path, name):
        header = (ROOT / "include/photo_album.h").read_text()
        photomon = header[header.index("typedef struct PhotoMon {"):]
        photomon = photomon[:photomon.index("} PhotoMon;") + len("} PhotoMon;")]
        party = next(l for l in (ROOT / "include/constants/global.h").read_text().splitlines() if l.startswith("#define PARTY_SIZE"))
        native = function((ROOT / path).read_text(), name)
        with tempfile.TemporaryDirectory(prefix="newgold-photo-caption-") as temp:
            c, exe = Path(temp) / "check.c", Path(temp) / "check"
            c.write_text(PREFIX.replace("@PARTY_SIZE@", party).replace("@PHOTOMON@", photomon).replace("@NATIVE@", native).replace("@NAME@", name))
            result = subprocess.run(shlex.split(os.environ.get("CC", "cc")) + ["-std=c11", "-O1", "-g", "-fsanitize=address,undefined", "-fno-omit-frame-pointer", "-iquote", str(ROOT / "include"), str(c), "-o", str(exe)], capture_output=True, text=True)
            self.assertEqual(result.returncode, 0, result.stderr)
            result = subprocess.run([str(exe)], capture_output=True, text=True, env={**os.environ, "ASAN_OPTIONS": "detect_leaks=0", "UBSAN_OPTIONS": "halt_on_error=1"})
            self.assertEqual(result.returncode, 0, result.stderr)


if __name__ == "__main__":
    unittest.main()
