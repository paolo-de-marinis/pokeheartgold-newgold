#!/usr/bin/env python3
"""Check the Dex footprint archive.

Nothing indexes this archive by name: the game reads member `species + 2`. A
missing member would not leave one species without a print — every member after
it would shift, and every species after it would show the wrong footprint. So
what is checked is that the members run unbroken from the first species to the
last, and that a member here still converts to exactly the bytes the reference
ships.
"""

import subprocess
import sys
import tempfile
import unittest
from pathlib import Path

from test_level_cap import ROOT

sys.path[:0] = [str(ROOT / "tools/newgold" / sub) for sub in ("import", "devkit", "devkit/harness", "devkit/diag")]
import import_footprints  # noqa: E402

FOOTPRINTS = ROOT / "files/poketool/pokefoot/pokefoot"
REFERENCE = Path("/home/paolo/Porting HGSS/hg-engine-newgold-reference")


def members():
    return sorted(int(p.stem.split("_")[1]) for p in FOOTPRINTS.glob("pokefoot_*.png"))


class FootprintTests(unittest.TestCase):
    def setUp(self):
        self.members = members()

    def test_the_archive_has_no_holes(self):
        self.assertEqual(self.members, list(range(self.members[0], self.members[-1] + 1)))

    def test_every_species_has_one(self):
        header = (ROOT / "include/constants/species.h").read_text()
        import re
        last = max(int(m) for m in re.findall(r"#define SPECIES_[A-Z0-9_]+\s+(\d+)\s*$", header, re.M))
        self.assertGreaterEqual(self.members[-1], last + import_footprints.MEMBER_OFFSET,
                                "the archive stops before the last species")
        print(f"PASS: {len(self.members)} footprints, species 1 to {self.members[-1] - import_footprints.MEMBER_OFFSET}.")

    def test_a_footprint_converts_to_what_the_reference_ships(self):
        """The whole pipeline, both ways, on a species the reference has."""
        source = REFERENCE / "rawdata/footprints/a069_0012"
        if not source.exists():
            self.skipTest("reference checkout not present")
        gfx = import_footprints.GFX
        with tempfile.TemporaryDirectory(prefix="newgold-footprint-test-") as temp:
            chars, packed = Path(temp) / "f.NCGR", Path(temp) / "f.NCGR.lz"
            subprocess.run([gfx, FOOTPRINTS / "pokefoot_00000012.png", chars,
                            "-clobbersize", "-version101", "-mappingtype", "128"],
                           check=True, capture_output=True)
            subprocess.run([gfx, chars, packed, "-nopad"], check=True, capture_output=True)
            self.assertEqual(packed.read_bytes(), source.read_bytes())


if __name__ == "__main__":
    unittest.main()
