#!/usr/bin/env python3
"""Check that a hold effect this port added is a hold effect something reads.

An added held item is three separate things: a constant, a row of item data
naming a HOLD_EFFECT_, and battle code that switches on that effect. The first
two build and test clean on their own -- the item is in the bag, has a name, a
price and an icon, and a Pokemon holds it -- and the third can simply be
missing. Nine items shipped that way: the effects were defined, the records
pointed at them, and no line in src/ ever looked at one, so every one of them
was an ordinary rock to carry around.

Nothing else says so, because there is nothing to say it: an unread case in a
switch is not an error in any language.

Only the effects past retail's last are checked. The retail ones below it are
not all named in C -- the type-weakening Berries are one computed range, the
evolution items are read out of the evolution tables, the weather extenders go
by number -- and sorting those out is a different job from this one.

Then the whole of konefr's item range arrived, and sixty-four hold effects of
theirs came with it that nothing here reads yet. Those are deliberate: the
platform holds every item konefr could reach, and giving each of them its
behaviour is a pass of its own. They are let past the check above and counted
instead, so the block cannot quietly grow, an unread effect written by hand
still fails, and implementing one shows up as the number going down.
"""

import re
import unittest

from test_level_cap import ROOT

HEADER = ROOT / "include/constants/items.h"
ITEM_DATA = ROOT / "files/itemtool/itemdata/item_data.csv"
SRC = ROOT / "src"

# Eviolite's, the first effect this port added. Everything at or above it is
# New Gold's.
FIRST_ADDED = "HOLD_EFFECT_BOOST_IF_NOT_EVOLVED"
# The Douse Drive's, the first of konefr's own effects, renumbered here when
# the whole item range came in. Below it are the effects this port wrote by
# hand, and those have to be read by name somewhere. At or above it are the
# ones the range brought with it, which are counted instead.
FIRST_IMPORTED = "HOLD_EFFECT_DOUSE_DRIVE"
# How many of those an item carries and no line in src/ reads. It is every one
# of them: the import gave the items their records and left the behaviour.
IMPORTED_AND_UNREAD = 64


def effects_defined():
    """Every hold effect constant, by name -> number."""
    return {name: int(value) for name, value
            in re.findall(r"#define (HOLD_EFFECT_[A-Z0-9_]+)\s+(\d+)", HEADER.read_text())}


def effects_added():
    """The hold effects this port added, by name."""
    defined = effects_defined()
    return {name for name, value in defined.items() if value >= defined[FIRST_ADDED]}


def effects_in_records():
    """Every hold effect an item record names, by name."""
    return {line.split(",")[2] for line in ITEM_DATA.read_text().splitlines()[1:] if line.strip()}


def effects_read():
    """Every hold effect named anywhere under src/, by name."""
    read = set()
    for path in SRC.rglob("*.c"):
        read.update(re.findall(r"HOLD_EFFECT_[A-Z0-9_]+", path.read_text(errors="replace")))
    return read


class HoldEffectTests(unittest.TestCase):
    def test_every_effect_a_record_names_is_defined(self):
        defined = effects_defined()
        for effect in sorted(effects_in_records() - {"HOLD_EFFECT_NONE"}):
            self.assertIn(effect, defined, f"{effect} is in item_data.csv and in no header")

    def test_every_added_effect_an_item_carries_is_read(self):
        defined = effects_defined()
        read = effects_read()
        for effect in sorted(effects_added() & effects_in_records()):
            if defined[effect] >= defined[FIRST_IMPORTED]:
                continue  # counted below instead
            self.assertIn(effect, read,
                          f"an item carries {effect} and nothing in src/ reads it, "
                          f"so the item does nothing when it is held")

    def test_the_effects_the_item_range_brought_with_it_are_the_only_unread_ones(self):
        """The count is a pin, not a licence: it is the size of the block the
        import left behind, and it only ever goes down."""
        defined = effects_defined()
        unread = sorted(effects_added() & effects_in_records() - effects_read())
        self.assertEqual([e for e in unread if defined[e] < defined[FIRST_IMPORTED]], [],
                         "an effect below the imported block is unread; the test above "
                         "should have said so first")
        self.assertEqual(len(unread), IMPORTED_AND_UNREAD,
                         "the unread hold effects are no longer the block konefr's item "
                         "range brought with it:\n" + "\n".join(unread))

    def test_every_added_effect_is_carried_by_an_item(self):
        records = effects_in_records()
        for effect in sorted(effects_added()):
            self.assertIn(effect, records,
                          f"{effect} is defined and no item record names it, so no "
                          f"Pokemon can ever have it")


if __name__ == "__main__":
    unittest.main()
