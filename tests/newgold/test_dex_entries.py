#!/usr/bin/env python3
"""Every Pokedex entry fits the window the Dex prints it in, in the reference's words.

HeartGold prints msg_0803 and SoulSilver msg_0804 (ZUKAN_FLAVOR_GMM in
ov18_021E590C.c), one row per species and form, a caught form its own; the
other languages' pages, 805..810, only up to Arceus (ov18_021E5A50_sub2).
ov18_021EE984 centres an entry by its widest line: one wider than the window
wraps the position in u32, and the Dex shows a piece of the first line and
nothing else. A line past the window's height is not drawn.

hg-engine breaks its entries for a wider box. import_species_text.fit_entry
breaks again, at spaces, the ones that do not fit, and leaves the rest as they
are. Some need more lines than the window has however they are broken: those
are LEFT_FOR_PAOLO, the reference's text as it is, until other words or a
bigger window are chosen. Take a species off the list when its entry fits.
"""

import html
import re
import sys
import unittest

from test_level_cap import ROOT

sys.path[:0] = [str(ROOT / "tools/newgold/import")]
import gmm  # noqa: E402
import import_species_text  # noqa: E402

REFERENCE = gmm.REFERENCE if (gmm.REFERENCE / ".git").exists() else None
HEARTGOLD, SOULSILVER = 803, 804
FOREIGN = range(805, 811)
ARCEUS = 493
FIRST_ADDED = 508
REBROKEN = 46       # entries whose breaks fit_entry moved

# Four lines of the window's width at the least; Enamorus, both forms, five.
LEFT_FOR_PAOLO = {
    "URSALUNA", "ANNIHILAPE", "FARIGIRAF", "DUDUNSPARCE", "HYDRAPPLE", "VANILLITE", "MELMETAL",
    "GRAPPLOCT", "OBSTAGOON", "FALINKS", "REGIELEKI", "BASCULEGION", "SNEASLER", "OVERQWIL",
    "ENAMORUS", "SPRIGATITO", "MEOWSCARADA", "CROCALOR", "SKELEDIRGE", "QUAXLY", "QUAXWELL",
    "QUAQUAVAL", "TAROUNTULA", "SPIDOPS", "NYMBLE", "LOKIX", "PAWMI", "PAWMO", "MAUSHOLD",
    "SMOLIV", "DOLLIV", "SQUAWKABILLY", "NACLI", "NACLSTACK", "GARGANACL", "ARMAROUGE",
    "CERULEDGE", "TADBULB", "BELLIBOLT", "WATTREL", "KILOWATTREL", "MASCHIFF", "GRAFAIAI",
    "BRAMBLIN", "BRAMBLEGHAST", "TOEDSCOOL", "TOEDSCRUEL", "KLAWF", "CAPSAKID", "SCOVILLAIN",
    "RELLOR", "RABSCA", "FLITTLE", "TINKATUFF", "TINKATON", "BOMBIRDIER", "PALAFIN", "VAROOM",
    "REVAVROOM", "CYCLIZAR", "HOUNDSTONE", "FLAMIGO", "CETITAN", "VELUZA", "CLODSIRE",
    "BRUTE_BONNET", "FLUTTER_MANE", "IRON_TREADS", "IRON_BUNDLE", "IRON_HANDS", "IRON_THORNS",
    "GIMMIGHOUL", "GHOLDENGO", "CHIEN_PAO", "ROARING_MOON", "KORAIDON", "IRON_LEAVES",
    "POLTCHAGEIST", "SINISTCHA", "MUNKIDORI", "OGERPON", "GOUGING_FIRE", "RAGING_BOLT",
    "IRON_CROWN", "PECHARUNT",
    # Forms.
    "ENAMORUS_THERIAN", "BASCULEGION_FEMALE", "MAUSHOLD_FAMILY_OF_THREE",
    "SQUAWKABILLY_BLUE_PLUMAGE", "SQUAWKABILLY_YELLOW_PLUMAGE", "SQUAWKABILLY_WHITE_PLUMAGE",
    "PALAFIN_HERO", "DUDUNSPARCE_THREE_SEGMENT", "GIMMIGHOUL_ROAMING", "REVAVROOM_SEGIN",
    "REVAVROOM_SCHEDAR", "REVAVROOM_NAVI", "REVAVROOM_RUCHBAH", "REVAVROOM_CAPH",
    "KORAIDON_LIMITED_BUILD", "KORAIDON_SPRINTING_BUILD", "KORAIDON_SWIMMING_BUILD",
    "KORAIDON_GLIDING_BUILD", "POLTCHAGEIST_MASTERPIECE", "SINISTCHA_MASTERPIECE",
    "OGERPON_WELLSPRING_MASK", "OGERPON_HEARTHFLAME_MASK", "OGERPON_CORNERSTONE_MASK",
    "OGERPON_TEAL_MASK_TERASTAL", "OGERPON_WELLSPRING_MASK_TERASTAL",
    "OGERPON_HEARTHFLAME_MASK_TERASTAL", "OGERPON_CORNERSTONE_MASK_TERASTAL",
    "URSALUNA_BLOODMOON", "GIGANTAMAX_MELMETAL", "MEGA_FALINKS", "MEGA_SCOVILLAIN",
}


