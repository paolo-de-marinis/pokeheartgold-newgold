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
    "BABY_LUGIA",   # Paolo, 2026-10-07: New Gold's own; its battle pictures and follower are his
)

# The battle pictures' entry animations Paolo chose for one of these, in place
# of the reference's (made for a picture that is not his): front, then back,
# each (cry delay, motion, motion delay, [(pose, ticks, x shift), ...]) as
# SpriteFrameData holds them. import_sprite_offsets.py writes them into the
# species' record; a species not listed keeps the reference's.
MOTIONS = {
    # Paolo, 2026-10-09: round 19's candidates F2 and B4, Cleffa's and Pichu's
    # squash and spring (motion 0), the wings beating, the cry at the top.
    "BABY_LUGIA": ((11, 0, 0, [(0, 3, 0), (1, 1, 0), (0, 1, 0), (1, 1, 0), (0, 1, 0), (1, 12, 0)]),
                   (11, 0, 0, [(0, 3, 0), (1, 1, 0), (0, 1, 0), (1, 1, 0), (0, 1, 0), (1, 12, 0)])),
}
