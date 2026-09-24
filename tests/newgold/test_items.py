#!/usr/bin/env python3
"""Check that everything indexed by an item id reaches the last item.

An item is a constant, a row of item data, four rows of text, and a line of
sItemNarcIds saying which archive members hold its data and its icon. Nothing
at build time ties those together: sItemNarcIds is sized by ITEMS_COUNT, so a
line nobody wrote is a row of zeroes -- ITEM_NONE's data and the question-mark
icon -- and a message bank that stops short reads whatever the encoder left
after it. Both go quiet rather than wrong, which is why this port has shipped a
table sized to the old range more than once.

The member numbers are checked against the archives' own contents, so an icon
that was never built fails here rather than showing up blank in the bag.

The range itself is checked the same way the other ranges are. konefr's items
are imported BY NAME and renumbered densely from where this tree was -- their
Black Augurite is 1691 and this tree's is 537, and taking their number would
renumber every item already in Paolo's save -- so the port is the mapping in
tools/newgold/import/item_map.csv, and an item of theirs the mapping does not name is
an item this game cannot be given. Where their checkout is beside this one the
mapping is checked against it; where it is not, the numbers are pinned.
"""

import csv
import os
import re
import sys
import unittest
from pathlib import Path

from test_level_cap import ROOT

sys.path[:0] = [str(ROOT / "tools/newgold" / sub) for sub in ("import", "devkit", "devkit/harness", "devkit/diag")]
import import_items  # noqa: E402

REFERENCE = os.environ.get("HG_ENGINE_NEWGOLD_REFERENCE")
if REFERENCE is None:
    sibling = Path("/home/paolo/Porting HGSS/hg-engine-newgold-reference")
    REFERENCE = sibling if (sibling / ".git").exists() else None

HEADER = ROOT / "include/constants/items.h"
ITEM_DATA = ROOT / "files/itemtool/itemdata/item_data.csv"
ITEM_MK = ROOT / "files/itemtool/itemdata/item_data.mk"
ITEM_C = ROOT / "src/item.c"
# The four banks an item id indexes: its description, its name, its name with
# an indefinite article, and its plural. The last two are easy to forget --
# nine items were added before them without one -- and the party menu reads the
# article bank for whatever a Pokemon is holding.
ITEM_BANKS = [ROOT / f"files/msgdata/msg/msg_{bank}.gmm"
              for bank in ("0221", "0222", "0223", "0224")]
NAMES, ARTICLES = ITEM_BANKS[1], ITEM_BANKS[2]
ICON_DIR = ROOT / "files/itemtool/itemdata/item_icon"
ITEM_MAP = ROOT / "tools/newgold/import/item_map.csv"

# What the import read out of konefr's tree, for a run with no checkout beside
# it. Theirs is ITEM_NONE to ITEM_CANARI_BREAD.
REFERENCE_ITEMS = 2685
# Those, and the eight slots HeartGold left empty that konefr filled with real
# items: a real item facing a gap is not that gap under another spelling, so
# the gap stays here and their item is imported beside it.
ITEMS_HERE = REFERENCE_ITEMS + 8
# The last id the two trees share, and the last id this tree had before the
# whole of konefr's range arrived. Both are pinned because an import that took
# konefr's numbering rather than this tree's would move them, and everything
# numbered at or below them is in Paolo's save, his bag and the held items in
# the data.
SHARED_LAST = ("ITEM_ENIGMA_STONE", 536)
LAST_BEFORE_THE_IMPORT = ("ITEM_SNOWBALL", 563)
# ItemData.holdEffect is one byte wide.
HOLD_EFFECT_MAX = 255


def items_count():
    return int(re.search(r"#define ITEMS_COUNT\s+(\d+)", HEADER.read_text()).group(1))


def item_ids():
    """The item constants, by name. The block runs from ITEM_NONE to the count;
    HOLD_EFFECT_ above it and ITEM_VAR_ below are not item ids."""
    return import_items.item_block(HEADER.read_text())


def item_records():
    return list(csv.DictReader(ITEM_DATA.read_text().splitlines()))


def mapping():
    """konefr's item name -> this tree's id, as the importer wrote it down."""
    return list(csv.DictReader(ITEM_MAP.read_text().splitlines()))


