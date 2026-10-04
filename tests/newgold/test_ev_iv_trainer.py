#!/usr/bin/env python3
"""The EV/IV trainer's rules, compiled from src/ev_iv_trainer_rules.c.

EVs: 252 a stat and 510 in all (Pokemon Central, Punti base), which is all
the Max button and the arrows may reach. The fee: 500 for every started ten
EVs a stat gains, as the Mochi that add ten to one stat cost, so a spread of
4, 252 and 252 from nothing is 1 + 26 + 26 tens, 26,500; taking EVs away is
free. The Judge's scale is the latest games'. Hyper Training (Allenamento
Pro) as Scarlet and Violet have it: from level 50, never a stat at 31 or one
already trained.

The app's screens and its texts are checked here too, in what can be read
without the game: every row the app prints exists and fits where it goes.
"""

import os
from pathlib import Path
import re
import shlex
import struct
import subprocess
import tempfile
import unittest

from test_repels import ROOT, function, read

FIXTURE = r"""
#include <assert.h>
#include <stdint.h>
#include "constants/pokemon.h"
typedef uint8_t u8;
typedef uint16_t u16;
typedef uint32_t u32;
typedef int BOOL;
@HEADER@
@RULES@

static u32 Fee(int hp, int atk, int def, int spe, int spa, int spd) {
    static const u8 none[NUM_STATS] = { 0 };
    u8 after[NUM_STATS] = { hp, atk, def, spe, spa, spd };
    return EvIvTrainer_Fee(none, after);
}

int main(void) {
    // 252 a stat, 510 in all.
    u8 evs[NUM_STATS] = { 0 };
    assert(EvIvTrainer_EvRoom(evs, STAT_HP) == 252);
    evs[STAT_HP] = 252;
    evs[STAT_ATK] = 252;
    assert(EvIvTrainer_EvRoom(evs, STAT_HP) == 0);
    assert(EvIvTrainer_EvRoom(evs, STAT_DEF) == 6);
    evs[STAT_DEF] = 6;
    assert(EvIvTrainer_EvRoom(evs, STAT_SPEED) == 0);
    evs[STAT_ATK] = 100;
    assert(EvIvTrainer_EvRoom(evs, STAT_ATK) == 152);

    // The fee: started tens of each stat that gains.
    assert(Fee(0, 0, 0, 0, 0, 0) == 0);
    assert(Fee(1, 0, 0, 0, 0, 0) == 500);
    assert(Fee(10, 0, 0, 0, 0, 0) == 500);
    assert(Fee(11, 0, 0, 0, 0, 0) == 1000);
    assert(Fee(4, 0, 0, 252, 252, 0) == 26500);
    assert(Fee(1, 1, 1, 1, 1, 1) == 3000);
    {
        // The mockup's: Attack 18 to 0, Sp. Atk 40 to 252 -- 22 tens; the loss is free.
        u8 before[NUM_STATS] = { 12, 18, 6, 52, 40, 8 };
        u8 after[NUM_STATS] = { 12, 0, 6, 52, 252, 8 };
        assert(EvIvTrainer_Fee(before, after) == 11000);
        assert(EvIvTrainer_Fee(after, before) == 1000);
        assert(EvIvTrainer_Fee(before, before) == 0);
    }

    // The latest games' Judge.
    assert(EvIvTrainer_JudgeRank(0) == JUDGE_NO_GOOD);
    assert(EvIvTrainer_JudgeRank(1) == JUDGE_DECENT && EvIvTrainer_JudgeRank(15) == JUDGE_DECENT);
    assert(EvIvTrainer_JudgeRank(16) == JUDGE_PRETTY_GOOD && EvIvTrainer_JudgeRank(25) == JUDGE_PRETTY_GOOD);
    assert(EvIvTrainer_JudgeRank(26) == JUDGE_VERY_GOOD && EvIvTrainer_JudgeRank(29) == JUDGE_VERY_GOOD);
    assert(EvIvTrainer_JudgeRank(30) == JUDGE_FANTASTIC);
    assert(EvIvTrainer_JudgeRank(31) == JUDGE_BEST);

    // Hyper Training: level 50, a stat under 31 that is not trained yet.
    assert(!EvIvTrainer_CanHyperTrain(49, 10, 0, STAT_HP));
    assert(EvIvTrainer_CanHyperTrain(50, 10, 0, STAT_HP));
    assert(EvIvTrainer_CanHyperTrain(100, 30, 0, STAT_SPDEF));
    assert(!EvIvTrainer_CanHyperTrain(100, 31, 0, STAT_SPDEF));
    assert(!EvIvTrainer_CanHyperTrain(100, 3, MON_HYPER_TRAINED_BIT(STAT_SPDEF), STAT_SPDEF));
    assert(EvIvTrainer_CanHyperTrain(100, 3, MON_HYPER_TRAINED_BIT(STAT_SPATK), STAT_SPDEF));
    return 0;
}
"""


def header():
    """ev_iv_trainer.h's constants and its enum, without the game's headers."""
    text = read("include/ev_iv_trainer.h")
    keep = re.findall(r"^#define EV_TRAINER_\w+ .*$", text, re.M)
    keep.append(re.search(r"enum JudgeRank \{.*?\};", text, re.S).group(0))
    return "\n".join(keep)


