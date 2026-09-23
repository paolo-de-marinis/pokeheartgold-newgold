#!/usr/bin/env python3
"""Every name fits the buffer the game reads it into.

ReadMsgDataIntoString ends in CopyU16ArrayToStringN (src/pm_string.c), which
copies a row only when its length -- in u16, control codes and terminator
included -- is at most the String's capacity. A longer row trips GF_ASSERT,
which does nothing in this build, and the String keeps what it held before: a
blank or somebody else's text, and nothing at build time says so. The lengths
are read from the banks msgenc built, which store them.

Item names, plurals and descriptions are checked only for the items a player
can come by, read from the data that hands items out. hg-engine's banks carry
every item up to Scarlet and Violet, and 74 of those names are longer than the
bag's 18; none of the 74 can be obtained, and the bag's String_New(0x12) is
assembly (ov15_021FA008), so the guard is that no such item enters the game
until the bag's strings are sized for it.

Needs the build: run after make.
"""

import re
import struct
import unittest

from test_level_cap import ROOT

MESSAGES = ROOT / "files/msgdata/msg"

# Capacities in u16, terminator included, of the smallest String each bank is read into.
MOVE_NAME_CAPACITY = 16         # GetMoveName's String_New(16) (src/msgdata.c), the move tutor's String_New(0x10)
SPECIES_NAME_CAPACITY = 11      # POKEMON_NAME_LENGTH + 1: GetSpeciesNameIntoArray copies the row into a nickname array unbounded
MESSAGE_FORMAT_CAPACITY = 32    # MessageFormat_New_Custom(_, 32) callers: ability names, items with article
ITEM_NAME_CAPACITY = 18         # the bag's String_New(0x12) (ov15_021FA008)
ITEM_DESCRIPTION_CAPACITY = 130  # bag, battle bag and shop String_New(130)

MOVE_NAMES, ITEM_DESCRIPTIONS, ITEM_NAMES, ITEM_ARTICLES, ITEM_PLURALS, SPECIES_NAMES, ABILITY_NAMES = (
    750, 221, 222, 223, 224, 237, 720)

# Where an item enters the game: every script (item balls, gifts, prizes, give-items), the marts,
# hidden items, wild held items, trainers' held and bag items, and the C tables that give items.
# ponytail: item tables still in assembly (Pickup, the exchange counters) are not read; add one here
# if the port ever puts an item in it.
ITEM_SOURCES = [
    "src/scrcmd_mart.c", "src/data/fieldmap/hidden_items.h",
    "files/poketool/personal/personal.json", "files/poketool/trainer/trainers.json",
    "src/mom_gift.c", "src/field/rock_smash_item.c", "src/overlay_bug_contest.c", "src/scrcmd_fossils.c",
    "src/scrcmd_dppl_prizes.c", "src/application/pokegear/phone/phone_script_defs.c", "files/tel/pmtel_book.json",
]


def item_plural_capacity():
    """The bag reads plurals into the MessageFormat_New buffer (ov15, asm); the other plural
    readers have 64 (scripts, overlay 31) or read Apricorns only (overlay 59's 32)."""
    source = (ROOT / "src/message_format.c").read_text()
    return int(re.search(r"MessageFormat_New\(enum HeapID heapID\) \{\s*return MessageFormat_New_Custom\(8, (\d+),",
                         source).group(1))


def row_lengths(bank):
    """The length msgenc stored for each row of a bank (MessagesConverter.h's MsgAlloc)."""
    path = MESSAGES / f"msg_{bank:04d}.bin"
    if not path.exists():
        raise unittest.SkipTest("the message banks have not been built")
    assert path.stat().st_mtime >= path.with_suffix(".gmm").stat().st_mtime, f"{path.name} is older than its gmm: run make"
    data = path.read_bytes()
    count, key = struct.unpack_from("<HH", data)
    lengths = []
    for i in range(1, count + 1):
        k = 765 * i * key & 0xFFFF
        lengths.append(struct.unpack_from("<I", data, 8 * i)[0] ^ (k | k << 16))
    return lengths


def items():
    text = (ROOT / "include/constants/items.h").read_text()
    return {name: int(value) for name, value in re.findall(r"#define (ITEM_\w+)\s+(\d+)\b", text)}


def obtainable_items():
    paths = sorted((ROOT / "files/fielddata/script/scr_seq").glob("*.s")) + [ROOT / p for p in ITEM_SOURCES]
    names = set()
    for path in paths:
        names |= set(re.findall(r"\bITEM_\w+", path.read_text(encoding="utf-8")))
    ids = items()
    return {name: ids[name] for name in names - {"ITEM_NONE"}}


def over(bank, capacity):
    return {row: n for row, n in enumerate(row_lengths(bank)) if n > capacity}


def items_over(bank, capacity):
    lengths = row_lengths(bank)
    return {name: lengths[row] for name, row in obtainable_items().items() if lengths[row] > capacity}


class TextLengthTests(unittest.TestCase):
    def test_move_names_fit(self):
        self.assertEqual(over(MOVE_NAMES, MOVE_NAME_CAPACITY), {}, "move rows longer than 16")

    def test_species_names_fit(self):
        self.assertEqual(over(SPECIES_NAMES, SPECIES_NAME_CAPACITY), {}, "species rows longer than 11")

    def test_ability_names_fit(self):
        self.assertEqual(over(ABILITY_NAMES, MESSAGE_FORMAT_CAPACITY), {}, "ability rows longer than 32")

    def test_item_names_with_article_fit(self):
        self.assertEqual(over(ITEM_ARTICLES, MESSAGE_FORMAT_CAPACITY), {}, "article rows longer than 32")

    def test_obtainable_item_names_fit(self):
        self.assertEqual(items_over(ITEM_NAMES, ITEM_NAME_CAPACITY), {}, "obtainable items named longer than 18")

    def test_obtainable_item_plurals_fit(self):
        # hg-engine's Never-Melt Ice and Secret Medicine plurals are 33.
        self.assertEqual(items_over(ITEM_PLURALS, item_plural_capacity()), {})

    def test_obtainable_item_descriptions_fit(self):
        self.assertEqual(items_over(ITEM_DESCRIPTIONS, ITEM_DESCRIPTION_CAPACITY), {},
                         "obtainable items described longer than 130")

    def test_lengths_are_read_as_msgenc_writes_them(self):
        """Characters, 4 u16 per {COLOR n}, 1 for the terminator."""
        self.assertEqual(row_lengths(MOVE_NAMES)[588], len("ParabolicCharge") + 1)
        self.assertEqual(row_lengths(ITEM_ARTICLES)[items()["ITEM_SUPER_LUMIOSE_GALETTE"]],
                         len("a Super Lumiose Galette") + 2 * 4 + 1)


if __name__ == "__main__":
    unittest.main()