def narc_rows():
    """Every item's (data, NCGR, NCLR) member, as GetItemIndexMapping answers.

    The shipped items keep a four-column row each in sItemNarcIds. The
    imported ones do not: their data member follows their id from
    FIRST_IMPORTED_ITEM_DATA, and sImportedItemIcons holds one halfword an
    item -- its tiles member, the palette being the next one, or zero for the
    blank pair. Both are read back here so the checks below see one table.
    """
    text = ITEM_C.read_text()
    table = text[text.index("sItemNarcIds[FIRST_IMPORTED_ITEM][4] = {"):]
    table = table[:table.index("\n};")]
    rows = re.findall(r"\[(ITEM_[A-Z0-9_]+)\] = \{ NARC_item_data_(\d+)_bin, "
                      r"NARC_item_icon_item_icon_(\d+)_NCGR, "
                      r"NARC_item_icon_item_icon_(\d+)_NCLR", table)
    out = {name: (int(data), int(ncgr), int(nclr)) for name, data, ncgr, nclr in rows}
    header = HEADER.read_text()
    first = int(re.search(r"#define FIRST_IMPORTED_ITEM\s+(\d+)", header).group(1))
    first_data = int(re.search(r"#define FIRST_IMPORTED_ITEM_DATA\s+(\d+)", header).group(1))
    icons = text[text.index("sImportedItemIcons[ITEMS_COUNT - FIRST_IMPORTED_ITEM] = {"):]
    icons = [int(v) for v in re.findall(r"\b(\d+)\b", icons[icons.index("{") + 1:icons.index("\n};")])]
    by_id = {number: name for name, number in item_ids().items()}
    for k, tiles in enumerate(icons):
        name = by_id.get(first + k)
        if name is None:
            continue
        out[name] = (first_data + k, tiles or 793, tiles + 1 if tiles else 794)
    return out


def icon_members():
    """Every member the item icon archive will hold, by number: the files that
    are committed, plus the ones item_data.mk builds from the PNGs beside them.
    """
    members = {}
    for path in ICON_DIR.iterdir():
        found = re.match(r"item_icon_(\d+)\.(NANR|NCER|NCGR|NCLR)$", path.name)
        if found:
            members[int(found.group(1))] = found.group(2)
    for ncgr, nclr, png in re.findall(r"ITEMICON_FROM_PNG,(\d+),(\d+),(\w+)\)", ITEM_MK.read_text()):
        assert (ICON_DIR / f"{png}.png").exists(), f"{png}.png is missing"
        members[int(ncgr)] = "NCGR"
        members[int(nclr)] = "NCLR"
    return members


def message_rows(path):
    return [int(index) for index in re.findall(r'index="(\d+)"', path.read_text(encoding="utf-8"))]


def message_text(path):
    return re.findall(r'<language name="English">(.*?)</language>',
                      path.read_text(encoding="utf-8"), re.S)


