#!/usr/bin/env python3
"""Check that every species the game can reach is a whole Pokemon.

The ledger's "1041 species in play" row -- 1423 since the forms became species
-- asks for six things at once: a sprite, an icon, a cry, a name, a Dex page
and an ability that does something. Each of the six already has a test of its
own, and each of those tests asks its own question -- is the sprite tree
dense, is the cry table the right length, does the name bank reach the end.
None of them asks the row's question, which is about a *species*: pick one of
the 1423 the game can put in a party and follow all six of its numbers out to
the data they index.

That distinction is not pedantry. Five of the six are reached by arithmetic on
the species number -- pokegra member species * 6, icon member species - 508 +
551, cry bank sAddedCryBanks[species - 508], footprint member species + 2, Dex
row species -- and arithmetic fails one species at a time. A table that is the
right length and starts one entry late passes every length check in the tree
and makes Lillipup cry as Karrablast, which is exactly what happened.

So this walks all 1423 and names the one that fails. It is not a substitute for
the row: nobody has looked at 1423 sprites, and a member that exists is not a
picture that is drawn. What a machine can answer is whether the number lands on
something, and that is what this answers.

Where the reference checkout is present the Dex text is compared against it for
every added species, which is the check that catches a shift rather than a
hole. Run only this file; it reads data and source and builds nothing.
"""

import json
import re
import sys
import unittest
import xml.etree.ElementTree as ET
from collections import Counter
from pathlib import Path

from test_level_cap import ROOT
from test_repels import REFERENCE

sys.path[:0] = [str(ROOT / "tools/newgold" / sub) for sub in ("import", "devkit", "devkit/harness", "devkit/diag")]
import import_cries  # noqa: E402
import import_dex_text  # noqa: E402
import gmm  # noqa: E402
import import_footprints  # noqa: E402
import import_species  # noqa: E402
import sdat  # noqa: E402
import wotbl  # noqa: E402

# The tree's own ledger of which added abilities have an effect and which are
# still a name. Reading it here rather than writing a second list means the two
# cannot disagree: an ability that moves out of PENDING there stops counting a
# species as dead here on the same commit.
from test_ability_effects import NOT_AN_ABILITY, PENDING as INERT_ABILITIES, battle_source  # noqa: E402

SPRITES = ROOT / "files/poketool/pokegra/pokegra"
ICONS = ROOT / "files/poketool/icongra/poke_icon"
FOOTPRINTS = ROOT / "files/poketool/pokefoot/pokefoot"
MESSAGES = ROOT / "files/msgdata/msg"
PERSONAL = ROOT / "files/poketool/personal/personal.json"
ICON_SOURCE = ROOT / "src/pokemon_icon_idx.c"
ICON_HEADER = ROOT / "include/pokemon_icon_idx.h"
CRY_SOURCE = ROOT / "src/unk_02005D10.c"
SPECIES_HEADER = ROOT / "include/constants/species.h"

PICTURES_PER_SPECIES = 6
FOOTPRINT_OFFSET = import_footprints.MEMBER_OFFSET

# HeartGold's own 493, New Gold's 534 and the reference's 396 forms numbered
# as species (1042..1437): 493 + 534 + 396 = 1423. The fourteen between the
# first two -- the egg, the bad egg and the twelve alternate forms -- are
# species numbers but not Pokemon: nothing can put one in a party, they have
# no Dex page of their own, and their sprites come from otherpoke.narc. They
# are checked by the tests that own those tables, not here.
SPECIES_IN_PLAY = 1423

# The two the reference ships with an empty Pokedex entry and placeholder
# measurements of its own -- konefr's Galarian Slowpoke is still called "-----"
# in his own text table. Blank here is faithful, not missing; what would be a
# port bug is a third one appearing.
BLANK_IN_THE_REFERENCE = set()  # a form carries its base's text, the two Galarian lines included

# A species whose only abilities are still names loses battles quietly: it
# looks right on the summary screen and does nothing. This is the ledger's
# number for the row, not a pass or a fail -- it comes down as the abilities
# get their effects, and it may only come down.
#
# It was 18 before the forms import (00e38ed6a) and went to 58 with it, one
# raise with its reason: 58 = the 18 base species plus 40 form species
# (1042..1437) whose only abilities are pending -- a form is a species of its
# own here and brings its own ability record.
#
# 58 -> 65: Schooling and Power Construct went back to pending (see
# test_ability_effects.py), which leaves seven species with nothing:
# WISHIWASHI, WISHIWASHI_SCHOOL, ZYGARDE_10/50_POWER_CONSTRUCT,
# ZYGARDE_10/50_COMPLETE and MEGA_ZYGARDE. They were never doing anything; the
# count now says so.
SPECIES_WITH_NOTHING_TO_DO = 65


