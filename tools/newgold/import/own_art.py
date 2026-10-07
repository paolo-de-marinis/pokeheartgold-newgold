"""The species whose pictures are Paolo's own, not the reference's.

Paolo has a species' pictures drawn where the reference has a placeholder
or none (docs/newgold/DEVKIT-PROMPTS.md), and
tools/newgold/devkit/sprites/convert_chatgpt.py writes them into the tree:
the battle front and back with the shiny palette, the party icon and its
palette number, the follower's texture. The tree's pictures are then the
source, and every importer that writes those files keeps them for a species
listed here instead of putting the reference's back on a re-run:
import_sprites.py (the battle pictures), import_icons.py (the icon and its
palette number, taken from the icon), import_followers.py (the texture) and
import_sprite_offsets.py (the record, placed for the picture). heights.py
reads the tree's pictures for every species already.

The next species is one more line.
"""

SPECIES = (
    "BRAMBLIN",     # Paolo, 2026-10-08: the reference drew Bulbasaur's battle pictures for it
)
