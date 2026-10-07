#!/usr/bin/env python3
"""Every Pokemon that can be female has a female picture.

The game reads the female member of pokegra.narc for every female Pokemon,
so the repository keeps a female picture for every species that can be
female -- the male one again where there is no difference -- and leaves a
gender's files empty only where that gender does not exist. An importer that
left the female empty when it matched the male sent 504 species' females
into a data abort on the way into battle (2026-09-22, a female Sylveon
against Falkner).

A species listed in tools/newgold/import/own_art.py has pictures Paolo had
drawn (docs/newgold/DEVKIT-PROMPTS.md) where the reference has a
placeholder, written into the tree by convert_chatgpt.py. Every importer
that writes those files has to keep the tree's for it: one that copied the
reference's again would put Bulbasaur's battle pictures back on Bramblin.
And each of his pictures is the size and palette the game reads it in.
"""

import io
import json
import os
import re
import struct
import sys
import unittest
from pathlib import Path
from unittest import mock

from PIL import Image, ImageOps

from test_level_cap import ROOT, function

sys.path.insert(0, str(ROOT / "tools/newgold/import"))
import import_followers  # noqa: E402
import import_icons  # noqa: E402
import import_species  # noqa: E402
import import_sprites  # noqa: E402
import own_art  # noqa: E402
import own_species  # noqa: E402

SPRITES = ROOT / "files/poketool/pokegra/pokegra"
REFERENCE = Path(os.environ.get("HG_ENGINE_NEWGOLD_REFERENCE", import_followers.REFERENCE))
# Paolo's icon for Baby Lugia is not drawn yet (2026-10-07): his picture has
# 50x50 frames, which a 32x32 icon cannot show at its own pixels. Lugia's
# stands in, in the shared palette the game shows it in.
PLACEHOLDER_ICONS = {"BABY_LUGIA"}


def species_numbers():
    text = (ROOT / "include/constants/species.h").read_text()
    return {m.group(1): int(m.group(2)) for m in re.finditer(r"#define SPECIES_(\w+)\s+(\d+)\b", text)}


class SpriteTests(unittest.TestCase):
    def test_every_gender_a_species_can_be_has_its_pictures(self):
        personal = json.loads((ROOT / "files/poketool/personal/personal.json").read_text())["baseStats"]
        missing = []
        for species in range(1, len(personal)):
            if 494 <= species <= 507:
                continue  # the egg, the bad egg and the retail forms live in otherpoke.narc
            ratio = personal[species]["genderRatio"]
            genders = (["male"] if ratio < 1 else []) + (["female"] if 0 < ratio <= 1 else [])
            for gender in genders:
                for name in ("front.png", "back.png"):
                    if (SPRITES / f"{species:04d}" / gender / name).stat().st_size == 0:
                        missing.append(f"{species:04d}/{gender}/{name}")
        self.assertEqual(missing, [], "a picture the game will ask for is empty:\n" + "\n".join(missing[:20]))

    def test_every_gender_the_dex_records_draws_a_picture(self):
        """The Dex draws a species' picture in the gender it saw: its own
        genders and those of its forms, which count for it
        (SpeciesToDexSpecies). A female Meowstic is MEOWSTIC_FEMALE and the
        base is male-only, so the Dex asks for Meowstic, female: the picture
        code has to send that to the female species."""
        personal = json.loads((ROOT / "files/poketool/personal/personal.json").read_text())["baseStats"]
        numbers = species_numbers()
        pokemon = (ROOT / "src/pokemon.c").read_text()
        sprite = function(pokemon, "GetMonSpriteCharAndPlttNarcIdsEx")
        own_case = {numbers.get(name) for name in re.findall(r"case SPECIES_(\w+):", sprite[:sprite.index("default:")])}
        mapping = re.search(r"^u16 PicSpecies_FemaleForm\(.*?^\}", pokemon, re.M | re.S)
        female_form = {numbers[a]: numbers[b] for a, b in re.findall(
            r"case SPECIES_(\w+):\s*return SPECIES_(\w+);", mapping.group(0) if mapping else "")}
        bases = {numbers[form]: numbers[base] for form, base in re.findall(
            r"\[SPECIES_(\w+) - NATIONAL_DEX_COUNT - 1\] = SPECIES_(\w+),", (ROOT / "src/pokedex.c").read_text())}
        recorded = {}
        for species in range(1, len(personal)):
            if 494 <= species <= 507:
                continue
            ratio = personal[species]["genderRatio"]
            genders = (["male"] if ratio != 1 else []) + (["female"] if 0 < ratio <= 1 else [])
            recorded.setdefault(bases.get(species, species), set()).update(genders)
        missing = []
        for species, genders in sorted(recorded.items()):
            if species in own_case:
                continue  # otherpoke.narc, by form
            for gender in sorted(genders):
                drawn = female_form.get(species, species) if gender == "female" else species
                if (SPRITES / f"{drawn:04d}" / gender / "front.png").stat().st_size == 0:
                    missing.append(f"{species:04d} {gender} -> {drawn:04d}/{gender}/front.png")
        self.assertEqual(missing, [], "the Dex draws an empty picture:\n" + "\n".join(missing))

    def test_the_picture_and_its_height_ask_the_female_form(self):
        """The mapping above only counts if the two functions that draw a
        picture from a species and a gender -- the picture and palette, and
        the picture's height -- send the base's female to it."""
        pokemon = (ROOT / "src/pokemon.c").read_text()
        for name in ("GetMonSpriteCharAndPlttNarcIdsEx", "GetMonPicHeightBySpeciesGenderForm"):
            with self.subTest(function=name):
                self.assertIn("PicSpecies_FemaleForm(species, gender)", function(pokemon, name))