def constant(source, name):
    return int(re.search(rf"#define {name}\s+(\d+)", source).group(1))


def species_numbers():
    """Every SPECIES_ constant that is a plain number, by name."""
    return {m[1]: int(m[2]) for m in
            re.finditer(r"#define SPECIES_([A-Z0-9_]+)\s+(\d+)\s*$",
                        SPECIES_HEADER.read_text(), re.M)}


def in_play():
    """(number, name) for every species the game can put in a party.

    Derived from the header and the import, never written down: the range moved
    once already and a test carrying its own copy of the old one would pass.
    """
    numbers = species_numbers()
    header = SPECIES_HEADER.read_text()
    last = numbers[re.search(r"#define NUM_SPECIES SPECIES_([A-Z0-9_]+)", header).group(1)]
    arceus = numbers[re.search(r"#define MAX_SPECIES SPECIES_([A-Z0-9_]+)", header).group(1)]
    added = import_species.added_species()
    first_added = numbers[added[0]]
    byNumber = {}
    for name, number in numbers.items():
        byNumber.setdefault(number, name)
    return ([(n, byNumber[n]) for n in range(1, arceus + 1)]
            + [(numbers[name], name) for name in added]), first_added, last


def message_rows(bank):
    """index -> English text, for a message bank."""
    parsed = ET.parse(MESSAGES / f"msg_{bank}.gmm").getroot().findall("row")
    return {int(row.get("index")): (row.find("language[@name='English']").text or "")
            for row in parsed}


class SpeciesInPlayTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.species, cls.firstAdded, cls.lastSpecies = in_play()

    def test_the_range_is_the_one_the_row_is_about(self):
        self.assertEqual(len(self.species), SPECIES_IN_PLAY)
        self.assertEqual(self.species[0], (1, "BULBASAUR"))
        self.assertEqual(self.species[-1][0], self.lastSpecies)
        # Nothing between Arceus and the first added species is in the list.
        numbers = [number for number, _ in self.species]
        self.assertEqual(len(set(numbers)), len(numbers))
        self.assertFalse([n for n in numbers if 493 < n < self.firstAdded])

    # ---- sprite -----------------------------------------------------------

    def test_every_species_has_all_six_of_its_pokegra_members(self):
        """Six members per species, and a species that cannot make all six
        shifts every species after it rather than losing its own picture.

        Four of them are always built -- the tool has a flag for an empty
        picture -- so the four files have to exist. The two palettes are built
        from a back picture only `if test -s`, so a species with both back
        pictures empty makes no palette at all and the archive comes up short.
        A species with both front pictures empty keeps its six members and
        shows nothing in a battle, which is the same row failing quietly.
        """
        for number, name in self.species:
            directory = SPRITES / f"{number:04d}"
            for gender in ("male", "female"):
                for picture in ("front.png", "back.png"):
                    self.assertTrue((directory / gender / picture).exists(),
                                    f"{name} ({number}) has no {gender}/{picture}")
            for picture in ("back.png", "front.png"):
                sizes = [(directory / gender / picture).stat().st_size
                         for gender in ("male", "female")]
                self.assertTrue(any(sizes), f"{name} ({number}) has no {picture} at all")

    def test_the_sprite_index_is_still_species_times_six(self):
        """The arithmetic, the archive's order, and the tree, together.

        `species * 6` is only the right member while all three hold: the game
        computes it, the archive is the build directory in name order, and the
        tree has a directory for every slot with no gap. Checking the formula
        alone would pass on a tree missing Bulbasaur.
        """
        source = (ROOT / "src/pokemon.c").read_text()
        self.assertEqual(source.count("species * 6 + whichFacing"), 2)
        self.assertEqual(source.count("species * 6 + 4"), 2)
        rules = (ROOT / "files/poketool/pokegra/pokegra.mk").read_text()
        self.assertEqual(sorted(set(re.findall(r"/%-(\d\d)\.", rules))),
                         [f"{i:02d}" for i in range(PICTURES_PER_SPECIES)])
        self.assertIn("--index-namespace", rules)
        slots = sorted(int(p.name) for p in SPRITES.iterdir() if p.name.isdigit())
        self.assertEqual(slots, list(range(self.lastSpecies + 1)))

    # ---- icon -------------------------------------------------------------

    def test_every_species_has_an_icon_and_a_palette(self):
        """Both lookups, run the way GetMonIconNaixEx and GetMonIconPaletteEx
        run them, with their own constants read out of the source."""
        source = ICON_SOURCE.read_text()
        firstIcon = constant(ICON_HEADER.read_text(), "FIRST_ADDED_ICON")
        firstPalette = constant(ICON_HEADER.read_text(), "FIRST_ADDED_PALETTE")
        pictures = {int(m.group(1)) for m in
                    (re.match(r"poke_icon_0*(\d+)\.png$", p.name) for p in ICONS.iterdir()) if m}
        start = source.index("sPokemonPalNoBySpeciesAndForm[] = {")
        palettes = [int(v) for v in
                    re.findall(r"^\s*(\d+),", source[start:source.index("\n};", start)], re.M)]
        for number, name in self.species:
            if number > 493:
                member = number - self.firstAdded + firstIcon
                entry = number - self.firstAdded + firstPalette
            else:
                member, entry = number + 7, number
            self.assertTrue(member in pictures, f"{name} ({number}) asks for icon {member}")
            self.assertLess(entry, len(palettes),
                            f"{name} ({number}) asks for palette entry {entry} of {len(palettes)}")
            self.assertIn(palettes[entry], (0, 1, 2), f"{name} ({number})")

    # ---- cry --------------------------------------------------------------

    def cry_banks(self):
        """species -> bank, through CryBankForSpecies' own arithmetic."""
        source = CRY_SOURCE.read_text()
        first = constant(source, "NUM_SPECIES_WITH_CRIES") + 1
        table = [int(n) for n in re.findall(
            r"^    (\d+), //", re.search(r"sAddedCryBanks\[\] = \{(.*?)\n\};",
                                         source, re.S).group(1), re.M)]
        self.assertEqual(len(table), self.lastSpecies - first + 1,
                         "sAddedCryBanks does not cover the added species exactly, so the "
                         "species it is indexed by is not the species it answers for")
        return ({number: table[number - first] if number >= first else number
                 for number, _ in self.species},
                constant(source, "ARCHIVE_BANK_COUNT"))

    def test_every_species_maps_to_a_cry_the_archive_holds(self):
        """The bank a species lands on has to be a bank.

        PlayCry clamps an out-of-range bank to 1, so a species past the end of
        the table does not crash -- it cries as Bulbasaur, or as whatever the
        read off the end happened to be. Nothing in a build says so.
        """
        banks, limit = self.cry_banks()
        archive = sdat.load(import_cries.ARCHIVE)
        self.assertEqual(limit, len(archive.records["SBNK"]))
        for number, name in self.species:
            bank = banks[number]
            self.assertTrue(0 < bank < limit,
                            f"{name} ({number}) asks for bank {bank} of {limit}")
            self.assertIsNotNone(archive.records["SBNK"][bank],
                                 f"{name} ({number}) asks for empty bank {bank}")
            self.assertIsNotNone(archive.records["SWAR"][bank],
                                 f"{name} ({number}) asks for bank {bank}, which has no wave archive")

    def test_no_two_species_share_a_cry_but_the_two_that_should(self):
        """The test the off-by-one would have failed.

        A table read one entry late still has the right length and every bank
        in it is still a real bank; what it stops being is a bijection. The two
        Galarian forms are the only species meant to share, and they share with
        the Johto line they were imported from, which import_cries names.
        """
        banks, _ = self.cry_banks()
        numbers = species_numbers()
        # The two Galarian lines, and every form the reference numbers as a
        # species: a form cries as its base.
        sharing = dict(import_cries.SHARED_WITH)
        for form, base in import_species.base_species_of(Path(REFERENCE)).items():
            if form in numbers:
                sharing.setdefault(form, base)
        shared = {numbers[form]: numbers[base] for form, base in sharing.items()}
        self.assertTrue(shared)
        for form, base in shared.items():
            self.assertEqual(banks[form], banks[base])
        repeats = {bank for bank, count in Counter(banks.values()).items() if count > 1}
        self.assertEqual(repeats, {banks[base] for base in shared.values()},
                         "two species cry as each other")

    # ---- name -------------------------------------------------------------

    def test_every_species_has_a_name_that_fits(self):
        rows = message_rows("0237")
        limit = constant((ROOT / "include/constants/global.h").read_text(), "POKEMON_NAME_LENGTH")
        for number, name in self.species:
            shown = rows.get(number)
            self.assertTrue(shown, f"{name} ({number}) has no name in msg_0237")
            self.assertLessEqual(len(shown), limit, f"{name} ({number}) is named {shown!r}")

    # ---- Dex --------------------------------------------------------------

    def test_every_species_has_a_height_weight_entry_and_footprint(self):
        """The four things the Dex page is made of, per species.

        The footprint is the one read by arithmetic -- member species + 2 --
        and the three texts are rows in three banks that each used to stop at
        Arceus. A missing row is not a crash: the Dex draws an empty page.
        """
        entries = message_rows("0803")
        weights = message_rows("0812")
        heights = message_rows("0814")
        categories = message_rows("0816")
        prints = {int(p.stem.split("_")[1]) for p in FOOTPRINTS.glob("pokefoot_*.png")}
        blank = []
        for number, name in self.species:
            self.assertTrue(heights.get(number, "").strip(), f"{name} ({number}) has no height")
            self.assertTrue(weights.get(number, "").strip(), f"{name} ({number}) has no weight")
            self.assertTrue(categories.get(number, "").strip(), f"{name} ({number}) has no category")
            self.assertTrue(number + FOOTPRINT_OFFSET in prints,
                            f"{name} ({number}) asks for footprint member {number + FOOTPRINT_OFFSET}")
            if not entries.get(number, "").strip():
                blank.append(name)
        self.assertEqual(set(blank), BLANK_IN_THE_REFERENCE,
                         "a species with no Pokedex entry that the reference does not leave blank")

    @unittest.skipIf(REFERENCE is None, "behaviour reference not present")
    def test_the_dex_text_still_says_what_the_reference_says(self):
        """Every added species, every bank the import writes.

        A hole is easy to see and a shift is not: every row present, every row
        the wrong Pokemon's. So the rule the import applied is applied again
        and the answer compared, which is the only form of this check that
        would notice the whole range sliding by one.
        """
        # The English banks are hg-engine's, whole, and test_species_names.py
        # holds them to import_species_text.py; these are the foreign-language
        # ones, whose rows past 493 are this port's.
        data = import_dex_text.text_data(gmm.ENGINE)
        names = [row["text"] for row in gmm.read(237)]
        added = import_species.added_species()
        checked = 0
        for bank, kind in sorted(import_dex_text.BANKS.items()):
            have = [row["text"] for row in gmm.read(bank)]
            for offset, name in enumerate(added):
                index = self.firstAdded + offset
                self.assertIn(name, data, f"the reference has no text for SPECIES_{name}")
                wanted = import_dex_text.wanted(kind, data[name], names[index])
                self.assertEqual(have[index], wanted, f"msg_{bank:04d} row {index} ({name})")
                checked += 1
        self.assertEqual(checked, len(added) * len(import_dex_text.BANKS))

    # ---- ability ----------------------------------------------------------

    def personal_records(self):
        return json.loads(PERSONAL.read_text())["baseStats"]

    def test_every_species_names_three_abilities_this_game_defines(self):
        """Both abilities and the hidden one.

        An ability id this tree has not got is not a build error anywhere: the
        record holds a number, and the number reaches nothing.
        """
        known = {f"ABILITY_{m}" for m in re.findall(
            r"#define ABILITY_([A-Z0-9_]+)\s+\d+", (ROOT / "include/constants/abilities.h").read_text())}
        records = self.personal_records()
        for number, name in self.species:
            record = records[number]
            self.assertEqual(record["species"], name, f"record {number} is {record['species']}")
            for ability in list(record["abilities"]) + [record.get("hiddenAbility", "ABILITY_NONE")]:
                self.assertTrue(ability in known,
                                f"{name} ({number}) names {ability}, which this game has not got")
            self.assertNotEqual(record["abilities"][0], "ABILITY_NONE",
                                f"{name} ({number}) has no first ability")

    def test_an_ability_that_is_not_pending_is_read_by_the_game(self):
        """The ledger of inert abilities has to match the source.

        The count below is only worth reading if "does something" means what it
        says, so the list it comes from is checked against the game rather than
        trusted: everything not pending is named somewhere the battle runs.
        """
        source = battle_source()
        names = re.findall(r"#define ABILITY_([A-Z0-9_]+)\s+\d+",
                           (ROOT / "include/constants/abilities.h").read_text())
        for name in names:
            if name == "NONE" or name in INERT_ABILITIES or name in NOT_AN_ABILITY:
                continue
            self.assertTrue(f"ABILITY_{name}" in source,
                            f"ABILITY_{name} counts as an effect and nothing reads it")

    def test_count_the_species_whose_abilities_do_nothing(self):
        """A number for the row, not a pass or a fail.

        A species both of whose abilities are still names is a species that
        fights with nothing: Zorua and Zoroark have only Illusion, Victini only
        Victory Star. They are not broken -- nothing reads past anything, the
        summary screen is right -- so this counts them and holds the count from
        growing rather than failing on each one.
        """
        records = self.personal_records()
        dead = []
        for number, name in self.species:
            record = records[number]
            abilities = [a[len("ABILITY_"):] for a in record["abilities"]]
            if all(a == "NONE" or a in INERT_ABILITIES for a in abilities):
                dead.append(name)
        print(f"{len(dead)} of {len(self.species)} species have no ability that does "
              f"anything: {', '.join(sorted(dead))}")
        self.assertLessEqual(len(dead), SPECIES_WITH_NOTHING_TO_DO,
                             f"{len(dead)} species have nothing but inert abilities and the "
                             f"ledger allows {SPECIES_WITH_NOTHING_TO_DO}")

    # ---- what the arithmetic still runs off the end of ---------------------

    def test_the_dex_metrics_reach_every_species(self):
        """The two tables a battle indexes by species, and used to fall off.

        zukan_data member 0 is the height and member 1 the weight, a u32 per
        species. They stopped at Arceus -- 494 entries -- while three readers
        index them by species with no bound: GetMonWeight for the Heavy Ball,
        battle_regulation.c for the link rulesets, and PokedexData_GetWeight,
        which fills battleMons[].weight for EVERY battler in EVERY battle and
        feeds Low Kick, Grass Knot and Autotomize. For a species past 493 all
        three read off the end of a heap allocation, and nothing says so: a
        garbage weight is a Low Kick doing the wrong damage, not a crash.

        tools/newgold/import/import_dex_metrics.py carried konefr's own metricsData
        across. This is what stops it going short again.
        """
        zukan, _, _ = wotbl.read_narc(
            (ROOT / "files/application/zukanlist/zkn_data/zukan_data.narc").read_bytes())
        for member, what in ((0, "height"), (1, "weight")):
            self.assertGreater(len(zukan[member]) // 4, self.lastSpecies,
                               f"the Dex {what} table stops before the last species")
        source = (ROOT / "src/battle/battle_command.c").read_text()
        self.assertIn("weightList[species]", source,
                      "GetMonWeight reads the table unbounded, so the table is the guard")

    def test_the_dex_metrics_match_the_reference(self):
        """Every species' height and weight is konefr's, not a filler."""
        if REFERENCE is None:
            self.skipTest("no reference checkout")
        sys.path[:0] = [str(ROOT / "tools/newgold" / sub) for sub in ("import", "devkit", "devkit/harness", "devkit/diag")]
        import import_dex_metrics as importer
        theirs = importer.metrics(Path(REFERENCE), importer.body_styles(Path(REFERENCE)))
        rows = json.loads((ROOT / "files/application/zukanlist/zkn_data/zukan_data.json")
                          .read_text())["mon_stats"]
        checked = 0
        for number, row in enumerate(rows):
            name = row["species"][len("SPECIES_"):]
            if name not in theirs:
                continue
            for field, want in theirs[name].items():
                if field == "body_style" and number > 493:
                    continue  # the reference's placeholder; the games' shape (test_dex_sort_lists)
                have = row[field]
                if isinstance(have, dict):
                    # Giratina: the reference has the Altered Forme's figures,
                    # which retail's pair keeps under "origin"
                    have = have["origin"]
                self.assertEqual(have, want, f"{row['species']}.{field}")
            checked += 1
        self.assertGreater(checked, 1000)

    def test_the_dex_metrics_importer_counts_nothing_on_a_rerun(self):
        """It counted a row as updated whenever the reference's figures
        differed from it, before putting back what it writes over them --
        the games' body style past Arceus and Giratina's pair -- so a rerun
        that changed nothing said "updated 729". A table with one of each,
        merged twice."""
        import import_dex_metrics as importer
        numbers = {f"MON{n}": n for n in range(495)}
        numbers["GIRATINA"] = numbers.pop("MON487")
        theirs = {name: {field: 1 for field in importer.FIELDS} for name in numbers}
        national, shapes = {"MON494": 906}, {906: 7}
        rows, added, _, _ = importer.merge([], theirs, numbers, national, shapes)
        self.assertEqual(added, 495)
        rows = json.loads(json.dumps(rows))
        again, added, changed, _ = importer.merge(rows, theirs, numbers, national, shapes)
        self.assertEqual((added, changed), (0, 0))
        self.assertEqual(again, rows)


if __name__ == "__main__":
    print(f"Pinned NewGold comparison: "
          f"{REFERENCE if REFERENCE is not None else 'unavailable; native expectations only'}")
    unittest.main()
