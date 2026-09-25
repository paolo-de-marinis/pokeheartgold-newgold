#!/usr/bin/env python3
"""Check the sound archive and the cries added to it.

A cry is wave archive N played as sequence 2 -- on bank N where N has one,
on bank 1's instrument where it does not (every added cry) -- and nothing
bounds N but the code that picks it: a species past the end of the list would
read whatever follows it. The archive is also a binary with no text source, so
the tool that writes it has to reproduce what it did not touch exactly.
"""

import re
import struct
import sys
import unittest
from collections import Counter
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

    def test_dropping_unused_files_keeps_every_record_on_its_bytes(self):
        """sdat.drop_unused_files finds nothing to drop in the committed
        archive; and a record nulled takes its file with it, the files after
        it move down one, and every other record still names the same bytes."""
        def fileId(record):
            return struct.unpack("<I", record[:4])[0] & 0xFFFFFF

        def contents():
            return {(kind, i): self.archive.files[fileId(r)] for kind in sdat.FILE_KINDS
                    for i, r in enumerate(self.archive.records[kind]) if r is not None}
        self.archive.drop_unused_files()
        self.assertEqual(self.archive.build(), self.archive.data)
        before, count = contents(), len(self.archive.files)
        names = [(fileId(r), kind, i) for kind in sdat.FILE_KINDS
                 for i, r in enumerate(self.archive.records[kind]) if r is not None]
        users = Counter(f for f, _, _ in names)
        _, kind, index = min(n for n in names if users[n[0]] == 1)
        self.archive.records[kind][index] = None
        self.archive.drop_unused_files()
        del before[kind, index]
        self.assertEqual(len(self.archive.files), count - 1)
        self.assertEqual(contents(), before)

    def test_an_added_cry_is_a_wave_archive_alone(self):
        """No bank past HeartGold's own: each costs the sound heap sixteen
        bytes of records and file table, and the music loads into what is left
        (NNSi_SndArcLoadBank plays the wave archive on bank 1's instrument)."""
        wars = self.archive.records["SWAR"]
        self.assertEqual(len(self.archive.records["SBNK"]), RETAIL_BANKS)
        self.assertGreater(len(wars), RETAIL_BANKS)
        for index in range(RETAIL_BANKS, len(wars)):
            self.assertIsNotNone(wars[index], index)

    def test_bank_1_is_every_cry_bank(self):
        """What a cry with no bank plays on. HeartGold's cry banks all hold the
        same seventy-six bytes, one instrument playing slot 0's wave archive,
        so bank 1's record with the cry's number in slot 0 is the cry's bank."""
        fileId, _, *waves = struct.unpack("<HH4H", self.archive.records["SBNK"][1])
        model = self.archive.files[fileId]
        self.assertEqual(len(model), 76)
        self.assertEqual(waves, [1, 0xFFFF, 0xFFFF, 0xFFFF])
        for bank in range(2, 495):
            record = self.archive.records["SBNK"][bank]
            if record is not None:
                self.assertEqual(self.archive.files[struct.unpack("<H", record[:2])[0]], model, bank)

    def test_nothing_loads_a_cry_outside_the_cry_players(self):
        """A cry's bank is a copy in the cry player's own heap, one per cry.

        StartSeq loads it there without registering it (bSetAddr FALSE), and
        LoadBank reuses only a registered copy. Were bank 1 loaded into the
        sound heap and registered -- by a group, or by a scene loading a
        sequence that names it -- every bankless cry would relink that one
        copy, and two cries started together would play the second. Only the
        cry sequences name a cry bank, and no group names either.
        """
        cries = set(range(1, 495)) | set(range(RETAIL_BANKS, len(self.archive.records["SWAR"])))
        naming = {seq for seq, record in enumerate(self.archive.records["SSEQ"])
                  if record is not None and struct.unpack("<HHH", record[:6])[2] in cries}
        self.assertEqual(naming, {1, 2, 3})  # SEQ_PV001, SEQ_PV, SEQ_PV_END
        for group in self.archive.records["GROUP"]:
            count, = struct.unpack("<I", group[:4])
            for kind, _, number in (struct.unpack("<BBxxI", group[4 + 8 * i:12 + 8 * i]) for i in range(count)):
                self.assertFalse(kind == 0 and number in naming, f"a group loads sequence {number}")
                self.assertFalse(kind == 1 and number in cries, f"a group loads bank {number}")

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
        bankFile, = struct.unpack("<H", self.archive.records["SBNK"][1][:2])
        for index in range(RETAIL_BANKS, len(self.archive.records["SWAR"])):
            warFile, = struct.unpack("<H", self.archive.records["SWAR"][index][:2])
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

    def test_every_added_cry_is_one_the_lookup_names(self):
        """A cry nothing looks up still costs the sound heap its table entries.

        The importer used to append to the archive of 4c8176ea1, which already
        held the first sixty-five added species, and appended them again: 778
        to 842 were copies nothing played, and the sound heap the archive's
        tables live in is where the music has to fit.
        """
        archive = sdat.load(import_cries.ARCHIVE)
        self.assertEqual(set(range(RETAIL_BANKS, len(archive.records["SWAR"]))),
                         {bank for bank in self.banks if bank >= RETAIL_BANKS})

    def test_no_cry_is_past_the_end_of_the_archive(self):
        limit = int(re.search(r"#define ARCHIVE_WAVE_ARC_COUNT\s+(\d+)", self.source).group(1))
        archive = sdat.load(import_cries.ARCHIVE)
        self.assertEqual(limit, len(archive.records["SWAR"]))
        for bank in self.banks:
            self.assertLess(bank, limit)

    def test_the_numbers_with_no_bank_are_cries(self):
        """The loader plays any number with a wave archive and no bank as a
        cry, so those numbers have to be the cries and nothing else; and the
        egg, the bad egg and the alternate forms (495 to 507), silent in
        HeartGold, have neither."""
        archive = sdat.load(import_cries.ARCHIVE)
        banks, wars = archive.records["SBNK"], archive.records["SWAR"]
        bankless = {n for n in range(len(wars)) if wars[n] is not None and (n >= len(banks) or banks[n] is None)}
        cries = set(range(1, 495)) | set(self.banks)
        self.assertLessEqual(bankless, cries)
        for number in cries:
            self.assertIsNotNone(wars[number], number)
        for number in [0] + list(range(495, 508)):
            self.assertIsNone(banks[number], number)
            self.assertIsNone(wars[number], number)

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