class ItemRangeTests(unittest.TestCase):
    def setUp(self):
        self.count = items_count()
        self.ids = item_ids()
        self.rows = narc_rows()

    def test_the_constants_run_to_the_count_without_a_gap(self):
        self.assertEqual(sorted(set(self.ids.values())), list(range(self.count)),
                         "ITEMS_COUNT and the item constants disagree")

    def test_every_item_says_where_its_data_and_icon_live(self):
        self.assertEqual(set(self.ids) - set(self.rows), set(),
                         "items with no line in sItemNarcIds")
        # The one table an item id indexes. Sized by the range rather than by a
        # number someone typed, so it cannot be left behind by the next import.
        self.assertIn("sItemNarcIds[FIRST_IMPORTED_ITEM][4]", ITEM_C.read_text())

    def test_the_item_data_every_item_points_at_was_written(self):
        """csv2bin makes one archive member per row, in order, so the last row
        is the last member: a line pointing past it reads nothing."""
        written = len(ITEM_DATA.read_text().splitlines()) - 1
        for name, (data, _, _) in self.rows.items():
            self.assertLess(data, written, f"{name} reads item data member {data}")

    def test_the_icons_every_item_points_at_are_in_the_archive(self):
        members = icon_members()
        for name, (_, ncgr, nclr) in self.rows.items():
            self.assertEqual(members.get(ncgr), "NCGR", f"{name} tiles, member {ncgr}")
            self.assertEqual(members.get(nclr), "NCLR", f"{name} palette, member {nclr}")

    def test_the_icon_archive_holds_each_member_at_its_number(self):
        """The item data names an icon by its member number, and nitroarc packs a
        directory by name: past item_icon_999 that is not number order (1000
        sorts before 101), and every imported item read another file's tiles and
        palette -- a palette as tiles for the DNA Splicers, which stopped the bag.
        .narcorder lists the members in number order; the index the build writes
        beside the archive says where each one went."""
        order = (ICON_DIR / ".narcorder").read_text().split()
        members = icon_members()
        self.assertEqual(len(order), len(members))
        for number, name in enumerate(order):
            found = re.match(r"item_icon_(\d+)\.(\w+)$", name)
            self.assertEqual((int(found.group(1)), found.group(2)), (number, members.get(number)), name)
        naix = ICON_DIR.with_suffix(".naix")
        if naix.exists():
            for name, member in re.findall(r"#define NARC_item_icon_item_icon_(\d+)_\w+ (\d+)", naix.read_text()):
                self.assertEqual(int(name), int(member), f"item_icon_{name} is member {member}")

    def test_every_bank_an_item_id_indexes_reaches_the_last_item(self):
        for path in ITEM_BANKS:
            rows = message_rows(path)
            self.assertEqual(rows, list(range(len(rows))), f"{path.name} is not in index order")
            self.assertGreaterEqual(len(rows), self.count,
                                    f"{path.name} stops before the last item")

    def test_the_article_bank_names_the_item_its_row_belongs_to(self):
        """Three banks say the item's name, and a row added in the wrong place
        is invisible until someone picks the thing up. The plural bank is not
        checked this way: a Cheri Berry pluralises to Cheri Berries."""
        names = message_text(NAMES)
        for item, value in enumerate(message_text(ARTICLES)[:self.count]):
            if item and "???" not in (names[item], value):
                self.assertIn(names[item], value, f"msg_0223 row {item}")


class ItemTextTests(unittest.TestCase):
    """The four banks carry hg-engine's text, row = this game's item id.

    hg-engine keeps descriptions, articles and plurals in banks 830..852 by
    generation, and its 221/223/224 are one-row templates for custom items; the
    port fills its flat banks from the engine's row for each item's reference
    id (item_map.csv). Before this, 2045 descriptions read "Custom item
    description" and the plurals were made up by a rule ("DNA Splicerses").
    """

    PINNED = {
        221: {564: "Aromatic tea that has a slightly\\nbitter taste.\\nIt soothes a dry throat.",
              # 850.txt stops five rows short; hg-engine shows nothing there.
              2688: "", 2692: "", 1851: "N/A", 114: "- - -"},
        222: {22: "Paralyze Heal", 328: "TM001", 469: "Unown Report", 564: "Tea",
              113: "???", 1837: ""},
        223: {657: "the {COLOR 255}DNA Splicers{COLOR 0}", 651: "???", 113: "???",
              22: "a {COLOR 255}Paralyze Heal{COLOR 0}"},
        224: {0: "None", 1: "{COLOR 255}Master Balls{COLOR 0}", 113: "???",
              564: "{COLOR 255}cups of Tea{COLOR 0}", 657: "{COLOR 255}DNA Splicers{COLOR 0}"},
    }

    def test_pinned_rows_are_the_engines(self):
        for bank, rows in self.PINNED.items():
            text = message_text(ITEM_BANKS[bank - 221])
            for index, want in rows.items():
                self.assertEqual(text[index], want, f"msg_{bank:04d} row {index}")
        self.assertNotIn("Custom item description", ITEM_BANKS[0].read_text(encoding="utf-8"))

    def test_the_importer_reproduces_the_banks(self):
        if REFERENCE is None:
            self.skipTest("behaviour reference not present; the rows above are the pin")
        import gmm
        text = import_items.item_text(gmm.ENGINE, Path(REFERENCE))
        self.assertEqual(import_items.write_text(text, items_count(), write=False), {},
                         "run import_items.py REFERENCE --text-only --write")


