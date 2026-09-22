#!/usr/bin/env python3
"""Check the four tables behind the reference's EXPAND_ settings.

EXPAND_TRAINER_PRIZE_MONEY, EXPAND_TRAINER_GENDER_TABLE, EXPAND_MUSIC_TABLES
and EXPAND_ROAMERS are hg-engine's way of lifting a table out of the ROM and
into C so that it can be edited: each one is a repoint plus a retyped copy of
what the cartridge held. This is a decompilation, so all four tables are
already C here and the setting itself is nothing to port. What is left of the
four is the data, and there the copies are not quite the same: the reference's
gender table calls Koga and Bruno female and carries a row for a class the
cartridge's stops one short of, and its encounter-music table names the two
Johto Ace Trainer classes where the cartridge names the other two.

Those three differences are the reference's, they are what its ROM reads, and
this checks that they are still here -- and that nothing else in the four has
drifted.
"""

import os
import re
import unittest
from pathlib import Path

from test_level_cap import ROOT

REFERENCE = Path(os.environ.get(
    "NEWGOLD_REFERENCE", "/home/paolo/Porting HGSS/hg-engine-newgold-reference"))


def body(text, start, end="\n};"):
    at = text.index(start)
    return text[at:text.index(end, at)]


def ours(path):
    return (ROOT / path).read_text()


def theirs(path):
    return (REFERENCE / path).read_text()


def combo_numbers():
    """The reference's ANIM_MUSIC_COMBO_ enum, by name."""
    text = theirs("include/constants/sndseq.h")
    at = text.index("ANIM_MUSIC_COMBO_FALKNER")
    block = text[text.rindex("{", 0, at):text.index("}", at)]
    return {name: i for i, name in enumerate(re.findall(r"ANIM_MUSIC_COMBO_\w+", block))}


def route(name):
    """MAP_ROUTE_29, MAP_R29 and MAP_W19 are the same map under three
    spellings; the number is the part both trees agree on."""
    return int(re.search(r"(\d+)$", name).group(1))


needs_reference = unittest.skipUnless(REFERENCE.exists(), "the reference checkout is not here")


class PrizeMoneyTests(unittest.TestCase):
    def rows(self):
        return re.findall(r"\.short\s+(TRAINERCLASS_\w+),\s*(\d+)",
                          body(ours("asm/overlay_12_battle_command.s"), "sPrizeMoneyTbl: ", "\n\n"))

    def test_the_table_is_the_length_the_code_reads(self):
        # extern u16 sPrizeMoneyTbl[0x81][2] in src/battle/battle_command.c.
        self.assertEqual(len(self.rows()), 0x81)

    @needs_reference
    def test_every_multiplier_is_the_reference_s(self):
        want = re.findall(r"\.class = (\w+), \.multiplier = (\d+)",
                          body(theirs("src/trainermoney.c"), "struct TrainerMoney PrizeMoney[]", "\n    };"))
        self.assertEqual(self.rows(), want)


class TrainerGenderTests(unittest.TestCase):
    def rows(self):
        out = []
        for line in body(ours("src/trainer_data.c"), "static const u8 sTrainerGenders[] = {").splitlines()[1:]:
            if line.strip():
                out.append((re.search(r"//\s*(TRAINERCLASS_\w+)", line).group(1),
                            re.search(r"(TRAINER_\w+)", line).group(1)))
        return out

    def test_the_table_reaches_the_last_trainer_class(self):
        """It used to stop at 127, and class 128 exists: reading its gender
        read the byte after the array."""
        last = int(re.search(r"#define TRAINERCLASS_PKMN_TRAINER_DAWN_PT\s+(\d+)",
                             ours("include/constants/trainer_class.h")).group(1))
        rows = self.rows()
        self.assertEqual(len(rows), last + 1)
        self.assertEqual(rows[last][0], "TRAINERCLASS_PKMN_TRAINER_DAWN_PT")

    def test_koga_and_bruno_are_the_reference_s_female(self):
        """The cartridge says TRAINER_DOUBLE for both. Only TRAINER_FEMALE is
        ever tested, and it decides which way a 50/50 species falls, so this is
        the gender of Koga's and Bruno's Pokemon."""
        genders = dict(self.rows())
        self.assertEqual(genders["TRAINERCLASS_ELITE_FOUR_KOGA"], "TRAINER_FEMALE")
        self.assertEqual(genders["TRAINERCLASS_ELITE_FOUR_BRUNO"], "TRAINER_FEMALE")

    @needs_reference
    def test_every_row_is_the_reference_s(self):
        want = re.findall(r"\[(TRAINERCLASS_\w+)\]\s*=\s*(TRAINER_\w+)",
                          body(theirs("src/pokemon.c"), "const u8 sTrainerGenders[] = {"))
        self.assertEqual(self.rows(), want)


