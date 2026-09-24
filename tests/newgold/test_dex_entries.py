#!/usr/bin/env python3
"""Every Pokedex entry fits the window the Dex prints it in, three lines at a
time, in the reference's words.

HeartGold prints msg_0803 and SoulSilver msg_0804 (ZUKAN_FLAVOR_GMM in
ov18_021E590C.c), one row per species and form, a caught form its own; the
other languages' pages, 805..810, only up to Arceus (ov18_021E5A50_sub2).
ov18_021EE984 centres an entry by its widest line, and the window shows three
lines: an entry of more is shown three lines at a time, and its pages turn by
themselves (DexEntryPages; test_dex_entry_pages.py runs it).

hg-engine breaks its entries for a wider box. import_species_text.fit_entry
leaves the ones that fit as they are and breaks the others again, at spaces:
into three lines where three can hold them, and where they cannot into two
pages of three, keeping the reference's own lines that fit.
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
REBROKEN = 46       # entries fit_entry breaks again into three lines
PAGED = 116         # entries three lines cannot hold, broken into two pages


def entries(bank):
    return [html.unescape(row["text"]) for row in gmm.read(bank)]


def same_words(a, b):
    return a.replace("\\n", " ") == b.replace("\\n", " ")


def three_lines_hold(text):
    """However the entry is broken at its spaces, three lines of the window
    hold it."""
    width, lines = import_species_text.entry_window()
    words = re.split(r" |\\n", text)
    return import_species_text.balance(words, range(1, lines + 1))[0] <= width


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
        """HeartGold's and SoulSilver's entries in two pages at the most, the
        other languages' (retail's, to Arceus) in one."""
        names = import_species_text.port_species()
        for bank, last, pages in ((HEARTGOLD, max(names), import_species_text.PAGES),
                                  (SOULSILVER, max(names), import_species_text.PAGES),
                                  *((b, ARCEUS, 1) for b in FOREIGN)):
            rows = entries(bank)
            self.assertEqual(len(rows), max(names) + 1, f"msg_{bank:04d}")
            too_long = {names[n] for n in range(1, last + 1) if not import_species_text.fits(rows[n], pages)}
            self.assertEqual(too_long, set(), f"msg_{bank:04d}")

    def test_an_entry_of_pages_needs_them(self):
        """An entry is broken into pages only where three lines cannot hold
        it, however it is broken."""
        paged = [text for text in entries(HEARTGOLD) if not import_species_text.fits(text)]
        self.assertEqual(len(paged), PAGED)
        for text in paged:
            self.assertFalse(three_lines_hold(text), text)

    @unittest.skipIf(REFERENCE is None, "behaviour reference not present")
    def test_the_words_are_the_references(self):
        """HeartGold's rows are Species.c's at konefr's tip, word for word; an
        entry that fitted is as it was, one three lines can hold is three
        lines, and one of pages keeps the reference's lines that fit.
        SoulSilver's and the other languages' rows past the retail species
        are HeartGold's."""
        width, lines = import_species_text.entry_window()
        ours = entries(HEARTGOLD)
        rebroken = paged = 0
        for number, fields in import_species_text.fields_by_port_row(gmm.NEWGOLD).items():
            theirs = fields["pokedexEntry"].replace('"', "”").replace("'", "’").replace("`", "’")
            self.assertTrue(same_words(ours[number], theirs), number)
            if import_species_text.fits(theirs):
                self.assertEqual(ours[number], theirs, number)
            elif three_lines_hold(theirs):
                self.assertTrue(import_species_text.fits(ours[number]), number)
                rebroken += 1
            else:
                kept = [line for line in theirs.split("\\n") if import_species_text.line_widths(line)[0] <= width]
                self.assertTrue(set(kept) <= set(ours[number].split("\\n")), number)
                self.assertGreater(len(ours[number].split("\\n")), lines, number)
                paged += 1
        self.assertEqual((rebroken, paged), (REBROKEN, PAGED))
        for bank in (SOULSILVER, *FOREIGN):
            self.assertEqual(entries(bank)[FIRST_ADDED:], ours[FIRST_ADDED:], f"msg_{bank:04d}")


if __name__ == "__main__":
    unittest.main()