class ItemRangeAgainstTheReferenceTests(unittest.TestCase):
    """The whole of konefr's item range, under this tree's numbering.

    Every other range in this port -- species, moves, abilities -- holds
    everything the reference could reach, not only what their game reaches
    today. Items were the exception for a long time, and the way that goes
    wrong again is quiet: an importer that resolves a name badly drops the item
    rather than failing, and nobody notices until the thing it was wanted for
    is written. So the mapping is checked item by item, not counted.
    """

    def setUp(self):
        self.mapping = mapping()
        self.ids = item_ids()
        self.records = item_records()

    def test_the_mapping_names_every_item_the_reference_defines(self):
        theirs = {row["reference_name"] for row in self.mapping}
        self.assertEqual(len(theirs), len(self.mapping), "a reference item is mapped twice")
        self.assertEqual(len(self.mapping), REFERENCE_ITEMS,
                         "the mapping no longer covers konefr's whole item range")
        if REFERENCE is None:
            self.skipTest("behaviour reference not present; the count above is the pin")
        reference = import_items.defines(
            (Path(REFERENCE) / "include/constants/item.h").read_text(), "ITEM_")
        self.assertEqual(sorted(set(reference) - theirs), [],
                         "items the reference defines that this game cannot name")

    def test_the_mapping_gives_every_item_an_id_of_its_own(self):
        """One id per item, and the id the header actually gives that name.
        Two of konefr's names landing on one constant is two items the game
        would treat as one -- which is what a bad alias looks like from here."""
        ids = [int(row["item_id"]) for row in self.mapping]
        self.assertEqual(len(set(ids)), len(ids), "two of the reference's items share an id here")
        for row in self.mapping:
            self.assertEqual(self.ids.get(row["item_name"]), int(row["item_id"]),
                             f"{row['reference_name']} maps to {row['item_name']}, "
                             "which is not that id in this tree")

    def test_nothing_that_was_already_here_was_renumbered(self):
        for name, number in (SHARED_LAST, LAST_BEFORE_THE_IMPORT):
            self.assertEqual(self.ids.get(name), number,
                             f"{name} has moved: the import took konefr's numbering "
                             "instead of this tree's, and every save is numbered against it")
        self.assertGreaterEqual(items_count(), ITEMS_HERE,
                                "the item range has gone short of konefr's again")

    def test_the_last_items_data_record_is_the_last_one_written(self):
        """LoadAllItemData sizes the whole table off ITEM_MAX's own data member
        -- GetItemIndexMapping(ITEM_MAX) + 1 records -- so an item numbered
        after the last one to be given a record shortens that allocation and
        the battle reads past the end of it for everything above."""
        rows = narc_rows()
        last = {number: name for name, number in self.ids.items()}[max(self.ids.values())]
        self.assertEqual(rows[last][0], max(data for data, _, _ in rows.values()),
                         f"{last} is ITEM_MAX and does not hold the highest data member")

    def test_every_item_data_record_belongs_to_an_item(self):
        """csv2bin writes one member per row whatever points at it, so the
        members an item names have to be the members that exist: a gap is a
        record the cartridge carries and nothing opens, and it moves every
        record after it."""
        members = sorted({data for data, _, _ in narc_rows().values()})
        self.assertEqual(members, list(range(len(self.records))),
                         "item_data.csv and the members sItemNarcIds names disagree")

    def test_no_record_names_a_field_routine_this_game_has_not_got(self):
        """GetItemFieldUseFunc indexes sItemFieldUseFuncs with the record's own
        fieldUseFunc and checks nothing. konefr has six routines past this
        game's thirty -- Mint, Nectar, Ability Capsule, Reveal Glass, DNA
        Splicers, Rotom Catalog -- and a record carrying one of those would
        jump through whatever follows the table."""
        for row in self.records:
            self.assertLess(int(row["fieldUseFunc"]), import_items.FIELD_USE_FUNCS, row["item"])

    def test_every_hold_effect_an_item_names_fits_the_byte_it_is_kept_in(self):
        """The import brings konefr's hold effects with it, renumbered here for
        the same reason the items are. ItemData.holdEffect is one byte, so that
        list is the one place this range can overflow something narrower than
        the item id itself."""
        effects = import_items.defines(HEADER.read_text(), "HOLD_EFFECT_")
        self.assertEqual(sorted(effects.values()), list(range(len(effects))),
                         "the hold effect numbers are not dense")
        self.assertLessEqual(max(effects.values()), HOLD_EFFECT_MAX,
                             "ItemData.holdEffect is one byte")
        for row in self.records:
            self.assertIn(row["holdEffect"], effects, row["item"])



