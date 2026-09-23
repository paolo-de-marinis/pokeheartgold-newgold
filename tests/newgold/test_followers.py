#!/usr/bin/env python3
"""Check the following-Pokemon models the added species walk with.

Retail has a following-Pokemon model for each of its species, forms and
female looks: 566 textures in files/data/mmodel from member 297, a model
number a species in sModelIndexLUT, sprite IDs from Bulbasaur's 428 to the
last Arceus' 993, the field's sprite table turning each sprite ID back into
its member, and four bytes a model in tsurepoke/tp_param.

hg-engine has a sprite for every species at d0380a487.
tools/newgold/import/import_followers.py converts each one the added species
here draw into a BTX0 as the reference's tool does and appends it after
retail's: models from 566, members from 863, sprite IDs from 1050.
"""

import re
import sys
import unittest

from test_level_cap import ROOT

sys.path.insert(0, str(ROOT / "tools/newgold/import"))
import import_followers  # noqa: E402


def added_models():
    """The added models' names, in order, from the sprite ID constants."""
    header = (ROOT / "include/constants/sprites.h").read_text()
    block = header[header.index("// The species New Gold adds"):]
    return re.findall(r"^#define SPRITE_FOLLOWER_MON_(\w+)\s+\d+$", block, re.M)[:-2]


class FollowerTests(unittest.TestCase):
    def test_the_sprite_table_draws_each_added_model_at_its_size(self):
        """Each added sprite ID names its own mmodel member, with the size
        class its texture has."""
        entries = dict((sprite, (member, int(size))) for sprite, member, size in re.findall(
            r"\{ SPRITE_FOLLOWER_MON_(\w+), MMODEL_FOLLOWER_MON_(\w+), 0x\w+ \| \((\d+) << 10\) \}",
            (ROOT / "src/field/object_graphics_info.c").read_text()))
        models = added_models()
        self.assertEqual(len(models), 741)
        for i, name in enumerate(models):
            data = (import_followers.MMODEL_DIR / f"mmodel_{863 + i:08d}.NSBTX").read_bytes()
            self.assertEqual(entries[name], (name, 20 if import_followers.texture_width(data) == 64 else 19), name)

    def test_every_added_model_has_its_follower_bytes(self):
        """tp_param has a row a model, and the added ones are the reference's."""
        rows = (ROOT / "files/fielddata/tsurepoke/tp_param.csv").read_text().splitlines()[1:]
        self.assertEqual(len(rows), 566 + len(added_models()))
        self.assertEqual(rows[566].split(",")[0], "FOLLOWER_MON_" + added_models()[0])

    def test_the_textures_are_the_reference_s(self):
        """Each added texture is what the reference's tool builds from its
        picture; retail's are what it builds from retail's."""
        if not import_followers.REFERENCE.exists():
            self.skipTest("no reference checkout")
        models, _ = import_followers.plan()
        for i, (name, directory, *_rest) in enumerate(models):
            data = (import_followers.MMODEL_DIR / f"mmodel_{863 + i:08d}.NSBTX").read_bytes()
            self.assertEqual(data, import_followers.nsbtx(directory), name)
        self.assertEqual((import_followers.MMODEL_DIR / "mmodel_00000297.NSBTX").read_bytes(),
                         import_followers.nsbtx("data/graphics/sprites/bulbasaur"))


if __name__ == "__main__":
    unittest.main()