def palette_table():
    source = import_icons.INDEX.read_text()
    start = source.index("sPokemonPalNoBySpeciesAndForm[] = {")
    return [int(v) for v in re.findall(r"^\s*(\d+),", source[start:source.index("\n};", start)], re.M)]


def icon_of(name):
    return import_icons.ICONS / f"poke_icon_{import_icons.first_added_icon() + import_species.added_species().index(name):08d}.png"


def member_of(name):
    header = import_followers.MMODEL_H.read_text()
    return int(re.search(rf"^#define MMODEL_FOLLOWER_MON_{name}\s+(\d+)", header, re.M).group(1))


class OwnArtImportTests(unittest.TestCase):
    def test_the_list_names_species_the_tree_has(self):
        self.assertIn("BRAMBLIN", own_art.SPECIES)
        self.assertEqual(set(own_art.SPECIES) - set(import_species.added_species()), set())

    def test_the_battle_pictures_are_not_copied_again(self):
        """import_sprites.py copies every added species' battle pictures but
        Paolo's."""
        copied = import_sprites.species_to_copy()
        self.assertEqual(set(own_art.SPECIES) & set(copied), set())
        self.assertEqual(len(copied), len(import_species.added_species()) - len(own_art.SPECIES))

    def test_the_icon_and_its_palette_are_the_tree_s(self):
        """import_icons.py keeps the tree's icon, and gives it the shared
        palette that icon is drawn in, which is the table's."""
        if not REFERENCE.exists():
            self.skipTest("no reference checkout")
        plan = {name: (picture, number) for name, picture, number, _theirs in import_icons.plan(REFERENCE)}
        first = import_species.added_species().index
        header = (ROOT / "include/pokemon_icon_idx.h").read_text()
        first_palette = int(re.search(r"#define FIRST_ADDED_PALETTE\s+(\d+)", header).group(1))
        for name in own_art.SPECIES:
            picture, number = plan[name]
            self.assertEqual(picture, icon_of(name), name)
            self.assertEqual(number, import_icons.drawn_in(icon_of(name), import_icons.shared_palettes()), name)
            self.assertEqual(palette_table()[first_palette + first(name)], number, name)

    def test_the_follower_is_the_tree_s(self):
        """import_followers.py keeps the texture the tree has for the species,
        at whatever member it writes it to."""
        for name in own_art.SPECIES:
            kept = (import_followers.MMODEL_DIR / f"mmodel_{member_of(name):08d}.NSBTX").read_bytes()
            self.assertEqual(import_followers.texture(name, f"data/graphics/sprites/{name.lower()}"), kept, name)


def number_of(name):
    header = (ROOT / "include/constants/species.h").read_text()
    return int(re.search(rf"^#define SPECIES_{name}\s+(\d+)", header, re.M).group(1))


def palette_entries(path):
    """How many colours a PNG's PLTE chunk holds."""
    data, at = path.read_bytes(), 8
    while at < len(data):
        length, kind = struct.unpack(">I4s", data[at:at + 8])
        if kind == b"PLTE":
            return length // 3
        at += 12 + length


def battle_pictures(name):
    """{(gender, picture): path} of the genders the species is drawn as."""
    folder = import_sprites.SPRITES / f"{number_of(name):04d}"
    return {(gender, picture): folder / gender / picture for gender in ("male", "female")
            for picture in ("front.png", "back.png") if (folder / gender / "front.png").stat().st_size}


