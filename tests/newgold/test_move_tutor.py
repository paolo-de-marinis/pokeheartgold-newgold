#!/usr/bin/env python3
"""The move tutor reads each species' own record.

fielddata/wazaoshie/waza_oshie.json has a record a species with the egg and
the bad egg left out, and GetMoveTutorLearnsetIndex turns a species into a
record. It has been wrong twice: an index never set for an ordinary species,
then one set two records late for everything past Arceus -- Lillipup read
Stoutland's moves, and the last two forms read past the file.
"""

import json
import re
import unittest

from test_level_cap import ROOT


class MoveTutorTests(unittest.TestCase):
    def test_every_record_is_read_by_its_own_species(self):
        source = (ROOT / "src/field/scrcmd_move_tutor.c").read_text()
        self.assertIn("u16 index = species > SPECIES_ARCEUS ? species - 2 : species;", source)
        self.assertIn("return index - 1;", source)
        numbers = {m.group(1): int(m.group(2)) for m in
                   re.finditer(r"#define (SPECIES_[A-Z0-9_]+)\s+(\d+)", (ROOT / "include/constants/species.h").read_text())}
        records = json.loads((ROOT / "files/fielddata/wazaoshie/waza_oshie.json").read_text())["tutor"]
        for position, record in enumerate(records):
            species = numbers[record["mon"]]
            index = species - 2 if species > numbers["SPECIES_ARCEUS"] else species
            self.assertEqual(index - 1, position, record["mon"])

    def test_the_file_is_the_length_the_game_checks(self):
        header = (ROOT / "include/constants/species.h").read_text()
        last = re.search(r"#define NUM_SPECIES SPECIES_([A-Z0-9_]+)", header).group(1)
        count = int(re.search(rf"#define SPECIES_{last}\s+(\d+)", header).group(1))
        records = json.loads((ROOT / "files/fielddata/wazaoshie/waza_oshie.json").read_text())["tutor"]
        self.assertEqual(len(records), count - 2)


if __name__ == "__main__":
    unittest.main()
