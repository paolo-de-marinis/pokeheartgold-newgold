"""The species New Gold adds beyond the reference.

Every importer reads the reference by species name, and a species the
reference has not got would stop each of them, or be dropped by the next
re-run. A species listed here is one each importer carries the same way,
from four rules:

1. Wherever an importer reads the reference by species name, an own species
   reads its like's: the record and yields, the machines, the hidden ability,
   the egg moves, the Dex entry and category, the Dex metrics row, the
   picture records' animation, and the battle pictures, icon and palette
   number until Paolo's own are drawn (own_art.py). Its follower walks as its
   like's, the way a form walks as its base's. What is written here for it
   (the name, the Dex number, the size and the size page) overrides the
   like's.
2. What names the species itself is its own: its Dex species, the species
   its egg hatches as (itself, not its like), its trainer seed, its cry and
   its footprint member. It evolves into nothing, and nothing into it.
3. Where the tree's row for the like is not what the importer reads from the
   reference, the own species copies the tree's row as it is written: the
   level-up learnset (Lugia's is the engine's and konefr's, wotbl.py) and the
   tutor record (retail's).
4. import_species.py appends a listed species missing from species.h after
   all of the reference's own, so its identifier never moves and every table
   indexed by offset (icons, cries, followers) has it last.

The species' Dex flags live past the last reference species' place
(src/pokedex.c, DexFlagNo; docs/newgold/SAVE-LAYOUT.md), where one more fits.

The next species is one more entry.
"""

SPECIES = {
    # Paolo, 2026-10-07: Silver, the anime's baby Lugia. Lugia's data for now
    # but the size: the follower is drawn for 1.4 m; the weight is a
    # placeholder. cry_semitones raises Lugia's cry by that many.
    "BABY_LUGIA": {
        "like": "LUGIA",
        "name": "Baby Lugia",
        "national": 1026,
        "height": 14,
        "weight": 216,
        "height_text": "4’07”",
        "weight_text": "47.6 lbs.",
        # The Dex's size page: the trainer's scale and offset of every retail
        # species of 1.4 m, and the Pokemon drawn pixel for pixel, its
        # 62-row front as tall as retail's of 1.4 m are drawn there (54 to
        # 82 rows, 63 the median); import_dex_metrics.py stands it on
        # retail's line.
        "scale_m": 256, "ypos_m": 9, "scale_f": 272, "ypos_f": 8,
        "mon_scale_m": 256, "mon_scale_f": 256,
        "cry_semitones": 7,
    },
}


def like(name):
    """The species an own species reads the reference as; any other is itself."""
    return SPECIES.get(name, {}).get("like", name)