class OwnPicturesTests(unittest.TestCase):
    """Bramblin's and Baby Lugia's pictures are Paolo's (2026-10-08,
    2026-10-07), each the size and the palette the game reads it in: a PNG
    palette of 256 entries garbled the whole battle, and a female picture
    left alone showed the placeholder."""

    def test_the_pictures_are_not_the_reference_s(self):
        """Not the reference's pictures of the species, or of the species an
        own species is like: the icon's pixels, whatever its palette."""
        if not REFERENCE.exists():
            self.skipTest("no reference checkout")
        for name in own_art.SPECIES:
            folder = f"data/graphics/sprites/{own_species.like(name).lower()}"
            for (gender, picture), path in battle_pictures(name).items():
                self.assertNotEqual(path.read_bytes(), import_followers.show(f"{folder}/male/{picture}", REFERENCE),
                                    f"{name} {gender} {picture}")
            if name not in PLACEHOLDER_ICONS:
                theirs = Image.open(io.BytesIO(import_followers.show(f"{folder}/icon.png", REFERENCE)))
                self.assertNotEqual(Image.open(icon_of(name)).tobytes(), theirs.tobytes(), name)
            kept = (import_followers.MMODEL_DIR / f"mmodel_{member_of(name):08d}.NSBTX").read_bytes()
            self.assertNotEqual(kept, import_followers.nsbtx(folder, REFERENCE), name)

    def test_the_battle_pictures_are_two_frames_in_sixteen_colours(self):
        """160x80, index 0 transparent, a 16-entry palette; every gender's
        alike; the back's palette the shiny one over the front's indices."""
        for name in own_art.SPECIES:
            pictures = battle_pictures(name)
            self.assertTrue(pictures, name)
            for (gender, picture), path in pictures.items():
                im = Image.open(path)
                self.assertEqual((im.size, im.mode, im.info.get("transparency")), ((160, 80), "P", 0), path)
                self.assertEqual(palette_entries(path), 16, path)
                self.assertLess(max(im.tobytes()), 16, path)
                self.assertEqual(im.crop((0, 0, 80, 80)).tobytes(), im.crop((80, 0, 160, 80)).tobytes(), path)
                self.assertEqual(path.read_bytes(), pictures[next(iter(pictures))[0], picture].read_bytes(), path)
            front, back = (Image.open(pictures[next(iter(pictures))[0], p]) for p in ("front.png", "back.png"))
            self.assertNotEqual(front.getpalette()[3:48], back.getpalette()[3:48], name)

    def test_the_icon_is_two_frames_in_a_shared_palette(self):
        for name in own_art.SPECIES:
            im = Image.open(icon_of(name))
            self.assertEqual((im.size, im.mode), ((32, 64), "P"), name)
            self.assertEqual(palette_entries(icon_of(name)), 16, name)
            self.assertIsNotNone(import_icons.drawn_in(icon_of(name), import_icons.shared_palettes()), name)

    def test_the_follower_is_heartgold_s_size_its_right_frames_mirrored(self):
        """Eight 32x32 frames, the first down one as tall as HeartGold's
        followers of the species' Dex height are (0.6 m: 17 rows, 1.4 m:
        22), its feet
        on row 29 and centred; the right frames the left ones mirrored; a
        normal and a shiny palette."""
        sys.path.insert(0, str(ROOT / "tools/newgold/devkit/sprites"))
        import convert_chatgpt
        dex = json.loads((ROOT / "files/application/zukanlist/zkn_data/zukan_data.json").read_text())["mon_stats"]
        for name in own_art.SPECIES:
            data = (import_followers.MMODEL_DIR / f"mmodel_{member_of(name):08d}.NSBTX").read_bytes()
            self.assertEqual(import_followers.texture_width(data), 32, name)
            frames = convert_chatgpt.texture_pixels(data)
            frame = lambda k: frames.crop((0, 32 * k, 32, 32 * k + 32))  # noqa: E731
            for left, right in ((4, 6), (5, 7)):
                self.assertEqual(ImageOps.mirror(frame(left)).tobytes(), frame(right).tobytes(), name)
            box = convert_chatgpt.drawn_box(data)
            self.assertEqual(box[3] - box[1], convert_chatgpt.follower_height(dex[number_of(name)]["height"]), name)
            self.assertEqual(box[3], 30, name)
            self.assertLessEqual(abs(box[0] + box[2] - 32), 1, name)
            # Two palettes of sixteen BGR555 colours at the end of the TEX0 block, normal and shiny.
            tex = 0x14
            palettes = data[tex + int.from_bytes(data[tex + 0x38:tex + 0x3C], "little"):]
            self.assertEqual(len(palettes), 2 * 32, name)
            self.assertNotEqual(palettes[2:32], palettes[34:64], name)

    def test_the_front_stands_where_it_is_drawn(self):
        """The reference never placed a record for Paolo's picture: its front
        stands as drawn in its frame (the Y offset its clearance, one row),
        over a shadow centred and sized by the picture (Bramblin's small,
        Baby Lugia's large)."""
        import heights
        import import_sprite_offsets as offsets
        from wotbl import read_narc
        member = read_narc(offsets.ARCHIVE.read_bytes())[0][0]
        for name in own_art.SPECIES:
            n = number_of(name)
            tail = struct.unpack_from("<bbB", member, n * offsets.RECORD + offsets.Y_OFFSET)
            clearance = heights.height_of(import_sprites.SPRITES / f"{n:04d}/male/front.png")[0]
            self.assertEqual(tail, (clearance, 0, offsets.shadow_size(offsets.front_picture(n))), name)
        self.assertEqual(struct.unpack_from("<bbB", member, number_of("BRAMBLIN") * offsets.RECORD + offsets.Y_OFFSET),
                         (1, 0, 1))
        self.assertEqual(struct.unpack_from("<bbB", member, number_of("BABY_LUGIA") * offsets.RECORD + offsets.Y_OFFSET),
                         (1, 0, 3))

    def test_a_record_the_reference_placed_does_not_move_the_picture(self):
        """The reference's record for Bramblin was never placed, and the path
        for those gives the same bytes today; one it placed for its
        placeholder (a made-up 20 rows up, 4 across, a large shadow) must not
        move Paolo's picture either."""
        if not REFERENCE.exists():
            self.skipTest("no reference checkout")
        import import_sprite_offsets as offsets
        from wotbl import read_narc
        real = offsets.reference_records

        def placed(reference):
            records = real(reference)
            for name in map(own_species.like, own_art.SPECIES):
                records[f"SPECIES_{name}"] = records[f"SPECIES_{name}"][:offsets.Y_OFFSET] + struct.pack("<bbB", 20, 4, 3)
            return records
        with mock.patch.object(offsets, "reference_records", placed):
            records = offsets.records(REFERENCE)
        member = read_narc(offsets.ARCHIVE.read_bytes())[0][0]
        for name in own_art.SPECIES:
            n = number_of(name)
            self.assertEqual(records[n], member[n * offsets.RECORD:(n + 1) * offsets.RECORD], name)