class RulesTests(unittest.TestCase):
    def test_the_rules(self):
        rules = read("src/ev_iv_trainer_rules.c")
        body = "\n".join(function(rules, name) for name in (
            "EvIvTrainer_EvRoom", "EvIvTrainer_Fee", "EvIvTrainer_JudgeRank", "EvIvTrainer_CanHyperTrain"))
        source = FIXTURE.replace("@HEADER@", header()).replace("@RULES@", body)
        with tempfile.TemporaryDirectory(prefix="newgold-trainer-") as directory:
            path = Path(directory)
            (path / "check.c").write_text(source)
            subprocess.run(shlex.split(os.environ.get("CC", "cc")) + [
                "-std=c99", "-Wall", "-Wextra", "-Werror", "-Wno-unused-function", "-O2",
                "-iquote", str(ROOT / "include"), str(path / "check.c"), "-o", str(path / "check")], check=True)
            subprocess.run([str(path / "check")], cwd=directory, check=True)

    def test_the_app_writes_only_what_was_confirmed(self):
        """The Pokemon is written in one place, after the YES, and the money
        and the caps are spent there too."""
        app = read("src/ev_iv_trainer_app.c")
        writes = [m.start() for m in re.finditer(r"SetMonData\(app->mon,", app)]
        apply = function(app, "Trainer_Apply")
        start = app.index(apply)
        self.assertTrue(writes and all(start <= w < start + len(apply) for w in writes), "a write outside Trainer_Apply")
        self.assertIn("PlayerProfile_SubMoney(app->profile, fee)", apply)
        self.assertIn("Bag_TakeItem(app->bag, ITEM_GOLD_BOTTLE_CAP, 1", apply)
        self.assertIn("CalcMonStats(app->mon)", apply)
        answered = function(app, "Trainer_Answered")
        self.assertIn("Trainer_Apply(app)", answered)


# The narrow font and the system one, as the app prints with them.
FONTS = {0: "font_00000000.bin", 5: "font_00000010.bin"}


def widths(font):
    data = (ROOT / "files/graphic/font" / FONTS[font]).read_bytes()
    header, width_at, glyphs = struct.unpack_from("<III", data, 0)
    return data[width_at:width_at + glyphs]


def charmap():
    out = {}
    for line in (ROOT / "charmap.txt").read_text(encoding="utf-8").splitlines():
        code, sep, text = line.partition("=")
        if sep and len(text) == 1 and text not in out:
            try:
                out[text] = int(code.strip(), 16)
            except ValueError:
                pass
    out[" "] = 0x1DE
    return out


def width(text, font):
    table, codes = widths(font), charmap()
    text = re.sub(r"\{[^}]*\}", "000", text)   # a number or a name: three digits' room
    return sum(table[codes.get(ch, 0x1AC) - 1] for ch in text)


def rows(bank):
    text = (ROOT / "files/msgdata/msg" / bank).read_text(encoding="utf-8")
    return {int(i): body for i, body in re.findall(r'<row id="[^"]*" index="(\d+)">.*?<language name="English">(.*?)</language>', text, re.S)}


class TextTests(unittest.TestCase):
    """The rows the app prints and where they go: (font, pixels there)."""

    ROOM = {
        0: (0, 90),                    # the title, top right
        **{r: (0, 43) for r in range(12, 18)},     # the stat names, from x 8 in a label cell ending at 51
        **{r: (0, 84) for r in range(30, 36)},     # the Judge's words, in a row's value cell
        36: (5, 76),                   # Hyper trained!, small, before the IV
        37: (5, 132), 38: (5, 132),    # the two lines under the IV page's rows
        47: (5, 132), 64: (5, 132),
        39: (0, 50), 40: (5, 50), 25: (5, 50), 26: (5, 50), 43: (5, 50),   # the blue buttons
        27: (5, 90), 24: (5, 90),
        1: (0, 88), 2: (0, 88), 3: (0, 88),   # the bottom screen's headers
        48: (0, 130),
    }

    def test_every_row_the_app_names_exists(self):
        app = read("src/ev_iv_trainer_app.c")
        bank = rows("msg_0829.gmm")
        for row in set(re.findall(r"msg_0829_(\d{5})", app)):
            self.assertIn(int(row), bank, f"msg_0829_{row} has no row")

    def test_the_rows_fit_where_they_are_printed(self):
        bank = rows("msg_0829.gmm")
        for row, (font, room) in self.ROOM.items():
            for line in bank[row].split("\\n"):
                self.assertLessEqual(width(line, font), room, f"msg_0829 row {row} {line!r} in font {font}")

    def test_the_message_window_lines_fit(self):
        """The confirmation window is 22 tiles, 176 pixels of the message font."""
        bank = rows("msg_0829.gmm")
        for row in (49, 50, 51, 52, 53, 54, 55, 56):
            for line in bank[row].split("\\n"):
                self.assertLessEqual(width(line, 0), 170, f"msg_0829 row {row} {line!r}")


if __name__ == "__main__":
    unittest.main()
