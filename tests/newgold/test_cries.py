#!/usr/bin/env python3
"""Check the sound archive and the cries added to it.

A cry is bank N played as sequence 2, and nothing bounds N but the code that
picks it: a species past the end of the bank list would read whatever follows
it. The archive is also a binary with no text source, so the tool that writes
it has to reproduce what it did not touch exactly.
"""

import re
import struct
import sys
import unittest
from pathlib import Path

from test_level_cap import ROOT

sys.path[:0] = [str(ROOT / "tools/newgold" / sub) for sub in ("import", "devkit", "devkit/harness", "devkit/diag")]
import import_cries  # noqa: E402
import import_species  # noqa: E402
import sdat  # noqa: E402

SOURCE = ROOT / "src/unk_02005D10.c"
RETAIL_BANKS = 778


class SoundArchiveTests(unittest.TestCase):
    def setUp(self):
        self.archive = sdat.load(import_cries.ARCHIVE)

    def test_the_archive_rebuilds_byte_for_byte(self):
        self.assertEqual(self.archive.build(), self.archive.data)

    def test_every_added_species_has_a_bank(self):
        banks = self.archive.records["SBNK"]
        wars = self.archive.records["SWAR"]
        self.assertEqual(len(banks), len(wars))
        self.assertGreater(len(banks), RETAIL_BANKS)
        for index in range(RETAIL_BANKS, len(banks)):
            self.assertIsNotNone(banks[index], index)
            self.assertIsNotNone(wars[index], index)
            fileId, _, first = struct.unpack("<HH4H", banks[index])[:3]
            self.assertEqual(first, index, "a bank must name its own wave archive")
            self.assertEqual(len(self.archive.files[fileId]), 76)

    def test_every_added_wave_archive_holds_one_playable_sample(self):
        for index in range(RETAIL_BANKS, len(self.archive.records["SWAR"])):
            fileId, = struct.unpack("<H", self.archive.records["SWAR"][index][:2])
            blob = self.archive.files[fileId]
            self.assertEqual(blob[:4], b"SWAR", index)
            self.assertEqual(struct.unpack("<I", blob[8:12])[0], len(blob), index)
            count, offset = struct.unpack("<II", blob[0x38:0x40])
            self.assertEqual(count, 1, index)
            fmt, loop, rate, timer, loopStart, loopLen = struct.unpack("<BBHHHI", blob[offset:offset + 12])
            self.assertEqual(fmt, 0, "eight-bit samples")
            # A long cry is sampled lower so that it fits the cry player's heap.
            self.assertLessEqual(rate, import_cries.CRY_RATE)
            self.assertEqual(timer, round(import_cries.NDS_CLOCK / rate))
            self.assertGreater(loopLen, 0, index)
            self.assertEqual(len(blob), offset + 12 + loopLen * 4, index)

    def test_every_added_cry_fits_the_cry_players_heap(self):
        # A cry whose bank and wave archive outweigh HeartGold's largest is
        # never started: 18 added species had no cry at all.
        room = import_cries.cry_room(self.archive)
        for index in range(RETAIL_BANKS, len(self.archive.records["SBNK"])):
            bankFile, _, war = struct.unpack("<HHH", self.archive.records["SBNK"][index][:6])
            warFile, = struct.unpack("<H", self.archive.records["SWAR"][war][:2])
            self.assertLessEqual(len(self.archive.files[bankFile]) + len(self.archive.files[warFile]), room, index)


class CryLookupTests(unittest.TestCase):
    def setUp(self):
        self.source = SOURCE.read_text()
        self.banks = [int(n) for n in re.findall(
            r"^    (\d+), //", re.search(r"sAddedCryBanks\[\] = \{(.*?)\n\};", self.source, re.S).group(1), re.M)]

    def test_there_is_one_bank_for_every_added_species(self):
        self.assertEqual(len(self.banks), len(import_species.added_species()))

    def test_the_lookup_lands_on_the_table(self):
        """The index must put the first added species at entry zero.

        CryBankForSpecies reads sAddedCryBanks[species - NUM_SPECIES_WITH_CRIES
        - 1]. The egg, the bad egg and the twelve alternate forms sit between
        Arceus and the first added species and have no cries, so that constant
        is the last identifier with one, not the count of them. It said 494
        for a table that starts at 508, which slid every added species
        thirteen entries along and ran the last thirteen off the end.
        """
        constant = int(re.search(r"#define NUM_SPECIES_WITH_CRIES\s+(\d+)",
                                 self.source).group(1))
        header = (ROOT / "include/constants/species.h").read_text()
        numbers = {name: int(value) for name, value in
                   re.findall(r"#define SPECIES_([A-Z0-9_]+)\s+(\d+)", header)}
        added = import_species.added_species()
        first = numbers[added[0]] - constant - 1
        last = numbers[added[-1]] - constant - 1
        self.assertEqual(first, 0, f"{added[0]} lands on entry {first}, not the first")
        self.assertEqual(last, len(self.banks) - 1,
                         f"{added[-1]} lands on entry {last} of {len(self.banks)}")

    def test_no_bank_is_past_the_end_of_the_archive(self):
        limit = int(re.search(r"#define ARCHIVE_BANK_COUNT\s+(\d+)", self.source).group(1))
        archive = sdat.load(import_cries.ARCHIVE)
        self.assertEqual(limit, len(archive.records["SBNK"]))
        for bank in self.banks:
            self.assertLess(bank, limit)

    def test_both_ways_into_a_cry_go_through_the_lookup(self):
        """PlayCry and PlayCryEx both clamp, and both have to ask."""
        self.assertEqual(self.source.count("CryBankForSpecies("),
                         1 + 2, "the definition and one lookup on each way in")
        self.assertEqual(self.source.count("static int CryBankForSpecies"), 1)

    def test_a_second_lookup_would_not_be_harmless(self):
        """Most added banks are themselves a number in the species range.

        CryBankForSpecies is not safe to apply twice: the added species run
        from NUM_SPECIES_WITH_CRIES + 1 to the end of the table, and a bank
        that happens to fall in that window is mapped again into somebody
        else's. Cryogonal's 997 is the plain case.
        """
        constant = int(re.search(r"#define NUM_SPECIES_WITH_CRIES\s+(\d+)",
                                 self.source).group(1))
        last = constant + len(self.banks)
        collide = [bank for bank in self.banks if constant < bank <= last]
        self.assertEqual(len(collide), 781)
        self.assertIn(997, collide)

    def test_play_cry_ex_keeps_its_argument_a_species(self):
        """It maps once, for the archive, and hands PlayCry the species.

        PlayCry and sub_02006AC0 look a bank up for themselves, so a number
        this function has already mapped goes through the table twice. Which
        is what used to happen, and what the count above says it costs.
        """
        body = re.search(r"\nBOOL PlayCryEx\([^)]*\) \{\n(.*?)\n\}\n", self.source, re.S).group(1)
        self.assertNotIn("species = CryBankForSpecies", body)
        for call in ("PlayCry(", "sub_02006AC0("):
            args = re.findall(re.escape(call) + r"(\w+)", body)
            self.assertTrue(args, call)
            self.assertLessEqual(set(args), {"species", "0x1B9"}, call)
        for call in ("sub_02006820(", "sub_020057AC(", "sub_02006AF4("):
            args = re.findall(re.escape(call) + r"(\w+)", body)
            self.assertTrue(args, call)
            self.assertEqual(set(args), {"bank"}, call)


if __name__ == "__main__":
    unittest.main()