class ItemTableStrideTests(unittest.TestCase):
    def test_the_battle_steps_through_the_item_table_by_the_archive_s_stride(self):
        """LoadAllItemData reads item_data.narc's records as one array, and
        GetItemDataPtrFromArray indexes it by sizeof(ItemData). The archive
        starts each 34-byte record on a word, so that size has to be 36
        (test_heaps' ITEM_RECORD). It was 34 from 2026-09-22: in battle a
        Focus Sash read the Toxic Orb's hold effect and poisoned its holder.
        """
        from test_ability_behaviour import run_c
        header = (ROOT / "include/item.h").read_text()
        structs = "\n".join(header[header.index(f"typedef struct {name} {{"):header.index(f"}} {name};") + len(name) + 3]
                            for name in ("ItemPartyParam", "ItemData"))
        run_c(self, "#include <stdint.h>\ntypedef uint8_t u8; typedef int8_t s8; typedef uint16_t u16;\n" + structs +
              "\n_Static_assert(sizeof(ItemData) == 36, \"ItemData steps by the archive's stride\");\n"
              "int main(void) { return 0; }\n")


class SharedRecordTests(unittest.TestCase):
    """An item both trees have should carry konefr's numbers, not Game Freak's.

    The importer only ever adds an item this tree has not got, so for a long
    while every item that came over with the ROM kept its vanilla record even
    where the reference changed it -- 277 prices and all 64 of Natural Gift's
    sixth-generation powers. import_items.py --sync is what closes that, and
    this is what notices if it opens again.
    """

    REFERENCE = Path("/home/paolo/Porting HGSS/hg-engine-newgold-reference")
    # Fields that disagree for a reason, with the reason. See KEPT in the
    # importer: this engine evolves by a party-use routine, not a hold effect.
    ALLOWED = {("ITEM_PRISM_SCALE", "holdEffect"), ("ITEM_PRISM_SCALE", "fieldUseFunc"),
               ("ITEM_PRISM_SCALE", "partyUse"), ("ITEM_PRISM_SCALE", "evolve")}

    def test_every_shared_record_matches_the_reference(self):
        if not self.REFERENCE.exists():
            self.skipTest("Pinned NewGold reference checkout not configured")
        sys.path[:0] = [str(ROOT / "tools/newgold" / sub) for sub in ("import", "devkit", "devkit/harness", "devkit/diag")]
        import import_items as importer
        reference = importer.Reference(self.REFERENCE)
        header = importer.original(importer.ITEMS_H)
        here = importer.item_block(header)
        pairs = importer.correspondence(reference, here)
        effects = importer.hold_effect_map(reference, importer.defines(header, "HOLD_EFFECT_"))
        rows = list(csv.reader(importer.ITEM_CSV.read_text().splitlines()))
        fields, mine = rows[0][1:], {r[0]: r[1:] for r in rows[1:]}
        bad = []
        for theirs, ours in sorted(pairs.items()):
            if theirs not in reference.records or ours not in mine:
                continue
            want = importer.record(reference, theirs, fields, effects, {})
            for field, wanted, got in zip(fields, want, mine[ours]):
                if wanted != got and (ours, field) not in self.ALLOWED:
                    bad.append(f"{ours}.{field}: {got} here, {wanted} in the reference")
        self.assertEqual(bad, [], "run tools/newgold/import/import_items.py --sync --write")


if __name__ == "__main__":
    unittest.main()