def entries(bank):
    return [html.unescape(row["text"]) for row in gmm.read(bank)]


def same_words(a, b):
    return a.replace("\\n", " ") == b.replace("\\n", " ")


class DexEntryTests(unittest.TestCase):
    def test_the_window_and_the_widths_are_the_games(self):
        """28 x 6 tiles, a line every 16 px; the capture page's window
        (ov18_021F8CCC, the 5th of ov18_021FBDB4) is the same size. The
        widths agree with retail, whose widest line is 222 px."""
        self.assertEqual(import_species_text.entry_window(), (224, 3))
        # The table's file changes as overlay 18 is decompiled around it.
        capture = next(text for text in (path.read_text() for path in sorted((ROOT / "asm").glob("overlay_18_*.s")))
                       if "ov18_021FBDB4:" in text)
        rows = re.findall(r"\.byte (.*)\n\s*\.short", capture[capture.index("ov18_021FBDB4:"):])
        self.assertEqual([int(n, 0) for n in rows[4].split(",")][3:5], [28, 6])
        self.assertIn("foes, it weaves its flexible body in close,", entries(HEARTGOLD)[454])
        self.assertEqual(import_species_text.line_widths("foes, it weaves its flexible body in close,"), [222])

    def test_every_entry_the_game_prints_fits(self):
        names = import_species_text.port_species()
        for bank, last in ((HEARTGOLD, max(names)), (SOULSILVER, max(names)), *((b, ARCEUS) for b in FOREIGN)):
            rows = entries(bank)
            self.assertEqual(len(rows), max(names) + 1, f"msg_{bank:04d}")
            too_wide = {names[n] for n in range(1, last + 1) if not import_species_text.fits(rows[n])}
            self.assertEqual(too_wide, LEFT_FOR_PAOLO if last > ARCEUS else set(), f"msg_{bank:04d}")

    def test_what_is_left_fits_no_way_it_can_be_broken(self):
        texts = entries(HEARTGOLD)
        for number, name in import_species_text.port_species().items():
            if name in LEFT_FOR_PAOLO:
                self.assertEqual(import_species_text.fit_entry(texts[number]), texts[number], name)

    @unittest.skipIf(REFERENCE is None, "behaviour reference not present")
    def test_the_words_are_the_references(self):
        """HeartGold's rows are Species.c's at konefr's tip, word for word, and
        an entry that fitted has its breaks too. SoulSilver's and the other
        languages' rows past the retail species are HeartGold's."""
        ours = entries(HEARTGOLD)
        moved = 0
        for number, fields in import_species_text.fields_by_port_row(gmm.NEWGOLD).items():
            theirs = fields["pokedexEntry"].replace('"', "”").replace("'", "’").replace("`", "’")
            self.assertTrue(same_words(ours[number], theirs), number)
            if import_species_text.fits(theirs):
                self.assertEqual(ours[number], theirs, number)
            moved += ours[number] != theirs
        self.assertEqual(moved, REBROKEN)
        for bank in (SOULSILVER, *FOREIGN):
            self.assertEqual(entries(bank)[FIRST_ADDED:], ours[FIRST_ADDED:], f"msg_{bank:04d}")


if __name__ == "__main__":
    unittest.main()
