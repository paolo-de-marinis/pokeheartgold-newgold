# Pictures for the game: prompts and rules

How a new picture gets into New Gold, as Paolo and Claude did it for
Bramblin (2026-10-07): Paolo has the picture drawn by ChatGPT (his own
subscription, by hand: no pay-per-use API, decided 2026-09-24), Claude converts
it to the DS's formats, puts it in a test build and shows it in the game
through the harness, and Paolo judges it, on his phone if he likes. The devkit's
sprite and item editors will host the same flow: drop the pictures in, the
conversion and the in-game preview follow (DEVKIT-PLAN.md, section 4).

**Bramblin is in the game** (2026-10-08): its battle front and back, their
shiny colours, the party icon and the follower are Paolo's, where the
reference had Bulbasaur's battle pictures. A species whose pictures are
Paolo's is listed in `tools/newgold/import/own_art.py`, which every importer
that writes those files reads, so a re-import keeps his pictures instead of
the reference's; the next species is one line there, then one run of the
converter.

**Baby Lugia is a species** (2026-10-07), the first one New Gold has that
the reference has not: species 1438, No. 1026, Lugia's data for now with a
size, a name and a cry of its own (below, "A species the reference has not
got"). Its battle pictures and follower are Paolo's (2026-10-07), the battle
ones at his own pixels, and it is in `own_art.py` as Bramblin is; its party
icon is his drawing redrawn by hand at 32x32 (2026-10-08, below), until he
draws one at that size.

The prompts are in English, which ChatGPT follows best. Replace `<NAME>` with
the Pokemon's or the item's English name.

## Rules every prompt keeps

- **Pixel art**, hard edges, no anti-aliasing, no blur.
- **A flat pure magenta (#FF00FF) background**, and no magenta on the subject:
  the conversion makes magenta transparent. Black is no good -- outlines are
  dark.
- **Few colours**: the DS gives a picture 16, one of them transparent.
- **The exact size, or an exact multiple** (each pixel a clean block); the
  conversion copes with less, but scaling a painted picture down blurs it.
- **The shiny colours each part with the index the normal colours it with.**
  The DS keeps one picture for both and two palettes of 15 colours over the
  same indices, so a part the normal draws in one colour and the shiny in two
  (or the other way round) is one more pair; past 15 pairs two of them become
  one, and the normal or the shiny loses a shade there. Baby Lugia's drawings
  have 21 pairs: 6 merged, 72 of its pixels a neighbouring shade.

## Battle pictures: front and back

```text
Pixel art sprite of the Pokémon <NAME>, in the exact style of Nintendo DS Pokémon games (Pokémon HeartGold/SoulSilver and Black/White battle sprites).

Make TWO separate images, same size and same colour palette:
1. FRONT sprite: <NAME> seen from the front, three-quarter view, facing toward the LEFT side of the image, as an opponent Pokémon appears in battle.
2. BACK sprite: <NAME> seen from behind, three-quarter back view, as the player's own Pokémon appears in battle.

Rules for both images:
- Canvas exactly 80x80 pixels (or exactly 320x320 if you must go bigger, with every pixel drawn as a clean 4x4 block, no in-between pixels).
- True pixel art: hard edges, no anti-aliasing, no blur, no gradients, no shading softer than pixel dithering.
- At most 15 colours in total, the SAME 15 colours in both images, including a dark 1-pixel outline around the Pokémon.
- Plain flat background in pure magenta (#FF00FF) everywhere outside the Pokémon; do not use magenta anywhere on the Pokémon.
- The Pokémon centred horizontally, its lowest point touching about the bottom 10 pixels of the canvas, filling most of the canvas without touching the edges.
- Faithful to <NAME>'s official design (colours, shape, face).
```

**The shiny colours**, added to the same request:

```text
Also make the SAME front and back images again, pixel for pixel identical in shape, using <NAME>'s official SHINY colours.
```

## Party icon

```text
Pixel art party-menu icon of the Pokémon <NAME>, in the exact style of the Nintendo DS Pokémon HeartGold/SoulSilver party icons.
Two frames side by side, each exactly 32x32 pixels (or each 128x128 with every pixel a clean 4x4 block): frame 1 the idle pose, frame 2 the same pose bounced up by 1-2 pixels or with a small change (as the menu animates it).
Small, chunky, cute proportions, dark 1-pixel outline, at most 12 colours, no anti-aliasing, flat pure magenta (#FF00FF) background, the Pokémon facing the viewer slightly to the left, feet near the bottom of each frame. Faithful to <NAME>'s official design.
```

The game has no shiny icons: one picture serves both. **The frame is 32x32,
and the Pokemon at most 32 wide and 24 tall in it**, as every retail icon is,
in the colours of one of the three palettes all icons share
(`poke_icon_00000000.pal`): a bigger drawing can only be shrunk, and shrunk it
is no longer pixel art. Baby Lugia's was drawn in 50x50 frames, its body
about 40 tall: it was redrawn pixel by pixel at 0.6 of its size from what of
his pixels each new one covers, outline, eye and marks kept, its two frames'
head the same drawing (`.rounds/round18/babylugia/art`,
`icon_32x32_claude_from_paolo.png` and its grid), and went in through the
converter with `--grid 1`.

## Following Pokemon (overworld)

```text
Pixel art overworld walking sprite sheet of the Pokémon <NAME>, in the exact style of the Pokémon HeartGold/SoulSilver walking Pokémon that follow the player.
A grid of 6 frames, each exactly 32x32 pixels (or 128x128 with clean 4x4 pixel blocks): row 1 facing DOWN (toward the viewer) step A and step B, row 2 facing UP (back to the viewer) step A and step B, row 3 facing LEFT, seen exactly from the side, step A and step B.
Top-down three-quarter view as in the DS overworld, dark 1-pixel outline, at most 15 colours shared by all frames, no anti-aliasing, flat pure magenta (#FF00FF) background, the body centred in each frame with its feet on the bottom rows. Faithful to <NAME>'s official design.
```

And the same sheet again in the official shiny colours, shape for shape.

A sheet goes through the converter (`--rows`), which makes the texture's
16-colour indexed picture and scales the down frame by HeartGold's size rule:
Baby Lugia's round-17 `build_sheets.py` wrote RGBA strips of about 1,170
colours, its down frame 21 rows, which neither the texture tool nor the size
rule takes; its sheets went through the converter with `--paired`, its
shiny sheet colouring the parts its own way.

No right-facing row: HeartGold draws a follower's right-facing frames as the exact mirror of
its left-facing ones (checked on Pikachu's), so the conversion mirrors row 3. ChatGPT's own
right-facing rows came out turned wrong (Lugia, 2026-10-08), and a mirror is always right.

## Item icon

```text
Pixel art bag icons for the Pokémon items <NAME 1>, <NAME 2>, ... in the exact style of the Nintendo DS Pokémon HeartGold/SoulSilver bag item icons.
One image with the icons in a single row, in that order, each icon on its own 32x32 pixel square (or 128x128 with every pixel a clean 4x4 block), the item drawn about 24x24 pixels in the middle of its square.
Each icon: dark 1-pixel outline, at most 15 colours, simple shading as the DS icons have, no anti-aliasing, flat pure magenta (#FF00FF) background, nothing touching the square's edges. Faithful to each item's official artwork from the Pokémon games.
```

The first use, Paolo, 2026-10-08: the seven Mochi of Scarlet/Violet (Health,
Muscle, Resist, Genius, Clever, Swift and Fresh-Start Mochi), which the
reference has no icons for (they showed the "?" icon in the EV/IV trainer's
shop and in the bag). How they came out: usable as drawn, one try, no
retouching. ChatGPT ignored the 32-pixel squares -- one 2000x667 picture, its
pixels about 6 screen pixels, each disc 252x193 with a 2-3 pixel blend of
outline and magenta round it -- so `tools/newgold/devkit/sprites/convert_item_icons.py`
cuts the icons apart by their columns, erodes the blend (it tinted the
outlines purple), scales each to 22x17 by area average and gives it 15 colours
of its own. In the game: the shop and the bag's Items pocket
(`tests/newgold/scenarios/mochi_icons.json`).

## What the conversion does, and the traps found

- **Transparent background:** magenta out, and the letters' holes with it.
- **Scaling:** the picture is reduced by area average from the subject's own
  pixels, so its edges take no magenta. Pixel art drawn N screen pixels a
  pixel is read back at its own pixels instead (`--grid N`), each cell the
  colour most of it has, and placed as drawn: Baby Lugia's battle pictures.
- **Colours:** 15 at most, chosen together for all the frames that share a
  palette, in 15-bit colour; index 0 is the transparent one. With `--grid`
  (the battle pictures) or `--paired` (the follower) each pixel's normal and
  shiny colour pair is an index, past 15 the cheapest merged into their
  nearest; otherwise the shiny pictures vote each index's colour.
- **The PNG's palette must have exactly 16 entries.** A 256-entry palette made
  the battle load 256 colours over every other sprite's: the whole battle was
  garbled (found with Bramblin).
- **Battle:** `files/poketool/pokegra/pokegra/<species>/{male,female}/`
  `front.png` and `back.png`, 160x80 (two 80x80 frames); the front's palette is
  the normal one, the **back's PNG carries the shiny palette** (the same
  indices); the female pictures are separate files and must be replaced too
  (a female Bramblin first showed the old placeholder). `heights.py write`
  follows the pictures, and `import_sprite_offsets.py` stands the front as it
  is drawn in its frame, over a shadow its size. The size of a new species'
  battle picture follows the community sprites of the same Pokemon (Bramblin
  42 wide), or, pixel art, its own pixels (Baby Lugia 75x62, as tall as the
  median of retail's fronts of 1.3 to 1.5 m).
- **Party icon:** `poke_icon_<n>.png`, 32x64, in one of the three palettes all
  icons share (`poke_icon_00000000.pal`); the species' palette number is in
  `sPokemonPalNoBySpeciesAndForm` (src/pokemon_icon_idx.c): the conversion
  picks the palette closest to the picture's colours and sets the number.
- **Following Pokemon:** `overworld.png` 32x256, eight 32x32 frames in the
  game's order **up, up, down, down, left, left, right, right** (right = left mirrored), two 16-colour
  palettes (normal, shiny), built into the species' mmodel texture
  (`import_followers.nsbtx`). **Size, HeartGold's rule measured on its own
  followers:** the drawn height is the median of retail's 32x32 followers whose
  Dex height is within 1 dm of the species' (0.6 m gives 17 pixels), measured
  on the first down frame, and the down frame is scaled to it, the feet
  on row 29, centred at x 16, one scale for all eight frames so it does not
  change size while walking; the largest Pokemon use 64x64 frames.
- **Item icon:** 32x32, 4bpp, its own 16-colour palette, as the items
  `item_data.mk` builds from PNGs, the item **in the top-left 24x24**, centred
  on (12, 12): every HeartGold item icon is drawn there, and one centred on
  the 32x32 square would sit 4 pixels off in the bag. An item whose reference
  art is the blank goes in `OWN_ICONS` (`import_items.py`), so a re-import
  keeps it.
- **Checked in the game,** not on the PNG: the field, the party menu and a
  battle, normal and shiny (the harness: `scene.py` with
  `gDiagForceBattleSpecies` on a route, the species both as the foe and as the
  player's Pokemon -- the 256-colour trap showed only with the back loaded).
  `front1.lift` finds the foe's front on the screen in its PNG's colours, a
  shiny one in its back's: Bramblin's scenarios are `bramblin_pictures.json`
  and `bramblin_pictures_shiny.json`, Baby Lugia's `baby_lugia_pictures.json`
  and `baby_lugia_pictures_shiny.json`.

The converter is `tools/newgold/devkit/sprites/convert_chatgpt.py`: it takes
the species, each picture and the follower sheet's rows (`--rows`, top to
bottom; a right row is not used), writes into the tree and runs what follows
the pictures; its docstring has Bramblin's command and Baby Lugia's. It refuses a species not
in `own_art.py`. The sprite editor will host it.

## A species the reference has not got

A species New Gold adds beyond konefr's reference is one entry in
`tools/newgold/import/own_species.py`: the species it is like, whose data it
takes until its own is written; its name, ten characters at most, as the
names bank has them ("Baby Lugia"); its National Dex number; its height and
weight in decimetres and hectograms and as the Dex prints them; the Dex's
size page's scales, the trainer's as retail's species of that height have
them and the Pokemon's 256, its front pixel for pixel, when that is about as
tall as theirs are drawn (`import_dex_metrics.py` then stands the front on
retail's line from the picture, and a test checks it); and how many
semitones its cry is raised over its like's. The
file's docstring has the rules every importer follows for it. Then the
importers, from `tools/newgold/import` with the reference's checkout as REF,
in the order Baby Lugia's commit ran them:

```text
import_species.py REF --write             # appended after the reference's last
import_hidden_abilities.py REF --write
wotbl.py extend REF --write               # the like's learnset as the tree has it
import_egg_moves.py REF --write
import_tutor_moves.py REF --write
import_baby_species.py REF --write        # it hatches as itself
import_trainer_seed.py --write
import_species_text.py --write
import_dex_text.py --write
import_dex_metrics.py REF --write
../devkit/dex_areas.py
git show 4c8176ea1^:files/data/sound/gs_sound_data.sdat > ../../../files/data/sound/gs_sound_data.sdat
import_cries.py REF --write               # the like's samples, played higher
import_footprints.py REF --write          # the like's footprint
import_sprites.py REF --write             # the like's pictures
heights.py write
import_sprite_offsets.py --write
import_icons.py REF --write
import_followers.py --write               # it walks as its like
```

Paolo's pictures for it then go in as Bramblin's did, in this order: its
line in `own_art.py`; `import_followers.py --write` again, which now gives
it a model of its own (Baby Lugia: model 1307, member 1604, sprite 1791),
and without which the converter refuses its follower ("has no follower
model of its own"); then the converter, Baby Lugia's command in its
docstring (`--grid 14 ... --paired`), and the icon with `--icon ... --grid 1`;
then `import_dex_metrics.py REF --write` again, which stands the new front on
the SIZE page's line (a test fails until it has).

A re-run of any of them keeps it, and none moves it. What is not generated
is its Dex page: `src/pokedex.c` names it in SpeciesToDexSpecies (it is no
form), DexSpeciesIsInvalid (it has a page), SpeciesToNationalDexNo (its
number) and DexFlagNo, which keeps its flags at the place after Pecharunt's,
in room HeartGold's save has (SAVE-LAYOUT.md). One more own species fits
there, at 1043, with a line in each of the four; a third needs a save
layout. savedit's `dex_place` follows DexFlagNo. Not obtainable in the game
until a wild table, a trainer or a gift names it: `savedit.py --party
BABY_LUGIA:12` and the diagnostics build's `gDiagForceBattleSpecies` (1438)
reach it. Its scenarios are `cry_baby_lugia.json`, its cry in battle, and
`dex_baby_lugia.json`, its Dex page, AREA and SIZE.