class PriceTests(unittest.TestCase):
    """The price is twenty bits, because konefr sells things Gen 4 could not.

    An Ability Patch is 500000 and the record's price field is sixteen bits.
    The reference puts the top four in the first byte of the record's tail
    padding; so does this tree, and ITEMATTR_PRICE puts them back together.
    Three items need it, and if the reader ever stops combining them an
    Ability Patch quietly becomes 41248.
    """

    BIG = {"ITEM_BIG_NUGGET": 80000, "ITEM_ABILITY_CAPSULE": 100000,
           "ITEM_ABILITY_PATCH": 500000}

    def rows(self):
        rows = list(csv.reader((ROOT / "files/itemtool/itemdata/item_data.csv")
                               .read_text().splitlines()))
        head = rows[0]
        return head, {r[0]: dict(zip(head[1:], r[1:])) for r in rows[1:]}

    def test_the_record_carries_the_high_nibble(self):
        head, _ = self.rows()
        self.assertIn("price_high", head)
        manifest = (ROOT / "files/itemtool/itemdata/item_data.txt").read_text()
        self.assertIn("price_high:u8.4", manifest)

    def test_the_expensive_items_keep_their_price(self):
        _, rows = self.rows()
        for name, want in self.BIG.items():
            row = rows[name]
            got = int(row["price"]) | (int(row["price_high"]) << 16)
            self.assertEqual(got, want, name)

    def test_the_reader_puts_the_two_halves_back(self):
        self.assertIn("itemData->price | (itemData->partyUseParam.price_high << 16)",
                      (ROOT / "src/item.c").read_text())

    def test_the_game_reads_the_nibble_where_the_data_puts_it(self):
        """The packer and the struct have to agree on where price_high is.

        They did not: the struct had it at byte 0x22, past the 34-byte record,
        and the manifest at 0x20, so every price the game read took its top
        bits from whatever followed the record. Both field lists are laid out
        here with C's rule for bitfields -- a field that does not fit in what
        is left of its unit starts a new one -- and the offsets compared.
        """
        SIZE = {"u8": 8, "s8": 8, "u16": 16, "s16": 16, "u32": 32}

        def offset(fields, stop):
            bits, unit, used = 0, None, 0
            for name, kind, width, count in fields:
                if name == stop:
                    return (bits + (used if unit else 0)) // 8 if not width else (bits + used) // 8
                if width:
                    if unit == kind and used + width <= SIZE[kind]:
                        used += width
                        continue
                    bits += SIZE[unit] if unit else 0
                    unit, used = kind, width
                    continue
                if unit:
                    bits += SIZE[unit]
                    unit, used = None, 0
                bits += SIZE[kind] * count
            return None

        manifest = []
        for field in (ROOT / "files/itemtool/itemdata/item_data.txt").read_text().split():
            name, kind = field.split(":")[:2]
            if kind == "skip":
                continue
            if kind.startswith("pad"):
                manifest.append((name, "u8", 0, int(kind[3:])))
            elif "." in kind:
                manifest.append((name, kind.split(".")[0], int(kind.split(".")[1]), 1))
            else:
                manifest.append((name, kind, 0, 1))

        header = (ROOT / "include/item.h").read_text()
        def c_fields(block):
            out = []
            for line in block.splitlines()[1:]:
                line = line.split("//")[0].strip().rstrip(";")
                if not line or line.startswith(("union", "}", "{", "ItemPartyParam")):
                    continue
                kind, rest = line.split(None, 1)
                if kind not in SIZE:
                    continue
                if ":" in rest:
                    out.append((rest.split(":")[0].strip(), kind, int(rest.split(":")[1]), 1))
                elif "[" in rest:
                    out.append((rest.split("[")[0].strip(), kind, 0, int(rest.split("[")[1].rstrip("]"))))
                else:
                    out.append((rest.strip(), kind, 0, 1))
            return out
        item = header[header.index("typedef struct ItemData {"):header.index("union {", header.index("typedef struct ItemData {"))]
        party = header[header.index("typedef struct ItemPartyParam {"):header.index("} ItemPartyParam;")]
        c_layout = c_fields(item) + c_fields(party)

        data_offset = offset(manifest, "price_high")
        self.assertEqual(data_offset, 0x20)
        self.assertEqual(offset(c_layout, "price_high"), data_offset,
                         "the struct reads the price's top bits somewhere the data does not put them")
