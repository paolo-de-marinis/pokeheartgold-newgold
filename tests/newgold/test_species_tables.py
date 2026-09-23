#!/usr/bin/env python3
"""Check that nothing indexed by a species number stops before the last one.

This is the defect the expansion could repeat at any time. A table with one
entry a species -- an archive, or a static array in C -- was written when
there were 493 species and works perfectly until a number past its end is
asked for. Then:

  an archive returns the bytes that follow its allocation table, read as a
    member's start and end, so the length is arbitrary and the read overwrites
    whatever followed the destination -- a stack array, in the battle's case
  a static array returns whatever is next in .rodata, which is used as an
    archive member number, and the same thing happens one step later

Neither says anything. GF_ASSERT is compiled in but its report is gated off,
so the game carries on with a smashed stack. That is what a black battle and
a frozen one look like from the outside.

The archives are checked by reading them. The two tables in C that cannot be
extended -- there is no overworld model and no Pokeathlon record for an added
species -- are checked by insisting that their readers still bound the index.
"""

import re
import struct
import sys
import unittest
from pathlib import Path

from test_level_cap import ROOT

# Archives with one member a species, all of which are read with a species
# number and nothing else.
BY_SPECIES = [
    "files/poketool/personal/personal.narc",
    "files/poketool/personal/wotbl.narc",
    "files/poketool/personal/evo.narc",
]


def num_species():
    header = (ROOT / "include/constants/species.h").read_text()
    name = re.search(r"#define NUM_SPECIES SPECIES_([A-Z0-9_]+)", header).group(1)
    return int(re.search(rf"#define SPECIES_{name}\s+(\d+)", header).group(1))


def members(path):
    data = (ROOT / path).read_bytes()
    position = struct.unpack_from("<H", data, 12)[0]
    assert data[position:position + 4] == b"BTAF", path
    return struct.unpack_from("<H", data, position + 8)[0]


class ArchiveLengthTests(unittest.TestCase):
    def test_every_species_archive_reaches_the_last_species(self):
        """evo.narc is generated and not committed, so on a tree that has
        never been built there is nothing to read; what matters there is the
        rule below, which is what keeps it from going stale once it exists."""
        for path in BY_SPECIES:
            if not (ROOT / path).exists():
                continue
            self.assertGreaterEqual(
                members(path), num_species() + 1,
                f"{path} stops before species {num_species()}; a read past its "
                f"end takes a length out of the bytes after the file table")

    def test_the_evolution_archive_is_rebuilt_when_the_species_count_moves(self):
        """It is generated from a template sized at NUM_SPECIES + 1, and the
        rule has to say so or the archive silently keeps the old length."""
        self.assertIn("include/constants/species.h",
                      (ROOT / "files/poketool/personal/evo.mk").read_text())


class TableBoundTests(unittest.TestCase):
    """The two tables in C that stop at retail and cannot sensibly grow."""

    def table_length(self, path, name):
        text = (ROOT / path).read_text()
        body = re.search(rf"{name}\[\] = \{{(.*?)\n\}};", text, re.S).group(1)
        return len([line for line in body.splitlines() if line.strip().rstrip(",")])

    def test_the_follower_model_table_is_bounded_where_it_is_read(self):
        self.assertLess(self.table_length("src/follow_mon.c", "sModelIndexLUT"),
                        num_species() + 1)
        reader = re.search(r"int SpeciesToOverworldModelIndexOffset\(int species\) \{(.*?)\n\}",
                           (ROOT / "src/follow_mon.c").read_text(), re.S).group(1)
        self.assertIn("NELEMS(sModelIndexLUT)", reader)

    def test_the_pokeathlon_table_is_bounded_where_it_is_read(self):
        text = (ROOT / "src/pokemon.c").read_text()
        self.assertLess(self.table_length("src/pokemon.c", "sPokeathlonPerformanceArcIdxs"),
                        num_species() + 1)
        self.assertIn("NELEMS(sPokeathlonPerformanceArcIdxs)", text)
        # Past the table the form is not added either: member 0 plus a form
        # would be another species' record.
        self.assertIn("sPokeathlonPerformanceArcIdxs[species] + form : 0", text)

    def test_the_course_bounds_its_own_copy_of_the_pokeathlon_table(self):
        """The course reads performance.narc through ov96_0221AAE8, the same
        494 entries as pokemon.c's. The lookup is compiled on the host with
        the table as written and asked for retail and added species."""
        sys.path.insert(0, str(Path(__file__).parent))
        from test_dex_range import c_function, run_native
        table = (ROOT / "src/pokeathlon/overlay_96_0221AAE8.c").read_text()
        entries = re.search(r"ov96_0221AAE8\[MAX_SPECIES \+ 1\] = \{(.*?)\};", table, re.S).group(1)
        lookup = c_function((ROOT / "src/pokeathlon/overlay_96_021E679C.c").read_text(), "ov96_021E679C")
        run_native(self, COURSE.replace("@TABLE@", entries).replace("@LOOKUP@", lookup), "newgold-course-")


COURSE = r"""
#include <assert.h>
#include <stdio.h>
#define NELEMS(a) (sizeof(a) / sizeof((a)[0]))
typedef unsigned short u16;
static const u16 ov96_0221AAE8[493 + 1] = { @TABLE@ };
@LOOKUP@
int main(void) {
    assert(ov96_021E679C(1, 0) == ov96_0221AAE8[1]);
    assert(ov96_021E679C(386, 3) == ov96_0221AAE8[386] + 3); /* Deoxys Speed */
    assert(ov96_021E679C(493, 0) == ov96_0221AAE8[493]);
    for (int species = 494; species <= 1437; species++) {
        assert(ov96_021E679C(species, 0) == 0);
        assert(ov96_021E679C(species, 5) == 0);
    }
    printf("PASS: the course reads member 0 for every species past 493, form and all.\n");
    return 0;
}
"""


if __name__ == "__main__":
    unittest.main()


class SpeciesRangeTests(unittest.TestCase):
    """Every species konefr names has a counterpart here.

    The ledger used to compare the highest constant on each side -- 1041 here
    against 1075 there -- and read 34 short while nothing was missing: the
    reference leaves forty-eight reserved gaps between Arceus and its own
    additions, with bare numbers for names, and this tree numbers densely. The
    honest question is how many of their species this tree can name.
    """

    REFERENCE = Path("/home/paolo/Porting HGSS/hg-engine-newgold-reference")

    @staticmethod
    def named(path):
        return {name for name in re.findall(r"^#define\s+SPECIES_([A-Z0-9_]+)\s+\d+",
                                            Path(path).read_text(errors="replace"), re.M)
                if not name.isdigit()}

    def test_every_species_the_reference_names_is_here(self):
        if not self.REFERENCE.exists():
            self.skipTest("Pinned NewGold reference checkout not configured")
        theirs = self.named(self.REFERENCE / "include/constants/species.h")
        here = self.named(ROOT / "include/constants/species.h")
        self.assertEqual(sorted(theirs - here), [], "species the reference names and this tree has not")
        self.assertGreaterEqual(len(theirs), 1000)

    def test_the_gaps_the_reference_leaves_are_unnamed(self):
        if not self.REFERENCE.exists():
            self.skipTest("Pinned NewGold reference checkout not configured")
        text = (self.REFERENCE / "include/constants/species.h").read_text(errors="replace")
        gaps = [n for n in re.findall(r"^#define\s+SPECIES_([A-Z0-9_]+)\s+\d+", text, re.M)
                if n.isdigit()]
        self.assertGreater(len(gaps), 40, "the reserved gaps are what the old count mistook for work")