class PixelArtTests(unittest.TestCase):
    """convert_chatgpt.py --grid reads pixel art drawn several screen pixels
    a pixel back at its own pixels (Baby Lugia's are drawn 14 a pixel), and
    a normal and a shiny picture keep their colour pairs, 15 at most."""

    def setUp(self):
        sys.path.insert(0, str(ROOT / "tools/newgold/devkit/sprites"))
        import convert_chatgpt
        self.convert = convert_chatgpt

    def test_pixel_art_comes_back_at_its_own_pixels(self):
        """A picture drawn three pixels a pixel, its cells starting one pixel
        across and two down, a stray pixel at the edge of some: each cell is
        one pixel again, in its own colour in 15 bits, index 0 magenta."""
        colours = [(255, 0, 255), (255, 255, 255), (24, 32, 55), (161, 172, 192), (255, 123, 156)]
        small = Image.new("P", (7, 5))
        small.putpalette([v for c in colours for v in c])
        small.putdata([(x * y + x + 2 * y) % 5 for y in range(5) for x in range(7)])
        big = Image.new("P", (23, 18))
        big.putpalette(small.getpalette())
        big.paste(small.resize((21, 15), Image.NEAREST), (1, 2))
        for x, y in ((3, 2), (7, 10), (12, 8)):
            big.putpixel((x, y), (big.getpixel((x, y)) + 1) % 5)
        picture = io.BytesIO()
        big.save(picture, "PNG")
        read = self.convert.load(picture, 3)
        for y in range(5):
            for x in range(7):
                i = small.getpixel((x, y))
                self.assertEqual(read.getpixel((x, y)), (255, 0, 255) if i == 0 else tuple(v & 0xF8 for v in colours[i]))

    def test_past_fifteen_pairs_the_cheapest_merge_into_their_nearest(self):
        """Fifteen pairs far apart, a hundred pixels each, and two of one
        pixel each 8 away from one of them: those two merge, into it."""
        normal, shiny = {}, {}
        pairs = [((16 * i, 0, 0), (0, 16 * i, 0)) for i in range(15)]
        for i, (a, b) in enumerate(pairs):
            for k in range(100):
                normal[i, k], shiny[i, k] = a, b
        normal[20, 0], shiny[20, 0] = (56, 0, 0), (0, 48, 0)
        normal[21, 0], shiny[21, 0] = (160, 0, 8), (0, 160, 0)
        (indices,), normals, shinies, merges = self.convert.paired([normal], [shiny])
        self.assertEqual(sorted(merges), [(((56, 0, 0), (0, 48, 0)), pairs[3], 1),
                                          (((160, 0, 8), (0, 160, 0)), pairs[10], 1)])
        self.assertEqual((len(normals), len(shinies)), (15, 15))
        self.assertEqual(indices[20, 0], indices[3, 0])
        self.assertEqual(indices[21, 0], indices[10, 0])
        self.assertEqual(sorted(zip(normals, shinies)), sorted(pairs))


if __name__ == "__main__":
    unittest.main()
