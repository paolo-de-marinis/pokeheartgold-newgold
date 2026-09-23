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

Every species past Arceus used to resolve to model 0 and walk as a
Bulbasaur, and the Hall of Fame, its PC showcase, the Pokeathlon and the
certificates drew an NPC for it. Each of them now takes the species' own
model, or its base species' where hg-engine draws none.
"""

import io
import re
import sys
import unittest

from test_level_cap import ROOT, function
from test_picture_tables import run_native

sys.path.insert(0, str(ROOT / "tools/newgold/import"))
import import_followers  # noqa: E402


def table(source, name):
    start = source.index(f"static const u16 {name}[] = {{")
    return source[start:source.index("};", start) + 2]


def added_models():
    """The added models' names, in order, from the sprite ID constants."""
    header = (ROOT / "include/constants/sprites.h").read_text()
    block = header[header.index("// The species New Gold adds"):]
    return re.findall(r"^#define SPRITE_FOLLOWER_MON_(\w+)\s+\d+$", block, re.M)[:-2]


PROGRAM = r"""
#include <assert.h>
#include <stdint.h>
#include <stdio.h>
#include "constants/species.h"
#include "constants/pokemon.h"
#include "constants/sprites.h"
#include "constants/mmodel.h"
#include "constants/follow_mon_idx.h"
typedef uint8_t u8; typedef uint16_t u16; typedef uint32_t u32;
typedef int BOOL;
#define TRUE 1
#define FALSE 0
#define NELEMS(a) (sizeof(a) / sizeof(*(a)))
#define NARC_mmodel_mmodel_00000001_NSBTX 1
#define NARC_mmodel_mmodel_00000297_NSBTX 297
typedef struct Sprite { int slot; } Sprite;
typedef struct { int spriteId; Sprite *slots[2]; } LocalMapObject;
static int MapObject_GetSpriteID(LocalMapObject *obj) { return obj->spriteId; }
static u8 *sub_0205F40C(LocalMapObject *obj) { return (u8 *)obj->slots; }
static Sprite drawnApart = { 2 };
Sprite *sub_02064084(LocalMapObject *obj) { return &drawnApart; }
@SOURCE@
static Sprite first = { 0 }, second = { 1 };
static int slot(int spriteId) {
    LocalMapObject obj = { spriteId, { &first, &second } };
    return ov01_021F72DC(&obj)->slot;
}
static void walks(int species, u16 form, u32 gender, u32 sprite, u32 member) {
    assert(FollowMon_GetSpriteID(species, form, gender) == sprite);
    assert(slot(sprite) == 0);
    assert(RegisterHallOfFame_GetMmodelBySpeciesFormGender(species, form, gender) == (int)member);
    assert(ov64_021E6E30(species, form, gender) == member);
    assert(ov78_021E6688(species, form, gender) == member);
    assert(ov96_021E91B8(species, form, gender) == member);
}
int main(void) {
@CHECKS@
    // Retail's are where they were.
    walks(SPECIES_BULBASAUR, 0, MON_MALE, SPRITE_FOLLOWER_MON_BULBASAUR, MMODEL_FOLLOWER_MON_BULBASAUR);
    walks(SPECIES_VENUSAUR, 0, MON_FEMALE, SPRITE_FOLLOWER_MON_VENUSAUR_F, MMODEL_FOLLOWER_MON_VENUSAUR_F);
    walks(SPECIES_ARCEUS, 17, MON_MALE, SPRITE_FOLLOWER_MON_ARCEUS_DARK, MMODEL_FOLLOWER_MON_ARCEUS_DARK);
    walks(SPECIES_ARCEUS, 18, MON_MALE, SPRITE_FOLLOWER_MON_ARCEUS_NORMAL, MMODEL_FOLLOWER_MON_ARCEUS_NORMAL);
    // A form hg-engine never draws walks as its base species.
    walks(SPECIES_MEGA_VENUSAUR, 0, MON_FEMALE, SPRITE_FOLLOWER_MON_VENUSAUR, MMODEL_FOLLOWER_MON_VENUSAUR);
    walks(SPECIES_GIGANTAMAX_TOXTRICITY_LOW_KEY, 0, MON_MALE, SPRITE_FOLLOWER_MON_TOXTRICITY, MMODEL_FOLLOWER_MON_TOXTRICITY);
    // The static Pokemon between the two ranges are not followers.
    assert(slot(SPRITE_FOLLOWER_MON_STATIC_BUTTERFREE) == 1 && slot(SPRITE_FOLLOWER_MON_ADDED_LAST + 1) == 1);
    assert(FollowMon_GetSpriteID(NUM_SPECIES + 1, 0, MON_MALE) == SPRITE_FOLLOWER_MON_BULBASAUR);
    printf("PASS: every species walks as its own follower sprite.\n");
    return 0;
}
"""


class FollowerTests(unittest.TestCase):
    def test_every_species_walks_as_its_own_sprite(self):
        """The field, the Hall of Fame, its showcase, the Pokeathlon and the
        certificates take each added species' own model, or its base's where
        the reference draws none."""
        follow = (ROOT / "src/follow_mon.c").read_text()
        source = "\n".join(
            [table(follow, name) for name in ("sModelIndexLUT", "sFormMaxLUT", "sFemaleFlagLUT")]
            + [function(follow, name) for name in ("SpeciesToOverworldModelIndexOffset", "OverworldModelLookupFormCount",
                                                   "OverworldModelLookupHasFemaleForm", "FollowMon_GetSpriteID")]
            + [function((ROOT / path).read_text(), name) for path, name in (
                ("src/field/overlay_01_021F72DC.c", "ov01_021F72DC"),
                ("src/register_hall_of_fame.c", "RegisterHallOfFame_GetMmodelBySpeciesFormGender"),
                ("src/overlay_64_021E6E30.c", "ov64_021E6E30"),
                ("src/certificates_app.c", "ov78_021E6688"),
                ("src/pokeathlon/overlay_96_021E91B8.c", "ov96_021E91B8"))])
        checks = "\n".join(f"    walks(SPECIES_{name}, 0, MON_MALE, SPRITE_FOLLOWER_MON_{name}, MMODEL_FOLLOWER_MON_{name});"
                           for name in added_models())
        run_native(self, PROGRAM.replace("@SOURCE@", source).replace("@CHECKS@", checks), "followers")

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

    def test_each_texture_is_its_picture_s_size(self):
        """A texture's frames are as wide as the reference's picture of them.
        Four of its frame lists name the other size -- Hydrapple's and Garden
        Vivillon's pictures are 32 wide, Hatterene's and Dondozo's 64 -- and
        a texture sized by the list drew Hydrapple as a bare shadow."""
        if not import_followers.REFERENCE.exists():
            self.skipTest("no reference checkout")
        from PIL import Image
        models, _ = import_followers.plan()
        for i, (name, directory, *_rest) in enumerate(models):
            data = (import_followers.MMODEL_DIR / f"mmodel_{863 + i:08d}.NSBTX").read_bytes()
            picture = Image.open(io.BytesIO(import_followers.show(f"{directory}/overworld.png")))
            self.assertEqual(import_followers.texture_width(data), picture.width, name)

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
