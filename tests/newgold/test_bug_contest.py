#!/usr/bin/env python3
"""Check the Bug-Catching Contest table.

The contest does not read the wild encounter NARC: it reads
files/data/mushi/mushi_encount.csv, which is why the rebalance that changed
every route left this one table vanilla. A contest handing out Caterpie at
level seven beside a level cap of thirty is not obviously broken -- it is just
the wrong game -- so nothing would have said so.

Only the first of the four tables is New Gold's. The other three are what the
base ROM plays after the National Dex, and the reference leaves them alone.
"""

import csv
import re
import unittest
from pathlib import Path

from test_level_cap import ROOT

TABLE = ROOT / "files/data/mushi/mushi_encount.csv"
PER_TABLE = 10
STORY_CAP = 30  # Whitney's cap, which the contest is balanced around


def species_constants():
    return set(re.findall(r"#define (SPECIES_[A-Z0-9_]+)",
                          (ROOT / "include/constants/species.h").read_text()))


class BugContestTests(unittest.TestCase):
    def setUp(self):
        with TABLE.open() as f:
            self.rows = list(csv.DictReader(f))
        self.story = self.rows[:PER_TABLE]

    def test_the_table_still_has_its_four_tables(self):
        self.assertEqual(len(self.rows), 4 * PER_TABLE)

    def test_the_story_contest_is_new_golds(self):
        wanted = ["SPECIES_BUTTERFREE", "SPECIES_BEEDRILL", "SPECIES_ARIADOS",
                  "SPECIES_LEDIAN", "SPECIES_SHUCKLE", "SPECIES_SCYTHER",
                  "SPECIES_PINSIR", "SPECIES_HERACROSS", "SPECIES_GALVANTULA",
                  "SPECIES_ESCAVALIER"]
        self.assertEqual([row["species"] for row in self.story], wanted)

    def test_the_thresholds_and_scores_are_the_references(self):
        self.assertEqual([int(row["rate"]) for row in self.story],
                         [80, 60, 50, 40, 30, 20, 15, 10, 5, 0])
        self.assertEqual([int(row["score"]) for row in self.story],
                         [60, 60, 60, 60, 80, 80, 80, 80, 100, 100])

    def test_the_levels_sit_under_the_cap_the_contest_is_played_at(self):
        for row in self.story:
            self.assertLessEqual(int(row["lvlmin"]), int(row["lvlmax"]), row["species"])
            self.assertLessEqual(int(row["lvlmax"]), STORY_CAP, row["species"])
            self.assertGreaterEqual(int(row["lvlmin"]), 20, row["species"])

    def test_every_species_named_exists(self):
        known = species_constants()
        for row in self.rows:
            self.assertIn(row["species"], known, row["species"])

    def test_the_thresholds_descend_in_every_table(self):
        """The rate is a descending threshold, not a percentage, so a table
        whose rates do not fall would never reach its last entries."""
        for start in range(0, len(self.rows), PER_TABLE):
            rates = [int(row["rate"]) for row in self.rows[start:start + PER_TABLE]]
            self.assertEqual(rates, sorted(rates, reverse=True), f"table at row {start}")
            self.assertEqual(rates[-1], 0, f"table at row {start} never reaches its last slot")


if __name__ == "__main__":
    unittest.main()
