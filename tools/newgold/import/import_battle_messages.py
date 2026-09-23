#!/usr/bin/env python3
"""Write msg_0197, the battle messages, from the reference's data/text/197.txt.

Rows 0 to 1786 are the reference's own, as the revision given has them: the
engine (d0380a487) by default, New Gold with --revision ccf2c9f5. The two files
are the same; konefr changed no battle message. The reference rewrote retail's
1276 rows in place and added 511 of its own after them. Where retail has a
garbage row the reference has an empty line, and that is what is written: a
used row with no text, which msgenc encodes as an empty string (a garbage row
would come out as spaces).

After the reference's last row come the lines this port prints and the
reference has no text for (PORT_ROWS). A line about one Pokemon is three rows,
the player's, the wild one's and the opposing trainer's, because the battle
adds one or two to the row for the other side
(BattleSystem_AdjustMessageForSide); a block with fewer would print whatever
follows it.

Usage: import_battle_messages.py [--revision REV] [--write]
Without --write it reports what it would change and touches nothing.
"""

import argparse
import sys
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parent))
import gmm  # noqa: E402

BANK = 197

# Each block: why the reference has no row for it, then its rows in order.
PORT_ROWS = [
    # Wandering Spirit. The reference swaps the two abilities under an ability
    # popup and prints nothing (subscript_0517); this game has no popup, so it
    # says what happened. The player's row is the port's own; the wild and
    # opposing rows follow the reference's Mummy rows 1307 and 1308, which say
    # the same thing about one ability.
    ("wandering spirit", [
        r"{STRVAR_1 1, 0, 0}’s Ability\nbecame {STRVAR_1 5, 1, 0}!",
        r"The wild {STRVAR_1 1, 0, 0}’s Ability\nbecame {STRVAR_1 5, 1, 0}!",
        r"The opposing {STRVAR_1 1, 0, 0}’s Ability\nbecame {STRVAR_1 5, 1, 0}!",
    ]),
    # Belch without a Berry. The reference has 1610 alone and prints it with
    # TAG_NICKNAME, so for a wild or a trainer's Pokemon it shows 1611 or 1612
    # (BattleController_BeforeMove.c, other_battle_calculators.c): its bug.
    ("belch", [
        r"{STRVAR_1 1, 0, 0} hasn’t eaten any held Berries,\nso it can’t possibly belch!",
        r"The wild {STRVAR_1 1, 0, 0} hasn’t eaten any held\nBerries, so it can’t possibly belch!",
        r"The opposing {STRVAR_1 1, 0, 0} hasn’t eaten any held\nBerries, so it can’t possibly belch!",
    ]),
    # Snow at the end of a turn. The reference's FIELD_CONDITION_SNOW_ALL
    # branch (ServerFieldConditionCheck.c) never sets the message id before
    # WEATHER_CONTINUES, so it has no row to print.
    ("snow continues", [
        r"The snow continues to fall.",
    ]),
    # Beat Up, one line a hit. The reference's Beat Up is the later games',
    # with no line for each party member, and it marks retail's 481 to 483
    # "(Unused)"; this game still prints one, so it keeps retail's three.
    ("beat up", [
        r"{STRVAR_1 1, 0, 0}’s attack!",
        r"The wild {STRVAR_1 1, 0, 0}’s attack!",
        r"The foe’s {STRVAR_1 1, 0, 0}’s attack!",
    ]),
    # Quick Draw. The reference gives the ability no effect and so no line;
    # this is the Custap Berry's 1254 to 1256 naming the ability instead.
    ("quick draw", [
        r"{STRVAR_1 1, 0, 0}\ncan act faster than normal,\fthanks to its {STRVAR_1 5, 1, 0}!",
        r"The wild {STRVAR_1 1, 0, 0}\ncan act faster than normal,\fthanks to its {STRVAR_1 5, 1, 0}!",
        r"The opposing {STRVAR_1 1, 0, 0}\ncan act faster than normal,\fthanks to its {STRVAR_1 5, 1, 0}!",
    ]),
    # Neutralizing Gas coming and going. The reference gives the ability no
    # effect and so no line; these are the later games' two, about the field
    # rather than a Pokemon, so one row each.
    ("neutralizing gas", [
        r"Neutralizing gas filled the area!",
    ]),
    ("neutralizing gas ends", [
        r"The effects of the neutralizing gas\nwore off!",
    ]),
    # Cud Chew eating a Berry again. The reference gives the ability no effect;
    # the later games show its popup, which this game has not, so the line says
    # what happened, as Harvest's "found one" does.
    ("cud chew", [
        r"{STRVAR_1 1, 0, 0} ate its\n{STRVAR_1 8, 1, 0} again!",
        r"The wild {STRVAR_1 1, 0, 0} ate its\n{STRVAR_1 8, 1, 0} again!",
        r"The opposing {STRVAR_1 1, 0, 0} ate its\n{STRVAR_1 8, 1, 0} again!",
    ]),
]


def rows(revision):
    texts = gmm.reference_rows(revision, BANK)
    if texts is None:
        raise SystemExit(f"{revision} has no data/text/{BANK:03d}.txt")
    for _, block in PORT_ROWS:
        texts += block
    return [gmm.new_row(BANK, index, text) for index, text in enumerate(texts)]


def port_row(name):
    """The index of a port block's first row, as the scripts and C use it."""
    first = len(gmm.reference_rows(gmm.ENGINE, BANK))
    for block_name, block in PORT_ROWS:
        if block_name == name:
            return first
        first += len(block)
    raise KeyError(name)


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--revision", default=gmm.ENGINE)
    parser.add_argument("--write", action="store_true")
    args = parser.parse_args()

    new = rows(args.revision)
    old = gmm.read(BANK)
    changed = [row["index"] for row in new
               if row["index"] >= len(old) or (old[row["index"]]["text"], old[row["index"]]["context"])
               != (row["text"], row["context"])]
    print(f"msg_{BANK:04d}: {len(old)} -> {len(new)} rows, {len(changed)} written differently")
    if args.write:
        gmm.write(BANK, new)


if __name__ == "__main__":
    main()
