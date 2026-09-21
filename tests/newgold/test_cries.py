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

sys.path.insert(0, str(ROOT / "tools/newgold"))
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
            self.assertEqual(rate, import_cries.CRY_RATE)
            self.assertEqual(timer, round(import_cries.NDS_CLOCK / import_cries.CRY_RATE))
            self.assertGreater(loopLen, 0, index)
            self.assertEqual(len(blob), offset + 12 + loopLen * 4, index)


class CryLookupTests(unittest.TestCase):
    def setUp(self):
        self.source = SOURCE.read_text()
        self.banks = [int(n) for n in re.findall(
            r"^    (\d+), //", re.search(r"sAddedCryBanks\[\] = \{(.*?)\n\};", self.source, re.S).group(1), re.M)]

    def test_there_is_one_bank_for_every_added_species(self):
        self.assertEqual(len(self.banks), len(import_species.NEW_SPECIES))

    def test_no_bank_is_past_the_end_of_the_archive(self):
        limit = int(re.search(r"#define ARCHIVE_BANK_COUNT\s+(\d+)", self.source).group(1))
        archive = sdat.load(import_cries.ARCHIVE)
        self.assertEqual(limit, len(archive.records["SBNK"]))
        for bank in self.banks:
            self.assertLess(bank, limit)

    def test_both_ways_into_a_cry_go_through_the_lookup(self):
        """PlayCry and PlayCryEx both clamp, and both have to ask."""
        self.assertEqual(self.source.count("species = CryBankForSpecies(species);"), 2)
        self.assertEqual(self.source.count("static int CryBankForSpecies"), 1)


if __name__ == "__main__":
    unittest.main()