class MusicTableTests(unittest.TestCase):
    def encounter_rows(self):
        return re.findall(r"\{\s*(TRAINERCLASS_\w+),\s*(\w+),\s*(\w+)\s*\}",
                          body(ours("src/field_bgm.c"), "sTrainerEncounterMusicParam[][3] = {"))

    def test_the_two_ace_trainer_rows_are_the_reference_s(self):
        """Where the cartridge names classes 24 and 25, the reference names
        their Johto twins, so in New Gold an Ace Trainer of either of the first
        two has no eyes-meet cue and the two GS classes have one."""
        classes = [row[0] for row in self.encounter_rows()]
        self.assertIn("TRAINERCLASS_ACE_TRAINER_M_GS", classes)
        self.assertIn("TRAINERCLASS_ACE_TRAINER_F_GS", classes)
        self.assertNotIn("TRAINERCLASS_ACE_TRAINER_M", classes)
        self.assertNotIn("TRAINERCLASS_ACE_TRAINER_F", classes)

    @needs_reference
    def test_the_encounter_table_is_the_reference_s(self):
        """Sorted, because the two copies disagree about the order of two of
        the Rocket executives and the table is a linear search in which each
        class appears once: the order is not something a player can hear, and
        those two have the same cue anyway."""
        want = re.findall(r"\.class = (\w+), \.music1 = (\w+), \.music2 = (\w+)",
                          body(theirs("src/music_tables.c"), "struct TrainerMusic sTrainerEncounterMusicParam[]", "\n    };"))
        self.assertEqual(sorted(self.encounter_rows()), sorted(want))

    @needs_reference
    def test_the_three_battle_music_tables_are_the_reference_s(self):
        """konefr added no row to any of them -- each ends at the marker
        hg-engine leaves for its own additions -- so all three still hold
        exactly what the cartridge held."""
        combo = combo_numbers()
        text = ours("asm/unk_020517A4.s")

        mine = [(name, int(n)) for name, n in
                re.findall(r"\.short (SPECIES_\w+) \| \((\d+) << 10\)", body(text, "_020FC3B4:", "_020FC3CA:"))]
        want = [(name, combo[c]) for name, c in
                re.findall(r"\.species = (SPECIES_\w+), \.combo = (ANIM_MUSIC_COMBO_\w+)",
                           body(theirs("src/music_tables.c"), "struct MonBattleMusic PokemonBattleMusic[] = {"))]
        self.assertEqual(mine, want, "the species that bring their own battle music")

        mine = [(name, int(n)) for name, n in
                re.findall(r"\.short (TRAINERCLASS_\w+) \| \((\d+) << 10\)", body(text, "_020FC3CA:", "_020FC40A:"))]
        want = [(name, combo[c]) for name, c in
                re.findall(r"\{ (TRAINERCLASS_\w+), (ANIM_MUSIC_COMBO_\w+) \* 4 \}",
                           body(theirs("src/music_tables.c"), "u8 TrainerClassToMusicCombo[][2] = {"))]
        self.assertEqual(mine, want, "the trainer classes that bring their own")

        mine = [(i, int(a, 0), seq) for i, (a, seq) in
                enumerate(re.findall(r"\.short (\d+|0x[0-9A-Fa-f]+), (\w+)", body(text, "_020FC40A:", "\n\n")))]
        want = sorted((combo[c], int(a, 0), seq) for c, a, seq in
                      re.findall(r"\[(ANIM_MUSIC_COMBO_\w+)\] = \{ (0x[0-9A-Fa-f]+|\d+), (\w+) \}",
                                 body(theirs("src/music_tables.c"), "u16 MainMusicComboTable[][2] = {")))
        self.assertEqual(mine, want, "the animation and music each combo is")


class RoamerTests(unittest.TestCase):
    def locations(self):
        return [route(name) for name in re.findall(
            r"MAP_\w+", body(ours("src/field_roamer.c"), "static const u32 sRoamerLocations[ROAMER_LOC_COUNT] = {"))]

    def test_the_four_roamers_are_what_they_were(self):
        text = ours("src/field_roamer.c")
        for species, level in (("RAIKOU", 40), ("ENTEI", 40), ("LATIAS", 35), ("LATIOS", 35)):
            at = text.index(f"species = SPECIES_{species};")
            self.assertRegex(text[at:at + 120], rf"level = {level};", species)

    @needs_reference
    def test_the_routes_they_roam_are_the_reference_s(self):
        want = [route(name) for name in re.findall(
            r"MAP_\w+", body(theirs("src/field_roamer.c"), "sRoamerLocations[ROAMER_LOC_COUNT] = {"))]
        self.assertEqual(self.locations(), want)


if __name__ == "__main__":
    unittest.main()
